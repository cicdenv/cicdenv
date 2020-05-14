from os import path, getcwd

from . import (env, new_cluster_script, stop_cluster_script, 
    cluster_dir, kubeconfig, cluster_fqdn, state_store,
	cluster_targets, CONFIG, CLUSTER, ACCESS)
from ...aws import config_profile

from ...terraform.driver import TerraformDriver


class AuthenticatorDriver(object):
    def __init__(self, settings, cluster):
        self.settings = settings
        self.cluster = cluster
        self.name = cluster.name
        self.workspace = cluster.workspace
        self.cluster_fqdn = cluster_fqdn(self.name, self.workspace)

        self.environment = env(self.workspace)

        self.runner = self.settings.runner(cwd=getcwd(), env=self.environment)

    def token(self):
        self.environment['KUBECONFIG'] = kubeconfig(self.name, self.workspace, 'user')

        self.runner.run(['aws-iam-authenticator', 'token', '-i', self.cluster_fqdn])


class KopsDriver(object):
    def __init__(self, settings, cluster, admin):
        self.settings = settings
        self.cluster = cluster
        self.name = cluster.name
        self.workspace = cluster.workspace
        self.perms = 'admin' if admin else 'user'
        self.cluster_fqdn = cluster_fqdn(self.name, self.workspace)
        self.bucket = state_store()

        self.environment = env(self.workspace)

        self.runner = self.settings.runner(cwd=getcwd(), env=self.environment)

    def run(self, flags):
        self.environment['KUBECONFIG'] = kubeconfig(self.name, self.workspace, self.perms)

        self.runner.run(['kops'] + list(flags) + [f'--name={self.cluster_fqdn}', f'--state=s3://{self.bucket}'])


class KubectlDriver(object):
    def __init__(self, settings, cluster, admin):
        self.settings = settings
        self.cluster = cluster
        self.name = cluster.name
        self.workspace = cluster.workspace
        self.perms = 'admin' if admin else 'user'

        self.environment = env(self.workspace)

        self.runner = self.settings.runner(cwd=getcwd(), env=self.environment)

    def run(self, flags):
        self.environment['KUBECONFIG'] = kubeconfig(self.name, self.workspace, self.perms)

        self.runner.run(['kubectl'] + list(flags))


class ClusterDriver(object):
    def __init__(self, settings, cluster, flags=[]):
        self.settings = settings
        self.cluster = cluster
        self.name = cluster.name
        self.workspace = cluster.workspace

        self.tf_flags = [flag for flag in flags if flag.startswith('-')]
        self.tf_vars = [flag for flag in flags if not flag.startswith('-')]
        
        self.targets = cluster_targets(self.name, self.workspace)

        self.environment = env(self.workspace)

        self.runner = self.settings.runner(cwd=getcwd(), env=self.environment)

    def _cluster_prep(self):
        cluster_folder = cluster_dir(self.name)
        if not path.isdir(cluster_folder):
            self.runner.run([new_cluster_script, self.name] + self.tf_vars)
        self._terraform('apply', CONFIG, ['-auto-approve'])

    def _terraform(self, op, idx, flags=[]):
        target = self.targets[idx]
        driver_method = getattr(TerraformDriver(self.settings, target, flags), op)
        driver_method()

    def init(self):
        self._cluster_prep()

    def create(self):
        self._cluster_prep()
        self._terraform('apply', CLUSTER, self.tf_flags)
        self._terraform('apply', ACCESS,  self.tf_flags)

    def destroy(self):
        self._terraform('destroy', ACCESS,  self.tf_flags)
        self._terraform('destroy', CLUSTER, self.tf_flags)
        self._terraform('destroy', CONFIG,  self.tf_flags)

    def validate(self):
        admin_kubeconfig = kubeconfig(self.name, self.workspace, 'admin')
        KopsDriver(self.settings, self.cluster, path.isfile(admin_kubeconfig)).run(['validate', 'cluster'])

    def start(self):
        # cluster must exist
        self._terraform('apply', CLUSTER, ['-auto-approve'])

    def stop(self):
        # cluster must exist
        self.runner.run([stop_cluster_script, self.cluster])

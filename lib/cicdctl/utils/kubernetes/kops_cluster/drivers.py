from os import path, getcwd

from . import (env, new_cluster_script, stop_cluster_script, download_ca_script,
    cluster_dir, pki_dir, kubeconfig, cluster_fqdn, state_store,
	cluster_targets, ROUTING, CONFIG, CLUSTER, ACCESS)
from ...aws import config_profile

from ...terraform.routing import routing_target
from ...terraform.driver import TerraformDriver


class AuthenticatorDriver(object):
    def __init__(self, settings, cluster):
        self.cluster = cluster
        self.name = cluster.name
        self.workspace = cluster.workspace
        self.cluster_fqdn = cluster_fqdn(self.name, self.workspace)

        self.env_ctx = env(self.workspace)

        self._run = settings.runner(cwd=getcwd(), env_ctx=self.env_ctx).run

    def token(self):
        self.env_ctx.env['KUBECONFIG'] = kubeconfig(self.name, self.workspace, 'user')
        self.env_ctx.keys.append('KUBECONFIG')

        self._run(['aws-iam-authenticator', 'token', '-i', self.cluster_fqdn])


class KopsDriver(object):
    def __init__(self, settings, cluster, admin):
        self.cluster = cluster
        self.name = cluster.name
        self.workspace = cluster.workspace
        self.perms = 'admin' if admin else 'user'
        self.cluster_fqdn = cluster_fqdn(self.name, self.workspace)
        self.bucket = state_store()

        self.env_ctx = env(self.workspace)

        self._run = settings.runner(cwd=getcwd(), env_ctx=self.env_ctx).run

    def run(self, flags):
        self.env_ctx.env['KUBECONFIG'] = kubeconfig(self.name, self.workspace, self.perms)
        self.env_ctx.keys.append('KUBECONFIG')

        self._run(['kops'] + list(flags) + [f'--name={self.cluster_fqdn}', f'--state=s3://{self.bucket}'])


class KubectlDriver(object):
    def __init__(self, settings, cluster, admin):
        self.cluster = cluster
        self.name = cluster.name
        self.workspace = cluster.workspace
        self.perms = 'admin' if admin else 'user'

        self.env_ctx = env(self.workspace)

        self._run = settings.runner(cwd=getcwd(), env_ctx=self.env_ctx).run

    def run(self, flags):
        self.env_ctx.env['KUBECONFIG'] = kubeconfig(self.name, self.workspace, self.perms)
        self.env_ctx.keys.append('KUBECONFIG')

        self._run(['kubectl'] + list(flags))


class ClusterDriver(object):
    def __init__(self, settings, cluster, flags=[]):
        self.settings = settings
        self.cluster = cluster
        self.name = cluster.name
        self.workspace = cluster.workspace

        self.tf_flags = [flag for flag in flags if flag.startswith('-')]
        self.tf_vars = [flag for flag in flags if not flag.startswith('-')]
        
        self.targets = cluster_targets(self.name, self.workspace)

        self.env_ctx = env(self.workspace)

        self._run = self.settings.runner(cwd=getcwd(), env_ctx=self.env_ctx).run

    def _cluster_prep(self):
        # Generate cluster root module (component)
        cluster_folder = cluster_dir(self.name)
        if not path.isdir(cluster_folder):
            self._run([new_cluster_script, self.name] + self.tf_vars)

        # Download the kubernetes Certificate Authority for the target account
        pki_folder = pki_dir(self.workspace)
        if (
           not path.exists(path.join(cluster_folder, 'ca-key.pem')) or
           not path.exists(path.join(cluster_folder, 'ca.pem'))
        ):
            self._run([download_ca_script, self.workspace])

        # Ensure account NAT Gateways are up
        if not self._has_resources(ROUTING):
            self._terraform('apply', ROUTING, self.tf_flags)

        # Run KOPS manifest, update -> terraform output
        self._terraform('apply', CONFIG, ['-auto-approve'])

    def _terraform(self, op, idx, flags=[]):
        target = self.targets[idx]
        driver_method = getattr(TerraformDriver(self.settings, target, flags), op)
        driver_method()

    def _has_resources(self, idx):
        target = self.targets[idx]
        return TerraformDriver(self.settings, target).has_resources()

    def init(self):
        self._cluster_prep()

    def create(self):
        self._cluster_prep()
        self._terraform('apply', CLUSTER, self.tf_flags)
        self._terraform('apply', ACCESS,  self.tf_flags)

    def destroy(self):
        if self._has_resources(CLUSTER) and self._has_resources(ACCESS):
            self._terraform('destroy', ACCESS,  self.tf_flags)
        if self._has_resources(CLUSTER):
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
        self._run([stop_cluster_script, str(self.cluster)])

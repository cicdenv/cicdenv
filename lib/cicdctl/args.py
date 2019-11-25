from sys import argv
import argparse

from cicdctl.commands.terraform     import run_terraform
from cicdctl.commands.packer        import run_packer
from cicdctl.commands.cluster       import run_cluster
from cicdctl.commands.bastion       import run_bastion
from cicdctl.commands.credentials   import run_creds
from cicdctl.commands.kubectl       import run_kubectl
from cicdctl.commands.authenticator import run_authenticator
from cicdctl.commands.kops          import run_kops
from cicdctl.commands.console       import run_console
from cicdctl.commands.whitelist     import run_whitelist
from cicdctl.commands.test          import run_test
from cicdctl.commands.new           import run_new


def __add_terraform(subparsers):
    _targets = argparse.ArgumentParser(add_help=False)  # <state/path>:<worksapce>
    _targets.add_argument("target", help="target state in the form: <path>:<workspace>.")

    _passthru = argparse.ArgumentParser(add_help=False)
    _passthru.add_argument("overrides", nargs=argparse.REMAINDER, help="extra arguments for terraform.")

    _terraform = [_targets, _passthru]
    _terraform_cmds = [
        "init",
        "workspace",
        "plan",
        "apply",
        "destroy",
        "refresh",
        "import",
        "output",
        "unlock",
    ]
    for _terraform_cmd in _terraform_cmds:
        subparsers.add_parser(_terraform_cmd, parents=_terraform, help=f"terraform {_terraform_cmd}.") \
                  .set_defaults(func=run_terraform)


def __add_packer(subparsers):
    _packer_cmds = [
        "build",
        "validate",
        "version",
    ]

    packer_parser = subparsers.add_parser("packer", help=" | ".join(_packer_cmds))
    packer_subparsers = packer_parser.add_subparsers(title="packer sub-commands", dest="packer_command")
    packer_subparsers.required = True

    _passthru = argparse.ArgumentParser(add_help=False)
    _passthru.add_argument("overrides", nargs=argparse.REMAINDER, help="extra arguments for packer.")

    _packer = [_passthru]
    for _packer_cmd in _packer_cmds:
        packer_subparsers.add_parser(_packer_cmd, parents=_packer, help=f"packer {_packer_cmd}.") \
                  .set_defaults(func=run_packer)


def __add_cluster(subparsers):
    _target = argparse.ArgumentParser(add_help=False)  # <cluster>:<worksapce>, supports multiple values
    _target.add_argument("target", nargs='+', help="target kops cluster in the form: <cluster>:<workspace>.")

    _passthru = argparse.ArgumentParser(add_help=False)
    _passthru.add_argument("overrides", nargs=argparse.REMAINDER, help="extra arguments for terraform.")

    _cluster = [_target, _passthru]
    _cluster_cmds = [
        "init-cluster",
        "apply-cluster",
        "destroy-cluster",
        "validate-cluster",
        "start-cluster",
        "stop-cluster",
    ]
    for _cluster_cmd in _cluster_cmds:
        subparsers.add_parser(_cluster_cmd, parents=_cluster, help=f"kubernetes {_cluster_cmd}.") \
                  .set_defaults(func=run_cluster)


def __add_bastion(subparsers):
    _bastion_cmds = [
        "ssh",
        "host",
        "tunnel",
        "scp"
    ]

    bastion_parser = subparsers.add_parser("bastion", help=" | ".join(_bastion_cmds))
    bastion_subparsers = bastion_parser.add_subparsers(title="bastion sub-commands", dest="bastion_command")
    bastion_subparsers.required = True

    _workspace = argparse.ArgumentParser(add_help=False)  # <cluster>:<worksapce>, supports multiple values
    _workspace.add_argument("workspace", help="workspace name (account).")

    _passthru = argparse.ArgumentParser(add_help=False)
    _passthru.add_argument("overrides", nargs=argparse.REMAINDER, help="extra arguments for ssh.")

    _bastion = [_workspace, _passthru]
    for _bastion_cmd in _bastion_cmds:
        bastion_subparsers.add_parser(_bastion_cmd, parents=_bastion, help=f"bastion {_bastion_cmd}.") \
                  .set_defaults(func=run_bastion)


def __add_credentials(subparsers):
    _creds_cmds = [
        "aws-mfa",
        "mfa-code",
        "switch-role-url",
    ]

    creds_parser = subparsers.add_parser("creds", help=" | ".join(_creds_cmds))
    creds_subparsers = creds_parser.add_subparsers(title="credentials sub-commands", dest="creds_command")
    creds_subparsers.required = True

    _workspace = argparse.ArgumentParser(add_help=False)  # <worksapce>, supports multiple values
    _workspace.add_argument("workspace", nargs='+', help="workspace name (account).")

    _passthru = argparse.ArgumentParser(add_help=False)
    _passthru.add_argument("overrides", nargs=argparse.REMAINDER, help="extra arguments for ssh.")

    _creds = {
        "aws-mfa": [_workspace, _passthru],
        "mfa-code": [],
        "switch-role-url": [_workspace],
    }
    for _creds_cmd in _creds_cmds:
        creds_subparsers.add_parser(_creds_cmd, parents=_creds[_creds_cmd], help=f"creds {_creds_cmd}.") \
                  .set_defaults(func=run_creds)


def __add_kubectl(subparsers):
    _target = argparse.ArgumentParser(add_help=False)  # <cluster>:<worksapce>, supports multiple values
    _target.add_argument("target", help="target kops cluster in the form: <cluster>:<workspace>.")

    _passthru = argparse.ArgumentParser(add_help=False)
    _passthru.add_argument('--admin', help="use cluster admin creds.", action='store_true')
    _passthru.add_argument("arguments", nargs=argparse.REMAINDER, help="extra arguments for kubectl.")

    _kubectl = [_target, _passthru]
    subparsers.add_parser("kubectl", parents=_kubectl, help=f"kubernetes client.") \
              .set_defaults(func=run_kubectl)


def __add_authenticator(subparsers):
    _target = argparse.ArgumentParser(add_help=False)  # <cluster>:<worksapce>, supports multiple values
    _target.add_argument("target", help="target kops cluster in the form: <cluster>:<workspace>.")

    _authenticator = [_target]
    subparsers.add_parser("authenticator", parents=_authenticator, help=f"aws-iam-authenticator client.") \
              .set_defaults(func=run_authenticator)


def __add_kops(subparsers):
    _target = argparse.ArgumentParser(add_help=False)  # <cluster>:<worksapce>, supports multiple values
    _target.add_argument("target", help="target kops cluster in the form: <cluster>:<workspace>.")

    _passthru = argparse.ArgumentParser(add_help=False)
    _passthru.add_argument('--admin', help="use cluster admin creds.", action='store_true')
    _passthru.add_argument("arguments", nargs=argparse.REMAINDER, help="extra arguments for kops.")

    _kops = [_target, _passthru]
    subparsers.add_parser("kops", parents=_kops, help=f"kops tool.") \
              .set_defaults(func=run_kops)


def __add_console(subparsers):
    subparsers.add_parser("console", help=f"bash prompt.") \
              .set_defaults(func=run_console)


def __add_whitelist(subparsers):
    _cidr = argparse.ArgumentParser(add_help=False)  # <cluster>:<worksapce>, supports multiple values
    _cidr.add_argument("cidr", help="network cidr, ip address, or 'my-ip'.")

    _whitelist = [_cidr]
    subparsers.add_parser("whitelist", parents=_whitelist, help=f"updates ./terraform/whitelisted-networks.tfvars.") \
              .set_defaults(func=run_whitelist)


def __add_test(subparsers):
    _passthru = argparse.ArgumentParser(add_help=False)
    _passthru.add_argument("arguments", nargs=argparse.REMAINDER, help="extra arguments for the test runner.")

    _test = [_passthru]
    subparsers.add_parser("test", parents=_test, help=f"run tests.") \
              .set_defaults(func=run_test)


def __add_new(subparsers):
    _new_cmds = [
        "main-state",
        "workspaced-state",
    ]
    new_parser = subparsers.add_parser("new", help=" | ".join(_new_cmds))
    new_subparsers = new_parser.add_subparsers(title="new sub-commands", dest="new_command")
    new_subparsers.required = True

    _state = argparse.ArgumentParser(add_help=False)  # <state>, supports multiple values
    _state.add_argument("state", nargs='+', help="state path (under terraform/ folder).")

    _passthru = argparse.ArgumentParser(add_help=False)
    _passthru.add_argument("arguments", nargs=argparse.REMAINDER, help="extra arguments for bin/new-* scripts.")

    _new = [_state, _passthru]
    for _new_cmd in _new_cmds:
        new_subparsers.add_parser(_new_cmd, parents=_new, help=f"new {_new_cmd}.") \
                  .set_defaults(func=run_new)


def parse_command_line():
    main_parser = argparse.ArgumentParser(
        prog='cicdctl', 
        description='CI/CD CLI: Terraformed AWS Multi-Account Kubernetes Infrastructure Tool.', 
        epilog='https://github.com/vogtech/cicdenv')

    subparsers = main_parser.add_subparsers(title="tool sub-commands", dest="command")
    subparsers.required = True

    __add_terraform(subparsers)
    __add_packer(subparsers)
    __add_cluster(subparsers)
    __add_bastion(subparsers)
    __add_credentials(subparsers)
    __add_kubectl(subparsers)
    __add_authenticator(subparsers)
    __add_kops(subparsers)
    __add_console(subparsers)
    __add_whitelist(subparsers)
    __add_test(subparsers)
    __add_new(subparsers)

    if len(argv[1:]) == 0:
        main_parser.print_help()
        main_parser.exit()

    return main_parser.parse_args()

from sys import exit, stdout, stderr
from os import path, getcwd, environ
import subprocess

from argparse import ArgumentTypeError
from types import SimpleNamespace

from cicdctl.logs import log_cmd_line
from aws.credentials import StsAssumeRoleCredentials
from terraform.files import backend_config, varfile_dir, parse_terraform_tf, parse_tfvars, parse_variable_comments_tf
from terraform.dependencies import get_cascades

_init_command = ['init', '-upgrade', f'-backend-config={backend_config}']  # needs terraform[-<version>] prepended


def _state_prep(state_dir, workspace, environment, workspaced, terraform):
    # Odd, but you init, then workspace (first time only)
    # otherwise you workspace then init
    terrform_state = path.join(state_dir, '.terraform', 'terraform.tfstate')
    first_time = not path.exists(terrform_state)

    # Never init'd states must be init'd first before setting the workspace
    if first_time:
        _run([terraform] + _init_command, state_dir, environment)

    # If applicable: create workspace where neded before selecting it
    if workspaced:
        try:
            log_cmd_line([terraform, 'workspace', 'list'], cwd=state_dir)
            workspaces = subprocess.check_output([terraform, 'workspace', 'list'], env=environment, cwd=state_dir).decode("utf-8").strip().splitlines()
            workspaces = [w.strip() for w in workspaces]  # Strip whitespace
            if not f'* {workspace}' in workspaces:
                if not workspace in workspaces:
                    log_cmd_line([terraform, 'workspace', 'new', workspace], cwd=state_dir)
                    subprocess.run([terraform, 'workspace', 'new', workspace], env=environment, cwd=state_dir, stdout=stdout, stderr=stderr, check=True)
                else:
                    log_cmd_line([terraform, 'workspace', 'select', workspace], cwd=state_dir)
                    subprocess.run([terraform, 'workspace', 'select', workspace], env=environment, cwd=state_dir, stdout=stdout, stderr=stderr, check=True)
        except subprocess.CalledProcessError as cpe:
            exit(cpe.returncode)
    
    # Safe to init here for non-first time workspaced states
    if not first_time:
        _run([terraform] + _init_command, state_dir, environment)


def _unpack_args(args):
    """
    Only 1 target is officially supported, we 'pull' extra targets from overrides if need be.
    
    This is hacky but argparse doesn't support multiple sets of unbounded tokens.
    Use '--' to force remaing command line tokens to be passed to terraform.
    """
    
    targets = args.target if isinstance(args.target, list) else [args.target]
    overrides = []
    for i, override in enumerate(args.overrides):
        if ':' in override:
            targets.append(override)
        else:
            if override == '--':
                overrides = args.overrides[i + 1:]
            else:
                overrides = args.overrides[i:]
            break  # Quit 'pulling' overrides to targets
    return (targets, overrides)


def run_terraform(args):
    # Refresh main account AWS mfa credentials if needed
    StsAssumeRoleCredentials().refresh_profile(f'admin-main')

    targets, overrides = _unpack_args(args)
    for target in targets:
        parts = target.split(':')
        state = parts[0]

        # Assume the state's path is under the top-level terraform/ sub-folder
        _state = state.rstrip("/").replace(getcwd(), '').replace('/terraform/', '')  # Normalize
        state_dir = path.join(getcwd(), 'terraform', _state)

        # Sniff the backend.tf to determine if target is a workspaced state
        workspace = None
        workspaced = False
        with open(path.join(state_dir, 'backend.tf'), 'r') as backend:
            if 'workspace_key_prefix' in backend.read():
                workspaced = True
        if len(parts) > 1:
            workspace = parts[1]
        if workspaced and workspace is None:
            raise ArgumentTypeError('target argument was not in the form <state>:<workspace> for workspaced state.')
        if not workspaced and workspace is None:
            workspace = 'main'  # Default to the only valid value in this case

        # Refresh sub account AWS mfa credentials if needed
        StsAssumeRoleCredentials().refresh_profile(f'admin-{workspace}')

        environment = environ.copy()  # Inherit cicdctl's environment

        # Set aws credentials profile with env variables
        environment['AWS_PROFILE'] = f'admin-{workspace}'

        # Shared terraform plugin cache
        environment['TF_PLUGIN_CACHE_DIR'] = path.join(getcwd(), '.terraform.d/plugin-cache')

        # Handle version compatibility
        #  '>= ...'  => /bin/terraform (latest)
        #  '0.11.14' => /bin/terraform-0.11.14
        required_version = parse_terraform_tf(path.join(state_dir, 'backend.tf'))['required_version']
        terraform = 'terraform'
        if not required_version.strip().startswith('>='):
            terraform = f'terraform-{required_version}'

        # Handle sub-command dependencies (init, workspace ordering )
        sub_command = args.command
        if sub_command == 'unlock':  # Special case
            environment = environ.copy()  # Inherit cicdctl's environment
            gen_cmd = ['terraform/bin/clear-state-lock.sh', target]
            log_cmd_line(gen_cmd)
            subprocess.run(gen_cmd, env=environment, cwd=getcwd(), stdout=stdout, stderr=stderr, check=True)
        elif sub_command in ['init', 'workspace']:
            _state_prep(state_dir, workspace, environment, workspaced, terraform)  # "state prep" will handle these completely
        elif sub_command in ['import', 'output', 'refresh', 'plan', 'apply', 'destroy']:
            _state_prep(state_dir, workspace, environment, workspaced, terraform)  # "state prep" the state first, then proceed

            # Load variables.tf, locate values from terraform/*.tfvars
            var_opts = []
            if sub_command in ['refresh', 'plan', 'apply', 'destroy', 'import']:
                vars = parse_variable_comments_tf(path.join(state_dir, 'variables.tf'))  # name -> tfvar file
                backend_vars = parse_tfvars(backend_config)
                for name, file in vars.items():
                    if file == 'backend-config.tfvars':  # Backend variables get individual bindings
                        var_opts.append('-var')
                        var_opts.append(f'{name}={backend_vars[name]}')
                    else:  # Other global variables should be single value for file bindings
                        var_opts.append('-var-file')
                        var_opts.append(path.join(varfile_dir, file))

            command_line = [terraform, sub_command]
            command_line.extend(var_opts)
            command_line.extend(overrides)
            _run(command_line, state_dir, environment)

            # Handle cascades
            for cascade in get_cascades(_state):
                if sub_command in cascade['ops']:
                    _args = SimpleNamespace()
                    _args.command = cascade['type']
                    _args.target = cascade['target']
                    _args.overrides = [cascade['opts']]
                    run_terraform(_args)  # Recursive call


def _run(command_line, working_dir, environment):
    log_cmd_line(command_line, cwd=working_dir)

    p = subprocess.Popen(command_line,
                         stdout=stdout,
                         stderr=stderr,
                         cwd=working_dir,
                         env=environment)
    try:
        p.communicate()
    except KeyboardInterrupt:
        pass
    exit_code = p.returncode
    if exit_code != 0:
        exit(exit_code)

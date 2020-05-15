from sys import exit, stdout, stderr
from os import path, getcwd, environ
import subprocess
from signal import SIGINT
from collections import namedtuple
from pprint import pprint

# import logging


class EnvVars(namedtuple('EnvVars', ['vars', 'keys'])):
    """Environment vars and keys that should be echo'd."""
    def __str__(self):
        return f'{" ".join(self.keys)}\n{pprint.pformat(self.vars)}'



def _log_interrupted():
    print('  => Interrupted')


def _log_returncode(returncode):
    print(f'  => {returncode}')


def _log_env_vars(envVars):
    if len(envVars.keys) > 0:
        custom_env = [f'{key}={envVars.vars[key]}' for key in envVars.keys]
        # logging.getLogger("cicdctl").info(' '.join(custom_env))
        print('\n'.join(custom_env))


def _log_command_line(command_line, cwd=None):
    # render list of str, int into a string
    _cmd_line = " ".join(str(x) for x in command_line)
    # Print sub-shell command for non top-level $PWD
    if cwd and cwd != getcwd():
        path = cwd.replace(f'{getcwd()}/', '')
        cmd_line = f'(cd {path}; {_cmd_line})'
    else:
        cmd_line = _cmd_line
    
    # logging.getLogger('cicdctl').info(cmd_line)
    print(cmd_line)


class SubprocessRunner(object):
    def __init__(self, settings, cwd, envVars, stdout, stderr, check):
        self.settings = settings
        self.cwd = cwd
        self.envVars = envVars
        self.stdout = stdout
        self.stderr = stderr
        self.check = check

    def run(self, command_line, **kwargs):
        cwd = kwargs.get('cwd', self.cwd)
        envVars = kwargs.get('envVars', self.envVars)
        _input = kwargs.get('input', None)
        stdout = kwargs.get('stdout', self.stdout)
        stderr = kwargs.get('stderr', self.stderr)
        check = kwargs.get('check', self.check)

        if not self.settings.quiet:
            _log_env_vars(envVars)
            _log_command_line(command_line, cwd=cwd)

        if not self.settings.dry_run:
            def _run():
                return subprocess.run(command_line,
                                      input=_input,
                                      stdout=stdout,
                                      stderr=stderr,
                                      cwd=cwd,
                                      env=envVars.vars,
                                      check=check)
            try:
                if check:  # Non-zero exit status is fatal
                    try:
                        _run()
                    except subprocess.CalledProcessError as cpe:
                        _log_returncode(cpe.returncode)
                        exit(cpe.returncode)
                else:
                    result = _run()
                    if not self.settings.quiet and result.returncode != 0:
                        _log_returncode(result.returncode)
            except KeyboardInterrupt:
                if not self.settings.quiet:
                    _log_interrupted()
                exit(SIGINT)

    def exec(self, command_line, **kwargs):
        cwd = kwargs.get('cwd', self.cwd)
        envVars = kwargs.get('envVars', self.envVars)
        stdout = kwargs.get('stdout', self.stdout)
        stderr = kwargs.get('stderr', self.stderr)
        check = kwargs.get('check', self.check)

        if not self.settings.quiet:
            _log_env_vars(envVars)
            _log_command_line(command_line, cwd=cwd)
        
        if not self.settings.dry_run:
            p = subprocess.Popen(command_line,
                                 stdout=stdout,
                                 stderr=stderr,
                                 cwd=cwd,
                                 env=envVars.vars)
            try:
                p.communicate()
            except KeyboardInterrupt:
                if not self.settings.quiet:
                    _log_interrupted()
                exit(SIGINT)
            if not self.settings.quiet and p.returncode != 0:
                _log_returncode(p.returncode)
            if check and p.returncode != 0:
                exit(p.returncode)
    
    def output_string(self, command_line, **kwargs):
        cwd = kwargs.get('cwd', self.cwd)
        envVars = kwargs.get('envVars', self.envVars)
        stderr = kwargs.get('stderr', self.stderr)

        if not self.settings.quiet:
            _log_env_vars(envVars)
            _log_command_line(command_line, cwd=cwd)

        try:
            raw = subprocess.check_output(command_line, 
                                          env=envVars.vars, 
                                          cwd=cwd, 
                                          stderr=self.stderr)
        except subprocess.CalledProcessError as cpe:
            if not self.settings.quiet:
                _log_returncode(cpe.returncode)
            exit(cpe.returncode)
        except KeyboardInterrupt:
            if not self.settings.quiet:
                _log_interrupted()
            exit(SIGINT)
        return raw.decode("utf-8").strip()

    def output_list(self, command_line, func=lambda line: line.strip(), **kwargs):
        raw = self.output_string(command_line, **kwargs)
        lines = raw.splitlines()
        return [func(line) for line in lines] if func else lines


class SubprocessRunnerFactory(object):
    def __init__(self, settings):
        self.settings = settings

    def __call__(self, cwd=getcwd(), envVars=EnvVars(environ.copy(), []), stdout=stdout, stderr=stderr, check=True):
        return SubprocessRunner(self.settings, cwd, envVars, stdout, stderr, check)

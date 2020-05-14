from sys import exit, stdout, stderr
from os import path, getcwd, environ
import subprocess

# import logging


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
    def __init__(self, settings, cwd, env, stdout, stderr, check):
        self.settings = settings
        self.cwd = cwd
        self.env = env
        self.stdout = stdout
        self.stderr = stderr
        self.check = check

    def run(self, command_line, **kwargs):
        cwd = kwargs.get('cwd', self.cwd)
        env = kwargs.get('env', self.env)
        _input = kwargs.get('input', None)
        stdout = kwargs.get('stdout', self.stdout)
        stderr = kwargs.get('stderr', self.stderr)
        check = kwargs.get('check', self.check)

        if not self.settings.quiet:
            _log_command_line(command_line, cwd=cwd)

        if not self.settings.dry_run:
            subprocess.run(command_line,
                           input=_input,
                           stdout=stdout,
                           stderr=stderr,
                           cwd=cwd,
                           env=env,
                           check=check)

    def exec(self, command_line, **kwargs):
        cwd = kwargs.get('cwd', self.cwd)
        env = kwargs.get('env', self.env)
        stdout = kwargs.get('stdout', self.stdout)
        stderr = kwargs.get('stderr', self.stderr)
        check = kwargs.get('check', self.check)

        if not self.settings.quiet:
            _log_command_line(command_line, cwd=cwd)
        
        if not self.settings.dry_run:
            p = subprocess.Popen(command_line,
                                 stdout=stdout,
                                 stderr=stderr,
                                 cwd=cwd,
                                 env=env)
            try:
                p.communicate()
            except KeyboardInterrupt:
                pass
            exit_code = p.returncode
            if check and exit_code != 0:
                exit(exit_code)
    
    def output_string(self, command_line, **kwargs):
        cwd = kwargs.get('cwd', self.cwd)
        env = kwargs.get('env', self.env)
        stderr = kwargs.get('stderr', self.stderr)

        if not self.settings.quiet:
            _log_command_line(command_line, cwd=cwd)

        raw = subprocess.check_output(command_line, 
                                         env=env, 
                                         cwd=cwd, 
                                         stderr=self.stderr)
        return raw.decode("utf-8").strip()

    def output_list(self, command_line, func=lambda line: line.strip(), **kwargs):
        cwd = kwargs.get('cwd', self.cwd)
        env = kwargs.get('env', self.env)
        stderr = kwargs.get('stderr', self.stderr)

        if not self.settings.quiet:
            _log_command_line(command_line, cwd=cwd)

        raw = subprocess.check_output(command_line, 
                                         env=env, 
                                         cwd=cwd, 
                                         stderr=self.stderr)
        lines = raw.decode("utf-8").strip().splitlines()
        return [func(line) for line in lines] if func else lines


class SubprocessRunnerFactory(object):
    def __init__(self, settings):
        self.settings = settings

    def __call__(self, cwd=getcwd(), env=environ.copy(), stdout=stdout, stderr=stderr, check=True):
        return SubprocessRunner(self.settings, cwd, env, stdout, stderr, check)

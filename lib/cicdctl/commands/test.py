import sys
from sys import stdout, stderr
from os import path, getcwd, environ
import subprocess
from unittest import main


def run_test(args):
    if len(args.arguments) > 0:  # Run specific tests
        if not 'tests' in sys.path:
            sys.path.append('tests')
        
        import test

        main(module=test, argv=['cicdctl'] + args.arguments)
    else:  # Run all tests
        environment = environ.copy()  # Inherit cicdctl's environment        

        # Add lib/ folder to python module lookup path
        environment['PYTHONPATH'] = path.join(getcwd(), 'lib')

        subprocess.run(['python', '-m', 'unittest', 'discover', 'tests'], \
            env=environment, cwd=getcwd(), stdout=stdout, stderr=stderr, check=True)

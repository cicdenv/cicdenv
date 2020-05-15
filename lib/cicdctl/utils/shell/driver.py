from . import env 


class ShellDriver(object):
    def __init__(self, settings):
        self._run = settings.runner(env_ctx=env()).run

    def bash(self):
    	self._run(['bash'])

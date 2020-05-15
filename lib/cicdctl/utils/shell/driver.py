from . import env 


class ShellDriver(object):
    def __init__(self, settings):
        self.settings = settings

        self.envVars = env()

        self.runner = self.settings.runner(envVars=self.envVars)

    def bash(self):
    	self.runner.run(['bash'])

from . import env 


class ShellDriver(object):
    def __init__(self, settings):
        self.settings = settings

        self.environment = env()

        self.runner = self.settings.runner(env=self.environment)

    def bash(self):
    	self.runner.run(['bash'])

from . import env 


class TestDriver(object):
    def __init__(self, settings, flags):
        self.settings = settings
        self.flags = flags

        self.envVars = env()

        self.runner = self.settings.runner(envVars=self.envVars)

    def test(self):
        self.runner.run(['python', '-m', 'pytest'] + list(self.flags))

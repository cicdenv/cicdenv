from . import env 


class TestDriver(object):
    def __init__(self, settings, flags):
        self.settings = settings
        self.flags = flags

        self.environment = env()

        self.runner = self.settings.runner(env=self.environment)

    def test(self):
        self.runner.run(['python', '-m', 'pytest'] + list(self.flags))

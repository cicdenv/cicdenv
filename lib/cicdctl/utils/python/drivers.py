from . import env 


class TestDriver(object):
    def __init__(self, settings, flags):
        self.flags = flags

        self._run = settings.runner(env_ctx=env()).run

    def test(self):
        self._run(['python', '-m', 'pytest'] + list(self.flags))

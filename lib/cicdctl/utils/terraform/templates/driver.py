from . import (env, workspaced_script, non_workspaced_script)

class TemplateDriver(object):
    def __init__(self, settings):
        self.settings = settings

        self.envVars = env()

        self.runner = self.settings.runner(envVars=self.envVars)

    def new(self, workspaced, component):
        if workspaced:
            self.runner.run([workspaced_script, component])
        else:
            self.runner.run([non_workspaced_script, component])

from . import (workspaced_script, non_workspaced_script)


class TemplateDriver(object):
    def __init__(self, settings):
        self.run = settings.runner().run

    def new(self, workspaced, component):
        if workspaced:
            self.run([workspaced_script, component])
        else:
            self.run([non_workspaced_script, component])

from os import path

import yaml

from terraform.files import varfile_dir

# dependencies config (cascades)
deps_config = path.join(varfile_dir, 'dependencies.yaml')


def _load_cascades():
	with open(deps_config, 'r') as f:
		return yaml.load(f, Loader=yaml.BaseLoader)['cascades']


def get_cascades(state):
	deps = _load_cascades()
	if state in deps:
		return deps[state]
	else:
		return []

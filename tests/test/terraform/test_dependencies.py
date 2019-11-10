from os import path

from unittest import TestCase

from terraform.dependencies import deps_config, get_cascades


class TestTerraformDependencies(TestCase):
    """
    Tests the file cascade loading/parsing functions in terraform.dependencies.
    """

    def test_deps_config(self):
        self.assertTrue(path.isfile(deps_config))

    def test_get_cascades(self):
        result = get_cascades('iam/organizations')
        self.assertTrue(len(result) > 0)

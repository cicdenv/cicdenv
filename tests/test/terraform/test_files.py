from os import path, getcwd

from unittest import TestCase

from terraform.files import \
    varfile_dir, backend_config, domain_config, \
    parse_terraform_tf, parse_variable_comments_tf, parse_variables_tf, parse_tfvars


class TestTerraformFiles(TestCase):
    """
    Tests the file paths and helper functions in the terraform.files module.
    """

    def test_varfile_dir(self):
        self.assertTrue(path.isdir(varfile_dir))

    def test_backend_config_file_exists(self):
        self.assertTrue(path.isfile(backend_config))

    def test_domain_config_file_exists(self):
        self.assertTrue(path.isfile(domain_config))

    def test_parse_terraform_tf(self):
        parse_terraform_tf(path.join(getcwd(), 'terraform', 'backend', 'backend.tf'))

    def test_parse_variable_comments_tf(self):
        result = parse_variable_comments_tf(path.join(getcwd(), 'terraform', 'backend', 'variables.tf'))
        self.assertTrue(result['region'] == 'backend-config.tfvars')

    def test_parse_variables_tf(self):
        result = parse_variables_tf(path.join(getcwd(), 'terraform', 'backend', 'variables.tf'))
        self.assertTrue('region' in result)

    def test_parse_tfvars(self):
        result = parse_tfvars(path.join(getcwd(), 'terraform', 'whitelisted-networks.tfvars'))
        self.assertTrue('whitelisted_cidr_blocks' in result)

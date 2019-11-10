from unittest import TestCase

from aws.credentials import _is_mfa_admin_creds, StsAssumeRoleCredentials, MfaCodeGenerator


class TestIsMfaAdminCreds(TestCase):
    """
    Tests the admin-* profile section matching logic
    """

    #
    # These shouldn't match
    #
    
    def test_default_false(self):
        self.assertFalse(_is_mfa_admin_creds('default'))

    def test_default_long_term_false(self):
        self.assertFalse(_is_mfa_admin_creds('default-long-term'))

    def test_admin_false(self):
        self.assertFalse(_is_mfa_admin_creds('admin'))

    def test_admin_root_false(self):
        self.assertFalse(_is_mfa_admin_creds('admin-root'))

    #
    # These should match
    #
    def test_admin_main_true(self):
        self.assertTrue(_is_mfa_admin_creds('admin-main'))

    def test_admin_infra_test_true(self):
        self.assertTrue(_is_mfa_admin_creds('admin-infra-test'))


class TestMfaCodeGenerator(TestCase):
    """
    Test MfaCodeGenerator next method.
    """

    def test_next(self):
        MfaCodeGenerator().next()


class TestStsAssumeRoleCredentials(TestCase):
    """
    Test StsAssumeRoleCredentials works for 'admin-main'
    """

    def test_admin_main(self):
        StsAssumeRoleCredentials().refresh_profile('admin-main')

from os import path, listdir, getcwd, stat, environ
from sys import stdout, stderr

from stat import \
    S_IRGRP, S_IWGRP, S_IXGRP, \
    S_IROTH, S_IWOTH, S_IXOTH

import subprocess
from subprocess import DEVNULL

from unittest import TestCase


class TestEnvironment(TestCase):
    """
    Tests the basic bind-mounted host environment is usable
    """

    def test_aws_shared_credentials_file_exists(self):
        self.assertTrue(path.isfile(path.expanduser('~/.aws/credentials')))

    def test_ssh_user_folder_is_non_empty(self):
        self.assertTrue(listdir(path.expanduser('~/.ssh')))

    def test_ssh_user_folder_has_correct_folder_group_perms(self):
        dir_stat = stat(path.expanduser('~/.ssh'))
        self.assertFalse(dir_stat.st_mode & (S_IRGRP | S_IWGRP | S_IXGRP))

    def test_ssh_user_folder_has_correct_folder_other_perms(self):
        dir_stat = stat(path.expanduser('~/.ssh'))
        self.assertFalse(dir_stat.st_mode & (S_IROTH | S_IWOTH | S_IXOTH))

    def test_gitconfig_is_a_file(self):
        self.assertTrue(path.isfile(path.expanduser('~/.gitconfig')))

    def test_gitconfig_file_is_non_empty(self):
        self.assertTrue(path.getsize(path.expanduser('~/.gitconfig')) > 0)

    def test_keybase_is_logged_in(self):
        # Change DEVNULL(s) to stdout, stderr to debug failures
        subprocess.run(['keybase', 'id'], \
            env=environ.copy(), cwd=getcwd(), stdout=DEVNULL, stderr=DEVNULL, check=True)

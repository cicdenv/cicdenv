from sys import exit, stderr
from os import path, getcwd
import subprocess
from subprocess import DEVNULL

from pathlib import Path
from configparser import ConfigParser
import getpass
from hashlib import sha256
import logging
import json

import time
from dateutil.parser import parse
from datetime import datetime, timedelta
from pytz import timezone
from tzlocal import get_localzone

import oathtool

from . import config_profile
from ..terraform.driver import TerraformDriver
from ...commands.types.target import parse_target


def _is_mfa_admin_creds(section):
    """
    Filter for ~/.aws/credentials profile section names.
    """
    
    if not section.startswith('admin-'):
        return False
    if section.endswith('-long-term') or section.endswith('-root'):
        return False
    return True


totp_secrets_file = path.join(getcwd(), f'mfa-virtual-devices/{getpass.getuser()}-secret.txt.gpg')
last_totp_file = path.join(path.expanduser("~"), f'.aws/.last-totp.txt')


class MfaCodeGenerator(object):
    """
    Obtains the next Virtual MFA device code.

    This uses keybase decrypt to access the MFA device setup from mfa-virtual-devices/$IAM_USER-secret.txt.gpg.

    TOTP => [T]ime base [O]ne [T]ime [P]asscode - synonym: mfa-code
    """


    # decrypt from mfa-virtual-devices/
    def __init__(self, settings, totp_secrets_file=totp_secrets_file, last_totp_file=last_totp_file):
        self.settings = settings
        self.totp_secrets_file = totp_secrets_file
        self.last_totp_file = last_totp_file

        self.runner = self.settings.runner()

        Path(self.last_totp_file).touch(mode=0o600, exist_ok=True)

    def _decrypt_totp_config(self):
        # Keybase login required prior
        secret = self.runner.output_string(['keybase', '--no-auto-fork', '--local-rpc-debug-unsafe', 'A', 'decrypt', '--infile', self.totp_secrets_file], stderr=DEVNULL)
        return secret

    def _run_oathtool(self):
        secret = self._decrypt_totp_config()

        totp = oathtool.generate_otp(secret)  # self.runner.output_string(['oathtool', '--base32', '--totp', secret])
        hashed_totp = sha256(totp.encode()).hexdigest()
        
        return totp, hashed_totp

    def _load_last_used(self):
        last_used = set()
        with open(self.last_totp_file, 'r') as f:
            for line in f:
                last_used.add(line.strip())
        return last_used

    def _update_last_used(self, hashed_totp):
        with open(self.last_totp_file, 'w') as f:
            f.write(f'{hashed_totp}\n')

    def next(self):
        """
        Gets the next un-used MFA code.
        """
        
        totp, hashed_totp = self._run_oathtool()

        last_used = self._load_last_used()
        if hashed_totp in last_used:
            logging.getLogger("cicdctl").info("Waiting for next mfa-code ...")
        while hashed_totp in last_used:
            time.sleep(1)
            totp, hashed_totp = self._run_oathtool()
            last_used = self._load_last_used()  # Reload last_used each sleep cycle
        self._update_last_used(hashed_totp)

        return totp


class StsAssumeRoleCredentials(object):
    """
    AWS sts + assume-role credentials manager.

    Updates ~/.aws/credentials (removes, re-adds) [admin-$WORKSPACE] profiles.
    Expects corresponding [admin-$WORKSPACE-long-term] aws-mfa prototype profile
    sections to already be present.
    """

    credentials_file = path.join(path.expanduser("~"),'.aws/credentials')
    cutoff = datetime.now(timezone('UTC')) + timedelta(minutes=15)

    def __init__(self, settings, credentials_file=credentials_file, cutoff=cutoff):
        self.settings = settings
        
        self.totp_generator = MfaCodeGenerator(self.settings)
        self.runner = self.settings.runner()

    def refresh(self, workspace):
        profile = config_profile(workspace)
        self.refresh_profile(profile)
        
    def refresh_profile(self, profile):
        """
        Ensures the given profile exists in ~/.aws/credentials and
        has at least 15 minutes left before it expires.
        """

        self._remove_stale_profiles()
        self._ensure_profile_prototype(profile)
        if not self._has_profile(profile):
            self._renew_profile(profile)

    def _load_credentials(self):
        credentials = ConfigParser()
        credentials.read(self.credentials_file)
        return credentials

    def _remove_stale_profiles(self):
        credentials = self._load_credentials()

        profiles = [s for s in credentials.sections() if _is_mfa_admin_creds(s)]
        if len(profiles) == 0:  # No active creds sections
            return

        for profile in profiles:
            expiration = credentials.get(profile, 'expiration')
            expires = timezone('UTC').localize(parse(expiration))
            if expires < self.cutoff:
                credentials.remove_section(profile)

        with open(self.credentials_file, 'w') as f:
            credentials.write(f)

    def _get_assume_role(self, workspace):
        outputs = TerraformDriver(self.settings, parse_target(f'backend:main')).outputs()
        print(outputs)
        return outputs['organization_accounts']['value'][workspace]['role']

    def _ensure_profile_prototype(self, profile):
        workspace = profile.replace('admin-', '')
        if workspace == 'main':  # Special case - we must have this or can't source sub-account ids
            return

        credentials = self._load_credentials()
        if not f'{profile}-long-term' in credentials.sections():
            # Use 'default-long-term' to determine: key id, secret, mfa arn
            if not 'default-long-term' in credentials.sections():
                print(f"[default-long-term] profile section not found in '~/.aws/credentials'", file=stderr)
                exit(1)

            defaults = credentials['default-long-term']
            prototype = {
                'aws_secret_access_key': defaults['aws_secret_access_key'],
                'aws_access_key_id': defaults['aws_access_key_id'],
                'aws_mfa_device': defaults['aws_mfa_device'],
                'assume_role': self._get_assume_role(workspace),
            }
            credentials[f'{profile}-long-term'] = prototype

            with open(self.credentials_file, 'w') as f:
                credentials.write(f)

    def _has_profile(self, profile):
        credentials = self._load_credentials()

        return profile in credentials.sections()

    def _renew_profile(self, profile):
        # Get mfa-code
        totp = self.totp_generator.next()  # NOTE: totp has a newline

        _1hour = 60 * 60 # 1 hour in seconds
        duration = str(12 * _1hour)  # 12 hours in seconds
        
        # Use the mfa-code to login
        mfa_cmd = ['aws-mfa', f'--profile={profile}', f'--duration={duration}', '--log-level=ERROR']
        self.runner.run(mfa_cmd, input=totp.encode(), stdout=DEVNULL)

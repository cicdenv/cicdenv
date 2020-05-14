from . import (load_whitelisted_networks, normalize_cidr, update_whitelisted_networks)


class WhitelistDriver(object):
    def __init__(self, settings):
        self.settings = settings
        self.cidrs = load_whitelisted_networks()

    def list(self):
        print('\n'.join(self.cidrs))

    def add(self, cidr):
        if cidr not in self.cidrs:
            self.cidrs.append(cidr)
            if not self.settings.dry_run:
                update_whitelisted_networks(self.cidrs)

    def remove(self, cidr):
        if cidr in self.cidrs:
            self.cidrs.remove(cidr)
            if not self.settings.dry_run:
                update_whitelisted_networks(self.cidrs)

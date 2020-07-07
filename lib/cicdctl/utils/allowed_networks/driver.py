from . import (load_allowed_networks, normalize_cidr, update_allowed_networks)


class AllowedNetworksDriver(object):
    def __init__(self, settings):
        self.settings = settings
        self.cidrs = load_allowed_networks()

    def list(self):
        print('\n'.join(self.cidrs))

    def add(self, cidr):
        if cidr not in self.cidrs:
            self.cidrs.append(cidr)
            if not self.settings.dry_run:
                update_allowed_networks(self.cidrs)

    def remove(self, cidr):
        if cidr in self.cidrs:
            self.cidrs.remove(cidr)
            if not self.settings.dry_run:
                update_allowed_networks(self.cidrs)

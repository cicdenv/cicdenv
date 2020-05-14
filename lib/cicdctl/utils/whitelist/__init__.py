import urllib.request

from ..terraform import whitelisted_networks, parse_tfvars

"""
./terraform/whitelisted-networks.tfvars structure:
#
# Office Access
#
whitelisted_cidr_blocks = [
  <cidr-1>,
  <cidr-2>,
  ...,
]
"""

def load_whitelisted_networks():
    return parse_tfvars(whitelisted_networks)['whitelisted_cidr_blocks']


def normalize_cidr(cidr):
    if cidr == 'my-ip':  # Special case
        external_ip = urllib.request.urlopen('https://api.ipify.org/').read().decode('utf8')
        return f'{external_ip}/32'
    if '/' in args.cidr:
        return cidr
    return f'{cidr}/32'


def update_whitelisted_networks(cidrs):
    header = []
    with open(whitelisted_networks, 'r') as f:
        for line in f:
            if not line.startswith('whitelisted_cidr_blocks = ['):
                # Retain comments
                header.append(line)
            else:  # Found the HCL list start
                header.append(line)
                break

    with open(whitelisted_networks, 'w') as f:
        f.writelines(header)
        for cidr in cidrs:
            print(f'  "{cidr}",', file=f)
        print(']', file=f)  # Close the HCL list

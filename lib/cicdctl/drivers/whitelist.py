import urllib.request

from terraform.files import whitelisted_networks, parse_tfvars


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
def _update_whitelisted_networks(cidrs):
    header = []
    with open(whitelisted_networks, 'r') as f:
        for line in f:
            if line.startswith('whitelisted_cidr_blocks = ['):
                header.append(line)
                break
            header.append(line)

    with open(whitelisted_networks, 'w') as f:
        f.writelines(header)
        for cidr in cidrs:
            print(f'  "{cidr}",', file=f)
        print(']', file=f)


def run_whitelist(args):
    cidr = None
    if args.cidr == 'my-ip':  # Special case
        external_ip = urllib.request.urlopen('https://api.ipify.org/').read().decode('utf8')
        cidr = f'{external_ip}/32'
    else:
        if '/' in args.cidr:
            cidr = args.cidr
        else:
            cidr = f'{args.cidr}/32'
        
    cidrs = parse_tfvars(whitelisted_networks)['whitelisted_cidr_blocks']
    if not cidr in cidrs:
        print(f'Adding to whitelist: {cidr}')
        cidrs.append(cidr)
        _update_whitelisted_networks(cidrs)

from ...commands.types.target import parse_target

# Workspaced NAT-Gateways
def routing_target(workspace):
    # Retired in favor of a single egress VPC + transit gateway
    # return parse_target(f'network/routing:{workspace}')
    return parse_target(f'network/routing:main')

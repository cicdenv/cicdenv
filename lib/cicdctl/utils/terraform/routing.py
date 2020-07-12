from ...commands.types.target import parse_target

# Workspaced NAT-Gateways
def routing_target(workspace):
    return parse_target(f'network/routing:{workspace}')

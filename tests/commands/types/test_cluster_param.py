from cicdctl.commands.types.cluster import ClusterParamType


def test_full():
    name = '1-18a'
    workspace = 'dev'
    cluster = f'{name}:{workspace}'
    parsed = ClusterParamType().convert(value=cluster, param=None, context={})
    assert cluster == str(parsed)
    assert name == parsed.name
    assert workspace == parsed.workspace

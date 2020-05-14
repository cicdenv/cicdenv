from cicdctl.commands.types.instance import InstanceParamType


def test_full():
    name = 'test'
    workspace = 'dev'
    instance = f'{name}:{workspace}'
    parsed = InstanceParamType().convert(value=instance, param=None, context={})
    assert instance == str(parsed)
    assert name == parsed.name
    assert workspace == parsed.workspace

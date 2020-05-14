from cicdctl.commands.types.target import TargetParamType


def test_full():
    component = 'kops/nat-gateways'
    workspace = 'dev'
    target = f'{component}:{workspace}'
    parsed = TargetParamType().convert(value=target, param=None, context={})
    assert target == str(parsed)
    assert component == parsed.component
    assert workspace == parsed.workspace


def test_component_only_defaults_to_main_workspace():
    component = 'kops/backend'
    workspace = 'main'
    target = f'{component}'  # missing :<workspace>, should default to 'main'
    parsed = TargetParamType().convert(value=target, param=None, context={})
    assert f'{component}:{workspace}' == str(parsed)
    assert component == parsed.component
    assert workspace == parsed.workspace

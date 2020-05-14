from cicdctl.commands.types.workspace import WorkspaceParamType


def test_workspace():
    workspace = 'dev'
    parsed = WorkspaceParamType().convert(value=workspace, param=None, context={})
    assert workspace == parsed

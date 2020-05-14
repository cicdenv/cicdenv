from cicdctl.commands.types.flag import FlagParamType


def test_flag():
    flag = '-no-color'
    parsed = FlagParamType().convert(value=flag, param=None, context={})
    assert flag == parsed

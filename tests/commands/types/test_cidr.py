from cicdctl.commands.types.cidr import CIDRParamType


def test_workspace():
    cidr = '198.27.223.45/32'
    parsed = CIDRParamType().convert(value=cidr, param=None, context={})
    assert cidr == parsed

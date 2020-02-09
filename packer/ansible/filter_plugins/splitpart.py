def splitpart (value, index, char = ','):
    if isinstance(value, (list, tuple)):
        ret = []
        for v in value:
            ret.append(v.split(char)[index])
        return ret
    else:
        return value.split(char)[index]

class FilterModule(object):
    def filters(self):
        return {'splitpart': splitpart}

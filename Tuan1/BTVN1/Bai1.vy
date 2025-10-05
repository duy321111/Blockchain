stored_value: int128
# Luu tru va lay gia tri

@external

def store(_value: int128):
    self.stored_value = _value

@view
@external

def retrieve() -> int128:
    return self.stored_value



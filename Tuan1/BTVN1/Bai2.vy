
#   Quản lý gửi và rút ETH

# lưu số dư từng địa chỉ
balances: public(HashMap[address, uint256])

# Hàm gửi tiền vào hợp đồng
@payable
@external
def deposit():
    # Cộng số ETH gửi vào số dư của địa chỉ gọi hàm
    self.balances[msg.sender] += msg.value

#Hàm xem số dư của một địa chỉ
@view
@external
def get_balance(_addr: address) -> uint256:
    return self.balances[_addr]

# Hàm rút tiền
@external
def withdraw(_amount: uint256):
    # Kiểm tra người dùng có đủ tiền không
    assert self.balances[msg.sender] >= _amount, "Khong du so du"

    # Giảm số dư trước khi chuyển (quy tắc an toàn)
    self.balances[msg.sender] -= _amount

    # Gửi ETH về lại địa chỉ của người dùng
    send(msg.sender, _amount)

# Bai5.vy - Hợp đồng Crowdfunding đơn giản

# Chủ dự án
owner: public(address)

# Mục tiêu quỹ (5 ETH) – lưu theo Wei
goal: public(uint256)

# Thời hạn hợp đồng (timestamp)
deadline: public(uint256)

# Tổng số tiền đã nhận
totalCollected: public(uint256)

# Lưu số dư từng người đóng góp
balances: public(HashMap[address, uint256])

# Khởi tạo hợp đồng
@deploy
def __init__():
    self.owner = msg.sender
    self.goal = as_wei_value(5, "ether")  # 5 ETH
    self.deadline = block.timestamp + 10 * 60  # 10 phút từ lúc deploy
    self.totalCollected = 0

# Hàm đóng góp
@payable
@external
def contribute():
    # Chỉ nhận khi chưa quá hạn
    assert block.timestamp < self.deadline, "Thoi han da ket thuc"
    
    # Cập nhật số dư cá nhân
    self.balances[msg.sender] += msg.value
    
    # Cập nhật tổng số tiền đã nhận
    self.totalCollected += msg.value

# Hàm rút tiền
@external
def withdraw():
    # Nếu chủ dự án rút tiền khi đạt mục tiêu trước thời hạn
    if msg.sender == self.owner:
        assert self.totalCollected >= self.goal, "Chua dat muc tieu"
        send(self.owner, self.totalCollected)
        self.totalCollected = 0
    else:
        # Người đóng góp rút lại nếu không đạt mục tiêu sau thời hạn
        assert block.timestamp >= self.deadline, "Chua den thoi han"
        assert self.totalCollected < self.goal, "Muc tieu da dat"
        amount: uint256 = self.balances[msg.sender]
        assert amount > 0, "Khong co so du de rut"
        self.balances[msg.sender] = 0
        send(msg.sender, amount)

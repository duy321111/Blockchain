# Danh sách ứng viên - tối đa 3 ứng viên
candidates: public(DynArray[String[20], 3])

# Số phiếu cho từng ứng viên
votes: public(HashMap[String[20], uint256])

# Kiểm tra đã bỏ phiếu chưa
voted: public(HashMap[address, bool])

@deploy
def __init__():
    self.candidates.append("Ty")
    self.candidates.append("Teo")
    self.candidates.append("Mai")
    self.votes["Ty"] = 0
    self.votes["Teo"] = 0
    self.votes["Mai"] = 0

@external
def vote(name_candidate: String[20]):
    assert not self.voted[msg.sender], "Ban da bo phieu roi!"
    valid: bool = False
    for i: uint256 in range(3):
        if self.candidates[i] == name_candidate:
            valid = True
            break
    assert valid, "Ung vien khong hop le!"
    self.votes[name_candidate] += 1
    self.voted[msg.sender] = True

@view
@external
def getWinner() -> String[20]:
    winner: String[20] = self.candidates[0]
    max_votes: uint256 = self.votes[winner]
    for i: uint256 in range(1, 3):
        candidate: String[20] = self.candidates[i]
        if self.votes[candidate] > max_votes:
            max_votes = self.votes[candidate]
            winner = candidate
    return winner

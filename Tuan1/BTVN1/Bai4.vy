# Bai4.vy - Quản lý danh bạ bằng struct

# Định nghĩa cấu trúc Contact
struct Contact:
    name: String[32]
    phone: String[20]

# Lưu danh bạ: ánh xạ tên → Contact
contacts: public(HashMap[String[32], Contact])

# Thêm liên hệ mới
@external
def addContact(name: String[32], phone: String[20]):
    # Kiểm tra xem liên hệ đã tồn tại chưa
    assert len(self.contacts[name].name) == 0, "Lien he da ton tai"

    # Lưu liên hệ vào danh bạ
    self.contacts[name] = Contact({name: name, phone: phone})

# Tra cứu số điện thoại theo tên
@view
@external
def getPhone(name: String[32]) -> String[20]:
    # Kiểm tra liên hệ có tồn tại không
    assert len(self.contacts[name].name) != 0, "Lien he khong ton tai"
    
    # Trả về số điện thoại
    return self.contacts[name].phone

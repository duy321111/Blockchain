# Bai6.vy - Document Notary Contract

# Định nghĩa cấu trúc tài liệu
struct Document:
    owner: address
    timestamp: uint256
    signature: String[256]

# Lưu trữ tài liệu: hash → Document
documents: public(HashMap[bytes32, Document])

# Event khi đăng ký tài liệu
event DocumentRegistered:
    doc_hash: bytes32
    owner: address
    timestamp: uint256

# Event khi thêm chữ ký số
event SignatureAdded:
    doc_hash: bytes32
    owner: address
    signature: String[256]

# Hàm đăng ký tài liệu
@external
def registerDocument(doc_hash: bytes32):
    # Kiểm tra tài liệu chưa tồn tại
    assert self.documents[doc_hash].timestamp == 0, "Tai lieu da ton tai"
    
    # Lưu thông tin tài liệu
    self.documents[doc_hash] = Document({
        owner: msg.sender,
        timestamp: block.timestamp,
        signature: ""
    })
    
    # Phát event
    log DocumentRegistered(doc_hash, msg.sender, block.timestamp)

# Hàm thêm chữ ký số cho tài liệu
@external
def addSignature(doc_hash: bytes32, signature: String[256]):
    # Kiểm tra tài liệu tồn tại
    doc: Document = self.documents[doc_hash]
    assert doc.timestamp != 0, "Tai lieu khong ton tai"
    
    # Chỉ người đăng ký mới thêm chữ ký
    assert doc.owner == msg.sender, "Chi nguoi dang ky moi duoc ky"
    
    # Cập nhật chữ ký
    self.documents[doc_hash].signature = signature
    
    # Phát event
    log SignatureAdded(doc_hash, msg.sender, signature)

# Hàm kiểm tra tài liệu
@view
@external
def verifyDocument(doc_hash: bytes32) -> bool:
    return self.documents[doc_hash].timestamp != 0

# Hàm xem chữ ký của tài liệu
@view
@external
def getSignature(doc_hash: bytes32) -> String[256]:
    # Kiểm tra tài liệu tồn tại
    assert self.documents[doc_hash].timestamp != 0, "Tai lieu khong ton tai"
    return self.documents[doc_hash].signature

# Hàm xem chủ sở hữu và timestamp của tài liệu
@view
@external
def getDocumentInfo(doc_hash: bytes32) -> (address, uint256):
    doc: Document = self.documents[doc_hash]
    assert doc.timestamp != 0, "Tai lieu khong ton tai"
    return (doc.owner, doc.timestamp)

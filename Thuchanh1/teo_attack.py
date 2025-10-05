from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.asymmetric import padding
from cryptography.hazmat.primitives import serialization

# --- Load public key (công khai của Tý) ---
with open("ty.pub", "rb") as f:
    public_key = serialization.load_pem_public_key(f.read())

# --- Giả mạo thông điệp ---
tampered_message = b"Ty hates cat"

# --- Load chữ ký thật của Tý (đã ký trên "Ty likes cat") ---
with open("message.sig", "rb") as f:
    signature = f.read()

# --- Thử xác minh chữ ký ---
print("🔒 Tèo đang cố xác minh thông điệp đã bị sửa...")
try:
    public_key.verify(
        signature,
        tampered_message,
        padding.PSS(
            mgf=padding.MGF1(hashes.SHA256()),
            salt_length=padding.PSS.MAX_LENGTH
        ),
        hashes.SHA256()
    )
    print("✅ Thành công (Tèo đã lừa được hệ thống!)")
except Exception as e:
    print("❌ Xác minh thất bại!")
    print("📛 Lý do:", e)

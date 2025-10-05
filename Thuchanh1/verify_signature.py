from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.asymmetric import padding
from cryptography.hazmat.primitives import serialization

MESSAGE = b"Ty likes cat"

# --- Load public key của Tý ---
with open("ty.pub", "rb") as f:
    public_key = serialization.load_pem_public_key(f.read())

# --- Load chữ ký ---
with open("message.sig", "rb") as f:
    signature = f.read()

# --- Kiểm tra ---
print("🔍 Đang xác minh xem có phải Tý đã ký thông điệp không...")
try:
    public_key.verify(
        signature,
        MESSAGE,
        padding.PSS(
            mgf=padding.MGF1(hashes.SHA256()),
            salt_length=padding.PSS.MAX_LENGTH
        ),
        hashes.SHA256()
    )
    print("✅ Đúng! Thông điệp 'Ty likes cat' được ký bởi Tý và không bị thay đổi.")
except Exception:
    print("❌ Sai! Đây KHÔNG phải là chữ ký hợp lệ từ Tý.")

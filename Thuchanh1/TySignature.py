import os
import binascii
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.asymmetric import padding, rsa
from cryptography.hazmat.primitives import serialization

# --- Configuration ---
# 👉 Chỉ để True lần đầu tiên để tạo khóa, sau đó nhớ đổi lại False
GENERATE_KEYS = False

PRIVATE_KEY_FILE = "ty.pem"
PUBLIC_KEY_FILE = "ty.pub"
SIGNATURE_FILE = "message.sig"

# --- The Message ---
# Đổi nội dung để thử kiểm tra xác minh (ví dụ: b"Ty hates cat")
MESSAGE = b"Ty likes cat"


def run_signature_process():
    # 1. TẠO HOẶC TẢI KHÓA
    if GENERATE_KEYS:
        print("--- Generating new RSA key pair ---")
        private_key = rsa.generate_private_key(
            public_exponent=65537,
            key_size=2048,
        )
        public_key = private_key.public_key()

        # Lưu private key
        with open(PRIVATE_KEY_FILE, "wb") as f:
            f.write(private_key.private_bytes(
                encoding=serialization.Encoding.PEM,
                format=serialization.PrivateFormat.PKCS8,
                encryption_algorithm=serialization.NoEncryption()
            ))
        print(f"✅ Private key saved to {PRIVATE_KEY_FILE}")

        # Lưu public key
        with open(PUBLIC_KEY_FILE, "wb") as f:
            f.write(public_key.public_bytes(
                encoding=serialization.Encoding.PEM,
                format=serialization.PublicFormat.SubjectPublicKeyInfo
            ))
        print(f"✅ Public key saved to {PUBLIC_KEY_FILE}")
    else:
        if not os.path.exists(PRIVATE_KEY_FILE) or not os.path.exists(PUBLIC_KEY_FILE):
            print("❌ Key files not found. Set GENERATE_KEYS = True and run once to create them.")
            return
        with open(PRIVATE_KEY_FILE, "rb") as f:
            private_key = serialization.load_pem_private_key(f.read(), password=None)
        with open(PUBLIC_KEY_FILE, "rb") as f:
            public_key = serialization.load_pem_public_key(f.read())
        print("🔑 Keys loaded successfully.")

    # 2. KÝ SỐ THÔNG ĐIỆP
    print(f"\n✍️ Signing message: '{MESSAGE.decode()}'")
    signature = private_key.sign(
        MESSAGE,
        padding.PSS(
            mgf=padding.MGF1(hashes.SHA256()),
            salt_length=padding.PSS.MAX_LENGTH
        ),
        hashes.SHA256()
    )
    with open(SIGNATURE_FILE, "wb") as f:
        f.write(signature)

    # In chữ ký ra màn hình ở dạng hex (dễ đọc)
    print("🔐 Signature (hex):")
    print(binascii.hexlify(signature).decode())
    print(f"💾 Signature saved to {SIGNATURE_FILE}")

    # 3. XÁC MINH CHỮ KÝ
    print("\n--- Verifying Signature ---")
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
        print("✅ SUCCESS: Signature is valid!")
        print("📜 The message is authentic and was signed by the owner of the private key.")
    except Exception as e:
        print("❌ FAILED: Verification failed!")
        print("📛 The message was tampered with OR signed by a different key.")
        print(f"Error: {e}")


if __name__ == "__main__":
    run_signature_process()

import os
import zipfile
import shutil

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
PAYLOAD_DIR = os.path.join(BASE_DIR, 'Payload')
APP_DIR = os.path.join(PAYLOAD_DIR, 'WinDock.app')
IPA_OUTPUT = os.path.join(BASE_DIR, 'WinDock_unsigned.ipa')

def package_local_ipa():
    print("[*] Packaging WinDock.ipa...")
    if os.path.exists(PAYLOAD_DIR):
        shutil.rmtree(PAYLOAD_DIR)
    os.makedirs(APP_DIR, exist_ok=True)

    # 1. Copy Info.plist
    shutil.copyfile(os.path.join(BASE_DIR, 'Info.plist'), os.path.join(APP_DIR, 'Info.plist'))

    # 2. Copy Web Assets
    web_dir = os.path.join(BASE_DIR, 'server', 'web')
    if os.path.exists(web_dir):
        for f in os.listdir(web_dir):
            src = os.path.join(web_dir, f)
            dst = os.path.join(APP_DIR, f)
            if os.path.isfile(src):
                shutil.copyfile(src, dst)

    # 3. Create zip with Payload
    with zipfile.ZipFile(IPA_OUTPUT, 'w', zipfile.ZIP_DEFLATED) as zipf:
        for root, dirs, files in os.walk(PAYLOAD_DIR):
            for file in files:
                full_path = os.path.join(root, file)
                rel_path = os.path.relpath(full_path, BASE_DIR)
                zipf.write(full_path, rel_path)

    # Clean up temp Payload
    shutil.rmtree(PAYLOAD_DIR)
    print(f"[✓] Successfully generated: {IPA_OUTPUT} ({os.path.getsize(IPA_OUTPUT)} bytes)")

if __name__ == '__main__':
    package_local_ipa()

#!/usr/bin/env bash
set -e

echo "========================================================"
echo "  RestartX27 — Android TWA Local Builder (Linux/macOS)"
echo "========================================================"

if [ ! -f "android.keystore" ]; then
  echo "[1/4] Generating android.keystore..."
  keytool -genkeypair -v \
    -keystore android.keystore \
    -alias restartx27 \
    -keyalg RSA -keysize 2048 -validity 10000 \
    -storepass "restartx27password" \
    -keypass "restartx27password" \
    -dname "CN=Eliyas Hossain Anik, OU=RestartX27, O=RestartX27, L=Dhaka, S=Dhaka, C=BD"
fi

echo ""
echo "[2/4] Your SHA-256 Fingerprint (Put this in /.well-known/assetlinks.json):"
echo "--------------------------------------------------------"
keytool -list -v -keystore android.keystore -alias restartx27 -storepass "restartx27password" | grep "SHA256:"
echo "--------------------------------------------------------"
echo ""

echo "[3/4] Installing @bubblewrap/cli..."
npm install -g @bubblewrap/cli

echo "[4/4] Building Android TWA APK & AAB..."
export BUBBLEWRAP_KEYSTORE_PASSWORD="restartx27password"
export BUBBLEWRAP_KEY_PASSWORD="restartx27password"
bubblewrap update
bubblewrap build --skipPwaValidation

echo "========================================================"
echo "  DONE! Generated app-release-signed.apk & app-release-bundle.aab"
echo "========================================================"

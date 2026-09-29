@echo off
echo ========================================================
echo   RestartX27 — Android TWA Local Builder (Windows)
echo ========================================================
echo.

where keytool >nul 2>nul
if %errorlevel% neq 0 (
  echo [!] Java JDK (keytool) paowa jayni! Age JDK 17 install koro.
  pause
  exit /b 1
)

if not exist "android.keystore" (
  echo [1/4] Generating android.keystore...
  keytool -genkeypair -v -keystore android.keystore -alias restartx27 -keyalg RSA -keysize 2048 -validity 10000 -storepass restartx27password -keypass restartx27password -dname "CN=Eliyas Hossain Anik, OU=RestartX27, O=RestartX27, L=Dhaka, S=Dhaka, C=BD"
) else (
  echo [1/4] Using existing android.keystore...
)

echo.
echo [2/4] Extracting SHA-256 Fingerprint (Copy this to assetlinks.json!):
echo --------------------------------------------------------
keytool -list -v -keystore android.keystore -alias restartx27 -storepass restartx27password | findstr /C:"SHA256:"
echo --------------------------------------------------------
echo.

echo [3/4] Installing @bubblewrap/cli...
call npm install -g @bubblewrap/cli

echo [4/4] Building Android TWA APK ^& AAB...
set BUBBLEWRAP_KEYSTORE_PASSWORD=restartx27password
set BUBBLEWRAP_KEY_PASSWORD=restartx27password
call bubblewrap update
call bubblewrap build --skipPwaValidation

echo.
echo ========================================================
echo   DONE! Check app-release-signed.apk ^& app-release-bundle.aab
echo ========================================================
pause

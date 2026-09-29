# 🚀 RestartX27 — Complete Android TWA Guide (Bangla)

তোর **RestartX27 (`restartx27.netlify.app`)** প্রজেক্টটিকে ১০০% প্রোপার **Android TWA (Trusted Web Activity)** বানানোর জন্য সব ফাইল এখানে রেডি করে দেওয়া হয়েছে।

---

## ✅ আমরা তোর ওয়েব অ্যাপে কী কী TWA ফিক্স করেছি?

1. **TWA Cold-Start Redirect Bug Fix (`index.html`)**:
   আগে নতুন ইউজারদের ক্ষেত্রে `!isStandalone && !hasSession` চেক করে `/landing.html`-এ পাঠিয়ে দিত। কিন্তু Android TWA-তে প্রথমবার ওপেন হওয়ার সময় `android-app://` referrer বা `?twa=1` থাকে। আমরা `r27IsTWA()` ও `r27IsInstalledApp()` আপডেট করেছি যাতে TWA অ্যাপের ভেতরে কখনোই ভুল করে মার্কেটিং ল্যান্ডিং পেজে না যায়, সরাসরি অ্যাপ/লগইন স্ক্রিনে যায়।
2. **Android Hardware Back Button Support (`index.html`)**:
   আগে ফোনের Back বাটন চাপলে যেকোনো পেজ (Analytics, Clan, Routine, Sky) বা Modal খোলা থাকা অবস্থায় পুরো অ্যাপ বন্ধ হয়ে যেত! এখন:
   - কোনো Modal বা Sidebar খোলা থাকলে Back বাটনে সেটা বন্ধ হবে।
   - অন্য পেজে থাকলে Back চাপলে `Focus Timer` পেজে ফিরে আসবে।
   - `Focus Timer` পেজে থাকলে **"আবার Back চাপলে অ্যাপ বন্ধ হবে"** (Double-back to exit) দেখাবে।
3. **Digital Asset Links (`/.well-known/assetlinks.json` + `_headers` + `netlify.toml`)**:
   উপরের Chrome Address Bar (URL bar) হাইড করার জন্য এবং Google Sign-In (`Continue with Google`) সরাসরি TWA-এর ভেতরে কাজ করানোর জন্য `/.well-known/assetlinks.json` এবং সঠিক CORS/Content-Type হেডার যুক্ত করা হয়েছে।
4. **Upgraded `manifest.json` + App Shortcuts**:
   অ্যাপ আইকনে লং-প্রেস করলে সরাসরি **Focus Timer**, **My Clan**, **Analytics**, এবং **Comeback Sky**-তে যাওয়ার শর্টকাট যোগ করা হয়েছে।

---

## 🛠️ ধাপ ১: Netlify-তে আপডেট করা ওয়েবসাইট ডিপ্লয় কর

1. **`restartx27-netlify-twa-ready.zip`** ফাইলটা আনজিপ কর।
2. Netlify-তে তোর `restartx27.netlify.app` সাইটে এই ফাইলগুলো আপলোড/ডিপ্লয় কর।
3. চেক কর যে `https://restartx27.netlify.app/.well-known/assetlinks.json` লিংকে গেলে JSON দেখাচ্ছে।

---

## 📱 ধাপ ২: APK এবং AAB ফাইল বানানোর ২টা সহজ উপায়

### উপায় A: PWABuilder দিয়ে ১ মিনিটে APK/AAB জেনারেট (সবচেয়ে সহজ, কোনো ইনস্টল লাগবে না)
1. [https://www.pwabuilder.com](https://www.pwabuilder.com) ওয়েবসাইটে যা এবং `https://restartx27.netlify.app` লিখে **Start** দে।
2. **Package for stores** → **Android** → **Generate Package** এ ক্লিক কর।
3. সেটিংসে:
   - **Package ID**: `com.eliyas.restartx27`
   - **App name**: `RestartX27`
   - **Start URL**: `/?twa=1`
   - **Signing Key**: `Create new` সিলেক্ট করে ডাউনলোড কর।
4. ডাউনলোড করা জিপের ভেতরে:
   - **`.apk`** এবং **`.aab`** ফাইল পাবি।
   - সাথে একটা **`assetlinks.json`** ফাইল পাবি—ওটার ভেতরের `sha256_cert_fingerprints` কোডটা কপি করে তোর Netlify সাইটের `/.well-known/assetlinks.json` ফাইলে বসিয়ে আবার ডিপ্লয় দিলেই উপরের ব্রাউজার বার আজীবনের জন্য গায়েব হয়ে যাবে!

### উপায় B: GitHub Actions দিয়ে অটোমেটিক ক্লাউড বিল্ড (এই প্রজেক্ট জিপ দিয়ে)
1. **`restartx27-android-twa-builder.zip`** আনজিপ করে একটা নতুন GitHub Repository-তে আপলোড কর।
2. GitHub Repo-এর **Actions** ট্যাবে গিয়ে `Build RestartX27 Android TWA (APK + AAB)` ওয়ার্কফ্লো রান কর।
3. ২ মিনিটের মধ্যে GitHub নিজেই `app-release-signed.apk`, `app-release-bundle.aab`, `android.keystore`, এবং রেডিমেড `assetlinks.json` (SHA-256 সহ) জেনারেট করে দেবে!

### উপায় C: তোর পিসিতে Bubblewrap CLI দিয়ে বিল্ড
- Windows পিসিতে `build-twa-windows.bat` ডাবল-ক্লিক কর (অথবা টার্মিনালে `./build-twa-mac-linux.sh` চালা)।

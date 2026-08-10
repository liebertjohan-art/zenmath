# AGENTS.md

## 📌 Project Overview
- ZenMath — Maths practice and learning app with progress tracking, evaluation and growth
- Package name: `com.akashiverse.zenmath`
- Flutter version: 3.44.0 (stable channel, cloud builds only)
- Fully offline app — no internet required at runtime

## 🚨 CRITICAL RULES
1. **NEVER run `flutter` commands locally** — no `flutter run`, `flutter build`, `flutter test`, etc.
2. **NEVER run `dart` commands locally**.
3. **Build process is 100% cloud-based** via GitHub Actions CI/CD.
4. **Only `adb` is available locally** for installing APKs on the device.
5. **Only `git` and `gh` CLI are available** for pushing code and managing releases.

## 🛠️ Development & Build Workflow
```
+---------------------+        +--------------------+        +---------------------+
| Local Development   |  --->  | GitHub Repository  |  --->  | GitHub Actions CI   |
| (Code in lib/)      |        | (git push)         |        | (Cloud APK Build)   |
+---------------------+        +--------------------+        +---------------------+
                                                                        |
+---------------------+        +--------------------+                   v
| Local Device        |  <---  | Release APK        |  <---  +---------------------+
| (adb install)       |        | (gh download)      |        | GitHub Release Asset|
+---------------------+        +--------------------+        +---------------------+
```

### 1. Code & Push
Write/edit code in `lib/` directory, then push:
```bash
git add . && git commit -m "Your message" && git push origin main
```

### 2. Monitor Cloud Build
The push auto-triggers the `.github/workflows/build-release.yml` pipeline.
```bash
gh run list -L 1   # Get latest run ID
gh run watch <run_id> --exit-status
```
*(If a build fails, inspect it with: `gh run view <run_id> --log-failed`)*

### 3. Automated Download & Install
Once the build is successful:
```bash
./update_app.sh
```

## 🔍 Troubleshooting
- **`INSTALL_FAILED_UPDATE_INCOMPATIBLE`**: Signature mismatch. Run `adb uninstall com.akashiverse.zenmath` then reinstall.
- **Launch App Manually via adb**:
  `adb shell monkey -p com.akashiverse.zenmath -c android.intent.category.LAUNCHER 1`

## 📁 Project Structure
```
lib/
└── main.dart              # App entry point
```

## ✅ Code Verification
Since we can't run tools locally, verify code by:
- Reading the code carefully for syntax errors
- Checking cross-file imports and type consistency
- Push and let CI catch any build errors

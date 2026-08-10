# ZenMath

Maths practice and learning app with progress tracking, evaluation and growth.

## Development Setup

This project uses **cloud-based builds** via GitHub Actions. No local Flutter SDK needed.

### Prerequisites
- `git` and `gh` (GitHub CLI) installed
- `adb` for installing APKs on your device

### Build & Install
1. Push code: `git add . && git commit -m "msg" && git push origin main`
2. Wait for GitHub Actions build to complete
3. Install: `./update_app.sh`

### Build Status
Check latest build: `gh run list -L 1`

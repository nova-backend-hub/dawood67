# WinDock 🚀

> **Apple-Style App Dock for iPhone to Launch Windows Applications over Wi-Fi**

WinDock turns your iPhone into a clean, smooth, Apple-aesthetic external application dock for your Windows PC. With a single tap, launch your favorite games, developer tools, browsers, and utilities on Windows.

---

## ✨ Features

- **Apple Smooth Aesthetic**: Clean Cupertino white frosted-glass theme (`#F2F4F7`), authentic squircle icons with smooth spring physics (`scale(0.88)` on active press), and haptic feedback.
- **Two Layout Modes**:
  1. **8 Apps Dock**: Squircles in an expansive grid with smooth animations.
  2. **4 Apps + Live Clock**: 4 primary quick-launch apps on the left, paired with an Apple StandBy-style digital clock widget on the right (live ticking seconds track, date, and PC connection badge).
- **Customizable App Selection**:
  - Choose which 4 or 8 apps you want on your dock directly from your iPhone!
  - **1-Tap Catalog Selection**: Google Chrome, Microsoft Edge, VS Code, Discord, Spotify, Steam, Windows Terminal, PowerShell, File Explorer, Task Manager, Calculator, Notepad, OBS Studio, Blender, Photoshop, Epic Games, Settings.
  - **Custom Executables**: Enter custom application names and `.exe` paths or commands.
- **Dual Deployment**:
  - **Automated GitHub Actions IPA**: Push to GitHub to automatically compile a native SwiftUI `WinDock_unsigned.ipa` using Xcode on macOS runners.
  - **Instant Web PWA**: Zero installation needed—open the server URL on iPhone Safari and tap **"Add to Home Screen"** to run full-screen immediately!

---

## ⚡ Quick Start

### 1. Start the Windows Server
In `WinDock/server/`:
- Double-click **`start_server.bat`** (or open terminal and run `py server.py`).
- The server will detect your local Wi-Fi IP (e.g. `192.168.135.83:5050`) and start listening for launch commands.

### 2. Connect from iPhone (Immediate Web App)
1. Open **Safari** on your iPhone (ensure your phone is connected to the same Wi-Fi as your PC).
2. Browse to `http://<YOUR-PC-IP>:5050` (e.g., `http://192.168.135.83:5050`).
3. Tap the **Share** button in Safari and select **"Add to Home Screen"**.
4. Launch **WinDock** from your iPhone home screen!

### 3. Build & Download the Native `.ipa` via GitHub
1. Create a repository on GitHub (e.g., `https://github.com/nova-backend-hub/WinDock`).
2. Push this directory:
   ```bash
   git remote add origin https://github.com/nova-backend-hub/WinDock.git
   git branch -M main
   git push -u origin main
   ```
3. GitHub Actions will trigger `.github/workflows/build.yml`.
4. Once completed (approx. 2 minutes), go to the **Actions** tab on GitHub, select the latest run, and download **`WinDock-unsigned-ipa`**.
5. Sideload the `.ipa` onto your iPhone using **AltStore**, **SideStore**, **TrollStore**, or **Sideloadly**.

---

## 🎯 How to Choose & Customize Apps on iPhone
- **Launch an App**: Simply tap any icon.
- **Customize a Slot**: Long-press any app icon (or tap the **Sliders/Settings** icon at top right) to open the **App Chooser**.
- Select any preset from the Windows App Catalog or type your own custom executable command.

# Dawood67 Remote (iOS .ipa)

Custom iOS Remote and App Launcher for Samsung Smart TV rooted with Vetro (`http://192.168.1.51:8099`).

---

## Features
- **Hardware Volume Buttons**: When on the app, pressing the iPhone's physical Volume Up/Down buttons sends `XF86AudioRaiseVolume` and `XF86AudioLowerVolume` directly to the TV.
- **Full TV Controls (34 Keys)**:
  - Navigation D-Pad: Up, Down, Left, Right, OK (Return)
  - Navigation Pills: Back, Home, Menu, Info, Exit
  - Audio & Power: Power, Mute, Source/Input, Volume + / -
  - TV Features: Channel Guide, Channel List
  - Media Controls: Play, Pause, Stop, Previous, Next, Rewind, Fast Forward
  - Number Pad: 0–9, Info, Back/Delete
- **Installed TV App Launcher**:
  - Live query to `/apps` (loads all 257+ installed apps on your TV: YouTube, TizenTube, Disney+, OSN+, Shahid, Dawood Files, etc.).
  - Search filter by app name.
  - Fetches app icons directly from Vetro (`/apps/icon?appId=...`).
- **Haptic Feedback**: High-quality tactile haptics on every button press.
- **Configurable Host**: Connects to `192.168.1.51:8099` by default, customizable in in-app settings.

---

## How to Build the `.ipa` via GitHub Actions

Because this app is written in native Swift & SwiftUI, building an iOS `.ipa` binary requires Apple's `xcodebuild` tool (available on macOS runners in GitHub Actions for free):

1. **Create a GitHub Repository**:
   - Go to [GitHub](https://github.com/new) and create a repository (e.g., `Dawood67Remote`).

2. **Push this Project to GitHub**:
   In PowerShell or terminal inside this folder:
   ```powershell
   cd C:\Users\dawoo\.gemini\antigravity\scratch\Dawood67Remote
   git init
   git add .
   git commit -m "Initial commit for Dawood67 Remote"
   git branch -M main
   git remote add origin https://github.com/<YOUR_USERNAME>/Dawood67Remote.git
   git push -u origin main
   ```

3. **Download the Compiled `.ipa`**:
   - Open your repository on GitHub.
   - Click the **Actions** tab.
   - You will see the **Build Dawood67 Remote IPA** workflow running.
   - Once completed (takes ~1-2 minutes), scroll down to **Artifacts** and download `Dawood67-remote-ipa` (which contains `Dawood67_remote.ipa`).

4. **Sideload via Sideloadly**:
   - Open **Sideloadly** on Windows.
   - Connect your iPhone via USB or Wi-Fi.
   - Drag & drop `Dawood67_remote.ipa` into Sideloadly.
   - Click **Start** to sign with your Apple ID and install on your phone.


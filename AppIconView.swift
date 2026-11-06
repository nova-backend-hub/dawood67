import SwiftUI

struct AppIconView: View {
    let iconKey: String
    var size: CGFloat = 68

    var body: some View {
        ZStack {
            switch iconKey.lowercased() {
            case "chrome":
                chromeIcon
            case "vscode":
                vscodeIcon
            case "discord":
                discordIcon
            case "spotify":
                spotifyIcon
            case "steam":
                steamIcon
            case "terminal":
                terminalIcon
            case "explorer":
                explorerIcon
            case "taskmgr":
                taskmgrIcon
            case "calc":
                calcIcon
            case "notepad":
                notepadIcon
            case "browser":
                browserIcon
            case "video":
                videoIcon
            case "cube":
                cubeIcon
            case "photo":
                photoIcon
            case "gear":
                gearIcon
            default:
                defaultIcon
            }
        }
        .frame(width: size, height: size)
        .clipShape(RoundedRectangle(cornerRadius: size * 0.28, style: .continuous))
        .shadow(color: Color.black.opacity(0.12), radius: 6, x: 0, y: 3)
    }

    // 1. Chrome
    private var chromeIcon: some View {
        ZStack {
            Color.white
            Circle()
                .trim(from: 0.0, to: 0.33)
                .stroke(Color(hex: "#EA4335"), lineWidth: size * 0.28)
                .rotationEffect(.degrees(-60))
            Circle()
                .trim(from: 0.0, to: 0.33)
                .stroke(Color(hex: "#FBBC05"), lineWidth: size * 0.28)
                .rotationEffect(.degrees(60))
            Circle()
                .trim(from: 0.0, to: 0.33)
                .stroke(Color(hex: "#34A853"), lineWidth: size * 0.28)
                .rotationEffect(.degrees(180))

            Circle()
                .fill(Color.white)
                .frame(width: size * 0.44, height: size * 0.44)

            Circle()
                .fill(Color(hex: "#4285F4"))
                .frame(width: size * 0.34, height: size * 0.34)
        }
    }

    // 2. VS Code
    private var vscodeIcon: some View {
        ZStack {
            Color(hex: "#1E1E1E")
            Image(systemName: "chevron.left.forwardslash.chevron.right")
                .font(.system(size: size * 0.38, weight: .bold))
                .foregroundColor(Color(hex: "#007ACC"))
        }
    }

    // 3. Discord
    private var discordIcon: some View {
        ZStack {
            Color(hex: "#5865F2")
            Image(systemName: "bubble.left.and.bubble.right.fill")
                .font(.system(size: size * 0.42, weight: .semibold))
                .foregroundColor(.white)
        }
    }

    // 4. Spotify
    private var spotifyIcon: some View {
        ZStack {
            Color(hex: "#1DB954")
            VStack(spacing: size * 0.06) {
                Capsule()
                    .fill(Color.black.opacity(0.85))
                    .frame(width: size * 0.52, height: size * 0.08)
                    .rotationEffect(.degrees(-4))
                Capsule()
                    .fill(Color.black.opacity(0.85))
                    .frame(width: size * 0.44, height: size * 0.075)
                    .rotationEffect(.degrees(-4))
                Capsule()
                    .fill(Color.black.opacity(0.85))
                    .frame(width: size * 0.34, height: size * 0.07)
                    .rotationEffect(.degrees(-4))
            }
        }
    }

    // 5. Steam
    private var steamIcon: some View {
        ZStack {
            RadialGradient(
                gradient: Gradient(colors: [Color(hex: "#1B2838"), Color(hex: "#111822")]),
                center: .topLeading,
                startRadius: 5,
                endRadius: size
            )
            Image(systemName: "gamecontroller.fill")
                .font(.system(size: size * 0.42))
                .foregroundColor(.white.opacity(0.92))
        }
    }

    // 6. Terminal
    private var terminalIcon: some View {
        ZStack {
            Color(hex: "#1E1E1E")
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 3) {
                    Circle().fill(Color(hex: "#FF5F56")).frame(width: 5, height: 5)
                    Circle().fill(Color(hex: "#FFBD2E")).frame(width: 5, height: 5)
                    Circle().fill(Color(hex: "#27C93F")).frame(width: 5, height: 5)
                }
                .padding(.bottom, 2)

                HStack(spacing: 2) {
                    Text(">_")
                        .font(.system(size: size * 0.36, weight: .heavy, design: .monospaced))
                        .foregroundColor(Color(hex: "#4AF626"))
                }
            }
        }
    }

    // 7. File Explorer
    private var explorerIcon: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "#FFD659"), Color(hex: "#F2A900")],
                startPoint: .top,
                endPoint: .bottom
            )
            Image(systemName: "folder.fill")
                .font(.system(size: size * 0.44))
                .foregroundColor(Color(hex: "#0078D4"))
        }
    }

    // 8. Task Manager
    private var taskmgrIcon: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "#0067B8"), Color(hex: "#002050")],
                startPoint: .top,
                endPoint: .bottom
            )
            Image(systemName: "waveform.path.ecg")
                .font(.system(size: size * 0.44, weight: .bold))
                .foregroundColor(Color(hex: "#00FF88"))
        }
    }

    // 9. Calculator
    private var calcIcon: some View {
        ZStack {
            Color(hex: "#FF9500")
            Image(systemName: "plus.forwardslash.minus")
                .font(.system(size: size * 0.42, weight: .bold))
                .foregroundColor(.white)
        }
    }

    // 10. Notepad
    private var notepadIcon: some View {
        ZStack {
            Color(hex: "#0078D4")
            Image(systemName: "note.text")
                .font(.system(size: size * 0.42, weight: .semibold))
                .foregroundColor(.white)
        }
    }

    // 11. Browser
    private var browserIcon: some View {
        ZStack {
            Color(hex: "#0078D7")
            Image(systemName: "globe")
                .font(.system(size: size * 0.42, weight: .semibold))
                .foregroundColor(.white)
        }
    }

    // 12. Video / OBS
    private var videoIcon: some View {
        ZStack {
            Color(hex: "#222222")
            Image(systemName: "video.fill")
                .font(.system(size: size * 0.4))
                .foregroundColor(.white)
        }
    }

    // 13. Cube / Blender
    private var cubeIcon: some View {
        ZStack {
            Color(hex: "#EA7600")
            Image(systemName: "cube.fill")
                .font(.system(size: size * 0.4))
                .foregroundColor(.white)
        }
    }

    // 14. Photo / Photoshop
    private var photoIcon: some View {
        ZStack {
            Color(hex: "#31A8FF")
            Image(systemName: "photo.fill")
                .font(.system(size: size * 0.4))
                .foregroundColor(.white)
        }
    }

    // 15. Gear / Settings
    private var gearIcon: some View {
        ZStack {
            Color(hex: "#4A4A4A")
            Image(systemName: "gear")
                .font(.system(size: size * 0.42))
                .foregroundColor(.white)
        }
    }

    private var defaultIcon: some View {
        ZStack {
            Color.white
            Image(systemName: "app.fill")
                .font(.system(size: size * 0.4))
                .foregroundColor(Color(hex: "#0071E3"))
        }
    }
}

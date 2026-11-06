import SwiftUI

struct DockApp: Identifiable, Codable, Equatable {
    var id: String
    var name: String
    var icon: String
    var command: String
    var colorHex: String
    var category: String

    var color: Color {
        Color(hex: colorHex)
    }

    // Default 8 apps for the dock
    static let defaultEight: [DockApp] = [
        DockApp(id: "chrome", name: "Chrome", icon: "chrome", command: "start chrome", colorHex: "#4285F4", category: "Browser"),
        DockApp(id: "vscode", name: "VS Code", icon: "vscode", command: "code", colorHex: "#007ACC", category: "Dev"),
        DockApp(id: "discord", name: "Discord", icon: "discord", command: "start discord:", colorHex: "#5865F2", category: "Social"),
        DockApp(id: "spotify", name: "Spotify", icon: "spotify", command: "start spotify:", colorHex: "#1DB954", category: "Music"),
        DockApp(id: "steam", name: "Steam", icon: "steam", command: "start steam:", colorHex: "#171A21", category: "Gaming"),
        DockApp(id: "terminal", name: "Terminal", icon: "terminal", command: "wt", colorHex: "#1F2430", category: "Tools"),
        DockApp(id: "explorer", name: "Explorer", icon: "explorer", command: "explorer", colorHex: "#F3B300", category: "System"),
        DockApp(id: "taskmgr", name: "Task Manager", icon: "taskmgr", command: "taskmgr", colorHex: "#00A4EF", category: "System")
    ]

    // Rich catalog of Windows apps user can choose from
    static let catalog: [DockApp] = [
        DockApp(id: "chrome", name: "Google Chrome", icon: "chrome", command: "start chrome", colorHex: "#4285F4", category: "Browser"),
        DockApp(id: "edge", name: "Microsoft Edge", icon: "browser", command: "start msedge", colorHex: "#0078D7", category: "Browser"),
        DockApp(id: "vscode", name: "VS Code", icon: "vscode", command: "code", colorHex: "#007ACC", category: "Dev"),
        DockApp(id: "discord", name: "Discord", icon: "discord", command: "start discord:", colorHex: "#5865F2", category: "Social"),
        DockApp(id: "spotify", name: "Spotify", icon: "spotify", command: "start spotify:", colorHex: "#1DB954", category: "Music"),
        DockApp(id: "steam", name: "Steam", icon: "steam", command: "start steam:", colorHex: "#171A21", category: "Gaming"),
        DockApp(id: "terminal", name: "Terminal", icon: "terminal", command: "wt", colorHex: "#1F2430", category: "Tools"),
        DockApp(id: "powershell", name: "PowerShell", icon: "terminal", command: "powershell", colorHex: "#012456", category: "Tools"),
        DockApp(id: "explorer", name: "File Explorer", icon: "explorer", command: "explorer", colorHex: "#F3B300", category: "System"),
        DockApp(id: "taskmgr", name: "Task Manager", icon: "taskmgr", command: "taskmgr", colorHex: "#00A4EF", category: "System"),
        DockApp(id: "calc", name: "Calculator", icon: "calc", command: "calc", colorHex: "#FF9500", category: "Tools"),
        DockApp(id: "notepad", name: "Notepad", icon: "notepad", command: "notepad", colorHex: "#0078D4", category: "Tools"),
        DockApp(id: "obs", name: "OBS Studio", icon: "video", command: "start obs64", colorHex: "#222222", category: "Media"),
        DockApp(id: "blender", name: "Blender", icon: "cube", command: "blender", colorHex: "#EA7600", category: "3D/Design"),
        DockApp(id: "photoshop", name: "Photoshop", icon: "photo", command: "start photoshop", colorHex: "#31A8FF", category: "3D/Design"),
        DockApp(id: "epic", name: "Epic Games", icon: "steam", command: "start com.epicgames.launcher:", colorHex: "#2A2A2A", category: "Gaming"),
        DockApp(id: "settings", name: "Windows Settings", icon: "gear", command: "start ms-settings:", colorHex: "#4A4A4A", category: "System")
    ]
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

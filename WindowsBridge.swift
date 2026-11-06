import Foundation
import SwiftUI
import Combine

class WindowsBridge: ObservableObject {
    @Published var serverHost: String {
        didSet {
            UserDefaults.standard.set(serverHost, forKey: "windock_server_host")
            checkStatus()
        }
    }
    @Published var isConnected: Bool = false
    @Published var pcHostname: String = "Windows PC"
    @Published var toastMessage: String? = nil
    @Published var isLaunching: Bool = false

    private var cancellables = Set<AnyCancellable>()
    private var healthTimer: AnyCancellable?

    init() {
        self.serverHost = UserDefaults.standard.string(forKey: "windock_server_host") ?? "192.168.135.83:5050"
        checkStatus()

        // Periodically poll server status
        healthTimer = Timer.publish(every: 6.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.checkStatus()
            }
    }

    var serverURL: URL? {
        let clean = serverHost.trimmingCharacters(in: .whitespacesAndNewlines)
        if clean.starts(with: "http://") || clean.starts(with: "https://") {
            return URL(string: clean)
        }
        return URL(string: "http://\(clean)")
    }

    func checkStatus() {
        guard let base = serverURL, let url = URL(string: "/api/status", relativeTo: base) else {
            DispatchQueue.main.async { self.isConnected = false }
            return
        }

        var req = URLRequest(url: url)
        req.timeoutInterval = 3.0

        URLSession.shared.dataTask(with: req) { [weak self] data, res, err in
            DispatchQueue.main.async {
                if let data = data, let obj = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    self?.isConnected = (obj["status"] as? String) == "online"
                    if let host = obj["hostname"] as? String {
                        self?.pcHostname = host
                    }
                } else {
                    self?.isConnected = false
                }
            }
        }.resume()
    }

    func launch(app: DockApp) {
        // Trigger medium haptic impact
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.prepare()
        impact.impactOccurred()

        self.showToast("Launching \(app.name) on PC...")

        guard let base = serverURL, let url = URL(string: "/api/launch", relativeTo: base) else {
            self.showToast("⚠️ Invalid server URL: \(serverHost)")
            return
        }

        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        req.timeoutInterval = 4.0

        let payload: [String: String] = [
            "id": app.id,
            "command": app.command,
            "name": app.name
        ]

        req.httpBody = try? JSONSerialization.data(withJSONObject: payload)

        URLSession.shared.dataTask(with: req) { [weak self] data, res, err in
            DispatchQueue.main.async {
                if err != nil {
                    self?.isConnected = false
                    self?.showToast("⚠️ PC unreachable at \(self?.serverHost ?? "")")
                    return
                }

                if let httpRes = res as? HTTPURLResponse, httpRes.statusCode == 200 {
                    self?.isConnected = true
                    self?.showToast("✓ Opened \(app.name)")
                } else {
                    self?.showToast("⚠️ Failed to launch")
                }
            }
        }.resume()
    }

    func showToast(_ msg: String) {
        withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
            self.toastMessage = msg
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
            if self.toastMessage == msg {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                    self.toastMessage = nil
                }
            }
        }
    }
}

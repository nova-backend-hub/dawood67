import Foundation
import Combine
import SwiftUI

struct TVApp: Identifiable, Codable {
    var id: String { appId }
    let appId: String
    let packageId: String?
    let name: String?
    let show: Bool?
    let disabled: Bool?
    let iconPath: String?
    let area: String?
    let system: Bool?
    let removable: Bool?
    let role: String?
}

struct AppsResponse: Codable {
    let apps: [TVApp]
}

final class VetroService: ObservableObject {
    @Published var host: String {
        didSet {
            UserDefaults.standard.set(host, forKey: "vetro_host")
        }
    }
    
    @Published var isConnected: Bool = false
    @Published var apps: [TVApp] = []
    @Published var statusMessage: String = "Ready"
    @Published var lastPressedKey: String? = nil
    
    init() {
        self.host = UserDefaults.standard.string(forKey: "vetro_host") ?? "192.168.1.51:8099"
        checkConnection()
        fetchApps()
    }
    
    var baseURL: String {
        let clean = host.trimmingCharacters(in: .whitespacesAndNewlines)
        if clean.starts(with: "http://") || clean.starts(with: "https://") {
            return clean
        }
        return "http://\(clean)"
    }
    
    func checkConnection() {
        guard let url = URL(string: "\(baseURL)/status") else { return }
        var request = URLRequest(url: url)
        request.timeoutInterval = 3
        
        URLSession.shared.dataTask(with: request) { [weak self] _, response, error in
            DispatchQueue.main.async {
                if let http = response as? HTTPURLResponse, http.statusCode == 200 {
                    self?.isConnected = true
                } else {
                    self?.isConnected = false
                }
            }
        }.resume()
    }
    
    func sendKey(_ key: String) {
        guard let url = URL(string: "\(baseURL)/control") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 2.5
        
        let body = ["key": key]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        DispatchQueue.main.async {
            self.lastPressedKey = key
            self.triggerHaptic()
        }
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.statusMessage = "Error: \(error.localizedDescription)"
                    self?.isConnected = false
                } else if let http = response as? HTTPURLResponse, http.statusCode == 200 {
                    self?.isConnected = true
                    self?.statusMessage = "Sent \(key)"
                }
            }
        }.resume()
    }
    
    func launchApp(appId: String, name: String) {
        guard let url = URL(string: "\(baseURL)/apps/launch") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 4
        
        let body = ["appId": appId]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        triggerHaptic()
        
        URLSession.shared.dataTask(with: request) { [weak self] _, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.statusMessage = "Launch error: \(error.localizedDescription)"
                } else {
                    self?.statusMessage = "Opened \(name)"
                }
            }
        }.resume()
    }
    
    func fetchApps() {
        guard let url = URL(string: "\(baseURL)/apps") else { return }
        var request = URLRequest(url: url)
        request.timeoutInterval = 5
        
        URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let res = try JSONDecoder().decode(AppsResponse.self, from: data)
                
                // Keep only important, real user applications (exclude internal services, background components, and system processes)
                let important = res.apps.filter { app in
                    let isVisible = (app.show ?? false) && !(app.disabled ?? false)
                    guard isVisible else { return false }
                    
                    let id = app.appId.lowercased()
                    let name = (app.name ?? "").lowercased()
                    
                    // Filter out known internal diagnostic / system helpers
                    if id.hasPrefix("com.samsung.tv.coba") ||
                       id.contains("service") ||
                       id.contains("oobe") ||
                       id.contains("csaccount") ||
                       id.contains("csbilling") ||
                       id.contains("diagnosis") ||
                       id.contains("safcommon") ||
                       id.contains("qsymphony") ||
                       id.contains("plugin") ||
                       id.contains("indicator") ||
                       name.contains("emanual") ||
                       name.contains("guide") && id.contains("25emanual") ||
                       name.contains("promotion") {
                        return false
                    }
                    
                    // Keep media area apps or removable user installed apps
                    return app.area == "media" || (app.removable == true && app.system == false)
                }
                
                // Deduplicate by display name
                var uniqueApps: [TVApp] = []
                var seenNames = Set<String>()
                for app in important {
                    let display = app.name ?? app.appId
                    if !seenNames.contains(display) {
                        seenNames.insert(display)
                        uniqueApps.append(app)
                    }
                }
                
                let sorted = uniqueApps.sorted {
                    ($0.name ?? $0.appId).localizedCaseInsensitiveCompare($1.name ?? $1.appId) == .orderedAscending
                }
                
                DispatchQueue.main.async {
                    self?.apps = sorted
                    self?.isConnected = true
                }
            } catch {
                print("Decoding apps error: \(error)")
            }
        }.resume()
    }
    
    private func triggerHaptic() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
    }
}

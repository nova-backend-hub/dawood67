import SwiftUI

enum DockMode {
    case eightApps
    case fourAppsClock
}

struct ContentView: View {
    @StateObject private var bridge = WindowsBridge()
    @State private var mode: DockMode = .eightApps
    @State private var apps: [DockApp] = []
    @State private var pressedAppId: String? = nil
    
    // Customization Sheet States
    @State private var showSettings = false
    @State private var selectedSlotToEdit: Int? = nil
    @State private var tempServerHost = ""
    @State private var customAppName = ""
    @State private var customAppCommand = ""
    @State private var customAppIcon = "terminal"

    var body: some View {
        ZStack {
            // Apple Light Frosted Background
            Color(hex: "#F2F4F7")
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Top Control Bar
                topBar
                    .padding(.horizontal, 24)
                    .padding(.top, 14)
                    .padding(.bottom, 16)

                Spacer()

                // Main Content Stage
                Group {
                    switch mode {
                    case .eightApps:
                        eightAppsDock
                            .transition(.asymmetric(
                                insertion: .scale(scale: 0.95).combined(with: .opacity),
                                removal: .scale(scale: 0.95).combined(with: .opacity)
                            ))
                    case .fourAppsClock:
                        fourAppsClockDock
                            .transition(.asymmetric(
                                insertion: .scale(scale: 0.95).combined(with: .opacity),
                                removal: .scale(scale: 0.95).combined(with: .opacity)
                            ))
                    }
                }
                .animation(.spring(response: 0.4, dampingFraction: 0.75), value: mode)
                .padding(.horizontal, 20)

                Spacer()

                // Bottom Hint
                HStack(spacing: 6) {
                    Image(systemName: "hand.tap")
                        .font(.system(size: 11))
                    Text("Tip: Tap to launch on Windows • Long-press to change app")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                }
                .foregroundColor(Color(hex: "#86868B"))
                .padding(.bottom, 12)
            }

            // Bottom Toast Pill
            if let toast = bridge.toastMessage {
                VStack {
                    Spacer()
                    HStack(spacing: 8) {
                        Text("🚀")
                        Text(toast)
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(
                        Capsule()
                            .fill(Color(hex: "#1D1D1F").opacity(0.92))
                            .shadow(color: Color.black.opacity(0.2), radius: 14, x: 0, y: 6)
                    )
                    .padding(.bottom, 24)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
        .onAppear {
            loadSavedApps()
        }
        .sheet(isPresented: $showSettings) {
            settingsAndAppChooserSheet
        }
        .sheet(item: Binding<SlotWrapper?>(
            get: { selectedSlotToEdit.map { SlotWrapper(slot: $0) } },
            set: { selectedSlotToEdit = $0?.slot }
        )) { wrapper in
            singleSlotPickerSheet(slotIndex: wrapper.slot)
        }
    }

    // Top Bar
    private var topBar: some View {
        HStack {
            // Status Pill
            Button(action: {
                tempServerHost = bridge.serverHost
                showSettings = true
            }) {
                HStack(spacing: 7) {
                    Circle()
                        .fill(bridge.isConnected ? Color(hex: "#34C759") : Color(hex: "#FF3B30"))
                        .frame(width: 8, height: 8)
                        .shadow(color: bridge.isConnected ? Color(hex: "#34C759").opacity(0.6) : Color.clear, radius: 4)

                    Text(bridge.isConnected ? "Connected to PC" : "Connecting...")
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                        .foregroundColor(Color(hex: "#1D1D1F"))
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 7)
                .background(
                    Capsule()
                        .fill(Color.white.opacity(0.9))
                        .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
                )
            }

            Spacer()

            // Mode Switcher (8 Apps vs 4 Apps + Clock)
            HStack(spacing: 2) {
                modeButton(title: "8 Apps", target: .eightApps)
                modeButton(title: "4 Apps + Clock", target: .fourAppsClock)
            }
            .padding(3)
            .background(
                Capsule()
                    .fill(Color.black.opacity(0.06))
            )

            Spacer()

            // Settings & Customizer Button
            Button(action: {
                tempServerHost = bridge.serverHost
                showSettings = true
            }) {
                Image(systemName: "slider.horizontal.3")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(Color(hex: "#1D1D1F"))
                    .frame(width: 36, height: 36)
                    .background(
                        Circle()
                            .fill(Color.white.opacity(0.9))
                            .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
                    )
            }
        }
    }

    private func modeButton(title: String, target: DockMode) -> some View {
        Button(action: {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                mode = target
            }
        }) {
            Text(title)
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundColor(mode == target ? Color(hex: "#1D1D1F") : Color(hex: "#86868B"))
                .padding(.horizontal, 14)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(mode == target ? Color.white : Color.clear)
                        .shadow(color: mode == target ? Color.black.opacity(0.08) : Color.clear, radius: 4, x: 0, y: 2)
                )
        }
    }

    // Mode 1: 8 Apps Dock
    private var eightAppsDock: some View {
        VStack {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: 4), spacing: 22) {
                ForEach(Array(apps.prefix(8).enumerated()), id: \.element.id) { index, app in
                    appButton(app: app, slotIndex: index)
                }
            }
            .padding(26)
            .background(
                RoundedRectangle(cornerRadius: 36, style: .continuous)
                    .fill(Color.white.opacity(0.78))
                    .shadow(color: Color.black.opacity(0.07), radius: 24, x: 0, y: 12)
            )
        }
        .frame(maxWidth: 580)
    }

    // Mode 2: 4 Apps + Clock Dock
    private var fourAppsClockDock: some View {
        HStack(spacing: 20) {
            // Left 4 Apps Dock
            HStack(spacing: 16) {
                ForEach(Array(apps.prefix(4).enumerated()), id: \.element.id) { index, app in
                    appButton(app: app, slotIndex: index)
                }
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 20)
            .background(
                RoundedRectangle(cornerRadius: 32, style: .continuous)
                    .fill(Color.white.opacity(0.78))
                    .shadow(color: Color.black.opacity(0.07), radius: 20, x: 0, y: 10)
            )

            // Right Clock Widget
            ClockWidgetView(pcHostname: bridge.pcHostname)
        }
        .frame(maxWidth: 680)
    }

    // App Button with tap to launch & long-press to edit
    private func appButton(app: DockApp, slotIndex: Int) -> some View {
        VStack(spacing: 8) {
            AppIconView(iconKey: app.icon, size: 68)
                .scaleEffect(pressedAppId == app.id ? 0.88 : 1.0)
                .animation(.spring(response: 0.28, dampingFraction: 0.62), value: pressedAppId)

            Text(app.name)
                .font(.system(size: 13, weight: .medium, design: .rounded))
                .foregroundColor(Color(hex: "#1D1D1F"))
                .lineLimit(1)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            pressedAppId = app.id
            bridge.launch(app: app)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                pressedAppId = nil
            }
        }
        .onLongPressGesture(minimumDuration: 0.5) {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            selectedSlotToEdit = slotIndex
        }
    }

    // App Chooser & Settings Modal
    private var settingsAndAppChooserSheet: some View {
        NavigationView {
            Form {
                Section(header: Text("Windows PC Server Address")) {
                    HStack {
                        TextField("e.g. 192.168.1.100:5050", text: $tempServerHost)
                            .keyboardType(.numbersAndPunctuation)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)

                        Button("Connect") {
                            bridge.serverHost = tempServerHost
                            showSettings = false
                        }
                        .font(.system(.body, design: .rounded).bold())
                    }
                    Text("Ensure your iPhone and Windows PC are on the same Wi-Fi network.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Section(header: Text("Dock Slots (Tap any slot to choose a Windows app)")) {
                    ForEach(0..<8, id: \.self) { idx in
                        let app = (idx < apps.count) ? apps[idx] : DockApp.defaultEight[idx]
                        Button(action: {
                            selectedSlotToEdit = idx
                        }) {
                            HStack {
                                Text("Slot \(idx + 1)")
                                    .font(.system(size: 12, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 3)
                                    .background(Capsule().fill(idx < 4 ? Color.blue : Color.gray))

                                AppIconView(iconKey: app.icon, size: 38)
                                    .padding(.leading, 4)

                                VStack(alignment: .leading, spacing: 2) {
                                    Text(app.name)
                                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                                        .foregroundColor(Color(hex: "#1D1D1F"))

                                    Text(app.command)
                                        .font(.system(size: 12, design: .monospaced))
                                        .foregroundColor(.secondary)
                                }

                                Spacer()

                                Image(systemName: "chevron.right")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }

                Section {
                    Button("Reset to Default 8 Apps") {
                        apps = DockApp.defaultEight
                        saveApps()
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle("Configure WinDock")
            .navigationBarItems(trailing: Button("Done") {
                showSettings = false
            })
        }
    }

    // Single Slot Picker Sheet: Choose from catalog or enter custom
    private func singleSlotPickerSheet(slotIndex: Int) -> some View {
        let currentApp = (slotIndex < apps.count) ? apps[slotIndex] : DockApp.defaultEight[slotIndex]
        return NavigationView {
            List {
                Section(header: Text("Currently in Slot \(slotIndex + 1)")) {
                    HStack {
                        AppIconView(iconKey: currentApp.icon, size: 44)
                        VStack(alignment: .leading) {
                            Text(currentApp.name).font(.headline)
                            Text(currentApp.command).font(.caption).foregroundColor(.secondary)
                        }
                    }
                }

                Section(header: Text("Choose from Popular Windows Apps")) {
                    ForEach(DockApp.catalog) { catalogApp in
                        Button(action: {
                            assignAppToSlot(slotIndex: slotIndex, app: catalogApp)
                            selectedSlotToEdit = nil
                        }) {
                            HStack {
                                AppIconView(iconKey: catalogApp.icon, size: 36)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(catalogApp.name)
                                        .font(.system(size: 15, weight: .semibold))
                                        .foregroundColor(.primary)
                                    Text(catalogApp.command)
                                        .font(.system(size: 11, design: .monospaced))
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                if catalogApp.name == currentApp.name {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                    }
                }

                Section(header: Text("Or Add Custom Windows Executable")) {
                    TextField("App Name (e.g. MyGame)", text: $customAppName)
                    TextField("Command (e.g. C:\\Games\\app.exe)", text: $customAppCommand)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)

                    Button("Assign Custom App") {
                        if !customAppName.isEmpty && !customAppCommand.isEmpty {
                            let custom = DockApp(
                                id: UUID().uuidString,
                                name: customAppName,
                                icon: "terminal",
                                command: customAppCommand,
                                colorHex: "#0071E3",
                                category: "Custom"
                            )
                            assignAppToSlot(slotIndex: slotIndex, app: custom)
                            customAppName = ""
                            customAppCommand = ""
                            selectedSlotToEdit = nil
                        }
                    }
                    .font(.headline)
                    .disabled(customAppName.isEmpty || customAppCommand.isEmpty)
                }
            }
            .navigationTitle("Choose App for Slot \(slotIndex + 1)")
            .navigationBarItems(trailing: Button("Cancel") {
                selectedSlotToEdit = nil
            })
        }
    }

    private func assignAppToSlot(slotIndex: Int, app: DockApp) {
        if slotIndex < apps.count {
            apps[slotIndex] = app
        } else {
            apps.append(app)
        }
        saveApps()
    }

    private func saveApps() {
        if let data = try? JSONEncoder().encode(apps) {
            UserDefaults.standard.set(data, forKey: "windock_custom_apps")
        }
    }

    private func loadSavedApps() {
        if let data = UserDefaults.standard.data(forKey: "windock_custom_apps"),
           let saved = try? JSONDecoder().decode([DockApp].self, from: data) {
            self.apps = saved
        } else {
            self.apps = DockApp.defaultEight
        }
    }
}

// Wrapper for sheet binding
struct SlotWrapper: Identifiable {
    let slot: Int
    var id: Int { slot }
}

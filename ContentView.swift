import SwiftUI

struct RemoteKeyModel: Identifiable {
    var id: String { key }
    let key: String
    let label: String
    let systemImage: String?
    let color: Color
}

struct ContentView: View {
    @StateObject private var vetro = VetroService()
    @StateObject private var volumeHandler = VolumeButtonHandler()
    
    @State private var selectedTab: Int = 0
    @State private var showingSettings: Bool = false
    @State private var appSearchQuery: String = ""
    
    var body: some View {
        ZStack {
            Color(red: 0.03, green: 0.05, blue: 0.12).ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                headerBar
                
                // Content Switcher
                if selectedTab == 0 {
                    remoteControlTab
                } else if selectedTab == 1 {
                    appsTab
                } else {
                    keypadTab
                }
                
                // Bottom Tab Bar
                bottomTabBar
            }
        }
        .onAppear {
            volumeHandler.onVolumeUp = {
                vetro.sendKey("XF86AudioRaiseVolume")
            }
            volumeHandler.onVolumeDown = {
                vetro.sendKey("XF86AudioLowerVolume")
            }
            volumeHandler.startListening()
        }
        .sheet(isPresented: $showingSettings) {
            settingsSheet
        }
    }
    
    // MARK: - Header
    private var headerBar: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text("Dawood67 Remote")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Circle()
                        .fill(vetro.isConnected ? Color.green : Color.red)
                        .frame(width: 8, height: 8)
                }
                Text(vetro.statusMessage)
                    .font(.caption2)
                    .foregroundColor(Color.gray)
            }
            Spacer()
            
            Button {
                showingSettings = true
            } label: {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 18))
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Color.white.opacity(0.1))
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 12)
    }
    
    // MARK: - Remote Control Tab
    private var remoteControlTab: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                // Top Control Row: Power, Mute, Source
                HStack(spacing: 20) {
                    remoteButton(title: "POWER", icon: "power", color: .red) {
                        vetro.sendKey("XF86PowerOff")
                    }
                    
                    remoteButton(title: "MUTE", icon: "speaker.slash.fill", color: .orange) {
                        vetro.sendKey("XF86AudioMute")
                    }
                    
                    remoteButton(title: "INPUT", icon: "tv", color: .blue) {
                        vetro.sendKey("XF86DiscretSourceTV")
                    }
                }
                .padding(.horizontal, 20)
                
                // Volume & Navigation Row
                HStack(alignment: .center, spacing: 18) {
                    // Volume Up / Down Pill
                    VStack(spacing: 12) {
                        Button {
                            vetro.sendKey("XF86AudioRaiseVolume")
                        } label: {
                            VStack {
                                Image(systemName: "plus")
                                    .font(.title3.bold())
                                Text("VOL")
                                    .font(.caption2.bold())
                            }
                            .frame(width: 60, height: 80)
                            .background(Color.white.opacity(0.12))
                            .cornerRadius(18)
                        }
                        
                        Button {
                            vetro.sendKey("XF86AudioLowerVolume")
                        } label: {
                            VStack {
                                Text("VOL")
                                    .font(.caption2.bold())
                                Image(systemName: "minus")
                                    .font(.title3.bold())
                            }
                            .frame(width: 60, height: 80)
                            .background(Color.white.opacity(0.12))
                            .cornerRadius(18)
                        }
                    }
                    .foregroundColor(.white)
                    
                    // Directional Pad (D-Pad)
                    dPadView
                    
                    // Quick Action Column (Guide & Channel List)
                    VStack(spacing: 12) {
                        Button {
                            vetro.sendKey("XF86ChannelGuide")
                        } label: {
                            VStack(spacing: 4) {
                                Image(systemName: "list.bullet.rectangle")
                                    .font(.title3)
                                Text("GUIDE")
                                    .font(.system(size: 9, weight: .bold))
                            }
                            .frame(width: 60, height: 80)
                            .background(Color.white.opacity(0.12))
                            .cornerRadius(18)
                        }
                        
                        Button {
                            vetro.sendKey("XF86ChannelList")
                        } label: {
                            VStack(spacing: 4) {
                                Image(systemName: "list.number")
                                    .font(.title3)
                                Text("CH LIST")
                                    .font(.system(size: 9, weight: .bold))
                            }
                            .frame(width: 60, height: 80)
                            .background(Color.white.opacity(0.12))
                            .cornerRadius(18)
                        }
                    }
                    .foregroundColor(.white)
                }
                .padding(.horizontal, 16)
                
                // Navigation Control Row: Back, Home, Menu, Info, Exit
                HStack(spacing: 12) {
                    controlPill(title: "BACK", icon: "arrow.uturn.backward") {
                        vetro.sendKey("XF86Back")
                    }
                    
                    controlPill(title: "HOME", icon: "house.fill") {
                        vetro.sendKey("XF86Home")
                    }
                    
                    controlPill(title: "MENU", icon: "line.3.horizontal") {
                        vetro.sendKey("XF86Menu")
                    }
                    
                    controlPill(title: "INFO", icon: "info.circle") {
                        vetro.sendKey("XF86Info")
                    }
                    
                    controlPill(title: "EXIT", icon: "xmark.circle") {
                        vetro.sendKey("XF86Exit")
                    }
                }
                .padding(.horizontal, 16)
                
                // Media Playback Controls
                VStack(spacing: 10) {
                    Text("MEDIA PLAYBACK")
                        .font(.caption2.bold())
                        .foregroundColor(.gray)
                    
                    HStack(spacing: 14) {
                        mediaBtn(icon: "backward.end.fill") { vetro.sendKey("XF86AudioPrev") }
                        mediaBtn(icon: "backward.fill") { vetro.sendKey("XF86AudioRewind") }
                        mediaBtn(icon: "play.fill") { vetro.sendKey("XF86AudioPlay") }
                        mediaBtn(icon: "pause.fill") { vetro.sendKey("XF86AudioPause") }
                        mediaBtn(icon: "stop.fill") { vetro.sendKey("XF86AudioStop") }
                        mediaBtn(icon: "forward.fill") { vetro.sendKey("XF86AudioForward") }
                        mediaBtn(icon: "forward.end.fill") { vetro.sendKey("XF86AudioNext") }
                    }
                }
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                .background(Color.white.opacity(0.04))
                .cornerRadius(20)
                .padding(.horizontal, 16)
                
                // Physical iPhone Volume Hint Banner
                HStack(spacing: 10) {
                    Image(systemName: "speaker.wave.3.fill")
                        .foregroundColor(.blue)
                    Text("Hardware volume keys on your iPhone directly control TV volume!")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.85))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Color.blue.opacity(0.15))
                .cornerRadius(12)
                .padding(.horizontal, 20)
            }
            .padding(.bottom, 24)
        }
    }
    
    // MARK: - D-Pad View
    private var dPadView: some View {
        ZStack {
            Circle()
                .fill(Color(red: 0.10, green: 0.14, blue: 0.24))
                .frame(width: 210, height: 210)
                .overlay(Circle().stroke(Color.white.opacity(0.1), lineWidth: 1))
            
            // Up
            Button {
                vetro.sendKey("Up")
            } label: {
                Image(systemName: "chevron.up")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 60, height: 50)
            }
            .offset(y: -65)
            
            // Down
            Button {
                vetro.sendKey("Down")
            } label: {
                Image(systemName: "chevron.down")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 60, height: 50)
            }
            .offset(y: 65)
            
            // Left
            Button {
                vetro.sendKey("Left")
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 50, height: 60)
            }
            .offset(x: -65)
            
            // Right
            Button {
                vetro.sendKey("Right")
            } label: {
                Image(systemName: "chevron.right")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 50, height: 60)
            }
            .offset(x: 65)
            
            // Center OK Button
            Button {
                vetro.sendKey("Return")
            } label: {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 64, height: 64)
                    .overlay(
                        Text("OK")
                            .font(.system(size: 16, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                    )
                    .shadow(color: .blue.opacity(0.4), radius: 8, x: 0, y: 3)
            }
        }
    }
    
    // MARK: - Keypad Tab (0-9)
    private var keypadTab: some View {
        VStack(spacing: 20) {
            Text("NUMBER PAD")
                .font(.caption.bold())
                .foregroundColor(.gray)
                .padding(.top, 10)
            
            let grid = [
                ["1", "2", "3"],
                ["4", "5", "6"],
                ["7", "8", "9"]
            ]
            
            VStack(spacing: 16) {
                ForEach(grid, id: \.self) { row in
                    HStack(spacing: 20) {
                        ForEach(row, id: \.self) { num in
                            numPadButton(num) {
                                vetro.sendKey(num)
                            }
                        }
                    }
                }
                
                HStack(spacing: 20) {
                    numPadButton("XF86Info", label: "INFO") {
                        vetro.sendKey("XF86Info")
                    }
                    numPadButton("0") {
                        vetro.sendKey("0")
                    }
                    numPadButton("XF86Back", label: "DEL") {
                        vetro.sendKey("XF86Back")
                    }
                }
            }
            Spacer()
        }
        .padding(.horizontal, 30)
    }
    
    // MARK: - Apps Launcher Tab
    private var appsTab: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Search installed apps...", text: $appSearchQuery)
                    .foregroundColor(.white)
                if !appSearchQuery.isEmpty {
                    Button {
                        appSearchQuery = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(10)
            .background(Color.white.opacity(0.08))
            .cornerRadius(12)
            .padding(.horizontal, 16)
            
            let filtered = vetro.apps.filter {
                appSearchQuery.isEmpty ||
                ($0.name ?? "").localizedCaseInsensitiveContains(appSearchQuery) ||
                $0.appId.localizedCaseInsensitiveContains(appSearchQuery)
            }
            
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(filtered) { app in
                        Button {
                            vetro.launchApp(appId: app.appId, name: app.name ?? app.appId)
                        } label: {
                            VStack(spacing: 8) {
                                AsyncImage(url: URL(string: "\(vetro.baseURL)/apps/icon?appId=\(app.appId.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")")) { phase in
                                    if let image = phase.image {
                                        image.resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 50, height: 50)
                                            .cornerRadius(10)
                                    } else {
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color.blue.opacity(0.3))
                                            .frame(width: 50, height: 50)
                                            .overlay(
                                                Text(String((app.name ?? app.appId).prefix(1)).uppercased())
                                                    .font(.title2.bold())
                                                    .foregroundColor(.white)
                                            )
                                    }
                                }
                                
                                Text(app.name ?? app.appId)
                                    .font(.caption2.bold())
                                    .foregroundColor(.white)
                                    .lineLimit(2)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(14)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
        }
    }
    
    // MARK: - Bottom Tab Bar
    private var bottomTabBar: some View {
        HStack(spacing: 0) {
            tabButton(index: 0, title: "Remote", icon: "tv.fill")
            tabButton(index: 1, title: "TV Apps", icon: "square.grid.2x2.fill")
            tabButton(index: 2, title: "123", icon: "circle.grid.3x3.fill")
        }
        .padding(.vertical, 8)
        .background(Color(red: 0.06, green: 0.09, blue: 0.18))
        .overlay(Rectangle().frame(height: 1).foregroundColor(Color.white.opacity(0.1)), alignment: .top)
    }
    
    private func tabButton(index: Int, title: String, icon: String) -> some View {
        Button {
            selectedTab = index
        } label: {
            VStack(spacing: 3) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                Text(title)
                    .font(.system(size: 11, weight: .medium))
            }
            .foregroundColor(selectedTab == index ? .blue : .gray)
            .frame(maxWidth: .infinity)
        }
    }
    
    // MARK: - Small Components
    private func remoteButton(title: String, icon: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                Text(title)
                    .font(.system(size: 12, weight: .bold))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .background(color.opacity(0.3))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(color.opacity(0.6), lineWidth: 1))
            .cornerRadius(12)
        }
    }
    
    private func controlPill(title: String, icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 3) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                Text(title)
                    .font(.system(size: 9, weight: .bold))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(Color.white.opacity(0.08))
            .cornerRadius(12)
        }
    }
    
    private func mediaBtn(icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.white)
                .frame(width: 38, height: 38)
                .background(Color.white.opacity(0.08))
                .clipShape(Circle())
        }
    }
    
    private func numPadButton(_ key: String, label: String? = nil, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(label ?? key)
                .font(.system(size: label != nil ? 14 : 24, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .frame(width: 78, height: 78)
                .background(Color.white.opacity(0.08))
                .clipShape(Circle())
        }
    }
    
    // MARK: - Settings Sheet
    private var settingsSheet: some View {
        NavigationView {
            Form {
                Section(header: Text("Vetro Server")) {
                    TextField("Server Host:Port", text: $vetro.host)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    
                    Button("Test & Refresh Connection") {
                        vetro.checkConnection()
                        vetro.fetchApps()
                    }
                }
                
                Section(header: Text("Device Info")) {
                    HStack {
                        Text("Status")
                        Spacer()
                        Text(vetro.isConnected ? "Connected" : "Disconnected")
                            .foregroundColor(vetro.isConnected ? .green : .red)
                    }
                    HStack {
                        Text("Installed Apps")
                        Spacer()
                        Text("\(vetro.apps.count) available")
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("Remote Settings")
            .navigationBarItems(trailing: Button("Done") { showingSettings = false })
        }
    }
}

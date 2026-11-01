import SwiftUI

struct ContentView: View {
    @StateObject private var vetro = VetroService()
    @StateObject private var volumeHandler = VolumeButtonHandler()
    
    @State private var selectedTab: Int = 0
    @State private var showingSettings: Bool = false
    @State private var appSearchQuery: String = ""
    
    var body: some View {
        ZStack {
            Color(red: 0.04, green: 0.06, blue: 0.12).ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header Bar
                headerBar
                
                // Active Screen
                if selectedTab == 0 {
                    remoteControlTab
                } else if selectedTab == 1 {
                    appsTab
                } else {
                    numberPadTab
                }
                
                Spacer(minLength: 0)
                
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
    
    // MARK: - Header Bar
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
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Color.white.opacity(0.1))
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, 22)
        .padding(.top, 8)
        .padding(.bottom, 10)
    }
    
    // MARK: - Remote Control Tab (Only: Power, Vol +/-, D-Pad Up/Down/Left/Right/OK, Home, Back)
    private var remoteControlTab: some View {
        VStack(spacing: 28) {
            Spacer(minLength: 10)
            
            // Top Row: Power & Volume
            HStack(spacing: 36) {
                // Power Button
                Button {
                    vetro.sendKey("XF86PowerOff")
                } label: {
                    VStack(spacing: 6) {
                        Image(systemName: "power")
                            .font(.system(size: 24, weight: .bold))
                        Text("POWER")
                            .font(.system(size: 10, weight: .bold))
                    }
                    .foregroundColor(.red)
                    .frame(width: 84, height: 84)
                    .background(Color.red.opacity(0.18))
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.red.opacity(0.5), lineWidth: 1.5))
                }
                
                // Volume Controls (Vol + and Vol -)
                VStack(spacing: 8) {
                    Button {
                        vetro.sendKey("XF86AudioRaiseVolume")
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "plus")
                                .font(.system(size: 16, weight: .bold))
                            Text("VOL")
                                .font(.system(size: 12, weight: .bold))
                        }
                        .foregroundColor(.white)
                        .frame(width: 100, height: 44)
                        .background(Color.white.opacity(0.12))
                        .cornerRadius(12)
                    }
                    
                    Button {
                        vetro.sendKey("XF86AudioLowerVolume")
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "minus")
                                .font(.system(size: 16, weight: .bold))
                            Text("VOL")
                                .font(.system(size: 12, weight: .bold))
                        }
                        .foregroundColor(.white)
                        .frame(width: 100, height: 44)
                        .background(Color.white.opacity(0.12))
                        .cornerRadius(12)
                    }
                }
            }
            
            // Center D-Pad (Up, Down, Left, Right, OK)
            dPadView
            
            // Bottom Row: Home & Back
            HStack(spacing: 36) {
                Button {
                    vetro.sendKey("XF86Back")
                } label: {
                    VStack(spacing: 6) {
                        Image(systemName: "arrow.uturn.backward")
                            .font(.system(size: 20, weight: .bold))
                        Text("BACK")
                            .font(.system(size: 11, weight: .bold))
                    }
                    .foregroundColor(.white)
                    .frame(width: 90, height: 56)
                    .background(Color.white.opacity(0.12))
                    .cornerRadius(16)
                }
                
                Button {
                    vetro.sendKey("XF86Home")
                } label: {
                    VStack(spacing: 6) {
                        Image(systemName: "house.fill")
                            .font(.system(size: 20, weight: .bold))
                        Text("HOME")
                            .font(.system(size: 11, weight: .bold))
                    }
                    .foregroundColor(.white)
                    .frame(width: 90, height: 56)
                    .background(Color.blue.opacity(0.28))
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.blue.opacity(0.5), lineWidth: 1.5))
                    .cornerRadius(16)
                }
            }
            
            // Physical iPhone Volume Hint
            HStack(spacing: 8) {
                Image(systemName: "speaker.wave.2.fill")
                    .foregroundColor(.blue)
                    .font(.caption)
                Text("Physical iPhone volume buttons control TV volume")
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            .padding(.top, 4)
            
            Spacer(minLength: 10)
        }
        .padding(.horizontal, 20)
    }
    
    // MARK: - D-Pad View (Up, Down, Left, Right, OK)
    private var dPadView: some View {
        ZStack {
            Circle()
                .fill(Color(red: 0.10, green: 0.14, blue: 0.24))
                .frame(width: 230, height: 230)
                .overlay(Circle().stroke(Color.white.opacity(0.12), lineWidth: 1.5))
            
            // Up
            Button {
                vetro.sendKey("Up")
            } label: {
                Image(systemName: "chevron.up")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 70, height: 60)
            }
            .offset(y: -75)
            
            // Down
            Button {
                vetro.sendKey("Down")
            } label: {
                Image(systemName: "chevron.down")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 70, height: 60)
            }
            .offset(y: 75)
            
            // Left
            Button {
                vetro.sendKey("Left")
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 60, height: 70)
            }
            .offset(x: -75)
            
            // Right
            Button {
                vetro.sendKey("Right")
            } label: {
                Image(systemName: "chevron.right")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 60, height: 70)
            }
            .offset(x: 75)
            
            // Center OK Button
            Button {
                vetro.sendKey("Return")
            } label: {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 74, height: 74)
                    .overlay(
                        Text("OK")
                            .font(.system(size: 18, weight: .heavy, design: .rounded))
                            .foregroundColor(.white)
                    )
                    .shadow(color: .blue.opacity(0.4), radius: 10, x: 0, y: 4)
            }
        }
    }
    
    // MARK: - Number Pad Tab (0-9)
    private var numberPadTab: some View {
        VStack(spacing: 24) {
            Spacer(minLength: 10)
            
            let grid = [
                ["1", "2", "3"],
                ["4", "5", "6"],
                ["7", "8", "9"]
            ]
            
            VStack(spacing: 18) {
                ForEach(grid, id: \.self) { row in
                    HStack(spacing: 26) {
                        ForEach(row, id: \.self) { num in
                            numPadButton(num) {
                                vetro.sendKey(num)
                            }
                        }
                    }
                }
                
                HStack(spacing: 26) {
                    // Empty spacer on left
                    Color.clear
                        .frame(width: 76, height: 76)
                    
                    numPadButton("0") {
                        vetro.sendKey("0")
                    }
                    
                    // Del / Back key on right
                    Button {
                        vetro.sendKey("XF86Back")
                    } label: {
                        Image(systemName: "delete.backward.fill")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 76, height: 76)
                            .background(Color.white.opacity(0.08))
                            .clipShape(Circle())
                    }
                }
            }
            
            Spacer(minLength: 20)
        }
        .padding(.horizontal, 24)
    }
    
    private func numPadButton(_ num: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(num)
                .font(.system(size: 26, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .frame(width: 76, height: 76)
                .background(Color.white.opacity(0.1))
                .clipShape(Circle())
        }
    }
    
    // MARK: - Important Apps Tab (Only user media apps, no system clutter)
    private var appsTab: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Search apps...", text: $appSearchQuery)
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
                                            .frame(width: 52, height: 52)
                                            .cornerRadius(12)
                                    } else {
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.blue.opacity(0.25))
                                            .frame(width: 52, height: 52)
                                            .overlay(
                                                Text(String((app.name ?? app.appId).prefix(1)).uppercased())
                                                    .font(.title2.bold())
                                                    .foregroundColor(.white)
                                            )
                                    }
                                }
                                
                                Text(app.name ?? app.appId)
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundColor(.white)
                                    .lineLimit(2)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color.white.opacity(0.06))
                            .cornerRadius(14)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 20)
            }
        }
    }
    
    // MARK: - Bottom Tab Bar
    private var bottomTabBar: some View {
        HStack(spacing: 0) {
            tabButton(index: 0, title: "Remote", icon: "tv.fill")
            tabButton(index: 1, title: "Apps", icon: "square.grid.2x2.fill")
            tabButton(index: 2, title: "123", icon: "circle.grid.3x3.fill")
        }
        .padding(.vertical, 8)
        .background(Color(red: 0.07, green: 0.09, blue: 0.17))
        .overlay(Rectangle().frame(height: 1).foregroundColor(Color.white.opacity(0.1)), alignment: .top)
    }
    
    private func tabButton(index: Int, title: String, icon: String) -> some View {
        Button {
            selectedTab = index
        } label: {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                Text(title)
                    .font(.system(size: 11, weight: .medium))
            }
            .foregroundColor(selectedTab == index ? .blue : .gray)
            .frame(maxWidth: .infinity)
        }
    }
    
    // MARK: - Settings Sheet
    private var settingsSheet: some View {
        NavigationView {
            Form {
                Section(header: Text("Vetro TV Server")) {
                    TextField("Server Host:Port", text: $vetro.host)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    
                    Button("Refresh Connection & Apps") {
                        vetro.checkConnection()
                        vetro.fetchApps()
                    }
                }
                
                Section(header: Text("Status")) {
                    HStack {
                        Text("TV Status")
                        Spacer()
                        Text(vetro.isConnected ? "Connected" : "Disconnected")
                            .foregroundColor(vetro.isConnected ? .green : .red)
                    }
                    HStack {
                        Text("Apps Loaded")
                        Spacer()
                        Text("\(vetro.apps.count) user apps")
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarItems(trailing: Button("Done") { showingSettings = false })
        }
    }
}

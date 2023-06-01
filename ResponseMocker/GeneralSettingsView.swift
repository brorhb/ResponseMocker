import SwiftUI

struct SettingsView: View {
    private enum Tabs: Hashable {
        case general, advanced
    }
    var body: some View {
        TabView {
            GeneralSettingsView()
                .tabItem {
                    Label("General", systemImage: "gear")
                }
                .tag(Tabs.general)
        }
        .padding(20)
        .frame(width: 375, height: 150)
    }
}

struct GeneralSettingsView: View {
    @EnvironmentObject private var serverProvider: ServerProvider
    
    @State private var cancellable: Timer?
    @State private var port: String = ""
    
    func updateWithDebounce () {
        cancellable?.invalidate()
        
        guard let port = Int(port) else { return }
        
        cancellable = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
            serverProvider.port = port
            Task {
                await serverProvider.reboot()
            }
        }
    }

    var body: some View {
        Form {
            Text("Set the port you want the server to run on")
                .padding(.bottom)
            TextField("Port", text: $port)
                .onChange(of: port) { _ in
                    if port != "\(serverProvider.port)" {
                        updateWithDebounce()
                    }
                }
                .font(.system(.body, design: .monospaced))
            Text("NB: The field autosaves when you stop typing")
                .italic()
        }
        .padding(20)
        .frame(width: 350, height: 100)
        .onAppear {
            port = "\(serverProvider.port)"
        }
    }
}

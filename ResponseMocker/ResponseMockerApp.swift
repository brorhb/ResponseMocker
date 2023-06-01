//
//  ResponseMockerApp.swift
//  ResponseMocker
//
//  Created by Bror2 on 25/05/2023.
//

import SwiftUI

@main
struct ResponseMockerApp: App {
    @StateObject private var serverProvider = ServerProvider()
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(serverProvider)
        }
        Settings {
            SettingsView()
                .environmentObject(serverProvider)
        }
    }
}

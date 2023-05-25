//
//  ContentView.swift
//  ResponseMocker
//
//  Created by Bror2 on 25/05/2023.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var serverProvider: ServerProvider
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text(serverProvider.isRunning ? "Running" : "Not running")
            Button("Reboot") {
                Task {
                    await serverProvider.reboot()
                }
            }
        }
        .padding()
        .onAppear {
            serverProvider.start()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

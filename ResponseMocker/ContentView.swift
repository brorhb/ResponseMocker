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
            List {
                ForEach(serverProvider.mockeries.indices, id: \.self) { index in
                    MockInput(index: index)
                        .padding()
                }
            }
        }
        .padding()
        .onAppear {
            serverProvider.start()
        }
        .toolbar {
            ToolbarItem {
                HStack {
                    Text("Status")
                    Circle()
                        .foregroundColor(serverProvider.isRunning ? Color.green : Color.red)
                }
            }
            ToolbarItem {
                Button("Reboot") {
                    Task {
                        await serverProvider.reboot()
                    }
                }
            }
            ToolbarItem {
                Button(action: {
                    Task {
                        await serverProvider.addMock()
                    }
                }) {
                    Image(systemName: "plus")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

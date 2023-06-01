//
//  ContentView.swift
//  ResponseMocker
//
//  Created by Bror2 on 25/05/2023.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var serverProvider: ServerProvider
    @State private var addingMockery = false
    
    var body: some View {
        VStack {
            List {
                ForEach(serverProvider.mockeries.indices, id: \.self) { index in
                    MockInput(index: index)
                        .padding()
                        .contextMenu {
                            Button("Delete") {
                                Task {
                                    addingMockery = true
                                    let _ = await serverProvider.removeMock(at: IndexSet(integer: index))
                                    addingMockery = false
                                }
                            }
                        }
                }
                .onDelete(perform: { index in
                    Task {
                        addingMockery = true
                        let _ = await serverProvider.removeMock(at: index)
                        addingMockery = false
                    }
                })
            }
        }
        .background()
        .onAppear {
            Task {
                let _ = await serverProvider.start()
            }
        }
        .toolbar {
            ToolbarItem {
                HStack {
                    Circle()
                        .foregroundColor(serverProvider.isRunning ? Color.green : Color.red)
                }
            }
            ToolbarItem {
                Button("Update") {
                    Task {
                        await serverProvider.reboot()
                    }
                }
            }
            ToolbarItem {
                Button(action: {
                    Task {
                        addingMockery = true
                        let _ = await serverProvider.addMock()
                        addingMockery = false
                    }
                }) {
                    Image(systemName: "plus")
                }
                .disabled(addingMockery == true)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

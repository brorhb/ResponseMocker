//
//  MockInput.swift
//  ResponseMocker
//
//  Created by Bror2 on 25/05/2023.
//

import SwiftUI
import Combine

struct MockInput: View {
    var index: Int
    @EnvironmentObject var serverProvider: ServerProvider
    @State private var isJsonValid = true
    @State private var cancellable: Timer?
    
    func updateWithDebounce () {
        cancellable?.invalidate()
        
        cancellable = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
            Task {
                await serverProvider.reboot()
            }
        }
    }
    
    var body: some View {
        if (serverProvider.mockeries.count - 1 >= index) {
            VStack {
                Form {
                    HStack {
                        TextField("Endpoint", text: $serverProvider.mockeries[index].endpoint)
                            .font(.system(.body, design: .monospaced))
                        Spacer()
                        Picker("Status Code", selection: $serverProvider.mockeries[index].statusCode) {
                            ForEach(HTTPStatusCode.allCases, id: \.self) { statusCode in
                                Text("\(statusCode.rawValue)")
                            }
                        }
                    }
                }
                JSONInputFieldView(jsonString: $serverProvider.mockeries[index].responseBody)
            }
            .onChange(of: serverProvider.mockeries[index]) { _ in
                updateWithDebounce()
            }
            .padding()
            .border(.gray)
        }
    }
}

struct MockInput_Previews: PreviewProvider {
    static var previews: some View {
        MockInput(index: 0)
    }
}

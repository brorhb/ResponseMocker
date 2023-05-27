//
//  MockInput.swift
//  ResponseMocker
//
//  Created by Bror2 on 25/05/2023.
//

import SwiftUI

struct MockInput: View {
    var index: Int
    @EnvironmentObject var serverProvider: ServerProvider
    @State private var isJsonValid = true
    
    var body: some View {
        if (serverProvider.mockeries.count - 1 >= index) {
            VStack {
                Form {
                    HStack {
                        TextField("Endpoint", text: $serverProvider.mockeries[index].endpoint)
                            .font(.system(.body, design: .monospaced))
                        Spacer()
                        HStack {
                            TextField("Statuscode", text: $serverProvider.mockeries[index].statusCode)
                                .font(.system(.body, design: .monospaced))
                            TextField("Status message", text: $serverProvider.mockeries[index].responseDescription)
                        }
                    }
                }
                JSONInputFieldView(jsonString: $serverProvider.mockeries[index].responseBody)
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

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
        VStack {
            Form {
                HStack {
                    TextField("Endpoint", text: $serverProvider.mockeries[index].endpoint)
                        .font(.system(.body, design: .monospaced))
                    Spacer()
                    TextField("Statuscode", text: $serverProvider.mockeries[index].statusCode)
                        .font(.system(.body, design: .monospaced))
                }
            }
            JSONInputFieldView(jsonString: $serverProvider.mockeries[index].responseBody)
        }
    }
}

struct MockInput_Previews: PreviewProvider {
    static var previews: some View {
        MockInput(index: 0)
    }
}

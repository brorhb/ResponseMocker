//
//  JSONInputFieldView.swift
//  ResponseMocker
//
//  Created by Bror2 on 25/05/2023.
//

import SwiftUI
import CodeEditor

struct JSONInputFieldView: View {
    @Binding var jsonString: String
    @State private var isJSONValid: Bool = true
    
    var body: some View {
        VStack {
            CodeEditor(
                source: $jsonString,
                language: .json,
                indentStyle: .softTab(width: 2)
            )
            /*TextEditor(text: $jsonString)
                .font(Font.system(.body, design: .monospaced))
                .disableAutocorrection(true)*/
                .frame(height: 100)
                .onChange(of: jsonString) { value in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        isJSONValid = validateJSON(input: value)
                    }
                }
            
            HStack {
                Text(isJSONValid ? "" : "Invalid JSON")
                    .foregroundColor(isJSONValid ? .green : .red)
                    .padding(.top)
                Spacer()
            }
        }
    }
}

struct JSONInputFieldView_Previews: PreviewProvider {
    static var previews: some View {
        JSONInputFieldView(jsonString: .constant(""))
    }
}

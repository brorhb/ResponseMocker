//
//  util.swift
//  ResponseMocker
//
//  Created by Bror2 on 25/05/2023.
//

import Foundation

func validateJSON(input: String) -> Bool {
    let jsonData = input.data(using: .utf8)
    
    do {
        if let jsonData = jsonData {
            let _ = try JSONSerialization.jsonObject(with: jsonData, options: [])
            return true
        } else {
            return false
        }
    } catch {
        return false
    }
}

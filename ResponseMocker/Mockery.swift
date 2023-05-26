//
//  Mockery.swift
//  ResponseMocker
//
//  Created by Bror2 on 25/05/2023.
//

import Foundation

struct Mockery: Identifiable {
    let id = UUID()
    var statusCode = "200"
    var endpoint = "*"
    var responseDescription = ""
    var responseBody = ""
}

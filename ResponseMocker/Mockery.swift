//
//  Mockery.swift
//  ResponseMocker
//
//  Created by Bror2 on 25/05/2023.
//

import Foundation

struct Mockery: Identifiable, Codable {
    var id = UUID()
    var statusCode = "200"
    var endpoint = "*"
    var responseDescription = "OK"
    var responseBody = ""
}

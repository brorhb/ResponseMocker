//
//  Mockery.swift
//  ResponseMocker
//
//  Created by Bror2 on 25/05/2023.
//

import Foundation

struct Mockery: Identifiable, Codable, Equatable {
    var id = UUID()
    var statusCode: HTTPStatusCode = .ok
    var endpoint = "*"
    var responseBody = ""
    
    static func ==(lhs: Mockery, rhs: Mockery) -> Bool {
        return lhs.id == rhs.id &&
               lhs.statusCode == rhs.statusCode &&
               lhs.endpoint == rhs.endpoint &&
               lhs.responseBody == rhs.responseBody
    }
}

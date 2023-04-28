//
//  PasswordResponse.swift
//  SIACentro
//
//  Created by Carlos Manuel Hidalgo Ruiz on 27/04/23.
//

import Foundation

struct PasswordResponse: Codable {
    let status: Int
    let msg: String

    enum CodingKeys: String, CodingKey {
        case status, msg
    }
    
}

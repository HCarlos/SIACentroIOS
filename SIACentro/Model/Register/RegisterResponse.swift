//
//  RegisterResponse.swift
//  SIACentro
//
//  Created by Carlos Manuel Hidalgo Ruiz on 12/04/23.
//

import Foundation

// MARK: - Welcome
struct RegisterResponse: Codable {
    let status: Int
    let msg: String
    let accessToken: String?
    let tokenType: String?
    let username: String?
    let password: String?
    let email: String?
    let apPaterno: String?
    let apMaterno: String?
    let nombre: String?
    let domicilio: String?

    enum CodingKeys: String, CodingKey {
        case status, msg
        case accessToken = "access_token"
        case tokenType = "token_type"
        case username, password, email
        case apPaterno = "ap_paterno"
        case apMaterno = "ap_materno"
        case nombre, domicilio
    }
    
}

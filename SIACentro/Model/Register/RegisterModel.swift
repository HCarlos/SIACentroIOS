//
//  RegisterModel.swift
//  SIACentro
//
//  Created by Carlos Manuel Hidalgo Ruiz on 12/04/23.
//

import Foundation

struct RegisterModel {
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
}

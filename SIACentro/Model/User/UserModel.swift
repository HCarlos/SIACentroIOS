//
//  UserModel.swift
//  SIACentro
//
//  Created by Carlos Manuel Hidalgo Ruiz on 13/02/23.
//

import Foundation

struct UserModel {
    let status: Int
    let msg: String
    let accessToken, tokenType: String?
    let id: Int?
    let username, email, nombre, apPaterno: String?
    let apMaterno, curp, emails, celulares: String?
    let telefonos: String?
    let fechaNacimiento: String?
    let genero: Int?
    let root, filename, filenamePNG, filenameThumb: String?
    let admin, alumno, delegado: Bool?
    let sessionID: String?
    let statusUser, empresaID: Int?
    let ip, host: String?
    let logged: Bool?
    let loggedAt, logoutAt, emailVerifiedAt, createdAt: String?
    let updatedAt: String?
    let userMigID: Int?
    let searchtext: String?
    let ubicacionID, imagenID: Int?
    let uuid: String?
}


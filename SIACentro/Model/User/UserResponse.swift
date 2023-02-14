//
//  UsuarioResponse.swift
//  SIACentro
//
//  Created by Carlos Manuel Hidalgo Ruiz on 13/02/23.
//

import Foundation

// MARK: - Welcome
struct UserResponse: Codable {
    let status: Int?
    let msg, accessToken, tokenType: String?
    let user: User?

    enum CodingKeys: String, CodingKey {
        case status, msg
        case accessToken = "access_token"
        case tokenType = "token_type"
        case user
    }
}

// MARK: - User
struct User: Codable {
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

    enum CodingKeys: String, CodingKey {
        case id, username, email, nombre
        case apPaterno = "ap_paterno"
        case apMaterno = "ap_materno"
        case curp, emails, celulares, telefonos
        case fechaNacimiento = "fecha_nacimiento"
        case genero, root, filename
        case filenamePNG = "filename_png"
        case filenameThumb = "filename_thumb"
        case admin, alumno, delegado
        case sessionID = "session_id"
        case statusUser = "status_user"
        case empresaID = "empresa_id"
        case ip, host, logged
        case loggedAt = "logged_at"
        case logoutAt = "logout_at"
        case emailVerifiedAt = "email_verified_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case userMigID = "user_mig_id"
        case searchtext
        case ubicacionID = "ubicacion_id"
        case imagenID = "imagen_id"
        case uuid
    }
}

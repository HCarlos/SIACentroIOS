//
//  SolicitudesResponse.swift
//  SIACentro
//
//  Created by Carlos Manuel Hidalgo Ruiz on 28/02/23.
//

import Foundation

// MARK: - SolicitudesResponse
struct SolicitudesResponse: Codable {
    let status: Int
    let msg: String
    let denuncias: [Denuncia]
}

// MARK: - Denuncia
struct Denuncia: Codable {
    let id: Int
    let denuncia, fecha, latitud, longitud: String?
    let ubicacion, ubicacion_google, servicio: String?
    let imagenes: [Imagene]?
    let respuestas: [Respuesta]?

}

// MARK: - Imagene
struct Imagene: Codable {
    let id: Int
    let fecha, filename, filename_png, filename_thumb: String?
    let user_id, denunciamobile_id: Int?
    let latitud, longitud: String?
    let url, url_png, url_thumb: String?
    
}

// MARK: - Respuesta
struct Respuesta: Codable {
    let id: Int
    let fecha, respuesta: String?
    let observaciones: String?
    let user_id: Int?
    let roleuser: String?
    let username: String?
    
}

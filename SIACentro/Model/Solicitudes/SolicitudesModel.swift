//
//  SolicitudModel.swift
//  SIACentro
//
//  Created by Carlos Manuel Hidalgo Ruiz on 28/02/23.
//

import Foundation


// MARK: - SolicitudesModel
struct SolicitudesModel {
    let status: Int
    let msg: String
    let denuncias: [DenunciaModel]?
}

// MARK: - DenunciaModel
struct DenunciaModel {
    let id: Int
    let denuncia, fecha, latitud, longitud: String?
    let ubicacion, ubicacionGoogle, servicio: String?
    let imagenes: [ImageneModel]?
    let respuestas: [RespuestaModel]?
}

// MARK: - ImageneModel
struct ImageneModel {
    let id: Int
    let fecha, filename, filenamePNG, filenameThumb: String?
    let userID, denunciamobileID: Int?
    let latitud, longitud: String?
    let url, urlPNG, urlThumb: String?
}

// MARK: - RespuestaModel
struct RespuestaModel {
    let id: Int
    let fecha, respuesta: String?
    let observaciones: String?
    let userID: Int?
    let roleuser: String?
    let username: String?
}

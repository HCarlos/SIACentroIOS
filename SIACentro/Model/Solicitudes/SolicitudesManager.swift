//
//  SolicitudManager.swift
//  SIACentro
//
//  Created by Carlos Manuel Hidalgo Ruiz on 28/02/23.
//

import Foundation


protocol SolicitudesManagerDelegate{
    func didGetSolicitudesOk(Solicitud: SolicitudesModel)
    func didGetSolicitudesFail(_str: String)
}

struct SolicitudesManager{
    
    var delegate: SolicitudesManagerDelegate?

    private func parseJSON(solicitudResponse: Data)->SolicitudesModel?{
        let decoder = JSONDecoder()
        do {
            
            let decodeData = try? decoder.decode(SolicitudesResponse.self, from: solicitudResponse)
            
            let Solicitudes = SolicitudesModel(status: decodeData!.status, msg: decodeData!.msg, denuncias: decodeData!.denuncias.map{
                
                let Imagenes = $0.imagenes?.map{
                    ImageneModel(id: $0.id, fecha: $0.fecha, filename: $0.filename, filenamePNG: $0.filename_png, filenameThumb: $0.filename_thumb, userID: $0.user_id, denunciamobileID: $0.denunciamobile_id, latitud: $0.latitud, longitud: $0.longitud, url: $0.url, urlPNG: $0.url_png, urlThumb: $0.url_thumb)
                }

                let Respuestas = $0.respuestas?.map{
                    RespuestaModel(id: $0.id, fecha: $0.fecha, respuesta: $0.respuesta, observaciones: $0.observaciones, userID: $0.user_id, roleuser:$0.roleuser, username: $0.username)
                }

                return DenunciaModel(id: $0.id, denuncia: $0.denuncia, fecha: $0.fecha, latitud: $0.latitud, longitud: $0.longitud, ubicacion: $0.ubicacion, ubicacionGoogle: $0.ubicacion_google, servicio: $0.servicio, imagenes: Imagenes, respuestas: Respuestas)
                
            })
            return Solicitudes
        
        }
        
    }

    func postRequest(permissionData: String, user_id: Int) {
        
        let S = Singleton.shared
        let getUrlAPIGetSolicitudesList: String = S.getUrlAPIGetSolicitudesList()

        let parameters = ["user_id": user_id]

        let url = URL(string: getUrlAPIGetSolicitudesList)!

        let session = URLSession.shared

        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            self.delegate?.didGetSolicitudesFail(_str: error.localizedDescription )
        }

        //HTTP Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(permissionData)", forHTTPHeaderField: "Authorization")

        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            guard let data = data, error == nil else {
                self.delegate!.didGetSolicitudesFail(_str: error?.localizedDescription ?? "No hay conexión al servidor...")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                let Status: Int = responseJSON["status"] as! Int
                if Status == 1{
                    if let solicitud = self.parseJSON(solicitudResponse: data){
                        self.delegate?.didGetSolicitudesOk(Solicitud: solicitud)
                    }
                }else{
                    self.delegate!.didGetSolicitudesFail(_str: responseJSON["msg"] as! String )
                }
            }

        })
        task.resume()
    }

    
    
}

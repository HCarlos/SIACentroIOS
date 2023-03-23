//
//  SolicitudManager.swift
//  SIACentro
//
//  Created by Carlos Manuel Hidalgo Ruiz on 08/03/23.
//

import Foundation
protocol SolicitudManagerDelegate{
    func didGetSolicitudOk(Solicitud: SolicitudModel)
    func didGetSolicitudFail(_str: String)
}

struct SolicitudManager{
    
    var delegate: SolicitudManagerDelegate?
    

    private func parseJSON(solicitudResponse: Data)->SolicitudModel?{
        let decoder = JSONDecoder()
        do {
            
            let decodeData = try? decoder.decode(SolicitudResponse.self, from: solicitudResponse)
            
            let Solicitud = SolicitudModel(status: decodeData!.status, msg: decodeData!.msg)
            return Solicitud
        
        }
        
    }

    func postRequest(permissionData: String, user_id: Int, imagen: String, denuncia: String, servicio_id: String, servicio: String, latitud: Double, longitud: Double, tipo_mobile: String, marca_mobile: String, ubicacion_id: Int, ubicacion: String, ubicacion_google: String  ) {
        
        let S = Singleton.shared
        let getUrlAPISendSolicitud: String = S.getUrlAPISendSolicitud()

        let parameters = [
            "imagen": imagen,
            "denuncia": denuncia,
            "servicio_id": servicio_id,
            "servicio": servicio,
            "latitud": latitud,
            "longitud": longitud,
            "tipo_mobile": tipo_mobile,
            "marca_mobile": marca_mobile,
            "ubicacion_id": ubicacion_id,
            "ubicacion": ubicacion,
            "ubicacion_google": ubicacion_google,
            "user_id": user_id
        ] as [String : Any]

        let url = URL(string: getUrlAPISendSolicitud)!

        let session = URLSession.shared

        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            self.delegate?.didGetSolicitudFail(_str: error.localizedDescription )
        }

        //HTTP Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(permissionData)", forHTTPHeaderField: "Authorization")

        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            guard let data = data, error == nil else {
                self.delegate!.didGetSolicitudFail(_str: error?.localizedDescription ?? "No hay conexión al servidor...")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                let Status: Int = responseJSON["status"] as! Int
                if Status == 1{
                    if let solicitud = self.parseJSON(solicitudResponse: data){
                        self.delegate?.didGetSolicitudOk(Solicitud: solicitud)
                    }
                }else{
                    self.delegate!.didGetSolicitudFail(_str: responseJSON["msg"] as! String )
                }
            }

        })
        
        task.resume()
    }

    
    
    
    
}

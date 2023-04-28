//
//  RegisterManager.swift
//  SIACentro
//
//  Created by Carlos Manuel Hidalgo Ruiz on 12/04/23.
//

import Foundation

protocol RegisterManagerDelegate{
    func didRegisterUser(RegisterUser: RegisterModel)
    func didFailWithError(_str: String)
}

struct RegisterManager{
    
    var delegate: RegisterManagerDelegate?
    
    private func parseJSON(registerResponse: Data)->RegisterModel?{
        let decoder = JSONDecoder()
        do {
            
            let decodeData = try? decoder.decode(RegisterResponse.self, from: registerResponse)
            
            let usuario = RegisterModel(status: decodeData!.status, msg: decodeData!.msg, accessToken: decodeData?.accessToken ?? "", tokenType: decodeData?.tokenType ?? "", username: decodeData!.username ?? "", password: decodeData!.password ?? "", email: decodeData!.email ?? "", apPaterno: decodeData!.nombre ?? "", apMaterno: decodeData!.apPaterno ?? "", nombre: decodeData!.apMaterno ?? "", domicilio: decodeData!.domicilio ?? "")

            return usuario
        
        }
        
    }
    



    func postRequest(curp: String, ap_paterno: String, ap_materno: String, nombre: String, email: String, domicilio: String, genero: Int, device_name: String) {
        
        let S = Singleton.shared
        let UrlAPIRegister: String = S.getUrlAPIRegister()

        let parameters = ["curp": curp, "ap_paterno": ap_paterno, "ap_materno": ap_materno, "nombre": nombre, "email": email, "domicilio": domicilio, "genero": genero, "device_name": device_name] as [String : Any]
        
        let url = URL(string: UrlAPIRegister)!
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to data object and set it as request body
        } catch let error {
            self.delegate?.didFailWithError(_str: error.localizedDescription )
        }

        //HTTP Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request, completionHandler: { data, response, error in

            if error != nil{
                self.delegate!.didFailWithError(_str: error?.localizedDescription ?? "No hay conexión al servidor...")
                return
            }
            
            if let safeData = data{
                if let usuario = self.parseJSON(registerResponse: safeData){
                    self.delegate?.didRegisterUser(RegisterUser: usuario)
                }
            }
        })
        task.resume()
    }

    
    
}

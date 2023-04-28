//
//  PasswordManager.swift
//  SIACentro
//
//  Created by Carlos Manuel Hidalgo Ruiz on 27/04/23.
//

import Foundation

protocol PasswordManagerDelegate{
    func getResponseRecoveryPasswordAPIOK(PasswordUser: PasswordModel)
    func didFailWithError(_str: String)
}

struct PasswordManager{
    
    var delegate: PasswordManagerDelegate?
    
    private func parseJSON(passwordResponse: Data)->PasswordModel?{
        let decoder = JSONDecoder()
        do {
            
            let decodeData = try? decoder.decode(PasswordResponse.self, from: passwordResponse)
            
            let Message = PasswordModel(status: decodeData!.status, msg: decodeData!.msg)

            return Message
        
        }
        
    }
    



    func postRequest(email: String, device_name: String) {
        
        let S = Singleton.shared
        let UrlAPIRecoveryPassword: String = S.getUrlAPIRecoveryPassword()

        let parameters = ["email": email, "device_name": device_name] as [String : Any]
        
        let url = URL(string: UrlAPIRecoveryPassword)!
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
                if let Message = self.parseJSON(passwordResponse: safeData){
                    self.delegate?.getResponseRecoveryPasswordAPIOK(PasswordUser: Message)
                }
            }
        })
        task.resume()
    }

    
    
}

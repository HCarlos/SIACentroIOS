//
//  UserManager.swift
//  SIACentro
//
//  Created by Carlos Manuel Hidalgo Ruiz on 13/02/23.
//

import Foundation

protocol UserManagerDelegate{
    func didLoginUser(User: UserModel)
    func didFailWithError(_str: String)
}

struct UserManager{
    
    let UrlAPILogin: String = "https://pokeapi.co/api/v2/pokemon?limit=898"
    
    var delegate: UserManagerDelegate?
    

    func fetchUserAPI(){
        performRequest(with: UrlAPILogin)
    }
    
    private func performRequest(with _url:String){
        // 1.- Create/get URL
        if let __url = URL(string: _url){
            // Create the URLSession
            let session = URLSession(configuration: .default)
            // Give the session task
            let task = session.dataTask(with: __url){data,response,error in
                if error == nil{
                    self.delegate?.didFailWithError(_str: error?.localizedDescription ?? "error...")
                }
                if let safeData = data{
                    if let usuario = self.parseJSON(userResponse: safeData){
                        self.delegate?.didLoginUser(User: usuario)
                    }
                }
                
            }
            // Start the task
            task.resume()
        }
        
    }
    
    
    private func parseJSON(userResponse: Data)->UserModel?{
        let decoder = JSONDecoder()
        do {
            
            let decodeData = try? decoder.decode(UserResponse.self, from: userResponse)
            
            let User = decodeData?.user
            
            let usuario = UserModel(status: decodeData!.status, msg: decodeData!.msg, accessToken: decodeData?.accessToken ?? "", tokenType: decodeData?.tokenType ?? "", id: User?.id ?? 0, username: User?.username ?? "", email: User?.email ?? "", nombre: User?.nombre ?? "", apPaterno: User?.apPaterno ?? "", apMaterno: User?.apMaterno ?? "", curp: User?.curp ?? "", emails: User?.emails ?? "", celulares: User?.celulares ?? "", telefonos: User?.telefonos ?? "", fechaNacimiento: User?.fechaNacimiento ?? "", genero: User?.genero ?? 0, root: User?.root ?? "", filename: User?.filename ?? "", filenamePNG: User?.filenamePNG ?? "", filenameThumb: User?.filenameThumb ?? "", admin: User?.admin ?? false, alumno: User?.alumno ?? false, delegado: User?.delegado ?? false, sessionID: User?.sessionID ?? "", statusUser: User?.statusUser ?? 0, empresaID: User?.empresaID ?? 0, ip: User?.ip ?? "", host: User?.host ?? "", logged: User?.logged ?? false, loggedAt: User?.loggedAt ?? "", logoutAt: User?.logoutAt ?? "", emailVerifiedAt: User?.emailVerifiedAt ?? "", createdAt: User?.createdAt ?? "", updatedAt: User?.updatedAt ?? "", userMigID: User?.userMigID ?? 0, searchtext: User?.searchtext ?? "", ubicacionID: User?.ubicacionID ?? 1, imagenID: User?.imagenID ?? 0, uuid: User?.uuid ?? "")

            return usuario
        
        }
        
    }
    



    func postRequest(username: String, password: String) {
        
        let S = Singleton.shared
        let UrlAPILogin: String = S.getUrlAPILogin()

        let parameters = ["username": username, "password": password]
        let url = URL(string: UrlAPILogin)!
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST

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
                if let usuario = self.parseJSON(userResponse: safeData){
                    let S = Singleton.shared
                    S.setUser(_user: usuario)
                    self.delegate?.didLoginUser(User: usuario)
                }
            }
             

            
            
        })

        task.resume()
    }

    
    
}

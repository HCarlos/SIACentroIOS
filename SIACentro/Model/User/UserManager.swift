//
//  UserManager.swift
//  SIACentro
//
//  Created by Carlos Manuel Hidalgo Ruiz on 13/02/23.
//

import Foundation

struct UserManager{
    
    let UrlAPILogin: String = Singleton.shared.getUrlAPIBase() + "login"
    
    func performRequest(with _url:String){
        
        if let url = URL(string: _url){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url){data,response,error in
                if error != nil{
                    print(error!)
                }
                if let safeData = data{
                    if let usuario = self.parseJSON(userResponse: safeData){
                        print(usuario)
                    }
                }
                
            }
            task.resume()
        }
        
    }
    
    
    func parseJSON(userResponse: Data)->UserModel?{
        let decoder = JSONDecoder()
        do {
            let decodeData = try decoder.decode(UserResponse.self, from: userResponse)
            
            
//            let usuario = decodeData?.map{
//                UserModel(msg:$0.msg, status:$0.status, accessToken: $0.accessToken, tokenType: $0.tokenType, id: $0.id, username: $0.username, email: $0.email, nombre: $0.nombre, apPaterno: $0.apPaterno, apMaterno: $0.apMaterno, telefonos: $0.telefonos, fechaNacimiento: $0.fechaNacimiento, genero: $0.genero, root:$0.root, filename: $0.filename, filenamePNG: $0.filenamePNG, filenameThumb: $0.filenameThumb, admin: $0.admin, alumno: $0.alumno, delegado: $0.delegado, sessionID: $0.sessionID, statusUser: $0.statusUser, empresaID: $0.empresaID, ip: $0.ip, host: $0.host, logged: $0.logged, loggedAt: $0.loggewdAt, logoutAt: $0.logoutAt, emailVerifiedAt: $0.emailVerifiedAt, createdAt: $0.createdAt, updatedAt: $0.updatedAt, userMigID: $0.userMigID, searchtext: $0.searchtext, ubicacionID: $0.ubicacionID, imagenID: $0.imagenID, uuid: $0.uuid )
//            }
            
            let usuario = UserModel(status:decodeData.status, msg:decodeData.msg, accessToken: decodeData.accessToken, tokenType: decodeData.tokenType, id: decodeData.user?.id, username: decodeData.user?.username, email: decodeData.user?.email, nombre: decodeData.user?.nombre, apPaterno: decodeData.user?.apPaterno, apMaterno: decodeData.user?.apMaterno, curp: decodeData.user?.curp, emails: decodeData.user?.emails, celulares: decodeData.user?.celulares, telefonos: decodeData.user?.telefonos, fechaNacimiento: decodeData.user?.fechaNacimiento, genero: decodeData.user?.genero, root:decodeData.user?.root, filename: decodeData.user?.filename, filenamePNG: decodeData.user?.filenamePNG, filenameThumb: decodeData.user?.filenameThumb, admin: decodeData.user?.admin, alumno: decodeData.user?.alumno, delegado: decodeData.user?.delegado, sessionID: decodeData.user?.sessionID, statusUser: decodeData.user?.statusUser, empresaID: decodeData.user?.empresaID, ip: decodeData.user?.ip, host: decodeData.user?.host, logged: decodeData.user?.logged, loggedAt: decodeData.user?.loggedAt, logoutAt: decodeData.user?.logoutAt, emailVerifiedAt: decodeData.user?.emailVerifiedAt, createdAt: decodeData.user?.createdAt, updatedAt: decodeData.user?.updatedAt, userMigID: decodeData.user?.userMigID, searchtext: decodeData.user?.searchtext, ubicacionID: decodeData.user?.ubicacionID, imagenID: decodeData.user?.imagenID, uuid: decodeData.user?.uuid)

            return usuario
        } catch{
            return nil
        }
    }
    
    
    
    
}

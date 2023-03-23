//
//  Singleton.swift
//  SIACentro
//
//  Created by Carlos Manuel Hidalgo Ruiz on 13/02/23.
//

import Foundation

class Singleton {

    let URL_API: String = "https://siac.villahermosa.gob.mx/api/v1/"
    let URL_Home: String = "https://siac.villahermosa.gob.mx/"
    let pathLogin: String = "login"

    let pathGetSolicitudes: String = "denuncia/getlist"
    let pathSendSolicitud: String = "denuncia/insert"

    var User: UserModel? = nil
    
    var stringImageBase64 = ""

    static var shared: Singleton = {

        let instance = Singleton()
        return instance

    }()

    public init() {}

    func getUrlHome() -> String {
        return URL_API
    }

    func getUrlAPIBase() -> String {
        return URL_API
    }
    
    func getUrlAPILogin() -> String {
        return URL_API + pathLogin
    }
    
    func setUser(_user: UserModel){
        self.User = _user
    }
    
    func getUser() -> UserModel {
        return self.User!
    }
    
    func getUrlAPIGetSolicitudesList() -> String {
        return URL_API + pathGetSolicitudes
    }
    
    func getUrlAPISendSolicitud() -> String {
        return URL_API + pathSendSolicitud
    }

    
    func setStringImageBase64(_stringImageBase64: String){
        self.stringImageBase64 = _stringImageBase64
    }
    
    func getStringImageBase64() -> String {
        return self.stringImageBase64
    }
    
    
        

    

    
    
}

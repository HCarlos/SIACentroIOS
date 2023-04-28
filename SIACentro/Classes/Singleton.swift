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
    let pathRegister: String = "register"

    let pathGetSolicitudes: String = "denuncia/getlist"
    let pathSendSolicitud: String = "denuncia/insert"
    let pathSendMessage: String = "denuncia/add/respuesta"
    let pathRecoveryPasword: String = "user/recovery/password"
    let pathAboutApp:String = "about_app"
    let pathAvisoApp:String = "aviso_app"

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
    
    func getUrlAPIRegister() -> String {
        return URL_API + pathRegister
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

    func getUrlAPISendMessage() -> String {
        return URL_API + pathSendMessage
    }

    func getUrlAPIRecoveryPassword() -> String {
        return URL_API + pathRecoveryPasword
    }



    func setStringImageBase64(_stringImageBase64: String){
        self.stringImageBase64 = _stringImageBase64
    }
    
    func getAboutApp() -> String {
        return URL_Home + pathAboutApp
    }
    
    func getAvisoApp() -> String {
        return URL_Home + pathAvisoApp
    }
    

        

    

    
    
}

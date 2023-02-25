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
    
    var User: UserModel? = nil;

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
    
        

    

    
    
}

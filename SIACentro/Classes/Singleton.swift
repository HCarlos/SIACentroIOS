//
//  Singleton.swift
//  SIACentro
//
//  Created by Carlos Manuel Hidalgo Ruiz on 13/02/23.
//

import Foundation

class Singleton {

    let URL_API: String = "https://siac/villahermosa.gob.mx/api/v1/"
    let URL_Home: String = "https://siac/villahermosa.gob.mx/"

    static var shared: Singleton = {

        let instance = Singleton()
        return instance

    }()

    private init() {}

    func getUrlAPIBase() -> String {
        return URL_API
    }
    
    
    
    
}

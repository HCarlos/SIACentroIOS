//
//  Funciones.swift
//  SIACentro
//
//  Created by Carlos Manuel Hidalgo Ruiz on 08/03/23.
//

import Foundation
import UIKit


class Funciones {

    public init() {}
    
    func convertImageToBase64String (img: UIImage) -> String {
        return img.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
    }
    
    func convertBase64StringToImage (imageBase64String:String) -> UIImage {
        let imageData = Data(base64Encoded: imageBase64String)
        let image = UIImage(data: imageData!)
        return image!
    }

    static func setImagenFondo() -> UIImageView {
        let imageView = UIImageView(frame: UIScreen.main.bounds)
        imageView.image = UIImage(named: "AccentColor")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = false
       return imageView
    }
    
}





//
//  CeldaImageBigTableViewCell.swift
//  SIACentro
//
//  Created by Carlos Manuel Hidalgo Ruiz on 16/03/23.
//

import UIKit

class CeldaImageBigViewCell: UITableViewCell {

    @IBOutlet weak var Imagen: UIImageView!
    @IBOutlet var Activity: UIActivityIndicatorView!
    
    func sayImagen(){
        
        Imagen.layer.shadowOffset = CGSize(width: 0, height: 1)
        Imagen.layer.shadowColor = UIColor.lightGray.cgColor
        Imagen.layer.shadowOpacity = 0.8
        Imagen.layer.shadowRadius = 15

        Imagen.layer.borderWidth = 3
        Imagen.layer.borderColor = CGColor(red: 85, green: 86, blue: 87, alpha: 0.8)
        Imagen.layer.cornerRadius = 15;
        Imagen.layer.masksToBounds = true
        
    }

    
    
    func loadImageWithKF(url: URL) {
        sayImagen()
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if UIImage(data: data) != nil {
                    DispatchQueue.main.async {
//                        self?.Imagen.kf.setImage(with: url)
                        let image = UIImage(data:data, scale:1.0) // UIImage(data: data)
                        self?.Imagen.image = image
                        self?.Activity.stopAnimating()
                    }
                }
            }
        }
    }

    
    
}

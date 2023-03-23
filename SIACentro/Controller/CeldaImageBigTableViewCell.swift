//
//  CeldaImageBigTableViewCell.swift
//  SIACentro
//
//  Created by Carlos Manuel Hidalgo Ruiz on 16/03/23.
//

import UIKit

class CeldaImageBigTableViewCell: UITableViewCell {

    @IBOutlet weak var Imagen: UIImageView!
    @IBOutlet var Activity: UIActivityIndicatorView!
    
    func loadImageWithKF(url: URL) {
        DispatchQueue.global().async { [weak self] in
        if let data = try? Data(contentsOf: url) {
            if UIImage(data: data) != nil {
                DispatchQueue.main.async {
                    self?.Imagen.kf.setImage(with: url)
                    self?.Activity.stopAnimating()
                }
            }
        }
       }
    }

    
    
}

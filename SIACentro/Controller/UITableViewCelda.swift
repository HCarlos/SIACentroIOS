//
//  UITableViewCelda.swift
//  SIACentro
//
//  Created by Carlos Manuel Hidalgo Ruiz on 03/03/23.
//

import UIKit
import SwiftUI
import ImageIO


class UITableViewCelda: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

    /*
    @IBOutlet weak var ViewCell: UIView!
    //    @IBOutlet weak var lblGeo: UILabel!
//    @IBOutlet weak var lblDomicilio: UILabel!
    @IBOutlet weak var lblDenuncia: UILabel!
//    @IBOutlet weak var lblFecha: UILabel!
    @IBOutlet weak var lblServicio: UILabel!
    @IBOutlet weak var Imagen: UIImageView!
     */
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        
        
    }
    
    private var Imagen: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()

        private let lblServicio: UILabel = {
            let label = UILabel()
            label.font = .boldSystemFont(ofSize: 18)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()

        private let lblFecha: UILabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 14)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()

        private let lblDenuncia: UILabel = {
            let label = UILabel()
            label.font = .boldSystemFont(ofSize: 16)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()

        private let lblDomicilio: UILabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 14)
//            label.contentMode = .scaleToFill
//            label.numberOfLines = 0
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()

        private let lblGeolocalizacion: UILabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 14)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
    
        private let btnImages: UIButton = {
            let btn = UIButton()
//            btn.textColor = #colorLiteral(red: 0.5529411765, green: 0.4431372549, blue: 0.1843137255, alpha: 1)
            btn.layer.borderColor = #colorLiteral(red: 0.5529411765, green: 0.4431372549, blue: 0.1843137255, alpha: 1)
            btn.layer.borderWidth = 1
            btn.layer.cornerRadius = 8;
            btn.imageView?.image = UIImage(named: "icon_denuncia")
            btn.translatesAutoresizingMaskIntoConstraints = false
            return btn
        }()

        private let btnRespuestas: UIButton = {
            let btn = UIButton()
    //            btn.textColor = #colorLiteral(red: 0.5529411765, green: 0.4431372549, blue: 0.1843137255, alpha: 1)
            btn.layer.borderColor = #colorLiteral(red: 0.5529411765, green: 0.4431372549, blue: 0.1843137255, alpha: 1)
            btn.layer.borderWidth = 1
            btn.layer.cornerRadius = 8;
            
            btn.translatesAutoresizingMaskIntoConstraints = false
            return btn
        }()




        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            
            self.contentView.layer.backgroundColor = CGColor(red: 128, green: 128, blue: 128, alpha: 1)

            addSubview(Imagen)
            addSubview(lblServicio)
            addSubview(lblFecha)
            addSubview(lblDenuncia)
            addSubview(lblDomicilio)
            addSubview(lblGeolocalizacion)
            addSubview(btnImages)
            addSubview(btnRespuestas)

            NSLayoutConstraint.activate([
                Imagen.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
                Imagen.topAnchor.constraint(equalTo: topAnchor, constant: 12),
                Imagen.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
                Imagen.widthAnchor.constraint(equalToConstant: 80),
                Imagen.heightAnchor.constraint(equalToConstant: 80),

                lblServicio.leadingAnchor.constraint(equalTo: Imagen.trailingAnchor, constant: 12),
                lblServicio.topAnchor.constraint(equalTo: topAnchor, constant: 0),

                lblFecha.leadingAnchor.constraint(equalTo: Imagen.trailingAnchor, constant: 12),
                lblFecha.topAnchor.constraint(equalTo: lblServicio.topAnchor, constant: 22),

                lblDenuncia.leadingAnchor.constraint(equalTo: Imagen.trailingAnchor, constant: 12),
                lblDenuncia.topAnchor.constraint(equalTo: lblFecha.topAnchor, constant: 22),

                lblDomicilio.leadingAnchor.constraint(equalTo: Imagen.trailingAnchor, constant: 12),
                lblDomicilio.topAnchor.constraint(equalTo: lblDenuncia.topAnchor, constant: 22),

                lblGeolocalizacion.leadingAnchor.constraint(equalTo: Imagen.trailingAnchor, constant: 12),
                lblGeolocalizacion.topAnchor.constraint(equalTo: lblDomicilio.topAnchor, constant: 22),


                btnImages.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
                btnImages.topAnchor.constraint(equalTo: Imagen.bottomAnchor, constant: 12),
                btnImages.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
                btnImages.widthAnchor.constraint(equalToConstant: 48),
                btnImages.heightAnchor.constraint(equalToConstant: 48),

                btnRespuestas.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 100),
                btnRespuestas.topAnchor.constraint(equalTo: btnImages.bottomAnchor, constant: 12),
                btnRespuestas.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
                btnRespuestas.widthAnchor.constraint(equalToConstant: 48),
                btnRespuestas.heightAnchor.constraint(equalToConstant: 48),


            ])

        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

 
        func configure(model: DenunciaModel) {
            lblServicio.text = model.servicio!
            lblFecha.text = model.fecha!
            lblDenuncia.text = model.denuncia!
            lblDomicilio.text = model.ubicacion!
            lblGeolocalizacion.text = model.latitud!+", "+model.longitud!

           // let
            
            let imgModel: ImageneModel! = model.imagenes?[0]
            let urlImage = imgModel.urlThumb  ?? ""
            
            if ( urlImage != "" ){
                let fileUrl = URL(string: urlImage )
                loadImage(url: fileUrl!)
            }
        }
    
        func loadImage(url: URL) {
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self!.Imagen.image = image
                        }
                    }
                }
            }
        }
    
    
    
}

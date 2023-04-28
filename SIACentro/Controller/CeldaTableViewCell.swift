//
//  CeldaTableViewCell.swift
//  SIACentro
//
//  Created by Carlos Manuel Hidalgo Ruiz on 06/03/23.
//

import UIKit
//import Kingfisher

protocol CeldaImagesListViewCellDelegate {
    func callSegueFromCellImageList(Imagenes: [ImageneModel], SolicitudMobile_Id: String)
}

protocol CeldaChatListViewCellDelegate {
    func callSegueFromCellChatList(Respuestas: [RespuestaModel], SolicitudMobile_Id: String)
}


class CeldaTableViewCell: UITableViewCell {

    var delegateImageList:CeldaImagesListViewCellDelegate!
    var delegateChatList:CeldaChatListViewCellDelegate!
    
    @IBAction func btnImagen(_ sender: UIButton) {
        self.delegateImageList.callSegueFromCellImageList(Imagenes: Imagenes, SolicitudMobile_Id: DenunciaMobile_Id)
    }

    @IBAction func btnMessage(_ sender: UIButton) {
        self.delegateChatList.callSegueFromCellChatList(Respuestas: Respuestas, SolicitudMobile_Id: DenunciaMobile_Id)
    }

    var Imagenes:[ImageneModel] = [];
    var Respuestas:[RespuestaModel] = [];
    var DenunciaMobile_Id = "0"

    @IBOutlet weak var btnImagen: UIButton!
    @IBOutlet weak var ViewCell: UIView!
    @IBOutlet weak var lblGeolocalizacion: UILabel!
    @IBOutlet weak var lblDomicilio: UILabel!
    @IBOutlet weak var lblDenuncia: UILabel!
    @IBOutlet weak var lblFecha: UILabel!
    @IBOutlet weak var lblServicio: UILabel!
    @IBOutlet weak var Imagen: UIImageView!

    @IBOutlet weak var btnMessage: UIButton!
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//
//    }
//
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//
//
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//       super.init(coder: aDecoder)
//    }
    
    func pintaViewCell(){
        ViewCell.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        ViewCell.layer.borderWidth = 2
        ViewCell.layer.borderColor = CGColor.init(gray: 32, alpha: 1)
        ViewCell.layer.cornerRadius = 8
    }

    func configure(model: DenunciaModel) {
        
        Imagenes = model.imagenes!;
        Respuestas = model.respuestas!;
        DenunciaMobile_Id = String(model.id)
        
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
            loadImageWithKF(url: fileUrl!)
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

    func loadImageWithKF(url: URL) {
        DispatchQueue.global().async { [weak self] in
        if let data = try? Data(contentsOf: url) {
            if UIImage(data: data) != nil {
                DispatchQueue.main.async {
//                    self!.Imagen.kf.setImage(with: url)
                    let image = UIImage(data:data, scale:1.0) // UIImage(data: data)
                    self!.Imagen.image = image
                }
            }
        }
       }
    }

    
}

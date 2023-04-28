//
//  ChatListTableViewController.swift
//  SIACentro
//
//  Created by Carlos Manuel Hidalgo Ruiz on 17/03/23.
//

import UIKit
import SwiftUI

class ChatListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    lazy var solicitudManager = SolicitudManager()
    lazy var GetSolicitudListOk: SolicitudModel? = nil {
        didSet{
            getResponseSolicitudAPIOK()
        }
    }
    
    lazy var errorSet: String = "" {
        didSet{
            viewErrorConnectionAPI()
        }
    }

    var Respuestas:[RespuestaModel] = []
    var txtField = UITextField()
    
    var respuesta = ""
    var denunciamobile_id = "0"
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var txtChat: UITextField!
    @IBAction func btnListo(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        view.insertSubview(Funciones.setImagenFondo(), at: 0)

        solicitudManager.delegate = self

        txtChat.layer.backgroundColor =  #colorLiteral(red: 0.9488356709, green: 0.9253563285, blue: 0.8861634135, alpha: 1)
        txtChat.textColor = #colorLiteral(red: 0.5529411765, green: 0.4431372549, blue: 0.1843137255, alpha: 1)
        txtChat.layer.borderColor = #colorLiteral(red: 0.5529411765, green: 0.4431372549, blue: 0.1843137255, alpha: 1)
        txtChat.layer.borderWidth = 1
        txtChat.layer.cornerRadius = 8
        txtChat.placeholder = "Escriba un comentario"

        let customView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 48))
        customView.backgroundColor = UIColor.lightGray
        
        let ancho = txtChat.layer.frame.size.width - 5.0
        let alto = txtChat.layer.frame.size.height - 2.0
        
        // Agregamos el textview
        var fontSize:CGFloat { return 16 }
        var boldFont:UIFont { return UIFont(name: "AvenirNext-Bold", size: fontSize) ?? UIFont.boldSystemFont(ofSize: fontSize) }
        var normalFont:UIFont { return UIFont(name: "AvenirNext-Regular", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)}
        
        let normalText = ""
        let boldText  = ""
        let attributedString = NSMutableAttributedString(string:normalText)
        let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)]
        let boldString = NSMutableAttributedString(string: boldText, attributes:attrs)
        attributedString.append(boldString)
        let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 5)

        txtField = UITextField()
        txtField.attributedText = attributedString
        txtField.layer.frame.size = CGSize(width: ancho - 50, height: alto)
        txtField.frame = CGRect(x: 5, y: 7, width: ancho - 25, height: alto)
        txtField.layer.backgroundColor =  #colorLiteral(red: 0.9488356709, green: 0.9253563285, blue: 0.8861634135, alpha: 1)
        txtField.textColor = #colorLiteral(red: 0.5529411765, green: 0.4431372549, blue: 0.1843137255, alpha: 1)
        txtField.layer.borderColor = #colorLiteral(red: 0.5529411765, green: 0.4431372549, blue: 0.1843137255, alpha: 1)
        txtField.layer.borderWidth = 1
        txtField.layer.cornerRadius = 8
        txtField.placeholder = "Escriba un comentario"
        txtField.bounds.inset(by: padding)
        txtField.becomeFirstResponder()

        // Agregamos el botón
        let btnAddMsg = UIButton()
        btnAddMsg.layer.frame.size = CGSize(width: 32, height: 32)
        btnAddMsg.frame = CGRect(x: ancho - 10, y: 7, width: 32, height: 32)
        btnAddMsg.setImage(UIImage(named: "icon_denuncia"), for: .normal)
        btnAddMsg.backgroundColor = #colorLiteral(red: 0.4392156899, green:0.01176470611, blue: 0.1921568662, alpha: 1)
        btnAddMsg.layer.borderWidth = 1
        btnAddMsg.layer.cornerRadius = 8
//        btnAddMsg.titleLabel?.text = "OK"
//        btnAddMsg.titleLabel?.attributedText = attributedString
        btnAddMsg.addTarget(self, action:#selector(self.imageButtonTapped(_:)), for: .touchUpInside)
        
        customView.addSubview(txtField)
        customView.addSubview(btnAddMsg)

        txtChat.inputAccessoryView = customView

        
    }
    
    @IBAction func Alert(msg: String)
    {
        let alertController = UIAlertController(title: title, message: msg, preferredStyle:UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default) { action -> Void in
            self.sendMessage()
        })
        self.present(alertController, animated: true, completion: nil)
    }
    

    
    func sendMessage(){
        if (self.respuesta == ""){
            Alert(msg: "Por favor, escriba un comentario")
            return 
        }
        let S = Singleton.shared
        solicitudManager.postRequestMessage(
            permissionData: S.getUser().accessToken!,
            user_id: S.getUser().id!,
            respuesta: respuesta,
            denunciamobile_id: self.denunciamobile_id
            )
        //activityEnable()
    }
    

    
    @objc func imageButtonTapped(_ sender:UIButton!){
//        print(self.txtField.text as Any)
        self.respuesta = self.txtField.text ?? ""
        self.sendMessage()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print("Total filas: \(Respuestas.count)")
        return Respuestas.count
    }

//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 290
//    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "respuestaCell", for: indexPath) as! CeldaChatViewCell
        let respuesta: RespuestaModel! = Respuestas[indexPath.row]

        cell.txtMessage.text = respuesta.respuesta
        cell.txtMessage.adjustUITextViewHeight()
        
        return cell
    }
    

}

extension ChatListViewController: SolicitudManagerDelegate{
    func didGetSolicitudOk(Solicitud: SolicitudModel) {
        self.GetSolicitudListOk = Solicitud;
    }
    
    func didGetSolicitudFail(_str: String) {
        self.errorSet = _str
    }
    
    func getResponseSolicitudAPIOK(){
        DispatchQueue.main.async { [self] in
            MessageBox(_msg: GetSolicitudListOk!.msg)
            self.dismiss(animated: true)
        }
    }
    
    func viewErrorConnectionAPI(){
        DispatchQueue.main.async { [self] in
            MessageBox(_msg: errorSet)
        }
    }

    func MessageBox(_msg: String){
        Alert(msg: _msg)
        //activityDisable()
    }
    
}

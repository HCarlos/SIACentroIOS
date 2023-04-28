//
//  RecuperarContrasenaController.swift
//  SIACentro
//
//  Created by Carlos Manuel Hidalgo Ruiz on 27/04/23.
//

import UIKit

class RecuperarContrasenaController: UIViewController {

    @IBAction func lblExit(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBOutlet var txtEmail: UITextField!
    
    @IBAction func txtEmail(_ sender: Any) {
    }
    
    @IBOutlet var lblMessage: UILabel!
    
    @IBOutlet var activity: UIActivityIndicatorView!
    
    @IBAction func btnEnviar(_ sender: Any) {
        
        let device = UIDevice.current
        let email: String = txtEmail.text ?? ""
        
        if (email != ""){
            passwordManager.postRequest(email: email, device_name: device.model)
            
            activity.startAnimating()
            activity.isHidden = false
            lblMessage.text = "Enviando email..."

        }else{
            self.closeView = false
            Alert(msg: "Proporcione una cuenta de correo válido");
        }


    }

    let S = Singleton.shared
    
    lazy var passwordManager = PasswordManager()
    lazy var GetRecoveryPasswordListOk: PasswordModel? = nil {
        didSet{
            getResponseRecoveryPasswordAPIOK()
        }
    }
    
    lazy var errorSet: String = "" {
        didSet{
            viewErrorConnectionAPI()
        }
    }
    
    var closeView:          Bool  = true


    override func viewDidLoad() {
        super.viewDidLoad()
        activity.isHidden = true
        self.hideKeyboardWhenTappedAround()

        view.insertSubview(Funciones.setImagenFondo(), at: 0)

        txtEmail.textColor = #colorLiteral(red: 0.5529411765, green: 0.4431372549, blue: 0.1843137255, alpha: 1)
        txtEmail.layer.borderColor = #colorLiteral(red: 0.5529411765, green: 0.4431372549, blue: 0.1843137255, alpha: 1)
        txtEmail.layer.borderWidth = 1
        txtEmail.layer.cornerRadius = 8
        
        
        passwordManager.delegate = self


    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func Alert(msg: String)
    {
        let alertController = UIAlertController(title: title, message: msg, preferredStyle:UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default) { action -> Void in
            if (self.closeView){
                self.dismiss(animated: true)
            }else{
                self.closeView = true
            }
        })
        self.present(alertController, animated: true, completion: nil)
    }

    
    func getResponseRecoveryPasswordAPIOK(){
        DispatchQueue.main.async { [self] in
            if GetRecoveryPasswordListOk?.status == 0 {
                if GetRecoveryPasswordListOk?.msg == "" {
                    lblMessage.text = "Ocurrió un error"
                }else{
                    lblMessage.text = GetRecoveryPasswordListOk?.msg
                }
            }else{
                _ = Singleton.shared;
                lblMessage.text = "Se ha enviado el correo de recuperación"
            }
            Alert(msg: lblMessage.text!)
            activity.stopAnimating()
            activity.isHidden = true
        }
    }

    
    func viewErrorConnectionAPI(){
        DispatchQueue.main.async { [self] in
            lblMessage.text = errorSet
        }
    }

}

extension RecuperarContrasenaController: PasswordManagerDelegate {
    func getResponseRecoveryPasswordAPIOK(PasswordUser: PasswordModel) {
        self.GetRecoveryPasswordListOk = PasswordUser
    }
    
    func didFailWithError(_str: String) {
        print(_str)
        self.errorSet = _str
    }
}

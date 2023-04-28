//
//  ViewController.swift
//  SIACentro
//
//  Created by Carlos Manuel Hidalgo Ruiz on 10/02/23.
//

import UIKit
import SwiftUI

class LoginViewController: UIViewController {
    
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var lblError: UILabel!
    @IBOutlet weak var Activity: UIActivityIndicatorView!
    @IBOutlet weak var logo: UIImageView!
    
    @IBOutlet var btnOlvideMiContrasena: UIButton!

    @IBAction func btnOlvideMiContrasena(_ sender: UIButton) {
//        let alertController = UIAlertController(title: title, message: "Modulo en construcción", preferredStyle:UIAlertController.Style.alert)
//        alertController.addAction(UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default) { action -> Void in
//            // Put your code here
//        })
//        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBOutlet var btnQuieroRegistrarme: UIButton!
    
    @IBAction func btnQuieroRegistrarme(_ sender: UIButton) {
    }
    
    lazy var userManager = UserManager()
    
    lazy var UserLogged: UserModel? = nil {
        didSet{
            getResponseAPI()
        }
    }
    
    lazy var errorSet: String = "" {
        didSet{
            viewErrorConnectionAPI()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        userManager.delegate = self
        Activity.isHidden = true
        self.hideKeyboardWhenTappedAround()

        view.insertSubview(Funciones.setImagenFondo(), at: 0)

        txtUsername.textColor = #colorLiteral(red: 0.5529411765, green: 0.4431372549, blue: 0.1843137255, alpha: 1)
        txtUsername.layer.borderColor = #colorLiteral(red: 0.5529411765, green: 0.4431372549, blue: 0.1843137255, alpha: 1)
        txtUsername.layer.borderWidth = 1
        txtUsername.layer.cornerRadius = 8

        txtPassword.textColor = #colorLiteral(red: 0.5529411765, green: 0.4431372549, blue: 0.1843137255, alpha: 1)
        txtPassword.layer.borderColor = #colorLiteral(red: 0.5529411765, green: 0.4431372549, blue: 0.1843137255, alpha: 1)
        txtPassword.layer.borderWidth = 1
        txtPassword.layer.cornerRadius = 8
        
        //btnOlvideMiContrasena.isHidden = true

    }
            

    @IBAction func btnIngresar(_ sender: UIButton) {
        
        var Username = txtUsername.text
        var Password = txtPassword.text
        Username = Username == nil || Username == "" ? "" : Username
        Password = Password == nil || Password == "" ? "" : Password
        
        self.lblError.text = "Iniciando sessión..."
        
        Activity.isHidden = false
        Activity.startAnimating()
        
        userManager.postRequest(username: Username ?? "", password: Password ?? "")
        
    }
    
    func getResponseAPI(){
        DispatchQueue.main.async { [self] in
            if UserLogged!.status == 0 {
                if UserLogged!.msg == "" {
                    lblError.text = "No haz proporcionado los datos requeridos..."
                }else{
                    lblError.text = UserLogged!.msg
                }
            }else{
                let S = Singleton.shared;
                var gen = "a"
                if UserLogged!.genero == 1{
                    gen = "o"
                }
                lblError.text = "Bienvenid"+gen+": " + S.getUser().nombre! + " " + S.getUser().apPaterno!
                //[self, init(identifier: MisDenunciasViewController);]
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let myVC = storyboard.instantiateViewController(withIdentifier: "Navigator1")
                    self.present(myVC, animated: true, completion: nil)
                
            }
            
            Activity.stopAnimating()
            Activity.isHidden = true

        }
    }

    func viewErrorConnectionAPI(){
        DispatchQueue.main.async { [self] in
            lblError.text = errorSet
        }
    }
    
}

extension LoginViewController: UserManagerDelegate{
    func didLoginUser(User: UserModel) {
        self.UserLogged = User;
    }
    
    func didFailWithError(_str: String) {
        self.errorSet = _str
    }
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}



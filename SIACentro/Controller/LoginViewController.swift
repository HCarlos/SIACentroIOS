//
//  ViewController.swift
//  SIACentro
//
//  Created by Carlos Manuel Hidalgo Ruiz on 10/02/23.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var lblError: UILabel!
    
    @IBOutlet weak var Activity: UIActivityIndicatorView!
    
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
        
        // Do any additional setup after loading the view.
    }
            

    @IBAction func btnIngresar(_ sender: UIButton) {
        
        var Username = txtUsername.text
        var Password = txtPassword.text
        Username = Username == nil ? "nada" : Username
        Password = Password == nil ? "algo" : Password
        
        self.lblError.text = "Iniciando sessión..."
        
        let concat = Username! + " " + Password!
        
        print("PRESIONASTE : " + concat)
        Activity.isHidden = false
        Activity.startAnimating()
        
        //userManager.fetchUserAPI()
        
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
        print(User)
        self.UserLogged = User;
    }
    
    func didFailWithError(_str: String) {
        print(_str)
        self.errorSet = _str
    }
    
}


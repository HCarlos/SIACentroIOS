//
//  ViewController.swift
//  SIACentro
//
//  Created by Carlos Manuel Hidalgo Ruiz on 10/02/23.
//

import UIKit

class ViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBAction func btnIngresar(_ sender: UIButton) {
        
        var Username = txtUsername.text
        var Password = txtPassword.text
        Username = Username == nil ? "nada" : Username
        Password = Password == nil ? "algo" : Password
        
        let concat = Username! + " " + Password!
        
        print("PRESIONASTE : " + concat)
        
        
    }
    
    
    
    
    
}


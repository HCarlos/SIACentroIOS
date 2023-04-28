//
//  RegistryViewController.swift
//  SIACentro
//
//  Created by Carlos Manuel Hidalgo Ruiz on 12/04/23.
//

import UIKit

class RegistryViewController : UIViewController {
    
    @IBOutlet var txtCURP: UITextField!
    @IBOutlet var txtAp_Paterno: UITextField!
    @IBOutlet var txtAp_Materno: UITextField!
    @IBOutlet var txtNombre: UITextField!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtDomicilio: UITextField!
    @IBOutlet var mnuGenero: UIButton!
    @IBOutlet var lblMsg: UILabel!
    @IBOutlet var activity: UIActivityIndicatorView!
    @IBOutlet var btnRegistrar: UIButton!
    
    @IBAction func btnCloseWindows(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func btnRegistrar(_ sender: Any) {
        if ( validObjects() ){
            activity.isHidden = false
            activity.startAnimating()
            lblMsg.text = "Enviando información..."
            sendDataRegistry()
        }
//        self.dismiss(animated: true)
    }
    
    let arrGenerosIds:[Int]    = [-1, 0, 1, 2]
    let arrGenerosTitles:[String] = ["Seleccione un Género", "Mujer", "Hombre", "No definido"]
    var Genero: Int = -1
    var GenerosStr: String = ""
    var closeView: Bool = false
    
    lazy var registerManager = RegisterManager()
    lazy var GetRegisterUserOk: RegisterModel? = nil {
        didSet{
            getRegisterUserAPIOK()
        }
    }
    
    lazy var errorSet: String = "" {
        didSet{
            viewErrorConnectionAPI()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        view.insertSubview(Funciones.setImagenFondo(), at: 0)
        lblMsg.text = ""
        activity.isHidden = true
        sayGeneros()
        txtCURP = formatTextEditObject(txtF: txtCURP)
        txtAp_Paterno = formatTextEditObject(txtF: txtAp_Paterno)
        txtAp_Materno = formatTextEditObject(txtF: txtAp_Materno)
        txtNombre = formatTextEditObject(txtF: txtNombre)
        txtEmail = formatTextEditObject(txtF: txtEmail)
        txtDomicilio = formatTextEditObject(txtF: txtDomicilio)
        mnuGenero.layer.borderColor = #colorLiteral(red: 0.5529411765, green: 0.4431372549, blue: 0.1843137255, alpha: 1)
        mnuGenero.layer.borderWidth = 1
        mnuGenero.layer.cornerRadius = 8;
        mnuGenero.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        mnuGenero.contentEdgeInsets = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
//        mnuGenero.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        registerManager.delegate = self
        
    }
    
    func formatTextEditObject(txtF: UITextField) -> UITextField {
        txtF.textColor = #colorLiteral(red: 0.5529411765, green: 0.4431372549, blue: 0.1843137255, alpha: 1)
        txtF.layer.borderColor = #colorLiteral(red: 0.5529411765, green: 0.4431372549, blue: 0.1843137255, alpha: 1)
        txtF.layer.borderWidth = 1
        txtF.layer.cornerRadius = 8;
        return txtF
    }
    
    func sayGeneros(){
        let optionClosure = { [self](action: UIAction) in
            if ((action.index(ofAccessibilityElement: (Any).self)) != 0){
                let _: Int = (action.index(ofAccessibilityElement: (Any).self))
                GenerosStr = action.title
                if let index = arrGenerosTitles.firstIndex(of: GenerosStr) {
                    Genero = index
                }
            }
        }
        self.mnuGenero.menu = UIMenu(children: [
            UIAction(title: arrGenerosTitles[0], handler: optionClosure),
            UIAction(title: arrGenerosTitles[1], handler: optionClosure),
            UIAction(title: arrGenerosTitles[2], handler: optionClosure),
            UIAction(title: arrGenerosTitles[3], handler: optionClosure),
        ])
    }
    
    func validObjects() -> Bool {
        
        if txtCURP.text == "" {
            txtCURP.becomeFirstResponder()
            Alert(msg: "No ha proporcionado la CURP")
            return false
        }
        
        if txtAp_Paterno.text == "" {
            txtAp_Paterno.becomeFirstResponder()
            Alert(msg: "Escriba su Apellido Paterno")
            return false
        }
        
        if txtAp_Materno.text == "" {
            txtAp_Materno.becomeFirstResponder()
            Alert(msg: "Escriba su Apellido Materno")
            return false
        }
        
        if txtNombre.text == "" {
            txtNombre.becomeFirstResponder()
            Alert(msg: "Escriba su Nombre")
            return false
        }
        
        if txtNombre.text == "" {
            txtNombre.becomeFirstResponder()
            Alert(msg: "Escriba un EMail válido y que consulte constantemente, porque en caso de que olvide su contraseña, se le enviará a dicho correo")
            return false
        }
        
        if txtNombre.text == "" {
            txtNombre.becomeFirstResponder()
            Alert(msg: "Escriba su Domicilio")
            return false
        }
        
        if Genero == -1 {
            Alert(msg: "Especifique un Género")
            return false
        }
        
        return true
    }
    
    @IBAction func Alert(msg: String)
    {
        let alertController = UIAlertController(title: title, message: msg, preferredStyle:UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default) { action -> Void in
            if (self.closeView){
                self.dismiss(animated: true)
            }
        })
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    func sendDataRegistry(){
        let device = UIDevice.current
        registerManager.postRequest(
            curp: (txtCURP.text)!,
            ap_paterno: txtAp_Paterno.text!,
            ap_materno: txtAp_Materno.text!,
            nombre: txtNombre.text!,
            email: txtEmail.text!,
            domicilio: txtDomicilio.text!,
            genero: Genero,
            device_name: device.model
        )
        
        //activityEnable()
    }
    
    func closeViewController(){
        self.dismiss(animated: true, completion: nil)
    }
    



}

extension RegistryViewController: RegisterManagerDelegate{
    func didRegisterUser(RegisterUser: RegisterModel) {
        self.GetRegisterUserOk = RegisterUser;
    }

    func getRegisterUserAPIOK(){
        DispatchQueue.main.async { [self] in
            var msg: String = GetRegisterUserOk!.msg
            if (GetRegisterUserOk?.status == 1){
                msg = "Registro efectuado con éxito"
                if((self.presentingViewController) != nil){
                    self.closeView = true
                    MessageBox(msg: msg)
                 }
            }else{
                MessageBox(msg: msg)
            }
        }
    }

    func didFailWithError(_str: String) {
        self.errorSet = _str
    }
    
    func viewErrorConnectionAPI(){
        DispatchQueue.main.async { [self] in
            MessageBox(msg: errorSet)
        }
    }

    func MessageBox(msg: String){
        Alert(msg: msg)
        self.activity.stopAnimating()
        self.activity.isHidden = true
        self.lblMsg.text = msg
    }
    
}

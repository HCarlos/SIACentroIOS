//
//  UISendImageControllerView.swift
//  SIACentro
//
//  Created by Carlos Manuel Hidalgo Ruiz on 07/03/23.
//

import UIKit
import CoreLocation
//import Kingfisher

class SendImageControllerView: UIViewController {
    
    @IBOutlet weak var imagenSolicitud: UIImageView!
    @IBOutlet weak var btnTomarFoto: UIButton!
    @IBOutlet weak var btnSeleccionarFoto: UIButton!
    @IBOutlet weak var btnEnviarSolicitud: UIButton!
    
    @IBOutlet weak var Activity: UIActivityIndicatorView!
    
    @IBOutlet weak var txtSolicitud: UITextField!
    
    @IBOutlet weak var btnServicios: UIButton!

    @IBOutlet var btnListo: UIButton!
    
    @IBAction func btnListo(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
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

    
    
    let arrServiciosIds:[Int]    = [0, 207, 261, 269, 14, 208, 65]
    let arrServiciosTitles:[String] = ["Seleccione un Servicio", "FUGA DE AGUA POTABLE", "ALCANTARILLADO / AGUAS NEGRAS", "SOCAVÓN / HUNDIMIENTO", "REPARACIÓN DE CALLES (BACHEO)", "ALUMBRADO PÚBLICO", "RECOLECCIÓN DE BASURA"]

    let imagePicker = UIImagePickerController()
    var locationManager = CLLocationManager()
    var currentUserLocation: CLLocation!

    var imgStr:            String = ""
    var servicioStr:       String = ""
    var servicioId:           Int = 0
    var solicitudStr:      String = ""
    var latitud:           Double = 0.00
    var longitud:          Double = 0.00
    var ubicacion:         String = ""
    var closeView:          Bool  = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = Singleton.shared

        view.insertSubview(Funciones.setImagenFondo(), at: 0)

        solicitudManager.delegate = self

        imagePicker.delegate = self
        txtSolicitud.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.requestLocation()
        
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.requestLocation()

        view.insertSubview(imagenFondo(), at: 0)

        sayImagen()
        
        btnTomarFoto.titleLabel?.font =  UIFont(name: "Arial", size: 8)
        btnSeleccionarFoto.titleLabel?.font =   .systemFont(ofSize: 14, weight: .medium)

        
        txtSolicitud.textColor = #colorLiteral(red: 0.5529411765, green: 0.4431372549, blue: 0.1843137255, alpha: 1)
        txtSolicitud.layer.borderColor = #colorLiteral(red: 0.5529411765, green: 0.4431372549, blue: 0.1843137255, alpha: 1)
        txtSolicitud.layer.borderWidth = 1
        txtSolicitud.layer.cornerRadius = 8;

        btnServicios.backgroundColor = #colorLiteral(red: 0.5529411765, green: 0.4431372549, blue: 0.1843137255, alpha: 1)
        btnServicios.layer.borderColor = #colorLiteral(red: 0.5529411765, green: 0.4431372549, blue: 0.1843137255, alpha: 1)
        btnServicios.layer.borderWidth = 1
        btnServicios.layer.cornerRadius = 8;

        Activity.isHidden = true
        self.hideKeyboardWhenTappedAround()
        
        btnServicios.showsMenuAsPrimaryAction = true
        btnServicios.changesSelectionAsPrimaryAction = true
        sayServicios()

    }

    @IBAction func btnTomarFoto(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    
    @IBAction func btnSeleccionarFoto(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)

    }

    @IBAction func btnEnviarSolicitud(_ sender: Any) {
        
        
        if imgStr == "" {
            Alert(msg: "No ha seleccionado una imagen")
            return
        }

        if (servicioStr == "" || servicioId == 0) {
            Alert(msg: "No ha seleccionado un servicio")
            return
        }

        if solicitudStr == "" {
            txtSolicitud.becomeFirstResponder()
            Alert(msg: "Escriba una breve descripción")
            return
        }
        
        if latitud == 0.00 {
            Alert(msg: "No se tiene su Geolocalización o no ha dado los permisos para obtenerlo")
            return
        }
        
        if ubicacion == "" {
            Alert(msg: "No se tiene su Ubicación o no ha dado los permisos para obtenerlo")
            return
        }

        AlertQuestion(msg: "Estamos listos para enviar los datos.\n\n¿Desea continuar?")

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
    
    @IBAction func AlertQuestion(msg: String)
    {
        let alertController = UIAlertController(title: title, message: msg, preferredStyle:UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default) { action -> Void in
            self.sendSolicitud()
        })
        alertController.addAction(UIAlertAction(title: "Cancelar", style: UIAlertAction.Style.cancel) { action -> Void in })
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func AlertServicios(){
        let alertController = UIAlertController(title: title, message: "Seleccione un Servicio", preferredStyle:UIAlertController.Style.actionSheet)
        for val in arrServiciosTitles{
            alertController.addAction(UIAlertAction(title: val, style: UIAlertAction.Style.default) { action -> Void in
                // Put your code here
            })
        }
        
        alertController.addAction(UIAlertAction(title: "Cancelar", style: UIAlertAction.Style.cancel){ action -> Void in })
        self.present(alertController, animated: true, completion: nil)

    }
    
    func sendSolicitud(){
        let S = Singleton.shared
        let device = UIDevice.current
        solicitudManager.postRequest(
            permissionData: S.getUser().accessToken!,
            user_id: S.getUser().id!,
            imagen: imgStr,
            denuncia: solicitudStr,
            servicio_id: String(servicioId),
            servicio: servicioStr,
            latitud: latitud,
            longitud: longitud,
            tipo_mobile: device.model,
            marca_mobile: device.model,
            ubicacion_id: 1,
            ubicacion: ubicacion,
            ubicacion_google: ubicacion
            )

        activityEnable()
    }
    
    func imagenFondo() -> UIImageView {
        let imageView = UIImageView(frame: UIScreen.main.bounds)
        imageView.image = UIImage(named: "Background")
        imageView.contentMode = .scaleToFill
       return imageView
    }
    
    func sayImagen(){
//        imagenSolicitud.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        imagenSolicitud.layer.shadowOffset = CGSize(width: 0, height: 1)
        imagenSolicitud.layer.shadowColor = UIColor.lightGray.cgColor
        imagenSolicitud.layer.shadowOpacity = 0.8
        imagenSolicitud.layer.shadowRadius = 15

        imagenSolicitud.layer.borderWidth = 3
        imagenSolicitud.layer.borderColor = CGColor(red: 128.0, green: 128.0, blue: 128.0, alpha: 0.8)
        imagenSolicitud.layer.cornerRadius = 15;
//        imagenSolicitud.layer.cornerRadius = imagenSolicitud.frame.width/2
        imagenSolicitud.layer.masksToBounds = true
    }
    
    func sayServicios(){
        
        let optionClosure = { [self](action: UIAction) in
            
            if ((action.index(ofAccessibilityElement: (Any).self)) != 0){
                let _: Int = (action.index(ofAccessibilityElement: (Any).self))
                
                servicioStr = action.title
                
                if let index = arrServiciosTitles.firstIndex(of: servicioStr) {
                    servicioId = index
                }
                
                
            }
        }
        
        self.btnServicios.menu = UIMenu(children: [
            UIAction(title: arrServiciosTitles[0], handler: optionClosure),
            UIAction(title: arrServiciosTitles[1], handler: optionClosure),
            UIAction(title: arrServiciosTitles[2], handler: optionClosure),
            UIAction(title: arrServiciosTitles[3], handler: optionClosure),
            UIAction(title: arrServiciosTitles[4], handler: optionClosure),
            UIAction(title: arrServiciosTitles[5], handler: optionClosure),
            UIAction(title: arrServiciosTitles[6], handler: optionClosure),
        ])
        
    }
    
    func activityEnable(){
        Activity.startAnimating()
        Activity.isHidden = false
        btnServicios.isEnabled = false
        btnTomarFoto.isEnabled = false
        btnSeleccionarFoto.isEnabled = false
        btnEnviarSolicitud.isEnabled = false
        txtSolicitud.isEnabled = false
    }

    func activityDisable(){
        Activity.stopAnimating()
        Activity.isHidden = true
        btnServicios.isEnabled = true
        btnTomarFoto.isEnabled = true
        btnSeleccionarFoto.isEnabled = true
        btnEnviarSolicitud.isEnabled = true
        txtSolicitud.isEnabled = true
    }
    
}

extension SendImageControllerView: SolicitudManagerDelegate{
    func didGetSolicitudOk(Solicitud: SolicitudModel) {
        self.GetSolicitudListOk = Solicitud;
    }
    
    func didGetSolicitudFail(_str: String) {
        self.errorSet = _str
    }
    
    func getResponseSolicitudAPIOK(){
        DispatchQueue.main.async { [self] in
            //MessageBox(msg: GetSolicitudListOk!.msg)
            var msg: String = GetSolicitudListOk!.msg
            if (GetSolicitudListOk?.status == 1){
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
    
    func viewErrorConnectionAPI(){
        DispatchQueue.main.async { [self] in
            MessageBox(msg: errorSet)
        }
    }

    func MessageBox(msg: String){
        Alert(msg: msg)
        activityDisable()
    }
    
}


extension SendImageControllerView: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let image = info[.editedImage] as? UIImage else {
//            print("No image found")
            return
        }
        
        imagenSolicitud.image = image

        let cls = Funciones()
        imgStr = cls.convertImageToBase64String(img: image)
        
        let S = Singleton.shared;
        S.setStringImageBase64(_stringImageBase64: imgStr)

    }
    
}

extension SendImageControllerView: UITextFieldDelegate{
    
    func textFieldDidChange(_ textField: UITextField) {
        solicitudStr = textField.text!
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        solicitudStr = textField.text!
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        solicitudStr = textField.text!
    }
    
}

extension SendImageControllerView: CLLocationManagerDelegate{

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
         print("error:: \(error.localizedDescription)")
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let locationSafe = locations.first {
            locationManager.stopUpdatingLocation()
            latitud = locationSafe.coordinate.latitude
            longitud = locationSafe.coordinate.longitude
            let geocoder = CLGeocoder()
            if locations.first != nil {
                geocoder.reverseGeocodeLocation(locations[0], completionHandler: { (placemarks, error) in
                    if (error != nil) {
                        print("Error in reverseGeocode")
                    }
                    
                    let placemark = placemarks! as [CLPlacemark]
                    
                    if placemark.count > 0 {
                        
                        let pm = placemarks![0]
                        
                        var addressString : String = ""
                        
                        if pm.thoroughfare != nil {
                            addressString = addressString + pm.thoroughfare! + ", "
                        }
                        if pm.subThoroughfare != nil {
                            addressString = addressString + pm.subThoroughfare! + ", "
                        }
                        if pm.subLocality != nil {
                            addressString = addressString + pm.subLocality! + ", "
                        }
                        if pm.locality != nil {
                            addressString = addressString + pm.locality! + ", "
                        }
                        if pm.subAdministrativeArea != nil {
                            addressString = addressString + pm.subAdministrativeArea! + ", "
                        }
                        if pm.administrativeArea != nil {
                            addressString = addressString + pm.administrativeArea! + ", "
                        }
                        if pm.country != nil {
                            addressString = addressString + pm.country! + ", "
                        }
                        if pm.postalCode != nil {
                            addressString = addressString + pm.postalCode! + " "
                        }
                        self.ubicacion = addressString
                        print(self.ubicacion)
                        
                    }
                    
                }) //Geocode
                
            }
            
        }

    }

    
}

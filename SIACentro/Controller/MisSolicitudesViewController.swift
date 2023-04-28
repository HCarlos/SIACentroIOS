//
//  MisSolicitudesViewController.swift
//  SIACentro
//
//  Created by Carlos Manuel Hidalgo Ruiz on 27/02/23.
//

import UIKit

class MisSolicitudesViewController: UIViewController {
    

    @IBOutlet weak var lblBienvenida: UILabel!
//    @IBOutlet weak var btnTomarFoto: UIButton!
    @IBOutlet weak var btnTomarFoto: UIButton!
    
    @IBAction func btnTomarFoto(_ sender: Any) {    }
    
    @IBOutlet weak var Activity: UIActivityIndicatorView!
    
    @IBOutlet weak var tblSolicitudes: UITableView!

    private var pullControl = UIRefreshControl()

    lazy var solicitudManager = SolicitudesManager()
    lazy var GetSolicitudListOk: SolicitudesModel? = nil {
        didSet{
            getResponseSolicitudAPIOK()
        }
    }
    
    lazy var errorSet: String = "" {
        didSet{
            viewErrorConnectionAPI()
        }
    }
    
    
    private var Denuncias: [DenunciaModel]!
    private var ImagenesList: [ImageneModel] = []
    private var RespuestasList: [RespuestaModel] = []
    private var SolicitudMobile_Id: String = ""

    override func viewDidLoad() {
 
        super.viewDidLoad()

        sayBtnTomarFoto()
        
        let S = Singleton.shared

//        Activity.isHidden = false
//        Activity.startAnimating()
        
        solicitudManager.delegate = self
        solicitudManager.postRequest(permissionData: S.getUser().accessToken!, user_id: S.getUser().id!)

        tblSolicitudes.dataSource = self
        tblSolicitudes.delegate = self
        
        pullControl.attributedTitle = NSAttributedString(string: "Actualizando...")
//        pullControl.addTarget(self, action: nil, for: .init())
        pullControl.addTarget(self, action: #selector(refreshListData(_:)), for: .valueChanged)

        if #available(iOS 10.0, *) {
            tblSolicitudes.refreshControl = pullControl
        } else {
            tblSolicitudes.addSubview(pullControl)
        }
        
//        self.navigationController?.setNavigationBarHidden(false, animated: true)
//        self.navigationController?.navigationBar.isHidden = false
//        self.navigationController?.isNavigationBarHidden = false

    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        navigationController?.setNavigationBarHidden(false, animated: animated)
//    }
    
    func getResponseSolicitudAPIOK(){
        DispatchQueue.main.async { [self] in
            if GetSolicitudListOk?.status == 0 {
                if GetSolicitudListOk?.msg == "" {
//                    lblBienvenida.text = "Error.."
                }else{
//                    lblBienvenida.text = GetSolicitudListOk?.msg
                }
            }else{
                _ = Singleton.shared;
//                lblBienvenida.text = "Mis solicitudes: "
            }
            Denuncias = GetSolicitudListOk?.denuncias

            tblSolicitudes.reloadData()
            self.pullControl.endRefreshing()

//            Activity.stopAnimating()
//            Activity.isHidden = true

        }
    }
    
    func viewErrorConnectionAPI(){
        DispatchQueue.main.async { [self] in
            lblBienvenida.text = errorSet
//            Activity.stopAnimating()
//            Activity.isHidden = true
        }
    }
    
    func sayBtnTomarFoto(){
        btnTomarFoto.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)

        btnTomarFoto.layer.shadowOffset = CGSize(width: 0, height: 1)
        btnTomarFoto.layer.shadowColor = UIColor.lightGray.cgColor
        btnTomarFoto.layer.shadowOpacity = 1
        btnTomarFoto.layer.shadowRadius = 5

        btnTomarFoto.layer.cornerRadius = btnTomarFoto.frame.width/2
        btnTomarFoto.layer.masksToBounds = false
    }
    
    @objc private func refreshListData(_ sender: Any) {
        let S = Singleton.shared
        solicitudManager.postRequest(permissionData: S.getUser().accessToken!, user_id: S.getUser().id!)
    }
}


extension MisSolicitudesViewController: SolicitudesManagerDelegate{
    func didGetSolicitudesOk(Solicitud: SolicitudesModel) {
        self.GetSolicitudListOk = Solicitud;
    }
    
    func didGetSolicitudesFail(_str: String) {
        print(_str)
        self.errorSet = _str
    }
    
}


extension MisSolicitudesViewController: UITableViewDataSource, UITableViewDelegate, CeldaImagesListViewCellDelegate, CeldaChatListViewCellDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            return "Mis Solicitudes"
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
            return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Denuncias?.count ?? 0
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tblSolicitudes.dequeueReusableCell(withIdentifier: "CeldaTableViewCell", for: indexPath) as! CeldaTableViewCell
        let model = (Denuncias?[indexPath.row])!
        
        cell.delegateImageList = self
        cell.delegateChatList = self
        cell.pintaViewCell()
        cell.configure(model: model)
        cell.btnImagen.tag = indexPath.row
        
        return cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = Denuncias?[indexPath.row]
        print("CELL: \(String(describing: model?.denuncia))")
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
    }
    
    func callSegueFromCellImageList( Imagenes: [ImageneModel], SolicitudMobile_Id: String ) {
        self.ImagenesList = Imagenes
        self.SolicitudMobile_Id = SolicitudMobile_Id
        self.performSegue(withIdentifier: "goToImagesList", sender:self )
    }
    
    func callSegueFromCellChatList(Respuestas: [RespuestaModel], SolicitudMobile_Id: String) {
        self.RespuestasList = Respuestas
        self.SolicitudMobile_Id = SolicitudMobile_Id
        self.performSegue(withIdentifier: "goToRespuestaList", sender:self )
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "goToImagesList") {
            if let destination = segue.destination as? ImagesListViewController {
                destination.Imagenes = self.ImagenesList
                destination.denunciamobile_id = self.SolicitudMobile_Id
            }
        }
        
        if(segue.identifier == "goToRespuestaList") {
            if let destination = segue.destination as? ChatListViewController {
                destination.Respuestas = self.RespuestasList
                destination.denunciamobile_id = self.SolicitudMobile_Id
            }
        }

    }
    
}


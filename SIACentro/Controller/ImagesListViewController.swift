//
//  ImagesListTableViewController.swift
//  SIACentro
//
//  Created by Carlos Manuel Hidalgo Ruiz on 16/03/23.
//

import UIKit

class ImagesListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var Imagenes:[ImageneModel] = []
    
    @IBAction func btnListo(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Imagenes.count
    }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as! CeldaImageBigTableViewCell
        let imgModel: ImageneModel! = Imagenes[indexPath.row]
        let urlImage = imgModel.url  ?? ""
        
        if ( urlImage != "" ){
            let fileUrl = URL(string: urlImage )
            cell.loadImageWithKF(url: fileUrl!)
        }

        
        return cell
    }

}

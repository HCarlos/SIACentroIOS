//
//  ChatListTableViewController.swift
//  SIACentro
//
//  Created by Carlos Manuel Hidalgo Ruiz on 17/03/23.
//

import UIKit

class ChatListTableViewController: UITableViewController {

    var Respuestas:[RespuestaModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Respuestas.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "respuestaCell", for: indexPath) as! CeldaChatTableViewCell
        let respuesta: RespuestaModel! = Respuestas[indexPath.row]

        cell.lblMessage.text = respuesta.respuesta
        
        return cell
    }
    

}

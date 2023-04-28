//
//  CeldaChatTableViewCell.swift
//  SIACentro
//
//  Created by Carlos Manuel Hidalgo Ruiz on 17/03/23.
//

import UIKit

class CeldaChatViewCell: UITableViewCell {

    @IBOutlet var txtMessage: UITextView!

}

extension UITextView {
    func adjustUITextViewHeight() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.sizeToFit()
        self.isScrollEnabled = false
    }
}

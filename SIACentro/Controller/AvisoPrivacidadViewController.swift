//
//  AvisoPrivacidadViewController.swift
//  SIACentro
//
//  Created by Carlos Manuel Hidalgo Ruiz on 27/02/23.
//

import UIKit
import WebKit

class AvisoPrivacidadViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet var activity: UIActivityIndicatorView!
    @IBOutlet var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activity?.isHidden = false
        activity?.startAnimating()
        let S = Singleton.shared
        view.insertSubview(Funciones.setImagenFondo(), at: 0)
        let url = URL(string: S.getAvisoApp())!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
 
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        activity?.stopAnimating()
    }
    

 
    
}

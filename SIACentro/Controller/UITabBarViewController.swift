//
//  UITabBarViewController.swift
//  SIACentro
//
//  Created by Carlos Manuel Hidalgo Ruiz on 01/03/23.
//

import Foundation
import UIKit

class UITabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if let tabBarController = self as? UITabBarController {
//            tabBarController.selectedIndex = 1
//        }

        let tabBarController: UITabBarController = self
        tabBarController.selectedIndex = 1
        //setupMiddleButton()
    }
    
    func setupMiddleButton() {
            let menuButton = UIButton(frame: CGRect(x: 0, y: 0, width: 48, height: 48))
            var menuButtonFrame = menuButton.frame
            menuButtonFrame.origin.y = view.bounds.height - menuButtonFrame.height - 40
            menuButtonFrame.origin.x = view.bounds.width/2 - menuButtonFrame.size.width/2
            menuButton.frame = menuButtonFrame

            menuButton.backgroundColor = #colorLiteral(red: 0.337254902, green: 0.3450980392, blue: 0.3529411765, alpha: 1)
            menuButton.layer.cornerRadius = menuButtonFrame.height/2
            view.addSubview(menuButton)
        
            //let Img: UIImage = UIImage(named: "icon_denuncia")!
            let Img: UIImage = #imageLiteral(resourceName: "icon_denuncia")
            let size = CGSize(width: 100.0, height: 100.0)
            let newImage = Img.resize(withSize: size, contentMode: .contentAspectFill)
        
            menuButton.setImage(newImage, for: .normal)
            menuButton.addTarget(self, action: #selector(menuButtonAction(sender:)), for: .touchUpInside)

            view.layoutIfNeeded()
        }


        // MARK: - Actions

        @objc private func menuButtonAction(sender: UIButton) {
            selectedIndex = 1
        }

    
    
}

extension UIImage {
    enum ContentMode {
        case contentFill
        case contentAspectFill
        case contentAspectFit
    }
    
    func resize(withSize size: CGSize, contentMode: ContentMode = .contentAspectFill) -> UIImage? {
        let aspectWidth = size.width / self.size.width
        let aspectHeight = size.height / self.size.height
        
        switch contentMode {
        case .contentFill:
            return resize(withSize: size)
        case .contentAspectFit:
            let aspectRatio = min(aspectWidth, aspectHeight)
            return resize(withSize: CGSize(width: self.size.width * aspectRatio, height: self.size.height * aspectRatio))
        case .contentAspectFill:
            let aspectRatio = max(aspectWidth, aspectHeight)
            return resize(withSize: CGSize(width: self.size.width * aspectRatio, height: self.size.height * aspectRatio))
        }
    }
    
    private func resize(withSize size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, self.scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
}

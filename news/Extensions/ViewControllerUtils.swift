//
//  ViewControllerUtils.swift
//  tadreeb_ihssa
//
//  Created by mini mac on 8/9/17.
//  Copyright © 2017 mini mac. All rights reserved.
//

import Foundation

import Foundation
import UIKit
import Toast_Swift


class ViewControllerUtils : UIView{
    
    
func showAlert(controller: UIViewController, title: String, message: String){
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertController.addAction(defaultAction)
    controller.present(alertController, animated: true, completion: nil)
    
    
}
    
    func showToast(uView: UIView, msg: String, position: ToastPosition) {
        var style = ToastStyle()
        style.messageFont = UIFont(name:  "HacenTunisiaLt", size: 17.0)!
        style.messageAlignment = .center
        uView.makeToast(msg, duration: 2.5, position: position, style: style)
    }
    
    
}



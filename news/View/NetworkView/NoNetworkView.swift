//
//  NoNetworkView.swift
//  almasjed_ios
//
//  Created by Mamdouh Embabi on 3/27/18.
//  Copyright © 2018 ios. All rights reserved.

import UIKit

@objc protocol refreshNetworkDelegate {
    @objc optional func refreshNetwork()
}

@IBDesignable

class NoNetworkView: UIView {
    
    var contentView : UIView?
  
    var delegate : refreshNetworkDelegate?
    var notificationCenterName : String = "reloadNetwork"
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    func xibSetup() {
        contentView = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        contentView!.frame = bounds
        
        // Make the view stretch with containing view
        contentView!.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(contentView!)
    }
    
    func loadViewFromNib() -> UIView! {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
   
        
        return view
    }
    
  
    
    @IBAction func reloadBtnPressed(_ sender: Any) {
        if delegate != nil {
            
            delegate?.refreshNetwork!()
            
        }
        
        print("Reload Network Btn Pressed notificationCenterName = \(notificationCenterName)")
//        // Define identifier
//        let notificationName = Notification.Name(notificationCenterName)
//
//        // Post notification
//        NotificationCenter.default.post(name: notificationName, object: nil)
        
    }
}

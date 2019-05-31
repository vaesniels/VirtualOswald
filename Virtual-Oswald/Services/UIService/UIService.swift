//
//  UIService.swift
//  Virtual-Oswald
//
//  Created by niels vaes on 06/03/2019.
//  Copyright © 2019 niels vaes. All rights reserved.
//

import Foundation
import UIKit

class UIService{
    
    func createOkAlert(Title: String, Message : String) -> UIAlertController{
        let alert = UIAlertController(title: Title, message: Message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
            (action) in alert.dismiss(animated: true, completion: nil)
        }))
        return alert;
    }
    
    func createSettingsAlert(Title: String, Message : String) -> UIAlertController{
        
        weak var weakSelf = self
        let alert = UIAlertController.init(title: Title,
                                           message: Message,
                                           preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Sluiten", style: UIAlertAction.Style.cancel, handler: {
            (action) in alert.dismiss(animated: true, completion: nil)
        }))
        let okAction = UIAlertAction.init(title: "Naar intellingen",
                                          style: UIAlertAction.Style.default) { (UIAlertAction) in
                                            weakSelf?.goToAppSettings()
        }
        alert.addAction(okAction)
        return alert;
    }
    
    
    func goToAppSettings(){
        if let settingsURL = NSURL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.openURL(settingsURL as URL)
        }
    }
}

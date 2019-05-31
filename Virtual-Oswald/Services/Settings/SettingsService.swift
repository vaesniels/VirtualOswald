//
//  SettingsService.swift
//  Virtual-Oswald
//
//  Created by Yari Crollet on 09/04/2019.
//  Copyright © 2019 niels vaes. All rights reserved.
//

import Foundation

class SettingsService {
    
    var pitchValue: Float = 0.5
    var speechRate: Float = 0.5
    var demoApplication: Bool?
    
    init(){
        registerSettingsBundle()
        NotificationCenter.default.addObserver(self, selector: #selector(defaultsChanged), name: UserDefaults.didChangeNotification, object: nil)
        defaultsChanged()
    }
    
    
    func registerSettingsBundle(){
        let appDefaults = [String:AnyObject]()
        UserDefaults.standard.register(defaults: appDefaults)
    }
    
    //If a setting changes this function will update the variables in the app accordingly
    @objc func defaultsChanged(){
        if UserDefaults.standard.bool(forKey: "pitchValue") {
            self.pitchValue = UserDefaults.standard.float(forKey: "pitchValue")
        }
        if UserDefaults.standard.bool(forKey: "speechRate") {
            self.speechRate = UserDefaults.standard.float(forKey: "speechRate")
        }
        if UserDefaults.standard.bool(forKey: "DemoApplication") {
            self.demoApplication = UserDefaults.standard.bool(forKey: "DemoApplication")
        }
    }
    
    private static var sharedSettings: SettingsService = {
        let settings = SettingsService();
        return settings
    }()
    
    class func shared() -> SettingsService {
        return sharedSettings
    }
    
    
    
    
}

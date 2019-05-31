//
//  NetworkService.swift
//  Virtual-Oswald
//
//  Created by Yari Crollet on 29/04/2019.
//  Copyright © 2019 niels vaes. All rights reserved.
//

import Foundation
import Reachability

class NetworkService {
    
    let reachability = Reachability()!
    var delegate: NetworkDelegate?
    init() {
        self.checkConnection()
    }
    
    func checkConnection(){
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    
    
    @objc func reachabilityChanged(note: Notification) {
        let reachability = note.object as! Reachability
        switch reachability.connection {
        case .wifi:
            self.delegate?.OnNetworkConnected(isConnected: true)
        case .cellular:
            self.delegate?.OnNetworkConnected(isConnected: true)
        case .none:
            self.delegate?.OnNetworkConnected(isConnected: false)
        }
    }
    
    private static var sharedInstance: NetworkService = {
        let shared = NetworkService();
        return shared
    }()
    
    class func shared() -> NetworkService {
        return sharedInstance
    }
    
    
}

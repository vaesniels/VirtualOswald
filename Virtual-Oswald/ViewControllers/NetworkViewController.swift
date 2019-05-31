//
//  NetworkViewController.swift
//  Virtual-Oswald
//
//  Created by Yari Crollet on 29/04/2019.
//  Copyright © 2019 niels vaes. All rights reserved.
//

import UIKit

class NetworkViewController: UIViewController {

    var networkService: NetworkService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        networkService = NetworkService.shared()
        networkService.delegate = self
    }

}

extension NetworkViewController: NetworkDelegate {
    func OnNetworkConnected() {
        self.dismiss(animated: true, completion: nil)
    }
}

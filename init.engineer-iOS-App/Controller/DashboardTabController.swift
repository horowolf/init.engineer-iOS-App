//
//  DashboardTabController.swift
//  init.engineer-iOS-App
//
//  Created by horo on 6/6/20.
//  Copyright © 2020 Kantai Developer. All rights reserved.
//

import UIKit

class DashboardTabController: UIViewController {
    @IBOutlet weak var userImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let accessToken = KeyChainManager.shared.getToken() {
            print(accessToken)
        }
        else {
            self.performSegue(withIdentifier: K.dashboardToLoginSegue, sender: self)
        }
    }


}

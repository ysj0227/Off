//
//  OwnerChatListViewController.swift
//  OfficeGo
//
//  Created by mac on 2020/6/18.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class OwnerChatListViewController: RenterChatListViewController {

    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            let tab = self.navigationController?.tabBarController as? OwnerMainTabBarController
            tab?.customTabBar.isHidden = true
        }
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            let tab = self.navigationController?.tabBarController as? OwnerMainTabBarController
            tab?.customTabBar.isHidden = false
           juddgeIsLogin()
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
}

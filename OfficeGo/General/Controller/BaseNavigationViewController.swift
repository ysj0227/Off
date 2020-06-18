//
//  BaseNavigationViewController.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/4/26.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class BaseNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.barTintColor = UIColor.white  //导航栏底色
        
        navigationBar.backgroundColor = UIColor.white
        navigationBar.titleTextAttributes = [NSAttributedString.Key.font:FONT_MEDIUM_17,NSAttributedString.Key.foregroundColor:kAppColor_333333]
        
//        self.view.backgroundColor = kAppWhiteColor
//        self.isNavigationBarHidden = true;
//        self.navigationBar.isHidden = true
//        self.interactivePopGestureRecognizer?.isEnabled = true
        
        navigationBar.isHidden = true
    }

    // MARK: - 重写pushViewController方法
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
//        let appdelegate = UIApplication.shared.delegate as? AppDelegate
//        let tab = appdelegate?.window?.rootViewController as? RenterMainTabBarController
//        if viewControllers.count > 0 {
//            tab?.customTabBar.isHidden = true
//        }else {
//            tab?.customTabBar.isHidden = false
//        }
        super.pushViewController(viewController, animated: animated)
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
//        let appdelegate = UIApplication.shared.delegate as? AppDelegate
//        let tab = appdelegate?.window?.rootViewController as? RenterMainTabBarController
//        if viewControllers.count > 0 {
//            tab?.customTabBar.isHidden = true
//        }else {
//            tab?.customTabBar.isHidden = false
//        }
        return super.popViewController(animated: animated)
    }
    
    
    override var shouldAutorotate: Bool {
        get {
            return self.topViewController?.shouldAutorotate ?? false
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return self.topViewController?.supportedInterfaceOrientations ?? .portrait
        }
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        get {
            return self.topViewController?.preferredInterfaceOrientationForPresentation ?? .portrait
        }
    }
}

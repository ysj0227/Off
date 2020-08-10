//
//  RenterMainTabBarController.swift
//  UUStudent
//
//  Created by Fei DENG on 2018/12/12.
//  Copyright © 2018年 bike. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RenterMainTabBarController: UITabBarController {
    
   @objc var customTabBar: SSTabBarView
    
    init() {
        customTabBar = SSTabBarView.init(tabbarItems: SSTabBarItem.defaultRenterTabBarItems())
        
        super.init(nibName: nil, bundle: nil)

        self.viewControllers = [
            BaseNavigationViewController.init(rootViewController: RenterHomePageViewController()),
            BaseNavigationViewController.init(rootViewController: RenterChatListViewController()),
            BaseNavigationViewController.init(rootViewController: RenterCollectPageViewController()),
            BaseNavigationViewController.init(rootViewController: RenterMineViewController())]
        self.selectedIndex = 0

        customTabBar.currentIndex = selectedIndex
        reloadTabbarBgColor(isCenter: true)
        self.tabBar.isHidden = true
        customTabBar.delegate = self as SSTabBarViewDelegate
        view.addSubview(self.customTabBar)
        customTabBar.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(kTabBarHeight)
        }
    }
    
    func setbadge(num: Int) {
        let items = customTabBar.itemViews[1]
        items.setBadge(num: num)
    }
    
    override var selectedIndex: Int {
        get {
            return super.selectedIndex
        }
        set {
            super.selectedIndex = newValue
            customTabBar.currentIndex = selectedIndex
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func reloadTabbarBgColor (isCenter: Bool) {
        
        customTabBar.updateTabBgColor(isCenter: isCenter)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateBadgeValueForTabBarItem()
    }
    
    func updateBadgeValueForTabBarItem() {
        let count: Int = Int(RCIMClient.shared()?.getUnreadCount([RCConversationType.ConversationType_PRIVATE.rawValue, RCConversationType.ConversationType_SYSTEM.rawValue]) ?? 0)
        self.setbadge(num: count)
    }
}

extension RenterMainTabBarController: SSTabBarViewDelegate {
    func tabbar(_ tabbar: SSTabBarView, select index: Int) {
        
        if self.selectedIndex == index {
            return
        }
        self.selectedIndex = index
        self.customTabBar.isHidden = false
    }
}

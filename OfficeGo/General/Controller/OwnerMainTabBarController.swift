//
//  OwnerOwnerMainTabBarController.swift
//  OfficeGo
//
//  Created by mac on 2020/6/18.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class OwnerMainTabBarController: UITabBarController {
    
    @objc var customTabBar: SSTabBarView
    
    init() {
        customTabBar = SSTabBarView.init(tabbarItems: SSTabBarItem.defaultOwnerTabBarItems())
        
        super.init(nibName: nil, bundle: nil)
        
        self.viewControllers = [
            BaseNavigationViewController.init(rootViewController: OwnerHomeViewController()),
            BaseNavigationViewController.init(rootViewController: OwnerChatListViewController()),
            BaseNavigationViewController.init(rootViewController: OwnerHouseScheduleViewController()),
            BaseNavigationViewController.init(rootViewController: OwnerMineViewController())]
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
            
            //当不在首页房源管理的时候，要刷新网页
            NotificationCenter.default.post(name: NSNotification.Name.OwnerClearFYManagerCache, object: nil)
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
//        updateBadgeValueForTabBarItem()
    }
    
    func updateBadgeValueForTabBarItem() {
        let count: Int = Int(RCIMClient.shared()?.getUnreadCount([RCConversationType.ConversationType_PRIVATE]) ?? 0)
        self.setbadge(num: count)
    }
}

extension OwnerMainTabBarController: SSTabBarViewDelegate {
    func tabbar(_ tabbar: SSTabBarView, select index: Int) {
        
        if self.selectedIndex == index {
            return
        }
        self.selectedIndex = index
        self.customTabBar.isHidden = false
    }
}

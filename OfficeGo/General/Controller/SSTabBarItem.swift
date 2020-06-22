//
//  SSTabBarItem.swift
//  Thor
//
//  Created by dengfeifei on 2018/9/12.
//  Copyright © 2018年 RRTV. All rights reserved.
//

import Foundation
import UIKit

class SSTabBarItem: NSObject {
    var selectImagePath: String?
    var unSelectImagePath: String?
    
    var selectImageUrl: String?
    var unSelectImageUrl: String?
    
    var selectColor: UIColor = kAppBlueColor
    var unSelectColor: UIColor = kAppTabbarGrayColor
    
    var selectTitle: String?
    var unSelectTitle: String?
    
    //租户
    static func defaultRenterTabBarItems() -> [SSTabBarItem] {
        var tabbars: [SSTabBarItem] = []
        
        var item = SSTabBarItem()
        item.selectTitle = "首页"
        item.unSelectTitle = "首页"
        item.selectImagePath = "homeSel"
        item.unSelectImagePath = "home"
        tabbars.append(item)
        
        item = SSTabBarItem()
        item.selectTitle = "消息"
        item.unSelectTitle = "消息"
        item.selectImagePath = "messageSel"
        item.unSelectImagePath = "message"
        tabbars.append(item)
        
        item = SSTabBarItem()
        item.selectTitle = "收藏"
        item.unSelectTitle = "收藏"
        item.selectImagePath = "collectSel"
        item.unSelectImagePath = "collect"
        tabbars.append(item)
        
        item = SSTabBarItem()
        item.selectTitle = "我的"
        item.unSelectTitle = "我的"
        item.selectImagePath = "mineSel"
        item.unSelectImagePath = "mine"
        tabbars.append(item)
                
        return tabbars
    }
    
    //业主
    static func defaultOwnerTabBarItems() -> [SSTabBarItem] {
        var tabbars: [SSTabBarItem] = []
        
        var item = SSTabBarItem()
        item.selectTitle = "首页"
        item.unSelectTitle = "首页"
        item.selectImagePath = "homeSel"
        item.unSelectImagePath = "home"
        tabbars.append(item)
        
        item = SSTabBarItem()
        item.selectTitle = "消息"
        item.unSelectTitle = "消息"
        item.selectImagePath = "messageSel"
        item.unSelectImagePath = "message"
        tabbars.append(item)
        
        item = SSTabBarItem()
        item.selectTitle = "行程"
        item.unSelectTitle = "行程"
        item.selectImagePath = "messageSel"
        item.unSelectImagePath = "message"
        tabbars.append(item)
        
        item = SSTabBarItem()
        item.selectTitle = "我的"
        item.unSelectTitle = "我的"
        item.selectImagePath = "mineSel"
        item.unSelectImagePath = "mine"
        tabbars.append(item)
                
        return tabbars
    }
}

//
//  OfficeGoTabBarItem.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/4/26.
//  Copyright © 2020 Senwei. All rights reserved.
//

import Foundation
import UIKit
import HandyJSON

class ThorTabBarItem: NSObject, HandyJSON {
    enum PageType: Int, HandyJSONEnum {
        case native = 0
        case html = 1
    }
    
    var pageUrl: String?
    var selectImagePath: String?
    var unSelectImagePath: String?
    
    var selectColor: UIColor = kAppBlueColor
    var unSelectColor: UIColor = kAppTabbarGrayColor
    
    var title: String?
    var pageType: PageType = .native
    var shouldLogin: Bool = false
    var showNavibar: Bool = false
    var clickID: String?
    required override init() {
        super.init()
    }
    
    func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.selectImagePath <-- "selectImage"
        mapper <<<
            self.unSelectImagePath <-- "unselectImage"
    }
    
    static func viewController(from item: ThorTabBarItem) -> BaseNavigationViewController {
        switch item.pageUrl ?? "" {
        case "RenterHomePageViewController":
            return BaseNavigationViewController.init(rootViewController: RenterHomePageViewController())
        case "RenterChatListViewController":
            return BaseNavigationViewController.init(rootViewController: RenterChatListViewController())
        case "RenterMineViewController":
            return BaseNavigationViewController.init(rootViewController: RenterMineViewController())
        case "RenterCollectPageViewController":
            return BaseNavigationViewController.init(rootViewController: RenterCollectPageViewController())
        default:
            return BaseNavigationViewController.init(rootViewController: BaseViewController())
        }
    }
}

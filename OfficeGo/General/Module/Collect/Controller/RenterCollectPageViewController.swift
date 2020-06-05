//
//  RenterCollectPageViewController.swift
//  OfficeGo
//
//  Created by mac on 2020/5/14.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class RenterCollectPageViewController: BaseViewController {
    
    //父试图
    var segScroll:MLMSegmentScroll?
    
    lazy var lineView: UIView = {
        let view = UIView(frame: CGRect.init(x: 0, y: kNavigationHeight + 58, width: self.view.width, height: 1))
        view.backgroundColor = kAppColor_line_EEEEEE
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupEvent()
    }
    func createSegment() {
        
        let segHeadFrame = CGRect.init(x: 10, y: kNavigationHeight, width: self.view.width - left_pending_space_17, height: 58)
        let segScrollFrame = CGRect.init(x: 0, y: kNavigationHeight + 58, width: self.view.width, height: self.view.height - kNavigationHeight - 58 - kTabBarHeight)
        
        let segHead = MLMSegmentHead.init(frame: segHeadFrame, titles: ["写字楼/网点", "办公室"], headStyle: .init(rawValue: 1), layoutStyle: .init(rawValue: 2))
        segHead?.fontSize = 12
        segHead?.fontScale = 1.2
        segHead?.equalSize = false
        segHead?.selectedBold = true
        segHead?.gradualChangeTitleColor = false
        segHead?.deSelectColor = kAppColor_333333
        segHead?.selectColor = kAppColor_333333
        segHead?.lineColor =  kAppClearColor
        segHead?.bottomLineColor = kAppClearColor
        
        //            let btn = UIButton()
        //            btn.backgroundColor = kAppBlueColor
        //            btn.frame = CGRect(x: self.view.width - 100, y: 0, width: 100, height: 58)
        //            segHead?.addSubview(btn)
        //            segHead?.bringSubviewToFront(btn)
        
        segScroll = MLMSegmentScroll.init(frame: segScrollFrame, vcOrViews: customChildController())
        segScroll?.canPaged = true
        MLMSegmentManager.associateHead(segHead, with: segScroll, contentChangeAni: true, completion: {[weak self] in
            guard let weakSelf = self else {return}
            weakSelf.view.addSubview(weakSelf.segScroll!)
            weakSelf.view.addSubview(segHead!)
        }) { (index) in
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
         super.viewWillDisappear(animated)
         let tab = self.navigationController?.tabBarController as? MainTabBarController
         tab?.customTabBar.isHidden = true
     }
     override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         let tab = self.navigationController?.tabBarController as? MainTabBarController
         tab?.customTabBar.isHidden = false
     }
     
    
    func customChildController() -> [UIViewController] {
        var temp:[UIViewController] = []
        let vc1 = RenterCollectOfficeBuuildingOrJointListViewController()
        let vc2 = RenterCollectOfficeListViewController()
        temp.append(vc1)
        temp.append(vc2)
        return temp
    }
    
}
extension RenterCollectPageViewController {
    func setupView() {
        
        titleview = ThorNavigationView.init(type: .collectTitleSearchBtn)
        titleview?.titleLabel.text = "收藏"
        titleview?.rightButton.isHidden = true
        titleview?.rightBtnClickBlock = {
            
        }
        self.view.addSubview(titleview!)
        
        createSegment()
        
        self.view.addSubview(lineView)
    }
    
    func setupEvent() {
        
    }
    
    func sendRefreshNotify(index: Int) {
        //        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "listLevelClick"), object: ["index": self.levelSelectIndex, "currentVc":index])
    }
    
}

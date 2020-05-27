//
//  RenterHouseScheduleDetailViewController.swift
//  OfficeGo
//
//  Created by mac on 2020/5/19.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class RenterHouseScheduleDetailViewController: BaseViewController {
    
    let topview: UIView = {
        let view = UIView()
        view.backgroundColor = kAppBlueColor
        return view
    }()
    
    let msgView: RenterScheduleDetailView = {
        let view = Bundle.main.loadNibNamed("RenterScheduleDetailView", owner: nil, options: nil)?.first as! RenterScheduleDetailView
        view.shadow(cornerRadius: 10, color: kAppColor_999999, offset: CGSize(width: 5, height: 5), radius: 4, opacity: 0.1)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
        
        setData()
    }
    
}

extension RenterHouseScheduleDetailViewController {
    
    func setView() {
        
        titleview = ThorNavigationView.init(type: .HouseScheduleHeaderView)
        titleview?.titleLabel.text = "已完成"
        titleview?.titleLabel.textAlignment = .left
        titleview?.leftButtonCallBack = { [weak self] in
            self?.leftBtnClick()
        }
        self.view.addSubview(titleview ?? ThorNavigationView.init(type: .HouseScheduleHeaderView))
        
        self.view.addSubview(msgView)
        msgView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(left_pending_space_17)
            make.top.equalTo(kNavigationHeight + 47)
            make.height.equalTo(202)
        }
    }
    
    func setData() {
        msgView.model = ""
    }
}

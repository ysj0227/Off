//
//  RecentCityTableViewCell.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/5/8.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class RecentCitiesTableViewCell: UITableViewCell {
    
    // 使用tableView.dequeueReusableCell会自动调用这个方法
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        self.backgroundColor = kAppWhiteColor
        
        let btn = UIButton(frame: CGRect(x: left_pending_space_17, y: 15.0, width: btnWidth, height: 40))
        btn.setTitle("北京", for: .normal)
        btn.setTitleColor(kAppBlackColor, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.backgroundColor = kAppColor_bgcolor_F7F7F7
        //            btn.layer.borderColor = kAppWhiteColor.cgColor
        //            btn.layer.borderWidth = 0.5
        btn.layer.cornerRadius = 1
        btn.setBackgroundImage(UIImage.create(with: kAppBlueColor), for: .highlighted)
        btn.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
        self.addSubview(btn)

    }
    
    @objc private func btnClick(btn: UIButton) {
        SSLog(btn.titleLabel?.text!)
    }



}

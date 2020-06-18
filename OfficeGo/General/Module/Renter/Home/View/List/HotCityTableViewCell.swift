//
//  HotCityTableViewCell.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/5/8.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class HotCityTableViewCell: UITableViewCell {

    /// 懒加载 热门城市
    lazy var hotCities: [String] = {
        let path = Bundle.main.path(forResource: "hotCities.plist", ofType: nil)
        let array = NSArray(contentsOfFile: path!) as? [String]
        return array ?? []
    }()
    
    /// 使用tableView.dequeueReusableCell会自动调用这个方法
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        self.backgroundColor = kAppWhiteColor
        // 动态创建城市btn
        for i in 0..<hotCities.count {
            // 列
            let column = i % 3
            // 行
            let row = i / 3
            
            let btn = UIButton(frame: CGRect(x: btnMargin + CGFloat(column) * (btnWidth + btnMargin), y: 15 + CGFloat(row) * (40 + btnMargin), width: btnWidth, height: 40))
            btn.setTitle(hotCities[i], for: .normal)
            btn.setTitleColor(kAppBlackColor, for: .normal)
            btn.titleLabel?.font = FONT_15
            btn.backgroundColor = kAppColor_bgcolor_F7F7F7
//            btn.layer.borderColor = kAppWhiteColor.cgColor
//            btn.layer.borderWidth = 0.5
            btn.layer.cornerRadius = 1
            btn.setBackgroundImage(UIImage.create(with: kAppBlueColor), for: .highlighted)
            btn.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
            self.addSubview(btn)
            
        }
    }
    
    @objc private func btnClick(btn: UIButton) {
        SSLog(btn.titleLabel?.text! ?? "")
    }

}

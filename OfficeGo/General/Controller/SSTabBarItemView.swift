//
//  SSTabBarItemView.swift
//  Thor
//
//  Created by dengfeifei on 2018/9/12.
//  Copyright © 2018年 RRTV. All rights reserved.
//

import UIKit
import SnapKit

class SSTabBarItemView: UIView {
    var isSelected: Bool {
        didSet {
            if oldValue != isSelected {
                self.reloadLayout()
            }
        }
    }
    private var item: SSTabBarItem
    private var iconView: UIImageView
    private var titleLabel: UILabel
    var badgeNum: UILabel
    init(item: SSTabBarItem) {
        self.item = item
        self.titleLabel = UILabel()
        self.titleLabel.font = UIFont.systemFont(ofSize: 10)
        self.badgeNum = UILabel()
        self.badgeNum.textAlignment = .center
        self.badgeNum.backgroundColor = kAppRedColor
        self.badgeNum.font = FONT_MEDIUM_12
        self.badgeNum.clipsToBounds = true
        self.badgeNum.layer.cornerRadius = 9
        self.isSelected = false
        self.iconView = UIImageView()
        self.iconView.contentMode = .scaleAspectFit
        super.init(frame: .zero)
        self.addSubview(self.iconView)
        self.addSubview(self.titleLabel)
        self.addSubview(self.badgeNum)
        self.iconView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(5)
            make.width.equalTo(34)
        }
        self.titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(iconView.snp.bottom).offset(3)
            make.centerX.equalToSuperview()
        }
        self.reloadLayout()
        self.isUserInteractionEnabled = false
    }
    
    func setBadge(num: Int) {
        
        if num > 0 {
            badgeNum.isHidden = false
            if (num <= 99) {
                badgeNum.text = "\(num)"
            } else if num > 99 && num < 1000 {
                badgeNum.text = "99+"
            } else {
                badgeNum.text = "···"
            }
            let width: CGFloat = badgeNum.text?.boundingRect(with: CGSize(width: kWidth, height: 19), font: FONT_MEDIUM_12).width ?? 0 > 18 ? badgeNum.text?.boundingRect(with: CGSize(width: kWidth, height: 19), font: FONT_MEDIUM_12).width ?? 0 : 18
            self.badgeNum.snp.remakeConstraints { (make) in
                make.top.equalToSuperview()
                make.height.equalTo(18)
                make.centerX.equalTo(iconView).offset(20)
                make.width.equalTo(width)
            }
        }else {
            badgeNum.isHidden = true
            self.badgeNum.snp.remakeConstraints { (make) in
                make.top.equalToSuperview()
                make.height.equalTo(18)
                make.centerX.equalTo(iconView).offset(20)
                make.width.equalTo(18)
            }
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadLayout() {
        if self.isSelected {
            self.titleLabel.text = self.item.selectTitle
            self.titleLabel.textColor = self.item.selectColor
            if self.item.selectImageUrl != nil {
            } else {
                if let imagePath = self.item.selectImagePath {
                    self.iconView.image = UIImage.init(named: imagePath)
                }
            }
        } else {
            self.titleLabel.text = self.item.unSelectTitle
            self.titleLabel.textColor = self.item.unSelectColor
            if self.item.unSelectImageUrl != nil {
            } else {
                if let imagePath = self.item.unSelectImagePath {
                    self.iconView.image = UIImage.init(named: imagePath)
                }
            }
        }
    }
}

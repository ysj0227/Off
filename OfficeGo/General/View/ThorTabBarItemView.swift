//
//  OfficeGoTabBarItemView.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/4/26.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit
import SnapKit

class ThorTabBarItemView: UIView {
    var isSelected: Bool {
        didSet {
            if oldValue != isSelected {
                self.reloadLayout()
                showTip = false
            }
        }
    }
    var showTip: Bool {
        didSet {
            tipView.isHidden = !showTip
        }
    }
    var tipView: UIView = {
        let view = UIView()
        view.backgroundColor = kAppColor_FF9600
        view.layer.cornerRadius = 4
        return view
    }()
    private var item: ThorTabBarItem
    private var iconView: BaseImageView
    private var titleLabel: BaseLabel
    init(item: ThorTabBarItem) {
        self.item = item
        self.titleLabel = BaseLabel.init(localTitle: item.title)
        self.titleLabel.backgroundColor = UIColor.clear
        self.titleLabel.font = UIFont.systemFont(ofSize: 10)
        self.isSelected = false
        self.showTip = false
        self.tipView.isHidden = true
        self.iconView = BaseImageView.init(frame:CGRect(x: 0, y: 0, width: 34, height: 34))
        self.iconView.contentMode = .scaleAspectFit
        super.init(frame: .zero)
        self.addSubview(self.iconView)
        self.addSubview(self.titleLabel)
        self.addSubview(self.tipView)
        self.iconView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(8)
            make.width.height.equalTo(24)
        }
        self.titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.snp.top).offset(41)
            make.centerX.equalToSuperview()
        }
        self.tipView.snp.makeConstraints { (make) in
            make.leading.equalTo(iconView.snp.trailing)
            make.top.equalTo(iconView)
            make.size.equalTo(8)
        }
        self.reloadLayout()
        self.isUserInteractionEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadLayout() {
        if self.isSelected {
            self.titleLabel.textColor = self.item.selectColor
            if let imagePath = self.item.selectImagePath {
                if imagePath.hasPrefix("http") {
                    self.iconView.kf.setImage(with: URL(string: imagePath))
                } else {
                    self.iconView.image = UIImage.init(named: imagePath)
                }
            }
        } else {
            self.titleLabel.textColor = self.item.unSelectColor
            if let imagePath = self.item.unSelectImagePath {
                if imagePath.hasPrefix("http") {
                    self.iconView.kf.setImage(with: URL(string: imagePath))
                } else {
                    self.iconView.image = UIImage.init(named: imagePath)
                }
            }
        }
    }
}

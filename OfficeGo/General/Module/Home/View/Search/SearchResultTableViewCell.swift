//
//  SearchResultTableViewCell.swift
//  OfficeGo
//
//  Created by mac on 2020/6/5.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class SearchResultTableViewCell: BaseTableViewCell {
    
    lazy var houseNumberLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_MEDIUM_11
        view.textColor = kAppBlueColor
        return view
    }()
    lazy var houseJiIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.init(named: "jiIcon")
        return view
    }()
    lazy var houseNameLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_LIGHT_12
        view.textColor = kAppColor_333333
        return view
    }()
    lazy var houseDictrictIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.init(named: "locationGray")
        return view
    }()
    lazy var houseDistrictBusinessLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_LIGHT_10
        view.textColor = kAppColor_333333
        return view
    }()
    lazy var houseAddressIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.init(named: "locationGray")
        return view
    }()
    lazy var houseAddressLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_LIGHT_10
        view.textColor = kAppColor_333333
        return view
    }()
    
    lazy var housePriceLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .right
        view.font = FONT_SEMBLOD_11
        view.textColor = kAppBlueColor
        return view
    }()
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = kAppColor_line_EEEEEE
        return view
    }()
    
    var model: HouseFeatureModel? {
        didSet {
            updatelayout()
            houseNumberLabel.text = "1"
            houseNameLabel.text = "上海中心大厦"
            houseDistrictBusinessLabel.text = "2.1km | 徐汇区 · 漕河泾"
            houseAddressLabel.text = ""

            housePriceLabel.text = "￥2 /㎡/天起"
        }
    }
    
    func updatelayout() {
        if model?.dictCname == "ji" {
            houseJiIcon.isHidden = false
            houseNameLabel.snp.remakeConstraints { (make) in
                make.leading.equalTo(houseJiIcon.snp.trailing).offset(6)
                make.trailing.equalToSuperview().offset(-left_pending_space_17)
                make.top.equalTo(10)
                make.height.equalTo(24)
            }
        }else {
            houseJiIcon.isHidden = true
            houseNameLabel.snp.remakeConstraints { (make) in
                make.leading.equalTo(houseNumberLabel.snp.trailing).offset(15)
                make.trailing.equalToSuperview().offset(-left_pending_space_17)
                make.top.equalTo(10)
                make.height.equalTo(24)
            }
        }
    }
    
    class func rowHeight() -> CGFloat {
        return 94
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
           super.init(style: style, reuseIdentifier: reuseIdentifier)
           setupViews()
       }
       
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        self.addSubview(houseNumberLabel)
        self.addSubview(houseJiIcon)
        self.addSubview(houseNameLabel)
        self.addSubview(houseDictrictIcon)
        self.addSubview(houseDistrictBusinessLabel)
        self.addSubview(houseAddressIcon)
        self.addSubview(houseAddressLabel)
        self.addSubview(housePriceLabel)
        self.addSubview(lineView)
        houseNumberLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(0)
            make.width.equalTo(10)
            make.centerY.equalToSuperview()
        }
        houseJiIcon.snp.makeConstraints { (make) in
            make.leading.equalTo(houseNumberLabel.snp.trailing).offset(15)
            make.size.equalTo(14)
            make.top.equalTo(15)
        }
        houseNameLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(houseJiIcon.snp.trailing).offset(6)
            make.trailing.equalToSuperview().offset(-left_pending_space_17)
            make.top.equalTo(10)
            make.height.equalTo(24)
        }
        houseDictrictIcon.snp.makeConstraints { (make) in
            make.leading.equalTo(houseNumberLabel.snp.trailing).offset(15)
            make.top.equalTo(houseNameLabel.snp.bottom).offset(3)
            make.height.equalTo(14)
            make.width.equalTo(12)
        }
        houseDistrictBusinessLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(houseDictrictIcon.snp.trailing).offset(6)
            make.centerY.equalTo(houseDictrictIcon)
        }
        houseAddressIcon.snp.makeConstraints { (make) in
            make.leading.equalTo(houseNumberLabel.snp.trailing).offset(15)
            make.top.equalTo(houseDictrictIcon.snp.bottom).offset(3)
            make.height.equalTo(14)
            make.width.equalTo(12)
        }
        houseAddressLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(houseAddressIcon.snp.trailing).offset(6)
            make.centerY.equalTo(houseAddressIcon)
        }
        housePriceLabel.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-left_pending_space_17)
            make.centerY.equalToSuperview()
        }
        lineView.snp.makeConstraints { (make) in
            make.leading.equalTo(houseNumberLabel)
            make.trailing.equalTo(-left_pending_space_17)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    

}

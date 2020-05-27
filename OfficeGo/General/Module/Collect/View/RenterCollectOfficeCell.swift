//
//  RenterCollectOfficeCell.swift
//  OfficeGo
//
//  Created by mac on 2020/5/14.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class RenterCollectOfficeCell: BaseTableViewCell {
    
    lazy var houseImageview: BaseImageView = {
        let view = BaseImageView()
        view.isUserInteractionEnabled = true
        return view
    }()
    
    lazy var houseTagLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.font = FONT_10
        view.text = "独立办公室"
        view.textColor = kAppWhiteColor
        view.backgroundColor = kAppBlueColor
        return view
    }()
    
    lazy var houseNameLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_14
        view.textColor = kAppColor_333333
        return view
    }()
    
    lazy var houseaddressIcon: BaseImageView = {
        let view = BaseImageView()
        view.image = UIImage.init(named:"locationGray")
        return view
    }()
    
    lazy var houseAddressLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_LIGHT_10
        view.textColor = kAppColor_333333
        return view
    }()
    
    lazy var firstItem: detailItemView = {
        let view = detailItemView(frame: CGRect(x: 0, y: 0, width: (kWidth - 79 - left_pending_space_17 * 2 - 11) / 3.0, height: 40))
        view.titleLabel.textAlignment = .left
        view.descripLabel.textAlignment = .left
        view.titleLabel.textColor = kAppColor_333333
        view.lineView.isHidden = true
        return view
    }()
    
    lazy var secondItem: detailItemView = {
        let view = detailItemView(frame: CGRect(x: (kWidth - 79 - left_pending_space_17 * 2 - 11) / 3.0, y: 0, width: (kWidth - 79 - left_pending_space_17 * 2 - 11) / 3.0, height: 40))
        view.lineView.isHidden = true
        return view
    }()
    
    lazy var thirdItem: detailItemView = {
        let view = detailItemView(frame: CGRect(x: (kWidth - 79 - left_pending_space_17 * 2 - 11) / 3.0 * 2, y: 0, width: (kWidth - 79 - left_pending_space_17 * 2 - 11) / 3.0, height: 40))
        view.titleLabel.textAlignment = .right
        view.descripLabel.textAlignment = .right
        view.lineView.isHidden = true
        return view
    }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = kAppColor_line_EEEEEE
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var isDuliOffice: Bool = false {
        didSet {
            reloadLayout()
        }
    }
    
    func reloadLayout() {
        if isDuliOffice {
            houseTagLabel.isHidden = true
            secondItem.isHidden = true
        }else {
            houseTagLabel.isHidden = false
            secondItem.isHidden = false
        }
    }
    
    func setupViews() {
        self.addSubview(houseImageview)
        houseImageview.addSubview(houseTagLabel)
        self.addSubview(houseNameLabel)
        self.addSubview(houseaddressIcon)
        self.addSubview(houseAddressLabel)
        self.addSubview(firstItem)
        self.addSubview(secondItem)
        self.addSubview(thirdItem)
        self.addSubview(lineView)
        
        houseImageview.snp.makeConstraints { (make) in
            make.top.equalTo(12)
            make.leading.equalTo(left_pending_space_17)
            make.size.equalTo(79)
        }
        houseTagLabel.snp.makeConstraints { (make) in
            make.top.leading.equalToSuperview()
            make.size.equalTo(CGSize(width: 63, height: 15))
        }
        houseNameLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(houseImageview.snp.trailing).offset(11)
            make.top.equalTo(houseImageview)
//            make.height.equalTo(18)
            make.trailing.equalToSuperview().offset(-left_pending_space_17)
        }
        houseaddressIcon.snp.makeConstraints { (make) in
            make.leading.equalTo(houseNameLabel)
            make.top.equalTo(houseNameLabel.snp.bottom).offset(6)
            make.size.equalTo(CGSize(width: 12, height: 14))
        }
        houseAddressLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(houseaddressIcon.snp.trailing).offset(4)
            make.centerY.equalTo(houseaddressIcon)
            make.trailing.equalTo(houseNameLabel.snp.trailing)
        }
        let width = (kWidth - 79 - left_pending_space_17 * 2 - 11) / 3.0
        firstItem.snp.makeConstraints { (make) in
            make.leading.equalTo(houseNameLabel)
            make.top.equalTo(houseAddressLabel.snp.bottom).offset(6)
            make.width.equalTo(width)
        }
        secondItem.snp.makeConstraints { (make) in
            make.top.width.equalTo(firstItem)
            make.leading.equalTo(firstItem.snp.trailing)
        }
        thirdItem.snp.makeConstraints { (make) in
            make.top.equalTo(firstItem)
            make.trailing.equalToSuperview()
            make.leading.equalTo(secondItem.snp.trailing)
        }
        lineView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(left_pending_space_17)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
            make.trailing.equalToSuperview().offset(-left_pending_space_17)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    var itemModel: String = "" {
        didSet {
            houseImageview.setImage(with: "", placeholder: UIImage.init(named: "wechat"))
            houseAddressLabel.text = "徐汇区 · 徐家汇"
            houseNameLabel.text = "上海中心大厦"
            firstItem.titleLabel.text = "119~2000㎡"
            firstItem.descripLabel.text = "面积"
            secondItem.titleLabel.text = "￥2 /㎡/天起"
            secondItem.descripLabel.text = "租金"
            thirdItem.titleLabel.text = "50套"
            thirdItem.descripLabel.text = "在租房源"
        }
    }
    
    class func rowHeight() -> CGFloat {
        return 103
    }
    
}

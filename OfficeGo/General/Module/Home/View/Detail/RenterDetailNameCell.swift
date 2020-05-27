//
//  RenterDetailNameCell.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/5/11.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class RenterDetailNameCell: BaseTableViewCell {
    
    lazy var titleLabel: UILabel = {
        let view = UILabel(frame: CGRect(x: left_pending_space_17, y: 0, width: kWidth - left_pending_space_17, height: 21 + 18 * 2))
        view.textAlignment = .left
        view.numberOfLines = 0
        view.font = FONT_15
        view.textColor = kAppColor_333333
        return view
    }()
    
    lazy var firstItem: detailItemView = {
        let view = detailItemView(frame: CGRect(x: left_pending_space_17, y: 21 + 18 * 2, width: (kWidth - left_pending_space_17 * 2) / 3.0, height: 40))
        return view
    }()

    lazy var secondItem: detailItemView = {
        let view = detailItemView(frame: CGRect(x: left_pending_space_17 + (kWidth - left_pending_space_17 * 2) / 3.0, y: 21 + 18 * 2, width: kWidth / 3.0, height: 40))
        return view
    }()

    lazy var thirdItem: detailItemView = {
        let view = detailItemView(frame: CGRect(x: left_pending_space_17 + (kWidth - left_pending_space_17 * 2) / 3.0 * 2, y: 21 + 18 * 2, width: kWidth / 3.0, height: 40))
        view.lineView.isHidden = true
        return view
    }()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        self.addSubview(titleLabel)
        self.addSubview(firstItem)
        self.addSubview(secondItem)
        self.addSubview(thirdItem)
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
            titleLabel.text = "上海中心大厦"
            firstItem.titleLabel.text = "119~2000㎡"
            firstItem.descripLabel.text = "面积"
            secondItem.titleLabel.text = "￥2 /㎡/天起"
            secondItem.descripLabel.text = "租金"
            thirdItem.titleLabel.text = "50套"
            thirdItem.descripLabel.text = "在租房源"
        }
    }
    
    class func rowHeight() -> CGFloat {
        return 107
    }
    
}

//联合办公- cell。有头部的标签
class RenterJointDetailNameCell: BaseTableViewCell {
    
    lazy var tagLabel: UILabel = {
        let view = UILabel(frame: CGRect(x: left_pending_space_17, y: 5, width: 52, height: 21))
        view.textAlignment = .center
        view.font = FONT_10
        view.textColor = kAppWhiteColor
        view.backgroundColor = kAppBlueColor
        return view
    }()
    
    lazy var firstItem: detailItemView = {
        let view = detailItemView(frame: CGRect(x: left_pending_space_17, y: 26 + 5, width: (kWidth - left_pending_space_17 * 2) / 3.0, height: 40))
        return view
    }()

    lazy var secondItem: detailItemView = {
        let view = detailItemView(frame: CGRect(x: left_pending_space_17 + (kWidth - left_pending_space_17 * 2) / 3.0, y: 26 + 5, width: kWidth / 3.0, height: 40))
        return view
    }()

    lazy var thirdItem: detailItemView = {
        let view = detailItemView(frame: CGRect(x: left_pending_space_17 + (kWidth - left_pending_space_17 * 2) / 3.0 * 2, y: 26 + 5, width: kWidth / 3.0, height: 40))
        view.lineView.isHidden = true
        return view
    }()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        self.addSubview(tagLabel)
        self.addSubview(firstItem)
        self.addSubview(secondItem)
        self.addSubview(thirdItem)
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
            tagLabel.text = "独立办公室"
            firstItem.titleLabel.text = "119~2000㎡"
            firstItem.descripLabel.text = "面积"
            secondItem.titleLabel.text = "￥2 /㎡/天起"
            secondItem.descripLabel.text = "租金"
            thirdItem.titleLabel.text = "50套"
            thirdItem.descripLabel.text = "在租房源"
        }
    }
    
    class func rowHeight() -> CGFloat {
        return 72
    }
    
}

class detailItemView: UIView {
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.adjustsFontSizeToFitWidth = true
        view.font = FONT_MEDIUM_14
        view.textColor = kAppBlueColor
        return view
    }()
    
    lazy var descripLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.adjustsFontSizeToFitWidth = true
        view.font = FONT_LIGHT_9
        view.textColor = kAppColor_666666
        return view
    }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = kAppColor_line_D8D8D8
        return view
    }()
    
    var selectModel: HouseSelectModel = HouseSelectModel() {
        didSet {
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.frame = frame
        
        setUpSubviews()
    }
    
    func setUpSubviews() {
        self.addSubview(titleLabel)
        self.addSubview(descripLabel)
        self.addSubview(lineView)
        titleLabel.frame = CGRect(x: 0, y: 0, width: self.width, height: self.height / 2.0)
        descripLabel.frame = CGRect(x: 0, y: self.height / 2.0, width: self.width, height: self.height / 2.0)
        lineView.frame = CGRect(x: self.width - 1, y: (self.height - 26) / 2.0, width: 1, height: 26)
    }
}

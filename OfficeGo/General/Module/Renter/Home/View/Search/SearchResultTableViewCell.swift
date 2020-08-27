//
//  SearchResultTableViewCell.swift
//  OfficeGo
//
//  Created by mac on 2020/6/5.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class SearchResultTableViewCell: BaseTableViewCell {
    
    lazy var houseNameLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_LIGHT_14
        view.textColor = kAppColor_333333
        return view
    }()
    lazy var houseDictrictIcon: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage.init(named: "trafficIcon")
        return view
    }()
    lazy var houseDistrictBusinessLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_LIGHT_11
        view.textColor = kAppColor_333333
        return view
    }()
    lazy var houseAddressIcon: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage.init(named: "locationGray")
        return view
    }()
    lazy var houseAddressLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_LIGHT_11
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
    
    var model: FangYuanSearchResultModel? {
        didSet {
            viewModel = FangYuanSearchResultViewModel.init(model: model ?? FangYuanSearchResultModel())
        }
    }
    
    /*
    ///1是办公楼，2是共享办公
    var buildType: Int?
    ///楼盘id
    var bid : Int?
    var buildingName: String?
    ///区域
    var c : String?
    ///地址
    var addressAttributedString : NSMutableAttributedString?
    ///价格
    var dayPriceString : String?
    */
    var viewModel: FangYuanSearchResultViewModel? {
        didSet {
            houseNameLabel.attributedText = viewModel?.buildingAttributedName
            houseDistrictBusinessLabel.attributedText = viewModel?.districtBusinessString
            houseAddressLabel.attributedText = viewModel?.addressString
            housePriceLabel.text = viewModel?.dayPriceString
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
        self.addSubview(houseNameLabel)
        self.addSubview(houseDictrictIcon)
        self.addSubview(houseDistrictBusinessLabel)
        self.addSubview(houseAddressIcon)
        self.addSubview(houseAddressLabel)
        self.addSubview(housePriceLabel)
        self.addSubview(lineView)

        houseNameLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(left_pending_space_17)
            make.trailing.equalToSuperview().offset(-left_pending_space_17)
            make.top.equalTo(10)
            make.height.equalTo(24)
        }
        houseDictrictIcon.snp.makeConstraints { (make) in
            make.leading.equalTo(left_pending_space_17)
            make.top.equalTo(houseNameLabel.snp.bottom).offset(4)
            make.height.equalTo(18)
            make.width.equalTo(12)
        }
        houseDistrictBusinessLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(houseDictrictIcon.snp.trailing).offset(6)
            make.centerY.equalTo(houseDictrictIcon)
        }
        houseAddressIcon.snp.makeConstraints { (make) in
            make.leading.equalTo(left_pending_space_17)
            make.top.equalTo(houseDictrictIcon.snp.bottom).offset(4)
            make.height.equalTo(18)
            make.width.equalTo(12)
        }
        houseAddressLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(houseAddressIcon.snp.trailing).offset(6)
            make.centerY.equalTo(houseAddressIcon)
        }
        housePriceLabel.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-left_pending_space_17)
            make.centerY.equalTo(houseNameLabel)
        }
        lineView.snp.makeConstraints { (make) in
            make.leading.equalTo(left_pending_space_17)
            make.trailing.equalTo(-left_pending_space_17)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    

}

//
//  HouseListTableViewCell.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/4/29.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class HouseListTableViewCell: BaseTableViewCell {
    
    lazy var houseImageview: BaseImageView = {
        let view = BaseImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = button_cordious_2
        return view
    }()
    
    ///楼盘类型展示label
    lazy var houseTypTags: UILabel = {
        let view = UILabel()
//        view.textAlignment = .center
        view.font = FONT_10
        view.textColor = kAppWhiteColor
        view.backgroundColor = kAppBlueColor
        view.clipsToBounds = true
        view.layer.cornerRadius = button_cordious_2
        view.isHidden = true
        return view
    }()
    
    lazy var houseNameLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_15
        view.textColor = kAppColor_333333
        return view
    }()
    lazy var houselocationIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.init(named: "locationGray")
        view.contentMode = .scaleAspectFit
        return view
    }()
    lazy var houseAddressLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_LIGHT_10
        view.textColor = kAppColor_333333
        return view
    }()
    lazy var houseDistanceLabel: UILabel = {
        let view = UILabel()
        //TODO: 暂时隐藏距离 - 目前为0
        view.isHidden = true
        view.textAlignment = .left
        view.font = FONT_LIGHT_10
        view.textColor = kAppColor_333333
        return view
    }()
    
    lazy var houseTrafficIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.init(named: "trafficIcon")
        view.contentMode = .scaleAspectFit
        return view
    }()
    lazy var houseRouteLineLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_LIGHT_10
        view.textColor = kAppColor_333333
        return view
    }()
    
    lazy var housePriceLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_SEMBLOD_14
        view.textColor = kAppBlueColor
        return view
    }()
    lazy var housePriceUnitLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_LIGHT_10
        view.textColor = kAppColor_333333
        return view
    }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = kAppColor_line_EEEEEE
        return view
    }()
    lazy var mianjiOrLianheView: FeatureView = {
        let view = FeatureView(frame: CGRect(x: 0, y: 0, width:  kWidth - left_pending_space_17 * 2, height: 18))
        //        view.featureString = "免费停车,近地铁,近地铁1"
        return view
    }()
    
    lazy var featureView: FeatureView = {
        let view = FeatureView(frame: CGRect(x: 0, y: 0, width: kWidth - left_pending_space_17 * 2, height: 18))
        return view
    }()
    
    class func rowHeight() -> CGFloat {
        return 192
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        addSubview(houseImageview)
        addSubview(houseNameLabel)
        addSubview(houselocationIcon)
        addSubview(houseAddressLabel)
        addSubview(houseDistanceLabel)
        addSubview(houseTrafficIcon)
        addSubview(houseRouteLineLabel)
        addSubview(housePriceLabel)
        addSubview(housePriceUnitLabel)
        addSubview(mianjiOrLianheView)
        addSubview(featureView)
        addSubview(lineView)
        
        addSubview(houseTypTags)
        
        houseImageview.snp.makeConstraints { (make) in
            make.leading.top.equalTo(left_pending_space_17)
            make.size.equalTo(92)
        }
        
        houseTypTags.snp.makeConstraints { (make) in
            make.leading.top.equalTo(houseImageview)
            make.height.equalTo(17)
//            make.width.equalTo(60)
        }
        
        houseNameLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(houseImageview.snp.trailing).offset(13)
            make.trailing.equalToSuperview().offset(-left_pending_space_17)
            make.top.equalTo(houseImageview)
        }
        
        houseAddressLabel.snp.makeConstraints { (make) in
            make.top.equalTo(houseNameLabel.snp.bottom)
            make.leading.equalTo(houseNameLabel).offset(12 + 8)
            make.trailing.equalTo(houseNameLabel)
        }
        houselocationIcon.snp.makeConstraints { (make) in
            make.leading.equalTo(houseNameLabel)
            make.centerY.height.equalTo(houseAddressLabel)
            make.width.equalTo(12)
        }
        houseDistanceLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(houseNameLabel)
            make.centerY.equalTo(houselocationIcon)
        }
        
        houseRouteLineLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(houseNameLabel).offset(12 + 8)
            make.top.equalTo(houseAddressLabel.snp.bottom)
            make.trailing.equalTo(houseNameLabel)
        }
        houseTrafficIcon.snp.makeConstraints { (make) in
            make.leading.equalTo(houseNameLabel)
            make.centerY.height.equalTo(houseRouteLineLabel)
            make.width.equalTo(12)
        }
        housePriceLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(houseNameLabel)
            make.top.equalTo(houseRouteLineLabel.snp.bottom).offset(4)
        }
        housePriceUnitLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(housePriceLabel.snp.trailing).offset(1)
            make.centerY.equalTo(housePriceLabel)
        }
        
        mianjiOrLianheView.snp.makeConstraints { (make) in
            make.leading.equalTo(houseImageview)
            make.trailing.equalTo(houseNameLabel)
            make.top.equalTo(houseImageview.snp.bottom).offset(15)
            make.height.equalTo(18)
        }
        
        featureView.snp.makeConstraints { (make) in
            make.leading.equalTo(houseImageview)
            make.trailing.equalTo(houseNameLabel)
            make.top.equalTo(mianjiOrLianheView.snp.bottom).offset(12)
            make.height.equalTo(18)
        }
        lineView.snp.makeConstraints { (make) in
            make.leading.equalTo(houseImageview)
            make.trailing.equalTo(houseNameLabel)
            make.bottom.equalToSuperview().offset(-1)
            make.height.equalTo(1)
        }
    }
    var model: FangYuanListModel = FangYuanListModel() {
        didSet {
            viewModel = FangYuanListViewModel.init(model: model)
        }
    }
    
    var viewModel: FangYuanListViewModel = FangYuanListViewModel(model: FangYuanListModel()) {
        didSet {
            setCellWithViewModel(viewModel: viewModel)
        }
    }
    
    ///列表页面
    func setCellWithViewModel(viewModel: FangYuanListViewModel) {
        houseTypTags.isHidden = false
        ///1是写字楼，2是共享办公
        if viewModel.btype == 1 {
            houseTypTags.text = "  写字楼  "
        }else if viewModel.btype == 2 {
            houseTypTags.text = "  共享办公  "
        }
        houseImageview.setImage(with: viewModel.mainPicImgString ?? "", placeholder: UIImage(named: Default_1x1))
        houseNameLabel.text = viewModel.buildingName
        houseDistanceLabel.text = viewModel.distanceString
        houseAddressLabel.text = viewModel.addressString
        if viewModel.addressString?.count ?? 0 > 0 {
            houseAddressLabel.snp.remakeConstraints { (make) in
                make.top.equalTo(houseNameLabel.snp.bottom)
                make.leading.equalTo(houseNameLabel).offset(12 + 8)
                make.height.equalTo(16 + 12)
                make.trailing.equalTo(houseNameLabel)
            }
        }else {
            houseAddressLabel.snp.remakeConstraints { (make) in
                make.top.equalTo(houseNameLabel.snp.bottom).offset(6)
                make.leading.equalTo(houseNameLabel).offset(12 + 8)
                make.height.equalTo(0)
                make.trailing.equalTo(houseNameLabel)
            }
        }
        houseRouteLineLabel.text = viewModel.walkTimesubwayAndStationString
        
        if viewModel.walkTimesubwayAndStationString?.count ?? 0 > 0 {
            houseRouteLineLabel.snp.remakeConstraints { (make) in
                make.leading.equalTo(houseNameLabel).offset(12 + 8)
                make.top.equalTo(houseAddressLabel.snp.bottom)
                make.height.lessThanOrEqualTo(16 + 12)
                make.trailing.equalTo(houseNameLabel)
            }
        }else {
            houseRouteLineLabel.snp.remakeConstraints { (make) in
                make.leading.equalTo(houseNameLabel).offset(12 + 8)
                make.top.equalTo(houseAddressLabel.snp.bottom)
                make.height.lessThanOrEqualTo(0)
                make.trailing.equalTo(houseNameLabel)
            }
        }
        housePriceLabel.text = viewModel.dayPriceString
        housePriceUnitLabel.text = viewModel.unitString
        if viewModel.btype == 1 {
            mianjiOrLianheView.mianjiStringList = viewModel.areaString ?? []
            featureView.featureStringList = viewModel.tagsString ?? []
        }else if viewModel.btype == 2 {
            mianjiOrLianheView.lianheStringList = viewModel.jointDuliAndLianheNumString ?? []
            featureView.featureStringList = viewModel.tagsString ?? []
        }
    }
    
    //聊天预约看房页面
    var messageViewModel: MessageFYViewModel = MessageFYViewModel(model: MessageFYModel()) {
        didSet {
            setCellWithMessageViewModel(viewModel: messageViewModel)
        }
    }
    
    ///预约看房页面
    func setCellWithMessageViewModel(viewModel: MessageFYViewModel) {
        houseImageview.setImage(with: viewModel.mainPic ?? "", placeholder: UIImage.init(named: Default_1x1))
        houseNameLabel.text = viewModel.buildingName
        houseDistanceLabel.text = viewModel.distanceString
        houseAddressLabel.text = viewModel.districtString
        if viewModel.districtString?.count ?? 0 > 0 {
            houseAddressLabel.snp.remakeConstraints { (make) in
                make.top.equalTo(houseNameLabel.snp.bottom)
                make.leading.equalTo(houseNameLabel).offset(12 + 8)
                make.height.equalTo(16 + 12)
                make.trailing.equalTo(houseNameLabel)
            }
        }else {
            houseAddressLabel.snp.remakeConstraints { (make) in
                make.top.equalTo(houseNameLabel.snp.bottom).offset(6)
                make.leading.equalTo(houseNameLabel).offset(12 + 8)
                make.height.equalTo(0)
                make.trailing.equalTo(houseNameLabel)
            }
        }
        houseRouteLineLabel.text = viewModel.walkTimesubwayAndStationString
        
        if viewModel.walkTimesubwayAndStationString?.count ?? 0 > 0 {
            houseRouteLineLabel.snp.remakeConstraints { (make) in
                make.leading.equalTo(houseNameLabel).offset(12 + 8)
                make.top.equalTo(houseAddressLabel.snp.bottom)
                make.height.lessThanOrEqualTo(16 + 12)
                make.trailing.equalTo(houseNameLabel)
            }
        }else {
            houseRouteLineLabel.snp.remakeConstraints { (make) in
                make.leading.equalTo(houseNameLabel).offset(12 + 8)
                make.top.equalTo(houseAddressLabel.snp.bottom)
                make.height.lessThanOrEqualTo(0)
                make.trailing.equalTo(houseNameLabel)
            }
        }
        housePriceLabel.text = viewModel.dayPriceNoUnitString
        housePriceUnitLabel.text = viewModel.unitString
    }
    
}

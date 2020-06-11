//
//  HouseListTableViewCell.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/4/29.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class HouseListTableViewCell: BaseTableViewCell {

    @IBOutlet weak var houseImageview: BaseImageView!
    @IBOutlet weak var houseNameLabel: UILabel!
    @IBOutlet weak var houseAddressLabel: UILabel!
    @IBOutlet weak var houseDistanceLabel: UILabel!
    @IBOutlet weak var houseRouteLineLabel: UILabel!
    @IBOutlet weak var housePriceLabel: UILabel!
    @IBOutlet weak var housePriceUnitLabel: UILabel!
    @IBOutlet weak var houseOfficeNumOrSquareNumLabel: UIView!
    @IBOutlet weak var houseFeatureView: UIView!
    
    @IBOutlet weak var lineView: UIView!
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

    func setCellWithViewModel(viewModel: FangYuanListViewModel) {
        houseImageview.setImage(with: viewModel.mainPicImgString ?? "", placeholder: UIImage(named: "wechat"))
        houseNameLabel.text = viewModel.buildingName
        houseDistanceLabel.text = viewModel.distanceString
        houseAddressLabel.text = viewModel.addressString
        houseRouteLineLabel.text = viewModel.walkTimesubwayAndStationString
        housePriceLabel.text = viewModel.dayPriceString
        housePriceUnitLabel.text = viewModel.unitString
        if viewModel.btype == 1 {
            mianjiOrLianheView.mianjiStringList = viewModel.areaString ?? ""
            featureView.featureStringList = viewModel.tagsString ?? ""
        }else if viewModel.btype == 2 {
            mianjiOrLianheView.lianheStringList = viewModel.jointDuliAndLianheNumString ?? ""
            featureView.featureStringList = viewModel.tagsString ?? ""
        }
    }
    
    //聊天预约看房页面
    var messageViewModel: MessageFYViewModel = MessageFYViewModel(model: MessageFYModel()) {
        didSet {
            setCellWithMessageViewModel(viewModel: messageViewModel)
        }
    }
    
    func setCellWithMessageViewModel(viewModel: MessageFYViewModel) {
        houseImageview.setImage(with: viewModel.mainPic ?? "", placeholder: UIImage.init(named: "wechat"))
        houseNameLabel.text = viewModel.buildingName
        houseDistanceLabel.text = viewModel.distanceString
        houseAddressLabel.text = viewModel.districtString
        houseRouteLineLabel.text = viewModel.walkTimesubwayAndStationString
        housePriceLabel.text = viewModel.dayPriceString
        housePriceUnitLabel.text = viewModel.unitString
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()

        houseOfficeNumOrSquareNumLabel.addSubview(mianjiOrLianheView)
        mianjiOrLianheView.snp.makeConstraints { (make) in
            make.top.leading.bottom.trailing.equalToSuperview()
        }
        
        houseFeatureView.addSubview(featureView)
       featureView.snp.makeConstraints { (make) in
           make.top.leading.bottom.trailing.equalToSuperview()
       }
    }
    
}

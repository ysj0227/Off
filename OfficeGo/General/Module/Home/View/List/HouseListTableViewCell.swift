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
        let view = FeatureView(frame: CGRect(x: 0, y: 0, width: self.houseOfficeNumOrSquareNumLabel.width - left_pending_space_17 * 2, height: 18))
//        view.featureString = "免费停车,近地铁,近地铁1"
        return view
    }()
    
    lazy var featureView: FeatureView = {
            let view = FeatureView(frame: CGRect(x: 0, y: 0, width: self.houseOfficeNumOrSquareNumLabel.width - left_pending_space_17 * 2, height: 18))
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
//    var btype: Int?                     //1是办公楼，2是联合办公
//    var idString: Int?                  //房源id
//    var mainPicImgString: String?       //封面图
//    var buildingName: String?           //楼盘名称
//    var distanceString: String?         //距离 1.0km
//    var addressString: String?          //区域和商圈 徐汇区 · 徐家汇
//    var walkTimesubwayAndStationString: String?  //步行5分钟到 | 2号线 ·东昌路站
//    var dayPriceString: String?         //日租金
//    var unitString: String?             //单位 /m²/天起
//    var areaString: String?             //平方米
//    var tagsString: String?             //特色
//    var jointDuliAndLianheNumString: String?//联合办公 独立办公室和开放工位的数量

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

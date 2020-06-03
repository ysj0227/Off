//
//  RenterDetailOfficeListCell.swift
//  OfficeGo
//
//  Created by mac on 2020/5/12.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class RenterDetailOfficeListCell: BaseTableViewCell {

    @IBOutlet weak var mainImageView: BaseImageView!
    @IBOutlet weak var leftTopLabel: UILabel!
    @IBOutlet weak var leftbottomLabel: UILabel!
    @IBOutlet weak var centerTopLabel: UILabel!
    @IBOutlet weak var centerBottomLabel: UILabel!
    @IBOutlet weak var rightDocumentLabel: UILabel!
    @IBOutlet weak var rightBottomFloorLabel: UILabel!

    
    class func rowHeight() -> CGFloat {
        return 84
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var model: FangYuanBuildingOpenStationModel = FangYuanBuildingOpenStationModel() {
        didSet {
            viewModel = FangYuanBuildingOpenStationViewModel.init(model: model)
        }
    }
    
    var viewModel: FangYuanBuildingOpenStationViewModel = FangYuanBuildingOpenStationViewModel(model: FangYuanBuildingOpenStationModel()) {
        didSet {
            
            setCellWithViewModel(viewModel: viewModel)
        }
    }
    /**
     ///面积
     var buildingArea : String?
     ///工位数
     var buildinSeats : String?
     var buildingDayPriceString : String?
     ///月租金
     var buildingMonthPriceString : String?
     ///装修
      var buildingDecoration : String?
     ///楼层
      var buildingFloor : String?
     */
    func setCellWithViewModel(viewModel: FangYuanBuildingOpenStationViewModel) {
        mainImageView.setImage(with: viewModel.mainPic ?? "", placeholder: UIImage(named: "wechat"))
        leftTopLabel.text = viewModel.buildingArea
        leftbottomLabel.text = viewModel.buildinSeats
        centerTopLabel.text = viewModel.buildingDayPriceString
        centerBottomLabel.text = viewModel.buildingMonthPriceString
        rightDocumentLabel.text = viewModel.buildingDecoration
        rightBottomFloorLabel.text = viewModel.buildingFloor
    }
    
    
}

//
//  RenterDetailFYListCell.swift
//  OfficeGo
//
//  Created by mac on 2020/5/12.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class RenterDetailFYListCell: BaseTableViewCell {
    
    @IBOutlet weak var mainImageView: BaseImageView!
    @IBOutlet weak var leftTopLabel: UILabel!
    @IBOutlet weak var leftbottomLabel: UILabel!
    @IBOutlet weak var rightPriceLabel: UILabel!
    @IBOutlet weak var rightUnitLabel: UILabel!
    @IBOutlet weak var rightBottomUnitLabel: UILabel!
    
    class func rowHeight() -> CGFloat {
        return 84
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    /**
     ///开放工位
       ///工位数 - 30工位
       var openSeatsString : String?
       ///月租金
       var openMonthPriceString : String?
       ///最短租期---6个月可租
       var openMinimumLeaseString : String?
     */
    //开放工位 显示
    var model: FangYuanBuildingBuildingModel = FangYuanBuildingBuildingModel() {
         didSet {
             viewModel = FangYuanBuildingBuildingViewModel.init(model: model)
         }
     }
    var viewModel: FangYuanBuildingBuildingViewModel = FangYuanBuildingBuildingViewModel(model: FangYuanBuildingBuildingModel()) {
        didSet {
            setCellWithViewModel(viewModel: viewModel)
        }
    }
        
    func setCellWithViewModel(viewModel: FangYuanBuildingBuildingViewModel) {
        
        mainImageView.setImage(with: viewModel.openStationViewModel?.mainPic ?? "", placeholder: UIImage(named: "wechat"))
        leftTopLabel.text = viewModel.openStationViewModel?.openSeatsString
        rightPriceLabel.text = viewModel.openStationViewModel?.openMonthPriceString
        rightUnitLabel.text = "/位/月"
        rightBottomUnitLabel.text = viewModel.openStationViewModel?.openMinimumLeaseString
    }
    
    
        /**
       ///独立办公室
       ///
       ///面积
       var individualAreaString : String?
       ///每工位每月租金  3000.0
       var individualMonthPriceString : String?
       ///工位数 - 30工位
       var individualSeatsString : String?
       ///每工位每天租金  3000.0
       var individualDayPriceString : String?
       */
    
    var duliModel: FangYuanBuildingOpenStationModel = FangYuanBuildingOpenStationModel() {
        didSet {
            duliViewModel = FangYuanBuildingOpenStationViewModel.init(model: duliModel)
        }
    }
    
    var duliViewModel: FangYuanBuildingOpenStationViewModel = FangYuanBuildingOpenStationViewModel(model: FangYuanBuildingOpenStationModel()) {
        didSet {
            setDuliCellWithViewModel(viewModel: duliViewModel)
        }
    }
    func setDuliCellWithViewModel(viewModel: FangYuanBuildingOpenStationViewModel) {
        mainImageView.setImage(with: viewModel.mainPic ?? "", placeholder: UIImage(named: "wechat"))
        leftTopLabel.text = viewModel.individualAreaString
        leftbottomLabel.text = viewModel.individualSeatsString
        rightPriceLabel.text = viewModel.individualMonthPriceString
        rightUnitLabel.text = "/月"
        rightBottomUnitLabel.text = viewModel.individualDayPriceString
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

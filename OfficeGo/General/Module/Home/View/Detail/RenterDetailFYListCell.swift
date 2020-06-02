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
        leftTopLabel.text = viewModel.openStationViewModel?.minimumLeaseString
        rightPriceLabel.text = viewModel.openStationViewModel?.dayPriceString
        rightUnitLabel.text = "/位/月"
        rightBottomUnitLabel.text = viewModel.openStationViewModel?.minimumLeaseString
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

//
//  RenterOfficeDeatailCell.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/5/11.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class RenterOfficeDeatailCell: BaseTableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var ruzhuQiyeConstantHeight: NSLayoutConstraint!
    
    @IBOutlet weak var airDefaultConditioningLabel: UILabel!
        
    @IBOutlet weak var airDefaultCoastConditioningLabel: UILabel!
        
    @IBOutlet weak var completionTimeLabel: UILabel!
    
    @IBOutlet weak var totalFloorLabel: UILabel!
    
    @IBOutlet weak var storeyHeightLabel: UILabel!
    
    @IBOutlet weak var liftStringLabel: UILabel!
    
    @IBOutlet weak var parkingSpaceLabel: UILabel!
    
    @IBOutlet weak var parkingSpaceRentLabel: UILabel!
    
    @IBOutlet weak var propertyLabel: UILabel!
    
    @IBOutlet weak var propertyCostsLabel: UILabel!
    
    @IBOutlet weak var internetLabel: UILabel!
    
    @IBOutlet weak var promoteSloganLabel: UILabel!
    
    
    var model: FangYuanBuildingIntroductionModel = FangYuanBuildingIntroductionModel() {
        didSet {
            viewModel = FangYuanBuildingIntroductionlViewModel.init(model: model)
        }
    }
    
    var viewModel: FangYuanBuildingIntroductionlViewModel = FangYuanBuildingIntroductionlViewModel(model: FangYuanBuildingIntroductionModel()) {
        didSet {
            setCellWithViewModel(viewModel: viewModel)
        }
    }
    
    func setCellWithViewModel(viewModel: FangYuanBuildingIntroductionlViewModel) {
        airDefaultConditioningLabel.text = viewModel.airDefaultConditioning
        airDefaultCoastConditioningLabel.text = viewModel.airDefaultCoastConditioning
        completionTimeLabel.text = viewModel.completionTime
        totalFloorLabel.text = viewModel.totalFloor
        storeyHeightLabel.text = viewModel.storeyHeight
        liftStringLabel.text = viewModel.liftString
        parkingSpaceLabel.text = viewModel.parkingSpace
        parkingSpaceRentLabel.text = viewModel.parkingSpaceRent
        propertyLabel.text = viewModel.property
        propertyCostsLabel.text = viewModel.propertyCosts
        internetLabel.text = viewModel.internet
        promoteSloganLabel.text = viewModel.promoteSlogan
        
        ruzhuQiyeConstantHeight.constant = viewModel.textHeight ?? 0

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.font = FONT_15
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    class func rowHeight() -> CGFloat {
        return 486
    }
}

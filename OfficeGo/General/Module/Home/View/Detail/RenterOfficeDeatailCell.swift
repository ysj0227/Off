//
//  RenterOfficeDeatailCell.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/5/11.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class RenterOfficeDeatailCell: BaseTableViewCell {
    
    @IBOutlet weak var ruzhuQiyeConstantHeight: NSLayoutConstraint!
    
    @IBOutlet weak var airDefaultConditioningLabel: UILabel!
    
    @IBOutlet weak var airJiabanConditioningLabel: UILabel!
    
    @IBOutlet weak var airDefaultCoastConditioningLabel: UILabel!
    
    @IBOutlet weak var airJiabanCoastConditioningLabel: UILabel!
    
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
        airJiabanConditioningLabel.text = viewModel.airJiabanConditioning
        airDefaultCoastConditioningLabel.text = viewModel.airDefaultCoastConditioning
        airJiabanCoastConditioningLabel.text = viewModel.airJiabanCoastConditioning
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
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        ruzhuQiyeConstantHeight.constant = 25
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    func rowHeight() -> CGFloat {
        return 493 - 25 + ruzhuQiyeConstantHeight.constant
    }
}

//
//  OwnerBuildingClickCell.swift
//  OfficeGo
//
//  Created by Mac pro on 2020/9/30.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class OwnerBuildingClickCell: BaseEditCell {
    
    var userModel: OwnerIdentifyUserModel?
        
    var model: OwnerBuildingEditConfigureModel = OwnerBuildingEditConfigureModel(types: OwnerBuildingEditType.OwnerBuildingEditTypeBuildingTypew) {
        didSet {
            
            titleLabel.attributedText = model.getNameFormType(type: model.type ?? OwnerBuildingEditType.OwnerBuildingEditTypeBuildingTypew)
            editLabel.placeholder = model.getPalaceHolderFormType(type: model.type ?? OwnerBuildingEditType.OwnerBuildingEditTypeBuildingTypew)

            detailIcon.isHidden = false
            lineView.isHidden = false
            editLabel.isUserInteractionEnabled = false

            if model.type == .OwnerBuildingEditTypeBuildingTypew{
                detailIcon.image = UIImage.init(named: "moreDetail")
                
            }else if model.type == .OwnerBuildingEditTypeDisctict{
                detailIcon.image = UIImage.init(named: "moreDetail")
            }else if model.type == .OwnerBuildingEditTypeCompelteTime{
                detailIcon.image = UIImage.init(named: "dateSelectBule")
            }else if model.type == .OwnerBuildingEditTypeRenovationTime{
                detailIcon.image = UIImage.init(named: "dateSelectBule")
            }else if model.type == .OwnerBuildingEditTypeAirConditionType{
                detailIcon.image = UIImage.init(named: "moreDetail")
            }
        }
    }
    
    override func setExtraView() {
        titleLabel.textColor = kAppColor_333333
    }
}

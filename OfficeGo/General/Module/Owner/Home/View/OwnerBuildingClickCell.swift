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
            }else {
                detailIcon.image = UIImage.init(named: "")
            }
        }
    }
    
    override func setExtraView() {
        editLabel.font = FONT_14
        titleLabel.textColor = kAppColor_333333
    }
}

class OwnerBuildingDateClickCell: BaseEditCell {
    
    var userModel: OwnerIdentifyUserModel?
        
    var model: OwnerBuildingEditConfigureModel = OwnerBuildingEditConfigureModel(types: OwnerBuildingEditType.OwnerBuildingEditTypeCompelteTime) {
        didSet {
            
            titleLabel.attributedText = model.getNameFormType(type: model.type ?? OwnerBuildingEditType.OwnerBuildingEditTypeBuildingTypew)
            editLabel.placeholder = model.getPalaceHolderFormType(type: model.type ?? OwnerBuildingEditType.OwnerBuildingEditTypeBuildingTypew)

            detailIcon.isHidden = false
            lineView.isHidden = false
            editLabel.isUserInteractionEnabled = false

            if model.type == .OwnerBuildingEditTypeCompelteTime{
                detailIcon.image = UIImage.init(named: "dateSelectBule")
            }else if model.type == .OwnerBuildingEditTypeRenovationTime{
                detailIcon.image = UIImage.init(named: "dateSelectBule")
            }else {
                detailIcon.image = UIImage.init(named: "")
            }
        }
    }
    
    override func setExtraView() {
        editLabel.font = FONT_14
        titleLabel.textColor = kAppColor_333333
        detailIcon.contentMode = .scaleToFill

        detailIcon.snp.remakeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-left_pending_space_17)
            make.centerY.equalToSuperview()
            make.size.equalTo(20)
        }
    }
}

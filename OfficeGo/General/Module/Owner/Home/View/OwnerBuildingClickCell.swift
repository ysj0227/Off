//
//  OwnerBuildingClickCell.swift
//  OfficeGo
//
//  Created by Mac pro on 2020/9/30.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class OwnerBuildingClickCell: BaseEditCell {
    
    var buildingModel: FangYuanBuildingEditDetailModel?
    var model: OwnerBuildingEditConfigureModel = OwnerBuildingEditConfigureModel(types: OwnerBuildingEditType.OwnerBuildingEditTypeBuildingTypew) {
        didSet {
            
            titleLabel.attributedText = model.getNameFormType(type: model.type ?? OwnerBuildingEditType.OwnerBuildingEditTypeBuildingTypew)
            editLabel.placeholder = model.getPalaceHolderFormType(type: model.type ?? OwnerBuildingEditType.OwnerBuildingEditTypeBuildingTypew)

            detailIcon.isHidden = false
            lineView.isHidden = false
            editLabel.isUserInteractionEnabled = false

            if model.type == .OwnerBuildingEditTypeBuildingTypew{
                
                detailIcon.image = UIImage.init(named: "moreDetail")
                
                editLabel.text = buildingModel?.buildingType?.rawValue

            }else if model.type == .OwnerBuildingEditTypeDisctict{
                
                detailIcon.image = UIImage.init(named: "moreDetail")
                
                editLabel.text = "\(buildingModel?.districtString ?? "")\(buildingModel?.businessString ?? "")"

            }else if model.type == .OwnerBuildingEditTypeCompelteTime{
                
                detailIcon.image = UIImage.init(named: "dateSelectBule")
                
            }else if model.type == .OwnerBuildingEditTypeRenovationTime{
                
                detailIcon.image = UIImage.init(named: "dateSelectBule")
                
            }else if model.type == .OwnerBuildingEditTypeAirConditionType{
                
                detailIcon.image = UIImage.init(named: "moreDetail")
                
                editLabel.text = buildingModel?.airditionType?.rawValue

            }else if model.type == .OwnerBuildingEditTypeAirConditionCoast{
                
                detailIcon.image = UIImage.init(named: "")
                
                if buildingModel?.airditionType == OwnerAircontiditonType.OwnerAircontiditonTypeCenter {
                    editLabel.text = OwnerAircontiditonFeeType.OwnerAircontiditonFeeTypeCenter.rawValue
                }else if buildingModel?.airditionType == OwnerAircontiditonType.OwnerAircontiditonTypeIndividual{
                    editLabel.text = OwnerAircontiditonFeeType.OwnerAircontiditonFeeTypeIndividual.rawValue
                }else if buildingModel?.airditionType == OwnerAircontiditonType.OwnerAircontiditonTypeNone {
                    editLabel.text = OwnerAircontiditonFeeType.OwnerAircontiditonFeeTypeNone.rawValue
                }else {
                    editLabel.text = OwnerAircontiditonFeeType.OwnerAircontiditonFeeTypeDefault.rawValue
                }
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

//
//  OwnerBuildingClickCell.swift
//  OfficeGo
//
//  Created by Mac pro on 2020/9/30.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class OwnerBuildingClickCell: BaseEditCell {
    
    var buildingModel: FangYuanBuildingEditModel?
    
    var FYModel: FangYuanHouseEditModel?
    
    ///楼盘
    var model: OwnerBuildingEditConfigureModel = OwnerBuildingEditConfigureModel(types: OwnerBuildingEditType.OwnerBuildingEditTypeBuildingTypew) {
        didSet {
            
            titleLabel.attributedText = model.getNameFormType(type: model.type ?? OwnerBuildingEditType.OwnerBuildingEditTypeBuildingTypew)
            editLabel.placeholder = model.getPalaceHolderFormType(type: model.type ?? OwnerBuildingEditType.OwnerBuildingEditTypeBuildingTypew)
            
            detailIcon.isHidden = false
            lineView.isHidden = false
            editLabel.isUserInteractionEnabled = false
            
            if model.type == .OwnerBuildingEditTypeBuildingTypew{
                
                detailIcon.image = UIImage.init(named: "moreDetail")
                
                editLabel.text = buildingModel?.buildingMsg?.buildingTypeEnum?.rawValue
                
            }else if model.type == .OwnerBuildingEditTypeDisctict{
                
                detailIcon.image = UIImage.init(named: "moreDetail")
                
                editLabel.text = "\(buildingModel?.buildingMsg?.districtString ?? "")\(buildingModel?.buildingMsg?.businessString ?? "")"
                
            }else if model.type == .OwnerBuildingEditTypeAirConditionType{
                
                detailIcon.image = UIImage.init(named: "moreDetail")
                
                editLabel.text = buildingModel?.buildingMsg?.airditionType?.rawValue
                
            }else if model.type == .OwnerBuildingEditTypeAirConditionCoast{
                
                detailIcon.image = UIImage.init(named: "")
                
                if buildingModel?.buildingMsg?.airditionType == OwnerAircontiditonType.OwnerAircontiditonTypeCenter {
                    editLabel.text = OwnerAircontiditonFeeType.OwnerAircontiditonFeeTypeCenter.rawValue
                }else if buildingModel?.buildingMsg?.airditionType == OwnerAircontiditonType.OwnerAircontiditonTypeIndividual{
                    editLabel.text = OwnerAircontiditonFeeType.OwnerAircontiditonFeeTypeIndividual.rawValue
                }else if buildingModel?.buildingMsg?.airditionType == OwnerAircontiditonType.OwnerAircontiditonTypeNone {
                    editLabel.text = OwnerAircontiditonFeeType.OwnerAircontiditonFeeTypeNone.rawValue
                }else {
                    editLabel.text = OwnerAircontiditonFeeType.OwnerAircontiditonFeeTypeDefault.rawValue
                }
            }
        }
    }
    
    ///网点
    var jointModel: OwnerBuildingJointEditConfigureModel = OwnerBuildingJointEditConfigureModel(types: OwnerBuildingJointEditType.OwnerBuildingJointEditTypeDisctict) {
        didSet {
            
            titleLabel.attributedText = jointModel.getNameFormType(type: jointModel.type ?? OwnerBuildingJointEditType.OwnerBuildingJointEditTypeDisctict)
            editLabel.placeholder = jointModel.getPalaceHolderFormType(type: jointModel.type ?? OwnerBuildingJointEditType.OwnerBuildingJointEditTypeDisctict)
            
            detailIcon.isHidden = false
            lineView.isHidden = false
            editLabel.isUserInteractionEnabled = false
            editLabel.textAlignment = .left

            ///所在区域
            ///空调类型
            ///空调费
            ///所在楼层
            if jointModel.type == .OwnerBuildingJointEditTypeDisctict{
                
                detailIcon.image = UIImage.init(named: "moreDetail")
                
                editLabel.text = "\(buildingModel?.buildingMsg?.districtString ?? "")\(buildingModel?.buildingMsg?.businessString ?? "")"
                
            }else if jointModel.type == .OwnerBuildingJointEditTypeAirConditionType{
                                
                editLabel.text = buildingModel?.buildingMsg?.airditionType?.rawValue
                
            }else if jointModel.type == .OwnerBuildingJointEditTypeAirConditionCoast{
                
                detailIcon.image = UIImage.init(named: "")
                
                if buildingModel?.buildingMsg?.airditionType == OwnerAircontiditonType.OwnerAircontiditonTypeCenter {
                    editLabel.text = OwnerAircontiditonFeeType.OwnerAircontiditonFeeTypeCenter.rawValue
                }else if buildingModel?.buildingMsg?.airditionType == OwnerAircontiditonType.OwnerAircontiditonTypeIndividual{
                    editLabel.text = OwnerAircontiditonFeeType.OwnerAircontiditonFeeTypeIndividual.rawValue
                }else if buildingModel?.buildingMsg?.airditionType == OwnerAircontiditonType.OwnerAircontiditonTypeNone {
                    editLabel.text = OwnerAircontiditonFeeType.OwnerAircontiditonFeeTypeNone.rawValue
                }else {
                    editLabel.text = OwnerAircontiditonFeeType.OwnerAircontiditonFeeTypeDefault.rawValue
                }
            }else if jointModel.type == .OwnerBuildingJointEditTypeTotalFloor {
                editLabel.textAlignment = .right
                ///所在楼层 1 2
                if buildingModel?.buildingMsg?.floorType == "1" {
                    editLabel.text = OwnerBuildingTotalFloorType.OwnerBuildingTotalFloorTypeOne.rawValue
                }else if buildingModel?.buildingMsg?.floorType == "2" {
                    editLabel.text = OwnerBuildingTotalFloorType.OwnerBuildingTotalFloorTypeMore.rawValue
                }
            }
        }
    }
    
    
    ///办公室
    var officeModel: OwnerBuildingOfficeConfigureModel = OwnerBuildingOfficeConfigureModel(types: OwnerBuildingOfficeType.OwnerBuildingOfficeTypeTotalFloor) {
        didSet {
            
            titleLabel.attributedText = officeModel.getNameFormType(type: officeModel.type ?? OwnerBuildingOfficeType.OwnerBuildingOfficeTypeTotalFloor)
            editLabel.placeholder = officeModel.getPalaceHolderFormType(type: officeModel.type ?? OwnerBuildingOfficeType.OwnerBuildingOfficeTypeTotalFloor)
            
            //detailIcon.isHidden = false
            lineView.isHidden = false
            editLabel.isUserInteractionEnabled = false
            editLabel.textAlignment = .left

            ///所在楼层
            ///免租期
            if officeModel.type == .OwnerBuildingOfficeTypeTotalFloor {
                detailIcon.isHidden = true
                editLabel.textAlignment = .right
                ///所在楼层 1 2
                if FYModel?.houseMsg?.floorType == "1" {
                    editLabel.text = ""
                }else if FYModel?.houseMsg?.floorType == "2" {
                    editLabel.text = ""
                }
            }else if officeModel.type == .OwnerBuildingOfficeTypeRentFreePeriod {
                editLabel.text = FYModel?.houseMsg?.rentFreePeriod
            }
        }
    }
    
    ///独立办公室
    var jointIndepentOfficeModel: OwnerBuildingJointOfficeConfigureModel = OwnerBuildingJointOfficeConfigureModel(types: OwnerBuildingJointOfficeType.OwnerBuildingJointOfficeTypeRentFreePeriod) {
        didSet {
            
            
            titleLabel.attributedText = jointIndepentOfficeModel.getNameFormType(type: jointIndepentOfficeModel.type ?? OwnerBuildingJointOfficeType.OwnerBuildingJointOfficeTypeRentFreePeriod)
            editLabel.placeholder = jointIndepentOfficeModel.getPalaceHolderFormType(type: jointIndepentOfficeModel.type ?? OwnerBuildingJointOfficeType.OwnerBuildingJointOfficeTypeRentFreePeriod)
            
            detailIcon.isHidden = false
            lineView.isHidden = false
            editLabel.isUserInteractionEnabled = false
            editLabel.textAlignment = .left

            ///所在楼层
            ///免租期
            ///出租方式
            ///空调类型
            if jointIndepentOfficeModel.type == .OwnerBuildingJointOfficeTypeTotalFloor {
                //detailIcon.isHidden = true
                editLabel.textAlignment = .right
                ///所在楼层 1 2
                if FYModel?.houseMsg?.floorType == "1" {
                    editLabel.text = ""
                }else if FYModel?.houseMsg?.floorType == "2" {
                    editLabel.text = ""
                }
            }else if jointIndepentOfficeModel.type == .OwnerBuildingJointOfficeTypeRentFreePeriod {
                editLabel.text = FYModel?.houseMsg?.rentFreePeriod
            }
//            else if jointIndepentOfficeModel.type == .OwnerBuildingJointOfficeTypeRentType {
//                
//            }
            else if jointIndepentOfficeModel.type == .OwnerBuildingJointOfficeTypeAirConditionType{
                
                editLabel.text = FYModel?.houseMsg?.airditionType?.rawValue
                
            }else if jointIndepentOfficeModel.type == .OwnerBuildingJointOfficeTypeAirConditionCoast{
                
                detailIcon.image = UIImage.init(named: "")
                
                if FYModel?.houseMsg?.airditionType == OwnerAircontiditonType.OwnerAircontiditonTypeCenter {
                    editLabel.text = OwnerAircontiditonFeeType.OwnerAircontiditonFeeTypeCenter.rawValue
                }else if FYModel?.houseMsg?.airditionType == OwnerAircontiditonType.OwnerAircontiditonTypeIndividual{
                    editLabel.text = OwnerAircontiditonFeeType.OwnerAircontiditonFeeTypeIndividual.rawValue
                }else if FYModel?.houseMsg?.airditionType == OwnerAircontiditonType.OwnerAircontiditonTypeNone {
                    editLabel.text = OwnerAircontiditonFeeType.OwnerAircontiditonFeeTypeNone.rawValue
                }else {
                    editLabel.text = OwnerAircontiditonFeeType.OwnerAircontiditonFeeTypeDefault.rawValue
                }
            }
        }
    }
    
    
    ///开放工位
    var jointOpenStationModel: OwnerBuildingJointOpenStationConfigureModel = OwnerBuildingJointOpenStationConfigureModel(types: OwnerBuildingJointOpenStationType.OwnerBuildingJointOpenStationTypeRentFreePeriod) {
        didSet {
            
            
            titleLabel.attributedText = jointOpenStationModel.getNameFormType(type: jointOpenStationModel.type ?? OwnerBuildingJointOpenStationType.OwnerBuildingJointOpenStationTypeRentFreePeriod)
            editLabel.placeholder = jointOpenStationModel.getPalaceHolderFormType(type: jointOpenStationModel.type ?? OwnerBuildingJointOpenStationType.OwnerBuildingJointOpenStationTypeRentFreePeriod)
            
            detailIcon.isHidden = false
            lineView.isHidden = false
            editLabel.isUserInteractionEnabled = false
            editLabel.textAlignment = .left

            ///所在楼层
            ///免租期
            if jointOpenStationModel.type == .OwnerBuildingJointOpenStationTypeTotalFloor {
                //detailIcon.isHidden = true
                editLabel.textAlignment = .right
                ///所在楼层 1 2
                if FYModel?.houseMsg?.floorType == "1" {
                    editLabel.text = ""
                }else if FYModel?.houseMsg?.floorType == "2" {
                    editLabel.text = ""
                }
            }else if jointOpenStationModel.type == .OwnerBuildingJointOpenStationTypeRentFreePeriod {
                editLabel.text = FYModel?.houseMsg?.rentFreePeriod
            }
        }
    }
    
    override func setExtraView() {
        editLabel.font = FONT_14
        titleLabel.textColor = kAppColor_333333
    }
}

///日期选择cell
class OwnerBuildingDateClickCell: BaseEditCell {
    
    var buildingModel: FangYuanBuildingEditModel?

    var model: OwnerBuildingEditConfigureModel = OwnerBuildingEditConfigureModel(types: OwnerBuildingEditType.OwnerBuildingEditTypeCompelteTime) {
        didSet {
            
            titleLabel.attributedText = model.getNameFormType(type: model.type ?? OwnerBuildingEditType.OwnerBuildingEditTypeBuildingTypew)
            editLabel.placeholder = model.getPalaceHolderFormType(type: model.type ?? OwnerBuildingEditType.OwnerBuildingEditTypeBuildingTypew)
            
            detailIcon.isHidden = false
            lineView.isHidden = false
            editLabel.isUserInteractionEnabled = false
            
            if model.type == .OwnerBuildingEditTypeCompelteTime{
                
                detailIcon.image = UIImage.init(named: "dateSelectBule")
                
                editLabel.text = buildingModel?.buildingMsg?.completionTime

            }else if model.type == .OwnerBuildingEditTypeRenovationTime{
                
                detailIcon.image = UIImage.init(named: "dateSelectBule")
                
                editLabel.text = buildingModel?.buildingMsg?.refurbishedTime

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

///会议室配套cell
class OwnerBuildingRoomMatchingClickCell: BaseEditCell {
    
    var buildingModel: FangYuanBuildingEditModel?

    var jointModel: OwnerBuildingJointEditConfigureModel = OwnerBuildingJointEditConfigureModel(types: OwnerBuildingJointEditType.OwnerBuildingJointEditTypeRoomMatching) {
        didSet {
            
            titleLabel.attributedText = jointModel.getNameFormType(type: jointModel.type ?? OwnerBuildingJointEditType.OwnerBuildingJointEditTypeRoomMatching)
            editLabel.placeholder = jointModel.getPalaceHolderFormType(type: jointModel.type ?? OwnerBuildingJointEditType.OwnerBuildingJointEditTypeRoomMatching)
            
            detailIcon.isHidden = false
            lineView.isHidden = false
            editLabel.isEnabled = false
            editLabel.isUserInteractionEnabled = true
            
            setUpEditFeatureSubviews(str: buildingModel?.buildingMsg?.roomMatchingsLocal?.itemArr ?? [])
        }
    }
    
    
    //item之间间距
    let space: CGFloat = 20
    
    //每一项宽度添加的width
    var itemwidth: CGFloat = 20
    
    ///创建网点和编辑页面
    func setUpEditFeatureSubviews(str: [DictionaryModel]) {
        editLabel.subviews.forEach { (view) in
            if view.isKind(of: BaseImageView.self) {
                view.removeFromSuperview()
            }
        }
        var width: CGFloat = 0.0
        for strs in str {
            
            if strs.isSelected == true {
                let btn = BaseImageView.init(frame: CGRect(x: width, y: 0, width: itemwidth, height: self.height))
                btn.contentMode = .scaleAspectFit
                btn.clipsToBounds = true
                btn.setImage(with: strs.dictImgBlack ?? "", placeholder: UIImage.init(named: ""))
                width =  width + (itemwidth + space)
                editLabel.addSubview(btn)
            }
        }
    }
    override func setExtraView() {
        
    }
}

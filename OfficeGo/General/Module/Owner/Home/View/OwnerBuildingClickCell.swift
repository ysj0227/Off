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
    
    var jointModel: OwnerBuildingJointEditConfigureModel = OwnerBuildingJointEditConfigureModel(types: OwnerBuildingJointEditType.OwnerBuildingJointEditTypeDisctict) {
        didSet {
            
            titleLabel.attributedText = jointModel.getNameFormType(type: jointModel.type ?? OwnerBuildingJointEditType.OwnerBuildingJointEditTypeDisctict)
            editLabel.placeholder = jointModel.getPalaceHolderFormType(type: jointModel.type ?? OwnerBuildingJointEditType.OwnerBuildingJointEditTypeDisctict)
            
            detailIcon.isHidden = false
            lineView.isHidden = false
            editLabel.isUserInteractionEnabled = false
            
            ///所在区域
            ///空调类型
            ///空调费
            if jointModel.type == .OwnerBuildingJointEditTypeDisctict{
                
                detailIcon.image = UIImage.init(named: "moreDetail")
                
                editLabel.text = "\(buildingModel?.districtString ?? "")\(buildingModel?.businessString ?? "")"
                
            }else if jointModel.type == .OwnerBuildingJointEditTypeAirConditionType{
                                
                editLabel.text = buildingModel?.airditionType?.rawValue
                
            }else if jointModel.type == .OwnerBuildingJointEditTypeAirConditionCoast{
                
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

///日期选择cell
class OwnerBuildingDateClickCell: BaseEditCell {
    
    var buildingModel: FangYuanBuildingEditDetailModel?

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

///会议室配套cell
class OwnerBuildingRoomMatchingClickCell: BaseEditCell {
    
    var buildingModel: FangYuanBuildingEditDetailModel?

    var jointModel: OwnerBuildingJointEditConfigureModel = OwnerBuildingJointEditConfigureModel(types: OwnerBuildingJointEditType.OwnerBuildingJointEditTypeRoomMatching) {
        didSet {
            
            titleLabel.attributedText = jointModel.getNameFormType(type: jointModel.type ?? OwnerBuildingJointEditType.OwnerBuildingJointEditTypeRoomMatching)
            editLabel.placeholder = jointModel.getPalaceHolderFormType(type: jointModel.type ?? OwnerBuildingJointEditType.OwnerBuildingJointEditTypeRoomMatching)
            
            detailIcon.isHidden = false
            lineView.isHidden = false
            editLabel.isEnabled = false
            editLabel.isUserInteractionEnabled = true
            
            setUpEditFeatureSubviews(str: buildingModel?.roomMatchingsLocal?.itemArr ?? [])
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

//
//  OwnerBuildingDecimalNumInputCell.swift
//  OfficeGo
//
//  Created by Mac pro on 2020/10/12.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class OwnerBuildingDecimalNumInputCell: BaseEditCell {
    
    var buildingModel: FangYuanBuildingEditDetailModel?
    
    var endEditingMessageCell:((FangYuanBuildingEditDetailModel) -> Void)?
    
    override func setExtraView() {
        editLabel.font = FONT_14
        titleLabel.textColor = kAppColor_333333
        editLabel.snp.remakeConstraints { (make) in
            make.trailing.equalTo(unitLabel.snp.leading).offset(-5)
            make.leading.equalTo(titleLabel.snp.trailing)
            make.top.bottom.equalToSuperview()
        }
    }
    
    override func setDelegate() {
        editLabel.keyboardType = .decimalPad
        editLabel.delegate = self
        editLabel.addTarget(self, action: #selector(valueDidChange), for: .editingChanged)
    }
    
    @objc func valueDidChange() {
        let textNum = editLabel.text?.count
        ///建筑面积
        if model.type == .OwnerBuildingEditTypeArea {
            
        }
            ///净高
        else if model.type == .OwnerBuildingEditTypeClearHeight {
            
        }
            ///层高
        else if model.type == .OwnerBuildingEditTypeFloorHeight {
            
        }
            ///物业费
        else if model.type == .OwnerBuildingEditTypePropertyCoast {
            
        }
    }
    
    ///楼盘模型
    var model: OwnerBuildingEditConfigureModel = OwnerBuildingEditConfigureModel(types: OwnerBuildingEditType.OwnerBuildingEditTypeBuildingTypew) {
        didSet {
            
            titleLabel.attributedText = model.getNameFormType(type: model.type ?? OwnerBuildingEditType.OwnerBuildingEditTypeBuildingTypew)
            //editLabel.placeholder = model.getPalaceHolderFormType(type: model.type ?? OwnerBuildingEditType.OwnerBuildingEditTypeBuildingTypew)
            unitLabel.text = model.getPalaceHolderFormType(type: model.type ?? OwnerBuildingEditType.OwnerBuildingEditTypeBuildingTypew)
            
            detailIcon.isHidden = true
            lineView.isHidden = false
            editLabel.isUserInteractionEnabled = true
            
            ///建筑面积
            if model.type == .OwnerBuildingEditTypeArea {
                
            }
                ///净高
            else if model.type == .OwnerBuildingEditTypeClearHeight {
                
            }
                ///层高
            else if model.type == .OwnerBuildingEditTypeFloorHeight {
                
            }
                ///物业费
            else if model.type == .OwnerBuildingEditTypePropertyCoast {
                
            }
        }
    }
    
    ///网点
    var jointModel: OwnerBuildingJointEditConfigureModel = OwnerBuildingJointEditConfigureModel(types: OwnerBuildingJointEditType.OwnerBuildingJointEditTypeClearHeight) {
        didSet {
            
            titleLabel.attributedText = jointModel.getNameFormType(type: jointModel.type ?? OwnerBuildingJointEditType.OwnerBuildingJointEditTypeClearHeight)
            //editLabel.placeholder = jointModel.getPalaceHolderFormType(type: jointModel.type ?? OwnerBuildingJointEditType.OwnerBuildingJointEditTypeClearHeight)
            unitLabel.text = jointModel.getPalaceHolderFormType(type: jointModel.type ?? OwnerBuildingJointEditType.OwnerBuildingJointEditTypeClearHeight)

            detailIcon.isHidden = true
            lineView.isHidden = false
            editLabel.isUserInteractionEnabled = true
            
            ///净高
            if jointModel.type == .OwnerBuildingJointEditTypeClearHeight {
                
            }
        }
    }
    
    ///办公室
    ///数字 - 一位小数点文本输入cell
    ///建筑面积 - 两位
    ///净高
    ///层高
    ///物业费
    ///租金单价 - 两位
    ///租金总价 - 两位
    var officeModel: OwnerBuildingOfficeConfigureModel = OwnerBuildingOfficeConfigureModel(types: OwnerBuildingOfficeType.OwnerBuildingOfficeTypeArea) {
        didSet {
            
            titleLabel.attributedText = officeModel.getNameFormType(type: officeModel.type ?? OwnerBuildingOfficeType.OwnerBuildingOfficeTypeArea)
            //editLabel.placeholder = officeModel.getPalaceHolderFormType(type: officeModel.type ?? OwnerBuildingOfficeType.OwnerBuildingOfficeTypeArea)
            unitLabel.text = officeModel.getPalaceHolderFormType(type: officeModel.type ?? OwnerBuildingOfficeType.OwnerBuildingOfficeTypeArea)

            detailIcon.isHidden = true
            lineView.isHidden = false
            editLabel.isUserInteractionEnabled = true
            
            if officeModel.type == .OwnerBuildingOfficeTypeArea {
                editLabel.text = buildingModel?.areaOffice
            }else if officeModel.type == .OwnerBuildingOfficeTypeClearHeight {
                editLabel.text = buildingModel?.clearHeight
            }else if officeModel.type == .OwnerBuildingOfficeTypeFloorHeight {
                editLabel.text = buildingModel?.storeyHeight
            }else if officeModel.type == .OwnerBuildingOfficeTypePropertyCoast {
                editLabel.text = buildingModel?.propertyCosts
            }else if officeModel.type == .OwnerBuildingOfficeTypePrice {
                editLabel.text = buildingModel?.dayPrice
            }
        }
    }
    
    ///独立办公室
    ///建筑面积 - 一位
    ///净高
    ///租金
    var jointIndepentOfficeModel: OwnerBuildingJointOfficeConfigureModel = OwnerBuildingJointOfficeConfigureModel(types: OwnerBuildingJointOfficeType.OwnerBuildingJointOfficeTypeArea) {
        didSet {
            
            titleLabel.attributedText = jointIndepentOfficeModel.getNameFormType(type: jointIndepentOfficeModel.type ?? OwnerBuildingJointOfficeType.OwnerBuildingJointOfficeTypeArea)
            //editLabel.placeholder = jointIndepentOfficeModel.getPalaceHolderFormType(type: jointIndepentOfficeModel.type ?? OwnerBuildingJointOfficeType.OwnerBuildingJointOfficeTypeArea)
            unitLabel.text = jointIndepentOfficeModel.getPalaceHolderFormType(type: jointIndepentOfficeModel.type ?? OwnerBuildingJointOfficeType.OwnerBuildingJointOfficeTypeArea)

            detailIcon.isHidden = true
            lineView.isHidden = false
            editLabel.isUserInteractionEnabled = true
            
            if jointIndepentOfficeModel.type == .OwnerBuildingJointOfficeTypeArea {
                
            }else if jointIndepentOfficeModel.type == .OwnerBuildingJointOfficeTypeClearHeight {
                
            }else if jointIndepentOfficeModel.type == .OwnerBuildingJointOfficeTypePrice {
                
            }
        }
    }
    
    ///开放工位
    var jointOpenStationModel: OwnerBuildingJointOpenStationConfigureModel = OwnerBuildingJointOpenStationConfigureModel(types: OwnerBuildingJointOpenStationType.OwnerBuildingJointOpenStationTypeRentFreePeriod) {
        didSet {
            
            
            titleLabel.attributedText = jointOpenStationModel.getNameFormType(type: jointOpenStationModel.type ?? OwnerBuildingJointOpenStationType.OwnerBuildingJointOpenStationTypePrice)
            //editLabel.placeholder = jointOpenStationModel.getPalaceHolderFormType(type: jointOpenStationModel.type ?? OwnerBuildingJointOpenStationType.OwnerBuildingJointOpenStationTypePrice)
            unitLabel.text = jointOpenStationModel.getPalaceHolderFormType(type: jointOpenStationModel.type ?? OwnerBuildingJointOpenStationType.OwnerBuildingJointOpenStationTypePrice)

            detailIcon.isHidden = true
            lineView.isHidden = false
            editLabel.isUserInteractionEnabled = true
            
            ///租金
            if jointOpenStationModel.type == .OwnerBuildingJointOpenStationTypePrice {
                
            }
        }
    }
    
}

extension OwnerBuildingDecimalNumInputCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        ///建筑面积
        if model.type == .OwnerBuildingEditTypeArea {
            
        }
            ///净高
        else if model.type == .OwnerBuildingEditTypeClearHeight {
            
        }
            ///层高
        else if model.type == .OwnerBuildingEditTypeFloorHeight {
            
        }
            ///物业费
        else if model.type == .OwnerBuildingEditTypePropertyCoast {
            
        }
        
        ///净高
        if jointModel.type == .OwnerBuildingJointEditTypeClearHeight {
            
        }
        
        ///面积
        if officeModel.type == .OwnerBuildingOfficeTypeArea {
            ///如果面积存在，并且和输入的内容一致，是不需要计算工位数的
            if let areaOffice = buildingModel?.areaOffice {
                if textField.text != areaOffice {
                    let min = (Int(textField.text ?? "0") ?? 1) / minSeatsFM_5
                    let max = (Int(textField.text ?? "0") ?? 1) / maxSeatsFM_5
                    buildingModel?.minSeatsOffice = "\(min)"
                    buildingModel?.maxSeatsOffice = "\(max)"
                }
            }else {
                let min = (Int(textField.text ?? "0") ?? 1) / minSeatsFM_5
                let max = (Int(textField.text ?? "0") ?? 1) / maxSeatsFM_5
                buildingModel?.minSeatsOffice = "\(min)"
                buildingModel?.maxSeatsOffice = "\(max)"
            }
            buildingModel?.areaOffice = textField.text
        }
        ///净高
        else if officeModel.type == .OwnerBuildingOfficeTypeClearHeight {
            buildingModel?.clearHeight = textField.text
        }
        ///层高
        else if officeModel.type == .OwnerBuildingOfficeTypeFloorHeight {
            buildingModel?.storeyHeight = textField.text
        }
        ///物业费
        else if officeModel.type == .OwnerBuildingOfficeTypePropertyCoast {
            buildingModel?.propertyCosts = textField.text
        }
        ///租金单价 *
        else if officeModel.type == .OwnerBuildingOfficeTypePrice {
            buildingModel?.dayPrice = textField.text
        }
        
        if jointIndepentOfficeModel.type == .OwnerBuildingJointOfficeTypeArea {
            
        }else if jointIndepentOfficeModel.type == .OwnerBuildingJointOfficeTypeClearHeight {
            
        }else if jointIndepentOfficeModel.type == .OwnerBuildingJointOfficeTypePrice {
            
        }
        
        ///租金
        if jointOpenStationModel.type == .OwnerBuildingJointOpenStationTypePrice {
            
        }
        
        guard let blockk = self.endEditingMessageCell else {
            return
        }
        blockk(buildingModel ?? FangYuanBuildingEditDetailModel())
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        ///建筑面积
        if model.type == .OwnerBuildingEditTypeArea {
            return SSTool.validateBuildingArea(name: string)
        }
            ///净高
        else if model.type == .OwnerBuildingEditTypeClearHeight {
            return SSTool.validateBuildingClearHeight(name: string)
        }
            ///层高
        else if model.type == .OwnerBuildingEditTypeFloorHeight {
            return SSTool.validateBuildingFloorHeight(name: string)
        }
            ///物业费
        else if model.type == .OwnerBuildingEditTypePropertyCoast {
            return SSTool.validateBuildingPropertyCoast(name: string)
        }
        return true
    }
}


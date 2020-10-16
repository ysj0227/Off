//
//  OwnerBuildingInputCell.swift
//  OfficeGo
//
//  Created by Mac pro on 2020/9/28.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit


class OwnerBuildingInputCell: BaseEditCell {
    
    var buildingModel: FangYuanBuildingEditDetailModel?
    
    var endEditingMessageCell:((FangYuanBuildingEditDetailModel) -> Void)?
    
    override func setExtraView() {
        editLabel.font = FONT_14
        titleLabel.textColor = kAppColor_333333
    }
    
    override func setDelegate() {
        editLabel.delegate = self
        editLabel.addTarget(self, action: #selector(valueDidChange), for: .editingChanged)
    }
    
    @objc func valueDidChange() {
        let textNum = editLabel.text?.count
        ///写字楼名称
        if model.type == .OwnerBuildingEditTypeBuildingName {
            //截取
            if textNum! > ownerMaxBuildingnameNumber_20 {
                let index = editLabel.text?.index((editLabel.text?.startIndex)!, offsetBy: ownerMaxBuildingnameNumber_20)
                let str = editLabel.text?.substring(to: index!)
                editLabel.text = str
            }
        }
            ///楼号/楼名
        else if model.type == .OwnerBuildingEditTypeBuildingNum {
            //截取
            if textNum! > ownerMaxBuildingnameNumber_20 {
                let index = editLabel.text?.index((editLabel.text?.startIndex)!, offsetBy: ownerMaxBuildingnameNumber_20)
                let str = editLabel.text?.substring(to: index!)
                editLabel.text = str
            }
        }
            ///详细地址
        else if model.type == .OwnerBuildingEditTypeDetailAddress{
            //截取
            if textNum! > ownerMaxAddressDetailNumber_30 {
                let index = editLabel.text?.index((editLabel.text?.startIndex)!, offsetBy: ownerMaxAddressDetailNumber_30)
                let str = editLabel.text?.substring(to: index!)
                editLabel.text = str
            }
        }
            ///物业公司
        else if model.type == .OwnerBuildingEditTypePropertyCompany{
            //截取
            if textNum! > ownerMaxAddressDetailNumber_30 {
                let index = editLabel.text?.index((editLabel.text?.startIndex)!, offsetBy: ownerMaxAddressDetailNumber_30)
                let str = editLabel.text?.substring(to: index!)
                editLabel.text = str
            }
        }
    }
    
    var model: OwnerBuildingEditConfigureModel = OwnerBuildingEditConfigureModel(types: OwnerBuildingEditType.OwnerBuildingEditTypeBuildingTypew) {
        didSet {
            
            titleLabel.attributedText = model.getNameFormType(type: model.type ?? OwnerBuildingEditType.OwnerBuildingEditTypeBuildingTypew)
            editLabel.placeholder = model.getPalaceHolderFormType(type: model.type ?? OwnerBuildingEditType.OwnerBuildingEditTypeBuildingTypew)
            detailIcon.isHidden = true
            lineView.isHidden = false
            editLabel.isUserInteractionEnabled = true
            
            ///写字楼名称
            if model.type == .OwnerBuildingEditTypeBuildingName {
                if buildingModel?.buildingType == .xieziEnum {
                    titleLabel.attributedText = model.getBuildingNameFormType(type: .xieziEnum)
                    editLabel.placeholder = model.getBuildingPalaceHolderFormType(type: .xieziEnum)
                }else if buildingModel?.buildingType == .chuangyiEnum {
                    titleLabel.attributedText = model.getBuildingNameFormType(type: .chuangyiEnum)
                    editLabel.placeholder = model.getBuildingPalaceHolderFormType(type: .chuangyiEnum)
                }else if buildingModel?.buildingType == .chanyeEnum {
                    titleLabel.attributedText = model.getBuildingNameFormType(type: .chanyeEnum)
                    editLabel.placeholder = model.getBuildingPalaceHolderFormType(type: .chanyeEnum)
                }
            }
                ///楼号/楼名
            else if model.type == .OwnerBuildingEditTypeBuildingNum {
                
            }
                ///详细地址
            else if model.type == .OwnerBuildingEditTypeDetailAddress{
                
            }
                ///物业公司
            else if model.type == .OwnerBuildingEditTypePropertyCompany{
                
            }
        }
    }
    
    ///网点
    var jointModel: OwnerBuildingJointEditConfigureModel = OwnerBuildingJointEditConfigureModel(types: OwnerBuildingJointEditType.OwnerBuildingJointEditTypeBuildingName) {
        didSet {
            
            titleLabel.attributedText = jointModel.getNameFormType(type: jointModel.type ?? OwnerBuildingJointEditType.OwnerBuildingJointEditTypeBuildingName)
            editLabel.placeholder = jointModel.getPalaceHolderFormType(type: jointModel.type ?? OwnerBuildingJointEditType.OwnerBuildingJointEditTypeBuildingName)
            detailIcon.isHidden = true
            lineView.isHidden = false
            editLabel.isUserInteractionEnabled = true
            
            ///写字楼名称
            ///详细地址
            ///写字楼名称
            if jointModel.type == .OwnerBuildingJointEditTypeBuildingName {
                
            }
            ///详细地址
            else if jointModel.type == .OwnerBuildingJointEditTypeDetailAddress{
                
            }
        }
    }
    
    ///办公室
    var officeModel: OwnerBuildingOfficeConfigureModel = OwnerBuildingOfficeConfigureModel(types: OwnerBuildingOfficeType.OwnerBuildingOfficeTypeName) {
        didSet {
            
            titleLabel.attributedText = officeModel.getNameFormType(type: officeModel.type ?? OwnerBuildingOfficeType.OwnerBuildingOfficeTypeName)
            editLabel.placeholder = officeModel.getPalaceHolderFormType(type: officeModel.type ?? OwnerBuildingOfficeType.OwnerBuildingOfficeTypeName)
            detailIcon.isHidden = true
            lineView.isHidden = false
            editLabel.isUserInteractionEnabled = true
            
            ///标题
            if officeModel.type == .OwnerBuildingOfficeTypeName {
                
            }
        }
    }
    
}

extension OwnerBuildingInputCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        ///写字楼名称
        if model.type == .OwnerBuildingEditTypeBuildingName {
            
        }
            ///楼号/楼名
        else if model.type == .OwnerBuildingEditTypeBuildingNum {
            
        }
            ///详细地址
        else if model.type == .OwnerBuildingEditTypeDetailAddress{
            
        }
            ///物业公司
        else if model.type == .OwnerBuildingEditTypePropertyCompany{
            
        }
        
        guard let blockk = self.endEditingMessageCell else {
            return
        }
        blockk(buildingModel ?? FangYuanBuildingEditDetailModel())
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        ///写字楼名称 ------ 过滤 <>=，,。？? 最多25个字
        if model.type == .OwnerBuildingEditTypeBuildingName {
            return SSTool.isPureStrOrNumNumber(text: string)
        }
            ///楼号/楼名 ------ 最多10个字
        else if model.type == .OwnerBuildingEditTypeBuildingNum {
            return SSTool.isPureStrOrNumNumber(text: string)
        }
            ///详细地址 ------
        else if model.type == .OwnerBuildingEditTypeDetailAddress{
            return SSTool.isPureStrOrNumNumber(text: string)
        }
            ///物业公司 ------ 过滤 <>=，,。[]【】{}《》？?|、等符号，最多20个字
        else if model.type == .OwnerBuildingEditTypePropertyCompany{
            return SSTool.isPureStrOrNumNumber(text: string)
        }
        return true
    }
}

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
        
        //MARK: 楼盘
        //MARK: 楼盘  ///写字楼名称 文本，过滤 <>=，,。？? 最多25个字
        if model.type == .OwnerBuildingEditTypeBuildingName {
            //截取
            if textNum! > 25 {
                let index = editLabel.text?.index((editLabel.text?.startIndex)!, offsetBy: 25)
                editLabel.text = editLabel.text?.substring(to: index!)
            }
        }
        //MARK: 楼盘  ///楼号/楼名 默认带入园区名，填写楼名，必填，最多10个字；
        else if model.type == .OwnerBuildingEditTypeBuildingNum {
            //截取
            if textNum! > 10 {
                let index = editLabel.text?.index((editLabel.text?.startIndex)!, offsetBy: 10)
                editLabel.text = editLabel.text?.substring(to: index!)
            }
        }
        //MARK: 楼盘    ///详细地址 2-100
        else if model.type == .OwnerBuildingEditTypeDetailAddress{
            //截取
            if textNum! > 100 {
                let index = editLabel.text?.index((editLabel.text?.startIndex)!, offsetBy: 100)
                editLabel.text = editLabel.text?.substring(to: index!)
            }
        }
        //MARK: 楼盘   ///物业公司 过滤 <>=，,。[]【】{}《》？?|、等符号，最多20个字
        else if model.type == .OwnerBuildingEditTypePropertyCompany{
            //截取
            if textNum! > 20 {
                let index = editLabel.text?.index((editLabel.text?.startIndex)!, offsetBy: 20)
                editLabel.text = editLabel.text?.substring(to: index!)
            }
        }
        
        
        //MARK: 网点
        //MARK: 网点  ///网点名称 文本，过滤 <>=，,。？? 最多25个字
        if jointModel.type == .OwnerBuildingJointEditTypeBuildingName {
            //截取
            if textNum! > 25 {
                let index = editLabel.text?.index((editLabel.text?.startIndex)!, offsetBy: 25)
                editLabel.text = editLabel.text?.substring(to: index!)
            }
        }
        //MARK: 网点  ///详细地址 2-100
        else if jointModel.type == .OwnerBuildingJointEditTypeDetailAddress{
            //截取
            if textNum! > 100 {
                let index = editLabel.text?.index((editLabel.text?.startIndex)!, offsetBy: 100)
                editLabel.text = editLabel.text?.substring(to: index!)
            }
        }
        
        
        //MARK: 办公室
        //MARK: 办公室 ///标题 过滤 <>=，,。？? 和连续超过8位的数字，最多25个字
        if officeModel.type == .OwnerBuildingOfficeTypeName {
            //截取
            if textNum! > 25 {
                let index = editLabel.text?.index((editLabel.text?.startIndex)!, offsetBy: 25)
                editLabel.text = editLabel.text?.substring(to: index!)
            }
        }
        
        //MARK: 独立办公室
        //MARK: 独立办公室 ///标题 过滤 <>=，,。？? 最多20个字，不填时默认拼接：工位数+网点名
        if jointIndepentOfficeModel.type == .OwnerBuildingJointOfficeTypeName {
            //截取
            if textNum! > 20 {
                let index = editLabel.text?.index((editLabel.text?.startIndex)!, offsetBy: 20)
                editLabel.text = editLabel.text?.substring(to: index!)
            }
        }
        //MARK: 独立办公室   ///车位数  文本，最多20个字，过滤特殊字符
        else if jointIndepentOfficeModel.type == .OwnerBuildingJointOfficeTypeParkingNum {
            //截取
            if textNum! > 2 {
                let index = editLabel.text?.index((editLabel.text?.startIndex)!, offsetBy: 2)
                editLabel.text = editLabel.text?.substring(to: index!)
            }
        }
        //MARK: 独立办公室   ///车位费  文本，最多20个字，过滤特殊字符
        else if jointIndepentOfficeModel.type == .OwnerBuildingJointOfficeTypeParkingCoast{
            //截取
            if textNum! > 2 {
                let index = editLabel.text?.index((editLabel.text?.startIndex)!, offsetBy: 2)
                editLabel.text = editLabel.text?.substring(to: index!)
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
            
            ///网点名称
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
    
        ///独立办公室
    var jointIndepentOfficeModel: OwnerBuildingJointOfficeConfigureModel = OwnerBuildingJointOfficeConfigureModel(types: OwnerBuildingJointOfficeType.OwnerBuildingJointOfficeTypeRentFreePeriod) {
        didSet {
            
            
            titleLabel.attributedText = jointIndepentOfficeModel.getNameFormType(type: jointIndepentOfficeModel.type ?? OwnerBuildingJointOfficeType.OwnerBuildingJointOfficeTypeRentFreePeriod)
            editLabel.placeholder = jointIndepentOfficeModel.getPalaceHolderFormType(type: jointIndepentOfficeModel.type ?? OwnerBuildingJointOfficeType.OwnerBuildingJointOfficeTypeRentFreePeriod)
            
            detailIcon.isHidden = true
            lineView.isHidden = false
            editLabel.isUserInteractionEnabled = true
            
            ///标题
            ///车位数
            ///车位费
            if jointIndepentOfficeModel.type == .OwnerBuildingJointOfficeTypeName {
                
            }else if jointIndepentOfficeModel.type == .OwnerBuildingJointOfficeTypeParkingNum {
                
            }else if jointIndepentOfficeModel.type == .OwnerBuildingJointOfficeTypeParkingCoast{
                                
            }
        }
    }
    
}

extension OwnerBuildingInputCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        
        //MARK: 楼盘
        //MARK: 楼盘  ///写字楼名称 文本，过滤 <>=，,。？? 最多25个字
        if model.type == .OwnerBuildingEditTypeBuildingName {
            
            buildingModel?.buildingName = textField.text
            guard let blockk = self.endEditingMessageCell else {
                return
            }
            blockk(buildingModel ?? FangYuanBuildingEditDetailModel())
        }
        //MARK: 楼盘  ///楼号/楼名 默认带入园区名，填写楼名，必填，最多10个字；
        else if model.type == .OwnerBuildingEditTypeBuildingNum {
            
            buildingModel?.buildingNum = textField.text
            guard let blockk = self.endEditingMessageCell else {
                return
            }
            blockk(buildingModel ?? FangYuanBuildingEditDetailModel())
        }
        //MARK: 楼盘    ///详细地址 2-100
        else if model.type == .OwnerBuildingEditTypeDetailAddress{
            
            buildingModel?.address = textField.text
            guard let blockk = self.endEditingMessageCell else {
                return
            }
            blockk(buildingModel ?? FangYuanBuildingEditDetailModel())
        }
        //MARK: 楼盘   ///物业公司 过滤 <>=，,。[]【】{}《》？?|、等符号，最多20个字
        else if model.type == .OwnerBuildingEditTypePropertyCompany{
            
            buildingModel?.property = textField.text
            guard let blockk = self.endEditingMessageCell else {
                return
            }
            blockk(buildingModel ?? FangYuanBuildingEditDetailModel())
        }
        
        
        //MARK: 网点
        //MARK: 网点  ///网点名称 文本，过滤 <>=，,。？? 最多25个字
        if jointModel.type == .OwnerBuildingJointEditTypeBuildingName {
            
            buildingModel?.buildingName = textField.text
            guard let blockk = self.endEditingMessageCell else {
                return
            }
            blockk(buildingModel ?? FangYuanBuildingEditDetailModel())
        }
        //MARK: 网点  ///详细地址 2-100
        else if jointModel.type == .OwnerBuildingJointEditTypeDetailAddress{
            
            buildingModel?.address = textField.text
            guard let blockk = self.endEditingMessageCell else {
                return
            }
            blockk(buildingModel ?? FangYuanBuildingEditDetailModel())
        }
        
        
        //MARK: 办公室
        //MARK: 办公室 ///标题 过滤 <>=，,。？? 和连续超过8位的数字，最多25个字
        if officeModel.type == .OwnerBuildingOfficeTypeName {
            
            buildingModel?.buildingName = textField.text
            guard let blockk = self.endEditingMessageCell else {
                return
            }
            blockk(buildingModel ?? FangYuanBuildingEditDetailModel())
        }
        
        //MARK: 独立办公室
        //MARK: 独立办公室 ///标题 过滤 <>=，,。？? 最多20个字，不填时默认拼接：工位数+网点名
        if jointIndepentOfficeModel.type == .OwnerBuildingJointOfficeTypeName {
            
            buildingModel?.buildingName = textField.text
            guard let blockk = self.endEditingMessageCell else {
                return
            }
            blockk(buildingModel ?? FangYuanBuildingEditDetailModel())
        }
        //MARK: 独立办公室   ///车位数  文本，最多20个字，过滤特殊字符
        else if jointIndepentOfficeModel.type == .OwnerBuildingJointOfficeTypeParkingNum {
            
            buildingModel?.parkingSpace = textField.text
            guard let blockk = self.endEditingMessageCell else {
                return
            }
            blockk(buildingModel ?? FangYuanBuildingEditDetailModel())
        }
        //MARK: 独立办公室   ///车位费  文本，最多20个字，过滤特殊字符
        else if jointIndepentOfficeModel.type == .OwnerBuildingJointOfficeTypeParkingCoast{
            
            buildingModel?.ParkingSpaceRent = textField.text
            guard let blockk = self.endEditingMessageCell else {
                return
            }
            blockk(buildingModel ?? FangYuanBuildingEditDetailModel())
        }
        
    }

    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
//        ///写字楼名称 ------ 过滤 <>=，,。？? 最多25个字
//        if model.type == .OwnerBuildingEditTypeBuildingName {
//            return SSTool.isPureStrOrNumNumber(text: string)
//        }
//            ///楼号/楼名 ------ 最多10个字
//        else if model.type == .OwnerBuildingEditTypeBuildingNum {
//            return SSTool.isPureStrOrNumNumber(text: string)
//        }
//            ///详细地址 ------
//        else if model.type == .OwnerBuildingEditTypeDetailAddress{
//            return SSTool.isPureStrOrNumNumber(text: string)
//        }
//            ///物业公司 ------ 过滤 <>=，,。[]【】{}《》？?|、等符号，最多20个字
//        else if model.type == .OwnerBuildingEditTypePropertyCompany{
//            return SSTool.isPureStrOrNumNumber(text: string)
//        }
//        return true
//    }
}

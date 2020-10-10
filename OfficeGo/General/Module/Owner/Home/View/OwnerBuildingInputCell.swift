//
//  OwnerBuildingInputCell.swift
//  OfficeGo
//
//  Created by Mac pro on 2020/9/28.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit


class OwnerBuildingInputCell: BaseEditCell {
    
    var userModel: OwnerIdentifyUserModel?

    var endEditingMessageCell:((OwnerIdentifyUserModel) -> Void)?
    
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
            if textNum! > ownerMaxBuildingnameNumber {
                let index = editLabel.text?.index((editLabel.text?.startIndex)!, offsetBy: ownerMaxBuildingnameNumber)
                let str = editLabel.text?.substring(to: index!)
                editLabel.text = str
            }
        }
        ///详细地址
        else if model.type == .OwnerBuildingEditTypeDetailAddress{
            //截取
            if textNum! > ownerMaxAddressDetailNumber {
                let index = editLabel.text?.index((editLabel.text?.startIndex)!, offsetBy: ownerMaxAddressDetailNumber)
                let str = editLabel.text?.substring(to: index!)
                editLabel.text = str
            }
        }
        ///物业公司
        else if model.type == .OwnerBuildingEditTypePropertyCompany{
            //截取
            if textNum! > ownerMaxAddressDetailNumber {
                let index = editLabel.text?.index((editLabel.text?.startIndex)!, offsetBy: ownerMaxAddressDetailNumber)
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
                
            }
            ///详细地址
            else if model.type == .OwnerBuildingEditTypeDetailAddress{
                
            }
            ///物业公司
            else if model.type == .OwnerBuildingEditTypePropertyCompany{
                
            }
        }
    }
}

extension OwnerBuildingInputCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        ///写字楼名称
        if model.type == .OwnerBuildingEditTypeBuildingName {
            
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
        blockk(userModel ?? OwnerIdentifyUserModel())
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
}

//
//  OwnerBuildingEditCell.swift
//  OfficeGo
//
//  Created by Mac pro on 2020/9/28.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit


class OwnerBuildingEditCell: BaseEditCell {
    
    var userModel: OwnerIdentifyUserModel?
    
    var endEditingMessageCell:((OwnerIdentifyUserModel) -> Void)?
    
    override func setDelegate() {
        editLabel.delegate = self
        editLabel.addTarget(self, action: #selector(valueDidChange), for: .editingChanged)
        }
        @objc func valueDidChange() {
            let textNum = editLabel.text?.count
            if model.type == .OwnerCreteBuildingTypeBranchName{
                //截取
                if textNum! > ownerMaxBuildingnameNumber {
                    let index = editLabel.text?.index((editLabel.text?.startIndex)!, offsetBy: ownerMaxBuildingnameNumber)
                    let str = editLabel.text?.substring(to: index!)
                    editLabel.text = str
                }
            }else if model.type == .OwnerCreteBuildingTypeBranchAddress{
                //截取
                if textNum! > ownerMaxAddressDetailNumber {
                    let index = editLabel.text?.index((editLabel.text?.startIndex)!, offsetBy: ownerMaxAddressDetailNumber)
                    let str = editLabel.text?.substring(to: index!)
                    editLabel.text = str
                }
            }
        }
    
    var model: OwnerCreatBuildingConfigureModel = OwnerCreatBuildingConfigureModel(types: OwnerCreteBuildingType.OwnerCreteBuildingTypeBranchName) {
        didSet {
            
            titleLabel.attributedText = model.getNameFormType(type: model.type ?? OwnerCreteBuildingType.OwnerCreteBuildingTypeBranchName)
            
            detailIcon.isHidden = true
            
            if model.type == .OwnerCreteBuildingTypeBranchName{
                editLabel.isUserInteractionEnabled = true
                lineView.isHidden = false
                editLabel.text = userModel?.buildingName
            }else if model.type == .OwnerCreteBuildingTypeBranchDistrictArea{
                editLabel.isUserInteractionEnabled = false
                lineView.isHidden = false
                detailIcon.isHidden = false
                editLabel.text = "\(userModel?.districtString ?? "")\(userModel?.businessString ?? "")"
            }else if model.type == .OwnerCreteBuildingTypeBranchAddress{
                editLabel.isUserInteractionEnabled = true
                lineView.isHidden = false
                editLabel.text = userModel?.buildingAddress
            }else if model.type == .OwnerCreteBuildingTypeUploadYingyePhoto{
                editLabel.isUserInteractionEnabled = false
                lineView.isHidden = true
                editLabel.text = ""
            }
        }
    }
}

extension OwnerBuildingEditCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if model.type == .OwnerCreteBuildingTypeBranchName{
            userModel?.buildingName = textField.text
        }else if model.type == .OwnerCreteBuildingTypeBranchAddress{
            userModel?.buildingAddress = textField.text
        }
        
        guard let blockk = self.endEditingMessageCell else {
            return
        }
        blockk(userModel ?? OwnerIdentifyUserModel())
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
}

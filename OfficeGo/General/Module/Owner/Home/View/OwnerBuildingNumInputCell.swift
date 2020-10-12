//
//  OwnerBuildingNumInputCell.swift
//  OfficeGo
//
//  Created by Mac pro on 2020/9/30.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class OwnerBuildingNumInputCell: BaseEditCell {
    
    var userModel: OwnerIdentifyUserModel?

    var endEditingMessageCell:((OwnerIdentifyUserModel) -> Void)?

    override func setExtraView() {
        editLabel.font = FONT_14
        titleLabel.textColor = kAppColor_333333
    }
    
    override func setDelegate() {
        editLabel.keyboardType = .numberPad
        editLabel.delegate = self
        editLabel.addTarget(self, action: #selector(valueDidChange), for: .editingChanged)
    }
    
    @objc func valueDidChange() {
        let textNum = editLabel.text?.count
        ///总楼层
        if model.type == .OwnerBuildingEditTypeTotalFloor {
            
        }
        ///车位数
        else if model.type == .OwnerBuildingEditTypeParkingNum {
            
        }
        ///车位费
        else if model.type == .OwnerBuildingEditTypeParkingCoast {
            
        }
    }
    
    var model: OwnerBuildingEditConfigureModel = OwnerBuildingEditConfigureModel(types: OwnerBuildingEditType.OwnerBuildingEditTypeBuildingTypew) {
        didSet {
            
            titleLabel.attributedText = model.getNameFormType(type: model.type ?? OwnerBuildingEditType.OwnerBuildingEditTypeBuildingTypew)
            editLabel.placeholder = model.getPalaceHolderFormType(type: model.type ?? OwnerBuildingEditType.OwnerBuildingEditTypeBuildingTypew)
            detailIcon.isHidden = true
            lineView.isHidden = false
            editLabel.isUserInteractionEnabled = true

            ///总楼层
            if model.type == .OwnerBuildingEditTypeTotalFloor {
                
            }
            ///车位数
            else if model.type == .OwnerBuildingEditTypeParkingNum {
                
            }
            ///车位费
            else if model.type == .OwnerBuildingEditTypeParkingCoast {
                
            }
        }
    }
}

extension OwnerBuildingNumInputCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        ///总楼层
        if model.type == .OwnerBuildingEditTypeTotalFloor {
            
        }
        ///车位数
        else if model.type == .OwnerBuildingEditTypeParkingNum {
            
        }
        ///车位费
        else if model.type == .OwnerBuildingEditTypeParkingCoast {
            
        }
        
        guard let blockk = self.endEditingMessageCell else {
            return
        }
        blockk(userModel ?? OwnerIdentifyUserModel())
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
}


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
        titleLabel.textColor = kAppColor_333333
    }
    
    override func setDelegate() {
        editLabel.keyboardType = .phonePad
        editLabel.delegate = self
        editLabel.addTarget(self, action: #selector(valueDidChange), for: .editingChanged)
    }
    
    @objc func valueDidChange() {
        let textNum = editLabel.text?.count
        ///总楼层
        if model.type == .OwnerBuildingEditTypeTotalFloor {
            
        }
        ///建筑面积
        else if model.type == .OwnerBuildingEditTypeArea {
            
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
        ///车位数
        else if model.type == .OwnerBuildingEditTypeParkingNum {
            
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
            ///建筑面积
            else if model.type == .OwnerBuildingEditTypeArea {
                
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
            ///车位数
            else if model.type == .OwnerBuildingEditTypeParkingNum {
                
            }
        }
    }
}

extension OwnerBuildingNumInputCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        ///总楼层
        if model.type == .OwnerBuildingEditTypeTotalFloor {
            
        }
        ///建筑面积
        else if model.type == .OwnerBuildingEditTypeArea {
            
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
        ///车位数
        else if model.type == .OwnerBuildingEditTypeParkingNum {
            
        }
        
        guard let blockk = self.endEditingMessageCell else {
            return
        }
        blockk(userModel ?? OwnerIdentifyUserModel())
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
}


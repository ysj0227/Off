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
    
    var model: OwnerBuildingEditConfigureModel = OwnerBuildingEditConfigureModel(types: OwnerBuildingEditType.OwnerBuildingEditTypeBuildingTypew) {
        didSet {
            
            titleLabel.attributedText = model.getNameFormType(type: model.type ?? OwnerBuildingEditType.OwnerBuildingEditTypeBuildingTypew)
            editLabel.placeholder = model.getPalaceHolderFormType(type: model.type ?? OwnerBuildingEditType.OwnerBuildingEditTypeBuildingTypew)
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


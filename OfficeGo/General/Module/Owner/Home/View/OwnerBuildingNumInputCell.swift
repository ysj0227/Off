//
//  OwnerBuildingNumInputCell.swift
//  OfficeGo
//
//  Created by Mac pro on 2020/9/30.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class OwnerBuildingNumInputCell: BaseEditCell {
    
    var buildingModel: FangYuanBuildingEditDetailModel?
    
    var endEditingMessageCell:((FangYuanBuildingEditDetailModel) -> Void)?
    
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
    
    ///网点
    var jointModel: OwnerBuildingJointEditConfigureModel = OwnerBuildingJointEditConfigureModel(types: OwnerBuildingJointEditType.OwnerBuildingJointEditTypeTotalFloor) {
        didSet {
            
            titleLabel.attributedText = jointModel.getNameFormType(type: jointModel.type ?? OwnerBuildingJointEditType.OwnerBuildingJointEditTypeTotalFloor)
            editLabel.placeholder = jointModel.getPalaceHolderFormType(type: jointModel.type ?? OwnerBuildingJointEditType.OwnerBuildingJointEditTypeTotalFloor)
            detailIcon.isHidden = true
            lineView.isHidden = false
            editLabel.isUserInteractionEnabled = true
            
            ///会议室数量，数字，必填，支持输入0-10的正整数，单位 个；
            ///最多容纳人数，数字，选填，0-10的正整数，单位 人；
            ///车位数
            ///车位费
            if jointModel.type == .OwnerBuildingJointEditTypeConferenceNumber {
                
            } else if jointModel.type == .OwnerBuildingJointEditTypeConferencePeopleNumber {
                
            }else if jointModel.type == .OwnerBuildingJointEditTypeParkingNum {
                
            }else if jointModel.type == .OwnerBuildingJointEditTypeParkingCoast {
                
            }
        }
    }
    
    ///办公室
    var officeModel: OwnerBuildingOfficeConfigureModel = OwnerBuildingOfficeConfigureModel(types: OwnerBuildingOfficeType.OwnerBuildingOfficeTypeMinRentalPeriod) {
        didSet {
            
            titleLabel.attributedText = officeModel.getNameFormType(type: officeModel.type ?? OwnerBuildingOfficeType.OwnerBuildingOfficeTypeMinRentalPeriod)
            editLabel.placeholder = officeModel.getPalaceHolderFormType(type: officeModel.type ?? OwnerBuildingOfficeType.OwnerBuildingOfficeTypeMinRentalPeriod)
            detailIcon.isHidden = true
            lineView.isHidden = false
            editLabel.isUserInteractionEnabled = true
            
            ///最短租期
            if officeModel.type == .OwnerBuildingOfficeTypeMinRentalPeriod {
                
            }
        }
    }
    
    ///独立办公室
    var jointIndepentOfficeModel: OwnerBuildingJointOfficeConfigureModel = OwnerBuildingJointOfficeConfigureModel(types: OwnerBuildingJointOfficeType.OwnerBuildingJointOfficeTypeSeats) {
        didSet {
            
            
            titleLabel.attributedText = jointIndepentOfficeModel.getNameFormType(type: jointIndepentOfficeModel.type ?? OwnerBuildingJointOfficeType.OwnerBuildingJointOfficeTypeRentFreePeriod)
            editLabel.placeholder = jointIndepentOfficeModel.getPalaceHolderFormType(type: jointIndepentOfficeModel.type ?? OwnerBuildingJointOfficeType.OwnerBuildingJointOfficeTypeRentFreePeriod)
            
            detailIcon.isHidden = true
            lineView.isHidden = false
            editLabel.isUserInteractionEnabled = true
            
            ///工位数
            ///最短租期
            ///车位数
            ///车位费
            if jointIndepentOfficeModel.type == .OwnerBuildingJointOfficeTypeSeats {
                
            }else if jointIndepentOfficeModel.type == .OwnerBuildingJointOfficeTypeMinRentalPeriod {
                
            }else if jointIndepentOfficeModel.type == .OwnerBuildingJointOfficeTypeParkingNum {
                
            }else if jointIndepentOfficeModel.type == .OwnerBuildingJointOfficeTypeParkingCoast{
                                
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
        blockk(buildingModel ?? FangYuanBuildingEditDetailModel())
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        ///总楼层
        if model.type == .OwnerBuildingEditTypeTotalFloor {
            return SSTool.validateBuildingFloor(name: string)
        }
            ///车位数
        else if model.type == .OwnerBuildingEditTypeParkingNum {
            return SSTool.validateBuildingParkingNum(name: string)
        }
            ///车位费
        else if model.type == .OwnerBuildingEditTypeParkingCoast {
            return SSTool.validateBuildingParkingCoast(name: string)
        }
        return true
    }
}


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
        editLabel.snp.remakeConstraints { (make) in
            make.trailing.equalTo(unitLabel.snp.leading).offset(-5)
            make.leading.equalTo(titleLabel.snp.trailing)
            make.top.bottom.equalToSuperview()
        }
    }
    
    override func setDelegate() {
        editLabel.keyboardType = .numberPad
        editLabel.delegate = self
        editLabel.addTarget(self, action: #selector(valueDidChange), for: .editingChanged)
    }
    
    @objc func valueDidChange() {
        let textNum = editLabel.text?.count
        
        //MARK: 楼盘
        //MARK: 楼盘  总楼层  仅支持1-150之间正整数，单位“层”，提示文字：请填写总楼层数
        if model.type == .OwnerBuildingEditTypeTotalFloor {
            //截取
            if textNum! > 3 {
                let index = editLabel.text?.index((editLabel.text?.startIndex)!, offsetBy: 3)
                editLabel.text = editLabel.text?.substring(to: index!)
            }
        }
        //MARK: 楼盘    ///车位数    仅支持0和正整数
        else if model.type == .OwnerBuildingEditTypeParkingNum {
            //截取
            if textNum! > 9 {
                let index = editLabel.text?.index((editLabel.text?.startIndex)!, offsetBy: 9)
                editLabel.text = editLabel.text?.substring(to: index!)
            }
        }
        //MARK: 楼盘    ///车位费    仅支持0-5000正整数，默认值0，当填0时前台展示“未知”，单位，“元/月”
        else if model.type == .OwnerBuildingEditTypeParkingCoast {
            //截取
            if textNum! > 4 {
                let index = editLabel.text?.index((editLabel.text?.startIndex)!, offsetBy: 4)
                editLabel.text = editLabel.text?.substring(to: index!)
            }
        }
        
        
        //MARK: 网点
        //MARK: 网点  ///会议室数量，数字，必填，支持输入0-10的正整数，单位 个；
        if jointModel.type == .OwnerBuildingJointEditTypeConferenceNumber {
            //截取
            if textNum! > 2 {
                let index = editLabel.text?.index((editLabel.text?.startIndex)!, offsetBy: 2)
                editLabel.text = editLabel.text?.substring(to: index!)
            }
        }
        //MARK: 网点  ///最多容纳人数，数字，选填，0-10的正整数，单位 人；
        else if jointModel.type == .OwnerBuildingJointEditTypeConferencePeopleNumber {
            //截取
            if textNum! > 2 {
                let index = editLabel.text?.index((editLabel.text?.startIndex)!, offsetBy: 2)
                editLabel.text = editLabel.text?.substring(to: index!)
            }
        }
        //MARK: 网点  ///车位数    仅支持0和正整数
        else if jointModel.type == .OwnerBuildingJointEditTypeParkingNum {
            //截取
            if textNum! > 9 {
                let index = editLabel.text?.index((editLabel.text?.startIndex)!, offsetBy: 9)
                editLabel.text = editLabel.text?.substring(to: index!)
            }
        }
        //MARK: 网点  ///车位费    仅支持0-5000正整数，默认值0，当填0时前台展示“未知”，单位，“元/月”
        else if jointModel.type == .OwnerBuildingJointEditTypeParkingCoast {
            //截取
            if textNum! > 4 {
                let index = editLabel.text?.index((editLabel.text?.startIndex)!, offsetBy: 4)
                editLabel.text = editLabel.text?.substring(to: index!)
            }
        }
        
        
        
        //MARK: 办公室
        //MARK: 办公室 ///最短租期 必填，1-60正整数，单位 月
        if officeModel.type == .OwnerBuildingOfficeTypeMinRentalPeriod {
            //截取
            if textNum! > 2 {
                let index = editLabel.text?.index((editLabel.text?.startIndex)!, offsetBy: 2)
                editLabel.text = editLabel.text?.substring(to: index!)
            }
        }
        
        
        
        //MARK: 独立办公室
        //MARK: 独立办公室   ///工位数  工位数，支持填写1-100的正整数
        if jointIndepentOfficeModel.type == .OwnerBuildingJointOfficeTypeSeats {
            //截取
            if textNum! > 3 {
                let index = editLabel.text?.index((editLabel.text?.startIndex)!, offsetBy: 3)
                editLabel.text = editLabel.text?.substring(to: index!)
            }
        }
        //MARK: 独立办公室   ///最短租期 最短租期，必填，数字，单位月，支持输入0-60正整数
        else if jointIndepentOfficeModel.type == .OwnerBuildingJointOfficeTypeMinRentalPeriod {
            //截取
            if textNum! > 2 {
                let index = editLabel.text?.index((editLabel.text?.startIndex)!, offsetBy: 2)
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
        
        
        
        //MARK: 开放工位
        //MARK: 开放工位    ///工位数  工位数，数字，支持输入1-200正整数，单位 个
        if jointOpenStationModel.type == .OwnerBuildingJointOpenStationTypeSeats {
            //截取
            if textNum! > 3 {
                let index = editLabel.text?.index((editLabel.text?.startIndex)!, offsetBy: 3)
                editLabel.text = editLabel.text?.substring(to: index!)
            }
        }
        //MARK: 开放工位    ///最短租期 最短租期，数字，必填，单位月，支持输入0-60正整数
        else if jointOpenStationModel.type == .OwnerBuildingJointOpenStationTypeRentFreePeriod {
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
            //editLabel.placeholder = model.getPalaceHolderFormType(type: model.type ?? OwnerBuildingEditType.OwnerBuildingEditTypeBuildingTypew)
            unitLabel.text = model.getPalaceHolderFormType(type: model.type ?? OwnerBuildingEditType.OwnerBuildingEditTypeBuildingTypew)
            
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
            //editLabel.placeholder = jointModel.getPalaceHolderFormType(type: jointModel.type ?? OwnerBuildingJointEditType.OwnerBuildingJointEditTypeTotalFloor)
            unitLabel.text = jointModel.getPalaceHolderFormType(type: jointModel.type ?? OwnerBuildingJointEditType.OwnerBuildingJointEditTypeTotalFloor)
            
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
            //editLabel.placeholder = officeModel.getPalaceHolderFormType(type: officeModel.type ?? OwnerBuildingOfficeType.OwnerBuildingOfficeTypeMinRentalPeriod)
            unitLabel.text = officeModel.getPalaceHolderFormType(type: officeModel.type ?? OwnerBuildingOfficeType.OwnerBuildingOfficeTypeMinRentalPeriod)
            
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
            //editLabel.placeholder = jointIndepentOfficeModel.getPalaceHolderFormType(type: jointIndepentOfficeModel.type ?? OwnerBuildingJointOfficeType.OwnerBuildingJointOfficeTypeRentFreePeriod)
            unitLabel.text = jointIndepentOfficeModel.getPalaceHolderFormType(type: jointIndepentOfficeModel.type ?? OwnerBuildingJointOfficeType.OwnerBuildingJointOfficeTypeRentFreePeriod)
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
    
    ///开放工位
    var jointOpenStationModel: OwnerBuildingJointOpenStationConfigureModel = OwnerBuildingJointOpenStationConfigureModel(types: OwnerBuildingJointOpenStationType.OwnerBuildingJointOpenStationTypeRentFreePeriod) {
        didSet {
            
            
            titleLabel.attributedText = jointOpenStationModel.getNameFormType(type: jointOpenStationModel.type ?? OwnerBuildingJointOpenStationType.OwnerBuildingJointOpenStationTypeRentFreePeriod)
            //editLabel.placeholder = jointOpenStationModel.getPalaceHolderFormType(type: jointOpenStationModel.type ?? OwnerBuildingJointOpenStationType.OwnerBuildingJointOpenStationTypeRentFreePeriod)
            unitLabel.text = jointOpenStationModel.getPalaceHolderFormType(type: jointOpenStationModel.type ?? OwnerBuildingJointOpenStationType.OwnerBuildingJointOpenStationTypeRentFreePeriod)

            detailIcon.isHidden = true
            lineView.isHidden = false
            editLabel.isUserInteractionEnabled = true
            
            ///工位数
            ///最短租期
            if jointOpenStationModel.type == .OwnerBuildingJointOpenStationTypeSeats {
                
            }else if jointOpenStationModel.type == .OwnerBuildingJointOpenStationTypeRentFreePeriod {
                
            }
        }
    }
}

extension OwnerBuildingNumInputCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {

        //MARK: 楼盘
        //MARK: 楼盘  总楼层  仅支持1-150之间正整数，单位“层”，提示文字：请填写总楼层数
        if model.type == .OwnerBuildingEditTypeTotalFloor {
            
            buildingModel?.totalFloor = textField.text
            guard let blockk = self.endEditingMessageCell else {
                return
            }
            blockk(buildingModel ?? FangYuanBuildingEditDetailModel())
        }
        //MARK: 楼盘    ///车位数    仅支持0和正整数
        else if model.type == .OwnerBuildingEditTypeParkingNum {
        
        }
        //MARK: 楼盘    ///车位费    仅支持0-5000正整数，默认值0，当填0时前台展示“未知”，单位，“元/月”
        else if model.type == .OwnerBuildingEditTypeParkingCoast {
        
        }
        
        
        //MARK: 网点
        //MARK: 网点  ///会议室数量，数字，必填，支持输入0-10的正整数，单位 个；
        if jointModel.type == .OwnerBuildingJointEditTypeConferenceNumber {
        
        }
        //MARK: 网点  ///最多容纳人数，数字，选填，0-10的正整数，单位 人；
        else if jointModel.type == .OwnerBuildingJointEditTypeConferencePeopleNumber {
        
        }
        //MARK: 网点  ///车位数    仅支持0和正整数
        else if jointModel.type == .OwnerBuildingJointEditTypeParkingNum {
        
        }
        //MARK: 网点  ///车位费    仅支持0-5000正整数，默认值0，当填0时前台展示“未知”，单位，“元/月”
        else if jointModel.type == .OwnerBuildingJointEditTypeParkingCoast {
        
        }
        
        
        
        //MARK: 办公室
        //MARK: 办公室 ///最短租期 必填，1-60正整数，单位 月
        if officeModel.type == .OwnerBuildingOfficeTypeMinRentalPeriod {
        
        }
        
        
        
        //MARK: 独立办公室
        //MARK: 独立办公室   ///工位数  工位数，支持填写1-100的正整数
        if jointIndepentOfficeModel.type == .OwnerBuildingJointOfficeTypeSeats {
        
        }
        //MARK: 独立办公室   ///最短租期 最短租期，必填，数字，单位月，支持输入0-60正整数
        else if jointIndepentOfficeModel.type == .OwnerBuildingJointOfficeTypeMinRentalPeriod {
        
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
        
        
        
        //MARK: 开放工位
        //MARK: 开放工位    ///工位数  工位数，数字，支持输入1-200正整数，单位 个
        if jointOpenStationModel.type == .OwnerBuildingJointOpenStationTypeSeats {
        
        }
        //MARK: 开放工位    ///最短租期 最短租期，数字，必填，单位月，支持输入0-60正整数
        else if jointOpenStationModel.type == .OwnerBuildingJointOpenStationTypeRentFreePeriod {
        
        }
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
//        ///总楼层
//        if model.type == .OwnerBuildingEditTypeTotalFloor {
//            return SSTool.validateBuildingFloor(name: string)
//        }
//            ///车位数
//        else if model.type == .OwnerBuildingEditTypeParkingNum {
//            return SSTool.validateBuildingParkingNum(name: string)
//        }
//            ///车位费
//        else if model.type == .OwnerBuildingEditTypeParkingCoast {
//            return SSTool.validateBuildingParkingCoast(name: string)
//        }
//        return true
//    }
}


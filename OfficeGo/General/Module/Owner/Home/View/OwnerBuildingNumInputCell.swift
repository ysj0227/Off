//
//  OwnerBuildingNumInputCell.swift
//  OfficeGo
//
//  Created by Mac pro on 2020/9/30.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class OwnerBuildingNumInputCell: BaseEditCell {
    
    var buildingModel: FangYuanBuildingEditModel?
    
    var FYModel: FangYuanHouseEditModel?

    ///楼盘
    var endEditingMessageCell:((FangYuanBuildingEditModel) -> Void)?
    
    ///房源
    var endEditingFYMessageCell:((FangYuanHouseEditModel) -> Void)?
    
    
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
            if let num = Int(editLabel.text ?? "0") {
                if num > 150 {
                    editLabel.text?.removeLast(1)
                    AppUtilities.makeToast("仅支持1-150之间正整数")
                }
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
            if let num = Int(editLabel.text ?? "0") {
                if num > 5000 {
                    editLabel.text?.removeLast(1)
                    AppUtilities.makeToast("仅支持0-5000正整数")
                }
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
            if let num = Int(editLabel.text ?? "0") {
                if num > 10 {
                    editLabel.text?.removeLast(1)
                    AppUtilities.makeToast("仅支持0-10正整数")
                }
            }
        }
        //MARK: 网点  ///最多容纳人数，数字，选填，0-50的正整数，单位 人；
        else if jointModel.type == .OwnerBuildingJointEditTypeConferencePeopleNumber {
            //截取
            if textNum! > 2 {
                let index = editLabel.text?.index((editLabel.text?.startIndex)!, offsetBy: 2)
                editLabel.text = editLabel.text?.substring(to: index!)
            }
            if let num = Int(editLabel.text ?? "0") {
                if num > 50 {
                    editLabel.text?.removeLast(1)
                    AppUtilities.makeToast("仅支持0-50正整数")
                }
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
            if let num = Int(editLabel.text ?? "0") {
                if num > 5000 {
                    editLabel.text?.removeLast(1)
                    AppUtilities.makeToast("仅支持0-5000正整数")
                }
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
            if let num = Int(editLabel.text ?? "0") {
                if num > 60 {
                    editLabel.text?.removeLast(1)
                    AppUtilities.makeToast("仅支持0-60正整数")
                }
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
            if let num = Int(editLabel.text ?? "0") {
                if num > 100 {
                    editLabel.text?.removeLast(1)
                    AppUtilities.makeToast("仅支持0-100正整数")
                }
            }
        }
        //MARK: 独立办公室   ///最短租期 最短租期，必填，数字，单位月，支持输入0-60正整数
        else if jointIndepentOfficeModel.type == .OwnerBuildingJointOfficeTypeMinRentalPeriod {
            //截取
            if textNum! > 2 {
                let index = editLabel.text?.index((editLabel.text?.startIndex)!, offsetBy: 2)
                editLabel.text = editLabel.text?.substring(to: index!)
            }
            if let num = Int(editLabel.text ?? "0") {
                if num > 60 {
                    editLabel.text?.removeLast(1)
                    AppUtilities.makeToast("仅支持0-60正整数")
                }
            }
        }
        //MARK: 独立办公室       租金，必填，正整数，范围100-100000，单位 元/月
        else if jointIndepentOfficeModel.type == .OwnerBuildingJointOfficeTypePrice {
            //截取
            if textNum! > 7 {
                let index = editLabel.text?.index((editLabel.text?.startIndex)!, offsetBy: 7)
                editLabel.text = editLabel.text?.substring(to: index!)
            }
            if let num = Int(editLabel.text ?? "0") {
                if num > 100000 {
                    editLabel.text?.removeLast(1)
                    AppUtilities.makeToast("仅支持100-100000正整数")
                }
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
            if let num = Int(editLabel.text ?? "0") {
                if num > 200 {
                    editLabel.text?.removeLast(1)
                    AppUtilities.makeToast("仅支持0-200正整数")
                }
            }
        }
        //MARK: 开放工位    ///最短租期 最短租期，数字，必填，单位月，支持输入0-60正整数
        else if jointOpenStationModel.type == .OwnerBuildingJointOpenStationTypeMinRentalPeriod {
            //截取
            if textNum! > 2 {
                let index = editLabel.text?.index((editLabel.text?.startIndex)!, offsetBy: 2)
                editLabel.text = editLabel.text?.substring(to: index!)
            }
            if let num = Int(editLabel.text ?? "0") {
                if num > 60 {
                    editLabel.text?.removeLast(1)
                    AppUtilities.makeToast("仅支持0-60正整数")
                }
            }
        }
        
    }
    
    var model: OwnerBuildingEditConfigureModel = OwnerBuildingEditConfigureModel(types: OwnerBuildingEditType.OwnerBuildingEditTypeBuildingImage) {
        didSet {
            
            titleLabel.attributedText = model.getNameFormType(type: model.type ?? OwnerBuildingEditType.OwnerBuildingEditTypeBuildingTypew)
            //editLabel.placeholder = model.getPalaceHolderFormType(type: model.type ?? OwnerBuildingEditType.OwnerBuildingEditTypeBuildingTypew)
            unitLabel.text = model.getPalaceHolderFormType(type: model.type ?? OwnerBuildingEditType.OwnerBuildingEditTypeBuildingTypew)
            
            detailIcon.isHidden = true
            lineView.isHidden = false
            editLabel.isUserInteractionEnabled = true
            
            ///总楼层
            if model.type == .OwnerBuildingEditTypeTotalFloor {
                editLabel.text = buildingModel?.buildingMsg?.totalFloor
            }
                ///车位数
            else if model.type == .OwnerBuildingEditTypeParkingNum {
                editLabel.text = buildingModel?.buildingMsg?.parkingSpace
            }
                ///车位费
            else if model.type == .OwnerBuildingEditTypeParkingCoast {
                editLabel.text = buildingModel?.buildingMsg?.parkingSpaceRent
            }
        }
    }
    
    ///网点
    var jointModel: OwnerBuildingJointEditConfigureModel = OwnerBuildingJointEditConfigureModel(types: OwnerBuildingJointEditType.OwnerBuildingJointEditTypeBuildingImage) {
        didSet {
            
            titleLabel.attributedText = jointModel.getNameFormType(type: jointModel.type ?? OwnerBuildingJointEditType.OwnerBuildingJointEditTypeTotalFloor)
            //editLabel.placeholder = jointModel.getPalaceHolderFormType(type: jointModel.type ?? OwnerBuildingJointEditType.OwnerBuildingJointEditTypeTotalFloor)
            unitLabel.text = jointModel.getPalaceHolderFormType(type: jointModel.type ?? OwnerBuildingJointEditType.OwnerBuildingJointEditTypeTotalFloor)
            
            detailIcon.isHidden = true
            lineView.isHidden = false
            editLabel.isUserInteractionEnabled = true
            
            ///会议室数量，数字，必填，支持输入0-10的正整数，单位 个；
            ///最多容纳人数，数字，选填，0-50的正整数，单位 人；
            ///车位数
            ///车位费
            if jointModel.type == .OwnerBuildingJointEditTypeConferenceNumber {
                editLabel.text = buildingModel?.buildingMsg?.conferenceNumber
            } else if jointModel.type == .OwnerBuildingJointEditTypeConferencePeopleNumber {
                editLabel.text = buildingModel?.buildingMsg?.conferencePeopleNumber
            }else if jointModel.type == .OwnerBuildingJointEditTypeParkingNum {
                editLabel.text = buildingModel?.buildingMsg?.parkingSpace
            }else if jointModel.type == .OwnerBuildingJointEditTypeParkingCoast {
                editLabel.text = buildingModel?.buildingMsg?.parkingSpaceRent
            }
        }
    }
    
    ///办公室
    var officeModel: OwnerBuildingOfficeConfigureModel = OwnerBuildingOfficeConfigureModel(types: OwnerBuildingOfficeType.OwnerBuildingOfficeTypeBuildingImage) {
        didSet {
            
            titleLabel.attributedText = officeModel.getNameFormType(type: officeModel.type ?? OwnerBuildingOfficeType.OwnerBuildingOfficeTypeMinRentalPeriod)
            //editLabel.placeholder = officeModel.getPalaceHolderFormType(type: officeModel.type ?? OwnerBuildingOfficeType.OwnerBuildingOfficeTypeMinRentalPeriod)
            unitLabel.text = officeModel.getPalaceHolderFormType(type: officeModel.type ?? OwnerBuildingOfficeType.OwnerBuildingOfficeTypeMinRentalPeriod)
            
            detailIcon.isHidden = true
            lineView.isHidden = false
            editLabel.isUserInteractionEnabled = true
            
            ///最短租期
            ///租金单价 -
            if officeModel.type == .OwnerBuildingOfficeTypeMinRentalPeriod {
                editLabel.text = FYModel?.houseMsg?.minimumLease
            }
        }
    }
    
    ///独立办公室
    var jointIndepentOfficeModel: OwnerBuildingJointOfficeConfigureModel = OwnerBuildingJointOfficeConfigureModel(types: OwnerBuildingJointOfficeType.OwnerBuildingJointOfficeTypeBuildingImage) {
        didSet {
            
            
            titleLabel.attributedText = jointIndepentOfficeModel.getNameFormType(type: jointIndepentOfficeModel.type ?? OwnerBuildingJointOfficeType.OwnerBuildingJointOfficeTypeRentFreePeriod)
            //editLabel.placeholder = jointIndepentOfficeModel.getPalaceHolderFormType(type: jointIndepentOfficeModel.type ?? OwnerBuildingJointOfficeType.OwnerBuildingJointOfficeTypeRentFreePeriod)
            unitLabel.text = jointIndepentOfficeModel.getPalaceHolderFormType(type: jointIndepentOfficeModel.type ?? OwnerBuildingJointOfficeType.OwnerBuildingJointOfficeTypeRentFreePeriod)
            detailIcon.isHidden = true
            lineView.isHidden = false
            editLabel.isUserInteractionEnabled = true
            
            ///工位数
            ///最短租期
            ///租金
            if jointIndepentOfficeModel.type == .OwnerBuildingJointOfficeTypeSeats {
                editLabel.text = FYModel?.houseMsg?.seats
            }else if jointIndepentOfficeModel.type == .OwnerBuildingJointOfficeTypeMinRentalPeriod {
                editLabel.text = FYModel?.houseMsg?.minimumLease
            }else if jointIndepentOfficeModel.type == .OwnerBuildingJointOfficeTypePrice {
                editLabel.text = FYModel?.houseMsg?.monthPrice
            }
        }
    }
    
    ///开放工位
    var jointOpenStationModel: OwnerBuildingJointOpenStationConfigureModel = OwnerBuildingJointOpenStationConfigureModel(types: OwnerBuildingJointOpenStationType.OwnerBuildingJointOpenStationTypeBuildingImage) {
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
                editLabel.text = FYModel?.houseMsg?.seats
            }else if jointOpenStationModel.type == .OwnerBuildingJointOpenStationTypeMinRentalPeriod {
                editLabel.text = FYModel?.houseMsg?.minimumLease
            }
        }
    }
}

extension OwnerBuildingNumInputCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {

        //MARK: 楼盘
        //MARK: 楼盘  总楼层  仅支持1-150之间正整数，单位“层”，提示文字：请填写总楼层数
        if model.type == .OwnerBuildingEditTypeTotalFloor {
            
            buildingModel?.buildingMsg?.totalFloor = textField.text
            guard let blockk = self.endEditingMessageCell else {
                return
            }
            blockk(buildingModel ?? FangYuanBuildingEditModel())
        }
        //MARK: 楼盘    ///车位数    仅支持0和正整数
        else if model.type == .OwnerBuildingEditTypeParkingNum {
            
            buildingModel?.buildingMsg?.parkingSpace = textField.text
            guard let blockk = self.endEditingMessageCell else {
                return
            }
            blockk(buildingModel ?? FangYuanBuildingEditModel())
        }
        //MARK: 楼盘    ///车位费    仅支持0-5000正整数，默认值0，当填0时前台展示“未知”，单位，“元/月”
        else if model.type == .OwnerBuildingEditTypeParkingCoast {
            
            buildingModel?.buildingMsg?.parkingSpaceRent = textField.text
            guard let blockk = self.endEditingMessageCell else {
                return
            }
            blockk(buildingModel ?? FangYuanBuildingEditModel())
        }
        
        
        //MARK: 网点
        //MARK: 网点  ///会议室数量，数字，必填，支持输入0-10的正整数，单位 个；
        if jointModel.type == .OwnerBuildingJointEditTypeConferenceNumber {
            
            buildingModel?.buildingMsg?.conferenceNumber = textField.text
            guard let blockk = self.endEditingMessageCell else {
                return
            }
            blockk(buildingModel ?? FangYuanBuildingEditModel())
        }
        //MARK: 网点  ///最多容纳人数，数字，选填，0-50的正整数，单位 人；
        else if jointModel.type == .OwnerBuildingJointEditTypeConferencePeopleNumber {
            
            buildingModel?.buildingMsg?.conferencePeopleNumber = textField.text
            guard let blockk = self.endEditingMessageCell else {
                return
            }
            blockk(buildingModel ?? FangYuanBuildingEditModel())
        }
        //MARK: 网点  ///车位数    仅支持0和正整数
        else if jointModel.type == .OwnerBuildingJointEditTypeParkingNum {
            
            buildingModel?.buildingMsg?.parkingSpace = textField.text
            guard let blockk = self.endEditingMessageCell else {
                return
            }
            blockk(buildingModel ?? FangYuanBuildingEditModel())
        }
        //MARK: 网点  ///车位费    仅支持0-5000正整数，默认值0，当填0时前台展示“未知”，单位，“元/月”
        else if jointModel.type == .OwnerBuildingJointEditTypeParkingCoast {
            
            buildingModel?.buildingMsg?.parkingSpaceRent = textField.text
            guard let blockk = self.endEditingMessageCell else {
                return
            }
            blockk(buildingModel ?? FangYuanBuildingEditModel())
        }
        
        
        
        //MARK: 办公室
        //MARK: 办公室 ///最短租期 必填，1-60正整数，单位 月
        if officeModel.type == .OwnerBuildingOfficeTypeMinRentalPeriod {
            FYModel?.houseMsg?.minimumLease = textField.text
            guard let blockk = self.endEditingFYMessageCell else {
                return
            }
            blockk(FYModel ?? FangYuanHouseEditModel())
        }
        
        
        
        
        //MARK: 独立办公室
        //MARK: 独立办公室   ///工位数  工位数，支持填写1-100的正整数
        if jointIndepentOfficeModel.type == .OwnerBuildingJointOfficeTypeSeats {
            FYModel?.houseMsg?.seats = textField.text
            guard let blockk = self.endEditingFYMessageCell else {
                return
            }
            blockk(FYModel ?? FangYuanHouseEditModel())
        }
        //MARK: 独立办公室   ///最短租期 最短租期，必填，数字，单位月，支持输入0-60正整数
        else if jointIndepentOfficeModel.type == .OwnerBuildingJointOfficeTypeMinRentalPeriod {
            FYModel?.houseMsg?.minimumLease = textField.text
            guard let blockk = self.endEditingFYMessageCell else {
                return
            }
            blockk(FYModel ?? FangYuanHouseEditModel())
        }
        //MARK: 独立办公室       ///租金
        else if jointIndepentOfficeModel.type == .OwnerBuildingJointOfficeTypePrice {
            FYModel?.houseMsg?.monthPrice = textField.text
            guard let blockk = self.endEditingFYMessageCell else {
                return
            }
            blockk(FYModel ?? FangYuanHouseEditModel())
        }
        
        
        
        //MARK: 开放工位
        //MARK: 开放工位    ///工位数  工位数，数字，支持输入1-200正整数，单位 个
        if jointOpenStationModel.type == .OwnerBuildingJointOpenStationTypeSeats {
            FYModel?.houseMsg?.seats = textField.text
            guard let blockk = self.endEditingFYMessageCell else {
                return
            }
            blockk(FYModel ?? FangYuanHouseEditModel())
        }
        //MARK: 开放工位    ///最短租期 最短租期，数字，必填，单位月，支持输入0-60正整数
        else if jointOpenStationModel.type == .OwnerBuildingJointOpenStationTypeMinRentalPeriod {
            FYModel?.houseMsg?.minimumLease = textField.text
            guard let blockk = self.endEditingFYMessageCell else {
                return
            }
            blockk(FYModel ?? FangYuanHouseEditModel())
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


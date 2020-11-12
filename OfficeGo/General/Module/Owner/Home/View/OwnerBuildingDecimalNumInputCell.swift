//
//  OwnerBuildingDecimalNumInputCell.swift
//  OfficeGo
//
//  Created by Mac pro on 2020/10/12.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class OwnerBuildingDecimalNumInputCell: BaseEditCell {
    
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
        editLabel.keyboardType = .decimalPad
        editLabel.delegate = self
        editLabel.addTarget(self, action: #selector(valueDidChange), for: .editingChanged)
    }
    
    @objc func valueDidChange() {
        
        //let textNum = editLabel.text?.count
        
        //MARK: 楼盘
        //MARK: 楼盘      ///建筑面积 只支持0.1-1000正数数字，保留1位小数，单位“万 M²
        if model.type == .OwnerBuildingEditTypeArea {
            editLabel.text = SSTool.getTextFromTF(tf: editLabel, maxLength: 6, maxNum: 1000, decimalNum: 1, toast: "仅支持0.1-1000正整数，保留1位小数")
            
        }
        //MARK: 楼盘      ///净高   必填，仅支持1-8之间正数，保留1位小数，单位 米；
        else if model.type == .OwnerBuildingEditTypeClearHeight {
            editLabel.text = SSTool.getTextFromTF(tf: editLabel, maxLength: 3, maxNum: 8, decimalNum: 1, toast: "仅支持1-8之间正数，保留1位小数")

        }
        //MARK: 楼盘      ///层高   选填，仅支持1-8之间正数，保留1位小数，单位 米
        else if model.type == .OwnerBuildingEditTypeFloorHeight {
            editLabel.text = SSTool.getTextFromTF(tf: editLabel, maxLength: 3, maxNum: 8, decimalNum: 1, toast: "仅支持1-8之间正数，保留1位小数")

        }
        //MARK: 楼盘      ///物业费  必填，数字，0-100之间正数，保留1位小数，单位 “元/㎡/月
        else if model.type == .OwnerBuildingEditTypePropertyCoast {
            editLabel.text = SSTool.getTextFromTF(tf: editLabel, maxLength: 5, maxNum: 100, decimalNum: 1, toast: "仅支持0-100之间正数，保留1位小数")

        }
        
        
        
        //MARK: 网点
        //MARK: 网点盘      ///净高   必填，仅支持1-8之间正数，保留1位小数，单位 米；
        if jointModel.type == .OwnerBuildingJointEditTypeClearHeight {
            editLabel.text = SSTool.getTextFromTF(tf: editLabel, maxLength: 3, maxNum: 8, decimalNum: 1, toast: "仅支持1-8之间正数，保留1位小数")

        }
        
        
        
        //MARK: 办公室
        //MARK: 办公室     ///建筑面积 - 必填，只支持10-100000正数数字，保留2位小数，单位 M²
        if officeModel.type == .OwnerBuildingOfficeTypeArea {
            editLabel.text = SSTool.getTextFromTF(tf: editLabel, maxLength: 9, maxNum: 100000, decimalNum: 2, toast: "仅支持10-100000之间正数，保留2位小数")

        }
        //MARK: 办公室     ///租金 单价 - 0.1-50之间正数，保留2位小数点，单位“元”；
        else if officeModel.type == .OwnerBuildingOfficeTypePrice {
            
            editLabel.text = SSTool.getTextFromTF(tf: editLabel, maxLength: 5, maxNum: 50, decimalNum: 2, toast: "仅支持0.1-50之间正数，保留2位小数点")
            
        }
        //MARK: 办公室     ///净高   必填，仅支持1-8之间正数，保留1位小数，单位 米；
        else if officeModel.type == .OwnerBuildingOfficeTypeClearHeight {
            editLabel.text = SSTool.getTextFromTF(tf: editLabel, maxLength: 3, maxNum: 8, decimalNum: 1, toast: "仅支持1-8之间正数，保留1位小数")

        }
        //MARK: 办公室     选填，仅支持1-8之间正数，保留1位小数，单位 米
        else if officeModel.type == .OwnerBuildingOfficeTypeFloorHeight {
            editLabel.text = SSTool.getTextFromTF(tf: editLabel, maxLength: 3, maxNum: 8, decimalNum: 1, toast: "仅支持1-8之间正数，保留1位小数")

        }
        //MARK: 办公室     ///物业费 必填，可修改，默认获取楼盘物业费;     物业金额根据房源面积计算，计算公式=物业费*房源面积，0-100000，保留1位小数，单位 元/月
        else if officeModel.type == .OwnerBuildingOfficeTypePropertyCoast {
            editLabel.text = SSTool.getTextFromTF(tf: editLabel, maxLength: 8, maxNum: 100000, decimalNum: 1, toast: "仅支持0-100000之间正数，保留1位小数")

        }
        
               
        
        //MARK: 独立办公室
        //MARK: 独立办公室       ///面积，非必填，支持输入1-10000正数，支持保留1位小数
        if jointIndepentOfficeModel.type == .OwnerBuildingJointOfficeTypeArea {
            editLabel.text = SSTool.getTextFromTF(tf: editLabel, maxLength: 7, maxNum: 10000, decimalNum: 1, toast: "仅支持1-10000之间正数，保留1位小数")

        }
        //MARK: 独立办公室       ///净高   必填，仅支持1-8之间正数，保留1位小数，单位 米；
        else if jointIndepentOfficeModel.type == .OwnerBuildingJointOfficeTypeClearHeight {
            
            editLabel.text = SSTool.getTextFromTF(tf: editLabel, maxLength: 3, maxNum: 8, decimalNum: 1, toast: "仅支持1-8之间正数，保留1位小数")
        }
        
        
        //MARK: 开放工位
        //MARK: 开放工位        ///租金   支持输入100-1w之间的正数，保留1位小数
        //MARK: 开放工位        ///净高   必填，仅支持1-8之间正数，保留1位小数，单位 米；
        
        if jointOpenStationModel.type == .OwnerBuildingJointOpenStationTypePrice {
            editLabel.text = SSTool.getTextFromTF(tf: editLabel, maxLength: 7, maxNum: 10000, decimalNum: 1, toast: "仅支持输入100-1w之间的正数，保留1位小数")
        }else if jointOpenStationModel.type == .OwnerBuildingJointOpenStationTypeClearHeight {
            editLabel.text = SSTool.getTextFromTF(tf: editLabel, maxLength: 3, maxNum: 8, decimalNum: 1, toast: "仅支持1-8之间正数，保留1位小数")
        }
        
    }
    
//    func getTextFromTF(tf: UITextField, maxLength: Int, maxNum: Float, decimalNum: Int, toast: String) {
//        
//        let textNum = tf.text?.count
//
//        //截取
//        if textNum! > maxLength {
//            let index = editLabel.text?.index((editLabel.text?.startIndex)!, offsetBy: maxLength)
//            editLabel.text = editLabel.text?.substring(to: index!)
//        }
//        if let num = Float(editLabel.text ?? "0") {
//            if num > maxNum {
//                editLabel.text?.removeLast(1)
//                AppUtilities.makeToast(toast)
//            }
//            let arr = editLabel.text?.split{$0 == "."}.map(String.init)
//            if arr?.count == 2 {
//                if arr?[1].count ?? 0 > decimalNum {
//                    editLabel.text?.removeLast(1)
//                    AppUtilities.makeToast(toast)
//                }
//            }
//        }else {
//            if textNum ?? 0 > 0 {
//                
//                editLabel.text?.removeLast(1)
//                AppUtilities.makeToast(toast)
//            }
//        }
//    }
    
    ///楼盘模型
    var model: OwnerBuildingEditConfigureModel = OwnerBuildingEditConfigureModel(types: OwnerBuildingEditType.OwnerBuildingEditTypeBuildingTypew) {
        didSet {
            
            titleLabel.attributedText = model.getNameFormType(type: model.type ?? OwnerBuildingEditType.OwnerBuildingEditTypeBuildingTypew)
            //editLabel.placeholder = model.getPalaceHolderFormType(type: model.type ?? OwnerBuildingEditType.OwnerBuildingEditTypeBuildingTypew)
            unitLabel.text = model.getPalaceHolderFormType(type: model.type ?? OwnerBuildingEditType.OwnerBuildingEditTypeBuildingTypew)
            
            detailIcon.isHidden = true
            lineView.isHidden = false
            editLabel.isUserInteractionEnabled = true
            
            ///建筑面积
            if model.type == .OwnerBuildingEditTypeArea {
                editLabel.text = buildingModel?.buildingMsg?.constructionArea
            }
                ///净高
            else if model.type == .OwnerBuildingEditTypeClearHeight {
                editLabel.text = buildingModel?.buildingMsg?.clearHeight
            }
                ///层高
            else if model.type == .OwnerBuildingEditTypeFloorHeight {
                editLabel.text = buildingModel?.buildingMsg?.storeyHeight
            }
                ///物业费
            else if model.type == .OwnerBuildingEditTypePropertyCoast {
                editLabel.text = buildingModel?.buildingMsg?.propertyCosts
            }
        }
    }
    
    ///网点
    var jointModel: OwnerBuildingJointEditConfigureModel = OwnerBuildingJointEditConfigureModel(types: OwnerBuildingJointEditType.OwnerBuildingJointEditTypeFeature) {
        didSet {
            
            titleLabel.attributedText = jointModel.getNameFormType(type: jointModel.type ?? OwnerBuildingJointEditType.OwnerBuildingJointEditTypeClearHeight)
            //editLabel.placeholder = jointModel.getPalaceHolderFormType(type: jointModel.type ?? OwnerBuildingJointEditType.OwnerBuildingJointEditTypeClearHeight)
            unitLabel.text = jointModel.getPalaceHolderFormType(type: jointModel.type ?? OwnerBuildingJointEditType.OwnerBuildingJointEditTypeClearHeight)

            detailIcon.isHidden = true
            lineView.isHidden = false
            editLabel.isUserInteractionEnabled = true
            
            ///净高
            if jointModel.type == .OwnerBuildingJointEditTypeClearHeight {
                editLabel.text = buildingModel?.buildingMsg?.clearHeight
            }
        }
    }
    
    ///办公室
    ///数字 - 一位小数点文本输入cell
    ///建筑面积 - 两位
    ///租金
    ///净高
    ///层高
    ///物业费
    ///租金总价 - 两位
    var officeModel: OwnerBuildingOfficeConfigureModel = OwnerBuildingOfficeConfigureModel(types: OwnerBuildingOfficeType.OwnerBuildingOfficeTypeFeature) {
        didSet {
            
            titleLabel.attributedText = officeModel.getNameFormType(type: officeModel.type ?? OwnerBuildingOfficeType.OwnerBuildingOfficeTypeArea)
            //editLabel.placeholder = officeModel.getPalaceHolderFormType(type: officeModel.type ?? OwnerBuildingOfficeType.OwnerBuildingOfficeTypeArea)
            unitLabel.text = officeModel.getPalaceHolderFormType(type: officeModel.type ?? OwnerBuildingOfficeType.OwnerBuildingOfficeTypeArea)

            detailIcon.isHidden = true
            lineView.isHidden = false
            editLabel.isUserInteractionEnabled = true
            
            if officeModel.type == .OwnerBuildingOfficeTypeArea {
                editLabel.text = FYModel?.houseMsg?.area
            }else if officeModel.type == .OwnerBuildingOfficeTypePrice {
                editLabel.text = FYModel?.houseMsg?.dayPrice
            }else if officeModel.type == .OwnerBuildingOfficeTypeClearHeight {
                editLabel.text = FYModel?.houseMsg?.clearHeight
            }else if officeModel.type == .OwnerBuildingOfficeTypeFloorHeight {
                editLabel.text = FYModel?.houseMsg?.storeyHeight
            }else if officeModel.type == .OwnerBuildingOfficeTypePropertyCoast {
                editLabel.text = FYModel?.houseMsg?.propertyHouseCosts
            }
        }
    }
    
    ///独立办公室
    ///建筑面积 - 一位
    ///净高
    var jointIndepentOfficeModel: OwnerBuildingJointOfficeConfigureModel = OwnerBuildingJointOfficeConfigureModel(types: OwnerBuildingJointOfficeType.OwnerBuildingJointOfficeTypeRentFreePeriod) {
        didSet {
            
            titleLabel.attributedText = jointIndepentOfficeModel.getNameFormType(type: jointIndepentOfficeModel.type ?? OwnerBuildingJointOfficeType.OwnerBuildingJointOfficeTypeArea)
            //editLabel.placeholder = jointIndepentOfficeModel.getPalaceHolderFormType(type: jointIndepentOfficeModel.type ?? OwnerBuildingJointOfficeType.OwnerBuildingJointOfficeTypeArea)
            unitLabel.text = jointIndepentOfficeModel.getPalaceHolderFormType(type: jointIndepentOfficeModel.type ?? OwnerBuildingJointOfficeType.OwnerBuildingJointOfficeTypeArea)

            detailIcon.isHidden = true
            lineView.isHidden = false
            editLabel.isUserInteractionEnabled = true
            
            if jointIndepentOfficeModel.type == .OwnerBuildingJointOfficeTypeArea {
                editLabel.text = FYModel?.houseMsg?.area
            }else if jointIndepentOfficeModel.type == .OwnerBuildingJointOfficeTypeClearHeight {
                editLabel.text = FYModel?.houseMsg?.clearHeight
            }
        }
    }
    
    ///开放工位
    var jointOpenStationModel: OwnerBuildingJointOpenStationConfigureModel = OwnerBuildingJointOpenStationConfigureModel(types: OwnerBuildingJointOpenStationType.OwnerBuildingJointOpenStationTypeRentFreePeriod) {
        didSet {
            
            
            titleLabel.attributedText = jointOpenStationModel.getNameFormType(type: jointOpenStationModel.type ?? OwnerBuildingJointOpenStationType.OwnerBuildingJointOpenStationTypePrice)
            //editLabel.placeholder = jointOpenStationModel.getPalaceHolderFormType(type: jointOpenStationModel.type ?? OwnerBuildingJointOpenStationType.OwnerBuildingJointOpenStationTypePrice)
            unitLabel.text = jointOpenStationModel.getPalaceHolderFormType(type: jointOpenStationModel.type ?? OwnerBuildingJointOpenStationType.OwnerBuildingJointOpenStationTypePrice)

            detailIcon.isHidden = true
            lineView.isHidden = false
            editLabel.isUserInteractionEnabled = true
            
            ///租金
            if jointOpenStationModel.type == .OwnerBuildingJointOpenStationTypePrice {
                editLabel.text = FYModel?.houseMsg?.dayPrice
            }else if jointOpenStationModel.type == .OwnerBuildingJointOpenStationTypeClearHeight {
                editLabel.text = FYModel?.houseMsg?.clearHeight
            }

        }
    }
    
}

extension OwnerBuildingDecimalNumInputCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {

        let textNum = textField.text?.count

        //MARK: 楼盘
        //MARK: 楼盘      ///建筑面积
        if model.type == .OwnerBuildingEditTypeArea {
            
            //有小数点
            if textField.text?.contains(".") ?? false {
                
            }else {
                if textNum! > 2 {
                    if textField.text?.hasPrefix("0") == true {
                        textField.text?.removeFirst()
                    }
                }
            }

            buildingModel?.buildingMsg?.constructionArea = textField.text
            guard let blockk = self.endEditingMessageCell else {
                return
            }
            blockk(buildingModel ?? FangYuanBuildingEditModel())
        }
        //MARK: 楼盘      ///净高
        else if model.type == .OwnerBuildingEditTypeClearHeight {
            //有小数点
            if textField.text?.contains(".") ?? false {
                
            }else {
                if textNum! > 2 {
                    if textField.text?.hasPrefix("0") == true {
                        textField.text?.removeFirst()
                    }
                }
            }
            buildingModel?.buildingMsg?.clearHeight = textField.text
            guard let blockk = self.endEditingMessageCell else {
                return
            }
            blockk(buildingModel ?? FangYuanBuildingEditModel())
        }
        //MARK: 楼盘      ///层高
        else if model.type == .OwnerBuildingEditTypeFloorHeight {
            //有小数点
            if textField.text?.contains(".") ?? false {
                
            }else {
                if textNum! > 2 {
                    if textField.text?.hasPrefix("0") == true {
                        textField.text?.removeFirst()
                    }
                }
            }
            buildingModel?.buildingMsg?.storeyHeight = textField.text
            guard let blockk = self.endEditingMessageCell else {
                return
            }
            blockk(buildingModel ?? FangYuanBuildingEditModel())
        }
        //MARK: 楼盘      ///物业费
        else if model.type == .OwnerBuildingEditTypePropertyCoast {
            //有小数点
            if textField.text?.contains(".") ?? false {
                
            }else {
                if textNum! > 2 {
                    if textField.text?.hasPrefix("0") == true {
                        textField.text?.removeFirst()
                    }
                }
            }
            buildingModel?.buildingMsg?.propertyCosts = textField.text
            guard let blockk = self.endEditingMessageCell else {
                return
            }
            blockk(buildingModel ?? FangYuanBuildingEditModel())
        }
        
        
        
        //MARK: 网点
        //MARK: 网点      ///净高
        if jointModel.type == .OwnerBuildingJointEditTypeClearHeight {
            //有小数点
            if textField.text?.contains(".") ?? false {
                
            }else {
                if textNum! > 2 {
                    if textField.text?.hasPrefix("0") == true {
                        textField.text?.removeFirst()
                    }
                }
            }
            buildingModel?.buildingMsg?.clearHeight = textField.text
            guard let blockk = self.endEditingMessageCell else {
                return
            }
            blockk(buildingModel ?? FangYuanBuildingEditModel())
        }
        
        
        
        //MARK: 办公室
        //MARK: 办公室     ///建筑面积 - 必填，只支持10-100000正数数字，保留2位小数，单位 M²
        if officeModel.type == .OwnerBuildingOfficeTypeArea {
            ///如果面积存在，并且和输入的内容一致，是不需要计算工位数的
            if let areaOffice = FYModel?.houseMsg?.area {
                if textField.text != areaOffice {
                    let min = (Float(textField.text ?? "0") ?? 1) / minSeatsFM_5
                    let max = (Float(textField.text ?? "0") ?? 1) / maxSeatsFM_3
                    FYModel?.houseMsg?.minSeatsOffice = String(format: "%.0f", min)
                    FYModel?.houseMsg?.maxSeatsOffice = String(format: "%.0f", max)
                }
            }else {
                let min = (Float(textField.text ?? "0") ?? 1) / minSeatsFM_5
                let max = (Float(textField.text ?? "0") ?? 1) / maxSeatsFM_3
                FYModel?.houseMsg?.minSeatsOffice = String(format: "%.0f", min)
                FYModel?.houseMsg?.maxSeatsOffice = String(format: "%.0f", max)
            }
            FYModel?.houseMsg?.area = textField.text
            guard let blockk = self.endEditingFYMessageCell else {
                return
            }
            blockk(FYModel ?? FangYuanHouseEditModel())
            
        }
        //MARK: 办公室     ///租金 单价 - 0.1-50之间正数，保留2位小数点，单位“元”；
        else if officeModel.type == .OwnerBuildingOfficeTypePrice {
            //有小数点
            if textField.text?.contains(".") ?? false {
                
            }else {
                if textNum! > 2 {
                    if textField.text?.hasPrefix("0") == true {
                        textField.text?.removeFirst()
                    }
                }
            }
            FYModel?.houseMsg?.dayPrice = textField.text
            guard let blockk = self.endEditingFYMessageCell else {
                return
            }
            blockk(FYModel ?? FangYuanHouseEditModel())
        }
        //MARK: 办公室     ///净高
        else if officeModel.type == .OwnerBuildingOfficeTypeClearHeight {
            //有小数点
            if textField.text?.contains(".") ?? false {
                
            }else {
                if textNum! > 2 {
                    if textField.text?.hasPrefix("0") == true {
                        textField.text?.removeFirst()
                    }
                }
            }
            FYModel?.houseMsg?.clearHeight = textField.text
            guard let blockk = self.endEditingFYMessageCell else {
                return
            }
            blockk(FYModel ?? FangYuanHouseEditModel())
        }
        //MARK: 办公室     ///层高
        else if officeModel.type == .OwnerBuildingOfficeTypeFloorHeight {
            //有小数点
            if textField.text?.contains(".") ?? false {
                
            }else {
                if textNum! > 2 {
                    if textField.text?.hasPrefix("0") == true {
                        textField.text?.removeFirst()
                    }
                }
            }
            FYModel?.houseMsg?.storeyHeight = textField.text
            guard let blockk = self.endEditingFYMessageCell else {
                return
            }
            blockk(FYModel ?? FangYuanHouseEditModel())
        }
        //MARK: 办公室     ///物业费
        else if officeModel.type == .OwnerBuildingOfficeTypePropertyCoast {
            //有小数点
            if textField.text?.contains(".") ?? false {
                
            }else {
                if textNum! > 2 {
                    if textField.text?.hasPrefix("0") == true {
                        textField.text?.removeFirst()
                    }
                }
            }
            FYModel?.houseMsg?.propertyHouseCosts = textField.text
            guard let blockk = self.endEditingFYMessageCell else {
                return
            }
            blockk(FYModel ?? FangYuanHouseEditModel())
        }
               
        
        //MARK: 独立办公室
        //MARK: 独立办公室       ///建筑面积 - 一位
        if jointIndepentOfficeModel.type == .OwnerBuildingJointOfficeTypeArea {
            //有小数点
            if textField.text?.contains(".") ?? false {
                
            }else {
                if textNum! > 2 {
                    if textField.text?.hasPrefix("0") == true {
                        textField.text?.removeFirst()
                    }
                }
            }
            FYModel?.houseMsg?.area = textField.text
            guard let blockk = self.endEditingFYMessageCell else {
                return
            }
            blockk(FYModel ?? FangYuanHouseEditModel())
        }
        //MARK: 独立办公室       ///净高
        else if jointIndepentOfficeModel.type == .OwnerBuildingJointOfficeTypeClearHeight {
            //有小数点
            if textField.text?.contains(".") ?? false {
                
            }else {
                if textNum! > 2 {
                    if textField.text?.hasPrefix("0") == true {
                        textField.text?.removeFirst()
                    }
                }
            }
            FYModel?.houseMsg?.clearHeight = textField.text
            guard let blockk = self.endEditingFYMessageCell else {
                return
            }
            blockk(FYModel ?? FangYuanHouseEditModel())
        }
        
        
        //MARK: 开放工位
        //MARK: 开放工位        ///租金
        if jointOpenStationModel.type == .OwnerBuildingJointOpenStationTypePrice {
            //有小数点
            if textField.text?.contains(".") ?? false {
                
            }else {
                if textNum! > 2 {
                    if textField.text?.hasPrefix("0") == true {
                        textField.text?.removeFirst()
                    }
                }
            }
            FYModel?.houseMsg?.dayPrice = textField.text
            guard let blockk = self.endEditingFYMessageCell else {
                return
            }
            blockk(FYModel ?? FangYuanHouseEditModel())
        }else if jointOpenStationModel.type == .OwnerBuildingJointOpenStationTypeClearHeight {
            //有小数点
            if textField.text?.contains(".") ?? false {
                
            }else {
                if textNum! > 2 {
                    if textField.text?.hasPrefix("0") == true {
                        textField.text?.removeFirst()
                    }
                }
            }
            FYModel?.houseMsg?.clearHeight = textField.text
            guard let blockk = self.endEditingFYMessageCell else {
                return
            }
            blockk(FYModel ?? FangYuanHouseEditModel())
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
}


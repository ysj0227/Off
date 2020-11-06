//
//  OwnerBuildingBorderInputCell.swift
//  OfficeGo
//
//  Created by Mac pro on 2020/9/30.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class OwnerBuildingBorderInputCell: BaseTableViewCell {
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_15
        view.setContentCompressionResistancePriority(.required, for: .horizontal)
        view.textColor = kAppColor_333333
        return view
    }()
    
    
    lazy var editLabel: UITextField = {
        let view = UITextField()
        view.textAlignment = .center
        view.font = FONT_15
        view.textColor = kAppColor_333333
        view.clearButtonMode = .whileEditing
        view.keyboardType = .numberPad
        view.clipsToBounds = true
        view.layer.borderColor = kAppColor_line_EEEEEE.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = button_cordious_2
        return view
    }()
    
    lazy var unitLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_13
        view.textColor = kAppColor_btnGray_BEBEBE
        return view
    }()
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = kAppColor_line_EEEEEE
        return view
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    class func rowHeight() -> CGFloat {
        return cell_height_58
    }
    
    var buildingModel: FangYuanBuildingEditModel?
    
        ///楼盘
    var endEditingMessageCell:((FangYuanBuildingEditModel) -> Void)?
    
    func setupViews() {

        self.backgroundColor = kAppWhiteColor
  
        addSubview(titleLabel)
        addSubview(editLabel)
        addSubview(lineView)
        addSubview(unitLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(left_pending_space_17)
            make.top.bottom.equalToSuperview()
        }
        
        editLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(titleLabel.snp.trailing)
            make.size.equalTo(CGSize(width: 73, height: 36))
            make.centerY.equalTo(titleLabel)
        }
        unitLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(editLabel.snp.trailing).offset(13)
            make.top.bottom.equalTo(titleLabel)
        }
        
        lineView.snp.makeConstraints { (make) in
            make.leading.equalTo(left_pending_space_17)
            make.trailing.equalTo(-left_pending_space_17)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        
        editLabel.delegate = self
        editLabel.addTarget(self, action: #selector(valueDidChange), for: .editingChanged)
    }
    
    
    @objc func valueDidChange() {
        let textNum = editLabel.text?.count
        
        //MARK: 楼盘
        //MARK: 楼盘  ///电梯数 - 客梯 必填，客梯 货梯分开填，仅支持0-20数字；
        if model.type == .OwnerBuildingEditTypePassengerNum {
            //截取
            if textNum! > 2 {
                let index = editLabel.text?.index((editLabel.text?.startIndex)!, offsetBy: 2)
                editLabel.text = editLabel.text?.substring(to: index!)
            }
            if let num = Int(editLabel.text ?? "0") {
                if num > 20 {
                    editLabel.text?.removeLast(1)
                    AppUtilities.makeToast("仅支持0-20正整数")
                }
            }
        }
        //MARK: 楼盘  ///电梯数 - 货梯 必填，客梯 货梯分开填，仅支持0-20数字；
        else if model.type == .OwnerBuildingEditTypeFloorCargoNum {
            //截取
            if textNum! > 2 {
                let index = editLabel.text?.index((editLabel.text?.startIndex)!, offsetBy: 2)
                editLabel.text = editLabel.text?.substring(to: index!)
            }
            if let num = Int(editLabel.text ?? "0") {
                if num > 20 {
                    editLabel.text?.removeLast(1)
                    AppUtilities.makeToast("仅支持0-20正整数")
                }
            }
        }
        
        
        //MARK: 网点
        //MARK: 网点  ///电梯数 - 客梯 必填，客梯 货梯分开填，仅支持0-20数字；
        if jointModel.type == .OwnerBuildingJointEditTypePassengerNum {
            //截取
            if textNum! > 2 {
                let index = editLabel.text?.index((editLabel.text?.startIndex)!, offsetBy: 2)
                editLabel.text = editLabel.text?.substring(to: index!)
            }
            if let num = Int(editLabel.text ?? "0") {
                if num > 20 {
                    editLabel.text?.removeLast(1)
                    AppUtilities.makeToast("仅支持0-20正整数")
                }
            }
        }
        //MARK: 网点  ///电梯数 - 货梯 必填，客梯 货梯分开填，仅支持0-20数字；
        else if jointModel.type == .OwnerBuildingJointEditTypeFloorCargoNum {
            //截取
            if textNum! > 2 {
                let index = editLabel.text?.index((editLabel.text?.startIndex)!, offsetBy: 2)
                editLabel.text = editLabel.text?.substring(to: index!)
            }
            if let num = Int(editLabel.text ?? "0") {
                if num > 20 {
                    editLabel.text?.removeLast(1)
                    AppUtilities.makeToast("仅支持0-20正整数")
                }
            }
        }
    }
    
    var model: OwnerBuildingEditConfigureModel = OwnerBuildingEditConfigureModel(types: OwnerBuildingEditType.OwnerBuildingEditTypeBuildingTypew) {
        didSet {
            
            titleLabel.attributedText = model.getNameFormType(type: model.type ?? OwnerBuildingEditType.OwnerBuildingEditTypeBuildingTypew)
            unitLabel.text = model.getPalaceHolderFormType(type: model.type ?? OwnerBuildingEditType.OwnerBuildingEditTypeBuildingTypew)
            lineView.isHidden = false
            editLabel.isUserInteractionEnabled = true
            
            ///电梯数 - 客梯
            if model.type == .OwnerBuildingEditTypePassengerNum {
                editLabel.text = buildingModel?.buildingMsg?.passengerLift
            }
                ///电梯数 - 货梯
            else if model.type == .OwnerBuildingEditTypeFloorCargoNum {
                editLabel.text = buildingModel?.buildingMsg?.cargoLift
            }
        }
    }
    
    var jointModel: OwnerBuildingJointEditConfigureModel = OwnerBuildingJointEditConfigureModel(types: OwnerBuildingJointEditType.OwnerBuildingJointEditTypePassengerNum) {
        didSet {
            
            titleLabel.attributedText = jointModel.getNameFormType(type: jointModel.type ?? OwnerBuildingJointEditType.OwnerBuildingJointEditTypePassengerNum)
            unitLabel.text = jointModel.getPalaceHolderFormType(type: jointModel.type ?? OwnerBuildingJointEditType.OwnerBuildingJointEditTypePassengerNum)
            lineView.isHidden = false
            editLabel.isUserInteractionEnabled = true
            
            ///电梯数 - 客梯
            if jointModel.type == .OwnerBuildingJointEditTypePassengerNum {
                editLabel.text = buildingModel?.buildingMsg?.passengerLift
            }
                ///电梯数 - 货梯
            else if jointModel.type == .OwnerBuildingJointEditTypeFloorCargoNum {
                editLabel.text = buildingModel?.buildingMsg?.cargoLift
            }
            
        }
    }
}

extension OwnerBuildingBorderInputCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        //MARK: 楼盘
        //MARK: 楼盘  ///电梯数 - 客梯 必填，客梯 货梯分开填，仅支持0-20数字；
        if model.type == .OwnerBuildingEditTypePassengerNum {
            buildingModel?.buildingMsg?.passengerLift = textField.text
            guard let blockk = self.endEditingMessageCell else {
                return
            }
            blockk(buildingModel ?? FangYuanBuildingEditModel())
        }
        //MARK: 楼盘  ///电梯数 - 货梯 必填，客梯 货梯分开填，仅支持0-20数字；
        else if model.type == .OwnerBuildingEditTypeFloorCargoNum {
            buildingModel?.buildingMsg?.cargoLift = textField.text
            guard let blockk = self.endEditingMessageCell else {
                return
            }
            blockk(buildingModel ?? FangYuanBuildingEditModel())
        }
        
        
        //MARK: 网点
        //MARK: 网点  ///电梯数 - 客梯 必填，客梯 货梯分开填，仅支持0-20数字；
        if jointModel.type == .OwnerBuildingJointEditTypePassengerNum {
            buildingModel?.buildingMsg?.passengerLift = textField.text
            guard let blockk = self.endEditingMessageCell else {
                return
            }
            blockk(buildingModel ?? FangYuanBuildingEditModel())
        }
        //MARK: 网点  ///电梯数 - 货梯 必填，客梯 货梯分开填，仅支持0-20数字；
        else if jointModel.type == .OwnerBuildingJointEditTypeFloorCargoNum {
            buildingModel?.buildingMsg?.cargoLift = textField.text
            guard let blockk = self.endEditingMessageCell else {
                return
            }
            blockk(buildingModel ?? FangYuanBuildingEditModel())
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
}



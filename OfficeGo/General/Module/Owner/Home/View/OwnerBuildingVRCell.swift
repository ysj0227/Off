//
//  OwnerBuildingVRCell.swift
//  OfficeGo
//
//  Created by Mac pro on 2020/10/10.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class OwnerBuildingVRCell: BaseTableViewCell {
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_15
        view.setContentCompressionResistancePriority(.required, for: .horizontal)
        view.textColor = kAppColor_333333
        return view
    }()
    
    lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = kAppWhiteColor
        view.clipsToBounds = true
        view.layer.borderColor = kAppColor_line_EEEEEE.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = button_cordious_2
        return view
    }()
    
    lazy var editLabel: UITextField = {
        let view = UITextField()
        view.textAlignment = .left
        view.font = FONT_15
        view.textColor = kAppColor_333333
        view.clearButtonMode = .whileEditing
        view.keyboardType = .default
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
        return cell_height_58 * 2
    }
        
    var buildingModel: FangYuanBuildingEditModel?
    
    var FYModel: FangYuanHouseEditModel?

    ///楼盘
    var endEditingMessageCell:((FangYuanBuildingEditModel) -> Void)?
    
    ///房源
    var endEditingFYMessageCell:((FangYuanHouseEditModel) -> Void)?
    
    
    func setupViews() {

        self.backgroundColor = kAppWhiteColor
  
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(bottomView)
        self.contentView.addSubview(editLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(left_pending_space_17)
            make.top.equalTo(10)
            make.height.equalTo(cell_height_58)
        }
        
        bottomView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(left_pending_space_17)
            make.top.equalTo(titleLabel.snp.bottom)
            make.height.equalTo(45)
        }
        
        editLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(bottomView).offset(8)
            make.trailing.equalTo(bottomView)
            make.top.equalTo(titleLabel.snp.bottom)
            make.height.equalTo(45)
        }
        
        editLabel.delegate = self

    }

        
    var model: OwnerBuildingEditConfigureModel = OwnerBuildingEditConfigureModel(types: OwnerBuildingEditType.OwnerBuildingEditTypeBuildingImage) {
        didSet {
            
            titleLabel.attributedText = model.getNameFormType(type: model.type ?? OwnerBuildingEditType.OwnerBuildingEditTypeBuildingVR)
            editLabel.placeholder = model.getPalaceHolderFormType(type: model.type ?? OwnerBuildingEditType.OwnerBuildingEditTypeBuildingVR)
            
            editLabel.text = buildingModel?.vrUrl
        }
    }
    var jointModel: OwnerBuildingJointEditConfigureModel = OwnerBuildingJointEditConfigureModel(types: OwnerBuildingJointEditType.OwnerBuildingJointEditTypeBuildingImage) {
        didSet {
            
            titleLabel.attributedText = jointModel.getNameFormType(type: jointModel.type ?? OwnerBuildingJointEditType.OwnerBuildingJointEditTypeBuildingVR)
            editLabel.placeholder = jointModel.getPalaceHolderFormType(type: jointModel.type ?? OwnerBuildingJointEditType.OwnerBuildingJointEditTypeBuildingVR)
            
            editLabel.text = buildingModel?.vrUrl
        }
    }
    
    ///办公室
    var officeModel: OwnerBuildingOfficeConfigureModel = OwnerBuildingOfficeConfigureModel(types: OwnerBuildingOfficeType.OwnerBuildingOfficeTypeBuildingImage) {
        didSet {
            
            titleLabel.attributedText = officeModel.getNameFormType(type: officeModel.type ?? OwnerBuildingOfficeType.OwnerBuildingOfficeTypeBuildingVR)
            editLabel.placeholder = officeModel.getPalaceHolderFormType(type: officeModel.type ?? OwnerBuildingOfficeType.OwnerBuildingOfficeTypeBuildingVR)
            
            editLabel.text = FYModel?.vrUrl
        }
    }
    
    ///独立办公室
    var jointIndepentOfficeModel: OwnerBuildingJointOfficeConfigureModel = OwnerBuildingJointOfficeConfigureModel(types: OwnerBuildingJointOfficeType.OwnerBuildingJointOfficeTypeBuildingImage) {
        didSet {
            
            
            titleLabel.attributedText = jointIndepentOfficeModel.getNameFormType(type: jointIndepentOfficeModel.type ?? OwnerBuildingJointOfficeType.OwnerBuildingJointOfficeTypeBuildingVR)
            editLabel.placeholder = jointIndepentOfficeModel.getPalaceHolderFormType(type: jointIndepentOfficeModel.type ?? OwnerBuildingJointOfficeType.OwnerBuildingJointOfficeTypeBuildingVR)
           
            editLabel.text = FYModel?.vrUrl
    
        }
    }
    
    ///开放工位
    var jointOpenStationModel: OwnerBuildingJointOpenStationConfigureModel = OwnerBuildingJointOpenStationConfigureModel(types: OwnerBuildingJointOpenStationType.OwnerBuildingJointOpenStationTypeBuildingImage) {
        didSet {
            
            
            titleLabel.attributedText = jointOpenStationModel.getNameFormType(type: jointOpenStationModel.type ?? OwnerBuildingJointOpenStationType.OwnerBuildingJointOpenStationTypeRentFreePeriod)
            editLabel.placeholder = jointOpenStationModel.getPalaceHolderFormType(type: jointOpenStationModel.type ?? OwnerBuildingJointOpenStationType.OwnerBuildingJointOpenStationTypeRentFreePeriod)
            
            
        }
    }
}

extension OwnerBuildingVRCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {

        if textField.text?.hasPrefix("http") != true {
            AppUtilities.makeToast("输入的链接不符合规则，请重新输入")
            textField.text = nil
        }
        
        //MARK: 楼盘
        if model.type == .OwnerBuildingEditTypeBuildingVR {
            buildingModel?.vrUrl = textField.text
            guard let blockk = self.endEditingMessageCell else {
                return
            }
            blockk(buildingModel ?? FangYuanBuildingEditModel())
        }
        
        
        
        //MARK: 网点
        if jointModel.type == .OwnerBuildingJointEditTypeBuildingVR {
            buildingModel?.vrUrl = textField.text
            guard let blockk = self.endEditingMessageCell else {
                return
            }
            blockk(buildingModel ?? FangYuanBuildingEditModel())
        }
           
        
        
        //MARK: 办公室
        if officeModel.type == .OwnerBuildingOfficeTypeBuildingVR {
            FYModel?.vrUrl = textField.text
            guard let blockk = self.endEditingFYMessageCell else {
                return
            }
            blockk(FYModel ?? FangYuanHouseEditModel())
        }
        
        
        
        //MARK: 独立办公室
        if jointIndepentOfficeModel.type == .OwnerBuildingJointOfficeTypeBuildingVR {
            FYModel?.vrUrl = textField.text
            guard let blockk = self.endEditingFYMessageCell else {
                return
            }
            blockk(FYModel ?? FangYuanHouseEditModel())
        }
        
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
}


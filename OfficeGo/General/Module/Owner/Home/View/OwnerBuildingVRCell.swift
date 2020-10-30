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
    
    var FYModel: FangYuanFYEditDetailModel?

    ///楼盘
    var endEditingMessageCell:((FangYuanBuildingEditModel) -> Void)?
    
    ///房源
    var endEditingFYMessageCell:((FangYuanFYEditDetailModel) -> Void)?
    
    
    func setupViews() {

        self.backgroundColor = kAppWhiteColor
  
        addSubview(titleLabel)
        addSubview(bottomView)
        addSubview(editLabel)
        
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
        editLabel.addTarget(self, action: #selector(valueDidChange), for: .editingChanged)
    }
    
    
    @objc func valueDidChange() {
        let textNum = editLabel.text?.count
        ///vr
        if model.type == .OwnerBuildingEditTypeBuildingVR {
            
        }
    }
        
    var model: OwnerBuildingEditConfigureModel = OwnerBuildingEditConfigureModel(types: OwnerBuildingEditType.OwnerBuildingEditTypeBuildingImage) {
        didSet {
            
            titleLabel.attributedText = model.getNameFormType(type: model.type ?? OwnerBuildingEditType.OwnerBuildingEditTypeBuildingVR)
            editLabel.placeholder = model.getPalaceHolderFormType(type: model.type ?? OwnerBuildingEditType.OwnerBuildingEditTypeBuildingVR)
            
            if let vrr = buildingModel?.buildingLocalVRArr {
                if vrr.count > 0 {
                    editLabel.text = vrr[0].imgUrl
                }
            }
        }
    }
    var jointModel: OwnerBuildingJointEditConfigureModel = OwnerBuildingJointEditConfigureModel(types: OwnerBuildingJointEditType.OwnerBuildingJointEditTypeBuildingImage) {
        didSet {
            
            titleLabel.attributedText = jointModel.getNameFormType(type: jointModel.type ?? OwnerBuildingJointEditType.OwnerBuildingJointEditTypeBuildingVR)
            editLabel.placeholder = jointModel.getPalaceHolderFormType(type: jointModel.type ?? OwnerBuildingJointEditType.OwnerBuildingJointEditTypeBuildingVR)
            
            if let vrr = buildingModel?.buildingLocalVRArr {
                if vrr.count > 0 {
                    editLabel.text = vrr[0].imgUrl
                }
            }
        }
    }
    
    ///办公室
    var officeModel: OwnerBuildingOfficeConfigureModel = OwnerBuildingOfficeConfigureModel(types: OwnerBuildingOfficeType.OwnerBuildingOfficeTypeBuildingImage) {
        didSet {
            
            titleLabel.attributedText = officeModel.getNameFormType(type: officeModel.type ?? OwnerBuildingOfficeType.OwnerBuildingOfficeTypeMinRentalPeriod)
            editLabel.placeholder = officeModel.getPalaceHolderFormType(type: officeModel.type ?? OwnerBuildingOfficeType.OwnerBuildingOfficeTypeMinRentalPeriod)
            
            
            if let vrr = buildingModel?.buildingLocalVRArr {
                if vrr.count > 0 {
                    editLabel.text = vrr[0].imgUrl
                }
            }
        }
    }
    
    ///独立办公室
    var jointIndepentOfficeModel: OwnerBuildingJointOfficeConfigureModel = OwnerBuildingJointOfficeConfigureModel(types: OwnerBuildingJointOfficeType.OwnerBuildingJointOfficeTypeBuildingImage) {
        didSet {
            
            
            titleLabel.attributedText = jointIndepentOfficeModel.getNameFormType(type: jointIndepentOfficeModel.type ?? OwnerBuildingJointOfficeType.OwnerBuildingJointOfficeTypeRentFreePeriod)
            editLabel.placeholder = jointIndepentOfficeModel.getPalaceHolderFormType(type: jointIndepentOfficeModel.type ?? OwnerBuildingJointOfficeType.OwnerBuildingJointOfficeTypeRentFreePeriod)
           
            
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

        //MARK: 楼盘
        if model.type == .OwnerBuildingEditTypeBuildingVR {

            guard let blockk = self.endEditingMessageCell else {
                return
            }
            blockk(buildingModel ?? FangYuanBuildingEditModel())
        }
        
        
        
        //MARK: 网点
        if jointModel.type == .OwnerBuildingJointEditTypeBuildingVR {
            
            buildingModel?.buildingMsg?.conferenceNumber = textField.text
            guard let blockk = self.endEditingMessageCell else {
                return
            }
            blockk(buildingModel ?? FangYuanBuildingEditModel())
        }
           
        
        
        //MARK: 办公室
        if officeModel.type == .OwnerBuildingOfficeTypeBuildingVR {
            FYModel?.minimumLease = textField.text
            guard let blockk = self.endEditingFYMessageCell else {
                return
            }
            blockk(FYModel ?? FangYuanFYEditDetailModel())
        }
        
        
        
        //MARK: 独立办公室
        if jointIndepentOfficeModel.type == .OwnerBuildingJointOfficeTypeBuildingVR {
            FYModel?.minSeatsOffice = textField.text
            guard let blockk = self.endEditingFYMessageCell else {
                return
            }
            blockk(FYModel ?? FangYuanFYEditDetailModel())
        }
        
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
}


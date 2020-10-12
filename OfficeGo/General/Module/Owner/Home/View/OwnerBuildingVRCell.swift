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
    
    
    lazy var editLabel: UITextField = {
        let view = UITextField()
        view.textAlignment = .left
        view.font = FONT_15
        view.textColor = kAppColor_333333
        view.clearButtonMode = .whileEditing
        view.keyboardType = .default
        view.clipsToBounds = true
        view.layer.borderColor = kAppColor_line_EEEEEE.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = button_cordious_2
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
    
    var userModel: OwnerIdentifyUserModel?
    
    var endEditingMessageCell:((OwnerIdentifyUserModel) -> Void)?
    
    func setupViews() {
        
        addSubview(titleLabel)
        addSubview(editLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(left_pending_space_17)
            make.top.equalTo(10)
            make.height.equalTo(cell_height_58)
        }
        
        editLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(left_pending_space_17)
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
    
    var buildingModel: FangYuanBuildingEditDetailModel = FangYuanBuildingEditDetailModel() {
        didSet {
            editLabel.text = "https://img.officego.com/test/1596620185492.mp4"
        }
    }
    
    var model: OwnerBuildingEditConfigureModel = OwnerBuildingEditConfigureModel(types: OwnerBuildingEditType.OwnerBuildingEditTypeBuildingVR) {
        didSet {
            
            titleLabel.attributedText = model.getNameFormType(type: model.type ?? OwnerBuildingEditType.OwnerBuildingEditTypeBuildingVR)
            editLabel.placeholder = model.getPalaceHolderFormType(type: model.type ?? OwnerBuildingEditType.OwnerBuildingEditTypeBuildingVR)
            
        }
    }
}

extension OwnerBuildingVRCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard let blockk = self.endEditingMessageCell else {
            return
        }
        blockk(userModel ?? OwnerIdentifyUserModel())
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
}


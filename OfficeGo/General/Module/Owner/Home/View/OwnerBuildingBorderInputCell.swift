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
        view.textAlignment = .left
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
    
    var userModel: OwnerIdentifyUserModel?

    var endEditingMessageCell:((OwnerIdentifyUserModel) -> Void)?

    func setupViews() {
                
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
        ///电梯数 - 客梯
        if model.type == .OwnerBuildingEditTypePassengerNum {
            
        }
        ///电梯数 - 货梯
        else if model.type == .OwnerBuildingEditTypeFloorCargoNum {
            
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
                
            }
            ///电梯数 - 货梯
            else if model.type == .OwnerBuildingEditTypeFloorCargoNum {
                
            }
        }
    }
}

extension OwnerBuildingBorderInputCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
       
        ///电梯数 - 客梯
        if model.type == .OwnerBuildingEditTypePassengerNum {
            
        }
        ///电梯数 - 货梯
        else if model.type == .OwnerBuildingEditTypeFloorCargoNum {
            
        }
        
        guard let blockk = self.endEditingMessageCell else {
            return
        }
        blockk(userModel ?? OwnerIdentifyUserModel())
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
}



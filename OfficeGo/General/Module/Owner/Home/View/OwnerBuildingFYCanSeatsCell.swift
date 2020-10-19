//
//  OwnerBuildingFYCanSeatsCell.swift
//  OfficeGo
//
//  Created by Mac pro on 2020/10/19.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class OwnerBuildingFYCanSeatsCell: BaseTableViewCell {
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_15
        view.setContentCompressionResistancePriority(.required, for: .horizontal)
        view.textColor = kAppColor_333333
        return view
    }()
    
    ///最小工位数
    lazy var minLabel: UITextField = {
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
        view.textAlignment = .center
        view.font = FONT_18
        view.textColor = kAppColor_btnGray_BEBEBE
        view.text = "-"
        return view
    }()
    
    
    ///最大工位数
    lazy var maxLabel: UITextField = {
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
    
    lazy var rightUnitLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.font = FONT_14
        view.textColor = kAppColor_btnGray_BEBEBE
        view.text = "个"
        return view
    }()
    
    lazy var detailIcon: UIButton = {
        let view = UIButton()
        view.setImage(UIImage.init(named: "alertImg"), for: .normal)
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
    
    var alertBtnClickClouse:(() -> Void)?

    var buildingModel: FangYuanBuildingEditDetailModel?
    
    var endEditingMessageCell:((FangYuanBuildingEditDetailModel) -> Void)?
    
    func setupViews() {
        
        addSubview(titleLabel)
        addSubview(minLabel)
        addSubview(unitLabel)
        addSubview(maxLabel)
        addSubview(rightUnitLabel)
        addSubview(detailIcon)
        addSubview(lineView)
        
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(left_pending_space_17)
            make.top.bottom.equalToSuperview()
        }
        
        minLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(titleLabel.snp.trailing)
            make.size.equalTo(CGSize(width: 70, height: 36))
            make.centerY.equalTo(titleLabel)
        }
        unitLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(minLabel.snp.trailing)
            make.top.bottom.equalTo(titleLabel)
            make.width.equalTo(28)
        }
        maxLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(unitLabel.snp.trailing)
            make.size.equalTo(CGSize(width: 70, height: 36))
            make.centerY.equalTo(titleLabel)
        }
        rightUnitLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(maxLabel.snp.trailing)
            make.top.bottom.equalTo(titleLabel)
            make.width.equalTo(28)
        }
        detailIcon.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 47, height: 40))
        }
        
        detailIcon.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: left_pending_space_17)
        
        lineView.snp.makeConstraints { (make) in
            make.leading.equalTo(left_pending_space_17)
            make.trailing.equalTo(-left_pending_space_17)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        
        minLabel.delegate = self
        minLabel.addTarget(self, action: #selector(valueDidChange(tf:)), for: .editingChanged)
        
        maxLabel.delegate = self
        maxLabel.addTarget(self, action: #selector(valueDidChange(tf:)), for: .editingChanged)
        
        detailIcon.addTarget(self, action: #selector(clickAlertBtn), for: .touchUpInside)
    }
    
    /// ?按钮
    @objc func clickAlertBtn() {
        
        guard let blockk = self.alertBtnClickClouse else {
            return
        }
        blockk()
        
    }
    
    
    @objc func valueDidChange(tf: UITextField) {
        let textNum = minLabel.text?.count
        
    }
    
    
    var officeModel: OwnerBuildingOfficeConfigureModel = OwnerBuildingOfficeConfigureModel(types: OwnerBuildingOfficeType.OwnerBuildingOfficeTypeSeats) {
        didSet {
            
            titleLabel.attributedText = officeModel.getNameFormType(type: OwnerBuildingOfficeType.OwnerBuildingOfficeTypeSeats)
            
        }
    }
}

extension OwnerBuildingFYCanSeatsCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard let blockk = self.endEditingMessageCell else {
            return
        }
        blockk(buildingModel ?? FangYuanBuildingEditDetailModel())
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
}




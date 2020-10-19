//
//  OwnerBuildingEnterCompanyCell.swift
//  OfficeGo
//
//  Created by Mac pro on 2020/10/12.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class OwnerBuildingEnterCompanyCell: BaseTableViewCell {
    
    @objc var closeBtnClickClouse: CloseBtnClickClouse?
    
    var endEditingMessageCell:((_ str: String, _ index: Int) -> Void)?
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_14
        view.setContentCompressionResistancePriority(.required, for: .horizontal)
        view.textColor = kAppColor_333333
        return view
    }()
    
    
    lazy var editLabel: UITextField = {
        let view = UITextField()
        view.textAlignment = .left
        view.font = FONT_14
        view.textColor = kAppColor_333333
        return view
    }()
    
    
    lazy var detailIcon: UIButton = {
        let view = UIButton()
        view.setImage(UIImage.init(named: "addBlue"), for: .normal)
        return view
    }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = kAppColor_line_EEEEEE
        return view
    }()
    
    var userModel: OwnerIdentifyUserModel?
    
    var indexPathRow: Int?
    
    var model: OwnerBuildingEditConfigureModel = OwnerBuildingEditConfigureModel(types: OwnerBuildingEditType.OwnerBuildingEditTypeEnterCompany) {
        didSet {
            
            titleLabel.attributedText = model.getNameFormType(type: model.type ?? OwnerBuildingEditType.OwnerBuildingEditTypeEnterCompany)
            editLabel.placeholder = model.getPalaceHolderFormType(type: model.type ?? OwnerBuildingEditType.OwnerBuildingEditTypeEnterCompany)
        }
    }
    
    var jointModel: OwnerBuildingJointEditConfigureModel = OwnerBuildingJointEditConfigureModel(types: OwnerBuildingJointEditType.OwnerBuildingJointEditTypeBuildingName) {
        didSet {
            
            titleLabel.attributedText = jointModel.getNameFormType(type: jointModel.type ?? OwnerBuildingJointEditType.OwnerBuildingJointEditTypeEnterCompany)
            editLabel.placeholder = jointModel.getPalaceHolderFormType(type: jointModel.type ?? OwnerBuildingJointEditType.OwnerBuildingJointEditTypeEnterCompany)
        }
    }
    
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
    
    func setupViews() {
        
        addSubview(titleLabel)
        addSubview(editLabel)
        addSubview(detailIcon)
        addSubview(lineView)
        
        editLabel.delegate = self
        
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(left_pending_space_17)
            make.top.bottom.equalToSuperview()
        }
        
        editLabel.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-50)
            make.leading.equalTo(titleLabel.snp.trailing)
            make.top.bottom.equalToSuperview()
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
        
        detailIcon.addTarget(self, action: #selector(clickCloseBtn(btn:)), for: .touchUpInside)
    }
    
    /// 关闭按钮
    @objc func clickCloseBtn(btn:UIButton) {
        
        if self.closeBtnClickClouse != nil {
            self.closeBtnClickClouse!(indexPathRow ?? 0)
        }
    }
    
}
extension OwnerBuildingEnterCompanyCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        ///入驻企业
        if model.type == .OwnerBuildingEditTypeEnterCompany {
            
        }
        
        guard let blockk = self.endEditingMessageCell else {
            return
        }
        blockk(textField.text ?? "", indexPathRow ?? 0)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
}

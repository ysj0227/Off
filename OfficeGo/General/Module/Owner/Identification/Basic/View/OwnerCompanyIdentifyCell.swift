//
//  OwnerCompanyIdentifyCell.swift
//  OfficeGo
//
//  Created by mac on 2020/7/13.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

typealias IdentifyEditingClickClouse = (String)->()

class OwnerCompanyIdentifyCell: BaseCollectionViewCell {
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_14
        view.textColor = kAppColor_333333
        return view
    }()
    lazy var numDescTF: UITextField = {
        let view = UITextField()
        view.textAlignment = .left
        view.font = FONT_14
        view.delegate = self
        view.textColor = kAppColor_333333
        return view
    }()
    lazy var detailIcon: BaseImageView = {
        let view = BaseImageView.init()
        view.contentMode = .scaleAspectFit
        view.image = UIImage.init(named: "moreDetail")
        return view
    }()
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = kAppColor_line_EEEEEE
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    class func rowHeight() -> CGFloat {
        return cell_height_58
    }
    //公司名字
    @objc var companyNameClickClouse: IdentifyEditingClickClouse?

    //大楼名称
    @objc var buildingNameClickClouse: IdentifyEditingClickClouse?
    
    //写字楼地址
    var buildingAddresEndEditingMessageCell:((String) -> Void)?

    //模拟认证模型
    var userModel: OwnerIdentifyUserModel?

    var model: OwnerCompanyIedntifyConfigureModel = OwnerCompanyIedntifyConfigureModel(types: .OwnerCompanyIedntifyTypeIdentigy) {
        didSet {
            titleLabel.text = model.getNameFormType(type: model.type ?? .OwnerCompanyIedntifyTypeIdentigy)
            if model.type == .OwnerCompanyIedntifyTypeIdentigy {
                numDescTF.isUserInteractionEnabled = false
                detailIcon.isHidden = false
                lineView.isHidden = false
                ///身份类型0个人1企业2联合
                if UserTool.shared.user_owner_identifytype == 0 {
                    numDescTF.text = "个人"
                }else if UserTool.shared.user_owner_identifytype == 1 {
                    numDescTF.text = "公司"
                }else if UserTool.shared.user_owner_identifytype == 2 {
                    numDescTF.text = "联合办公"
                }
            }else if model.type == .OwnerCompanyIedntifyTypeBuildingFCType{
                numDescTF.isUserInteractionEnabled = false
                detailIcon.isHidden = false
                lineView.isHidden = false
                if userModel?.renterType == 0 {
                    numDescTF.text = "直租"
                }else if userModel?.renterType == 1 {
                    numDescTF.text = "转租"
                }else {
                    numDescTF.text = ""
                }
            }else if model.type == .OwnerCompanyIedntifyTypeCompanyname{
                numDescTF.isUserInteractionEnabled = true
                detailIcon.isHidden = true
                lineView.isHidden = true
                numDescTF.text = userModel?.company
            }else if model.type == .OwnerCompanyIedntifyTypeBuildingName {
                numDescTF.isUserInteractionEnabled = true
                detailIcon.isHidden = true
                lineView.isHidden = false
                numDescTF.text = userModel?.buildingName
            }else if model.type == .OwnerCompanyIedntifyTypeBuildingAddress{
                numDescTF.isUserInteractionEnabled = true
                detailIcon.isHidden = true
                lineView.isHidden = false
                numDescTF.text = userModel?.address
            }
        }
    }
    
    func setupViews() {
        
        addSubview(titleLabel)
        addSubview(numDescTF)
        addSubview(detailIcon)
        addSubview(lineView)
        
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        detailIcon.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(10)
        }
        
        numDescTF.snp.makeConstraints { (make) in
            make.trailing.equalTo(detailIcon.snp.leading).offset(-9)
            make.centerY.equalToSuperview()
            make.leading.equalTo(titleLabel.snp.trailing)
        }
        lineView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        
        numDescTF.addTarget(self, action: #selector(valueDidChange), for: .editingChanged)

    }
    @objc func valueDidChange() {
        
        //只有办公楼地址要在编辑结束的时候传过去
        if model.type == .OwnerCompanyIedntifyTypeCompanyname {
            guard let blockk = self.companyNameClickClouse else {
                return
            }
            blockk(numDescTF.text ?? "")
        }
        //只有办公楼地址要在编辑结束的时候传过去
        else if model.type == .OwnerCompanyIedntifyTypeBuildingName {
            guard let blockk = self.buildingNameClickClouse else {
                return
            }
            blockk(numDescTF.text ?? "")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
}

extension OwnerCompanyIdentifyCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        //只有办公楼地址要在编辑结束的时候传过去
        if model.type == .OwnerCompanyIedntifyTypeBuildingAddress {
            guard let blockk = self.buildingAddresEndEditingMessageCell else {
                return
            }
            blockk(textField.text ?? "")
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
}

//
//  OwnerJointIdentifyCell.swift
//  OfficeGo
//
//  Created by mac on 2020/7/15.
//  Copyright © 2020 Senwei. All rights reserved.
//
import UIKit

class OwnerJointIdentifyCell: BaseCollectionViewCell {
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_14
        view.textColor = kAppColor_999999
        return view
    }()
    lazy var numDescTF: UITextField = {
        let view = UITextField()
        view.textAlignment = .left
        view.font = FONT_14
        view.delegate = self
        view.textColor = kAppColor_333333
        view.clearButtonMode = .whileEditing
        return view
    }()
    lazy var detailIcon: BaseImageView = {
        let view = BaseImageView.init()
        view.contentMode = .scaleAspectFit
        view.image = UIImage.init(named: "moreDetail")
        return view
    }()
    lazy var addressLabel: UILabel = {
        let view = UILabel()
        view.isHidden = true
        view.textAlignment = .left
        view.font = FONT_11
        view.textColor = kAppColor_666666
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
    
    //网点名字
    @objc var branchNameClickClouse: IdentifyEditingClickClouse?
    
    //公司名字
    @objc var companyNameClickClouse: IdentifyEditingClickClouse?

    //大楼名称
    @objc var buildingNameClickClouse: IdentifyEditingClickClouse?
    
    //网点名称
    var buildingNameEndEditingMessageCell:((String) -> Void)?

    //模拟认证模型
    var userModel: OwnerIdentifyUserModel?

    var model: OwnerJointIedntifyConfigureModel = OwnerJointIedntifyConfigureModel(types: .OwnerJointIedntifyTypeIdentigy) {
        didSet {
            titleLabel.text = model.getNameFormType(type: model.type ?? .OwnerJointIedntifyTypeIdentigy)
            if model.type == .OwnerJointIedntifyTypeIdentigy {
                numDescTF.isUserInteractionEnabled = false
                detailIcon.isHidden = false
                addressLabel.isHidden = true
                ///身份类型0个人1企业2联合
                if UserTool.shared.user_owner_identifytype == 0 {
                    numDescTF.text = "个人"
                }else if UserTool.shared.user_owner_identifytype == 1 {
                    numDescTF.text = "公司"
                }else if UserTool.shared.user_owner_identifytype == 2 {
                    numDescTF.text = "联合办公"
                }
            }else if model.type == .OwnerPersonalIedntifyTypeBuildingFCType{
                numDescTF.isUserInteractionEnabled = false
                detailIcon.isHidden = true
                addressLabel.isHidden = true
                if userModel?.leaseType == 0 {
                    numDescTF.text = "自有房产"
                }else if userModel?.leaseType == 1 {
                    numDescTF.text = "租赁房产"
                }else {
                    numDescTF.text = ""
                }
            }else if model.type == .OwnerJointIedntifyTypeBranchname{
                numDescTF.isUserInteractionEnabled = true
                detailIcon.isHidden = true
                addressLabel.isHidden = false
                numDescTF.text = userModel?.branchNameTemp
                addressLabel.text = userModel?.buildingAddressTemp
            }else if model.type == .OwnerJointIedntifyTypeCompanyname{
                numDescTF.isUserInteractionEnabled = true
                detailIcon.isHidden = true
                addressLabel.isHidden = true
                numDescTF.text = userModel?.companyNameTemp
            }else if model.type == .OwnerJointIedntifyTypeBuildingName {
                numDescTF.isUserInteractionEnabled = true
                detailIcon.isHidden = true
                addressLabel.isHidden = false
                numDescTF.text = userModel?.buildingNameTemp
                if numDescTF.text?.count ?? 0 > 0 {
                    addressLabel.text = userModel?.buildingAddressTemp
                }
            }
        }
    }
    
    func setupViews() {
        
        addSubview(titleLabel)
        addSubview(numDescTF)
        addSubview(detailIcon)
        addSubview(lineView)
        addSubview(addressLabel)

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
        addressLabel.snp.makeConstraints { (make) in
            make.top.equalTo(numDescTF.snp.bottom)
            make.leading.equalTo(numDescTF)
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
        if model.type == .OwnerJointIedntifyTypeBranchname {
            guard let blockk = self.branchNameClickClouse else {
                return
            }
            addressLabel.text = ""
            blockk(numDescTF.text ?? "")
        }
        
        //只有办公楼地址要在编辑结束的时候传过去
        if model.type == .OwnerJointIedntifyTypeCompanyname {
            guard let blockk = self.companyNameClickClouse else {
                return
            }
            blockk(numDescTF.text ?? "")
        }
        //只有办公楼地址要在编辑结束的时候传过去
        else if model.type == .OwnerJointIedntifyTypeBuildingName {
            guard let blockk = self.buildingNameClickClouse else {
                return
            }
            addressLabel.text = ""
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

extension OwnerJointIdentifyCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
//        //只有网点名称要在编辑结束的时候传过去
//        if model.type == .OwnerJointIedntifyTypeBuildingName {
//            guard let blockk = self.buildingNameEndEditingMessageCell else {
//                return
//            }
//            blockk(textField.text ?? "")
//        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
}


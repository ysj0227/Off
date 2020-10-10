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
        view.setContentCompressionResistancePriority(.required, for: .horizontal)
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
//        view.clearButtonMode = .whileEditing
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
    lazy var editBtn: UIButton = {
        let btn = UIButton.init()
        btn.setImage(UIImage.init(named: "idenEdit"), for: .normal)
        btn.titleLabel?.font = FONT_8
        btn.addTarget(self, action: #selector(editClick), for: .touchUpInside)
        return btn
    }()
    lazy var closeBtn: UIButton = {
        let btn = UIButton.init()
        btn.setImage(UIImage.init(named: "idenDelete"), for: .normal)
        btn.titleLabel?.font = FONT_8
        btn.addTarget(self, action: #selector(closeClick), for: .touchUpInside)
        return btn
    }()
    
    //按钮点击方法
    var editClickBack:((OwnerJointIedntifyType) -> Void)?
    
    @objc func editClick() {
        guard let blockk = editClickBack else {
            return
        }
        blockk(model.type ?? OwnerJointIedntifyType.OwnerJointIedntifyTypeIdentigy)
    }
    
    var closeClickBack:((OwnerJointIedntifyType) -> Void)?
    
    @objc func closeClick() {
        editBtn.isHidden = true
        numDescTF.text = ""
        numDescTF.isUserInteractionEnabled = true
        numDescTF.becomeFirstResponder()
        addressLabel.text = ""
        guard let blockk = closeClickBack else {
            return
        }
        blockk(model.type ?? OwnerJointIedntifyType.OwnerJointIedntifyTypeIdentigy)
    }
    
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
    
    //写字楼名称址
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
                editBtn.isHidden = true
                closeBtn.isHidden = true
                ///身份类型0个人1企业2联合
                if UserTool.shared.user_owner_identifytype == 0 {
                    numDescTF.text = "个人"
                }else if UserTool.shared.user_owner_identifytype == 1 {
                    numDescTF.text = "公司"
                }else if UserTool.shared.user_owner_identifytype == 2 {
                    numDescTF.text = "共享办公"
                }
            }else if model.type == .OwnerPersonalIedntifyTypeBuildingFCType{
                numDescTF.isUserInteractionEnabled = false
                detailIcon.isHidden = true
                addressLabel.isHidden = true
                editBtn.isHidden = true
                closeBtn.isHidden = true
                if userModel?.leaseType == "0" {
                    numDescTF.text = "自有房产"
                }else if userModel?.leaseType == "1" {
                    numDescTF.text = "租赁房产"
                }else {
                    numDescTF.text = ""
                }
            }else if model.type == .OwnerJointIedntifyTypeBranchname{
                detailIcon.isHidden = true
                addressLabel.isHidden = false
                closeBtn.isHidden = false
                numDescTF.text = userModel?.branchesName
                addressLabel.text = userModel?.buildingAddress
                //0 空   无定义     1创建  2关联吗
                //就是自己创建
                if userModel?.isCreateBranch == "1" {
                    //1的就是自己创建
                    //不能输入框修改
                    //有编辑按钮
                    //有清空
                    numDescTF.isUserInteractionEnabled = false
                    editBtn.isHidden = false
                }else if userModel?.isCreateBranch == "2" {
                    //0 就是关联的公司
                    //不能输入框修改
                    //无编辑按钮
                    //有清空
                    numDescTF.isUserInteractionEnabled = true
                    editBtn.isHidden = true
                }else {
                    //如果没有提交过，应该返回一个""
                    //"" 没有提交过
                    //能输入框修改
                    //无编辑按钮
                    //有清空
                    numDescTF.isUserInteractionEnabled = true
                    editBtn.isHidden = true
                }
                
            }else if model.type == .OwnerJointIedntifyTypeCompanyname{
                //公司每次都是创建
                numDescTF.isUserInteractionEnabled = true
                detailIcon.isHidden = true
                addressLabel.isHidden = true
                closeBtn.isHidden = false
                numDescTF.text = userModel?.company
                //0 空   无定义     1创建  2关联吗
                //就是自己创建
                if userModel?.isCreateCompany == "1" {
                    //1的就是自己创建
                    //不能输入框修改
                    //有编辑按钮
                    //有清空
                    numDescTF.isUserInteractionEnabled = false
                    editBtn.isHidden = false
                }else if userModel?.isCreateCompany == "2" {
                    //0 就是关联的公司
                    //不能输入框修改
                    //无编辑按钮
                    //有清空
                    numDescTF.isUserInteractionEnabled = false
                    editBtn.isHidden = true
                }else {
                    //如果没有提交过，应该返回一个""
                    //"" 没有提交过
                    //能输入框修改
                    //无编辑按钮
                    //有清空
                    numDescTF.isUserInteractionEnabled = true
                    editBtn.isHidden = true
                }
            }else if model.type == .OwnerJointIedntifyTypeBuildingName {
                numDescTF.isUserInteractionEnabled = true
                detailIcon.isHidden = true
                addressLabel.isHidden = true
                editBtn.isHidden = true
                closeBtn.isHidden = true
                numDescTF.text = userModel?.buildingName
//                if numDescTF.text?.count ?? 0 > 0 {
//                    addressLabel.text = userModel?.buildingAddressTemp
//                }
            }
        }
    }
    
    func setupViews() {
        
        addSubview(titleLabel)
        addSubview(numDescTF)
        addSubview(detailIcon)
        addSubview(lineView)
        addSubview(addressLabel)
        addSubview(editBtn)
        addSubview(closeBtn)
        
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        
        detailIcon.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(10)
        }
        
        numDescTF.snp.makeConstraints { (make) in
            make.trailing.equalTo(detailIcon.snp.leading).offset(-49)
            make.centerY.equalToSuperview()
            make.leading.equalTo(titleLabel.snp.trailing)
        }
        addressLabel.snp.makeConstraints { (make) in
            make.top.equalTo(numDescTF.snp.bottom)
            make.leading.equalTo(numDescTF)
        }
        closeBtn.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview()
            make.width.equalTo(25)
            make.centerY.equalToSuperview()
            make.height.equalTo(25)
        }
        editBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(closeBtn.snp.leading).offset(-3)
            make.width.equalTo(25)
            make.centerY.equalToSuperview()
            make.height.equalTo(25)
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
        
        //只有写字楼地址要在编辑结束的时候传过去
        if model.type == .OwnerJointIedntifyTypeBranchname {
            guard let blockk = self.branchNameClickClouse else {
                return
            }
            addressLabel.text = ""
            let textNum = numDescTF.text?.count
              
            //截取
            if textNum! > ownerMaxBranchnameNumber {
                let index = numDescTF.text?.index((numDescTF.text?.startIndex)!, offsetBy: ownerMaxBranchnameNumber)
                let str = numDescTF.text?.substring(to: index!)
                numDescTF.text = str
            }
            blockk(numDescTF.text ?? "")
        }
        
        //只有写字楼地址要在编辑结束的时候传过去
        if model.type == .OwnerJointIedntifyTypeCompanyname {
            guard let blockk = self.companyNameClickClouse else {
                return
            }
            let textNum = numDescTF.text?.count
              
            //截取
            if textNum! > ownerMaxCompanynameNumber {
                let index = numDescTF.text?.index((numDescTF.text?.startIndex)!, offsetBy: ownerMaxCompanynameNumber)
                let str = numDescTF.text?.substring(to: index!)
                numDescTF.text = str
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

extension OwnerJointIdentifyCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        //只有楼盘名称要在编辑结束的时候传过去
        if model.type == .OwnerJointIedntifyTypeBuildingName {
            guard let blockk = self.buildingNameEndEditingMessageCell else {
                return
            }
            blockk(textField.text ?? "")
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
}


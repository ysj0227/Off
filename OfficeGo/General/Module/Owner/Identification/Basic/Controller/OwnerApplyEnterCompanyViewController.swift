//
//  OwnerApplyEnterCompanyViewController.swift
//  OfficeGo
//
//  Created by mac on 2020/7/15.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class OwnerApplyEnterCompanyViewController: BaseViewController {
    
    var isBranch: Bool? = false
    
    let topview: OwnerApplyEnterConpanyTopview = {
        let view = OwnerApplyEnterConpanyTopview(frame: CGRect(x: left_pending_space_17, y: kNavigationHeight + 10, width: kWidth - left_pending_space_17 * 2, height: 150))
        return view
    }()
    
    let bottomView: OwnerApplyEnterConpanyInputview = {
        let view = OwnerApplyEnterConpanyInputview(frame: CGRect(x: left_pending_space_17, y: kNavigationHeight + 10 + 150 + 14, width: kWidth - left_pending_space_17 * 2, height: 218))
        return view
    }()
    
    lazy var bottomBtnView: BottomBtnView = {
        let view = BottomBtnView.init(frame: CGRect(x: 0, y: 0, width: kWidth, height: 50))
        view.bottomType = BottomBtnViewType.BottomBtnViewTypeIwantToFind
        view.rightSelectBtn.setTitle("发送申请", for: .normal)
        view.backgroundColor = kAppWhiteColor
        return view
    }()
    
    //公司认证 - 公司
    var companyModel: OwnerESCompanySearchViewModel?
    
    //网点认证 - 网点
    var branchModel: OwnerESBuildingSearchViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
        setData()
    }
    
    
}

extension OwnerApplyEnterCompanyViewController {
    
    func setData() {
        if isBranch == true {
            topview.branchModel = branchModel
            bottomView.userModel = companyModel
        }else {
            topview.companyModel = companyModel
            bottomView.userModel = companyModel
        }
    }
    
    func setView() {
        
        let blueBgView = UIView(frame: CGRect(x: 0, y: 0, width: kWidth, height: kNavigationHeight + 150 + 14 + 30))
        blueBgView.backgroundColor = kAppBlueColor
        self.view.addSubview(blueBgView)
        
        titleview = ThorNavigationView.init(type: .backTitleRightBlueBgclolor)
        titleview?.rightButton.isHidden = true
        titleview?.leftButtonCallBack = { [weak self] in
            self?.leftBtnClick()
        }
        self.view.addSubview(titleview ?? ThorNavigationView.init(type: .HouseScheduleHeaderView))
        
        self.view.addSubview(topview)
        
        self.view.addSubview(bottomView)
        
        self.view.addSubview(bottomBtnView)
        
        bottomBtnView.rightBtnClickBlock = { [weak self] in
            
            self?.requestApplyEnterCompany()
        }
        bottomBtnView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-bottomMargin())
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        
        let descLabel = UILabel()
        descLabel.textAlignment = .center
        descLabel.font = FONT_10
        descLabel.text = "填写申请说明有助于管理员同意哦～"
        descLabel.textColor = kAppColor_999999
        self.view.addSubview(descLabel)
        descLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(bottomBtnView.snp.top).offset(-13)
        }
    }
    
    ///加入公司接口 -
    func requestApplyEnterCompany() {
        addNotify()
    }
    
    //发送加入公司和网点公司的通知
    func addNotify() {
        ///身份类型0个人1企业2联合
        if UserTool.shared.user_owner_identifytype == 1 {
            NotificationCenter.default.post(name: NSNotification.Name.OwnerApplyEnterCompany, object: companyModel)
        }else if UserTool.shared.user_owner_identifytype == 2 {
            //联合 - 网点名称
            if isBranch == true {
                NotificationCenter.default.post(name: NSNotification.Name.OwnerApplyEnterCompanyJoint, object: branchModel)
            }else {

                //联合 - 公司名称
                NotificationCenter.default.post(name: NSNotification.Name.OwnerApplyEnterCompany, object: companyModel)
            }
        }
    }
}

@objcMembers class OwnerApplyEnterConpanyTopview: UIView {
    
    lazy var itemIcon: BaseImageView = {
        let view = BaseImageView.init()
        view.image = UIImage.init(named: "companyIedntify")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_MEDIUM_15
        view.textColor = kAppColor_333333
        return view
    }()
    
    lazy var addressICon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.init(named: "locationBlue")
        view.contentMode = .scaleAspectFit
        return view
    }()
    lazy var addressLabel: UILabel = {
        let view = UILabel()
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
    
    lazy var avatarImg: BaseImageView = {
        let view = BaseImageView.init()
        view.image = UIImage.init(named: "avatar")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_MEDIUM_12
        view.textColor = kAppColor_333333
        return view
    }()
//    lazy var jobLabel: UILabel = {
//        let view = UILabel()
//        view.textAlignment = .left
//        view.font = FONT_9
//        view.textColor = kAppColor_666666
//        return view
//    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupView() {
        
        self.backgroundColor = kAppWhiteColor
        
        self.clipsToBounds = true
        self.layer.cornerRadius = button_cordious_15
        avatarImg.layer.cornerRadius = 14
        
        addSubview(itemIcon)
        addSubview(titleLabel)
        addSubview(addressICon)
        addSubview(addressLabel)
        addSubview(lineView)
        addSubview(avatarImg)
        addSubview(nameLabel)
        
        itemIcon.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 48, height: 22))
            make.leading.equalTo(21)
            make.top.equalTo(26)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(itemIcon.snp.trailing).offset(10)
            make.trailing.equalToSuperview()
            make.centerY.equalTo(itemIcon)
        }
        addressICon.snp.makeConstraints { (make) in
            make.top.equalTo(itemIcon.snp.bottom).offset(12)
            make.leading.equalTo(itemIcon)
            make.size.equalTo(CGSize(width: 14, height: 16))
        }
        addressLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(addressICon.snp.trailing).offset(6)
            make.trailing.equalToSuperview()
            make.centerY.equalTo(addressICon)
        }
        lineView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(addressICon.snp.bottom).offset(13)
            make.height.equalTo(1)
        }
        
        avatarImg.snp.makeConstraints { (make) in
            make.top.equalTo(lineView.snp.bottom).offset(11)
            make.leading.equalTo(itemIcon)
            make.size.equalTo(28)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(avatarImg.snp.trailing).offset(13)
            make.centerY.equalTo(avatarImg)
            make.trailing.equalToSuperview()
        }
    }
    
    var companyModel: OwnerESCompanySearchViewModel? {
        didSet {
            
            titleLabel.text = companyModel?.companyString?.string
            avatarImg.setImage(with: "", placeholder: UIImage.init(named: "avatar"))
            nameLabel.text = "管理员：杨先生 CED"
            if let address = companyModel?.addressString?.string {
                if address.isBlankString == true {
                    addressICon.isHidden = true
                    addressLabel.text = ""
                }else {
                    addressICon.isHidden = false
                    addressLabel.text = address
                }
            }else {
                addressICon.isHidden = true
                addressLabel.text = ""
            }
        }
    }
    
    var branchModel: OwnerESBuildingSearchViewModel? {
        didSet {
            
            titleLabel.text = branchModel?.buildingAttributedName?.string
            avatarImg.setImage(with: "", placeholder: UIImage.init(named: "avatar"))
            nameLabel.text = "管理员：杨先生 CED"
            itemIcon.isHidden = true
            itemIcon.snp.makeConstraints { (make) in
                make.size.equalTo(CGSize(width: 0, height: 22))
                make.leading.equalTo(21)
                make.top.equalTo(26)
            }
            titleLabel.snp.remakeConstraints { (make) in
                make.leading.equalTo(itemIcon.snp.trailing).offset(0)
                make.trailing.equalToSuperview()
                make.centerY.equalTo(itemIcon)
            }
            if let address = branchModel?.addressString?.string {
                if address.isBlankString == true {
                    addressICon.isHidden = true
                    addressLabel.text = ""
                }else {
                    addressICon.isHidden = false
                    addressLabel.text = address
                }
            }else {
                addressICon.isHidden = true
                addressLabel.text = ""
            }
        }
    }
    
}

@objcMembers class OwnerApplyEnterConpanyInputview: UIView {
    var topBgView: UIView = {
        let view = UIView()
        view.backgroundColor = kAppColor_bgcolor_F7F7F7
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_MEDIUM_12
        ///身份类型0个人1企业2联合
        if UserTool.shared.user_owner_identifytype == 1 {
            view.text = "申请加入公司"
        }else if UserTool.shared.user_owner_identifytype == 2 {
            view.text = "申请加入网点"
        }
        view.textColor = kAppColor_333333
        return view
    }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = kAppColor_line_EEEEEE
        return view
    }()
    
    lazy var intruductionTextview: UITextView = {
        let view = UITextView()
        view.delegate = self
        view.textAlignment = .left
        view.font = FONT_11
        view.textColor = kAppColor_666666
        view.backgroundColor = kAppClearColor
        return view
    }()
    
    lazy var numOfCharLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .right
        view.font = FONT_10
        view.text = "0/100"
        view.textColor = kAppColor_666666
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupView() {
        
        self.backgroundColor = kAppWhiteColor
        
        topBgView.layer.cornerRadius = button_cordious_2
        
        self.layer.cornerRadius = button_cordious_15
        
        self.layer.shadowColor = kAppColor_bgcolor_F7F7F7.cgColor;
        self.layer.shadowRadius = button_cordious_15;
        self.layer.shadowOffset = CGSize.init(width: 10, height: 10);
        self.layer.shadowOpacity = 0.9;
        
        
        addSubview(topBgView)
        topBgView.addSubview(titleLabel)
        topBgView.addSubview(lineView)
        topBgView.addSubview(intruductionTextview)
        topBgView.addSubview(numOfCharLabel)
        
        topBgView.snp.makeConstraints { (make) in
            make.leading.top.bottom.trailing.equalToSuperview().inset(left_pending_space_17)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(left_pending_space_17)
            make.trailing.equalToSuperview()
            make.top.equalTo(13)
        }
        lineView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.height.equalTo(1)
        }
        numOfCharLabel.snp.makeConstraints { (make) in
            make.trailing.bottom.equalToSuperview().inset(left_pending_space_17)
        }
        intruductionTextview.snp.makeConstraints { (make) in
            make.top.equalTo(lineView.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalTo(numOfCharLabel.snp.top)
        }
    }
    
    var isBranch: Bool? = false

    var userModel: OwnerESCompanySearchViewModel? {
        didSet {
            
            ///身份类型0个人1企业2联合
            if UserTool.shared.user_owner_identifytype == 1 {
                intruductionTextview.text = "我是用户\(userModel?.realname ?? "")，希望加入公司，请通过。"
            }else if UserTool.shared.user_owner_identifytype == 2 {
                intruductionTextview.text = "我是用户\(userModel?.realname ?? "")，希望加入网点，请通过。"
            }
            numOfCharLabel.text = String(format: "%ld/100",intruductionTextview.text.count)
        }
    }
}

extension OwnerApplyEnterConpanyInputview: UITextViewDelegate {
    //MARK: - TextViewDelegate
    func textViewDidChange(_ textView: UITextView) {
        //获得已输出字数与正输入字母数
        let selectRange = textView.markedTextRange
        //获取高亮部分 － 如果有联想词则解包成功
        if let selectRange = selectRange {
            let position =  textView.position(from: (selectRange.start), offset: 0)
            if (position != nil) {
                return
            }
        }
        let textContent = textView.text
        let textNum = textContent?.count
        //截取
        if textNum! > 100 {
            let index = textContent?.index((textContent?.startIndex)!, offsetBy: 100)
            let str = textContent?.substring(to: index!)
            textView.text = str
            numOfCharLabel.text = "100/100"
            
        }
        numOfCharLabel.text = String(format: "%ld/100",textView.text.count)
    }
}

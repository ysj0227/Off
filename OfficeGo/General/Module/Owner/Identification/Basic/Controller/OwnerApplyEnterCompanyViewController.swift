//
//  OwnerApplyEnterCompanyViewController.swift
//  OfficeGo
//
//  Created by mac on 2020/7/15.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class OwnerApplyEnterCompanyViewController: BaseViewController {
    
    //从个人中心点击进来查看审核状态
    var isFromMine: Bool? = false
    
    //判断是加入公司还是加入网点
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
    
    lazy var descLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.font = FONT_10
        view.text = "填写申请说明有助于管理员同意哦～"
        view.textColor = kAppColor_999999
        return view
    }()
    
    //申请认证
    //公司认证 - 公司
    var companyModel: OwnerESCompanySearchViewModel?
    
    //网点认证 - 网点
    var branchModel: OwnerESBuildingSearchViewModel?
    
    //管理员信息接口
    var managerMsg: OwnerIdentifyMsgDetailModel? {
        didSet {
            topview.managerMsg = managerMsg
        }
    }
    
    
    //获取申请详情
    var iedntifyDetailMsg: OwnerIdentifyMsgDetailModel? {
        didSet {
            topview.iedntifyDetailMsg = iedntifyDetailMsg
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
        setData()
    }
    
    
}

extension OwnerApplyEnterCompanyViewController {
    
    ///从个人中心进来 - 查看申请详情
    func requestApplyDetailMsg() {
        
        var params = [String:AnyObject]()
        
        params["token"] = UserTool.shared.user_token as AnyObject?
        
        SSNetworkTool.SSOwnerIdentify.request_getQueryApplyLicenceProprietorApp(params: params, success: {[weak self] (response) in
            
            guard let weakSelf = self else {return}
            
            if let model = OwnerIdentifyMsgDetailModel.deserialize(from: response, designatedPath: "data") {
                weakSelf.iedntifyDetailMsg = model
            }
            
            }, failure: { (error) in
                
        }) { (code, message) in
            
            //只有5000 提示给用户 - 失效原因
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" || code == "\(SSCode.ERROR_CODE_7016.code)" {
                AppUtilities.makeToast(message)
            }
        }
    }
    
    ///申请加入公司管理员信息接口 -
    func requestApplyManagerMsg() {
        
        var params = [String:AnyObject]()
        
        params["token"] = UserTool.shared.user_token as AnyObject?
        
        
        //身份类型0个人认证1企业认证2网点认证
        params["identityType"] = UserTool.shared.user_owner_identifytype as AnyObject?
        
        //从详情进入的必传id
        if UserTool.shared.user_owner_identifytype == 1 {
            params["id"] = companyModel?.bid as AnyObject?
        }else if UserTool.shared.user_owner_identifytype == 2 {
            params["id"] = branchModel?.bid as AnyObject?
        }
        
        
        SSNetworkTool.SSOwnerIdentify.request_getApplyManagerMsg(params: params, success: {[weak self] (response) in
            
            guard let weakSelf = self else {return}
            
            if let model = OwnerIdentifyMsgDetailModel.deserialize(from: response, designatedPath: "data") {
                weakSelf.managerMsg = model
            }
            
            }, failure: { (error) in
                
        }) { (code, message) in
            
            //只有5000 提示给用户 - 失效原因
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" || code == "\(SSCode.ERROR_CODE_7016.code)" {
                AppUtilities.makeToast(message)
            }
        }
    }
    
    ///申请加入公司接口 -
    func requestApplyJoin() {
        
        var params = [String:AnyObject]()
        
        params["token"] = UserTool.shared.user_token as AnyObject?
        
        
        //身份类型0个人认证1企业认证2网点认证
        params["identityType"] = UserTool.shared.user_owner_identifytype as AnyObject?
        
        //申请加入的企业id
        if UserTool.shared.user_owner_identifytype == 1 {
            params["id"] = companyModel?.bid as AnyObject?
        }else if UserTool.shared.user_owner_identifytype == 2 {
            params["id"] = branchModel?.bid as AnyObject?
        }
        
        params["chattedId"] = managerMsg?.chattedId as AnyObject?
        
        
        SSNetworkTool.SSOwnerIdentify.request_getApplyJoin(params: params, success: {[weak self] (response) in
            
            guard let weakSelf = self else {return}
            
            if let model = MessageFYChattedModel.deserialize(from: response, designatedPath: "data") {
                
                weakSelf.requestApplyEnterCompany(applyJoinModel: model)
            }
            
            }, failure: { (error) in
                
        }) { (code, message) in
            
            //只有5000 提示给用户 - 失效原因
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" || code == "\(SSCode.ERROR_CODE_7016.code)" {
                AppUtilities.makeToast(message)
            }
        }
    }
    
    func setData() {
        //来自个人中心 -
        //隐藏输入框
        //按钮文字修改
        //按钮点击方法修改
        if isFromMine == true {
            ///从个人中心进来 - 查看申请详情
            requestApplyDetailMsg()
            
            bottomView.isHidden = true
            descLabel.isHidden = true
            bottomBtnView.rightSelectBtn.setTitle("撤销申请", for: .normal)
            bottomBtnView.rightBtnClickBlock = { [weak self] in
                
                self?.requestCancelApply()
            }
        }else {
            
            ///获取管理员信息
            requestApplyManagerMsg()
            
            if isBranch == true {
                topview.branchModel = branchModel
            }else {
                topview.companyModel = companyModel
            }
            bottomBtnView.rightBtnClickBlock = { [weak self] in
                
                
                self?.requestApplyJoin()
            }
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
        
        bottomBtnView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-bottomMargin())
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        
        self.view.addSubview(descLabel)
        descLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(bottomBtnView.snp.top).offset(-13)
        }
    }
    
    ///撤销申请接口 -
    func requestCancelApply() {
        
        var params = [String:AnyObject]()
        
        params["token"] = UserTool.shared.user_token as AnyObject?
        
        //申请加入的企业id
        params["id"] = iedntifyDetailMsg?.userLicenceId as AnyObject?
        
        SSNetworkTool.SSOwnerIdentify.request_getDeleteUserLicenceApp(params: params, success: {[weak self] (response) in
            
            guard let weakSelf = self else {return}
            
            weakSelf.leftBtnClick()
            
            }, failure: { (error) in
                
        }) { (code, message) in
            
            //只有5000 提示给用户 - 失效原因
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" || code == "\(SSCode.ERROR_CODE_7016.code)" {
                AppUtilities.makeToast(message)
            }
        }
    }
    
    ///申请加入公司操作 -
    func requestApplyEnterCompany(applyJoinModel: MessageFYChattedModel) {
        if applyJoinModel.targetId == nil && applyJoinModel.targetId?.isBlankString == true {
            AppUtilities.makeToast("获取管理员信息异常，无法发送申请")
            return
        }
        let vc = OwnerChatViewController()
        vc.needPopToRootView = true
        vc.conversationType = .ConversationType_PRIVATE
        vc.content = bottomView.intruductionTextview.text
        vc.applyJoinModel = applyJoinModel
        vc.targetId = managerMsg?.targetId
        vc.enableNewComingMessageIcon = true  //开启消息提醒
        vc.displayUserNameInCell = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //发送加入公司和网点公司的通知
    func addNotify() {
//        ///身份类型0个人1企业2联合
//        if UserTool.shared.user_owner_identifytype == 1 {
//            NotificationCenter.default.post(name: NSNotification.Name.OwnerApplyEnterCompany, object: companyModel)
//        }else if UserTool.shared.user_owner_identifytype == 2 {
//            //联合 - 网点名称
//            if isBranch == true {
//                NotificationCenter.default.post(name: NSNotification.Name.OwnerApplyEnterCompanyJoint, object: branchModel)
//            }else {
//                
//                //联合 - 公司名称
//                NotificationCenter.default.post(name: NSNotification.Name.OwnerApplyEnterCompany, object: companyModel)
//            }
//        }
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
            make.size.equalTo(30)
        }
        avatarImg.clipsToBounds = true
        avatarImg.layer.cornerRadius = 15
        nameLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(avatarImg.snp.trailing).offset(13)
            make.centerY.equalTo(avatarImg)
            make.trailing.equalToSuperview()
        }
    }
    
    ///公司认证 网点认证 -认证中 - 查看详情
    var iedntifyDetailMsg: OwnerIdentifyMsgDetailModel? {
        didSet {
            avatarImg.setImage(with: iedntifyDetailMsg?.avatar ?? "", placeholder: UIImage.init(named: "avatar"))
            if iedntifyDetailMsg?.proprietorRealname?.count ?? 0 > 0 || iedntifyDetailMsg?.proprietorJob?.count ?? 0 > 0 {
                nameLabel.text = "\(iedntifyDetailMsg?.authority ?? "")：\(iedntifyDetailMsg?.proprietorRealname ?? "") \(iedntifyDetailMsg?.proprietorJob ?? "")"
            }else {
                nameLabel.text = "\(iedntifyDetailMsg?.authority ?? "")"
            }
            //企业
            if iedntifyDetailMsg?.identityType == 1 {
                titleLabel.text = iedntifyDetailMsg?.title
                
                if let address = iedntifyDetailMsg?.address {
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
                //联办
            else if iedntifyDetailMsg?.identityType == 2 {
                
                titleLabel.text = iedntifyDetailMsg?.title
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
                if let address = iedntifyDetailMsg?.address {
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
    
    
    
    ///公司认证 网点认证 - 管理员信息
    var managerMsg: OwnerIdentifyMsgDetailModel? {
        didSet {
            avatarImg.setImage(with: managerMsg?.avatar ?? "", placeholder: UIImage.init(named: "avatar"))
            if managerMsg?.proprietorRealname?.count ?? 0 > 0 || managerMsg?.proprietorJob?.count ?? 0 > 0 {
                nameLabel.text = "\(managerMsg?.authority ?? "")：\(managerMsg?.proprietorRealname ?? "") \(managerMsg?.proprietorJob ?? "")"
            }else {
                nameLabel.text = "\(managerMsg?.authority ?? "")"
            }
        }
    }
    
    //公司认证 - 加入公司
    var companyModel: OwnerESCompanySearchViewModel? {
        didSet {
            
            titleLabel.text = companyModel?.companyString?.string
            
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
    
    //网点认证 - 加入网点
    var branchModel: OwnerESBuildingSearchViewModel? {
        didSet {
            
            titleLabel.text = branchModel?.buildingAttributedName?.string
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
        
        setTitle()
    }
    
    var isBranch: Bool? = false
    
    func setTitle() {
        ///身份类型0个人1企业2联合
        if UserTool.shared.user_owner_identifytype == 1 {
            intruductionTextview.text = "我是\(UserTool.shared.user_name ?? "")，希望加入公司，请通过。"
        }else if UserTool.shared.user_owner_identifytype == 2 {
            intruductionTextview.text = "我是\(UserTool.shared.user_name ?? "")，希望加入网点，请通过。"
        }
        numOfCharLabel.text = String(format: "%ld/100",intruductionTextview.text.count)
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

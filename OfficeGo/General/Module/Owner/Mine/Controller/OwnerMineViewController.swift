//
//  OwnerMineViewController.swift
//  OfficeGo
//
//  Created by mac on 2020/6/18.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit
import HandyJSON
import SwiftyJSON

class OwnerMineViewController: BaseTableViewController {
    
    var userModel: LoginUserModel?
    
    var typeSourceArray:[OwnerMineConfigureModel] = {
        var arr = [OwnerMineConfigureModel]()
        arr.append(OwnerMineConfigureModel.init(types: .OwnerMineTypeHelpAndFeedback))
        arr.append(OwnerMineConfigureModel.init(types: .OwnerMineTypeCusomers))
        arr.append(OwnerMineConfigureModel.init(types: .OwnerMineTypeRegisterAgent))
        arr.append(OwnerMineConfigureModel.init(types: .OwnerMineTypeAboutus))
        return arr
    }()
    
    var headerView: RenterUserHeaderView = {
        let view = RenterUserHeaderView.init(frame: CGRect(x: 0, y: 0, width: kWidth, height: kStatusBarHeight + 20 + 20 + 114))
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        
        setUpData()
        
    }
    ///判断有没有登录
    func juddgeIsLogin() {
        //登录直接请求数据
        if isLogin() == true {
            
            requestUserMessage()
            
        }else {
            //没登录 - 显示登录按钮view
            //清空之前的用户信息模型
            userModel = nil
            headerView.isNoLoginShowView = true
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        ///移除业主弹框
        SureAlertView.Remove()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let tab = self.navigationController?.tabBarController as? OwnerMainTabBarController
        tab?.customTabBar.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tab = self.navigationController?.tabBarController as? OwnerMainTabBarController
        tab?.customTabBar.isHidden = false
        
        juddgeIsLogin()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}


extension OwnerMineViewController {
    
    ///头像点击方法 - 判断有没有登录
    func headerViewClick() {
        if isLogin() == true {
            let vc = OwnerUserMsgViewController()
            vc.userModel = self.userModel
            self.navigationController?.pushViewController(vc, animated: true)
        }else {
            showLoginVC()
        }
    }
    
    ///设置按钮点击方法 - 判断有没有登录
    func settingBtnClick() {
        if isLogin() == true {
            let vc = RenterMineSettingViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }else {
            showLoginVC()
        }
    }
    
    func showLoginVC() {
        let vc = RenterLoginViewController()
        vc.isFromOtherVC = true
        vc.closeViewBack = {[weak self] (isClose) in
            guard let weakSelf = self else {return}
            weakSelf.juddgeIsLogin()
        }
        let loginNav = BaseNavigationViewController.init(rootViewController: vc)
        loginNav.modalPresentationStyle = .overFullScreen
        //TODO: 这块弹出要设置
        self.present(loginNav, animated: true, completion: nil)
        
    }
    
    func setUpView() {
        
        self.navigationController?.navigationBar.isHidden = true
        
        //        NotificationCenter.default.addObserver(self, selector: #selector(requestUserMessage), name: Notification.Name.userChanged, object: nil)
        
        self.view.backgroundColor = kAppBlueColor
        
        self.view.addSubview(headerView)
        
        headerView.headerBtnClickBlock = { [weak self] in
            self?.headerViewClick()
        }
        
        headerView.setBtnClickBlock = { [weak self] in
            self?.settingBtnClick()
        }
        self.tableView.clipsToBounds = true
        self.tableView.layer.cornerRadius = 13
        self.tableView.snp.remakeConstraints { (make) in
            make.top.equalTo(kStatusBarHeight + 20 + 20 + 114)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        self.tableView.register(RenterMineCell.self, forCellReuseIdentifier: RenterMineCell.reuseIdentifierStr)
    }
    
    func setUpData() {
        
        //        requestUserMessage()
        
        self.tableView.reloadData()
    }
    
}

extension OwnerMineViewController {
    @objc func requestUserMessage() {
        var params = [String:AnyObject]()
        params["token"] = UserTool.shared.user_token as AnyObject?
        
        SSNetworkTool.SSMine.request_getOwnerUserMsg(params: params, success: {[weak self] (response) in
            
            guard let weakSelf = self else {return}
            
            if let model = LoginUserModel.deserialize(from: response, designatedPath: "data") {
                
                weakSelf.userModel = model
                
                UserTool.shared.user_name = model.proprietorRealname
                UserTool.shared.user_nickname = model.proprietorRealname
                UserTool.shared.user_avatars = model.avatar
                UserTool.shared.user_company = model.proprietorCompany
                UserTool.shared.user_job = model.proprietorJob
                UserTool.shared.user_sex = model.sex
                UserTool.shared.user_phone = model.phone
                UserTool.shared.user_wechat = model.wxId
                
                SSTool.invokeInMainThread {
                    weakSelf.headerView.ownerUserModel = model
                    weakSelf.reloadRCUserInfo()
                    weakSelf.idifyShowView()
                }
                
            }
            
            }, failure: {[weak self] (error) in
                self?.idifyShowView()

        }) {[weak self] (code, message) in
            
            self?.idifyShowView()
            //只有5000 提示给用户
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" {
                AppUtilities.makeToast(message)
            }
        }
    }
    
    //认证状态和引导显示 -
    //如果没有认证 - 显示弹框 -
    func idifyShowView() {
        
        ///身份类型0个人1企业2联合
        let identify: Int = userModel?.identityType ?? -1
        
        ///审核状态0待审核1审核通过2审核未通过
        let auditStatus: Int = userModel?.auditStatus ?? -1
        ///审核通过1不显示
        if auditStatus == 0 || auditStatus == 1 {
        }else {
            showIdifyAlertview(identify: identify)
        }
    }
    
    func showIdifyAlertview(identify: Int) {
        let alert = SureAlertView(frame: self.view.frame)
        var descString: String = ""
        if identify == 0 {
            descString = "您个人还没有完成，请先认证～"
        }else if identify == 1 {
            descString = "您企业还没有完成，请先认证～"
        }else if identify == 2 {
            descString = "您联合办公还没有完成，请先认证～"
        }else {
            descString = "您还没有完成，请先认证～"
        }
        alert.inputTFView.text = descString
        alert.ShowAlertView(withalertType: AlertType.AlertTypeVersionUpdate, message: "温馨提示", cancelButtonCallClick: {
            
        }) {
            
            ///点击跳转认证页面
            let vc = JHBaseWebViewController.init(protocalType: .ProtocalTypeIdentifyOwnerUrl)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    /*
     * 强制刷新用户信息
     * SDK 缓存操作
     * 1、刷新 SDK 缓存
     */
    func reloadRCUserInfo() {
        let info = RCUserInfo.init(userId: "\(UserTool.shared.user_uid ?? 0)\(UserTool.shared.user_id_type ?? 9)", name: UserTool.shared.user_name ?? "", portrait: UserTool.shared.user_avatars ?? "")
        RCIM.shared()?.refreshUserInfoCache(info, withUserId: "\(UserTool.shared.user_uid ?? 0)\(UserTool.shared.user_id_type ?? 9)")
    }
    
}

extension OwnerMineViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RenterMineCell.reuseIdentifierStr) as? RenterMineCell
        cell?.selectionStyle = .none
        cell?.ownerModel = typeSourceArray[indexPath.row]
        return cell ?? HouseListTableViewCell.init(frame: .zero)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return typeSourceArray.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return RenterMineCell.rowHeight()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch typeSourceArray[indexPath.row].type {
        case .OwnerMineTypeHelpAndFeedback:
            let vc = BaseWebViewController.init(protocalType: .ProtocalTypeHelpAndFeedbackUrl)
            vc.titleString = typeSourceArray[indexPath.row].getNameFormType(type: typeSourceArray[indexPath.row].type ?? OwnerMineType.OwnerMineTypeAboutus)
            self.navigationController?.pushViewController(vc, animated: true)
            
        case .OwnerMineTypeCusomers:
            AppUtilities.makeToast("正在开发中～")
            
        case .OwnerMineTypeRegisterAgent:
            let vc = BaseWebViewController.init(protocalType: .ProtocalTypeRegisterProtocol)
            vc.titleString = typeSourceArray[indexPath.row].getNameFormType(type: typeSourceArray[indexPath.row].type ?? OwnerMineType.OwnerMineTypeAboutus)
            self.navigationController?.pushViewController(vc, animated: true)
            
        case .OwnerMineTypeAboutus:
            let vc = BaseWebViewController.init(protocalType: .ProtocalTypeAboutUs)
            vc.titleString = typeSourceArray[indexPath.row].getNameFormType(type: typeSourceArray[indexPath.row].type ?? OwnerMineType.OwnerMineTypeAboutus)
            self.navigationController?.pushViewController(vc, animated: true)
            
        case .none:
            SSLog(typeSourceArray[indexPath.row].type)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 70
    }
}

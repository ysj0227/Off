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
    
    lazy var loginPCScanView: OwnerScanLoginInPCView = {
        let view = OwnerScanLoginInPCView(frame: self.view.frame)
        return view
    }()
    
    var userModel: LoginUserModel?
    
    var typeSourceArray:[OwnerMineConfigureModel] = {
        var arr = [OwnerMineConfigureModel]()
        //arr.append(OwnerMineConfigureModel.init(types: .OwnerMineTypeAuthority))
        arr.append(OwnerMineConfigureModel.init(types: .OwnerMineTypeHelpAndFeedback))
        arr.append(OwnerMineConfigureModel.init(types: .OwnerMineTypeCusomers))
        arr.append(OwnerMineConfigureModel.init(types: .OwnerMineTypeServiceAgent))
        arr.append(OwnerMineConfigureModel.init(types: .OwnerMineTypeRegisterAgent))
        arr.append(OwnerMineConfigureModel.init(types: .OwnerMineTypeRoleChange))
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
        requestUserMessage()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        ///移除房东弹框
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
        
        //如果已经点击过了 - 不展示版本更新
        if UserTool.shared.isCloseCancelVersionUpdate == true {
            juddgeIsLogin()
        }else {
            requestVersionUpdate()
        }
        
    }
    
    override func requestVersionUpdate() {
        
        SSNetworkTool.SSVersion.request_version(success: { [weak self] (response) in
            
            if let model = VersionModel.deserialize(from: response, designatedPath: "data") {
                self?.showUpdateAlertview(versionModel: model)
            }else {
                self?.juddgeIsLogin()
            }
            }, failure: {[weak self] (error) in
                self?.juddgeIsLogin()

        }) {[weak self] (code, message) in
            self?.juddgeIsLogin()

            //只有5000 提示给用户
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" {
                AppUtilities.makeToast(message)
            }
            
        }
        
    }
    
    //弹出版本更新弹框
    override func showUpdateAlertview(versionModel: VersionModel) {
        
        if UserTool.shared.isCloseCancelVersionUpdate == true {
            return
        }
        
        let alert = SureAlertView(frame: self.view.frame)
        alert.isHiddenVersionCancel = versionModel.force ?? false
        alert.ShowAlertView(withalertType: AlertType.AlertTypeVersionUpdate, title: "发现新版本", descMsg: versionModel.desc ?? "", cancelButtonCallClick: {[weak self] in
            UserTool.shared.isCloseCancelVersionUpdate = true
            self?.juddgeIsLogin()
            
        }) { [weak self] in
            UserTool.shared.isCloseCancelVersionUpdate = true
            if let url = URL(string: versionModel.uploadUrl ?? "") {
                if UIApplication.shared.canOpenURL(url) {
                    if #available(iOS 10, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler:nil)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            }
            self?.juddgeIsLogin()
        }
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
    
    ///跳转二维码页面页面
    func clickToQCode() {
        //设置扫码区域参数
        var style = LBXScanViewStyle()
        style.centerUpOffset = 44
        style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle.Inner
        style.photoframeLineW = 2
        style.photoframeAngleW = 18
        style.photoframeAngleH = 18
        style.isNeedShowRetangle = false

        style.anmiationStyle = LBXScanViewAnimationStyle.LineMove

        style.colorAngle = UIColor(red: 0.0/255, green: 200.0/255.0, blue: 20.0/255.0, alpha: 1.0)
        
        style.animationImage = UIImage(named: "CodeScan.bundle/qrcode_Scan_weixin_Line")
        
        
        let vc = LBXScanViewController()
        vc.scanStyle = style
        vc.isOpenInterestRect = true
        let nav = BaseNavigationViewController.init(rootViewController: vc)
        nav.modalPresentationStyle = .overFullScreen
        //TODO: 这块弹出要设置
        self.present(nav, animated: true, completion: nil)
    }
    
    //弹出pc登录框
    @objc func clickShowPCLogin() {
                
        loginPCScanView.ShowAlertView(cancelButtonCallClick: { [weak self] in
            

        }, sureButtonCallClick: { [weak self] in
            //跳转到扫一扫页面
                        
            self?.clickToQCode()
        })
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
        
        headerView.saoyisaoBtnClickBlock = { [weak self] in
            self?.clickShowPCLogin()
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
        
        SSNetworkTool.SSMine.request_getOwnerUserMsg(success: {[weak self] (response) in

            guard let weakSelf = self else {return}
            
            if let model = LoginUserModel.deserialize(from: response, designatedPath: "data") {
                
                weakSelf.userModel = model
                
                UserTool.shared.user_name = model.nickname
                UserTool.shared.user_nickname = model.nickname
                UserTool.shared.user_avatars = model.avatar
                UserTool.shared.user_sex = model.sex
                UserTool.shared.user_phone = model.phone
                UserTool.shared.user_wechat = model.wxId
                
                SSTool.invokeInMainThread {
                    weakSelf.headerView.ownerUserModel = model
                    weakSelf.reloadRCUserInfo()
                    weakSelf.tableView.reloadRows(at: [IndexPath.init(row: 0, section: 0)], with: .none)
                }
                
            }
            
            }, failure: { (error) in
                
        }) { (code, message) in
            
            //只有5000 提示给用户
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" {
                AppUtilities.makeToast(message)
            }
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
    
    ///切换身份ui
    func roleChangeClick() {
        
        let alert = SureAlertView(frame: self.view.frame)
        var aelrtMsg: String = ""
        if UserTool.shared.user_id_type == 0 {
            
            aelrtMsg = "是否确认切换为房东？"
            
            ///租户切换成房东
            SensorsAnalyticsFunc.tenant_to_owner()
            
        }else if UserTool.shared.user_id_type == 1 {
            
            aelrtMsg = "是否确认切换为租户？"
            
            ///房东切换成租户
            SensorsAnalyticsFunc.owne_to_tenant()
        }
        alert.ShowAlertView(withalertType: AlertType.AlertTypeMessageAlert, title: "温馨提示", descMsg: aelrtMsg, cancelButtonCallClick: {
            
        }) { [weak self] in
            
            self?.requestRoleChange()
        }
    }
    
    ///切换身份接口
    func requestRoleChange() {
        var params = [String:AnyObject]()
        if UserTool.shared.user_id_type == 0 {
            params["roleType"] = "1" as AnyObject?
        }else if UserTool.shared.user_id_type == 1 {
            params["roleType"] = "0" as AnyObject?
        }
        params["token"] = UserTool.shared.user_token as AnyObject?

        SSNetworkTool.SSMine.request_roleChange(params: params, success: { (response) in
            if let model = LoginModel.deserialize(from: response, designatedPath: "data") {
                UserTool.shared.user_id_type = model.rid
                UserTool.shared.user_rongyuntoken = model.rongyuntoken
                UserTool.shared.user_uid = model.uid
                UserTool.shared.user_token = model.token
                UserTool.shared.user_avatars = model.avatar
                UserTool.shared.user_name = model.nickName
                UserTool.shared.synchronize()
                NotificationCenter.default.post(name: NSNotification.Name.UserRoleChange, object: nil)
            }
        }, failure: {[weak self] (error) in
                

        }) {[weak self] (code, message) in
            //只有5000 提示给用户
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" {
                AppUtilities.makeToast(message)
            }
        }
        
        
    }
}

extension OwnerMineViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RenterMineCell.reuseIdentifierStr) as? RenterMineCell
        cell?.selectionStyle = .none
        cell?.userModel = userModel
        cell?.ownerModel = typeSourceArray[indexPath.row]
        return cell ?? HouseListTableViewCell.init(frame: .zero)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return typeSourceArray.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch typeSourceArray[indexPath.row].type {
        
        case .OwnerMineTypeAuthority:
            return 0
            
        case .OwnerMineTypeHelpAndFeedback:
            return RenterMineCell.rowHeight()
            
        case .OwnerMineTypeCusomers:
            return RenterMineCell.rowHeight()
            
        case .OwnerMineTypeServiceAgent:
            return RenterMineCell.rowHeight()

        case .OwnerMineTypeRegisterAgent:
            return RenterMineCell.rowHeight()
            
        case .OwnerMineTypeAboutus:
            return RenterMineCell.rowHeight()
        
        case .OwnerMineTypeRoleChange:
            return RenterMineCell.rowHeight()
            
        case .none:
            return RenterMineCell.rowHeight()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch typeSourceArray[indexPath.row].type {
            
        case .OwnerMineTypeAuthority:
            
            let vc = BaseWebViewController.init(protocalType: .ProtocalTypeStaffListOwnerUrl)
            vc.titleString = typeSourceArray[indexPath.row].getNameFormType(type: typeSourceArray[indexPath.row].type ?? OwnerMineType.OwnerMineTypeAuthority)
            self.navigationController?.pushViewController(vc, animated: true)
            
        case .OwnerMineTypeHelpAndFeedback:
            let vc = BaseWebViewController.init(protocalType: .ProtocalTypeHelpAndFeedbackUrl)
            vc.titleString = typeSourceArray[indexPath.row].getNameFormType(type: typeSourceArray[indexPath.row].type ?? OwnerMineType.OwnerMineTypeHelpAndFeedback)
            self.navigationController?.pushViewController(vc, animated: true)
            
        case .OwnerMineTypeCusomers:
            let vc = RenterCustomersViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            
        case .OwnerMineTypeServiceAgent:
            let vc = BaseWebViewController.init(protocalType: .ProtocalTypeRegisterProtocol)
            vc.titleString = typeSourceArray[indexPath.row].getNameFormType(type: typeSourceArray[indexPath.row].type ?? OwnerMineType.OwnerMineTypeServiceAgent)
            self.navigationController?.pushViewController(vc, animated: true)
            
        case .OwnerMineTypeRegisterAgent:
            let vc = BaseWebViewController.init(protocalType: .ProtocalTypePrivacyProtocolUrl)
            vc.titleString = typeSourceArray[indexPath.row].getNameFormType(type: typeSourceArray[indexPath.row].type ?? OwnerMineType.OwnerMineTypeRegisterAgent)
            self.navigationController?.pushViewController(vc, animated: true)
            
        case .OwnerMineTypeAboutus:
            let vc = BaseWebViewController.init(protocalType: .ProtocalTypeAboutUs)
            vc.titleString = typeSourceArray[indexPath.row].getNameFormType(type: typeSourceArray[indexPath.row].type ?? OwnerMineType.OwnerMineTypeAboutus)
            self.navigationController?.pushViewController(vc, animated: true)
            
        case .OwnerMineTypeRoleChange:
            roleChangeClick()
            
        case .none:
            SSLog(typeSourceArray[indexPath.row].type)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 70
    }
}

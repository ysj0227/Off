//
//  RenterMineViewController.swift
//  OfficeGo
//
//  Created by mac on 2020/5/18.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit
import HandyJSON
import SwiftyJSON

class RenterMineViewController: BaseTableViewController {
    
    var userModel: LoginUserModel?
    
    var typeSourceArray:[RenterMineConfigureModel] = {
        var arr = [RenterMineConfigureModel]()
        //        arr.append(RenterMineConfigureModel.init(types: .RenterMineTypeIWanttoFind))
        arr.append(RenterMineConfigureModel.init(types: .RenterMineTypeHouseSchedule))
        arr.append(RenterMineConfigureModel.init(types: .RenterMineTypeHelpAndFeedback))
        arr.append(RenterMineConfigureModel.init(types: .RenterMineTypeCusomers))
        arr.append(RenterMineConfigureModel.init(types: .RenterMineTypeServiceAgent))
        arr.append(RenterMineConfigureModel.init(types: .RenterMineTypeRegisterAgent))
        arr.append(RenterMineConfigureModel.init(types: .RenterMineTypeAboutus))
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
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let tab = self.navigationController?.tabBarController as? RenterMainTabBarController
        tab?.customTabBar.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tab = self.navigationController?.tabBarController as? RenterMainTabBarController
        tab?.customTabBar.isHidden = false
        
        juddgeIsLogin()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}


extension RenterMineViewController {
    
    ///头像点击方法 - 判断有没有登录
    func headerViewClick() {
        if isLogin() == true {
            let vc = RenterUserMsgViewController()
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
    
    ///我的 - 看房行程 添加未登录状态
    func scheduleCellClick() {
        if isLogin() == true {
            let vc = RenterHouseScheduleViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }else {
            showLoginVC()
        }
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

extension RenterMineViewController {
    @objc func requestUserMessage() {
        var params = [String:AnyObject]()
        params["token"] = UserTool.shared.user_token as AnyObject?
        
        SSNetworkTool.SSMine.request_getRenterUserMsg(params: params, success: {[weak self] (response) in
            
            guard let weakSelf = self else {return}
            
            if let model = LoginUserModel.deserialize(from: response, designatedPath: "data") {
                
                weakSelf.userModel = model
                
                UserTool.shared.user_name = model.realname
                UserTool.shared.user_nickname = model.realname
                UserTool.shared.user_avatars = model.avatar
                UserTool.shared.user_company = model.company
                UserTool.shared.user_job = model.job
                UserTool.shared.user_sex = model.sex
                UserTool.shared.user_phone = model.phone
                UserTool.shared.user_wechat = model.wxId
                
                SSTool.invokeInMainThread {
                    weakSelf.headerView.userModel = model
                    weakSelf.reloadRCUserInfo()
                }
                
            }
            
            }, failure: {[weak self] (error) in
                
        }) {[weak self] (code, message) in
            
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
    
}

extension RenterMineViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RenterMineCell.reuseIdentifierStr) as? RenterMineCell
        cell?.selectionStyle = .none
        cell?.renterModel = typeSourceArray[indexPath.row]
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
        case .RenterMineTypeIWanttoFind:
            SSLog(typeSourceArray[indexPath.row].type)
        case .RenterMineTypeHouseSchedule:
            scheduleCellClick()
            
        case .RenterMineTypeHelpAndFeedback:
            let vc = BaseWebViewController.init(protocalType: .ProtocalTypeHelpAndFeedbackUrl)
            vc.titleString = typeSourceArray[indexPath.row].getNameFormType(type: typeSourceArray[indexPath.row].type ?? RenterMineType.RenterMineTypeHelpAndFeedback)
            self.navigationController?.pushViewController(vc, animated: true)
            
        case .RenterMineTypeCusomers:
            let vc = RenterCustomersViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case .RenterMineTypeServiceAgent:
            let vc = BaseWebViewController.init(protocalType: .ProtocalTypeRegisterProtocol)
            vc.titleString = typeSourceArray[indexPath.row].getNameFormType(type: typeSourceArray[indexPath.row].type ?? RenterMineType.RenterMineTypeServiceAgent)
            self.navigationController?.pushViewController(vc, animated: true)
        case .RenterMineTypeRegisterAgent:
            let vc = BaseWebViewController.init(protocalType: .ProtocalTypePrivacyProtocolUrl)
            vc.titleString = typeSourceArray[indexPath.row].getNameFormType(type: typeSourceArray[indexPath.row].type ?? RenterMineType.RenterMineTypeRegisterAgent)
            self.navigationController?.pushViewController(vc, animated: true)
            
        case .RenterMineTypeAboutus:
            let vc = BaseWebViewController.init(protocalType: .ProtocalTypeAboutUs)
            vc.titleString = typeSourceArray[indexPath.row].getNameFormType(type: typeSourceArray[indexPath.row].type ?? RenterMineType.RenterMineTypeAboutus)
            self.navigationController?.pushViewController(vc, animated: true)
            
        case .none:
            SSLog(typeSourceArray[indexPath.row].type)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 70
    }
}

//
//  OwnerHomeViewController.swift
//  OfficeGo
//
//  Created by mac on 2020/6/18.
//  Copyright © 2020 Senwei. All rights reserved.
//

import JavaScriptCore
import WebKit
import RxSwift
import RxCocoa
import SwiftyJSON

class OwnerHomeViewController: BaseViewController {
    
    var userModel: LoginUserModel?
    
    var fyWebview: JHBaseWebViewController?
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let tab = self.navigationController?.tabBarController as? OwnerMainTabBarController
        tab?.customTabBar.isHidden = true
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let tab = self.navigationController?.tabBarController as? OwnerMainTabBarController
        tab?.customTabBar.isHidden = false
        
        requestUserMessage()

    }
    
    func addWebview() {
        ///身份类型0个人1企业2联合
        let identify: Int = userModel?.identityType ?? -1
        
        if self.view.subviews.contains(fyWebview?.view ?? UIView()) {
            
        }else {
            if identify == 2 {
                fyWebview = JHBaseWebViewController.init(protocalType: OwnerIdentifyOrFYType.ProtocalTypeFYJointOwnerUrl)
                
                self.view.addSubview(fyWebview?.view ?? UIView())

            }else {
                fyWebview = JHBaseWebViewController.init(protocalType: OwnerIdentifyOrFYType.ProtocalTypeFYBuildingOwnerUrl)
                self.view.addSubview(fyWebview?.view ?? UIView())
            }
            fyWebview?.view.snp.makeConstraints({ (make) in
                make.top.leading.trailing.equalToSuperview()
                make.bottom.equalToSuperview().offset(-kTabBarHeight)
            })
            fyWebview?.webView?.snp.remakeConstraints({ (make) in
                make.top.bottom.leading.trailing.equalToSuperview()
            })
        }
    }
    
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
                //显示房源管理
            addWebview()
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
}

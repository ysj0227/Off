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
    
    lazy var loginPCScanView: OwnerScanLoginInPCView = {
        let view = OwnerScanLoginInPCView(frame: self.view.frame)
        return view
    }()
    
    lazy var loginPCScanBtn: UIButton = {
        let view = UIButton(frame: CGRect.init(x: self.view.width - 80, y: kHeight - kTabBarHeight - 80, width: 80, height: 80))
        view.setImage(UIImage.init(named: "QScanBlue"), for: .normal)
        view.isHidden = true
        view.addTarget(self, action: #selector(clickShowPCLogin), for: .touchUpInside)
        return view
    }()
    
    
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
    
    deinit {
        //消失的时候清空缓存
        fyWebview?.clearCache()
        fyWebview = nil
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        ///移除房东弹框
        SureAlertView.Remove()        
    }
    
    override func viewDidLoad() {
        
        self.view.backgroundColor = kAppWhiteColor
        
        //点击下面的tabbar的时候的判断
        NotificationCenter.default.addObserver(self, selector: #selector(clearCache), name: NSNotification.Name.OwnerClearFYManagerCache, object: nil)

    }
    
    @objc func clearCache() {
        let tab = self.navigationController?.tabBarController as? OwnerMainTabBarController
        
        if tab?.selectedIndex == 0 {
            fyWebview?.loadWebview()
        }else {
            fyWebview?.clearCache()
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
        
        loginPCScanBtn.isHidden = true
        
        loginPCScanView.ShowAlertView(cancelButtonCallClick: { [weak self] in
            
            self?.loginPCScanBtn.isHidden = false

        }, sureButtonCallClick: { [weak self] in
            //跳转到扫一扫页面
            
            self?.loginPCScanBtn.isHidden = false
            
            self?.clickToQCode()
        })
    }
    
    //展示在pc登录的弹框
    func showPCScanLoginView() {

        if UserTool.shared.isShowPCScanLogin != true {
                    
            loginPCScanView.ShowAlertView(cancelButtonCallClick: { [weak self] in
                
                self?.loginPCScanBtn.isHidden = false
            }, sureButtonCallClick: { [weak self] in
                //跳转到扫一扫页面
                
                self?.loginPCScanBtn.isHidden = false
                
                self?.clickToQCode()
            })
        }else {
            loginPCScanBtn.isHidden = false
        }

    }
    
    func addWebview() {
        
        showPCScanLoginView()
        
        ///身份类型0个人1企业2联合
        let identify: Int = userModel?.identityType ?? -1
        
        if self.view.subviews.contains(fyWebview?.view ?? UIView()) {
            
        }else {
            if identify == 2 {
                fyWebview = JHBaseWebViewController.init(protocalType: OwnerIdentifyOrFYType.ProtocalTypeFYJointOwnerUrl)
                
                self.view.addSubview(fyWebview?.view ?? UIView())
                
                self.view.addSubview(loginPCScanBtn)
                
            }else {
                fyWebview = JHBaseWebViewController.init(protocalType: OwnerIdentifyOrFYType.ProtocalTypeFYBuildingOwnerUrl)
                self.view.addSubview(fyWebview?.view ?? UIView())
                
                self.view.addSubview(loginPCScanBtn)
            }
            fyWebview?.view.snp.makeConstraints({ (make) in
                make.top.leading.trailing.equalToSuperview()
                make.bottom.equalToSuperview().offset(-kTabBarHeight)
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
            
            }, failure: { (error) in
                
        }) { (code, message) in
            
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
        
        ///审核状态0待审核1审核通过2审核未通过-1未审核
        let auditStatus: Int = userModel?.auditStatus ?? -1
        ///审核通过1不显示
        if auditStatus == 0 || auditStatus == 1 {
            addWebview()
        }else {
            showIdifyAlertview(identify: identify, auditStatus: auditStatus, remark: userModel?.remark ?? "")
        }
    }
    
    func showIdifyAlertview(identify: Int, auditStatus: Int, remark: String) {

        if auditStatus == -1 {
            
            ///点击跳转认证页面
            let vc = OwnerIdenfySelectVC()
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if auditStatus == 2 || auditStatus == 3 {
            
            let alert = SureAlertView(frame: self.view.frame)
            let titleString = "审核未通过"
            let descString = remark
            alert.messageLabel.textAlignment = .center
            alert.bottomBtnView.rightSelectBtn.setTitle("去认证", for: .normal)
            alert.ShowAlertView(withalertType: AlertType.AlertTypeMessageAlert, title: titleString, descMsg: descString, cancelButtonCallClick: {
                
            }) { [weak self] in
                
                guard let weakSelf = self else {return}

                weakSelf.identifyVCClick(auditStatus: auditStatus, identify: identify)
            }
        }
        
    }
    
    func identifyVCClick(auditStatus: Int, identify: Int) {
        ///审核状态0待审核1审核通过2审核未通过 3过期，当驳回2处理 - 没有提交过为-1
        //未审核
        if auditStatus == -1 {
                            
            ///点击跳转认证页面
            let vc = OwnerIdenfySelectVC()
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if auditStatus == 2 || auditStatus == 3 {
            
            UserTool.shared.user_owner_identifytype = identify
            
            ///点击跳转认证页面
            let vc = OwnerIdenfySelectVC()
            self.navigationController?.pushViewController(vc, animated: false)
            
            if identify == 1 {
                let vc = OwnerCompanyIeditnfyVC()
                vc.isFromPersonalVc = true
                self.navigationController?.pushViewController(vc, animated: false)
            }else if identify == 2 {
                ///点击跳转认证页面
                let vc = OwnerJointIeditnfyVC()
                vc.isFromPersonalVc = true
                self.navigationController?.pushViewController(vc, animated: false)
            }else if identify == 0 {
                ///点击跳转认证页面
                let vc = OwnerPersonalIeditnfyVC()
                vc.isFromPersonalVc = true
                self.navigationController?.pushViewController(vc, animated: false)
            }
        }
    }
}

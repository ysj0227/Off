//
//  AppDelegate.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/4/26.
//  Copyright © 2020 Senwei. All rights reserved.
//

//提交token a3deb41aa4f2952fbb22feae2271b9d5987c47a7

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WXApiDelegate {
    var window: UIWindow?
    
    static func shared() -> AppDelegate {
        return UIApplication.shared.delegate as? AppDelegate ?? AppDelegate()
    }
    
    func listenNetworkStatus() {
        NetAlamofireReachability.shared.start()
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        InstallCocoaDebug()
        window = UIWindow.init(frame: UIScreen.main.bounds)
        
        window?.makeKeyAndVisible()
        
        //        self.networkReachabilityStatus()
        
        setUpSDKs()
        
        notifyObserve()
        
        runTabBarViewController()
        
        listenNetworkStatus()
        
        return true
    }
    
    func notifyObserve() {
        //登录失效 - 5009
        NotificationCenter.default.addObserver(self, selector: #selector(loginResignEffect), name: NSNotification.Name.LoginResignEffect, object: nil)
        
        //设置tabar - 租户
        NotificationCenter.default.addObserver(self, selector: #selector(setRenterTabar), name: NSNotification.Name.SetRenterTabbarViewController, object: nil)
        //登录成功通知 - 只设置登录融云
        NotificationCenter.default.addObserver(self, selector: #selector(loginSuccess), name: NSNotification.Name.UserLogined, object: nil)
     
        //切换身份
        NotificationCenter.default.addObserver(self, selector: #selector(roleChange), name: NSNotification.Name.UserRoleChange, object: nil)
        
        
        ///设置tabar - 业主
        NotificationCenter.default.addObserver(self, selector: #selector(setOwnerTabar), name: NSNotification.Name.SetOwnerTabbarViewController, object: nil)
        
        //退出登录 - 只有业主
             NotificationCenter.default.addObserver(self, selector: #selector(logout), name: NSNotification.Name.OwnerUserLogout, object: nil)
    }
    
    //9.0
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let result = WXApi.handleOpen(url, delegate: self)
        return result
    }
    
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        let result = WXApi.handleOpen(url, delegate: self)
        return result
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        return WXApi.handleOpenUniversalLink(userActivity, delegate: self)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }
    
    func onReq(_ req: BaseReq) {
        
    }
    
    func onResp(_ resp: BaseResp) {
        
    }
    
    //设置tabbar - 租户
    @objc func setRenterTabar(){
        
        //0:租户,1:业主,9:其他
        if UserTool.shared.user_id_type == 0 {
            //不清空身份类型
            let tabbarVC = RenterMainTabBarController()
            window?.rootViewController = tabbarVC
        }
    }
    //设置tabbar - 业主
    @objc func setOwnerTabar(){
        
        //0:租户,1:业主,9:其他
        if UserTool.shared.user_id_type == 1 {
            //不清空身份类型
            let tabbarVC = OwnerMainTabBarController()
            tabbarVC.selectedIndex = 3
            window?.rootViewController = tabbarVC
        }
        
    }
    //退出登录
    @objc func logout(){
        
        //不清空身份类型
        UserTool.shared.removeAll()
        
        setLoginVC()
        
    }
    
    @objc func setLoginVC() {
        let loginvc = RenterLoginViewController()
        loginvc.titleview?.leftButton.isHidden = true
        let loginNav = BaseNavigationViewController.init(rootViewController: loginvc)
        loginNav.navigationBar.isHidden = true
        window?.rootViewController = loginNav
    }
    
    //切换身份 - 设置里边 - 切换身份字段 - 重新设置tabbar
    @objc func roleChange(){
        
        //登录融云
        loginRongCloud()
        
        if UserTool.shared.user_id_type == 0 {
            
            setRenterTabar()
            
        }else if UserTool.shared.user_id_type == 1 {
            
            setOwnerTabar()
        }
    }
    
    
    //登录成功 - 登录融云
    @objc func loginSuccess(){
        
        //登录融云
        loginRongCloud()
    }
    
    func runTabBarViewController() -> Void {
        
        //0:租户,1:业主,9:其他
        if UserTool.shared.user_id_type == 0 {
            
            //登录 -
            if UserTool.shared.isLogin() == true {
                
                //登录直接登录融云 -
                loginRongCloud()
                
                //然后设置tabbar
                setRenterTabar()
                
            }else {
                //然后设置tabbar
                setRenterTabar()
            }
            
        }else if UserTool.shared.user_id_type == 1 {
            //登录 -
            if UserTool.shared.isLogin() == true {
                
                //登录直接登录融云 -
                loginRongCloud()
                
                //然后设置tabbar
                setOwnerTabar()
                
            }else {
                //登录
                setLoginVC()
            }
        }else {
            let rolechangeVC = LoginRoleViewController()
            let rolechangeNav = BaseNavigationViewController.init(rootViewController: rolechangeVC)
            rolechangeNav.navigationBar.isHidden = true
            window?.rootViewController = rolechangeNav
            
        }
    }
    
    ///登录失效处理 - 5009
    @objc func loginResignEffect() {
        //退出登录 - 判断是业主还是租户
        //业主- 直接退出登录 -
        //租户- 返回个人中心 - 个人中心状态刷新为未登录
        /// role 角色 用户身份类型,,0:租户,1:业主,9:其他
        if UserTool.shared.user_id_type == 0 {
            //不清空身份类型
            UserTool.shared.removeAll()
            
            //不清空身份类型
            let tabbarVC = RenterMainTabBarController()
            tabbarVC.selectedIndex = 3
            window?.rootViewController = tabbarVC

        }else if UserTool.shared.user_id_type == 1 {
            //NotificationCenter.default.post(name: NSNotification.Name.OwnerUserLogout, object: nil)
            logout()
        }
        
    }
}


extension AppDelegate {
    
    //设置当前用户信息
    func setRCUserInfo(userId: String) {
        
        let info = RCUserInfo.init(userId: userId, name: UserTool.shared.user_name ?? "", portrait: UserTool.shared.user_avatars ?? "")
        
        RCIM.shared()?.currentUserInfo = info
        
        ///是否在发送的所有消息中携带当前登录的用户信息
        RCIM.shared()?.enableMessageAttachUserInfo = true
    }
    
    //登录融云账号  -  如果之前用户登录就直接登录， 否则在登录成功之后登录
    func loginRongCloud() {
        
        RCIM.shared()?.connect(withToken: UserTool.shared.user_rongyuntoken, success: {[weak self] (userid) in
            SSLog("登陆成功。当前登录的用户ID： \(String(describing: userid))")
            self?.setRCUserInfo(userId: userid ?? "0")
        }, error: { (code) in
            SSLog("登陆的错误码为\(code)")
        }, tokenIncorrect: {[weak self] in
            //token过期或者不正确。
            //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
            //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
            SSLog("token错误")
            //TODO: 融云token错误 测试提示
            self?.refreshIMTokenAndReconnect()
        })
    }
    
    //token不对，重新获取token - 融云连接
    func refreshIMTokenAndReconnect() {
        
        var params = [String:AnyObject]()

        params["token"] = UserTool.shared.user_token as AnyObject?
        
        SSNetworkTool.SSChat.request_getRongYunToken(params: params, success: {[weak self] (response) in
            
            guard let weakSelf = self else {return}
                    
            if let rctoken = response["data"] {
                UserTool.shared.user_rongyuntoken = rctoken as? String
                RCIM.shared()?.connect(withToken: UserTool.shared.user_rongyuntoken, success: {[weak self] (userid) in
                    SSLog("登陆成功。当前登录的用户ID： \(String(describing: userid))")
                    self?.setRCUserInfo(userId: userid ?? "0")
                }, error: { (code) in
                    SSLog("登陆的错误码为\(code)")
                }, tokenIncorrect: {[weak self] in
                    SSLog("token错误")
                })
            }
                        
            }, failure: { (error) in
                
        }) { (code, message) in
            
            
        }
    }
    
    func setUpSDKs() {
        
        WXApi.registerApp(AppKey.WeChatAppId, universalLink: AppKey.UniversalLink)
        
        //键盘弹出sdk集成
        IQKeyboardManager.shared.enable = true
        
        
        //融云集成初始化 -
        RCIM.shared()?.initWithAppKey(AppKey.RCAppKey)
        
        //设置消息监听
        RCIM.shared().receiveMessageDelegate = self
        
        //通知声音的开发
        RCIM.shared()?.disableMessageAlertSound = false
        
        //设置连接状态监听
        RCIM.shared()?.connectionStatusDelegate = self
        
        ///是否将用户信息和群组信息在本地持久化存储
        RCIM.shared()?.enablePersistentUserInfoCache = true
        
        //没懂什么意思Mark Mark
        RCIM.shared()?.userInfoDataSource = RCDUserService.shared
        //        RCIM.shared()?.userInfoDataSource = self
        
        //注册自定义消息
        //交换手机
        RCIM.shared()?.registerMessageType(PhoneExchangeMessage.self)
        
        //交换微信
        RCIM.shared()?.registerMessageType(WechatExchangeMessage.self)
        
        //约看房源
        RCIM.shared()?.registerMessageType(ScheduleViewingMessage.self)
        
        //交换手机状态
        RCIM.shared()?.registerMessageType(PhoneExchangeStatusMessage.self)
        
        //交换微信状态
        RCIM.shared()?.registerMessageType(WechatExchangeStatusMessage.self)
        
        //约看房源
        RCIM.shared()?.registerMessageType(ScheduleViewingStatusMessage.self)
        
        //房源信息
        RCIM.shared()?.registerMessageType(FangyuanInsertFYMessage.self)
        
    }
    
    func showLogotAlertview() {
        let alert = SureAlertView(frame: window?.frame ?? CGRect.zero)
        alert.ShowAlertView(withalertType: AlertType.AlertTypeMessageAlert, title: "温馨提示", descMsg: "您的账号在别的设备上登录了，是否重连", cancelButtonCallClick: {[weak self] in
            
            //TOOD: 怎么操作
            self?.logout()
        }) {[weak self] in
            
            self?.loginRongCloud()
        }
    }
}



//设置消息监听
//当 SDK 在接收到消息时，开发者可通过下面方法进行处理。 SDK 会通过此方法接收包含 单聊、群聊、聊天室、系统 类型的所有消息，开发者只需全局设置一次即可，多次设置会导致其他代理失效。实现此功能需要开发者遵守 RCIMReceiveMessageDelegate 协议。
extension AppDelegate: RCIMReceiveMessageDelegate {
    func onRCIMReceive(_ message: RCMessage!, left: Int32) {
        
    }
    
    
}

//设置状态监听
//当 SDK 与融云服务器的连接状态发生变化时，开发者可通过下面方法进行处理。实现此功能需要开发者遵守 RCIMConnectionStatusDelegate 协议。
extension AppDelegate: RCIMConnectionStatusDelegate {
    func onRCIMConnectionStatusChanged(_ status: RCConnectionStatus) {
        
        //SDK 与融云服务器的连接状态
        if status == RCConnectionStatus.ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT {
//            AppUtilities.makeToast("您的账号在别的设备上登录了")
            showLogotAlertview()
            
        }else if status == RCConnectionStatus.ConnectionStatus_TOKEN_INCORRECT {
            AppUtilities.makeToast("您的token不对")
            ///退出到登录
            logout()
        }
        
    }
    
}

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
    
    //app关闭的时候 调用的方法
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        InstallCocoaDebug()
        window = UIWindow.init(frame: UIScreen.main.bounds)
        
        window?.makeKeyAndVisible()
        
        //每次启动，如果有版本更新只显示一次
        UserTool.shared.isCloseCancelVersionUpdate = false
        
        //        self.networkReachabilityStatus()
        
        configSealTalkWithApp(application, launchOptions: launchOptions)

        setUpSDKs()
        
        notifyObserve()
        
        runTabBarViewController()
        
        setStaticGuidePage()
        
        listenNetworkStatus()
     
        // 远程推送的内容
        let remote = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] as? Dictionary<String,Any>;
       // 如果remote不为空，就代表应用在未打开的时候收到了推送消息
       if remote != nil {
        //收到推送消息实现的方法
        let msgDic = remote?["rc"] as! [String: String]
        //PR
        let cType: String = msgDic["cType"] ?? ""
        //3251
        let fId: String = msgDic["fId"] ?? ""
        //RC:TxtMsg
        let oName: String = msgDic["oName"] ?? ""
        let targetId: String = msgDic["tId"] ?? ""
        
        /*
         cType根据得到字段转换成相应的conversationType
         其余信息可根据需求进行相应的操作
         */
        let vc = RenterChatViewController()
        vc.conversationType = .ConversationType_PRIVATE
        vc.targetId = targetId
        vc.displayUserNameInCell = false
        
        let tab = self.window?.rootViewController as? RenterMainTabBarController
        tab?.selectedIndex = 1
        tab?.customTabBar.isHidden = false
        let nsv = (tab?.viewControllers?[1]) as! BaseNavigationViewController as BaseNavigationViewController
        nsv.pushViewController(vc, animated: true)
       }
        SSLog("远端 - userInfo----\(remote)")
//

        
        return true
    }
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        application.registerForRemoteNotifications()
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { (c) -> String in
            return String(format: "%02.2hhx", c)}.joined()

        print(token);
//        let token = String(data: deviceToken, encoding: .utf8)?.replacingOccurrences(of: "[<>]", with: "", options: String.CompareOptions.regularExpression, range: nil)
        RCIMClient.shared()?.setDeviceToken(token)
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("didFailToRegisterForRemoteNotificationsWithError---\(error)")
    }
    func configSealTalkWithApp(_ application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {

        /**
         * 推送处理 1
         */
        registerRemoteNotification(application)

        /**
         * 统计推送，并获取融云推送服务扩展字段
         */
        //(launchOptions: launchOptions)
    }

    /**
     * 推送处理 1
     */
    func registerRemoteNotification(_ application: UIApplication) {
        /**
        *  推送说明：
        *
        我们在知识库里还有推送调试页面加了很多说明，当遇到推送问题时可以去知识库里搜索还有查看推送测试页面的说明。
        *
        首先必须设置deviceToken，可以搜索本文件关键字“推送处理”。模拟器是无法获取devicetoken，也就没有推送功能。
        *
        当使用"开发／测试环境"的appkey测试推送时，必须用Development的证书打包，并且在后台上传"开发／测试环境"的推送证书，证书必须是development的。
        当使用"生产／线上环境"的appkey测试推送时，必须用Distribution的证书打包，并且在后台上传"生产／线上环境"的推送证书，证书必须是distribution的。
        */
//        if application.responds(to: #selector(UIApplication.registerUserNotificationSettings(_:))) {
//            let notificationTypes: UIUserNotificationType = [.badge, .sound, .alert]
//            let settings = UIUserNotificationSettings(types: notificationTypes, categories: nil)
//            application.registerUserNotificationSettings(settings)
//        }else {
//            let notificationTypes: UIRemoteNotificationType = [.badge, .sound, .alert]
//            application.registerForRemoteNotifications(matching: notificationTypes)
//        }
        
        if application.responds(to: #selector(UIApplication.registerUserNotificationSettings(_:))) {
            let notificationTypes: UIUserNotificationType = [.badge, .sound, .alert]
            let settings = UIUserNotificationSettings(types: notificationTypes, categories: nil)
            application.registerUserNotificationSettings(settings)
        }
    }

    /**
     * 统计推送，并获取融云推送服务扩展字段
     */
//    func recordLaunchOptions(launchOptions: [UIApplication.LaunchOptionsKey: Any]?){
//        RCIMClient.shared()?.recordLaunchOptionsEvent(launchOptions)
//
//        let pushServiceData = (RCIMClient.shared()?.getPushExtra(fromLaunchOptions: launchOptions))! as! [String : Any]
////
////        if pushServiceData != nil {
////            SSLog("该启动事件包含来自融云的推送服务")
////            for key in pushServiceData.keys {
////                SSLog("key -- \(key)")
////            }
////        }else {
////            SSLog("该启动事件不包含来自融云的推送服务")
////        }
////
//        let remoteNotificationUserInfo = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification]
//        if remoteNotificationUserInfo != nil {
//            NSLog("remoteNotificationUserInfo 远程推送原始内容为 \(remoteNotificationUserInfo)")
//        }
//
//    }
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
                    weakSelf.setRCUserInfo(userId: userid ?? "0")
                    }, error: { (code) in
                        SSLog("登陆的错误码为\(code)")
                }, tokenIncorrect: {
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
        RCIM.shared()?.receiveMessageDelegate = self
        
        //通知声音的开发
        RCIM.shared()?.disableMessageAlertSound = false
        
        //设置连接状态监听
        RCIM.shared()?.connectionStatusDelegate = self
        
        ///是否将用户信息和群组信息在本地持久化存储
        RCIM.shared()?.enablePersistentUserInfoCache = true
        
        //没懂什么意思Mark Mark
        RCIM.shared()?.userInfoDataSource = RCDUserService.shared
        //        RCIM.shared()?.userInfoDataSource = self
        
        RCIM.shared()?.disableMessageAlertSound = false
        
        RCIM.shared()?.disableMessageNotificaiton = false
        
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
        
        //加入公司
        RCIM.shared()?.registerMessageType(ApplyEnterCompanyOrBranchMessage.self)
        
        //加入公司状态
        RCIM.shared()?.registerMessageType(ApplyEnterCompanyOrBranchStatusMessage.self)

    }
    
    func showLogotAlertview() {
        let alert = SureAlertView(frame: window?.frame ?? CGRect.zero)
        alert.bottomBtnView.rightSelectBtn.setTitle("登录", for: .normal)
        alert.ShowAlertView(withalertType: AlertType.AlertTypeMessageAlert, title: "你的账号已在其他设备上登录，是否重新登录", descMsg: "如果不是你的操作，请尽快修改密码", cancelButtonCallClick: {[weak self] in
            
            //TOOD: 怎么操作
            self?.logout()
        }) {[weak self] in
            
            self?.loginRongCloud()
        }
    }
    
    // MARK: - 静态图片引导页
    func setStaticGuidePage() {
        if UserTool.shared.isShowGuide != true {
            let imageNameArray: [String] = ["guide1", "guide2", "guide3", "guide4"]
            let guideView = HHGuidePageHUD.init(imageNameArray: imageNameArray, isHiddenSkipButton: false)
            window?.addSubview(guideView)
        }else {
            
        }
    }

}

extension AppDelegate {
    
    
    ///当返回值为 NO 时，SDK 会弹出默认的本地通知提示；当返回值为 YES 时，SDK 针对此消息不再弹本地通知提示
    func onRCIMCustomLocalNotification(_ message: RCMessage!, withSenderName senderName: String!) -> Bool {
        return false
    }
    
    //远端
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        let msgDic = userInfo["rc"] as! [String: String]
        //PR
        let cType: String = msgDic["cType"] ?? ""
        //3251
        let fId: String = msgDic["fId"] ?? ""
        //RC:TxtMsg
        let oName: String = msgDic["oName"] ?? ""
        let targetId: String = msgDic["tId"] ?? ""

        /*
        cType根据得到字段转换成相应的conversationType
        其余信息可根据需求进行相应的操作
        */
        let vc = RenterChatViewController()
        vc.conversationType = .ConversationType_PRIVATE
        vc.targetId = targetId
        vc.displayUserNameInCell = false
        
        let tab = self.window?.rootViewController as? RenterMainTabBarController
        tab?.selectedIndex = 1
        tab?.customTabBar.isHidden = false
        let nsv = (tab?.viewControllers?[1]) as! BaseNavigationViewController as BaseNavigationViewController
        nsv.pushViewController(vc, animated: true)
    }
    
    ///app打开
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        
        let msgDic = (notification.userInfo?["rc"] ?? []) as! [String: String]
        //PR
        let cType: String = msgDic["cType"] ?? ""
        //3251
        let fId: String = msgDic["fId"] ?? ""
        //RC:TxtMsg
        let oName: String = msgDic["oName"] ?? ""
        let targetId: String = msgDic["tId"] ?? ""

        /*
        cType根据得到字段转换成相应的conversationType
        其余信息可根据需求进行相应的操作
        */
        let vc = RenterChatViewController()
        vc.conversationType = .ConversationType_PRIVATE
        vc.targetId = targetId
        vc.displayUserNameInCell = false
        
        let tab = self.window?.rootViewController as? RenterMainTabBarController
        tab?.selectedIndex = 1
        tab?.customTabBar.isHidden = false
        let nsv = (tab?.viewControllers?[1]) as! BaseNavigationViewController as BaseNavigationViewController
        nsv.pushViewController(vc, animated: true)
    }
}

extension AppDelegate: RCIMReceiveMessageDelegate {
    /*!
    IMKit消息接收的监听器

    @warning 如果您使用IMKit，可以设置并实现此Delegate监听消息接收；
    如果您使用IMLib，请使用RCIMClient中的RCIMClientReceiveMessageDelegate监听消息接收，而不要使用此方法。
    */
    func onRCIMReceive(_ message: RCMessage!, left: Int32) {
        SSLog("onReceived------left-IMKit-\(left)")
    }
}

//设置消息监听
//当 SDK 在接收到消息时，开发者可通过下面方法进行处理。 SDK 会通过此方法接收包含 单聊、群聊、聊天室、系统 类型的所有消息，开发者只需全局设置一次即可，多次设置会导致其他代理失效。实现此功能需要开发者遵守 RCIMReceiveMessageDelegate 协议。
//IMLib
extension AppDelegate: RCIMClientReceiveMessageDelegate {
    func onReceived(_ message: RCMessage!, left nLeft: Int32, object: Any!) {
        SSLog("onReceived------left--\(nLeft)")
    }
    
    func onReceived(_ message: RCMessage!, left nLeft: Int32, object: Any!, offline: Bool, hasPackage: Bool) {
        SSLog("onReceived------left--\(nLeft)--offline--\(offline)")
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

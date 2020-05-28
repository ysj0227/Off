//
//  AppDelegate.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/4/26.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    //    var reachable: NetworkReachabilityManager.NetworkReachabilityStatus? {
    //        didSet {
    //            if oldValue == reachable {
    //                return
    //            }
    //            NotificationCenter.default.post(name: Notification.Name.networkStatusChanged, object: nil)
    //        }
    //    }
    //    var isReachable: Bool? {
    //        get {
    //            if let reachable = reachable {
    //                switch reachable {
    //                case .notReachable:
    //                    return false
    //                case .unknown:
    //                    return nil
    //                default:
    //                    return true
    //                }
    //            } else {
    //                return nil
    //            }
    //        }
    //    }
    //
    //    let net = NetworkReachabilityManager()
    
    var navigationController: BaseNavigationViewController?
    
    static func shared() -> AppDelegate {
        return UIApplication.shared.delegate as? AppDelegate ?? AppDelegate()
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow.init(frame: UIScreen.main.bounds)
        
        window?.makeKeyAndVisible()
        
        //        self.networkReachabilityStatus()
//        UserTool.shared.user_phone = "18567111111"
        UserTool.shared.user_phone = "18567200200"

        setUpSDKs()
        
        notifyObserve()
        
        runTabBarViewController()
        
        return true
    }
    
    func notifyObserve() {
        //登录成功通知
        NotificationCenter.default.addObserver(self, selector: #selector(loginSuccess), name: NSNotification.Name.UserLogined, object: nil)
        //退出登录
        NotificationCenter.default.addObserver(self, selector: #selector(logout), name: NSNotification.Name.UserLogout, object: nil)
        //切换身份
        NotificationCenter.default.addObserver(self, selector: #selector(roleChange), name: NSNotification.Name.UserRoleChange, object: nil)
    }
    
    //9.0
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
        let result = UMSocialManager.default()?.handleOpen(url, options: options) ?? false
        if !result {
            //其他sdk的回调
        }
        return result
    }
    
    //退出登录
    @objc func logout(){
        
        //不清空身份类型
        UserTool.shared.removeAll()
        let tabbarVC = MainTabBarController()
        window?.rootViewController = tabbarVC
    }
    
    //切换身份
    @objc func roleChange(){
        
        UserTool.shared.removeAll()
        let tabbarVC = MainTabBarController()
        window?.rootViewController = tabbarVC
    }
    
    
    //登录成功 - 登录融云 - 设置tabbar
    @objc func loginSuccess(){
        loginRongCloud()
        let tabbarVC = MainTabBarController()
        window?.rootViewController = tabbarVC
//        //跳到tabbat之前判断是否是登录
//        if UserTool.shared.isLogin() == true {
//
////            loginRongCloud()
//
//        }else {
//            let tabbarVC = MainTabBarController()
//            window?.rootViewController = tabbarVC
//        }
    }
    
    //    func networkReachabilityStatus() {
    //        net?.listener = {[unowned self](status) in
    //            self.reachable = status
    //        }
    //        net?.startListening()
    //        reachable = net?.networkReachabilityStatus
    //    }
    
    func runTabBarViewController() -> Void {
        
        if UserTool.shared.isLogin() == true {
            //登录直接登录融云 - 然后设置tabbar
            loginRongCloud()
        }else {
            let rolechangeVC = LoginRoleViewController()
            navigationController = BaseNavigationViewController.init(rootViewController: rolechangeVC)
            navigationController?.navigationBar.isHidden = true
            window?.rootViewController = navigationController
            return
        }
        //        if !UserInfo.shared().isLogin() {
        //            let rolechangeVC = LoginRoleViewController()
        //            navigationController = BaseNavigationViewController.init(rootViewController: rolechangeVC)
        //            navigationController?.navigationBar.isHidden = true
        //            window?.rootViewController = navigationController
        //            return
        //        }else {
        //            //登录直接登录融云 - 然后设置tabbar
        //            loginRongCloud()
        //        }
    }
}


extension AppDelegate {
    
    //设置当前用户信息
    func setRCUserInfo() {
//        let info = RCUserInfo.init(userId: "11", name: "11", portrait: "https://img.officego.com.cn/house/1589973533713.png")
            let info = RCUserInfo.init(userId: "200", name: "200", portrait: "https://img.officego.com.cn/report/1590121741001.jpg")
        
        RCIM.shared()?.currentUserInfo = info
        
        ///是否在发送的所有消息中携带当前登录的用户信息
        RCIM.shared()?.enableMessageAttachUserInfo = true
    }
    
    //登录融云账号  -  如果之前用户登录就直接登录， 否则在登录成功之后登录
    func loginRongCloud() {
        
        RCIM.shared()?.connect(withToken: AppKey.rcToken, success: { (userid) in
            print("登陆成功。当前登录的用户ID： \(String(describing: userid))")
        }, error: { (code) in
            print("登陆的错误码为\(code)")
        }, tokenIncorrect: {
            //token过期或者不正确。
            //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
            //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
            print("token错误")
        })
        setRCUserInfo()
        let tabbarVC = MainTabBarController()
        window?.rootViewController = tabbarVC
    }
    
    func setUpSDKs() {
        
        //友盟设置 -
        UMSocialManager.default().openLog(true)
        UMConfigure.initWithAppkey(AppKey.UMKey, channel: "App Store")
        /* 设置微信的appKey和appSecret */
        UMSocialManager.default().setPlaform(.wechatSession, appKey: AppKey.WeChatAppId, appSecret: AppKey.WeChatAppSecret, redirectURL: "http://mobile.umeng.com/social")
        /*
         * 移除相应平台的分享，如微信收藏
         */
        //[[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
        UMSocialManager.default().setPlaform(.wechatTimeLine, appKey: AppKey.WeChatAppSecret, appSecret: AppKey.WeChatAppSecret, redirectURL: "http://mobile.umeng.com/social")
        /* 设置新浪的appKey和appSecret */
        UMSocialManager.default().setPlaform(.sina, appKey: AppKey.SinaAppkey, appSecret: AppKey.SinaAppSecret, redirectURL: "http://mobile.umeng.com/social")
        
        
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
        //        RCIM.shared()?.userInfoDataSource = RCDUserService.shared
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
        //        {
        //            if (status == ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT) {
        //                [self showAlert:RCDLocalizedString(@"alert")
        //                           message:RCDLocalizedString(@"accout_kicked")
        //                    cancelBtnTitle:RCDLocalizedString(@"i_know")];
        //                RCDLoginViewController *loginVC = [[RCDLoginViewController alloc] init];
        //                RCDNavigationViewController *_navi = [[RCDNavigationViewController alloc] initWithRootViewController:loginVC];
        //                self.window.rootViewController = _navi;
        //            } else if (status == ConnectionStatus_TOKEN_INCORRECT) {
        //                [RCDLoginManager getToken:^(BOOL success, NSString *_Nonnull token, NSString *_Nonnull userId) {
        //                    if (success) {
        //                        [[RCDIMService sharedService] connectWithToken:token
        //                            dbOpened:^(RCDBErrorCode code) {
        //                                NSLog(@"RCDBOpened %@", code ? @"failed" : @"success");
        //                            }
        //                            success:^(NSString *userId) {
        //
        //                            }
        //                            error:^(RCConnectErrorCode status) {
        //
        //                            }
        //                            tokenIncorrect:^{
        //
        //                            }];
        //                    }
        //                }];
        //            } else if (status == ConnectionStatus_DISCONN_EXCEPTION) {
        //                [self showAlert:RCDLocalizedString(@"alert")
        //                           message:RCDLocalizedString(@"Your_account_has_been_banned")
        //                    cancelBtnTitle:RCDLocalizedString(@"i_know")];
        //                [[RCIMClient sharedRCIMClient] disconnect];
        //                RCDLoginViewController *loginVC = [[RCDLoginViewController alloc] init];
        //                RCDNavigationViewController *_navi = [[RCDNavigationViewController alloc] initWithRootViewController:loginVC];
        //                self.window.rootViewController = _navi;
        //            }
        //        }
    }
    
}

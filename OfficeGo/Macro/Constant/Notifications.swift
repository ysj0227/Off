//
//  Notification.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/5/8.
//  Copyright © 2020 Senwei. All rights reserved.
//

import Foundation

extension Notification.Name {
    /// 网络状态通知
    public static let NetStatusChange = Notification.Name("NetStatusChange")
    /// 设置rootviewcontroller
    public static let SetTabbarViewController = Notification.Name("setTabbarViewController")
    /// 用户登录
    public static let UserLogined = Notification.Name("userLogined")
    /// 用户推出
    public static let UserLogout = Notification.Name("userLogout")
    /// 用户身份切换
    public static let UserRoleChange = Notification.Name("userRoleChange")
    /// 首页登录锁定通知
    public static let HomeBtnLocked = Notification.Name("homeBtnLocked")
    
    /// 首页筛选之后刷新列表通知
    public static let HomeSelectRefresh = Notification.Name("homeSelectRefresh")
    
    /// 详情页面 公交展开通知
    public static let TrafficUpOrDown = Notification.Name("trafficUpOrDown")
    
    /// 聊天页面 - 点击收藏按钮 通知
    public static let MsgCollectBtnLocked = Notification.Name("msgCollectBtnLocked")
    
    /// 聊天页面 - 约看房源预约成功通知
    public static let MsgScheduleSuccess = Notification.Name("msgScheduleSuccess")
    
    /// 聊天页面 -交换手机号 - 业主点击同意或拒绝
    public static let MsgExchangePhoneStatusBtnLocked = Notification.Name("msgExchangePhoneStatusBtnLocked")
    
    /// 聊天页面 -交换微信 - 业主点击同意或拒绝
    public static let MsgExchangeWechatStatusBtnLocked = Notification.Name("msgExchangeWechatStatusBtnLocked")
    
    /// 聊天页面 -越看房源 - 业主点击同意或拒绝
      public static let MsgViewingScheduleStatusBtnLocked = Notification.Name("msgViewingScheduleStatusBtnLocked")
    
    /// 聊天页面 - 自定义预约成功 - 点击查看预约详情按钮
    public static let MsgScheduleDetail = Notification.Name("msgScheduleDetail")
    
    /// 接口- 没登录的时候 - 弹出登录
    public static let NoLoginClickToLogin = Notification.Name("noLoginClickToLogin")
    
    
    public static let userChanged      = Notification.Name("kNotificationUserChanged")
    public static let inviteCodeBind   = Notification.Name("kNotificationCodeBind")
    public static let languageChanged  = Notification.Name("kNotificationLanguageChanged")
    public static let unreadChanged    = Notification.Name("kNotificationUnreadChanged")
    public static let openTreasureCheast    = Notification.Name("kNotificationOpenTreasureCheast")
    public static let walletChanged      = Notification.Name("kNotificationWalletChanged")
    public static let userCookieChanged  = Notification.Name("kNotificationUserCookieChanged")
    public static let networkStatusChanged  = Notification.Name("kNotificationNetworkStatusChanged")
    public static let youtubeCookieSaved  = Notification.Name("kNotificationYoutubeCookieSaved")
    public static let treasureCheastCanOpen  = Notification.Name("kNotificationTreasureCheastCanOpen")
    public static let blockVideo = Notification.Name("kNotificationBlockVideo")
    public static let editProfileSaved = Notification.Name("kNotificationEditProfileSaved")
    public static let postVideoFinished = Notification.Name("kNotificationPostVideoFinished")
    public static let forumCommentsChanged = Notification.Name("kNotificationForumCommentsChanged")
    
}


struct Notifications {
    
    static let FilterHideNotification = "FilterHideNotification"
    
    
    
    
    static let SearchEndNotification = "SearchEndNotification"
    
    static let HotConvertNotification = "HotConvertNotification"
    static let kHomeEventNotification = "kHomeEventNotification"
    
    static let DataLoadStatusNotification = "DataLoadStatusNotification"
    
}

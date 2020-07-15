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
    
    
    ///登录失效 - 5009
    public static let LoginResignEffect = Notification.Name("LoginResignEffect")

    
    /// 认证 - 通知
    /// 身份认证 - 业主 - 企业认证 - 加入公司申请的通知
    public static let OwnerApplyEnterCompany = Notification.Name("OwnerApplyEnterCompany")
    
    /// 身份认证 - 业主 - 企业认证 - 创建公司成功的通知
    public static let OwnerCreateCompany = Notification.Name("OwnerCreateCompany")
    
    /// 身份认证 - 业主 - 联合办公认证 - 加入网点申请的通知
    public static let OwnerApplyEnterCompanyJoint = Notification.Name("OwnerApplyEnterCompanyJoint")
    
    /// 身份认证 - 业主 - 联合办公认证 - 创建网点成功的通知
    public static let OwnerCreateCompanyJoint = Notification.Name("OwnerCreateCompanyJoint")
    
    
    
    /// 设置rootviewcontroller - 业主
       public static let SetOwnerTabbarViewController = Notification.Name("SetOwnerTabbarViewController")
    /// 用户退出 - 只有业主需要重新设置tabbar
    public static let OwnerUserLogout = Notification.Name("OwnerUserLogout")
    
    /// 清楚房源管理缓存 - 只有业主需要首页
    public static let OwnerClearFYManagerCache = Notification.Name("OwnerClearFYManagerCache")
    
    /// 设置rootviewcontroller - 租户
    public static let SetRenterTabbarViewController = Notification.Name("SetRenterTabbarViewController")
   
    /// 用户登录 - 只是用于更新融云token登录
    public static let UserLogined = Notification.Name("userLogined")

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

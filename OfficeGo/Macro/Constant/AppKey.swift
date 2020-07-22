//
//  AppKey.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/5/8.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

struct AppKey {
        
//    /// 极光
//    static let jpushAppKey = "71355408d75091c2524071d2"
//    static let jpushChannel = "Publish channel"
//    static let isProduction = true
    
    static let UMKey = "5ee885e8978eea085c5464c2"

    /// 微信appid
    static let WeChatAppId = "wx70ee9e90c1d62d83"
    static let WeChatAppSecret = "acfe3227435a5698455f81294a7b078e"
    
    /*
     服务器配置 - https://m.officego.com/apple-app-site-association
     分享 - 设置 https://www.jianshu.com/p/363a5e492c05
     设置universalURL
     teamid：USX7BAW69F
     bundleid：officego.com
     */
    static let UniversalLink = "https://m.officego.com/"
    
    static let SinaAppkey = "3921700954"
    static let SinaAppSecret = "04b48b094faeb16683c32669824ebdad"
    
    
    /// bugly
    static let buglyAppKey = "821d61983d"
    
    /// 融云AppKey
    
    #if DEBUG
    static let RCAppKey = "kj7swf8oknm02"
    static let RCAppSecret = "OF78PpILjjRk4"
    #else  //REALEASE
    static let RCAppKey = "qf3d5gbjq94mh"
    static let RCAppSecret = "xtDkNCjJse"
    #endif
    //模拟器
    
    static let InsertFYMessageTypeIdentifier = "og:insertfyinfo"
    static let PhoneExchangeMessageTypeIdentifier = "og:mobile"
    static let WechatExchangeMessageTypeIdentifier = "og:wx"
    static let ViewingDateExchangeMessageTypeIdentifier = "og:fy"
    static let ExchangePhoneStatusMessageTypeIdentifier = "og:exmobile"
    static let ExchangeWechatStatusMessageTypeIdentifier = "og:exwx"
    static let ExchangeViewingDateStatusMessageTypeIdentifier = "og:exfy"

    static let ApplyEnterCompanyOrBranchMessageTypeIdentifier = "og.applyjoin"
    static let ApplyEnterCompanyOrBranchStatusMessageTypeIdentifier = "og.applyjoinstatus"

}

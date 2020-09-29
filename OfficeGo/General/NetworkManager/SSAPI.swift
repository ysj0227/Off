//
//  SSAPI.swift
//  UUEnglish
//
//  Created by Aibo on 2018/3/27.
//  Copyright © 2018年 uuabc. All rights reserved.
//

import Foundation

@objcMembers class SSAPI: NSObject {
    
    enum AppBuildType: Int {
        case Dev
        case Test
        case Release
    }
    
    enum BackgroundServerType: Int {
        case SSApiHost
        case SSH5Host
        case SSWebHost
        case SensorsAnalyticsSDK
        case RCAppKey
        case RCAppSecret
    }
    
    // DEBUG 开发环境,供技术内部联调
    // TEST 测试环境，供测试在测试环境测试
    // UAT 预上线环境，供测试在仿生产环境测试
    // REALEASE or Tag 正式环境, REALEASE testflight上测试, Tag adhoc
    // 激光推送 App 是 ad-hoc 打包或者App Store 版本（发布证书 Production）https://docs.jiguang.cn/jpush/client/iOS/ios_debug_guide/
        
    ///开发环境
    ///接口
    static var SSApiHosts = ["Dev": "http://debug.officego.com.cn/",
                             "Test": "http://admin.officego.com.cn/",
                             "Release": "https://api.officego.com/"]
    ///h5
    static var SSH5Hosts = ["Dev": "http://test1.officego.com.cn/",
                            "Test": "http://test.officego.com.cn/",
                            "Release": "https://m.officego.com/"]
    
    static var SSWebHosts = ["Dev": "http://debugweb.officego.com.cn/",
                             "Test": "http://debugweb.officego.com.cn/",
                             "Release": "http://webapi.officego.com/"]
    
    static var SensorsAnalyticsSDKs = ["Dev": "https://officego.datasink.sensorsdata.cn/sa?project=default&token=d0db7a742f154aac",
                                       "Test":"https://officego.datasink.sensorsdata.cn/sa?project=default&token=d0db7a742f154aac",
                                       "Release": "https://officego.datasink.sensorsdata.cn/sa?project=production&token=d0db7a742f154aac"]
    ///融云appkey
    static var RCAppKeys = ["Dev": "kj7swf8oknm02",
                            "Test":"kj7swf8oknm02",
                            "Release": "qf3d5gbjq94mh"]

    ///融云secret
    static var RCAppSecrets = ["Dev": "OF78PpILjjRk4",
                               "Test":"OF78PpILjjRk4",
                               "Release": "xtDkNCjJse"]
    
    //    调试接口地址:debug.officego.com.cn
    //    调试前端地址:test1.officego.com.cn
    static func getUrlAddress(buildType:AppBuildType,serverType:BackgroundServerType) -> String {
        let buildType =  "\(buildType)"
        var addrese: String
        switch serverType {
            
        case .SSApiHost:
            addrese = SSApiHosts[buildType]!
            
        case .SSH5Host:
            addrese = SSH5Hosts[buildType]!
            
        case .SSWebHost:
            addrese = SSWebHosts[buildType]!
            
        case .SensorsAnalyticsSDK:
            addrese = SensorsAnalyticsSDKs[buildType]!
            
        case .RCAppKey:
            addrese = RCAppKeys[buildType]!
            
        case .RCAppSecret:
            addrese = RCAppSecrets[buildType]!
        }
        return addrese
    }
    
    static func saveUrlAddress(url:String, buildType:AppBuildType,serverType:BackgroundServerType) {
        guard url.length>0 else {
            return
        }
        guard  buildType != .Release else {
            return
        }
        let key:String = "\(serverType)\(buildType)"
        SSTool.saveDataWithUserDefault(key: key, value: url as AnyObject)
    }
    
    static  func getUrlByServerType(serverType: BackgroundServerType) -> String {
        if UserTool.shared.API_Setting == API_Debug {
            return getUrlAddress(buildType: .Dev,serverType: serverType)
        }else if UserTool.shared.API_Setting == API_Test {
            return getUrlAddress(buildType: .Test,serverType: serverType)
        }else if UserTool.shared.API_Setting == API_Release {
            return getUrlAddress(buildType: .Release,serverType: serverType)
        }else {
            UserTool.shared.API_Setting = API_Release
            return getUrlAddress(buildType: .Release,serverType: serverType)
        }
    }
    
    
    @objc static var SSApiHost: String {
        return getUrlByServerType(serverType: .SSApiHost)
    }
    
    static var SSH5Host: String {
        return getUrlByServerType(serverType: .SSH5Host)
    }
    
    static var SSWebHost: String {
        return getUrlByServerType(serverType: .SSWebHost)
    }
    
    static var SensorsAnalyticsSDK: String {
        return getUrlByServerType(serverType: .SensorsAnalyticsSDK)
    }
    
    static var RCAppKey: String {
        return getUrlByServerType(serverType: .RCAppKey)
    }
    
    static var RCAppSecret: String {
        return getUrlByServerType(serverType: .RCAppSecret)
    }
}

extension SSAPI.AppBuildType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .Dev:
            return "Dev"
        case .Test:
            return "Test"
        case .Release:
            return "Release"
        }
    }
}
extension SSAPI.BackgroundServerType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .SSApiHost:
            return "SSAPIHost"
        case .SSH5Host:
            return "SSH5Host"
        case .SSWebHost:
            return "SSWebHost"
        case .SensorsAnalyticsSDK:
            return "SensorsAnalyticsSDK"
        case .RCAppKey:
            return "RCAppKey"
        case .RCAppSecret:
            return "RCAppSecret"
        }
    }
}

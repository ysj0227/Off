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
        case Uat
        case Tag
        case Release
    }
    
    enum BackgroundServerType: Int {
        case SSApiHost
        case SSH5Host
        case SensorsAnalyticsSDK
    }
    
    // DEBUG 开发环境,供技术内部联调
    // TEST 测试环境，供测试在测试环境测试
    // UAT 预上线环境，供测试在仿生产环境测试
    // REALEASE or Tag 正式环境, REALEASE testflight上测试, Tag adhoc
    // 激光推送 App 是 ad-hoc 打包或者App Store 版本（发布证书 Production）https://docs.jiguang.cn/jpush/client/iOS/ios_debug_guide/
    

    
    
    ///开发环境
    ///接口
    static var SSApiHosts = ["Dev": "http://debug.officego.com.cn/",
                             "Release": "http://debug.officego.com.cn/"]
    ///h5
    static var SSH5Hosts = ["Dev": "http://test1.officego.com.cn/",
                            "Release": "http://test1.officego.com.cn/"]
    ///神策
    static var SensorsAnalyticsSDKs = ["Dev": "https://officego.datasink.sensorsdata.cn/sa?project=default&token=d0db7a742f154aac",
                            "Release": "https://officego.datasink.sensorsdata.cn/sa?project=default&token=d0db7a742f154aac"]
    
    
//    ///预发测试环境
//            static var SSApiHosts = ["Dev": "http://admin.officego.com.cn/",
//                                     "Release": "http://admin.officego.com.cn/"]
//
//            static var SSH5Hosts = ["Dev": "http://test.officego.com.cn/",
//                                     "Release": "http://test.officego.com.cn/"]
//    static var SensorsAnalyticsSDKs = ["Dev": "https://officego.datasink.sensorsdata.cn/sa?project=default&token=d0db7a742f154aac",
//                            "Release": "https://officego.datasink.sensorsdata.cn/sa?project=default&token=d0db7a742f154aac"]
    
    
    ///正式环境
//    static var SSApiHosts = ["Dev": "https://api.officego.com/",
//                             "Release": "https://api.officego.com/"]
//
//    static var SSH5Hosts = ["Dev": "https://m.officego.com/",
//                            "Release": "https://m.officego.com/"]
    
//    static var SensorsAnalyticsSDKs = ["Dev": "https://officego.datasink.sensorsdata.cn/sa?project=production&token=d0db7a742f154aac",
//                            "Release": "https://officego.datasink.sensorsdata.cn/sa?project=production&token=d0db7a742f154aac"]
    
    
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
            
        case .SensorsAnalyticsSDK:
            addrese = SensorsAnalyticsSDKs[buildType]!
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
        #if DEBUG
        return getUrlAddress(buildType: .Dev,serverType: serverType)
        #elseif TEST
        return getUrlAddress(buildType: .Test,serverType:serverType)
        #elseif UAT
        return getUrlAddress(buildType: .Uat,serverType: serverType)
        #elseif TAG
        return getUrlAddress(buildType: .Tag,serverType: serverType)
        #else  //REALEASE
        let releaseBuildType = "\(AppBuildType.Release)"
        var url = ""
        switch serverType {
        case .SSApiHost:
            url = SSApiHosts[releaseBuildType]!
        case .SSH5Host:
            url = SSH5Hosts[releaseBuildType]!
        case .SensorsAnalyticsSDK:
            url = SensorsAnalyticsSDKs[releaseBuildType]!
        }
        SSLog("url:\(url)")
        return url
        #endif
    }
    
    
    @objc static var SSApiHost: String {
        return getUrlByServerType(serverType: .SSApiHost)
    }
    
    static var SSH5Host: String {
        return getUrlByServerType(serverType: .SSH5Host)
    }
    
    static var SensorsAnalyticsSDK: String {
        return getUrlByServerType(serverType: .SensorsAnalyticsSDK)
    }
    
}

extension SSAPI.AppBuildType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .Dev:
            return "Dev"
        case .Test:
            return "Test"
        case .Uat:
            return "Uat"
        case .Tag:
            return "Tag"
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
        case .SensorsAnalyticsSDK:
            return "SensorsAnalyticsSDK"
        }
    }
}

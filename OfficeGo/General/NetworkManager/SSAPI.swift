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
        case ShareHost
    }
    
    // DEBUG 开发环境,供技术内部联调
    // TEST 测试环境，供测试在测试环境测试
    // UAT 预上线环境，供测试在仿生产环境测试
    // REALEASE or Tag 正式环境, REALEASE testflight上测试, Tag adhoc
    // 激光推送 App 是 ad-hoc 打包或者App Store 版本（发布证书 Production）https://docs.jiguang.cn/jpush/client/iOS/ios_debug_guide/
    
    
    
    static var SSApiHosts = ["Dev": "http://admin.officego.com.cn/api/",
                             "Test": "http://admin.officego.com.cn/api/",
                             "Uat": "http://admin.officego.com.cn/api/",
                             "Tag": "http://admin.officego.com.cn/api/",
                             "Release": "http://admin.officego.com.cn/api/"]
    
    static var ShareHosts = ["Dev": "http://admin.officego.com.cn/api/",
                             "Test": "http://admin.officego.com.cn/api/",
                             "Uat": "http://admin.officego.com.cn/api/",
                             "Tag": "http://admin.officego.com.cn/api/",
                             "Release": "admin://api.officego.com.cn/api/"]
    
    static func getUrlAddress(buildType:AppBuildType,serverType:BackgroundServerType) -> String {
        let buildType =  "\(buildType)"
        var addrese: String
        switch serverType {
            
        case .SSApiHost:
            addrese = SSApiHosts[buildType]!
            
        case .ShareHost:
            addrese = ShareHosts[buildType]!
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
        case .ShareHost:
            url = ShareHosts[releaseBuildType]!
        }
        SSLog("url:\(url)")
        return url
        #endif
    }
    
    
    @objc static var SSApiHost: String {
        return getUrlByServerType(serverType: .SSApiHost)
    }
    
    static var ShareHost: String {
        return getUrlByServerType(serverType: .ShareHost)
    }
}
enum DictionaryCodeEnum: String {
    case codeEnumuserPosition = "userPosition"
    case codeEnumbasicServices = "basicServices"
    case codeEnumcompanyService = "companyService"
    case codeEnumdecoratedType = "decoratedType"
    case codeEnumbranchUnique = "branchUnique"
    case codeEnumbuildType = "buildType"
    case codeEnumhouseUnique = "houseUnique"
    case codeEnumreportType = "reportType"
    case codeEnumhotKeywords = "hotKeywords"
}

//  MARK:   --聊天
class SSChatURL: NSObject {
    
    //创建和业主聊天接口
    static let getCreatFirstChatApp = "chat/chatApp"

    //
    static let getChatMsgDetailApp = "chat/firstChatApp"
    
}

//  MARK:   --搜索
class SSSearchURL: NSObject {
    
    //全局搜索接口
    static let getsearchList = "esearch/searchListApp"
    
    //查询历史记录
    static let getgetSearchKeywords = "esearch/getSearchKeywords"
        
    //查询发现 - 热门关键字 - 字典接口
    
}

//  MARK:   --首页
class SSHomeURL: NSObject {
    
    //轮播图接口
    static let getbannerListt = "banner/bannerList"
    
    //推荐列表 - 首页和搜索页面
    static let getselectBuildingApp = "building/selectBuildingApp"
       
}

//  MARK:   --收藏
class SSCollectURL: NSObject {
    
    //添加收藏
    static let addCollection = "favorite/addCollectionAPP"
    
    //收藏列表
    static let getFavoriteListAPP = "favorite/getFavoriteListApp"
       
}

//  MARK:   --详情
class SSFYDetailURL: NSObject {
    
    //楼盘网点详情
    static let getBuildingDetailbyBuildingId = "building/selectBuildingbyBuildingIdApp"
    
    //楼盘-网点房源详情
    static let getBuildingFYDetailbyHouseId = "house/selectHousebyHouseIdApp"
    
    //楼盘-网点房源列表
    static let getBuildingFYList = "building/selectHouseApp"
       
}

//  MARK:   --基本信息
class SSBasicURL: NSObject {
    
    //地铁线路接口
    static let getSubwayList = "dictionary/getSubwayList"
    
    //区域商圈接口
    static let getDistrictList = "dictionary/getDistrictList"
    
    //获取字典接口
    static let getDictionary = "dictionary/getDictionary"
    
}

//  MARK:   --登录
class SSLoginURL: NSObject {
    
    static let getSmsCode = "login/sms_code"
    
    static let loginWithCode = "login/loginCode"
    
    static let addWantToFind = "building/addWantGoBuild"
    
}

//  MARK:   --我的
class SSMineURL: NSObject {
    
    ///绑定微信
    static let bindWeChat = "login/sms_codeApp"
    
    ///个人资料
    static let getUserMsg = "user/getAllMsgApp"

    ///切换身份
    static let roleChange = "user/regTokenApp"
    
    ///修改个人资料
    static let updateUserMessage = "user/updateDataApp"

    ///版本更新
    static let versionUpdate = "version/ios"
    
    ///注册协议
    static let registerProtocol = "registerProtocol.html"
    
    ///关于我们
    static let aboutUs = "aboutUs.html"

}

//  MARK:   --行程接口
class SSScheduleURL: NSObject {
    
    //看房行程
    static let getScheduleListApp = "schedule/getScheduleListApp"
    
    //约看房记录
    static let getOldScheduleListApp = "schedule/getOldScheduleListApp"
    
    //看房行程详情
    static let getScheduleApp = "schedule/getScheduleApp"
    
    //预约看房
    static let selectScheduleHouseApp = "schedule/selectScheduleHouseApp"
    
    //保存预约行程
    static let addRenterApp = "schedule/addRenterApp"
    
    //结束行程
    static let updateFinish = "schedule/updateFinish"
    
    //行程审核接口
    static let updateAuditStatusApp = "schedule/updateAuditStatusApp"
    
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
        case .ShareHost:
            return "ShareHost"
        }
    }
}

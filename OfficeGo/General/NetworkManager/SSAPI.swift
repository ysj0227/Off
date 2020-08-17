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
    }
    
    // DEBUG 开发环境,供技术内部联调
    // TEST 测试环境，供测试在测试环境测试
    // UAT 预上线环境，供测试在仿生产环境测试
    // REALEASE or Tag 正式环境, REALEASE testflight上测试, Tag adhoc
    // 激光推送 App 是 ad-hoc 打包或者App Store 版本（发布证书 Production）https://docs.jiguang.cn/jpush/client/iOS/ios_debug_guide/
    
    
    
    //    static var SSApiHosts = ["Dev": "http://admin.officego.com.cn/",
    //                             "Release": "https://api.officego.com/"]
    //
    //    static var SSH5Hosts = ["Dev": "http://test.officego.com.cn/",
    //                             "Release": "https://m.officego.com/"]
    
    
    ///开发环境
//    static var SSApiHosts = ["Dev": "http://debug.officego.com.cn/",
//                             "Release": "http://debug.officego.com.cn/"]
//
//    static var SSH5Hosts = ["Dev": "http://test1.officego.com.cn/",
//                            "Release": "http://test1.officego.com.cn/"]
    
    ///预发测试环境
//            static var SSApiHosts = ["Dev": "http://admin.officego.com.cn/",
//                                     "Release": "http://admin.officego.com.cn/"]
//
//            static var SSH5Hosts = ["Dev": "http://test.officego.com.cn/",
//                                     "Release": "http://test.officego.com.cn/"]
    
    ///正式环境
    static var SSApiHosts = ["Dev": "https://api.officego.com/",
                             "Release": "https://api.officego.com/"]
    
    static var SSH5Hosts = ["Dev": "https://m.officego.com/",
                            "Release": "https://m.officego.com/"]
    
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

//  MARK:   --网页
class SSDelegateURL: NSObject {
    
    //楼盘分享地址 buildingId
    static let h5BuildingDetailShareUrl =  "lessee/housesDetail.html"
    
    //网点分享地址 buildingId
    static let h5JointDetailShareUrl =  "lessee/housesDetail2.html"
    
    //房源分享地址 buildingId houseId
    static let h5BuildingFYDetailShareUrl =  "lessee/detail.html"
    
    //网点下的房源分享地址 buildingId houseId
    static let h5BJointFYDetailShareUrl =  "lessee/detail2.html"
    
    //关于我们
    static let h5AboutUsUrl = "lessee/aboutUs.html?channel=\(UserTool.shared.user_channel)"
    
    //服务协议
    static let h5RegisterProtocolUrl = "lessee/registerProtocol.html?channel=\(UserTool.shared.user_channel)"
    
    //隐私条款：
    static let h5PrivacyProtocolUrl = "lessee/privacy.html?channel=\(UserTool.shared.user_channel)"
    
    //帮助与反馈 - 租户：
    static let h5RenterHelpAndFeedbackUrl = "lessee/opinion.html?channel=\(UserTool.shared.user_channel)&identity=\(UserTool.shared.user_id_type ?? 9)"
    
    //帮助与反馈 - 租户：
    static let h5OwnerHelpAndFeedbackUrl = "owner/opinion.html?channel"
    
    //常见问题：
    static let h5QuestionUrl = "lessee/issueList.html?channel=\(UserTool.shared.user_channel)"
    
    ///认证业主网页接口
    static let h5IdentifyOwnerUrl = "owner/myHome.html"
    
    ///个人认证  attestationPersonage.html
    static let h5IdentifyOwnerPersonageUrl = "owner/attestationPersonage.html"
    
    ///企业认证 company.html
    static let h5IdentifyOwnerBCompanyUrl = "owner/company.html"
    
    ///网点认证 company2.html
    static let h5IdentifyOwnerJointUrl = "owner/company2.html"
    
    //房源 - 楼盘管理 houseList
    static let h5IdentifyOwnerBuildingManagerUrl = "owner/houseList.html"
    
    //房源 - 网点管理 branchList
    static let h5IdentifyOwnerJointManagerUrl = "owner/branchList.html"
    
    //员工管理 staffList.html
    static let h5OwnerStaffListUrl = "owner/staffList.html"
}


//  MARK:   --业主认证接口
class SSOwnerIdentifyURL: NSObject {
    
    //搜索企业接口
    static let getESCompany = "api/esearch/searchListByLicence"
    
    //搜索企业大楼接口
    static let getESBuild = "api/esearch/searchListBuild"
    
    //搜索网点接口
    static let getESBranch = "api/esearch/searchListBranch"
    
    //进入申请加入查询管理员Id APP
    static let getApplyManagerMsg = "api/licence/selectApplyLicenceApp"
    
    //申请加入企业
    static let getApplyJoin = "api/licence/applyLicenceProprietorApp"
    
    //加入企业或者网点同意拒绝接口
    static let getUpdateAuditStatus = "api/licence/updateAuditStatusApp"
    
    //网点是否可以创建判断接口app
    static let getIsCanCreatBranch = "api/licence/selectBuildingByNameApp"
    
    //企业是否可以创建判断接口App
    static let getIsCanCreatCompany = "api/licence/selectLicenceByCompanyApp"
    
    //用户选择身份调
    static let getSelectIdentityTypeApp = "api/licence/selectIdentityTypeApp"
    
    //添加认证APP - 待测
    static let getUploadLicenceProprietorApp = "api/licence/uploadLicenceProprietorApp"
    
    //查询申请信息接口（普通员工申请加入之后查询页面数据）
    static let getQueryApplyLicenceProprietorApp = "api/licence/queryApplyLicenceProprietorApp"
    
    //自主撤销认证 待测
    static let getDeleteUserLicenceApp = "api/licence/deleteUserLicenceApp"
    
    //业主和业主聊天列表调用接口
    static let getOwnerToOwnerchattedMsgAApp = "api/chat/chattedMsgApp"
    
    //图片删除调用接口
    static let deleteImgApp = "api/licence/deleteImgApp"
    
}




//  MARK:   --聊天
class SSChatURL: NSObject {
    
    //获取融云token
    static let getRongYunToken = "api/user/rongYunToken"
    
    //创建和业主聊天接口
    static let getCreatFirstChatApp = "api/chat/chatApp"
    
    //获取聊天关联房源
    static let getChatMsgDetailApp = "api/chat/firstChatApp"
    
    //新增微信
    static let addWxID = "api/user/changeWxId"
    
    //记录第一次发送
    static let addChatApp = "api/chat/addChatApp"
    
    //获取用户信息
    static let getUserChatInfoApp = "api/user/getUser"
    
}

//  MARK:   --搜索
class SSSearchURL: NSObject {
    
    //全局搜索接口
    static let getsearchList = "api/esearch/searchListApp"
    
    //查询历史记录
    static let getgetSearchKeywords = "api/esearch/getSearchKeywords"
    
    //删除搜索记录
    static let delSearchKeywords = "api/esearch/delSearchKeywords"
    
}

//  MARK:   --首页
class SSHomeURL: NSObject {
    
    //轮播图接口
    static let getbannerListt = "api/banner/bannerList"
    
    //推荐列表 - 首页和搜索页面
    static let getselectBuildingApp = "api/building/selectBuildingApp"
    
}

//  MARK:   --收藏
class SSCollectURL: NSObject {
    
    //添加收藏
    static let addCollection = "api/favorite/addCollectionAPP"
    
    //收藏列表
    static let getFavoriteListAPP = "api/favorite/getFavoriteListApp"
    
}

//  MARK:   --详情
class SSFYDetailURL: NSObject {
    
    //楼盘网点详情
    static let getBuildingDetailbyBuildingId = "api/building/selectBuildingbyBuildingIdApp"
    
    //楼盘-网点房源详情
    static let getBuildingFYDetailbyHouseId = "api/house/selectHousebyHouseIdApp"
    
    //楼盘-网点房源列表
    static let getBuildingFYList = "api/building/selectHouseApp"
    
    //点击分享 - 调用接口
    static let clickShareClick = "api/chat/shareApp"

}

//  MARK:   --基本信息
class SSBasicURL: NSObject {
    
    //地铁线路接口
    static let getSubwayList = "api/dictionary/getSubwayList"
    
    //区域商圈接口
    static let getDistrictList = "api/dictionary/getDistrictList"
    
    //获取字典接口
    static let getDictionary = "api/dictionary/getDictionary"
    
}

//  MARK:   --登录
class SSLoginURL: NSObject {
    
    static let getSmsCode = "api/login/sms_code"
    
    static let loginWithCode = "api/login/loginCode"
    
    static let addWantToFind = "api/building/addWantGoBuild"
    
}

//  MARK:   --我的
class SSMineURL: NSObject {
    
    ///绑定微信
    static let bindWeChat = "api/login/sms_codeApp"
    
    ///个人资料 - 租户  - 业主
    static let getRenterUserMsg = "api/user/userMsgApp"
    
    ///个人资料 - 业主
    static let getOwnerUserMsg = "api/user/userMsgApp"
    
    ///切换身份
    static let roleChange = "api/user/regTokenApp"
    
    ///修改个人资料 - 业主 - 租户
    static let updateUserMessage = "api/user/updateDataApp"
    
    ///版本更新
    static let versionUpdate = "api/version/ios"
    
    /// 修改手机号
    static let changePhone = "api/user/changePhone"
    
    ///修改微信
    static let changeWechat = "api/user/changeWechat"
    
}

//  MARK:   --行程接口
class SSScheduleURL: NSObject {
    
    //看房行程
    static let getScheduleListApp = "api/schedule/getScheduleListApp"
    
    //约看房记录
    static let getOldScheduleListApp = "api/schedule/getOldScheduleListApp"
    
    //看房行程详情
    static let getScheduleApp = "api/schedule/getScheduleApp"
    
    //预约看房
    static let selectScheduleHouseApp = "api/schedule/selectScheduleHouseApp"
    
    //保存预约行程  租户像业主申请
    static let addRenterApp = "api/schedule/addRenterApp"
    
    //保存预约行程  业主像租户申请
    static let addProprietorApp = "api/schedule/addProprietorApp"
    
    //结束行程
    static let updateFinish = "api/schedule/updateFinish"
    
    //行程审核接口
    static let updateAuditStatusApp = "api/schedule/updateAuditStatus"
    
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
        }
    }
}

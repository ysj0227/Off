//
//  RequestAPIs.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/5/8.
//  Copyright © 2020 Senwei. All rights reserved.
//

//  MARK:   --网页
class SSDelegateURL: NSObject {
        
    //vr录制地址
    static let h5VRCreateUrl =  "owner/vr.html"
    
    
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
    
    ///认证房东网页接口
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


//  MARK:   --房源列表
class SSOwnerFYManagerURL: NSObject {
    
    //楼盘驳回回显
    static let getBuildingTempById = "api/building/getBuildingTempById"
    
    //楼盘添加接口
    static let getinsertBuilding = "api/building/insertBuilding"
    
    //vr楼盘发布
    static let addBuildingVr = "api/building/addBuildingVr"
    
    //vr房源发布
    static let addHouseVr = "api/house/addHouseVr"

    //上传阿里云图片
    static let uploadResourcesUrl = "api/building/uploadResourcesUrl"
    
    //删除阿里云图片
    static let deleteResourcesUrl = "api/building/deleteResourcesUrl"
    
    //楼盘网点回显接口
    static let getBuildingMsg = "api/building/getBuildingMsgByBuildingId"
    
    //楼盘网点编辑接口
    static let getUpdateBuilding = "api/building/updateBuilding"
    
    //房源回显接口
    static let getHouseMsgByHouseId = "api/house/getHouseMsgByHouseId"
    
    //房源编辑接口
    static let getUpdateHouse = "api/house/updateHouse"
    
    //房源添加接口
    static let getinsertHouse = "api/house/insertHouse"
    
        
    //楼盘列表接口
    static let getBuildingList = "api/building/selectBuildingList"
    
    //房源列表接口
    static let getHouseLists = "api/house/selectHouseList"
    
    //上下架房源
    static let getHousePublishOrRelease = "api/house/houseReleaseOrShelves"
    
    //删除房源
    static let getHouseDelete = "api/house/houseDelete"
    
}

// MARK: --扫码登录pc
class SSWebLoginURL: NSObject {
    static let getWebLogin = "api/login/bindTokenUser"
}

//  MARK:   --房东认证接口
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
    
    //房东和房东聊天列表调用接口
    static let getOwnerToOwnerchattedMsgAApp = "api/chat/chattedMsgApp"
    
    //图片删除调用接口
    static let deleteImgApp = "api/licence/deleteImgApp"
    
}




//  MARK:   --聊天
class SSChatURL: NSObject {
    
    //聊天列表调用接口
    static let getChatList = "api/chat/chatListApp"
    
    //获取融云token
    static let getRongYunToken = "api/user/rongYunToken"
    
    //创建和房东聊天接口
    static let getCreatFirstChatApp = "api/chat/chatApp"
    
    //获取聊天关联房源
    static let getChatMsgDetailApp = "api/chat/firstChatApp"
    
    //新增微信
    static let addWxID = "api/user/changeWxId"
    
    //记录第一次发送
    static let addChatApp = "api/chat/addChat"
    
    //获取融云用户信息
    static let getUserChatInfoApp = "api/user/getUser"
    
    //交换手机微信号判断
    static let getExchangePhoneVerification = "api/chat/exchangePhoneVerification"
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
    
    //业主 - 楼盘网点预览
    static let getBuildingbyBuildingIdPreviewApp = "api/building/getBuildingbyBuildingIdPreviewApp"
    
    //业主 楼盘-网点房源预览
    static let getHousebyHouseIdPreviewApp = "api/house/getHousebyHouseIdPreviewApp"
    
    //业主 楼盘-网点房源列表
    static let getOwnerBuildingFYList = "api/building/selectHousePreviewApp"
    
    
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
    
    ///个人资料 - 租户  - 房东
    static let getRenterUserMsg = "api/user/userMsgApp"
    
    ///个人资料 - 房东
    static let getOwnerUserMsg = "api/user/userMsgApp"
    
    ///切换身份
    static let roleChange = "api/user/regTokenApp"
    
    ///修改个人资料 - 房东 - 租户
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
    
    //保存预约行程  租户像房东申请
    static let addRenterApp = "api/schedule/addRenterApp"
    
    //保存预约行程  房东像租户申请
    static let addProprietorApp = "api/schedule/addProprietorApp"
    
    //结束行程
    static let updateFinish = "api/schedule/updateFinish"
    
    //行程审核接口
    static let updateAuditStatusApp = "api/schedule/updateAuditStatus"
    
}

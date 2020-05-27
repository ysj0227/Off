//
//  RequestAPIs.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/5/8.
//  Copyright © 2020 Senwei. All rights reserved.
//
import Foundation
// api path

let kApiUserLogin       = "/user/loginByToken"  // 登录
let kApiPeriodAward     = "/u/timequest/hour"   // 领取时段奖励
let kApiUserInfo        = "/u/user/info"        // 用户信息
let kApiTimeRead        = "/time/read"          // App 启动时获取服务器时间
let kApiVideoLog        = "/u/video/log"        // 用户观看视频记录
let kApiBindMobile      = "/u/user/bindMobile"  // 用户观看视频记录

let kApiGoldRecord      = "/u/wallet/gold/findGoldRecordOfCurrentUser"     // 分页获取当前user近7日金币记录
let kApiCoinRecord      = "/u/wallet/coins/findCoinsRecordOfCurrentUser"   // 分页获取当前user近7日零钱记录
let kApiCoinPageInfo    = "/u/activity/page"    // 获取领现金页面的集合信息
let kApiCoins2MoneyPollingList = "/wallet/coins/getCoins2MoneyPollingList" // 获取领现金页面轮播信息
let kApiActivityOpenBox = "/u/activity/openBox" // 开宝箱
let kApiActivitySignIn  = "/u/activity/signIn"  // 签到
let kApiActivityBindInvitationCode  = "/u/relation/bindInvitationCode"  // 绑定邀请码
let kApiShareCallback  = "/u/share/callback"    //分享后回调给服务器
let kApiCoins2MoneyRateToday    = "/wallet/findCoins2MoneyRateToday"// 今日汇率
let kApiGetAllSharingMessage    = "/u/quest/sharing/getAllSharingMessage"  // 获取分享信息
let kApiMessageList         = "/u/message/list" // 通知列表
let kApiMessageUnreadCount  = "/u/message/unreadCount"  // 消息未读数

let kApiGetSpuList      = "/u/wallet/cash/card/getSpuList"  //获取spu列表
let kApiExchangeCard    = "/u/wallet/cash/card/exchangeCardCode"

let kApiGetSetting      = "/version/getSetting"  // 审核接口 false为审核中
let kApiFindGold2CoinsRecordToday = "/u/wallet/coins/findGold2CoinsRecordToday" // 获取今日结算记录
let kApiJSVersion       = "/version/js"
let kApiSepcialList     = "/content/specialList"    //受限内容
let kApiChannellList    = "/content/channel/list"
let kApiUploadToken     = "/content/common/uploadToken" // 七牛上传token
let kApiFeedback        = "/c/user/feedback"    // 意见反馈
let kApiTabList         = "/content/tabList"    // 配置tab列表
let kApiPostList        = "/thorPro/comments"   // 社区接口
let kApiVideoList       = "/thorPro/videoList"  // 首页自家视频列表

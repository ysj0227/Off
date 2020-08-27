//
//  NetworkErrorManager.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/5/8.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit


class SSCode: NSObject {
    static let SERVER_ERROR                         = StatusStruct.init(code: 5, msg: "服务器错误")
    static let SUCCESS                              = StatusStruct.init(code: 200, msg: "")//程序默认的成功状态码
    static let DEFAULT_ERROR_CODE_5000              = StatusStruct.init(code: 5000, msg: "默认错误状态码,此状态必须写明 message 原因") //默认错误状态码,此状态必须写明 message 原因
    static let ERROR_CODE_5001                      = StatusStruct.init(code:5001, msg: "缺少参数或参数为空")//缺少参数或参数为空
    static let ERROR_CODE_5002                      = StatusStruct.init(code:5002, msg: "TODO 网络异常")//TODO 网络异常
    static let ERROR_CODE_5003                      = StatusStruct.init(code:5003, msg: "签名验证失败,请重新登录")//签名验证失败,请重新登录
    static let ERROR_CODE_5004                      = StatusStruct.init(code:5004, msg: "程序发生异常,请查看log日志")//程序发生异常,请查看log日志
    static let ERROR_CODE_5005                      = StatusStruct.init(code:5005, msg: "参数类型错误")//参数类型错误
    static let ERROR_CODE_5006                      = StatusStruct.init(code:5006, msg: "暂无数据")//暂无数据
    static let ERROR_CODE_5007                      = StatusStruct.init(code:5007, msg: "操作失败")//操作失败
    static let ERROR_CODE_5009                      = StatusStruct.init(code:5009, msg: "当前登录失效，请重新登录")//token已失效，需要重新登录
    static let ERROR_CODE_666                       = StatusStruct.init(code:666, msg: "需要统一抛出提示的状态码")//需要统一抛出提示的状态码
    //6开头,tian
    static let ERROR_CODE_6000                      = StatusStruct.init(code:6000, msg: "密码错误")
    static let ERROR_CODE_6001                      = StatusStruct.init(code:6001, msg: "两次密码不相同")
    static let ERROR_CODE_6004                      = StatusStruct.init(code:6004, msg: "获取AccessToken信息失败")
    static let ERROR_CODE_6005                      = StatusStruct.init(code:6005, msg: "无效第三方标示")
    static let ERROR_CODE_6006                      = StatusStruct.init(code:6006, msg: "获取第三方消息失败")
    static let ERROR_CODE_6007                      = StatusStruct.init(code:6007, msg: "无效凭证")
    static let ERROR_CODE_6008                      = StatusStruct.init(code:6008, msg: "全局检索失败")
    static let ERROR_CODE_6009                      = StatusStruct.init(code:6009, msg:  "验证码不对或已过期!")
    static let ERROR_CODE_6010                      = StatusStruct.init(code:6010, msg: "验证码不正确")
    static let ERROR_CODE_6011                      = StatusStruct.init(code:6011, msg: "验证码不正确")
    static let ERROR_CODE_6012                      = StatusStruct.init(code:6012, msg: "验证码不正确")
    static let ERROR_CODE_6013                      = StatusStruct.init(code:6013, msg: "手机号没有注册")
    static let ERROR_CODE_6014                      = StatusStruct.init(code:6014, msg: "未设置密码")
    static let ERROR_CODE_6015                      = StatusStruct.init(code:6015, msg: "融云token生成失败")
    static let ERROR_CODE_6016                      = StatusStruct.init(code:6016, msg: "更新楼盘缓存失败!")
    static let ERROR_CODE_6017                      = StatusStruct.init(code:6017, msg:  "更新房源缓存失败!")
    static let ERROR_CODE_6018                      = StatusStruct.init(code:6018, msg: "更新用户缓存失败!")
    static let ERROR_CODE_6019                      = StatusStruct.init(code:6019, msg: "请下载微信最新版本")
    static let ERROR_CODE_6020                      = StatusStruct.init(code:6020, msg: "您的帐号已冻结，请联系客服")
    static let ERROR_CODE_6021                      = StatusStruct.init(code:6021, msg: "新号码已被注册!")
    static let ERROR_CODE_6022                      = StatusStruct.init(code:6022, msg: "请勿重复举报！")
    static let ERROR_CODE_6023                      = StatusStruct.init(code:6023, msg: "您举报的用户不存在！")
    static let ERROR_CODE_6024                      = StatusStruct.init(code:6024, msg: "获取图片失败!")
    static let ERROR_CODE_6025                      = StatusStruct.init(code:6025, msg:  "常见问题信息不存在")
    static let ERROR_CODE_6026                      = StatusStruct.init(code:6026, msg: "当前行程不存在")
    static let ERROR_CODE_6027                      = StatusStruct.init(code:6027, msg: "当前行程已结束")
    static let ERROR_CODE_6028                      = StatusStruct.init(code:6028, msg: "图片尺寸太大,宽高不能超过4096px")
    static let ERROR_CODE_6029                      = StatusStruct.init(code:6029, msg: "图片太大,大小不能超过20M")
    static let ERROR_CODE_6030                      = StatusStruct.init(code:6030, msg: "文件类型错误,请重新选择")
    static let ERROR_CODE_6031                      = StatusStruct.init(code:6031, msg: "图片识别失败,请重新选择")
    static let ERROR_CODE_6032                      = StatusStruct.init(code:6032, msg: "不可重复拉黑")
    static let ERROR_CODE_6033                      = StatusStruct.init(code:6033, msg:  "对方为该房源最后一个管理员,不可拉黑!")
    //7开头,李
    static let ERROR_CODE_7000                      = StatusStruct.init(code:7000, msg: "默认")
    static let ERROR_CODE_7001                      = StatusStruct.init(code:7001, msg: "该房源没有管理员无法建立聊天")
    static let ERROR_CODE_7002                      = StatusStruct.init(code:7002, msg: "删除失败")
    static let ERROR_CODE_7003                      = StatusStruct.init(code:7003, msg: "楼盘不存在")
    static let ERROR_CODE_7012                      = StatusStruct.init(code:7012, msg: "楼盘已经下架")
    static let ERROR_CODE_7013                      = StatusStruct.init(code:7013, msg: "楼盘下的房源已经售完")
    static let ERROR_CODE_7014                      = StatusStruct.init(code:7014, msg: "楼盘已删除")
    static let ERROR_CODE_7016                      = StatusStruct.init(code:7016, msg: "房源已下架")

    //8开头,谢
    static let ERROR_CODE_8000                      = StatusStruct.init(code:8000, msg: "默认")
    static let ERROR_CODE_8001                      = StatusStruct.init(code:8001, msg: "企业名称已存在")
    static let ERROR_CODE_8002                      = StatusStruct.init(code:8002, msg: "用户已企业认证")
    static let ERROR_CODE_8003                      = StatusStruct.init(code:8003, msg: "企业、网点不存在")
    static let ERROR_CODE_8004                      = StatusStruct.init(code:8004, msg: "未认证")
    static let ERROR_CODE_8005                      = StatusStruct.init(code:8005, msg: "对象为空")
    static let ERROR_CODE_8006                      = StatusStruct.init(code:8006, msg: "集合为空")
}

struct StatusStruct {
    let code: Int
    let msg: String
}

enum NetworkErrorReturnCode: Int {
    case kErrorUnknown              = -1        // 用于转换int to enum 的时候，不存在这个rawValue的替换默认
    case kErrorNOError              = 0         // 没有错误
    case kErrorAwardTask            = 3000      // 任务奖励相关的错误
    case kErrorAwardHasTaken        = 3001      // 时段奖励已经领取过了
    case kErrorInvalidMaster        = 3030      // 师父注册时间必须早于徒弟的注册时间
    case kErrorInvalidInviteCode    = 3031      // 邀请码错误
    case kErrorHasBindOtherCode     = 3032      // 已绑定其他邀请码
    case kErrorBindOwnCode          = 3033      // 绑定自己的邀请码
    case kErrorBindCodeInSameDevice = 3036      // 师傅和徒弟使用了同一个设备ID
    case kErrorSigninAlready        = 3040      // 已经签到过了
    case kErrorNotReadyForOpenBox   = 3050      // 开宝箱没到时间
    case kErrorQuestGoldCountLimit  = 3099      // 金币请求达到上限
    
    case kErrorVerifyError          = 4021      // 验证码校验失败
    case kErrorMobileUserd          = 4022      // 手机号已绑定其他账号
    case kErrorAccountBinded        = 4023      // 用户已绑定过手机号
    case kErrorVerifyTooFrequent    = 4024      // 验证码过于频繁
    
    case kErrorGetRateFailed        = 5531      // 获取汇率出错
    
    case kErrorUserIsForbidden      = 5622      // 用户被禁用
    case kErrorUserNotBindMobile    = 5623      // 用户未绑定手机号
    case kErrorSkuNotExist          = 5624      // SKU不存在
    case kErrorBeyondSkuLimit       = 5625      // 超出了SKU兑换次数
    case kErrorCoinsNotEnough       = 5626      // 余额不足
    case kErrorBeyondDailyLimit     = 5627      // 超出每日限额
    case kErrorSKUIsOffTheShelves   = 5628      // SKU已下架
    case kErrorOutOfStock           = 5629      // 库存不足
    
    public func errorMessage() -> String? {
        switch self {
            /// 3000
        case .kErrorAwardTask:
            return localizedMessage(with: "unkown quest error")
        case .kErrorAwardHasTaken:
            return localizedMessage(with: "repeately get gold")
        case .kErrorInvalidMaster:
            return localizedMessage(with: "师父注册时间必须早于徒弟的注册时间")
        case .kErrorInvalidInviteCode:
            return localizedMessage(with: "invalid invitation code")
        case .kErrorHasBindOtherCode:
            return localizedMessage(with: "user has binded other code")
        case .kErrorBindOwnCode:
            return localizedMessage(with: "cannot use your own code")
        case .kErrorBindCodeInSameDevice:
            return localizedMessage(with: "同设备邀请码无效")
        case .kErrorNotReadyForOpenBox:
            return localizedMessage(with: "not ready for open box")
        case .kErrorQuestGoldCountLimit:
            return localizedMessage(with: "quest gold count max limit")
        
            /// 4000
        case .kErrorVerifyError:
            return localizedMessage(with: "captcha verify failed")
        case .kErrorMobileUserd:
            return localizedMessage(with: "mobile has been bound with another user")
        case .kErrorAccountBinded:
            return localizedMessage(with: "current user has been bound with a mobile")
        case .kErrorVerifyTooFrequent:
            return localizedMessage(with: "operation frequently. please try again later")
            
            /// 5000
        case .kErrorGetRateFailed:
            return localizedMessage(with: "failed to get rate")
            
        case .kErrorUserIsForbidden:
            return localizedMessage(with: "user is forbidden")
        case .kErrorUserNotBindMobile:
            return localizedMessage(with: "user not bind mobile")
        case .kErrorSkuNotExist:
            return localizedMessage(with: "sku not exist")
        case .kErrorBeyondSkuLimit:
            return localizedMessage(with: "超过兑换次数")
        case .kErrorCoinsNotEnough:
            return localizedMessage(with: "Coins not enough")
        case .kErrorBeyondDailyLimit:
            return localizedMessage(with: "beyond daily limit")
        case .kErrorSKUIsOffTheShelves:
            return localizedMessage(with: "sku is off the shelves")
        case .kErrorOutOfStock:
            return localizedMessage(with: "sku is out of stock")
        default:
            return nil
        }
    }
    
    private func localizedMessage(with message: String) -> String {
        return NSLocalizedString(message, tableName: "ErrorMsg")
    }
}

class NetworkErrorManager: NSObject {
    
    class func handleErrorWithResult(codeInt: Int?, msg: String?) {
        
        if let codeInt = codeInt, let code = NetworkErrorReturnCode(rawValue: codeInt), let localMessage = code.errorMessage() {
            AppUtilities.makeToast(localMessage)
        } else {
            if (msg ?? "").lengthOfBytes(using: .utf8) > 0 {
                AppUtilities.makeToast(msg ?? "")
            } else {
                AppUtilities.makeToast(NSLocalizedString("请求失败，错误码：", comment: "") + String(codeInt ?? 0))
            }
        }
    }
}

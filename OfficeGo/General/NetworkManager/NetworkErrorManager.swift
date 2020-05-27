//
//  NetworkErrorManager.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/5/8.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

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

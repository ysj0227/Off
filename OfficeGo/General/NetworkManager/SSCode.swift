//
//  SSCode.swift
//  UUEnglish
//
//  Created by Aibo on 2018/3/28.
//  Copyright © 2018年 uuabc. All rights reserved.
//

import Foundation

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

class SSSS: NSObject {
    
    static let MsgDefault = "请稍候..."
    static let MsgLoginError   = "登录失败,请检查用户名密码"
    static let MsgError   = "操作失败！"
    static let MsgSuccess = "操作成功！"
    static let MsgCode = "请输入正确的手机号码"
    static let NetErrorMessage  = "网络连接失败，请检查网络"
    
    static let InSearching    = "正在搜索..."
    static let NoSearchResult = "未找到相关的项目"
    static let Loading          = "加载中..."
    static let AllLoaded      = "已经全部加载完毕"
}


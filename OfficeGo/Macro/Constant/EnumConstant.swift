//
//  EnumConstant.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/5/8.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

//协议url
public enum ProtocalType {
    ///关于我们
    case ProtocalTypeAboutUs
    ///服务协议
    case ProtocalTypeRegisterProtocol
    ///隐私条款
    case ProtocalTypePrivacyProtocolUrl
    ///帮助与反馈
    case ProtocalTypeHelpAndFeedbackUrl
    ///常见问题
    case ProtocalTypeQuestionUrl
}

//我想找item枚举
public enum IWantToFindType {
    case IWantToFindTypeCity        //城市
    case IWantToFindTypeHouseType   //房源类型
    case IWantToFindTypeGongwei     //工位
    case IWantToFindTypeGongwei1    //工位1
    case IWantToFindTypeZujin       //租金
    case IWantToFindTypeMianji      //面积
    case IWantToFindTypeDocumentType//装修类型
    case IWantToFindTypeFeature     //房源特色
}

//办公楼和联合办公详情页面枚举
public enum FYDetailItemType {
    case FYDetailItemOfficeBuildingNameView //头部名字
    case FYDetailItemTypeJointNameView  //联合办公 - 头部 - 开放工位和独立办公室
    case FYDetailItemTypeTraffic        //交通
    case FYDetailItemTypeFeature        //特色
    case FYDetailItemTypeLianheOpenList //联合办公开放工位列表
    case FYDetailItemTypeFYList         //房源列表 - 办公楼办公室 / 联合办公独立办公室列表
    case FYDetailItemTypeShareServices  //共享服务
    case FYDetailItemTypeOfficeDeatail  //楼盘详情
    case FYDetailItemTypeAmbitusMating  //周边配套
    case FYDetailItemTypeHuxing         //办公室户型信息
}

//下面的bottom
public enum BottomBtnViewType {
    case BottomBtnViewTypeIwantToFind   //我想找页面 - 只显示一个确定按钮
    case BottomBtnViewTypeShaixuan      //筛选页面 - 两个按钮 清除 确定
    case BottomBtnViewTypeOfficeDetail  //详情页面 - 收藏 - 找房东
    case BottomBtnViewTypeChatAlertBottomView  //聊天页面 - 取消 - 确定
}

//租户我的
public enum RenterMineType {
    case RenterMineTypeIWanttoFind      //我想找
    case RenterMineTypeHouseSchedule    //看房行程
    case RenterMineTypeHelpAndFeedback  //帮助与反馈
    case RenterMineTypeCusomers         //客服
    case RenterMineTypeRegisterAgent    //注册协议与隐私条款
    case RenterMineTypeAboutus          //关于我们
}
//设置
public enum RenterSettingType {
    case RenterSettingTypeAccountAndBind    //账号与绑定
    case RenterSettingTypeNoticifyAndAlert  //通知与提醒
    case RenterSettingTypePrivacySetting    //隐私设置
    case RenterSettingTypeHello             //打招呼语
    case RenterSettingTypeVersionUpdate     //版本更新
    case RenterSettingTypeRoleChange        //切换身份
}

//基本信息
public enum RenterUserMsgType {
    case RenterUserMsgTypeAvatar            //头像
    case RenterUserMsgTypeNick              //昵称
    case RenterUserMsgTypeSex               //性别
    case RenterUserMsgTypeTele              //联系方式
    case RenterUserMsgTypeWechat            //微信
}


//弹框alert
public enum AlertType {
    case AlertTypeVersionUpdate             //版本更新 - 弹框
    case AlertTypeChatInput                 //聊天- 微信输入框
    case AlertTypeChatSure                  //聊天- 微信交换弹框
}

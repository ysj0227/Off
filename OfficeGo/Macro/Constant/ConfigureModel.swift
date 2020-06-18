//
//  ConfigureModel.swift
//  OfficeGo
//
//  Created by mac on 2020/5/18.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class ConfigureModel: NSObject {
    var title: String?
    var icon: String?
    var isShowDetailIcon: Bool?
}

//我的
class MineConfigureModel: ConfigureModel {
    
    var type: RenterMineType?
    
    init(types: RenterMineType) {
        type = types
    }
    
    func getNameFormType(type: RenterMineType) -> String{
        switch type {
        case .RenterMineTypeIWanttoFind:
            return "我想找"
        case .RenterMineTypeHouseSchedule:
            return "看房行程"
        case .RenterMineTypeHelpAndFeedback:
            return "帮助与反馈"
        case .RenterMineTypeCusomers:
            return "客服"
        case .RenterMineTypeRegisterAgent:
            return "注册协议与隐私条款"
        case .RenterMineTypeAboutus:
            return "关于我们"
        }
    }
    func getIconFormType(type: RenterMineType) -> String{
        switch type {
        case .RenterMineTypeIWanttoFind:
            return "iwantToFind"
        case .RenterMineTypeHouseSchedule:
            return "houseSchedule"
        case .RenterMineTypeHelpAndFeedback:
            return "helpAndFeedback"
        case .RenterMineTypeCusomers:
            return "customers"
        case .RenterMineTypeRegisterAgent:
            return "agentRegular"
        case .RenterMineTypeAboutus:
            return "aboutUS"
        }
    }
}



//设置
class SettingConfigureModel: NSObject {
    
    var type: RenterSettingType?
    
    init(types: RenterSettingType) {
        type = types
    }
    
    func getNameFormType(type: RenterSettingType) -> String{
        switch type {
        case .RenterSettingTypeAccountAndBind:
            return "账号与绑定"
        case .RenterSettingTypeNoticifyAndAlert:
            return "通知与提醒"
        case .RenterSettingTypePrivacySetting:
            return "隐私设置"
        case .RenterSettingTypeHello:
            return "打招呼语"
        case .RenterSettingTypeVersionUpdate:
            return "版本更新"
        case .RenterSettingTypeRoleChange:
            return "切换身份"
        case .RenterSettingTypeChangePhone:
            return "修改手机号"
        case .RenterSettingTypeChangeWechat:
            return "修改微信"
        }
    }
}

//个人信息
class UserMsgConfigureModel: NSObject {
    
    var type: RenterUserMsgType?
    
    init(types: RenterUserMsgType) {
        type = types
    }
    
    func getNameFormType(type: RenterUserMsgType) -> NSMutableAttributedString{
        switch type {
        case .RenterUserMsgTypeAvatar:
            return FuWenBen(name: "头像", centerStr: "", last: "")
        case .RenterUserMsgTypeNick:
            return FuWenBen(name: "昵称", centerStr: " *", last: " ：")
        case .RenterUserMsgTypeSex:
            return FuWenBen(name: "性别", centerStr: " *", last: " ：")
        case .RenterUserMsgTypeTele:
            return FuWenBen(name: "联系方式", centerStr: " *", last: " ：")
        case .RenterUserMsgTypeWechat:
            return FuWenBen(name: "微信", centerStr: "", last: " ：")
        }
    }
    
    //centerStr *
    func FuWenBen(name: String, centerStr: String, last: String) -> NSMutableAttributedString {
        
        //定义富文本即有格式的字符串
        let attributedStrM : NSMutableAttributedString = NSMutableAttributedString()
        
        if name.count > 0 {
            let nameAtt = NSAttributedString.init(string: name, attributes: [NSAttributedString.Key.backgroundColor : kAppWhiteColor , NSAttributedString.Key.foregroundColor : kAppColor_333333 , NSAttributedString.Key.font : FONT_14])
            attributedStrM.append(nameAtt)
            
        }
        
        if centerStr.count > 0 {
            //*
            let xingxing = NSAttributedString.init(string: centerStr, attributes: [NSAttributedString.Key.backgroundColor : kAppWhiteColor , NSAttributedString.Key.foregroundColor : kAppRedColor , NSAttributedString.Key.font : FONT_18])

            attributedStrM.append(xingxing)
            
        }
        
        if last.count > 0 {
            let lastAtt = NSAttributedString.init(string: last, attributes: [NSAttributedString.Key.backgroundColor : kAppWhiteColor , NSAttributedString.Key.foregroundColor : kAppColor_333333 , NSAttributedString.Key.font : FONT_14])
            attributedStrM.append(lastAtt)
            
        }
        
        
        //图片
        //        let smileImage  = UIImage.init(named: "tupian")
        //        let textAttachment : NSTextAttachment = NSTextAttachment()
        //        textAttachment.image = smileImage
        //        textAttachment.bounds = CGRect(x: 0, y: -4, width: 22, height: 22)
        //         attributedStrM.append(NSAttributedString(attachment: textAttachment))
        
        
        return attributedStrM
    }
}

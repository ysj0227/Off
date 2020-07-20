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

//业主
//网点创建
class OwnerCreatBranchConfigureModel: NSObject {

    var type: OwnerCreteBranchType?
    
    init(types: OwnerCreteBranchType) {
        type = types
    }
    
    func getNameFormType(type: OwnerCreteBranchType) -> NSMutableAttributedString{
        switch type {
        case .OwnerCreteBranchTypeBranchName:
            return FuWenBen(name: "网点名称", centerStr: " *", last: " ：")
        case .OwnerCreteBranchTypeBranchDistrictArea:
            return FuWenBen(name: "所在区域", centerStr: " *", last: " ：")
        case .OwnerCreteBranchTypeBranchAddress:
            return FuWenBen(name: "详细地址", centerStr: " *", last: " ：")
        case .OwnerCreteBranchTypeUploadYingyePhoto:
            return FuWenBen(name: "上传网点封面图", centerStr: " *", last: "")
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
        
        return attributedStrM
    }
}

//业主
//写字楼创建
class OwnerCreatBuildingConfigureModel: NSObject {

    var type: OwnerCreteBuildingType?
    
    init(types: OwnerCreteBuildingType) {
        type = types
    }
    
    func getNameFormType(type: OwnerCreteBuildingType) -> NSMutableAttributedString{
        switch type {
        case .OwnerCreteBuildingTypeBranchName:
            return FuWenBen(name: "写字楼名称", centerStr: " *", last: " ：")
        case .OwnerCreteBuildingTypeBranchDistrictArea:
            return FuWenBen(name: "所在区域", centerStr: " *", last: " ：")
        case .OwnerCreteBuildingTypeBranchAddress:
            return FuWenBen(name: "详细地址", centerStr: " *", last: " ：")
        case .OwnerCreteBuildingTypeUploadYingyePhoto:
            return FuWenBen(name: "上传楼盘封面图", centerStr: " *", last: " ：")
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
        
        return attributedStrM
    }
}

//业主
//公司创建
class OwnerCreatCompanyConfigureModel: NSObject {
    
    //业主
    //创建公司

    var type: OwnerCreteCompanyType?
    
    init(types: OwnerCreteCompanyType) {
        type = types
    }
    
    func getNameFormType(type: OwnerCreteCompanyType) -> NSMutableAttributedString{
        switch type {
        case .OwnerCreteCompanyTypeIedntify:
            return FuWenBen(name: "认证身份", centerStr: "", last: " ：")
        case .OwnerCreteCompanyTypeCompanyName:
            return FuWenBen(name: "公司名称", centerStr: " *", last: " ：")
        case .OwnerCreteCompanyTypeCompanyAddress:
            return FuWenBen(name: "公司地址", centerStr: " *", last: " ：")
        case .OwnerCreteCompanyTypeYingyeCode:
            return FuWenBen(name: "营业执照注册号", centerStr: " *", last: " ：")
        case .OwnerCreteCompanyTypeUploadYingyePhoto:
            return FuWenBen(name: "上传营业执照", centerStr: " *", last: "")
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
        
        return attributedStrM
    }
}


//业主
// 业主 - 公司认证
class OwnerCompanyIedntifyConfigureModel: ConfigureModel {
    
    var type: OwnerCompanyIedntifyType?
    
    init(types: OwnerCompanyIedntifyType) {
        type = types
    }
    func getNameFormType(type: OwnerCompanyIedntifyType) -> String{
        switch type {
        case .OwnerCompanyIedntifyTypeIdentigy:
            return "认证身份："
        case .OwnerCompanyIedntifyTypeCompanyname:
            return "公司名称："
        case .OwnerCompanyIedntifyTypeBuildingName:
            return "写字楼名称："
        case .OwnerCompanyIedntifyTypeBuildingAddress:
            return "写字楼地址："
        case .OwnerCompanyIedntifyTypeBuildingFCType:
            return "房产类型："
        case .OwnerCompanyIedntifyTypeUploadFangchanzheng:
            return "上传房产证"
        case .OwnerCompanyIedntifyTypeUploadZulinAgent:
            return "上传租赁协议"
//        case .OwnerCompanyIedntifyTypeUploadMainimg:
//            return "上传楼盘封面图"
        }
    }
    func getDescFormType(type: OwnerCompanyIedntifyType) -> String{
        switch type {
        case .OwnerCompanyIedntifyTypeIdentigy:
            return ""
        case .OwnerCompanyIedntifyTypeCompanyname:
            return ""
        case .OwnerCompanyIedntifyTypeBuildingName:
            return ""
        case .OwnerCompanyIedntifyTypeBuildingAddress:
            return ""
        case .OwnerCompanyIedntifyTypeBuildingFCType:
            return ""
        case .OwnerCompanyIedntifyTypeUploadFangchanzheng:
            return "请确保所上传的房产信息与公司信息一致"
        case .OwnerCompanyIedntifyTypeUploadZulinAgent:
            return "上传内容务必包含承租方名称、租赁大厦名称和出租方公章"
//        case .OwnerCompanyIedntifyTypeUploadMainimg:
//            return ""
        }
    }
}

//业主
//联合办公认证
class OwnerJointIedntifyConfigureModel: ConfigureModel {
    
    var type: OwnerJointIedntifyType?
    
    init(types: OwnerJointIedntifyType) {
        type = types
    }
    func getNameFormType(type: OwnerJointIedntifyType) -> String{
        switch type {
        case .OwnerJointIedntifyTypeIdentigy:
            return "认证身份："
        case .OwnerJointIedntifyTypeBranchname:
            return "网点名称："
        case .OwnerJointIedntifyTypeCompanyname:
            return "所属公司："
        case .OwnerJointIedntifyTypeBuildingName:
            return "所在楼盘："
        case .OwnerJointIedntifyTypeUploadFangchanzheng:
            return "上传房产证"
        case .OwnerJointIedntifyTypeUploadZulinAgent:
            return "上传租赁协议"
        case .OwnerPersonalIedntifyTypeBuildingFCType:
            return "房产类型："
//        case .OwnerJointIedntifyTypeUploadMainimg:
//            return "上传楼盘封面图"
        }
    }
    func getDescFormType(type: OwnerJointIedntifyType) -> String{
        switch type {
        case .OwnerJointIedntifyTypeIdentigy:
            return ""
        case .OwnerJointIedntifyTypeBranchname:
            return ""
        case .OwnerJointIedntifyTypeCompanyname:
            return ""
        case .OwnerJointIedntifyTypeBuildingName:
            return ""
        case .OwnerPersonalIedntifyTypeBuildingFCType:
            return ""
        case .OwnerJointIedntifyTypeUploadFangchanzheng:
            return "请确保所上传的房产信息与公司信息一致"
        case .OwnerJointIedntifyTypeUploadZulinAgent:
            return "上传内容务必包含承租方名称、租赁大厦名称和出租方公章"
//        case .OwnerJointIedntifyTypeUploadMainimg:
//            return ""
        }
    }
}

//业主
//个人认证
class OwnerPersonalIedntifyConfigureModel: ConfigureModel {
    
    var type: OwnerPersonalIedntifyType?
    
    init(types: OwnerPersonalIedntifyType) {
        type = types
    }
    func getNameFormType(type: OwnerPersonalIedntifyType) -> String{
        switch type {
        case .OwnerPersonalIedntifyTypeIdentify:
            return "认证身份："
        case .OwnerPersonalIedntifyTypeUserName:
            return "姓名："
        case .OwnerPersonalIedntifyTypeUserIdentifyCode:
            return "身份证号："
        case .OwnerPersonalIedntifyTypeUploadIdentifyPhoto:
            return "上传身份证"
        case .OwnerPersonalIedntifyTypeBuildingName:
            return "写字楼名称："
        case .OwnerPersonalIedntifyTypeBuildingAddress:
            return "写字楼地址："
        case .OwnerPersonalIedntifyTypeBuildingFCType:
            return "房产类型："
        case .OwnerPersonalIedntifyTypeUploadFangchanzheng:
            return "上传房产证"
        case .OwnerPersonalIedntifyTypeUploadZulinAgent:
            return "上传租赁协议"
        }
    }
    func getDescFormType(type: OwnerPersonalIedntifyType) -> String{
        switch type {
        case .OwnerPersonalIedntifyTypeIdentify, .OwnerPersonalIedntifyTypeUserName, .OwnerPersonalIedntifyTypeUserIdentifyCode, .OwnerPersonalIedntifyTypeUploadIdentifyPhoto, .OwnerPersonalIedntifyTypeBuildingName, .OwnerPersonalIedntifyTypeBuildingAddress, .OwnerPersonalIedntifyTypeBuildingFCType:
            return ""
        case .OwnerPersonalIedntifyTypeUploadFangchanzheng:
            return "请确保所上传的房产信息与公司信息一致"
        case .OwnerPersonalIedntifyTypeUploadZulinAgent:
            return "上传内容务必包含承租方名称、租赁大厦名称和出租方公章"
        }
    }
}

//我的 - 租户
class RenterMineConfigureModel: ConfigureModel {
    
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
            return "隐私条款"
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
//我的 - 业主
class OwnerMineConfigureModel: ConfigureModel {
    
    var type: OwnerMineType?
    
    init(types: OwnerMineType) {
        type = types
    }
    
    func getNameFormType(type: OwnerMineType) -> String{
        switch type {
        case .OwnerMineTypeAuthority:
            return "员工管理"
        case .OwnerMineTypeHelpAndFeedback:
            return "帮助与反馈"
        case .OwnerMineTypeCusomers:
            return "客服"
        case .OwnerMineTypeRegisterAgent:
            return "隐私条款"
        case .OwnerMineTypeAboutus:
            return "关于我们"
        }
    }
    func getIconFormType(type: OwnerMineType) -> String{
        switch type {
        case .OwnerMineTypeAuthority:
            return "authority"
        case .OwnerMineTypeHelpAndFeedback:
            return "helpAndFeedback"
        case .OwnerMineTypeCusomers:
            return "customers"
        case .OwnerMineTypeRegisterAgent:
            return "agentRegular"
        case .OwnerMineTypeAboutus:
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
//        case .RenterSettingTypeAccountAndBind:
//            return "账号与绑定"
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
            return "绑定微信"
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
            return FuWenBen(name: "姓名", centerStr: " *", last: " ：")
        case .RenterUserMsgTypeSex:
            return FuWenBen(name: "性别", centerStr: " *", last: " ：")
        case .RenterUserMsgTypeTele:
            return FuWenBen(name: "联系方式", centerStr: " *", last: " ：")
        case .RenterUserMsgTypeWechat:
            return FuWenBen(name: "微信", centerStr: "", last: " ：")
        case .RenterUserMsgTypeCompany:
            return FuWenBen(name: "公司", centerStr: "", last: " ：")
        case .RenterUserMsgTypeJob:
            return FuWenBen(name: "职位", centerStr: "", last: " ：")
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

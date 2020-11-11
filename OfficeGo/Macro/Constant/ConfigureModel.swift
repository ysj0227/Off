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


//房东
//房源管理写字楼创建
class OwnerBuildingJointCreatAddConfigureModel: NSObject {
    
    var type: OwnerBuildingCreteAddType?
    
    init(types: OwnerBuildingCreteAddType) {
        type = types
    }
    
    func getNameFormType(type: OwnerBuildingCreteAddType) -> NSMutableAttributedString{
        switch type {
        case .OwnerBuildingCreteAddTypeBuildingName:
            return FuWenBen(name: "楼盘名称", centerStr: " * ", last: "")
        case .OwnerBuildingCreteAddTypeBuildingDistrictArea:
            return FuWenBen(name: "所在区域", centerStr: " * ", last: "")
        case .OwnerBuildingCreteAddTypeBuildingAddress:
            return FuWenBen(name: "详细地址", centerStr: " * ", last: "")
        case .OwnerBuildingCreteAddTypeUploadMainPhoto:
            return FuWenBen(name: "上传封面图", centerStr: " * ", last: "")
        case .OwnerBuildingCreteAddTypeUploadFCZPhoto:
            return FuWenBen(name: "上传房产证", centerStr: " * ", last: "")
        }
    }
    
    //centerStr *
    func FuWenBen(name: String, centerStr: String, last: String) -> NSMutableAttributedString {
        
        //定义富文本即有格式的字符串
        let attributedStrM : NSMutableAttributedString = NSMutableAttributedString()
        
        if name.count > 0 {
            let nameAtt = NSAttributedString.init(string: name, attributes: [NSAttributedString.Key.backgroundColor : kAppWhiteColor , NSAttributedString.Key.foregroundColor : kAppColor_999999 , NSAttributedString.Key.font : FONT_14])
            attributedStrM.append(nameAtt)
            
        }
        
        if centerStr.count > 0 {
            //*
            let xingxing = NSAttributedString.init(string: centerStr, attributes: [NSAttributedString.Key.backgroundColor : kAppWhiteColor , NSAttributedString.Key.foregroundColor : kAppRedColor , NSAttributedString.Key.font : FONT_18])
            
            attributedStrM.append(xingxing)
            
        }
        
        if last.count > 0 {
            let lastAtt = NSAttributedString.init(string: last, attributes: [NSAttributedString.Key.backgroundColor : kAppWhiteColor , NSAttributedString.Key.foregroundColor : kAppColor_999999 , NSAttributedString.Key.font : FONT_14])
            attributedStrM.append(lastAtt)
            
        }
        
        return attributedStrM
    }
    
    func getPalaceHolderFormType(type: OwnerBuildingCreteAddType) -> String{
        switch type {
        case .OwnerBuildingCreteAddTypeBuildingName:
            return "请输入楼盘名称"
        case .OwnerBuildingCreteAddTypeBuildingDistrictArea:
            return "请选择城市、区域与商圈"
        case .OwnerBuildingCreteAddTypeBuildingAddress:
            return "请输入详细地址（2～100个字）"
        case .OwnerBuildingCreteAddTypeUploadMainPhoto:
            return ""
        case .OwnerBuildingCreteAddTypeUploadFCZPhoto:
            return ""
        }
    }
}

///房东 - 开放工位编辑
class OwnerBuildingJointOpenStationConfigureModel : ConfigureModel {
    var type : OwnerBuildingJointOpenStationType?
    
    init(types: OwnerBuildingJointOpenStationType) {
        type = types
    }
    
    func getNameFormType(type: OwnerBuildingJointOpenStationType) -> NSMutableAttributedString{
        switch type {
        ///工位数 *
        case .OwnerBuildingJointOpenStationTypeSeats:
            return FuWenBen(name: "工位数", centerStr: " * ", last: "")
        ///租金 *
        case .OwnerBuildingJointOpenStationTypePrice:
            return FuWenBen(name: "租金", centerStr: " * ", last: "")
        ///所在楼层 *
        case .OwnerBuildingJointOpenStationTypeTotalFloor:
            return FuWenBen(name: "所在楼层", centerStr: " * ", last: "")
        ///净高
        case .OwnerBuildingJointOpenStationTypeClearHeight:
            return FuWenBen(name: "净高", centerStr: "   ", last: "")
        ///最短租期 *
        case .OwnerBuildingJointOpenStationTypeMinRentalPeriod:
            return FuWenBen(name: "最短租期", centerStr: " * ", last: "")
        ///免租期 *
        case .OwnerBuildingJointOpenStationTypeRentFreePeriod:
            return FuWenBen(name: "免租期", centerStr: " * ", last: "")
        ///上传图片 *
        case .OwnerBuildingJointOpenStationTypeBuildingImage:
            return FuWenBen(name: "上传图片", centerStr: " * ", last: "")
        }
    }
    
    func getPalaceHolderFormType(type: OwnerBuildingJointOpenStationType) -> String{
        switch type {
        ///工位数 *
        case .OwnerBuildingJointOpenStationTypeSeats:
            return "个"
        ///租金 *
        case .OwnerBuildingJointOpenStationTypePrice:
            return "元/位/月"
        ///所在楼层 *
        case .OwnerBuildingJointOpenStationTypeTotalFloor:
            return ""
        ///净高
        case .OwnerBuildingJointOpenStationTypeClearHeight:
            return "米"
        ///最短租期 *
        case .OwnerBuildingJointOpenStationTypeMinRentalPeriod:
            return "月"
        ///免租期 *
        case .OwnerBuildingJointOpenStationTypeRentFreePeriod:
            return ""
        ///上传图片 *
        case .OwnerBuildingJointOpenStationTypeBuildingImage:
            return "可上传9张图片，单张不大于10M，支持jpg、jpeg、png格式"
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
            let lastAtt = NSAttributedString.init(string: last, attributes: [NSAttributedString.Key.backgroundColor : kAppWhiteColor , NSAttributedString.Key.foregroundColor : kAppColor_999999 , NSAttributedString.Key.font : FONT_10])
            attributedStrM.append(lastAtt)
            
        }
        
        return attributedStrM
    }
}

///房东 - 独立办公室编辑
class OwnerBuildingJointOfficeConfigureModel : ConfigureModel {
    var type : OwnerBuildingJointOfficeType?
    
    init(types: OwnerBuildingJointOfficeType) {
        type = types
    }
    
    func getNameFormType(type: OwnerBuildingJointOfficeType) -> NSMutableAttributedString{
        switch type {
        ///标题
        case .OwnerBuildingJointOfficeTypeName:
            return FuWenBen(name: "标题", centerStr: "   ", last: "")
        ///出租方式 *
//        case .OwnerBuildingJointOfficeTypeRentType:
//            return FuWenBen(name: "出租方式", centerStr: " * ", last: "")
        ///工位数 *
        case .OwnerBuildingJointOfficeTypeSeats:
            return FuWenBen(name: "工位数", centerStr: " * ", last: "")
        ///面积
        case .OwnerBuildingJointOfficeTypeArea:
            return FuWenBen(name: "面积", centerStr: "   ", last: "")
        ///租金 *
        case .OwnerBuildingJointOfficeTypePrice:
            return FuWenBen(name: "租金", centerStr: " * ", last: "")
        ///所在楼层 *
        case .OwnerBuildingJointOfficeTypeTotalFloor:
            return FuWenBen(name: "所在楼层", centerStr: " * ", last: "")
        ///最短租期 *
        case .OwnerBuildingJointOfficeTypeMinRentalPeriod:
            return FuWenBen(name: "最短租期", centerStr: " * ", last: "")
        ///免租期 *
        case .OwnerBuildingJointOfficeTypeRentFreePeriod:
            return FuWenBen(name: "免租期", centerStr: " * ", last: "")
        ///空调类型 *
        case .OwnerBuildingJointOfficeTypeAirConditionType:
            return FuWenBen(name: "空调类型", centerStr: " * ", last: "")
        ///空调费
        case .OwnerBuildingJointOfficeTypeAirConditionCoast:
            return FuWenBen(name: "空调费", centerStr: "   ", last: "")
        ///车位数
        case .OwnerBuildingJointOfficeTypeParkingNum:
            return FuWenBen(name: "车位数", centerStr: "   ", last: "")
        ///车位费
        case .OwnerBuildingJointOfficeTypeParkingCoast:
            return FuWenBen(name: "车位费", centerStr: "   ", last: "")
        ///净高
        case .OwnerBuildingJointOfficeTypeClearHeight:
            return FuWenBen(name: "净高", centerStr: "   ", last: "")
        ///户型格局简介
        case .OwnerBuildingJointOfficeTypeIntrodution:
            return FuWenBen(name: "户型格局简介", centerStr: "   ", last: "")
        ///上传办公室图片 *
        case .OwnerBuildingJointOfficeTypeBuildingImage:
            return FuWenBen(name: "上传办公室图片", centerStr: " * ", last: "")
        ///上传办公室视频
        case .OwnerBuildingJointOfficeTypeBuildingVideo:
            return FuWenBen(name: "上传办公室视频", centerStr: "   ", last: "")
        ///上传办公室vr
        case .OwnerBuildingJointOfficeTypeBuildingVR:
            return FuWenBen(name: "VR全景展示", centerStr: "   ", last: "")
        }
    }
    
    func getPalaceHolderFormType(type: OwnerBuildingJointOfficeType) -> String{
        switch type {
        ///标题
        case .OwnerBuildingJointOfficeTypeName:
            return "请输入标题"
        ///出租方式 *
//        case .OwnerBuildingJointOfficeTypeRentType:
//            return ""
        ///工位数 *
        case .OwnerBuildingJointOfficeTypeSeats:
            return "个"
        ///面积
        case .OwnerBuildingJointOfficeTypeArea:
            return "㎡"
        ///租金
        case .OwnerBuildingJointOfficeTypePrice:
            return "元/月"
        ///所在楼层 *
        case .OwnerBuildingJointOfficeTypeTotalFloor:
            return ""
        ///最短租期 *
        case .OwnerBuildingJointOfficeTypeMinRentalPeriod:
            return "月"
        ///免租期 *
        case .OwnerBuildingJointOfficeTypeRentFreePeriod:
            return ""
        ///空调类型 *
        case .OwnerBuildingJointOfficeTypeAirConditionType:
            return "请选择空调类型"
        ///空调费
        case .OwnerBuildingJointOfficeTypeAirConditionCoast:
            return ""
        ///车位数
        case .OwnerBuildingJointOfficeTypeParkingNum:
            //return "例：地面车位100个，车库车位25个"
            return ""
        ///车位费
        case .OwnerBuildingJointOfficeTypeParkingCoast:
            //return "请输入车位费 元/月"
            return ""
        ///净高
        case .OwnerBuildingJointOfficeTypeClearHeight:
            return "米"
        ///户型格局简介
        case .OwnerBuildingJointOfficeTypeIntrodution:
            return "简单描述该办公室的房型格局"
        ///上传办公室图片 *
        case .OwnerBuildingJointOfficeTypeBuildingImage:
            return "可上传9张图片，单张不大于10M，支持jpg、jpeg、png格式"
        ///上传办公室视频
        case .OwnerBuildingJointOfficeTypeBuildingVideo:
            return "上传视频不大于100M，支持mp4、Mov格式"
        ///上传办公室vr
        case .OwnerBuildingJointOfficeTypeBuildingVR:
            return "请输入正确的VR"
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
            let lastAtt = NSAttributedString.init(string: last, attributes: [NSAttributedString.Key.backgroundColor : kAppWhiteColor , NSAttributedString.Key.foregroundColor : kAppColor_999999 , NSAttributedString.Key.font : FONT_10])
            attributedStrM.append(lastAtt)
            
        }
        
        return attributedStrM
    }
}

///房东 - 办公室编辑
class OwnerBuildingOfficeConfigureModel : ConfigureModel {
    var type : OwnerBuildingOfficeType?
    
    init(types: OwnerBuildingOfficeType) {
        type = types
    }
    
    func getNameFormType(type: OwnerBuildingOfficeType) -> NSMutableAttributedString{
        switch type {
        ///标题
        case .OwnerBuildingOfficeTypeName:
            return FuWenBen(name: "标题 ", centerStr: "   ", last: "")
        ///面积 *
        case .OwnerBuildingOfficeTypeArea:
            return FuWenBen(name: "面积 ", centerStr: " * ", last: "")
        ///可置工位 *
        case .OwnerBuildingOfficeTypeSeats:
            return FuWenBen(name: "可置工位", centerStr: " * ", last: "")
        ///租金单价 *
        case .OwnerBuildingOfficeTypePrice:
            return FuWenBen(name: "租金单价", centerStr: " * ", last: "")
        ///租金总价 *
        case .OwnerBuildingOfficeTypeTotalPrice:
            return FuWenBen(name: "租金总价", centerStr: " * ", last: "")
        ///所在楼层 *
        case .OwnerBuildingOfficeTypeTotalFloor:
            return FuWenBen(name: "所在楼层", centerStr: " * ", last: "")
        ///净高 *
        case .OwnerBuildingOfficeTypeClearHeight:
            return FuWenBen(name: "净高", centerStr: " * ", last: "")
        ///层高
        case .OwnerBuildingOfficeTypeFloorHeight:
            return FuWenBen(name: "层高", centerStr: "   ", last: "")
        ///最短租期 *
        case .OwnerBuildingOfficeTypeMinRentalPeriod:
            return FuWenBen(name: "最短租期", centerStr: " * ", last: "")
        ///免租期 *
        case .OwnerBuildingOfficeTypeRentFreePeriod:
            return FuWenBen(name: "免租期", centerStr: " * ", last: "")
        ///物业费 *
        case .OwnerBuildingOfficeTypePropertyCoast:
            return FuWenBen(name: "物业费", centerStr: " * ", last: "")
        ///装修程度 *
        case .OwnerBuildingOfficeTypeDocument:
            return FuWenBen(name: "装修程度", centerStr: " * ", last: "")
        ///户型格局简介
        case .OwnerBuildingOfficeTypeIntrodution:
            return FuWenBen(name: "户型格局简介", centerStr: " * ", last: "")
        ///办公室特色
        case .OwnerBuildingOfficeTypeFeature:
            return FuWenBen(name: "办公室特色", centerStr: " ", last: "最多选择4项")
        ///上传办公室图片 *
        case .OwnerBuildingOfficeTypeBuildingImage:
            return FuWenBen(name: "上传办公室图片", centerStr: " * ", last: "")
        ///上传办公室视频
        case .OwnerBuildingOfficeTypeBuildingVideo:
            return FuWenBen(name: "上传办公室视频", centerStr: "   ", last: "")
        ///上传办公室vr
        case .OwnerBuildingOfficeTypeBuildingVR:
            return FuWenBen(name: "VR全景展示", centerStr: "   ", last: "")
        }
    }
    
    func getPalaceHolderFormType(type: OwnerBuildingOfficeType) -> String{
        switch type {
        ///标题
        case .OwnerBuildingOfficeTypeName:
            return "例：临地铁200㎡稀缺房源寻租"
        ///面积 *
        case .OwnerBuildingOfficeTypeArea:
            return "㎡"
        ///可置工位 *
        case .OwnerBuildingOfficeTypeSeats:
            return "个"
        ///租金单价 *
        case .OwnerBuildingOfficeTypePrice:
            return "元/㎡/天"
        ///租金总价 *
        case .OwnerBuildingOfficeTypeTotalPrice:
            return "元/月"
        ///所在楼层 *
        case .OwnerBuildingOfficeTypeTotalFloor:
            return ""
        ///净高 *
        case .OwnerBuildingOfficeTypeClearHeight:
            return "米"
        ///层高
        case .OwnerBuildingOfficeTypeFloorHeight:
            return "米"
        ///最短租期 *
        case .OwnerBuildingOfficeTypeMinRentalPeriod:
            return "年"
        ///免租期 *
        case .OwnerBuildingOfficeTypeRentFreePeriod:
            return ""
        ///物业费 *
        case .OwnerBuildingOfficeTypePropertyCoast:
            return "元/月"
        ///装修程度 *
        case .OwnerBuildingOfficeTypeDocument:
            return ""
        ///户型格局简介
        case .OwnerBuildingOfficeTypeIntrodution:
//            return "简单描述该办公室的房型格局，清晰的图片或VR能够吸引更多客户的关注"
            return "简单描述该办公室的房型格局"
        ///办公室特色
        case .OwnerBuildingOfficeTypeFeature:
            return ""
        ///上传办公室图片 *
        case .OwnerBuildingOfficeTypeBuildingImage:
            return "可上传9张图片，单张不大于10M，支持jpg、jpeg、png格式"
        ///上传办公室视频
        case .OwnerBuildingOfficeTypeBuildingVideo:
            return "上传视频不大于100M，支持mp4、Mov格式"
        ///上传办公室vr
        case .OwnerBuildingOfficeTypeBuildingVR:
            return "请输入正确的VR链接"
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
            let lastAtt = NSAttributedString.init(string: last, attributes: [NSAttributedString.Key.backgroundColor : kAppWhiteColor , NSAttributedString.Key.foregroundColor : kAppColor_999999 , NSAttributedString.Key.font : FONT_10])
            attributedStrM.append(lastAtt)
            
        }
        
        return attributedStrM
    }
}

///房东 - 网点编辑
class OwnerBuildingJointEditConfigureModel : ConfigureModel {
    var type : OwnerBuildingJointEditType?
    
    init(types: OwnerBuildingJointEditType) {
        type = types
    }
    
    func getNameFormType(type: OwnerBuildingJointEditType) -> NSMutableAttributedString{
        switch type {
        ///写字楼名称
        case .OwnerBuildingJointEditTypeBuildingName:
            return FuWenBen(name: "网点名称", centerStr: " * ", last: "")
        ///所在区域
        case .OwnerBuildingJointEditTypeDisctict:
            return FuWenBen(name: "所在区域", centerStr: " * ", last: "")
        ///详细地址
        case .OwnerBuildingJointEditTypeDetailAddress:
            return FuWenBen(name: "详细地址", centerStr: " * ", last: "")
        ///所在楼层
        case .OwnerBuildingJointEditTypeTotalFloor:
            return FuWenBen(name: "所在楼层", centerStr: " * ", last: "")
        ///净高
        case .OwnerBuildingJointEditTypeClearHeight:
            return FuWenBen(name: "净高", centerStr: " * ", last: "")
        ///空调类型
        case .OwnerBuildingJointEditTypeAirConditionType:
            return FuWenBen(name: "空调类型", centerStr: " * ", last: "")
        ///空调费
        case .OwnerBuildingJointEditTypeAirConditionCoast:
            return FuWenBen(name: "空调费", centerStr: "   ", last: "")
        ///会议室数量
        case .OwnerBuildingJointEditTypeConferenceNumber:
            return FuWenBen(name: "会议室数量", centerStr: " * ", last: "")
        ///最多容纳人数
        case .OwnerBuildingJointEditTypeConferencePeopleNumber:
            return FuWenBen(name: "最多容纳人数", centerStr: "   ", last: "")
        ///会议室配套
        case .OwnerBuildingJointEditTypeRoomMatching:
            return FuWenBen(name: "会议室配套", centerStr: "   ", last: "")
        ///车位数
        case .OwnerBuildingJointEditTypeParkingNum:
            return FuWenBen(name: "车位数", centerStr: "   ", last: "")
        ///车位费
        case .OwnerBuildingJointEditTypeParkingCoast:
            return FuWenBen(name: "车位费", centerStr: "   ", last: "")
        ///电梯数 - 客梯
        case .OwnerBuildingJointEditTypePassengerNum:
            return FuWenBen(name: "电梯数", centerStr: "   ", last: "")
        ///电梯数 - 客、货梯
        case .OwnerBuildingJointEditTypeFloorCargoNum:
            return FuWenClearBen(name: "电梯数", centerStr: "   ", last: "")
        ///网络
        case .OwnerBuildingJointEditTypeNetwork:
            return FuWenBen(name: "网络", centerStr: "   ", last: "")
        ///入驻企业
        case .OwnerBuildingJointEditTypeEnterCompany:
            return FuWenBen(name: "入驻企业", centerStr: "   ", last: "")
        ///详细介绍
        case .OwnerBuildingJointEditTypeDetailIntroduction:
            return FuWenBen(name: "详细介绍", centerStr: "   ", last: "")
        ///特色
        case .OwnerBuildingJointEditTypeFeature:
            return FuWenBen(name: "共享办公网点特色", centerStr: " ", last: "最多选择4项")
        ///共享服务
        case .OwnerBuildingJointEditTypeShareService:
            return FuWenBen(name: "共享服务", centerStr: "   ", last: "")
        ///上传楼盘图片
        case .OwnerBuildingJointEditTypeBuildingImage:
            return FuWenBen(name: "上传网点图片", centerStr: " * ", last: "")
        ///上传楼盘视频
        case .OwnerBuildingJointEditTypeBuildingVideo:
            return FuWenBen(name: "上传网点视频", centerStr: "   ", last: "")
        ///上传楼盘vr
        case .OwnerBuildingJointEditTypeBuildingVR:
            return FuWenBen(name: "VR全景展示", centerStr: "   ", last: "")
        }
    }
    
    func getPalaceHolderFormType(type: OwnerBuildingJointEditType) -> String{
        switch type {
        ///写字楼名称
        case .OwnerBuildingJointEditTypeBuildingName:
            return "请输入名称"
        ///所在区域
        case .OwnerBuildingJointEditTypeDisctict:
            return "请选择城市、区域与商圈"
        ///详细地址
        case .OwnerBuildingJointEditTypeDetailAddress:
            return "请输入详细地址（2～100个字）"
        ///所在楼层
        case .OwnerBuildingJointEditTypeTotalFloor:
            return ""
        ///净高
        case .OwnerBuildingJointEditTypeClearHeight:
            return "米"
        ///空调类型
        case .OwnerBuildingJointEditTypeAirConditionType:
            return "请选择空调类型"
        ///空调费
        case .OwnerBuildingJointEditTypeAirConditionCoast:
            return "空调费"
        ///会议室数量
        case .OwnerBuildingJointEditTypeConferenceNumber:
            return "个"
        ///最多容纳人数
        case .OwnerBuildingJointEditTypeConferencePeopleNumber:
            return "人"
        ///会议室配套
        case .OwnerBuildingJointEditTypeRoomMatching:
            return ""
        ///车位数
        case .OwnerBuildingJointEditTypeParkingNum:
//            return "个"
            return "例：地面车位100个，车库车位25个"
        ///车位费
        case .OwnerBuildingJointEditTypeParkingCoast:
//            return "元/月"
            return "元/月"
        ///电梯数 - 客梯
        case .OwnerBuildingJointEditTypePassengerNum:
            return "个 (客梯)"
        ///电梯数 - 客、货梯
        case .OwnerBuildingJointEditTypeFloorCargoNum:
            return "个 (货梯)"
        ///网络
        case .OwnerBuildingJointEditTypeNetwork:
            return ""
        ///入驻企业
        case .OwnerBuildingJointEditTypeEnterCompany:
            return "请输入企业"
        ///详细介绍
        case .OwnerBuildingJointEditTypeDetailIntroduction:
            return ""
        ///特色
        case .OwnerBuildingJointEditTypeFeature:
            return ""
        ///共享服务
        case .OwnerBuildingJointEditTypeShareService:
            return ""
        ///上传楼盘图片
        case .OwnerBuildingJointEditTypeBuildingImage:
            return "可上传9张图片，单张不大于10M，支持jpg、jpeg、png格式"
        ///上传楼盘视频
        case .OwnerBuildingJointEditTypeBuildingVideo:
            return "上传视频不大于100M，支持mp4、Mov格式"
        ///上传楼盘vr
        case .OwnerBuildingJointEditTypeBuildingVR:
            return "请输入正确的VR链接"
        }
    }
    
    //centerStr *
    func FuWenClearBen(name: String, centerStr: String, last: String) -> NSMutableAttributedString {
        
        //定义富文本即有格式的字符串
        let attributedStrM : NSMutableAttributedString = NSMutableAttributedString()
        
        if name.count > 0 {
            let nameAtt = NSAttributedString.init(string: name, attributes: [NSAttributedString.Key.backgroundColor : kAppWhiteColor , NSAttributedString.Key.foregroundColor : kAppClearColor , NSAttributedString.Key.font : FONT_14])
            attributedStrM.append(nameAtt)
            
        }
        
        if centerStr.count > 0 {
            //*
            let xingxing = NSAttributedString.init(string: centerStr, attributes: [NSAttributedString.Key.backgroundColor : kAppWhiteColor , NSAttributedString.Key.foregroundColor : kAppClearColor , NSAttributedString.Key.font : FONT_18])
            
            attributedStrM.append(xingxing)
            
        }
        
        if last.count > 0 {
            let lastAtt = NSAttributedString.init(string: last, attributes: [NSAttributedString.Key.backgroundColor : kAppWhiteColor , NSAttributedString.Key.foregroundColor : kAppColor_999999 , NSAttributedString.Key.font : FONT_10])
            attributedStrM.append(lastAtt)
            
        }
        
        return attributedStrM
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
            let lastAtt = NSAttributedString.init(string: last, attributes: [NSAttributedString.Key.backgroundColor : kAppWhiteColor , NSAttributedString.Key.foregroundColor : kAppColor_999999 , NSAttributedString.Key.font : FONT_10])
            attributedStrM.append(lastAtt)
            
        }
        
        return attributedStrM
    }
}

///房东 - 楼盘编辑
class OwnerBuildingEditConfigureModel : ConfigureModel {
    var type : OwnerBuildingEditType?
    
    init(types: OwnerBuildingEditType) {
        type = types
    }
    
    ///获取到楼名item
    func getBuildingNameFormType(type: OWnerBuildingTypeEnum) -> NSMutableAttributedString{
        switch type {
        ///写字楼名称
        case .xieziEnum:
            return FuWenBen(name: "写字楼名称", centerStr: " * ", last: "")
        ///创意名称
        case .chuangyiEnum:
            return FuWenBen(name: "园区名称", centerStr: " * ", last: "")
        ///产业名称
        case .chanyeEnum:
            return FuWenBen(name: "园区名称", centerStr: " * ", last: "")
        }
    }
    ///获取palaceholder
    func getBuildingPalaceHolderFormType(type: OWnerBuildingTypeEnum) -> String{
        switch type {
        ///写字楼名称
        case .xieziEnum:
            return "请输入写字楼名称"
        ///创意名称
        case .chuangyiEnum:
            return "请输入园区名称"
        ///产业名称
        case .chanyeEnum:
            return "请输入园区名称"
        }
    }
    func getNameFormType(type: OwnerBuildingEditType) -> NSMutableAttributedString{
        switch type {
        ///楼盘类型
        case .OwnerBuildingEditTypeBuildingTypew:
            return FuWenBen(name: "楼盘类型", centerStr: " * ", last: "")
        ///写字楼名称
        case .OwnerBuildingEditTypeBuildingName:
            return FuWenBen(name: "写字楼名称", centerStr: " * ", last: "")
        ///楼号/楼名
        case .OwnerBuildingEditTypeBuildingNum:
            return FuWenBen(name: "楼号", centerStr: " * ", last: "")
        ///所在区域
        case .OwnerBuildingEditTypeDisctict:
            return FuWenBen(name: "所在区域", centerStr: " * ", last: "")
        ///详细地址
        case .OwnerBuildingEditTypeDetailAddress:
            return FuWenBen(name: "详细地址", centerStr: " * ", last: "")
        ///总楼层
        case .OwnerBuildingEditTypeTotalFloor:
            return FuWenBen(name: "总楼层", centerStr: " * ", last: "")
        ///竣工时间
        case .OwnerBuildingEditTypeCompelteTime:
            return FuWenBen(name: "竣工时间", centerStr: " * ", last: "")
        ///翻新时间
        case .OwnerBuildingEditTypeRenovationTime:
            return FuWenBen(name: "翻新时间", centerStr: "   ", last: "")
        ///建筑面积
        case .OwnerBuildingEditTypeArea:
            return FuWenBen(name: "建筑面积", centerStr: "   ", last: "")
        ///净高
        case .OwnerBuildingEditTypeClearHeight:
            return FuWenBen(name: "净高", centerStr: " * ", last: "")
        ///层高
        case .OwnerBuildingEditTypeFloorHeight:
            return FuWenBen(name: "层高", centerStr: "   ", last: "")
        ///物业公司
        case .OwnerBuildingEditTypePropertyCompany:
            return FuWenBen(name: "物业公司", centerStr: " * ", last: "")
        ///物业费
        case .OwnerBuildingEditTypePropertyCoast:
            return FuWenBen(name: "物业费", centerStr: " * ", last: "")
        ///车位数
        case .OwnerBuildingEditTypeParkingNum:
            return FuWenBen(name: "车位数", centerStr: " * ", last: "")
        ///车位费
        case .OwnerBuildingEditTypeParkingCoast:
            return FuWenBen(name: "车位费", centerStr: "   ", last: "")
        ///空调类型
        case .OwnerBuildingEditTypeAirConditionType:
            return FuWenBen(name: "空调类型", centerStr: " * ", last: "")
        ///空调费
        case .OwnerBuildingEditTypeAirConditionCoast:
            return FuWenBen(name: "空调费", centerStr: "   ", last: "")
        ///电梯数 - 客梯
        case .OwnerBuildingEditTypePassengerNum:
            return FuWenBen(name: "电梯数", centerStr: " * ", last: "")
        ///电梯数 - 客、货梯
        case .OwnerBuildingEditTypeFloorCargoNum:
            return FuWenClearBen(name: "电梯数", centerStr: " * ", last: "")
        ///网络
        case .OwnerBuildingEditTypeNetwork:
            return FuWenBen(name: "网络", centerStr: "   ", last: "")
        ///入驻企业
        case .OwnerBuildingEditTypeEnterCompany:
            return FuWenBen(name: "入驻企业", centerStr: "   ", last: "")
        ///详细介绍
        case .OwnerBuildingEditTypeDetailIntroduction:
            return FuWenBen(name: "详细介绍", centerStr: "   ", last: "")
        ///特色
        case .OwnerBuildingEditTypeFeature:
            return FuWenBen(name: "楼盘特色", centerStr: " ", last: "最多选择4项")
        ///上传楼盘图片
        case .OwnerBuildingEditTypeBuildingImage:
            return FuWenBen(name: "上传楼盘图片", centerStr: " * ", last: "")
        ///上传楼盘视频
        case .OwnerBuildingEditTypeBuildingVideo:
            return FuWenBen(name: "上传楼盘视频", centerStr: "   ", last: "")
        ///上传楼盘vr
        case .OwnerBuildingEditTypeBuildingVR:
            return FuWenBen(name: "VR全景展示", centerStr: "   ", last: "")
        }
    }
    
    func getPalaceHolderFormType(type: OwnerBuildingEditType) -> String{
        switch type {
        ///楼盘类型
        case .OwnerBuildingEditTypeBuildingTypew:
            return "请选择楼盘类型"
        ///写字楼名称
        case .OwnerBuildingEditTypeBuildingName:
            return "请输入写字楼名称"
        ///楼号/楼名
        case .OwnerBuildingEditTypeBuildingNum:
            return "请输入楼号"
        ///所在区域
        case .OwnerBuildingEditTypeDisctict:
            return "请选择城市、区域与商圈"
        ///详细地址
        case .OwnerBuildingEditTypeDetailAddress:
            return "请输入详细地址（2～100个字）"
        ///总楼层
        case .OwnerBuildingEditTypeTotalFloor:
            return "层"
        ///竣工时间
        case .OwnerBuildingEditTypeCompelteTime:
            return "请选择时间"
        ///翻新时间
        case .OwnerBuildingEditTypeRenovationTime:
            return "请选择时间"
        ///建筑面积
        case .OwnerBuildingEditTypeArea:
            return "万 ㎡"
        ///净高
        case .OwnerBuildingEditTypeClearHeight:
            return "米"
        ///层高
        case .OwnerBuildingEditTypeFloorHeight:
            return "米"
        ///物业公司
        case .OwnerBuildingEditTypePropertyCompany:
            return "请填写物业公司名称"
        ///物业费
        case .OwnerBuildingEditTypePropertyCoast:
            return "元/㎡/月"
        ///车位数
        case .OwnerBuildingEditTypeParkingNum:
            return "例：地面车位100个，车库车位25个"
        ///车位费
        case .OwnerBuildingEditTypeParkingCoast:
            return "元/月"
        ///空调类型
        case .OwnerBuildingEditTypeAirConditionType:
            return "请选择空调类型"
        ///空调费
        case .OwnerBuildingEditTypeAirConditionCoast:
            return "空调费"
        ///电梯数 - 客梯
        case .OwnerBuildingEditTypePassengerNum:
            return "个 (客梯)"
        ///电梯数 - 客、货梯
        case .OwnerBuildingEditTypeFloorCargoNum:
            return "个 (货梯)"
        ///网络
        case .OwnerBuildingEditTypeNetwork:
            return ""
        ///入驻企业
        case .OwnerBuildingEditTypeEnterCompany:
            return "请输入企业"
        ///详细介绍
        case .OwnerBuildingEditTypeDetailIntroduction:
            return ""
        ///特色
        case .OwnerBuildingEditTypeFeature:
            return ""
        ///上传楼盘图片
        case .OwnerBuildingEditTypeBuildingImage:
            return "可上传9张图片，单张不大于10M，支持jpg、jpeg、png格式"
        ///上传楼盘视频
        case .OwnerBuildingEditTypeBuildingVideo:
            return "上传视频不大于100M，支持mp4、Mov格式"
        ///上传楼盘vr
        case .OwnerBuildingEditTypeBuildingVR:
            return "请输入正确的VR链接"
        }
    }
    
    func getTextLength(type: OwnerBuildingEditType) -> Int{
        switch type {
        ///楼盘类型
        case .OwnerBuildingEditTypeBuildingTypew:
            return 0
        ///写字楼名称
        case .OwnerBuildingEditTypeBuildingName:
            return 25
        ///楼号/楼名
        case .OwnerBuildingEditTypeBuildingNum:
            return 10
        ///所在区域
        case .OwnerBuildingEditTypeDisctict:
            return 0
        ///详细地址
        case .OwnerBuildingEditTypeDetailAddress:
            return 100
        ///总楼层
        case .OwnerBuildingEditTypeTotalFloor:
            return 0
        ///竣工时间
        case .OwnerBuildingEditTypeCompelteTime:
            return 0
        ///翻新时间
        case .OwnerBuildingEditTypeRenovationTime:
            return 0
        ///建筑面积
        case .OwnerBuildingEditTypeArea:
            return 6
        ///净高
        case .OwnerBuildingEditTypeClearHeight:
            return 3
        ///层高
        case .OwnerBuildingEditTypeFloorHeight:
            return 3
        ///物业公司
        case .OwnerBuildingEditTypePropertyCompany:
            return 20
        ///物业费
        case .OwnerBuildingEditTypePropertyCoast:
            return 5
        ///车位数
        case .OwnerBuildingEditTypeParkingNum:
            return 9999999
        ///车位费
        case .OwnerBuildingEditTypeParkingCoast:
            return 4
        ///空调类型
        case .OwnerBuildingEditTypeAirConditionType:
            return 0
        ///空调费
        case .OwnerBuildingEditTypeAirConditionCoast:
            return 0
        ///电梯数 - 客梯
        case .OwnerBuildingEditTypePassengerNum:
            return 2
        ///电梯数 - 客、货梯
        case .OwnerBuildingEditTypeFloorCargoNum:
            return 2
        ///网络
        case .OwnerBuildingEditTypeNetwork:
            return 0
        ///入驻企业
        case .OwnerBuildingEditTypeEnterCompany:
            return 0
        ///详细介绍
        case .OwnerBuildingEditTypeDetailIntroduction:
            return 100
        ///特色
        case .OwnerBuildingEditTypeFeature:
            return 0
        ///上传楼盘图片
        case .OwnerBuildingEditTypeBuildingImage:
            return 0
        ///上传楼盘视频
        case .OwnerBuildingEditTypeBuildingVideo:
            return 0
        ///上传楼盘vr
        case .OwnerBuildingEditTypeBuildingVR:
            return 0
        }
    }
    
    //centerStr *
    func FuWenClearBen(name: String, centerStr: String, last: String) -> NSMutableAttributedString {
        
        //定义富文本即有格式的字符串
        let attributedStrM : NSMutableAttributedString = NSMutableAttributedString()
        
        if name.count > 0 {
            let nameAtt = NSAttributedString.init(string: name, attributes: [NSAttributedString.Key.backgroundColor : kAppWhiteColor , NSAttributedString.Key.foregroundColor : kAppClearColor , NSAttributedString.Key.font : FONT_14])
            attributedStrM.append(nameAtt)
            
        }
        
        if centerStr.count > 0 {
            //*
            let xingxing = NSAttributedString.init(string: centerStr, attributes: [NSAttributedString.Key.backgroundColor : kAppWhiteColor , NSAttributedString.Key.foregroundColor : kAppClearColor , NSAttributedString.Key.font : FONT_18])
            
            attributedStrM.append(xingxing)
            
        }
        
        if last.count > 0 {
            let lastAtt = NSAttributedString.init(string: last, attributes: [NSAttributedString.Key.backgroundColor : kAppWhiteColor , NSAttributedString.Key.foregroundColor : kAppColor_999999 , NSAttributedString.Key.font : FONT_10])
            attributedStrM.append(lastAtt)
            
        }
        
        return attributedStrM
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
            let lastAtt = NSAttributedString.init(string: last, attributes: [NSAttributedString.Key.backgroundColor : kAppWhiteColor , NSAttributedString.Key.foregroundColor : kAppColor_999999 , NSAttributedString.Key.font : FONT_10])
            attributedStrM.append(lastAtt)
            
        }
        
        return attributedStrM
    }
}

//房东
//网点创建
class OwnerCreatBranchConfigureModel: NSObject {
    
    var type: OwnerCreteBranchType?
    
    init(types: OwnerCreteBranchType) {
        type = types
    }
    
    func getNameFormType(type: OwnerCreteBranchType) -> NSMutableAttributedString{
        switch type {
        case .OwnerCreteBranchTypeBranchName:
            return FuWenBen(name: "网点名称", centerStr: " * ", last: "")
        case .OwnerCreteBranchTypeBranchDistrictArea:
            return FuWenBen(name: "所在区域", centerStr: " * ", last: "")
        case .OwnerCreteBranchTypeBranchAddress:
            return FuWenBen(name: "详细地址", centerStr: " * ", last: "")
        case .OwnerCreteBranchTypeUploadYingyePhoto:
            return FuWenBen(name: "上传网点封面图", centerStr: " * ", last: "")
        }
    }
    
    //centerStr *
    func FuWenBen(name: String, centerStr: String, last: String) -> NSMutableAttributedString {
        
        //定义富文本即有格式的字符串
        let attributedStrM : NSMutableAttributedString = NSMutableAttributedString()
        
        if name.count > 0 {
            let nameAtt = NSAttributedString.init(string: name, attributes: [NSAttributedString.Key.backgroundColor : kAppWhiteColor , NSAttributedString.Key.foregroundColor : kAppColor_999999 , NSAttributedString.Key.font : FONT_14])
            attributedStrM.append(nameAtt)
            
        }
        
        if centerStr.count > 0 {
            //*
            let xingxing = NSAttributedString.init(string: centerStr, attributes: [NSAttributedString.Key.backgroundColor : kAppWhiteColor , NSAttributedString.Key.foregroundColor : kAppRedColor , NSAttributedString.Key.font : FONT_18])
            
            attributedStrM.append(xingxing)
            
        }
        
        if last.count > 0 {
            let lastAtt = NSAttributedString.init(string: last, attributes: [NSAttributedString.Key.backgroundColor : kAppWhiteColor , NSAttributedString.Key.foregroundColor : kAppColor_999999 , NSAttributedString.Key.font : FONT_14])
            attributedStrM.append(lastAtt)
            
        }
        
        return attributedStrM
    }
}

//房东
//写字楼创建
class OwnerCreatBuildingConfigureModel: NSObject {
    
    var type: OwnerCreteBuildingType?
    
    init(types: OwnerCreteBuildingType) {
        type = types
    }
    
    func getNameFormType(type: OwnerCreteBuildingType) -> NSMutableAttributedString{
        switch type {
        case .OwnerCreteBuildingTypeBranchName:
            return FuWenBen(name: "写字楼名称", centerStr: " * ", last: "")
        case .OwnerCreteBuildingTypeBranchDistrictArea:
            return FuWenBen(name: "所在区域", centerStr: " * ", last: "")
        case .OwnerCreteBuildingTypeBranchAddress:
            return FuWenBen(name: "详细地址", centerStr: " * ", last: "")
        case .OwnerCreteBuildingTypeUploadYingyePhoto:
            return FuWenBen(name: "上传楼盘封面图", centerStr: " * ", last: "")
        }
    }
    
    //centerStr *
    func FuWenBen(name: String, centerStr: String, last: String) -> NSMutableAttributedString {
        
        //定义富文本即有格式的字符串
        let attributedStrM : NSMutableAttributedString = NSMutableAttributedString()
        
        if name.count > 0 {
            let nameAtt = NSAttributedString.init(string: name, attributes: [NSAttributedString.Key.backgroundColor : kAppWhiteColor , NSAttributedString.Key.foregroundColor : kAppColor_999999 , NSAttributedString.Key.font : FONT_14])
            attributedStrM.append(nameAtt)
            
        }
        
        if centerStr.count > 0 {
            //*
            let xingxing = NSAttributedString.init(string: centerStr, attributes: [NSAttributedString.Key.backgroundColor : kAppWhiteColor , NSAttributedString.Key.foregroundColor : kAppRedColor , NSAttributedString.Key.font : FONT_18])
            
            attributedStrM.append(xingxing)
            
        }
        
        if last.count > 0 {
            let lastAtt = NSAttributedString.init(string: last, attributes: [NSAttributedString.Key.backgroundColor : kAppWhiteColor , NSAttributedString.Key.foregroundColor : kAppColor_999999 , NSAttributedString.Key.font : FONT_14])
            attributedStrM.append(lastAtt)
            
        }
        
        return attributedStrM
    }
}

//房东
//公司创建
class OwnerCreatCompanyConfigureModel: NSObject {
    
    //房东
    //创建公司
    
    var type: OwnerCreteCompanyType?
    
    init(types: OwnerCreteCompanyType) {
        type = types
    }
    
    func getNameFormType(type: OwnerCreteCompanyType) -> NSMutableAttributedString{
        switch type {
        case .OwnerCreteCompanyTypeIedntify:
            return FuWenBen(name: "认证身份", centerStr: " ", last: "")
        case .OwnerCreteCompanyTypeCompanyName:
            return FuWenBen(name: "公司名称", centerStr: " * ", last: "")
        case .OwnerCreteCompanyTypeCompanyAddress:
            return FuWenBen(name: "公司地址", centerStr: " * ", last: "")
        case .OwnerCreteCompanyTypeYingyeCode:
            return FuWenBen(name: "统一社会信用代码", centerStr: " * ", last: "")
        case .OwnerCreteCompanyTypeUploadYingyePhoto:
            return FuWenBen(name: "上传营业执照", centerStr: " * ", last: "")
        }
    }
    
    func getPalaceHolderFormType(type: OwnerCreteCompanyType) -> String{
        switch type {
        case .OwnerCreteCompanyTypeIedntify:
            return ""
        case .OwnerCreteCompanyTypeCompanyName:
            return "请输入公司名称"
        case .OwnerCreteCompanyTypeCompanyAddress:
            return "请输入公司地址"
        case .OwnerCreteCompanyTypeYingyeCode:
            return ""
        case .OwnerCreteCompanyTypeUploadYingyePhoto:
            return ""
        }
    }
    //centerStr *
    func FuWenBen(name: String, centerStr: String, last: String) -> NSMutableAttributedString {
        
        //定义富文本即有格式的字符串
        let attributedStrM : NSMutableAttributedString = NSMutableAttributedString()
        
        if name.count > 0 {
            let nameAtt = NSAttributedString.init(string: name, attributes: [NSAttributedString.Key.backgroundColor : kAppWhiteColor , NSAttributedString.Key.foregroundColor : kAppColor_999999 , NSAttributedString.Key.font : FONT_14])
            attributedStrM.append(nameAtt)
            
        }
        
        if centerStr.count > 0 {
            //*
            let xingxing = NSAttributedString.init(string: centerStr, attributes: [NSAttributedString.Key.backgroundColor : kAppWhiteColor , NSAttributedString.Key.foregroundColor : kAppRedColor , NSAttributedString.Key.font : FONT_18])
            
            attributedStrM.append(xingxing)
            
        }
        
        if last.count > 0 {
            let lastAtt = NSAttributedString.init(string: last, attributes: [NSAttributedString.Key.backgroundColor : kAppWhiteColor , NSAttributedString.Key.foregroundColor : kAppColor_999999 , NSAttributedString.Key.font : FONT_14])
            attributedStrM.append(lastAtt)
            
        }
        
        return attributedStrM
    }
}


//房东
// 房东 - 公司认证
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

//房东
//共享办公认证
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

//房东
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
        case .RenterMineTypeServiceAgent:
            return "服务协议"
        case .RenterMineTypeRegisterAgent:
            return "隐私条款"
        case .RenterMineTypeAboutus:
            return "关于我们"
        case .RenterMineTypeRoleChange:
            return "切换为房东"
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
        case .RenterMineTypeServiceAgent:
            return "serviceAgent"
        case .RenterMineTypeRegisterAgent:
            return "agentRegular"
        case .RenterMineTypeAboutus:
            return "aboutUS"
        case .RenterMineTypeRoleChange:
            return "rolechange"
        }
    }
}
//我的 - 房东
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
        case .OwnerMineTypeServiceAgent:
            return "服务协议"
        case .OwnerMineTypeRegisterAgent:
            return "隐私条款"
        case .OwnerMineTypeAboutus:
            return "关于我们"
        case .OwnerMineTypeRoleChange:
            return "切换为租户"
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
        case .OwnerMineTypeServiceAgent:
            return "serviceAgent"
        case .OwnerMineTypeRegisterAgent:
            return "agentRegular"
        case .OwnerMineTypeAboutus:
            return "aboutUS"
        case .OwnerMineTypeRoleChange:
            return "rolechange"
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
        case .RenterSettingTypeAPISet:
            return "切换环境"
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
        
        return attributedStrM
    }
}

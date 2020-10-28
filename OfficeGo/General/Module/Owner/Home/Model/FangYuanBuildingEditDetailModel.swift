//
//  FangYuanBuildingEditDetailModel.swift
//  OfficeGo
//
//  Created by Mac pro on 2020/10/9.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

//MARK: 楼盘和共享办公详情
class FangYuanBuildingEditDetailModel: BaseModel {
    
    ///0是正式表1临时表
    var isTemp : Bool?
    
    var buildingId: String?
    ///写字楼，创意园，产业园 写字楼1,创意园3,产业园6
    var buildingType: OWnerBuildingTypeEnum?
    ///楼盘名称
    var buildingName : String?
    ///楼号/楼名 为创业园，产业园时候必填
    var buildingNum : String?
    ///城市
    var city : Int?
    ///区域
    var districtId : Int?
    ///商圈
    var area : Int?
    ///地址
    var address : String?
    ///经度
    var longitude : String?
    ///纬度
    var latitude : String?
    ///竣工时间
    var completionTime : Double?
    ///翻新时间
    var refurbishedTime : Double?
    ///建筑面积
    var constructionArea : String?
    ///总楼层 当为网点多层时候格式为
    var totalFloor : String?
    ///层高，仅支持1-8之间正数，保留1位小数
    var storeyHeight : String?
    ///净高，仅支持1-8之间正数，保留1位小数
    var clearHeight     : String?
    ///楼盘简介
    var buildingIntroduction : String?
    ///得房率
    var getBuildingOccupancyRate : String?
    ///物业公司
    var property     : String?
    ///物业费用
    var propertyCosts     : String?
    ///空调费用
    var airConditioningFee : String?
    ///车位数量
    var parkingSpace : String?
    ///车位租金(元/月)
    var ParkingSpaceRent : String?
    ///客梯
    var passengerLift : String?
    ///货梯
    var cargoLift : String?
    ///空调
    var airConditioning : String?
    ///封面图
    var mainPics : String?
    ///0是正式1是临时
    var type : Int?
    ///工位类型，列如”开放工位,独立办公室”
    var stationType : String?
    ///会议室数量
    var conferenceNumber : String?
    ///会议室最大容纳人数
    var conferencePeopleNumber : String?
    ///1单层2多层 - 默认单层
    var floorType : String = "1"
    ///入驻企业
    var settlementLicence : String?
    ///网点的总楼层（网点专属）
    var branchesTotalFloor : String?
    ///是否是编辑地址，0不是，1是
    var isAddress : Int?
    
    ///标签,网点特色,多个用英文逗号隔开
    var tags : String?
    ///网络，多个用英文逗号隔开
    var internet : String?
    /// 基础服务,多个用英文逗号隔开
    var basicServices : String?
    ///企业服务,多个用英文逗号隔开
    var corporateServices : String?
    ///会议室配套,多个用英文逗号隔开,会议室配套详情，看字典
    var roomMatching : String?
    
    
    ///空调类型 中央空调，独立空调，无空调
    var airditionType: OwnerAircontiditonType?
    ///楼盘图片
    var imgUrl: [BannerModel]?
    var videoUrl : [BannerModel]?
    var vrUrl : [BannerModel]?
    var introduction : FangYuanBuildingIntroductionEditModel?
    
    ///标签
    var tagsLocal = [HouseFeatureModel]()
    
    ///网络
    var internetLocal = [HouseFeatureModel]()

    ///基础服务
    var basicServicesLocal = [DictionaryModel]()
    
    ///创业服务
    var corporateServicesLocal = [DictionaryModel]()
    
    ///共享服务数组 - 包括 基础服务 创业服务
    var shareServices = [ShareServiceModel]()
    
    ///创业服务
    var roomMatchingsLocal : ShareServiceModel?
    
    ///大区id
    var district : String?
    
    ///商圈id
    var business : String?
    
    
    ///自己添加的显示的参数
    ///大区id
    var districtString : String?
    
    ///商圈id
    var businessString : String?
    
    
    ///装修类型- 办公室独有
    var decoratesLocal = [HouseFeatureModel]()
    
    ///选中的装修类型
    var decorateModel: HouseFeatureModel?
    
    ///竣工时间
    var completionDate : Date?
    
    ///翻新时间
    var refurbishedDate : Date?

    
    
    
    ///办公室
    ///面积
    var areaOffice : String?
    ///单价
    var dayPrice : String?
    ///总价
    var totalPrice : String?
    ///总价 - 计算出来的临时总价  用于判断有没有点击过
    var totalPriceTemp : String?
    //最小工位数
    var minSeatsOffice : String?
    //最大工位数
    var maxSeatsOffice : String?
    
    ///最短租期
    var minimumLease : String?
    
    ///楼层 单层数字 多层文本
    var ownerFloor : String?
}


//楼盘信息 - 空调 空调费
class FangYuanBuildingIntroductionEditModel: BaseModel {
    var buildingMsg : [FangYuanBuildingIntroductionMsgEditModel]?
    var introductionStr : String?
    var settlementLicence : String?
    
}
//楼盘信息 - 空调 空调费
class FangYuanBuildingIntroductionMsgEditModel: BaseModel {
    var name : String?
    var value : String?
    var height : CGFloat?
}


//MARK: 房源详情
class FangYuanFYEditDetailModel: BaseModel {
    ///写字楼，创意园，产业园 写字楼1,创意园3,产业园6
    var buildingType: OWnerBuildingTypeEnum?
    ///楼盘名称
    var buildingName : String?
    ///楼号/楼名 为创业园，产业园时候必填
    var buildingNum : String?
    ///城市
    var city : Int?
    ///区域
    var districtId : Int?
    ///商圈
    var area : Int?
    ///地址
    var address : String?
    ///经度
    var longitude : String?
    ///纬度
    var latitude : String?
    ///竣工时间
    var completionTime : Double?
    ///翻新时间
    var refurbishedTime : Double?
    ///建筑面积
    var constructionArea : String?
    ///总楼层 当为网点多层时候格式为
    var totalFloor : String?
    ///层高，仅支持1-8之间正数，保留1位小数
    var storeyHeight : String?
    ///净高，仅支持1-8之间正数，保留1位小数
    var clearHeight     : String?
    ///楼盘简介
    var buildingIntroduction : String?
    ///得房率
    var getBuildingOccupancyRate : String?
    ///物业公司
    var property     : String?
    ///物业费用
    var propertyCosts     : String?
    ///空调费用
    var airConditioningFee : String?
    ///车位数量
    var parkingSpace : String?
    ///车位租金(元/月)
    var ParkingSpaceRent : String?
    ///客梯
    var passengerLift : String?
    ///货梯
    var cargoLift : String?
    ///空调
    var airConditioning : String?
    ///封面图
    var mainPics : String?
    ///0是正式1是临时
    var type : Int?
    ///工位类型，列如”开放工位,独立办公室”
    var stationType : String?
    ///会议室数量
    var conferenceNumber : Int?
    ///会议室最大容纳人数
    var conferencePeopleNumber : Int?
    ///1单层2多层 - 默认单层
    var floorType : String = "1"
    ///入驻企业
    var settlementLicence : String?
    ///网点的总楼层（网点专属）
    var branchesTotalFloor : String?
    ///是否是编辑地址，0不是，1是
    var isAddress : Int?
    
    ///标签,网点特色,多个用英文逗号隔开
    var tags : String?
    ///网络，多个用英文逗号隔开
    var internet : String?
    /// 基础服务,多个用英文逗号隔开
    var basicServices : String?
    ///企业服务,多个用英文逗号隔开
    var corporateServices : String?
    ///会议室配套,多个用英文逗号隔开,会议室配套详情，看字典
    var roomMatching : String?
    
    
    ///空调类型 中央空调，独立空调，无空调
    var airditionType: OwnerAircontiditonType?
    ///楼盘图片
    var imgUrl: [BannerModel]?
    var videoUrl : [BannerModel]?
    var vrUrl : [BannerModel]?
    var introduction : FangYuanBuildingIntroductionEditModel?
    
    ///标签
    var tagsLocal = [HouseFeatureModel]()
    
    ///网络
    var internetLocal = [HouseFeatureModel]()

    ///基础服务
    var basicServicesLocal = [DictionaryModel]()
    
    ///创业服务
    var corporateServicesLocal = [DictionaryModel]()
    
    ///共享服务数组 - 包括 基础服务 创业服务
    var shareServices = [ShareServiceModel]()
    
    ///创业服务
    var roomMatchingsLocal : ShareServiceModel?
    
    ///大区id
    var district : String?
    
    ///商圈id
    var business : String?
    
    
    ///自己添加的显示的参数
    ///大区id
    var districtString : String?
    
    ///商圈id
    var businessString : String?
    
    
    ///装修类型- 办公室独有
    var decoratesLocal = [HouseFeatureModel]()
    
    ///选中的装修类型
    var decorateModel: HouseFeatureModel?
    
    ///竣工时间
    var completionDate : Date?
    
    ///翻新时间
    var refurbishedDate : Date?

    
    
    
    ///办公室
    ///面积
    var areaOffice : String?
    ///单价
    var dayPrice : String?
    ///总价
    var totalPrice : String?
    ///总价 - 计算出来的临时总价  用于判断有没有点击过
    var totalPriceTemp : String?
    //最小工位数
    var minSeatsOffice : String?
    //最大工位数
    var maxSeatsOffice : String?
 
    ///最短租期
    var minimumLease : String?
    
    ///楼层 单层数字 多层文本
    var ownerFloor : String?
}

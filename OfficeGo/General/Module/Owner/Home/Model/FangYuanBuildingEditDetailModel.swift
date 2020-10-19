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
    var completionTime : Int?
    ///翻新时间
    var refurbishedTime : Int?
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
    var passengerLift : Int?
    ///货梯
    var cargoLift : Int?
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
    ///1单层2多层
    var floorType : String?
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
    
    var decorateModel: HouseFeatureModel?
}



class FangYuanBuildingEditBuildingModel: BaseModel {
    ///1是写字楼，2是共享办公
    var btype: Int?
    ///地址
    var address : String?
    ///基础服务
    var basicServices : [DictionaryModel]?
    ///创业服务
    var corporateServices : [DictionaryModel]?
    
    var buildingId : Int?
    var businessDistrict : String?
    var mainPic : String?
    var smallImg : String?

    ///楼盘
    ///房源数
    var houseCount : Int?
    ///最小面积-最大面积
    var minArea : Float?
    var maxArea : Float?
    ///价格
    var minDayPrice : Float?
    var maxDayPrice : Float?
    
    
    ///网点
    ///独立办公室最小面积
    var minAreaIndependentOffice : Float?
    ///独立办公室最大面积
    var maxAreaIndependentOffice : Float?
    ///独立办公室平均租金
    var avgDayPriceIndependentOffice : Double?
    //独立办公室最小工位数
    var minSeatsIndependentOffice : Float?
    //独立办公最大平方面积
    var maxSeatsIndependentOffice : Float?
    
    ///开放办公最小工位数
    var minSeatsOpenStation : Float?
    ///开放办公最大工位数
    var maxSeatsOpenStation : Float?
    ///开放办公平均租金
    var avgDayPriceOpenStation : Float?
    
    ///开放办公最小每工位数每月租金
    var minDayPriceOpenStation : Float?
    ///开放办公最大每工位数每月租金
    var maxDayPriceOpenStation : Float?
    ///楼盘网点名称
    var name : String?
    
    ///是否显示开放工位 true： 有 false： 无
    var openStationFlag: Bool?
    ///开放工位信息
    var openStationMap : FangYuanBuildingOpenStationEditModel?
    ///距离最近地铁达到时间
    var nearbySubwayTime : [String]?
    ///地铁线颜色
    var stationColours : [String]?
    ///站名
    var stationNames : [String]?
    ///距离最近地铁先，进的在前
    var stationline : [String]?
}

//楼盘基本信息 - 楼盘名字 地址 公交
class ShareServiceEditModel: BaseModel {
    var title: String?
    var itemArr: [DictionaryModel]?
}
class FangYuanBuildingEditFactorModel: BaseModel {
    ///1是写字楼，2是共享办公
    var btype: Int?
    var buildingItem0: Int?
    var buildingItem1 : Int?
    var buildingItem2 : Int?
    var buildingItem3 : Int?
    var buildingItem4 : Int?
    var buildingItem5 : Int?
    var buildingItem6 : Int?
    var buildingItem7 : Int?
    var buildingItem8 : Int?
    var jointworkItem0 : Int?
    var jointworkItem1 : Int?
    var jointworkItem2 : Int?
    var jointworkItem3 : Int?
    var jointworkItem4 : Int?
    var jointworkItem5 : Int?
    var jointworkItem6 : Int?
    var jointworkItem7 : Int?
    var jointworkItem8 : Int?
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


///房源列表模型
class FangYuanBuildingOpenStationEditModel: BaseModel {
    ///是否有vr，1 有，0 没有
    var vr: String?
    ///1是写字楼，2是共享办公
    var btype: Int?
    ///每工位每月租金  3000.0
    var dayPrice : Float?
    var mainPic : String?
    
    var buildingName : String?
    
    var businessDistrict : String?

    ///0: 下架(未发布),1: 上架(已发布) ;2:资料待完善 ,3: 置顶推荐;4:已售完;5:删除
    var Isfailure : Int?

    ///网点
    ///房源id
    var id : Int?
    ///最短租期
    var minimumLease : String?
    
    ///楼盘
    var area : Float?
    var decoration : String?
    var floor : String?
    var totalFloor : String?
    var monthPrice : Float?
    /// 办公类型1是独立办公室，2是开放工位
    var officeType : Int?
    var seats : Int?
    var simple : String?
    
    
}


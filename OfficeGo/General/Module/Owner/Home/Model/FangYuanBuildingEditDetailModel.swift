//
//  FangYuanBuildingEditDetailModel.swift
//  OfficeGo
//
//  Created by Mac pro on 2020/10/9.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class FangYuanBuildingEditModel: BaseModel {
    var address : String?
    var banner : [BannerModel]?
    var buildingMsg : FangYuanBuildingMsgEditModel?
    var video : [BannerModel]?
    var vr : [BannerModel]?
    
    ///本地展示图片数组
    var buildingLocalImgArr = [BannerModel]()  // 在实际的项目中可能用于存储图片的url
    
    ///删除掉呃服务器返回图片数组
    var buildingDeleteRemoteArr = [BannerModel]()  // 在实际的项目中可能用于存储图片的url
    
    ///本地展示vr数组
    var buildingLocalVRArr = [BannerModel]()
    
    ///本地展示视频数组
    var buildingLocalVideoArr = [BannerModel]()

    ///0是正式表1临时表
    var isTemp : Bool?
    
    var buildingId : Int?
    
}

class FangYuanBuildingMsgEditModel: BaseModel {
    
    ///1为楼盘2为网点
    var btype : Int?

    ///楼盘id
    var id : Int?

    ///楼盘名称
    var buildingName : String?
    
    ///写字楼，创意园，产业园 写字楼1,创意园3,产业园6
    ///楼盘类型1写字楼 2商务园 3创意园 4共享空间 5公寓  6产业园
        
    var buildingTypeEnum: OWnerBuildingTypeEnum?
    
    var buildingType : Int?
    
    ///楼号/楼名 为创业园，产业园时候必填
    var buildingNum : String?
    ///楼盘/网点编号
    var buildingNumber : String?
    ///网点名称
    var branchesName : String?
    
    
    ///每工位每月单价
    var seatMonthPrice : Float?
    
    /////楼盘状态 ,0: 下架(未发布),1: 上架(已发布) ;2:资料待完善 ,3: 置顶推荐;4:已售完;5:删除
    var status : Int?
    
    
    ///城市
    var city : Int?
    ///区域
    var districtId : String?
    ///商圈
    var businessDistrict : String?
    
    ///地址
    var address : String?
    ///经度
    var longitude : String?
    ///纬度
    var latitude : String?
    
    
    ///楼盘：楼盘总楼层  网点：网点第多少层
    var totalFloor : String?
    
    ///网点的总楼层（网点专属）
    var branchesTotalFloor : String?
    
    
    
    ///竣工时间 2019
    var completionTime : String?
    
    ///翻新时间 1980
    var refurbishedTime : String?
    
    
    ///建筑面积
    var constructionArea : String?
    
    
    
    
    ///层高，仅支持1-8之间正数，保留1位小数
    var storeyHeight : String?
    ///净高，仅支持1-8之间正数，保留1位小数
    var clearHeight     : String?
    
    ///楼盘简介
    var buildingIntroduction : String?
    
    ///物业公司
    var property     : String?
    ///物业费用
    var propertyCosts     : String?
    
    
    
    
    
    ///车位数量
    var parkingSpace : String?
    ///车位租金(元/月)
    var parkingSpaceRent : String?
    
    ///客梯
    var passengerLift : String?
    ///货梯
    var cargoLift : String?
    
    ///空调
    var airConditioning : String?
    
    ///空调费用
    var airConditioningFee : String?
    
    
    ///封面图
    var mainPic : String?
    ///0是正式1是临时
    var type : Int?
    
    ///会议室数量
    var conferenceNumber : String?
    
    ///会议室最大容纳人数
    var conferencePeopleNumber : String?
    
    ///1单层2多层 - 默认单层
    var floorType : String = "1"
    
    ///标签,网点特色,多个用英文逗号隔开
    var tags : String?
    ///网络，多个用英文逗号隔开
    var internet : String?
    /// 基础服务,多个用英文逗号隔开 1,2,4,6,9
    var basicServices : String?
    ///企业服务,多个用英文逗号隔开
    var corporateServices : String?
    ///会议室配套,多个用英文逗号隔开,会议室配套详情，看字典
    var roomMatching : String?
    ///企业活动
    //var enterpriseActivities : String?
    ///配套设施
    var supportFacilities : String?
    ///入驻企业
    var settlementLicence : String?
    
    
    ///空调类型 中央空调，独立空调，无空调
    var airditionType: OwnerAircontiditonType?
    ///楼盘图片
    var imgUrl: [BannerModel]?
    var videoUrl : [BannerModel]?
    var vrUrl : [BannerModel]?
    
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
    
    
    ///自己添加的显示的参数
    ///大区id
    var districtString : String?
    
    ///商圈id
    var businessString : String?
    
    
    ///装修类型- 办公室独有
    var decoratesLocal = [HouseFeatureModel]()
    
    ///选中的装修类型
    var decoration: HouseFeatureModel?

    
    ///是否是编辑地址，0不是，1是
    var isAddress : Int?
    
    ///工位类型，列如”开放工位,独立办公室”
    var stationType : String?
    
    var createTime : Int?
    
    var updateTime : Int?
    var releaseTime : Int?
    
    ///得房率
    var buildingOccupancyRate : String?
    
    
    ///免费会议室,0无,1有
    var freeRoom : Int?
    var houseCount : Int?
    var ishot : AnyObject?
    
    var nearbySubway : String?
    var nearbySubwayDistance : String?
    var nearbySubwayLine : String?
    var nearbySubwayTime : String?
    
    var oderNum : Int?
    
    ///宣传口号
    var promoteSlogan : String?
    var remark : String?
    var renovationStyle : String?
    
    
    var transitDistance : String?
    var transitLine : String?
    var transitName : String?
    var transitTime : String?
    
    var createUser : String?
    var updateUser : String?
    var userId : Int?
}



class FangYuanHouseEditModel: BaseModel {
    
    ///基础信息是否完善
    var isBasis : Bool?
    ///图片视频vr是否完善
    var isImg : Bool?
    ///房源户型图是否完善
    var isModel : Bool?
    ///为1时候说明开放工位已经有了，只能添加独立办公室
    var isOfficeType : Int?
    ///房源特色标签，在为楼盘下房源时才会有
    var isTags : Bool?
    
    var btype : Int?
    var houseMsg : FangYuanHouseMsgEditModel?
    
    var banner : [BannerModel]?
    var video : [BannerModel]?
    var vr : [BannerModel]?
    
    ///本地展示图片数组
    var buildingLocalImgArr = [BannerModel]()  // 在实际的项目中可能用于存储图片的url
    
    ///删除掉呃服务器返回图片数组
    var buildingDeleteRemoteArr = [BannerModel]()  // 在实际的项目中可能用于存储图片的url
    
    ///本地展示vr数组
    var buildingLocalVRArr = [BannerModel]()
    
    ///本地展示视频数组
    var buildingLocalVideoArr = [BannerModel]()

    ///0是正式表1临时表
    var isTemp : Bool?
    
    ///房源id
    var id : Int?
    
}
///MARK: 房源详情
class FangYuanHouseMsgEditModel: BaseModel {
    
    ///1为房源2为网点
    var btype : Int?

    ///房源id
    var id : Int?
    
    ///房源归属楼盘id
    var buildingId : Int?

    ///办公类型1是独立办公室，2是开放工位
    var officeType : Int?
    
    ///房源编号
    var houseNumber : String?
    
    ///封面图
    var mainPic : String?
    
    ///0为添加未发布，1为发布，2为下架
    var houseStatus : Int?
    
    ///房源名称
    var title : String?
        
    
    ///单价
    var dayPrice : String?
    
    ///总价
    var monthPrice : String?
    
    ///联合办公时候取工位数
    var seats : String?
    
    ///为楼盘下房源时的预估工位数
    var simple : String?
    
    //最小工位数
    var minSeatsOffice : String?
    //最大工位数
    var maxSeatsOffice : String?
    
    ///总价 - 计算出来的临时总价  用于判断有没有点击过
    var monthPriceTemp : String?
    
    ///面积平方数
    var area : String?
    
    ///1单层2多层 - 默认单层
    var floorType : String = "1"
    
    ///楼层信息
    var floor: String?
        
    ///层高，仅支持1-8之间正数，保留1位小数
    var storeyHeight : String?
    ///净高，仅支持1-8之间正数，保留1位小数
    var clearHeight : String?
    
    ///物业费
    var propertyHouseCosts : String?
        
    
    
    ///最短租期
    var minimumLease : String?
    
    
    ///免租期 6个月
    var rentFreePeriod : String?
    
    

    ///标签,网点特色,多个用英文逗号隔开
    var tags : String?
    
    
    ///标签
    var tagsLocal = [HouseFeatureModel]()
    
    ///装修类型- 办公室独有
    var decoratesLocal = [HouseFeatureModel]()
    
    ///装修类型1毛坯房屋，2简装 ，3豪华，4标准，5精装，6不带窗口，7带家具，8带窗口
    ///选中的装修类型
    var decoration : Int?
    
    
    ///空调类型 中央空调，独立空调，无空调
    var airditionType: OwnerAircontiditonType?
    
    var conditioningType : String?
    var conditioningTypeCost : String?
   
    ///车位数量
    var parkingSpace : String?
    
    ///车位租金(元/月)
    var parkingSpaceRent : String?
    
    ///户型格局图
    var unitPatternImg : String?
    
    ///户型格局简介
    var unitPatternRemark : String?
    
    
    ///房源 - 户型介绍图片数组
    //var unitPatternImgArr = [BannerModel]()
    var unitPatternImgArr = BannerModel()
    
    
    
    ///租金是否包含物业费0不包含，1包含
   // var propertyCosts     : String?
    
    ///起租方式(押三付一) "付三押一
    var rentalMethod : String?
    
    var status : Int?
    
    ///朝向
    var orientation : String?
    
    ///办公格局
    var officePattern : String?
    
    ///是否是编辑地址，0不是，1是
    var isAddress : Int?
    
    ///空调
//    var airConditioning : String?
//    
//    ///租金是否包含空调费0不包含，1包含
//    var airConditioningFee : String?
    
    ///最早交付
    var earliestDelivery : String?
    ///租金是否包含电费0不包含，1包含
    var electricFee : Int?
    
    var createTime : Int?
    
    var updateTime : Int?
    var releaseTime : Int?
    
    var ishot : Int?
    
    var oderNum : Int?
    
    var otherRemark : String?
    
    ///企业认证ID
    var licenceId : Int?
    
    var transitDistance : String?
    var transitLine : String?
    var transitName : String?
    var transitTime : String?

    var createUser : String?
    var updateUser : String?
    var userId : Int?
}

//MARK: 楼盘和共享办公详情
//class FangYuanBuildingEditDetailModel: BaseModel {
//
//    ///0是正式表1临时表
//    var isTemp : Bool?
//
//    var buildingId: String?
//    ///写字楼，创意园，产业园 写字楼1,创意园3,产业园6
//    var buildingType: OWnerBuildingTypeEnum?
//    ///楼盘名称
//    var buildingName : String?
//    ///楼号/楼名 为创业园，产业园时候必填
//    var buildingNum : String?
//    ///城市
//    var city : Int?
//    ///区域
//    var districtId : Int?
//    ///商圈
//    var area : Int?
//    ///地址
//    var address : String?
//    ///经度
//    var longitude : String?
//    ///纬度
//    var latitude : String?
//    ///竣工时间
//    var completionTime : Double?
//    ///翻新时间
//    var refurbishedTime : Double?
//    ///建筑面积
//    var constructionArea : String?
//    ///总楼层 当为网点多层时候格式为
//    var totalFloor : String?
//    ///层高，仅支持1-8之间正数，保留1位小数
//    var storeyHeight : String?
//    ///净高，仅支持1-8之间正数，保留1位小数
//    var clearHeight     : String?
//    ///楼盘简介
//    var buildingIntroduction : String?
//    ///得房率
//    var getBuildingOccupancyRate : String?
//    ///物业公司
//    var property     : String?
//    ///物业费用
//    var propertyCosts     : String?
//    ///空调费用
//    var airConditioningFee : String?
//    ///车位数量
//    var parkingSpace : String?
//    ///车位租金(元/月)
//    var ParkingSpaceRent : String?
//    ///客梯
//    var passengerLift : String?
//    ///货梯
//    var cargoLift : String?
//    ///空调
//    var airConditioning : String?
//    ///封面图
//    var mainPics : String?
//    ///0是正式1是临时
//    var type : Int?
//    ///工位类型，列如”开放工位,独立办公室”
//    var stationType : String?
//    ///会议室数量
//    var conferenceNumber : String?
//    ///会议室最大容纳人数
//    var conferencePeopleNumber : String?
//    ///1单层2多层 - 默认单层
//    var floorType : String = "1"
//    ///入驻企业
//    var settlementLicence : String?
//    ///网点的总楼层（网点专属）
//    var branchesTotalFloor : String?
//    ///是否是编辑地址，0不是，1是
//    var isAddress : Int?
//
//    ///标签,网点特色,多个用英文逗号隔开
//    var tags : String?
//    ///网络，多个用英文逗号隔开
//    var internet : String?
//    /// 基础服务,多个用英文逗号隔开
//    var basicServices : String?
//    ///企业服务,多个用英文逗号隔开
//    var corporateServices : String?
//    ///会议室配套,多个用英文逗号隔开,会议室配套详情，看字典
//    var roomMatching : String?
//
//
//    ///空调类型 中央空调，独立空调，无空调
//    var airditionType: OwnerAircontiditonType?
//    ///楼盘图片
//    var imgUrl: [BannerModel]?
//    var videoUrl : [BannerModel]?
//    var vrUrl : [BannerModel]?
//    var introduction : FangYuanBuildingIntroductionEditModel?
//
//    ///标签
//    var tagsLocal = [HouseFeatureModel]()
//
//    ///网络
//    var internetLocal = [HouseFeatureModel]()
//
//    ///基础服务
//    var basicServicesLocal = [DictionaryModel]()
//
//    ///创业服务
//    var corporateServicesLocal = [DictionaryModel]()
//
//    ///共享服务数组 - 包括 基础服务 创业服务
//    var shareServices = [ShareServiceModel]()
//
//    ///创业服务
//    var roomMatchingsLocal : ShareServiceModel?
//
//    ///大区id
//    var district : String?
//
//    ///商圈id
//    var business : String?
//
//
//    ///自己添加的显示的参数
//    ///大区id
//    var districtString : String?
//
//    ///商圈id
//    var businessString : String?
//
//
//    ///装修类型- 办公室独有
//    var decoratesLocal = [HouseFeatureModel]()
//
//    ///选中的装修类型
//    var decoration: HouseFeatureModel?
//
//    ///竣工时间
//    var completionDate : Date?
//
//    ///翻新时间
//    var refurbishedDate : Date?
//
//
//
//
//    ///办公室
//    ///面积
//    var areaOffice : String?
//    ///单价
//    var dayPrice : String?
//    ///总价
//    var totalPrice : String?
//    ///总价 - 计算出来的临时总价  用于判断有没有点击过
//    var totalPriceTemp : String?
//    //最小工位数
//    var minSeatsOffice : String?
//    //最大工位数
//    var maxSeatsOffice : String?
//
//    ///最短租期
//    var minimumLease : String?
//
//    ///楼层 单层数字 多层文本
//    var ownerFloor : String?
//}


//楼盘信息 - 空调 空调费
//class FangYuanBuildingIntroductionEditModel: BaseModel {
//    var buildingMsg : [FangYuanBuildingIntroductionMsgEditModel]?
//    var introductionStr : String?
//    var settlementLicence : String?
//
//}
//楼盘信息 - 空调 空调费
//class FangYuanBuildingIntroductionMsgEditModel: BaseModel {
//    var name : String?
//    var value : String?
//    var height : CGFloat?
//}


//MARK: 房源详情
//class FangYuanFYEditDetailModel: BaseModel {
//    ///写字楼，创意园，产业园 写字楼1,创意园3,产业园6
//    var buildingType: OWnerBuildingTypeEnum?
//    ///楼盘名称
//    var buildingName : String?
//    ///楼号/楼名 为创业园，产业园时候必填
//    var buildingNum : String?
//    ///城市
//    var city : Int?
//    ///区域
//    var districtId : Int?
//    ///商圈
//    var area : Int?
//    ///地址
//    var address : String?
//    ///经度
//    var longitude : String?
//    ///纬度
//    var latitude : String?
//    ///竣工时间
//    var completionTime : Double?
//    ///翻新时间
//    var refurbishedTime : Double?
//    ///建筑面积
//    var constructionArea : String?
//    ///总楼层 当为网点多层时候格式为
//    var totalFloor : String?
//    ///层高，仅支持1-8之间正数，保留1位小数
//    var storeyHeight : String?
//    ///净高，仅支持1-8之间正数，保留1位小数
//    var clearHeight     : String?
//    ///楼盘简介
//    var buildingIntroduction : String?
//    ///得房率
//    var getBuildingOccupancyRate : String?
//    ///物业公司
//    var property     : String?
//    ///物业费用
//    var propertyCosts     : String?
//    ///空调费用
//    var airConditioningFee : String?
//    ///车位数量
//    var parkingSpace : String?
//    ///车位租金(元/月)
//    var ParkingSpaceRent : String?
//    ///客梯
//    var passengerLift : String?
//    ///货梯
//    var cargoLift : String?
//    ///空调
//    var airConditioning : String?
//    ///封面图
//    var mainPics : String?
//    ///0是正式1是临时
//    var type : Int?
//    ///工位类型，列如”开放工位,独立办公室”
//    var stationType : String?
//    ///会议室数量
//    var conferenceNumber : Int?
//    ///会议室最大容纳人数
//    var conferencePeopleNumber : Int?
//    ///1单层2多层 - 默认单层
//    var floorType : String = "1"
//    ///入驻企业
//    var settlementLicence : String?
//    ///网点的总楼层（网点专属）
//    var branchesTotalFloor : String?
//    ///是否是编辑地址，0不是，1是
//    var isAddress : Int?
//
//    ///标签,网点特色,多个用英文逗号隔开
//    var tags : String?
//    ///网络，多个用英文逗号隔开
//    var internet : String?
//    /// 基础服务,多个用英文逗号隔开
//    var basicServices : String?
//    ///企业服务,多个用英文逗号隔开
//    var corporateServices : String?
//    ///会议室配套,多个用英文逗号隔开,会议室配套详情，看字典
//    var roomMatching : String?
//
//
//    ///空调类型 中央空调，独立空调，无空调
//    var airditionType: OwnerAircontiditonType?
//    ///楼盘图片
//    var imgUrl: [BannerModel]?
//    var videoUrl : [BannerModel]?
//    var vrUrl : [BannerModel]?
//    var introduction : FangYuanBuildingIntroductionEditModel?
//
//    ///标签
//    var tagsLocal = [HouseFeatureModel]()
//
//    ///网络
//    var internetLocal = [HouseFeatureModel]()
//
//    ///基础服务
//    var basicServicesLocal = [DictionaryModel]()
//
//    ///创业服务
//    var corporateServicesLocal = [DictionaryModel]()
//
//    ///共享服务数组 - 包括 基础服务 创业服务
//    var shareServices = [ShareServiceModel]()
//
//    ///创业服务
//    var roomMatchingsLocal : ShareServiceModel?
//
//    ///大区id
//    var district : String?
//
//    ///商圈id
//    var business : String?
//
//
//    ///自己添加的显示的参数
//    ///大区id
//    var districtString : String?
//
//    ///商圈id
//    var businessString : String?
//
//
//    ///装修类型- 办公室独有
//    var decoratesLocal = [HouseFeatureModel]()
//
//    ///选中的装修类型
//    var decoration: HouseFeatureModel?
//
//    ///竣工时间
//    var completionDate : Date?
//
//    ///翻新时间
//    var refurbishedDate : Date?
//
//
//
//
//    ///办公室
//    ///面积
//    var areaOffice : String?
//    ///单价
//    var dayPrice : String?
//    ///总价
//    var totalPrice : String?
//    ///总价 - 计算出来的临时总价  用于判断有没有点击过
//    var totalPriceTemp : String?
//    //最小工位数
//    var minSeatsOffice : String?
//    //最大工位数
//    var maxSeatsOffice : String?
//
//    ///最短租期
//    var minimumLease : String?
//
//    ///楼层 单层数字 多层文本
//    var ownerFloor : String?
//}

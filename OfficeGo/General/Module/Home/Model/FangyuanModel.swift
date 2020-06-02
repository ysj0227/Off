//
//  FangYuanListModel.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/5/9.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class FangYuanListModel: BaseModel {
    
    var address : String?               //距离
    var areaMap : [Float]?
    var btype : Int?                    //类型,1:楼盘,2:网点,当是1的时候,网点名称可为空
    var buildingMap : BuildingMap?      //
    var businessDistrict : String?      //所属商圈-静安区-静安市
    var createTime : Int?
    var distance : String?              //距离
    var id: Int?                        //楼盘id
    var independenceOffice : Int?       //独立办公室数量
    var mainPic : String?               //封面图
    var maxArea : Float?
    var maxDayPrice : Float?
    var maxSeats : Int?
    var minDayPrice : Float?
    var minSeats : Int?
    var name : String?                  //楼盘名称, 网点名称
    var officeType: String?             //逗号分隔的办公类型1是独立办公室，2是开放工位
    var openStation : Int?              //开放工位数量
    var passengerLift : Int?
    var releaseTime : AnyObject?        //发布时间
    var remark : AnyObject?
    var seatMonthPrice : Float?
    var storeyHeight : String?
    var tags : [DictionaryModel]?       //楼盘网点特色
    var totalFloor : String?
    var updateTime : Int?
    var userId : String?             //用户id 发布者
    
}

//地址模型
class BuildingMap : BaseModel {
    
    var nearbySubwayTime : [String]?    //距离最近地铁达到时间
    var stationColours : [String]?      //地铁线颜色
    var stationNames : [String]?        //站名
    var stationline : [String]?         //距离最近地铁先，进的在前
}
class FangYuanListViewModel: NSObject {
    var btype: Int?                     //1是办公楼，2是联合办公
    var idString: Int?                  //房源id
    var mainPicImgString: String?       //封面图
    var buildingName: String?           //楼盘名称
    var distanceString: String?         //距离 1.0km
    var addressString: String?          //区域和商圈 徐汇区 · 徐家汇
    var walkTimesubwayAndStationString: String?  //步行5分钟到 | 2号线 ·东昌路站
    var dayPriceString: String?         //日租金
    var unitString: String?             //单位 /m²/天起
    var areaString: String?             //平方米
    var tagsString: String?             //特色
    var jointDuliAndLianheNumString: String?//联合办公 独立办公室和开放工位的数量
    
    init(model:FangYuanListModel) {
        btype = model.btype
        idString = model.id
        mainPicImgString = model.mainPic
        buildingName = model.name
        distanceString = model.distance ?? ""
        addressString = model.businessDistrict ?? ""
        walkTimesubwayAndStationString = "步行"
        guard let nearbySubwayTime = model.buildingMap?.nearbySubwayTime else {
            return
        }
        walkTimesubwayAndStationString?.append(nearbySubwayTime[0])
        walkTimesubwayAndStationString?.append("分钟到 | ")
        guard let stationline = model.buildingMap?.stationline else {
            return
        }
        walkTimesubwayAndStationString?.append(stationline[0])
        walkTimesubwayAndStationString?.append("号线 ·")
        guard let stationNames = model.buildingMap?.stationNames else {
            return
        }
        walkTimesubwayAndStationString?.append(stationNames[0])
        walkTimesubwayAndStationString?.append("站")
        
        dayPriceString = "\(model.minDayPrice ?? 0)"
        unitString = "/m²/天起"
        
        //面积
        var areaArr: [String] = []
        model.areaMap?.forEach({ (area) in
            areaArr.append(String(format: "%.0fm²", area))
        })
        areaString = areaArr.joined(separator: ",")
        
        //特色
        var tagArr: [String] = []
        model.tags?.forEach({ (model) in
            tagArr.append(model.dictCname ?? "")
        })
        tagsString = tagArr.joined(separator: ",")
        
        
        //开放工位数和独立办公室数量
        var jointArr: [String] = []
        if model.independenceOffice ?? 0 > 0 {
            jointArr.append("独立办公室\(model.independenceOffice ?? 0)间")
        }
        if model.openStation ?? 0 > 0 {
            jointArr.append("开放工位\(model.openStation ?? 0)个")
        }
        jointDuliAndLianheNumString = jointArr.joined(separator: ",")
    }
}


//MARK: 楼盘和联合办公详情
class FangYuanBuildingDetailModel: BaseModel {
    ///1是办公楼，2是联合办公
    var btype: Int?
    ///是否收藏：为0时是未为收藏 ，其他是已经收藏
    var IsFavorite : Bool?
    var building : FangYuanBuildingBuildingModel?
    var factorMap :FangYuanBuildingFactorModel?
    var imgUrl: [BannerModel]?       //banner图片
    var introduction : FangYuanBuildingIntroductionModel?
    var tags : [DictionaryModel]?
    var videoUrl : [BannerModel]?
    var vrUrl : [BannerModel]?
}


class FangYuanBuildingDetailViewModel: NSObject {
    ///1是办公楼，2是联合办公
    var btype: Int?
    ///是否收藏：为0时是未为收藏 ，其他是已经收藏
    var IsFavorite : Bool?
    var buildingViewModel : FangYuanBuildingBuildingViewModel?
    var factorMap :FangYuanBuildingFactorModel?
    var imgUrl: [BannerModel]?       //banner图片
    var introductionViewModel : FangYuanBuildingIntroductionlViewModel?
    ///特色
    var tagsString: String?
    var videoUrl : [BannerModel]?
    var vrUrl : [BannerModel]?
    
    init(model:FangYuanBuildingDetailModel) {
        btype = model.btype
        IsFavorite = model.IsFavorite
        model.building?.btype = model.btype
        buildingViewModel = FangYuanBuildingBuildingViewModel.init(model: model.building ?? FangYuanBuildingBuildingModel())
        factorMap = model.factorMap
        imgUrl = model.imgUrl
        introductionViewModel = FangYuanBuildingIntroductionlViewModel.init(model: model.introduction ?? FangYuanBuildingIntroductionModel())
        //特色
        var tagArr: [String] = []
        model.tags?.forEach({ (model) in
            tagArr.append(model.dictCname ?? "")
        })
        tagsString = tagArr.joined(separator: ",")
        videoUrl = model.videoUrl
        vrUrl = model.vrUrl
    }
}

class FangYuanBuildingBuildingModel: BaseModel {
    ///1是办公楼，2是联合办公
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
    ///独立办公室最小面积
    var minAreaIndependentOffice : Float?
    ///独立办公室最大面积
    var maxAreaIndependentOffice : Float?
    ///独立办公室平均租金
    var avgDayPriceIndependentOffice : Float?
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
    var openStationMap : FangYuanBuildingOpenStationModel?
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
class FangYuanBuildingBuildingViewModel: NSObject {
    ///1是办公楼，2是联合办公
    var btype: Int?
    ///基础服务
    var basicServices : [DictionaryModel]?
    ///创业服务
    var corporateServices : [DictionaryModel]?
    
    ///独立办公室最小面积 - 最大面积
    var independentAreaString: String?
    
    ///独立办公室平均租金
    var independentavgDayPriceString: String?
    
    ///独立办公室工位数区间
    var independentSeatsString: String?
    
    ///开放工位数- 默认取最小
    var seatsOpenStationString: String?
    
    ///开放工位平均租金
    var avgDayPriceOpenStationString: String?
    
    
    ///开放办公最小工位数
    var minSeatsOpenStation : Int?
    ///开放办公最大工位数
    var maxSeatsOpenStation : Int?
    ///开放办公平均租金
    var avgDayPriceOpenStation : Float?
    
    ///开放办公最小每工位数每月租金
    var minDayPriceOpenStation : Float?
    ///开放办公最大每工位数每月租金
    var maxDayPriceOpenStation : Float?
    
    ///是否显示开放工位 true： 有 false： 无
    var openStationFlag: Bool?
    ///开放工位信息
    var openStationViewModel : FangYuanBuildingOpenStationViewModel?
    ///楼盘名称
    var buildingName: String?
    ///区域和商圈 徐汇区 · 徐家汇
    var addressString: String?
    var walkTimesubwayAndStationStringArr: [String]?  //步行5分钟到 | 2号线 ·东昌路站
    var dayPriceString: String?         //日租金
    
    ///共享服务
    ///基础服务
    var basicServicesString : [String]?
    ///创业服务
    var corporateServicesString : [String]?
    
    init(model:FangYuanBuildingBuildingModel) {
        
        super.init()

        btype = model.btype
        
        buildingName = model.name
        
        addressString = model.businessDistrict ?? ""
        
        ///是否显示开发工位的字段
        openStationFlag = model.openStationFlag
        
        ///办公楼
        if btype == 1 {
            
        }
            
            ///联合办公
        else if btype == 2 {
            
            independentAreaString = String(format: "%.0f", model.minAreaIndependentOffice ?? 0) + "-" + String(format: "%.0f", model.maxAreaIndependentOffice ?? 0) + "m²"
            
            independentavgDayPriceString = "¥" + String(format: "%.0f", model.avgDayPriceIndependentOffice ?? 0) + "/位/月"
            
            independentSeatsString = String(format: "%.0f", model.minSeatsIndependentOffice ?? 0) + "-" + String(format: "%.0f", model.maxSeatsIndependentOffice ?? 0) + "位"
            
            seatsOpenStationString = String(format: "%.0f", model.minSeatsOpenStation ?? 0) + "位"
            
            avgDayPriceOpenStationString = "¥" + String(format: "%.0f", model.avgDayPriceOpenStation ?? 0) + "/位/月"
            
        }
        
        let timeStr = "步行"
        guard let nearbySubwayTime = model.nearbySubwayTime else {
            return
        }
        
        let miniuteStr = "分钟到 | "
        
        guard let stationline = model.stationline else {
            return
        }
        
        let xianStr = "号线 ·"
        guard let stationNames = model.stationNames else {
            return
        }
        
        let zhanStr = "站"
        
        if nearbySubwayTime.count == stationline.count && nearbySubwayTime.count == stationNames.count && nearbySubwayTime.count > 0 {
            
            walkTimesubwayAndStationStringArr = []
            
            nearbySubwayTime.forEach { (time) in
                let index = nearbySubwayTime.firstIndex(of: time)
                var timestring = timeStr
                timestring.append(time)
                timestring.append(miniuteStr)
                let stationlineStr = stationline[index ?? 0]
                timestring.append(stationlineStr)
                timestring.append(xianStr)
                let stationName = stationNames[index ?? 0]
                timestring.append(stationName)
                timestring.append(zhanStr)
                self.walkTimesubwayAndStationStringArr?.append(timestring)
                self.walkTimesubwayAndStationStringArr?.append(timestring)
                self.walkTimesubwayAndStationStringArr?.append(timestring)
                self.walkTimesubwayAndStationStringArr?.append(timestring)
                
            }
        }
        
        
        openStationViewModel = FangYuanBuildingOpenStationViewModel.init(model: model.openStationMap ?? FangYuanBuildingOpenStationModel())
        
        
        //共享服务
        if let arr = model.basicServices {
            basicServicesString = []
            for service in arr {
                basicServicesString?.append(service.dictImg ?? "")
            }
        }
        
        if let arr = model.corporateServices {
            corporateServicesString = []
            for service in arr {
                corporateServicesString?.append(service.dictImg ?? "")
            }
        }

        
        
    }
}
class FangYuanBuildingFactorModel: BaseModel {
    var one : Int?
    var sevenTen : Int?
    var all : Int?
    var elevenFifteen : Int?
    var fourSix : Int?
    var sixteenTwenty : Int?
    var twentyAbove : Int?
    var twoThree : Int?
}

//楼盘信息 - 空调 空调费
class FangYuanBuildingIntroductionModel: BaseModel {
    ///空调
    var airConditioning : String?
    ///车位租金(元/月)
    var ParkingSpaceRent : Int?
    ///货梯
    var cargoLift : Int?
    ///竣工时间
    var completionTime : String?
    ///建筑面积
    var constructionArea : String?
    ///电信,联通
    var internet : String?
    ///车位数量
    var parkingSpace : String?
    ///客梯
    var passengerLift : Int?
    ///宣传口号-市中心，交通便利
    var promoteSlogan : String?
    ///物业-上海要你美物业管理有限公司"
    var property : String?
    ///物业费(元/平米/月)
    var propertyCosts : String?
    ///层高 - 标准3.7米，净高2.5米"
    var storeyHeight : String?
    ///总楼层
    var totalFloor : String?
}
class FangYuanBuildingIntroductionlViewModel: NSObject {
    ///空调 - 常规
    var airDefaultConditioning : String?
    ///空调 - 加班
    var airJiabanConditioning : String?
    ///空调费 - 常规
    var airDefaultCoastConditioning : String?
    ///空调费 - 加班
    var airJiabanCoastConditioning : String?
    ///竣工时间
    var completionTime : String?
    ///总楼层
    var totalFloor : String?
    ///层高 - 标准3.7米，净高2.5米"
    var storeyHeight : String?
    ///电梯 6客梯2货梯
    var liftString: String?
    ///车位数量
    var parkingSpace : String?
    ///车位租金(元/月)
    var parkingSpaceRent : String?
    ///物业-上海要你美物业管理有限公司"
    var property : String?
    ///物业费(元/平米/月)
    var propertyCosts : String?
    ///电信,联通
    var internet : String?
    ///宣传口号-市中心，交通便利
    var promoteSlogan : String?
    
    init(model:FangYuanBuildingIntroductionModel) {
        
        airDefaultConditioning = "常规:" + "\(model.airConditioning ?? "")"
        
        airJiabanConditioning = "加班:" + "\(model.airConditioning ?? "")"
        
        airDefaultCoastConditioning = "常规:" + "--"
        
        airJiabanCoastConditioning = "常规:" + "--"
        
        completionTime = "2010年"
        
        totalFloor = "\(model.totalFloor ?? "0")" + "层"
        
        storeyHeight =  model.storeyHeight ?? ""
        
        liftString = "\(model.passengerLift ?? 0)" + "客梯" + "\(model.cargoLift ?? 0)" + "货梯"
        
        parkingSpace = "\(model.parkingSpace ?? "")" + "个"
        
        parkingSpaceRent = "\(model.ParkingSpaceRent ?? 0)" + "元/月/位"
        
        property = model.property ?? "--"
        
        propertyCosts = "\(model.propertyCosts ?? "")" + "元/㎡/月"
        
        internet = model.internet ?? ""
        
        promoteSlogan = model.promoteSlogan ?? ""
        
    }
}

///工位数模型
class FangYuanBuildingOpenStationModel: BaseModel {
    ///每工位每月租金  3000.0
    var dayPrice : Float?
    ///房源id
    var houseId : Int?
    var mainPic : String?
    ///最短租期
    var minimumLease : String?
    
}
///工位数viewmodel模型
class FangYuanBuildingOpenStationViewModel: NSObject {
    ///每工位每月租金  3000.0
    var dayPriceString : String?
    ///房源id
    var houseId : Int?
    var mainPic : String?
    ///最短租期---6个月可租
    var minimumLeaseString : String?
    
    init(model:FangYuanBuildingOpenStationModel) {
        dayPriceString = String(format: "¥%.0f", model.dayPrice ?? 0)
        houseId = model.houseId
        mainPic = model.mainPic
        minimumLeaseString = "\(model.minimumLease ?? "")" + "个月可租"
    }
    
}

//
//  FangYuanBuildingDetailModel.swift
//  OfficeGo
//
//  Created by mac on 2020/6/3.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

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
    //用户id 发布者
    var userId : String?
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
    
    ///特色高度
    var tagsHeight: CGFloat?
    
    var videoUrl : [BannerModel]?
    var vrUrl : [BannerModel]?
    //用户id 发布者
    var userId : String?
    
    init(model:FangYuanBuildingDetailModel) {
        btype = model.btype
        IsFavorite = model.IsFavorite
        model.building?.btype = model.btype
        userId = model.userId
        buildingViewModel = FangYuanBuildingBuildingViewModel.init(model: model.building ?? FangYuanBuildingBuildingModel())
        model.factorMap?.btype = model.btype
        factorMap = model.factorMap
        imgUrl = model.imgUrl
        introductionViewModel = FangYuanBuildingIntroductionlViewModel.init(model: model.introduction ?? FangYuanBuildingIntroductionModel())
        //特色
        var tagArr: [String] = []
        model.tags?.forEach({ (model) in
            tagArr.append(model.dictCname ?? "")
        })
        tagsString = tagArr.joined(separator: ",")
        let widthAdd: CGFloat = 10
        let space: CGFloat = 9
        let maxWidth: CGFloat = kWidth - 50
        var width: CGFloat = 0.0
        let height: CGFloat = 20.0
        var topY: CGFloat = 5.0
        
        for strs in tagArr {
            let itemwidth:CGFloat = strs.boundingRect(with: CGSize(width: kWidth, height: height), font: FONT_10, lineSpacing: 0).width + widthAdd
            if (width + (itemwidth + space)) > maxWidth {
                topY += (height + 5)
                width = 0.0
            }
            width =  width + (itemwidth + space)
            let index = tagArr.firstIndex(of: strs)
            if index == tagArr.count - 1 {
                topY += (height + 5)
            }
        }
        if topY < 30 {
            tagsHeight = 30
        }else {
            tagsHeight = topY
        }
        
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
    
    
    ///楼盘
    ///房源数
    var houseCountString : String?
    ///最小面积-最大面积
    var houseAreaString : String?
    ///价格
    var housePriceString : String?
    
    
    ///网点
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
        
        ///addressString = model.businessDistrict ?? ""
        addressString = model.address ?? ""
        
        ///是否显示开发工位的字段
        openStationFlag = model.openStationFlag
        
        ///办公楼
        if btype == 1 {
            houseCountString = "\(model.houseCount ?? 0)" + "套"
            ///最小面积-最大面积
            houseAreaString = String(format: "%.0f", model.minArea ?? 0) + "-" + String(format: "%.0f", model.maxArea ?? 0) + "m²"
            ///价格
            housePriceString = String(format: "%.0f", model.minDayPrice ?? 0) + "/m²/天起"
        }
            
            ///联合办公
        else if btype == 2 {
            
            independentAreaString = String(format: "%.0f", model.minAreaIndependentOffice ?? 0) + "-" + String(format: "%.0f", model.maxAreaIndependentOffice ?? 0) + "m²"
            
            independentavgDayPriceString = "¥" + String(format: "%.0f", model.avgDayPriceIndependentOffice ?? 0) + "/位/月"
            
            independentSeatsString = String(format: "%.0f", model.minSeatsIndependentOffice ?? 0) + "-" + String(format: "%.0f", model.maxSeatsIndependentOffice ?? 0) + "位"
            
            seatsOpenStationString = String(format: "%.0f", model.minSeatsOpenStation ?? 0) + "位"
            
            avgDayPriceOpenStationString = "¥" + String(format: "%.0f", model.avgDayPriceOpenStation ?? 0) + "/位/月"
            
            
            ///开放工位和共享服务之后网点有
            model.openStationMap?.btype = model.btype
            //详情 - 包含 开放工位
            model.openStationMap?.officeType = 2
            openStationViewModel = FangYuanBuildingOpenStationViewModel.init(model: model.openStationMap ?? FangYuanBuildingOpenStationModel())
            
            
            //共享服务 - 显示用黑色的图标
            if let arr = model.basicServices {
                basicServicesString = []
                for service in arr {
                    basicServicesString?.append(service.dictImgBlack ?? "")
                }
            }
            
            basicServices = model.basicServices
            
            if let arr = model.corporateServices {
                corporateServicesString = []
                for service in arr {
                    corporateServicesString?.append(service.dictImgBlack ?? "")
                }
            }
            corporateServices = model.corporateServices
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
                
            }
        }
        
    }
}
class FangYuanBuildingFactorModel: BaseModel {
    ///1是办公楼，2是联合办公
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
class FangYuanBuildingIntroductionModel: BaseModel {
    ///空调
    var airConditioning : String?
    ///车位租金(元/月)
    var ParkingSpaceRent : Int?
    ///货梯
    var cargoLift : Int?
    ///竣工时间
    var completionTime : Int?
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
    
    //宣传口号简介高度
    var textHeight: CGFloat?
    
    init(model:FangYuanBuildingIntroductionModel) {
        
        airDefaultConditioning = "常规:" + "\(model.airConditioning ?? "")"
        
        airJiabanConditioning = "加班:" + "\(model.airConditioning ?? "")"
        
        airDefaultCoastConditioning = "常规:" + "--"
        
        airJiabanCoastConditioning = "常规:" + "--"
                
        completionTime = SSTool.timeIntervalChangeToTimeStr(timeInterval: TimeInterval.init(model.completionTime ?? 0), dateFormat:"yyyy年")
        
        totalFloor = "\(model.totalFloor ?? "0")" + "层"
        
        storeyHeight =  model.storeyHeight ?? ""
        
        liftString = "\(model.passengerLift ?? 0)" + "客梯" + "\(model.cargoLift ?? 0)" + "货梯"
        
        parkingSpace = "\(model.parkingSpace ?? "")" + "个"
        
        parkingSpaceRent = "\(model.ParkingSpaceRent ?? 0)" + "元/月/位"
        
        property = model.property ?? "--"
        
        propertyCosts = "\(model.propertyCosts ?? "")" + "元/㎡/月"
        
        internet = model.internet ?? ""
        
        promoteSlogan = model.promoteSlogan ?? "--"
        
        let size: CGSize = model.promoteSlogan?.boundingRect(with: CGSize(width: kWidth - left_pending_space_17 * 2, height: 9999), font: FONT_13, lines: 0) ?? CGSize(width: kWidth - left_pending_space_17 * 2, height: 25)
        if size.height < 25 {
            textHeight = 25
        }else{
            textHeight = size.height
        }
    }
}

///房源列表模型
class FangYuanBuildingOpenStationModel: BaseModel {
    ///1是办公楼，2是联合办公
    var btype: Int?
    ///每工位每月租金  3000.0
    var dayPrice : Float?
    var mainPic : String?
    
    var buildingName : String?
    
    var businessDistrict : String?

    var Isfailure : Int?                //0: 下架(未发布),1: 上架(已发布) ;2:资料待完善 ,3: 置顶推荐;4:已售完;5:删除

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
///房源列表viewmodel模型
class FangYuanBuildingOpenStationViewModel: NSObject {
    ///1是办公楼，2是联合办公
    var btype: Int?
    ///房源id
    var id : Int?
    
    var Isfailure : Int?                //0: 下架(未发布),1: 上架(已发布) ;2:资料待完善 ,3: 置顶推荐;4:已售完;5:删除

    /// 办公类型1是独立办公室，2是开放工位
    var officeType : Int?
    
    var mainPic : String?
    
    var buildingName : String?
    
    var addressString : String?
    
    ///开放工位
    ///工位数 - 30工位
    var openSeatsString : String?
    ///月租金
    var openMonthPriceString : String?
    ///最短租期---6个月可租
    var openMinimumLeaseString : String?
    
    
    ///独立办公室
    ///
    ///面积
    var individualAreaString : String?
    ///每工位每月租金  3000.0
    var individualMonthPriceString : String?
    ///工位数 - 30工位
    var individualSeatsString : String?
    ///每工位每天租金  3000.0
    var individualDayPriceString : String?
    
    
    ///面积
    var buildingArea : String?
    ///工位数
    var buildinSeats : String?
    var buildingDayPriceString : String?
    ///月租金
    var buildingMonthPriceString : String?
    ///装修
    var buildingDecoration : String?
    ///楼层
    var buildingFloor : String?
    
    
    init(model:FangYuanBuildingOpenStationModel) {
        Isfailure = model.Isfailure
        btype = model.btype
        id = model.id
        mainPic = model.mainPic
        buildingName = model.buildingName
        addressString = model.businessDistrict ?? ""

        if btype == 1 {
            buildingArea = String(format: "%.0f㎡", model.area ?? 0)
            let arr = model.simple?.split{$0 == ","}.map(String.init)
            if let simpleArr = arr {
                if simpleArr.count >= 2 {
                    buildinSeats = "最多\(simpleArr[1])个工位"
                }
            }else {
                buildinSeats = "最多0个工位"
            }
            buildingDayPriceString = String(format: "¥%.0f /㎡/天", model.dayPrice ?? 0)
            buildingMonthPriceString = String(format: "¥%.0f /月", model.monthPrice ?? 0)
            buildingDecoration = model.decoration ?? ""
            buildingFloor = "\(model.floor ?? "0")/共\(model.totalFloor ?? "0")层"
        }else if btype == 2 {
            
            officeType = model.officeType
            
            ///独立办公室
            if officeType == 1 {
                individualAreaString = String(format: "%.0f㎡", model.area ?? 0)
                individualMonthPriceString = String(format: "¥%.0f", model.monthPrice ?? 0)
                individualSeatsString = "\(model.seats ?? 0)" + "工位"
                individualDayPriceString = String(format: "¥%.0f /位/天", model.dayPrice ?? 0)
            }else {
                openSeatsString = "\(model.seats ?? 0)" + "工位"
                openMonthPriceString = String(format: "¥%.0f", model.dayPrice ?? 0)
                openMinimumLeaseString = "\(model.minimumLease ?? "")" + "个月起租"
            }
        }
    }
}

//
//  FangYuanBuildingDetailModel.swift
//  OfficeGo
//
//  Created by mac on 2020/6/3.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

//MARK: 楼盘和共享办公详情
class FangYuanBuildingDetailModel: BaseModel {
    ///1是写字楼，2是共享办公
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
    ///1是写字楼，2是共享办公
    var btype: Int?
    ///是否收藏：为0时是未为收藏 ，其他是已经收藏
    var IsFavorite : Bool?
    var buildingViewModel : FangYuanBuildingBuildingViewModel?
    var factorMap :FangYuanBuildingFactorModel?
    var introductionViewModel : FangYuanBuildingIntroductionViewModel?
    ///特色
    var tagsString: [String]?             //特色

    ///特色高度
    var tagsHeight: CGFloat?
    
    var imgUrl: [String]?       //banner图片
    var videoUrl : [String]?
    var vrUrl : [String]?
    
    var isHasVideo: Bool?
    var isHasVR: Bool?
    
    //用户id 发布者
    var userId : String?
    
    init(model:FangYuanBuildingDetailModel) {
        super.init()
        btype = model.btype
        IsFavorite = model.IsFavorite
        model.building?.btype = model.btype
        userId = model.userId
        buildingViewModel = FangYuanBuildingBuildingViewModel.init(model: model.building ?? FangYuanBuildingBuildingModel())
        model.factorMap?.btype = model.btype
        factorMap = model.factorMap
        introductionViewModel = FangYuanBuildingIntroductionViewModel.init(model: model.introduction ?? FangYuanBuildingIntroductionModel())
        
        //特色
        tagsString = []
        model.tags?.forEach({[weak self] (model) in
            self?.tagsString?.append(model.dictCname ?? "")
        })
        
        let widthAdd: CGFloat = 10
        let space: CGFloat = 9
        let maxWidth: CGFloat = kWidth - 50
        var width: CGFloat = 0.0
        let height: CGFloat = 20.0
        var topY: CGFloat = 5.0
        if let tagArr = tagsString {
            for strs in tagArr {
                let itemwidth:CGFloat = strs.boundingRect(with: CGSize(width: kWidth, height: height), font: FONT_10, lineSpacing: 0).width + widthAdd
                if (width + (itemwidth + space)) > maxWidth {
                    topY += (height + 6)
                    width = 0.0
                }
                width =  width + (itemwidth + space)
            }
            if topY <= 30 {
                tagsHeight = 30
            }else {
                tagsHeight = topY + height
            }
        }
        
        if let vrArr = model.vrUrl {
            if vrArr.count > 0 {
                vrUrl = []
                isHasVR = true
                for vrmodel in vrArr {
                    vrUrl?.append(vrmodel.imgUrl ?? "")
                }
            }
        }
        if let vrArr = model.videoUrl {
            if vrArr.count > 0 {
                isHasVideo = true
                videoUrl = []
                for vrmodel in vrArr {
                    videoUrl?.append(vrmodel.imgUrl ?? "")
                }
            }
        }
        if let vrArr = model.imgUrl {
            if vrArr.count > 0 {
                imgUrl = []
                for vrmodel in vrArr {
                    imgUrl?.append(vrmodel.imgUrl ?? "")
                }
            }
        }
    }
}

class FangYuanBuildingBuildingModel: BaseModel {
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
    ///1是写字楼，2是共享办公
    var btype: Int?
    
    var buildingId : Int?
    
    ///共享服务数组 - 包括 基础服务 创业服务
    var shareServices: [ShareServiceModel]?
    
    var shareServicesHeight: CGFloat = 0

    
    var mainPic : String?

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
    
    init(model:FangYuanBuildingBuildingModel) {
        
        super.init()
        
        btype = model.btype
        
        buildingId = model.buildingId
        
        buildingName = model.name
        
        mainPic = model.mainPic
        ///addressString = model.businessDistrict ?? ""
        addressString = model.address ?? ""
        
        ///是否显示开发工位的字段
        openStationFlag = model.openStationFlag
        
        ///写字楼
        if btype == 1 {
            houseCountString = "\(model.houseCount ?? 0)" + "套"
            ///最小面积-最大面积 - 如果一样，显示一个
            if model.minArea == model.maxArea {
                houseAreaString = String(format: "%.0f", model.minArea ?? 0) + "m²"
            }else {
                houseAreaString = String(format: "%.0f", model.minArea ?? 0) + "-" + String(format: "%.0f", model.maxArea ?? 0) + "m²"
            }
            ///价格
            housePriceString =  "¥\(model.minDayPrice ?? 0)" + "/m²/天起"
        }
            
            ///共享办公
        else if btype == 2 {
            
            if model.minAreaIndependentOffice == model.maxAreaIndependentOffice {
                independentAreaString = String(format: "%.0f", model.minAreaIndependentOffice ?? 0) + "m²"
            }else {
                independentAreaString = String(format: "%.0f", model.minAreaIndependentOffice ?? 0) + "-" + String(format: "%.0f", model.maxAreaIndependentOffice ?? 0) + "m²"
            }
            
            independentavgDayPriceString = "¥\(model.avgDayPriceIndependentOffice ?? 0)" + "/位/月"
            
            if model.minSeatsIndependentOffice == model.maxSeatsIndependentOffice {
                independentSeatsString = String(format: "%.0f", model.minSeatsIndependentOffice ?? 0) + "位"
            }else {
                independentSeatsString = String(format: "%.0f", model.minSeatsIndependentOffice ?? 0) + "-" + String(format: "%.0f", model.maxSeatsIndependentOffice ?? 0) + "位"
            }
            
            seatsOpenStationString = String(format: "%.0f", model.minSeatsOpenStation ?? 0) + "位"
            
            avgDayPriceOpenStationString = "¥\(model.avgDayPriceOpenStation ?? 0)" + "/位/月"
            
            
            ///开放工位和共享服务之后网点有
            model.openStationMap?.btype = model.btype
            //详情 - 包含 开放工位
            model.openStationMap?.officeType = 2
            openStationViewModel = FangYuanBuildingOpenStationViewModel.init(model: model.openStationMap ?? FangYuanBuildingOpenStationModel())
            
            
            shareServices = []
            
            if model.corporateServices?.count ?? 0 > 0 {
                let corporateServicesModel = ShareServiceModel()
                corporateServicesModel.title = "创业服务"
                if let arr = model.corporateServices {
                    corporateServicesModel.itemArr = arr
                }
                shareServices?.append(corporateServicesModel)
            }
            
            if model.basicServices?.count ?? 0 > 0 {
                let basicServicesModel = ShareServiceModel()
                basicServicesModel.title = "基础服务"
                if let arr = model.basicServices {
                    basicServicesModel.itemArr = arr
                }
                shareServices?.append(basicServicesModel)
            }
            
            if shareServices?.count ?? 0 > 0 {
                if let shareservices = shareServices {
                    ///加26 当作底部的按钮
                    shareServicesHeight = CGFloat(50 + shareservices.count * (20 + 18 + 18 + 26) + 20)
                }
            }
        }
        
        guard let nearbySubwayTime = model.nearbySubwayTime else {
            return
        }
        if nearbySubwayTime.count > 0 {
            let timeStr = "步行"
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
                
                stationline.forEach { (time) in
                    let index = stationline.firstIndex(of: time)
                    let miniter = nearbySubwayTime[index ?? 0]
                    var timestring = timeStr
                    timestring.append(miniter)
                    timestring.append(miniuteStr)
                    timestring.append(time)
                    timestring.append(xianStr)
                    let stationName = stationNames[index ?? 0]
                    timestring.append(stationName)
                    timestring.append(zhanStr)
                    self.walkTimesubwayAndStationStringArr?.append(timestring)
                    
                }
            }
        }
    }
}
class ShareServiceModel: BaseModel {
    var title: String?
    var itemArr: [DictionaryModel]?
}
class FangYuanBuildingFactorModel: BaseModel {
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
class FangYuanBuildingIntroductionModel: BaseModel {
    var buildingMsg : [FangYuanBuildingIntroductionMsgModel]?
    var promoteSlogan : String?
    var settlementLicence : String?
    
}
//楼盘信息 - 空调 空调费
class FangYuanBuildingIntroductionMsgModel: BaseModel {
    var name : String?
    var value : String?
    var height : CGFloat?
}

class FangYuanBuildingIntroductionViewModel: NSObject {
    
    ///入住企业
    var settlementLicenceName: String?

    var settlementLicence: String?
    
    ///入住企业高度
    var settlementLicenceHeight: CGFloat = 0
    
    ///属性数组
    var buildingMsg : [FangYuanBuildingIntroductionMsgModel]?

    ///属性高度
    var buildingMsgHeight : CGFloat = 0

    var cellHeight : CGFloat = 0
    
    init(model:FangYuanBuildingIntroductionModel)
    {
//        model.buildingMsg?[1].value = "阿里巴巴巴巴阿里巴巴阿里巴巴阿里巴巴阿12cctv、上海东方明珠、芒果"
//        settlementLicence = "cctv、上海东方明珠、芒果tv、腾讯视频、百度、阿里巴巴、哔哩哔哩、cctv、上海东方明珠、芒果tv、腾讯视频、百度、阿里巴巴、哔哩哔哩"

        if let msg = model.buildingMsg {
            buildingMsg = []
            for item in msg {
                let size: CGSize = item.value?.boundingRect(with: CGSize(width: (kWidth - left_pending_space_17) / 2.0 + 1, height: 9999), font: FONT_12, lines: 0) ?? CGSize(width: (kWidth - left_pending_space_17) / 2.0 + 1, height: 25)
                item.height = size.height
                buildingMsg?.append(item)
            }
        }
        
        settlementLicenceName = "入住企业"
        
        settlementLicence = model.settlementLicence
        
        if let settlementlicenceStr = settlementLicence {
            if settlementlicenceStr.isBlankString != true {
                let size: CGSize = settlementlicenceStr.boundingRect(with: CGSize(width: kWidth - left_pending_space_17 * 2, height: 9999), font: FONT_12, lines: 0)
                
                settlementLicenceHeight = 12 + 18 + 12 + size.height + 12
            }else {
                settlementLicenceHeight = 0
            }
        }
        

        if buildingMsg?.count ?? 0 > 0 {
            buildingMsgHeight = (CGFloat(buildingMsg?.count ?? 0 + 1) / 2.0) * (12 * 3 + 36) + 40
        }else {
            buildingMsgHeight = 0
        }
        
        //50为标题
        if (buildingMsgHeight + settlementLicenceHeight) > 0 {
            cellHeight = buildingMsgHeight  + settlementLicenceHeight + 50
        }else {
            cellHeight = 0
        }
    }
}

///房源列表模型
class FangYuanBuildingOpenStationModel: BaseModel {
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
///房源列表viewmodel模型
class FangYuanBuildingOpenStationViewModel: NSObject {
    ///1是写字楼，2是共享办公
    var btype: Int?
    ///房源id
    var id : Int?
    
    ///0: 下架(未发布),1: 上架(已发布) ;2:资料待完善 ,3: 置顶推荐;4:已售完;5:删除
    var Isfailure : Int?

    /// 办公类型1是独立办公室，2是开放工位
    var officeType : Int?
    
    var mainPic : String?
    
    var buildingName : String?
    
    var addressString : String?
    
    ///开放工位
    ///工位数 - 30工位
    var openSeatsString : String?
    ///工位
    var openSeatsUnitLBString : String?
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
    ///楼层 - 只显示8楼，不显示总层数
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
            buildingDayPriceString = "¥\(model.dayPrice ?? 0) /㎡/天" 
            buildingMonthPriceString = "¥\(model.monthPrice ?? 0) /月"
            buildingDecoration = model.decoration ?? ""
            if model.floor?.isBlankString ?? false == true && model.totalFloor?.isBlankString ?? false == true {
                buildingFloor = "--"
            }else {
                buildingFloor = "\(model.floor ?? "0")楼"
            }
        }else if btype == 2 {
            
            officeType = model.officeType
            
            ///独立办公室
            if officeType == 1 {
                individualAreaString = String(format: "%.0f㎡", model.area ?? 0)
                individualMonthPriceString = "¥\(model.monthPrice ?? 0)"
                individualSeatsString = "\(model.seats ?? 0)" + "工位"
                individualDayPriceString = "¥\(model.dayPrice ?? 0) /位/天"
            }else {
                openSeatsString = "\(model.seats ?? 0)" + "工位"
                openSeatsUnitLBString = "工位"
                openMonthPriceString = "¥\(model.dayPrice ?? 0)"
                openMinimumLeaseString = "\(model.minimumLease ?? "")" + "个月起租"
            }
        }
    }
}

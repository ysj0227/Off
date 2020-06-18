//
//  FangYuanBuildingFYDetailModel.swift
//  OfficeGo
//
//  Created by mac on 2020/6/3.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class FangYuanBuildingFYDetailModel: BaseModel {
    ///1是办公楼，2是联合办公
    var btype: Int?
    ///是否收藏：为0时是未为收藏 ，其他是已经收藏
    var IsFavorite : Bool?
    var house : FangYuanBuildingFYDetailHouseModel?
    var imgUrl: [BannerModel]?
    var videoUrl : [BannerModel]?
    var vrUrl : [BannerModel]?
}
class FangYuanBuildingFYDetailViewModel: NSObject {
    ///1是办公楼，2是联合办公
    var btype: Int?
    ///是否收藏：为0时是未为收藏 ，其他是已经收藏
    var IsFavorite : Bool?
    var houseViewModel : FangYuanBuildingFYDetailHouseViewModel?
    var imgUrl: [BannerModel]?
    var videoUrl : [BannerModel]?
    var vrUrl : [BannerModel]?
    init(model:FangYuanBuildingFYDetailModel) {
        btype = model.btype
        IsFavorite = model.IsFavorite
        model.house?.basicInformation?.btype = model.btype
        houseViewModel = FangYuanBuildingFYDetailHouseViewModel.init(model: model.house ?? FangYuanBuildingFYDetailHouseModel())
        imgUrl = model.imgUrl
        videoUrl = model.videoUrl
        vrUrl = model.vrUrl
    }
}
class FangYuanBuildingFYDetailHouseModel: BaseModel {
    ///1是办公楼，2是联合办公
    var btype: Int?
    var buildingId : Int?
    var id : Int?
    
    ///面积
    var area : Float?
    
    //基本信息
    var basicInformation : FangYuanBuildingFYDetailBasicInformationModel?
    
    ///楼盘名字
    var buildingName : String?
    
    ///网点名字
    var branchesName : String?
    ///价格
    var dayPrice : Float?
    var decoration : String?
    
    var mainPic : String?
    var licenceId : Int?
    var monthPrice : Float?
    /// 办公类型1是独立办公室，2是开放工位
    var officeType : Int?
    
    var seats : Int?
    var simple : String?
    var tags : [DictionaryModel]?
    
    //用户id 发布者
    var userId : String?
    
    ///增加的公交和区域商圈
    ///距离最近地铁达到时间
    var nearbySubwayTime : [String]?
    ///地铁线颜色
    var stationColours : [String]?
    ///站名
    var stationNames : [String]?
    ///距离最近地铁先，进的在前
    var stationline : [String]?
    
    var businessDistrict : String?

    var address : String?

}
class FangYuanBuildingFYDetailHouseViewModel: NSObject {
    ///1是办公楼，2是联合办公
    var btype: Int?
    var buildingId : Int?
    var id : Int?
    
    ///面积
    var areaString : String?
    
    //基本信息
    var basicInformation : FangYuanBuildingFYDetailBasicInformationModel?
    
    ///楼盘名字
    var buildingName : String?
    
    
    ///价格
    var dayPriceString : String?
    var decorationString : String?
    
    var mainPic : String?
    var licenceId : Int?
    var monthPriceString : String?
    
    /// 办公类型1是独立办公室，2是开放工位
    var officeType : Int?
    
    ///工位数
    var seatsString : String?
    
    var tagsString: [String]?             //特色

    ///区域和商圈 徐汇区 · 徐家汇
    var addressString: String?
    
    var walkTimesubwayAndStationStringArr: [String]?  //步行5分钟到 | 2号线 ·东昌路站
    
    ///特色高度
    var tagsHeight: CGFloat?
    
    //用户id 发布者
    var userId : String?
    
    init(model:FangYuanBuildingFYDetailHouseModel) {
        
        super.init()

        btype = model.btype
        
        buildingId = model.buildingId
        
        id = model.id
        
        mainPic = model.mainPic
        
        if btype == 1 {
            buildingName = model.buildingName
        }else {
            buildingName = model.branchesName
        }
        
        areaString = String(format: "%.0fm²", model.area ?? 0)
        
        if let str = model.decoration {
            if str.isBlankString == true {
                decorationString = "--"
            }else {
                decorationString = model.decoration ?? ""
            }
        }else {
            decorationString = "--"
        }
        
        
        monthPriceString = String(format: "%.0f/月", model.monthPrice ?? 0)
        
        let size: CGSize = model.basicInformation?.unitPatternRemark?.boundingRect(with: CGSize(width: kWidth - left_pending_space_17 * 2, height: 9999), font: FONT_LIGHT_13, lines: 0) ?? CGSize(width: kWidth - left_pending_space_17 * 2, height: 25)
        if size.height < 25 {
            model.basicInformation?.textHeight = 25
        }else{
            model.basicInformation?.textHeight = size.height
            
        }
        
        model.basicInformation?.btype = model.btype
        basicInformation = model.basicInformation
        
        //办公室
        if btype == 1 {
            
            dayPriceString = String(format: "¥%.0f/m²/天", model.dayPrice ?? 0)
            let arr = model.simple?.split{$0 == ","}.map(String.init)
            if let simpleArr = arr {
                if simpleArr.count >= 2 {
                    seatsString = "最多\(simpleArr[1])个工位"
                }
            }else {
                seatsString = "最多0个工位"
            }
        }else {
            
            dayPriceString = String(format: "¥%.0f/位/天", model.dayPrice ?? 0)
            
            seatsString = "\(model.seats ?? 0)个工位"
        }
        
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
        
        ///addressString = model.businessDistrict ?? ""
        addressString = model.address ?? ""
        
    }
}

class FangYuanBuildingFYDetailBasicInformationModel: BaseModel {
    ///1是办公楼，2是联合办公 用来判断最短租期单位
    var btype: Int?
    ///"随时",//最早交付
    var earliestDelivery : String?
    ///楼层信息
    var floor : String?
    ///3年起",//最短租期
    var minimumLease : String?
    ///办公格局
    var officePattern : String?
    var otherRemark : AnyObject?
    ///"6个月",//免租期
    var rentFreePeriod : String?
    ///户型格局图
    var unitPatternImg : String?
    ///"门朝北，窗户朝向南，2个独立办公室，1间大会议室，3间小会议室。",//户型格局简
    var unitPatternRemark : String?
    
    //户型格局简介高度
    var textHeight: CGFloat?
}

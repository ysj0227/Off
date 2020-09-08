//
//  FangYuanBuildingFYDetailModel.swift
//  OfficeGo
//
//  Created by mac on 2020/6/3.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class FangYuanBuildingFYDetailModel: BaseModel {
    ///1是办公楼，2是共享办公
    var btype: Int?
    ///是否收藏：为0时是未为收藏 ，其他是已经收藏
    var IsFavorite : Bool?
    var house : FangYuanBuildingFYDetailHouseModel?
    var imgUrl: [BannerModel]?
    var videoUrl : [BannerModel]?
    var vrUrl : [BannerModel]?
}
class FangYuanBuildingFYDetailViewModel: NSObject {
    ///1是办公楼，2是共享办公
    var btype: Int?
    ///是否收藏：为0时是未为收藏 ，其他是已经收藏
    var IsFavorite : Bool?
    var houseViewModel : FangYuanBuildingFYDetailHouseViewModel?
        
    var imgUrl: [String]?       //banner图片
    var videoUrl : [String]?
    var vrUrl : [String]?
    
    var isHasVideo: Bool?
    var isHasVR: Bool?
    
    init(model:FangYuanBuildingFYDetailModel) {
        btype = model.btype
        IsFavorite = model.IsFavorite
        model.house?.basicInformation?.btype = model.btype
        houseViewModel = FangYuanBuildingFYDetailHouseViewModel.init(model: model.house ?? FangYuanBuildingFYDetailHouseModel())
        
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
class FangYuanBuildingFYDetailHouseModel: BaseModel {
    ///1是办公楼，2是共享办公
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
    ///1是办公楼，2是共享办公
    var btype: Int?
    var buildingId : Int?
    var id : Int?
    
    ///面积
    var areaString : String?
    
    //基本信息
    var basicInformationViewModel : FangYuanBuildingFYDetailBasicInformationViewModel?
    
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
        
        
        monthPriceString = "¥\(model.monthPrice ?? 0)/月"
       
        model.basicInformation?.btype = model.btype
        
        ///详情属性viewmodel
        basicInformationViewModel = FangYuanBuildingFYDetailBasicInformationViewModel.init(model: model.basicInformation ?? FangYuanBuildingFYDetailBasicInformationModel())
        
        //办公室
        if btype == 1 {
            
            dayPriceString = "¥\(model.dayPrice ?? 0)/m²/天"
            let arr = model.simple?.split{$0 == ","}.map(String.init)
            if let simpleArr = arr {
                if simpleArr.count >= 2 {
                    seatsString = "最多\(simpleArr[1])个工位"
                }
            }else {
                seatsString = "最多0个工位"
            }
        }else {
            
            dayPriceString = "¥\(model.dayPrice ?? 0)/位/天"
            
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
        
        ///addressString = model.businessDistrict ?? ""
        addressString = model.address ?? ""
    }
}

class FangYuanBuildingFYDetailBasicInformationModel: BaseModel {
    ///1是办公楼，2是共享办公 用来判断最短租期单位
    var btype: Int?
    ///户型格局图
    var unitPatternImg : String?
    ///"门朝北，窗户朝向南，2个独立办公室，1间大会议室，3间小会议室。",//户型格局简
    var unitPatternRemark : String?
    
    ///房源属性
    var houseMsg : [FangYuanBuildingIntroductionMsgModel]?
}
class FangYuanBuildingFYDetailBasicInformationViewModel: NSObject {
    ///1是办公楼，2是共享办公 用来判断最短租期单位
    var btype: Int?
    ///户型格局图
    var unitPatternImg : String?
    ///"门朝北，窗户朝向南，2个独立办公室，1间大会议室，3间小会议室。",//户型格局简
    var unitPatternRemark : String?
    
    ///房源属性
    var houseMsg : [FangYuanBuildingIntroductionMsgModel]?
    
    ///属性高度
    var houseMsgHeight : CGFloat = 0
    
    ///属性
    var cellHeight : CGFloat = 0
    
    
    ///户型介绍和户型图
    var patternHeight : CGFloat = 0
    
    //户型介绍高度
    var textHeight: CGFloat = 0
    
    ///户型介绍和户型图高度
    var patternCellHeight : CGFloat = 0
    
    init(model:FangYuanBuildingFYDetailBasicInformationModel)
    {
        super.init()
        
        btype = model.btype
        
        unitPatternImg = model.unitPatternImg
        
        unitPatternRemark = model.unitPatternRemark
        
        let size: CGSize = model.unitPatternRemark?.boundingRect(with: CGSize(width: kWidth - left_pending_space_17 * 2, height: 9999), font: FONT_LIGHT_11, lines: 0) ?? CGSize(width: kWidth - left_pending_space_17 * 2, height: 25)
        if size.height < 25 {
            textHeight = 25
        }else{
            textHeight = size.height
        }
        
        if let patternImg = model.unitPatternImg {
            if patternImg.isBlankString != true {
                patternHeight = (kWidth - left_pending_space_17 * 2) * (2 / 3.0)
            }
        }
        
        if patternHeight > 0 {
            patternHeight += 17
        }
        
        if (textHeight + patternHeight) > 0 {
            patternCellHeight = textHeight + patternHeight + 55
        }else {
            patternCellHeight = 0
        }
                
        if let msg = model.houseMsg {
            houseMsg = []
            for item in msg {
                let size: CGSize = item.value?.boundingRect(with: CGSize(width: (kWidth - left_pending_space_17) / 2.0 + 1, height: 9999), font: FONT_12, lines: 0) ?? CGSize(width: (kWidth - left_pending_space_17) / 2.0 + 1, height: 25)
                item.height = size.height
                houseMsg?.append(item)
            }
        }
        
        houseMsgHeight = (CGFloat(houseMsg?.count ?? 0 + 1) / 2.0) * (12 * 3 + 36) + 40
        
        //50为标题
        cellHeight = houseMsgHeight + 50
    }
}

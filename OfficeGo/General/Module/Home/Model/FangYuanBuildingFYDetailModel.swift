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
    
    ///网点名字
    var branchesName : String?
    
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
    
    var tagsString : String?

    //用户id 发布者
    var userId : String?
 
    init(model:FangYuanBuildingFYDetailHouseModel) {
        
        btype = model.btype
        
        buildingId = model.buildingId

        id = model.id
        
        buildingName = model.buildingName
        
        areaString = String(format: "%.0fm²", model.area ?? 0)
        
        decorationString = model.decoration ?? ""
        
        monthPriceString = String(format: "%.0f/月", model.monthPrice ?? 0)

        let size: CGSize = model.basicInformation?.unitPatternRemark?.boundingRect(with: CGSize(width: kWidth - left_pending_space_17 * 2, height: 9999), font: FONT_LIGHT_13, lines: 0) ?? CGSize(width: kWidth - left_pending_space_17 * 2, height: 25)
        if size.height < 25 {
            model.basicInformation?.textHeight = 25
        }else{
            model.basicInformation?.textHeight = size.height

        }
        
        basicInformation = model.basicInformation
        
        //办公室
        if btype == 1 {
            
            dayPriceString = String(format: "%.0f/m²/天", model.dayPrice ?? 0)
            let arr = model.simple?.split{$0 == ","}.map(String.init)
            if let simpleArr = arr {
                if simpleArr.count >= 2 {
                    seatsString = "最多\(simpleArr[1])个工位"
                }
            }else {
                seatsString = "最多0个工位"
            }
        }else {
            
            dayPriceString = String(format: "%.0f/位/天", model.dayPrice ?? 0)

            seatsString = "\(model.seats ?? 0)个工位"
        }
        
        //特色
        var tagArr: [String] = []
        model.tags?.forEach({ (model) in
            tagArr.append(model.dictCname ?? "")
        })
        tagsString = tagArr.joined(separator: ",")
    }
}

class FangYuanBuildingFYDetailBasicInformationModel: BaseModel {
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

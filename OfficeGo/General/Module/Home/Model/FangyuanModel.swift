//
//  FangYuanListModel.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/5/9.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit
import HandyJSON

class FangYuanListModel: HandyJSON {
    
    var id: Int?                //房源id
    var buildingId: Int?        //楼盘id
    var buildingName: String?   //楼盘名称
    var branchesName: String?   //楼盘名称
    var area: Double?           //平方米
    var monthPrice: Double?     //月租金
    var dayPrice: Double?       //日租金
    var releaseTime: Int?       //发布时间
    var mainPic: String?        //封面图
    var seats: Int?             //工位数
    var decoration: String?     //装修类型
    //    var officeType: Int?        //办公类型1是独立办公室，2是开放工位
    var officeType: String?     //逗号分隔的办公类型1是独立办公室，2是开放工位
    var houseType: Int?         //1是办公楼，2是联合办公
    
    required init() {
    }
}

class FangYuanListViewModel: NSObject {
    
    var idString: Int?                  //房源id
    var buildingIdString: Int?          //楼盘id
    var buildingName: String?           //楼盘名称
    var branchesName: String?           //楼盘名称
    var areaString: String?             //平方米
    var monthPriceString: String?       //月租金
    var dayPriceString: String?         //日租金
    var releaseTimeString: String?      //发布时间
    var mainPicImgString: String?       //封面图
    var seatsString: String?            //工位数
    var decorationArr: [String]?        //装修类型
    var officeTypeString: String        //办公类型1是独立办公室，2是开放工位
    
    var addressString: String            //区域和商圈 徐汇区 · 徐家汇
    var distanceString: String          //距离 1.0km
    var walkTimesubwayAndStationString: String  //步行5分钟到 | 2号线 ·东昌路站
    var unitString: String              //单位 /m²/天起
    var houseType: Int?         //1是办公楼，2是联合办公
    
    init(model:FangYuanListModel) {
        houseType = model.houseType
        buildingName = model.buildingName
        branchesName = model.branchesName
        areaString = "\(model.area ?? 0)"
        monthPriceString = "\(model.monthPrice ?? 0)"
        dayPriceString = "¥" + "\(model.dayPrice ?? 0)"
        releaseTimeString = "\(model.releaseTime ?? 0)"
        mainPicImgString = model.mainPic
        seatsString = "\(model.seats ?? 0)"
        decorationArr = ["地铁", "美食", "上下"]
        officeTypeString = model.officeType ?? ""
        addressString = "徐汇区" + " · " + "徐家汇"
        distanceString = "1.0" + "km"
        walkTimesubwayAndStationString = "步行" + "5" + "分钟到 | " + "2" + "号线 ·" + "东昌路" + "站"
        unitString = "/m²/天起"
    }
}



class FangyuanDetailModel: HandyJSON {
    
    var id: Int?                //房源id
    var buildingId: Int?        //楼盘id
    var imgUrl: [String]?       //banner图片
    var IsFavorite: Int?        //是否收藏：为0时是未为收藏 ，其他是已经收藏
    var building: FangYuanBuildingModel?   //楼盘名称
    
    required init() {
    }
}
class FangYuanBuildingModel: HandyJSON {
    
    var buildingIntroduction: FangYuanBuildingIntroductionModel?   //楼盘简介信息（下部分）
    var buildingMsg: FangYuanBuildingMsgModel?   //楼盘信息（上部分）
    
    required init() {
    }
}
//楼盘简介信息（下部分）
class FangYuanBuildingIntroductionModel: HandyJSON {
    required init() {
    }
}
//楼盘信息（上部分）
class FangYuanBuildingMsgModel: HandyJSON {
    required init() {
    }
}
class FangyuanDetailViewModel: NSObject {
    
    var idString: Int?                  //房源id
    var buildingIdString: Int?          //楼盘id
    var buildingName: String?           //楼盘名称
    var branchesName: String?           //楼盘名称
    var areaString: String?             //平方米
    var monthPriceString: String?       //月租金
    var dayPriceString: String?         //日租金
    var releaseTimeString: String?      //发布时间
    var mainPicImgString: String?       //封面图
    var seatsString: String?            //工位数
    var decorationArr: [String]?        //装修类型
    var officeTypeString: String        //办公类型1是独立办公室，2是开放工位
    
    var addressString: String            //区域和商圈 徐汇区 · 徐家汇
    var distanceString: String          //距离 1.0km
    var walkTimesubwayAndStationString: String  //步行5分钟到 | 2号线 ·东昌路站
    var unitString: String              //单位 /m²/天起
    var houseType: Int?         //1是办公楼，2是联合办公
    
    init(model:FangYuanListModel) {
        houseType = model.houseType
        buildingName = model.buildingName
        branchesName = model.branchesName
        areaString = "\(model.area ?? 0)"
        monthPriceString = "\(model.monthPrice ?? 0)"
        dayPriceString = "¥" + "\(model.dayPrice ?? 0)"
        releaseTimeString = "\(model.releaseTime ?? 0)"
        mainPicImgString = model.mainPic
        seatsString = "\(model.seats ?? 0)"
        decorationArr = ["地铁", "美食", "上下"]
        officeTypeString = model.officeType ?? ""
        addressString = "徐汇区" + " · " + "徐家汇"
        distanceString = "1.0" + "km"
        walkTimesubwayAndStationString = "步行" + "5" + "分钟到 | " + "2" + "号线 ·" + "东昌路" + "站"
        unitString = "/m²/天起"
    }
}

//
//  MessageFYModel.swift
//  OfficeGo
//
//  Created by mac on 2020/6/11.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class MessageFYViewModel: NSObject {
    var buildingId : Int?
    var houseId : Int?
    var targetId : String?
    var distanceString: String?
    var districtString: String?
    var unitString: String?

    ///封面图
    var mainPic : String?
    var createTimeAndByWho : String?
    var isFavorite : Bool?
    var buildingName : String?
    var houseName : String?
    ///2.1km | 徐汇区 · 漕河泾
    var distanceDistrictString: String?

    ///步行5分钟到 | 2号线 ·东昌路站
    var walkTimesubwayAndStationString: String?
    ///日租金
    var dayPriceString: String?
    ///特色
    var tagsString: String?
    var avatarString : String?
    var contactNameString : String?
    var companyJobString : String?
    
    init(model:MessageFYModel) {
        buildingId = model.house?.buildingId
        houseId = model.house?.houseId
        targetId = model.chatted?.targetId
        
        mainPic = model.house?.mainPic
        let dateTimeString = SSTool.timeIntervalChangeToYYMMHHMMTimeStr(timeInterval: TimeInterval.init(model.createTime ?? 0))
        if model.createUser == model.chatted?.targetId {
            createTimeAndByWho = "\(dateTimeString) 由对方发起沟通"
        }else {
            createTimeAndByWho = "\(dateTimeString) 由你发起沟通"
        }
        isFavorite = model.isFavorite
        buildingName = model.house?.buildingName
        houseName = "adddd"
        distanceDistrictString = "\(10)km | \(model.house?.district ?? "")"
        distanceString = "\(10)km"
        districtString = model.house?.district ?? ""
        walkTimesubwayAndStationString = "步行"
        guard let nearbySubwayTime = model.house?.nearbySubwayTime else {
            return
        }
        walkTimesubwayAndStationString?.append(nearbySubwayTime.count > 0 ? nearbySubwayTime[0] : "")
        walkTimesubwayAndStationString?.append("分钟到 | ")
        guard let stationline = model.house?.stationline else {
            return
        }
        walkTimesubwayAndStationString?.append(stationline.count > 0 ? stationline[0] : "")
        walkTimesubwayAndStationString?.append("号线 ·")
        guard let stationNames = model.house?.stationNames else {
            return
        }
        walkTimesubwayAndStationString?.append(stationNames.count > 0 ? stationNames[0] : "")
        walkTimesubwayAndStationString?.append("站")
        
        if model.house?.btype == 1 {
            dayPriceString = String(format: "¥%.0f /㎡/天", model.house?.minSinglePrice ?? 0)
            unitString = "/㎡/天"
        }else if model.house?.btype == 2 {
            
            ///独立办公室
            if model.house?.officeType == 1 {
                dayPriceString = String(format: "¥%.0f /位/天", model.house?.minSinglePrice ?? 0)
                unitString = "/位/天"
            }
        }
        
        //特色
//       var tagArr: [String] = []
//       model.tags?.forEach({ (model) in
//           tagArr.append(model.dictCname ?? "")
//       })
//       tagsString = tagArr.joined(separator: ",")
        avatarString = model.chatted?.avatar
        contactNameString = model.chatted?.nickname
        companyJobString = "\(model.chatted?.company ?? "")·\(model.chatted?.job ?? "")"
    }
}
//MARK: 创建聊天详情
class MessageFYModel: BaseModel {
    ///false没有离职true离职
    var isDepartureStatus : Bool?
    var isFavorite : Bool?
    var chatted : MessageFYChattedModel?
    var createTime : Int?
    var createUser : String?
    var building : MessageFYbuildingModel?
    var house : MessageFYHouseModel?
    ///1:从楼盘进入返回building对象,2:从房源进入返回house对象
    var isBuildOrHouse : Int?
    var scheduleStatus : Int?
    var user : MessageFYUserModel?
}
class MessageFYUserModel: BaseModel {
    var phone : String?
    var userId : Int?
    var userImg : String?
    var wxId : String?
}
class MessageFYHouseModel: BaseModel {
    var address : String?
    var btype : Int?
    var buildingId : Int?
    var buildingName : String?
    var district : String?
    var houseId : Int?
    var latitude : String?
    var longitude : String?
    var mainPic : String?               //封面图
    var maxArea : Float?
    var maxSinglePrice : Float?
    var minSinglePrice : Float?
    var nearbySubwayTime : [String]?
    var officeType : Int?
    var seats : Int?
    var stationColours : [String]?
    var stationNames : [String]?
    var stationline : [String]?

}
class MessageFYbuildingModel: BaseModel {
    var address : String?
    var btype : Int?
    var buildingId : Int?
    var buildingName : String?
    var district : String?
    var houseId : Int?
    var latitude : String?
    var longitude : String?
    var maxArea : Float?
    var maxSinglePrice : Float?
    var minSinglePrice : Float?
    var nearbySubwayTime : [String]?
    var officeType : Int?
    var seats : Int?
    var stationColours : [String]?
    var stationNames : [String]?
    var stationline : [String]?

}
class MessageFYChattedModel: BaseModel {
    var isZD : Bool?
    var accountStatus : Bool?
    var avatar : String?
    var targetId : String?
    var company : String?
    var job : String?
    var nickname : String?
    var typeId : Int?
}

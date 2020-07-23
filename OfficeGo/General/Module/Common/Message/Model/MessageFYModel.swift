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
    
    var address : String?

    ///封面图
    var mainPic : String?
    var createTimeAndByWho : String?
    var IsFavorite : Bool?
    var buildingName : String?
    var houseName : String?
    ///2.1km | 徐汇区 · 漕河泾
    var distanceDistrictString: String?
    
    ///步行5分钟到 | 2号线 ·东昌路站
    var walkTimesubwayAndStationString: String?
    ///日租金
    var dayPriceString: String?
    var dayPriceNoUnitString: String?
    ///特色
    var tagsString: String?
    var avatarString : String?
    var contactNameString : String?
    var companyJobString : String?
    
    init(model:MessageFYModel) {
        
        ///1:从楼盘进入返回building对象,2:从房源进入返回house对象
        if model.isBuildOrHouse == 1 {
            buildingId = model.building?.buildingId
            houseId = model.building?.houseId
            targetId = model.chatted?.targetId
            
            address = model.building?.address
            
            mainPic = model.building?.mainPic
            let dateTimeString = SSTool.timeIntervalChangeToYYMMHHMMTimeStr(timeInterval: TimeInterval.init(model.createTime ?? 0))
            if model.createUser == model.chatted?.targetId {
                createTimeAndByWho = "\(dateTimeString) 由对方发起沟通"
            }else {
                createTimeAndByWho = "\(dateTimeString) 由你发起沟通"
            }
            IsFavorite = model.IsFavorite
            buildingName = model.building?.buildingName
            houseName = model.building?.buildingName
            distanceDistrictString = "\(model.building?.distance ?? "0")km | \(model.building?.district ?? "")"
            distanceString = model.building?.distance?.count ?? 0 > 0 ? "\(model.building?.distance ?? "0")km" : ""
            districtString = model.building?.district ?? ""
            guard let nearbySubwayTime = model.building?.nearbySubwayTime else {
                return
            }
            if nearbySubwayTime.count > 0 {
                walkTimesubwayAndStationString = "步行"
                walkTimesubwayAndStationString?.append(nearbySubwayTime.count > 0 ? nearbySubwayTime[0] : "")
                walkTimesubwayAndStationString?.append("分钟到 | ")
                guard let stationline = model.building?.stationline else {
                    return
                }
                walkTimesubwayAndStationString?.append(stationline.count > 0 ? stationline[0] : "")
                walkTimesubwayAndStationString?.append("号线 ·")
                guard let stationNames = model.building?.stationNames else {
                    return
                }
                walkTimesubwayAndStationString?.append(stationNames.count > 0 ? stationNames[0] : "")
                walkTimesubwayAndStationString?.append("站")
            }
            
            dayPriceNoUnitString = "¥\(model.building?.minSinglePrice ?? 0)"
            
            if model.building?.btype == 1 {
                dayPriceString = "¥\(model.building?.minSinglePrice ?? 0) /㎡/天"
                unitString = "/㎡/天"
            }else if model.building?.btype == 2 {
                
                dayPriceString = "¥\(model.building?.minSinglePrice ?? 0) /位/月"
                unitString = "/位/月"
            }
            
            //特色
            var tagArr: [String] = []
            model.building?.tags?.forEach({ (model) in
                tagArr.append(model.dictCname ?? "")
            })
            tagsString = tagArr.joined(separator: ",")
            
            //        tagsString = model.house?.tags
            avatarString = model.chatted?.avatar
            contactNameString = model.chatted?.nickname
        }else {
            buildingId = model.house?.buildingId
            houseId = model.house?.houseId
            targetId = model.chatted?.targetId
            
            address = model.house?.address

            mainPic = model.house?.mainPic
            let dateTimeString = SSTool.timeIntervalChangeToYYMMHHMMTimeStr(timeInterval: TimeInterval.init(model.createTime ?? 0))
            if model.createUser == model.chatted?.targetId {
                createTimeAndByWho = "\(dateTimeString) 由对方发起沟通"
            }else {
                createTimeAndByWho = "\(dateTimeString) 由你发起沟通"
            }
            IsFavorite = model.IsFavorite
            buildingName = model.house?.buildingName
            houseName = model.house?.houseName
            distanceDistrictString = "\(model.house?.distance ?? "0")km | \(model.house?.district ?? "")"
            distanceString = model.house?.distance?.count ?? 0 > 0 ? "\(model.house?.distance ?? "0")km" : ""
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
            
            dayPriceNoUnitString = "¥\(model.house?.minSinglePrice ?? 0)"
            
            if model.house?.btype == 1 {
                dayPriceString = "¥\(model.house?.minSinglePrice ?? 0) /㎡/天"
                unitString = "/㎡/天"
            }else if model.house?.btype == 2 {
                
                ///独立办公室
//                if model.house?.officeType == 1 {
                    dayPriceString = "¥\(model.house?.minSinglePrice ?? 0) /位/月"
                    unitString = "/位/月"
//                }
            }
            
            //特色
            var tagArr: [String] = []
            model.house?.tags?.forEach({ (model) in
                tagArr.append(model.dictCname ?? "")
            })
            tagsString = tagArr.joined(separator: ",")
            
            //        tagsString = model.house?.tags
            avatarString = model.chatted?.avatar
            contactNameString = model.chatted?.nickname
        }
        
        
        companyJobString = "\(model.chatted?.company ?? "")·\(model.chatted?.job ?? "")"
    }
}
//MARK: 创建聊天详情
class MessageFYModel: BaseModel {
    ///false没有离职true离职
    var isDepartureStatus : Bool?
    var IsFavorite : Bool?
    var chatted : MessageFYChattedModel?
    var createTime : Int?
    var createUser : String?
    var building : MessageFYbuildingModel?
    var house : MessageFYHouseModel?
    ///1:从楼盘进入返回building对象,2:从房源进入返回house对象
    var isBuildOrHouse : Int?
    var scheduleStatus : Int?
    var user : MessageFYUserModel?
    ///0 是否调用过发送接口  0没有。1有
    var isChat: Int?
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
    var distance: String?
    var district : String?
    var houseId : Int?
    var houseName : String?
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
    var tags : [DictionaryModel]?
}
class MessageFYbuildingModel: BaseModel {
    var address : String?
    var btype : Int?
    var buildingId : Int?
    var buildingName : String?
    var distance: String?
    var district : String?
    var houseId : Int?
    var houseName : String?
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
    var tags : [DictionaryModel]?
}
class MessageFYChattedModel: BaseModel {
    ///0单业主 1多业主
    var multiOwner: Int?
    var isZD : Bool?
    var accountStatus : Bool?
    var avatar : String?
    var targetId : String?  //1061
    var chattedId : String? //106
    var company : String?
    var job : String?
    var nickname : String?
    var typeId : Int?
    
    //获取管理员信息添加的字段
    var authority : String?
    ///企业id
    var licenceId : Int?
    var proprietorJob : String?
    var proprietorRealname : String?
    
    //申请加入公司成功返回的字段
    var id: Int?
    var userId : String?

}


class OwnerIdentifyMsgDetailModel: BaseModel {
    
    ///身份类型0个人1企业2联和办公
    var identityType : Int?
    
    var company : String?
    var job : String?
    var nickname : String?

    var targetId : String?  //1061
    var chattedId : String? //106
    ///申请加入公司成功返回的字段
    var id: Int?
    var userId : String?
    
    ///获取管理员信息添加的字段
    var authority : String?
    ///企业id
    var licenceId : String?
    var proprietorJob : String?
    var proprietorRealname : String?
    var avatar : String?
    ///申请id
    var userLicenceId : String?
    ///申请加入企业的时候是企业名称 申请加入网点的时候是网点名称
    var title : String?
    ///申请加入企业的时候是企业地址 申请加入网点的时候是网点网点
    var address : String?


}


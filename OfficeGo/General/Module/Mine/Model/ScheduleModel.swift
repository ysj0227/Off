//
//  ScheduleModel.swift
//  OfficeGo
//
//  Created by mac on 2020/6/9.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

//MARK: 看房日程- 每天日程模型
class ScheduleModel: BaseModel {

    ///日期
    var day : String?
    ///
    var scheduleList : [ScheduleList]?
    ///周几
    var week : String?
}

class ScheduleViewModel: NSObject {


    ///日期
    var day : String?
    ///
    var scheduleViewModelList : [ScheduleViewModelList]?
    ///周几
    var week : String?
    init(model:ScheduleModel) {
        super.init()
        day = model.day
        week = model.week
        scheduleViewModelList = []
        model.scheduleList?.forEach({ (model) in
            scheduleViewModelList?.append(ScheduleViewModelList.init(model: model))
        })
    }
}


//MARK: 看房日程- 每天日程模型里边的单个日程
class ScheduleList: BaseModel {
    var address : String?
    var area : String?
    ///行程审核状态 0预约 1预约成功 2预约失败 3已看房 4未看房
    var auditStatus : Int?
    var branchesName : String?
    var btype : Int?
    var buildingId : Int?
    var buildingName : String?
    var businessDistrict : String?
    var contact : String?
    var company : String?
    var job : String?
    var mainPic : String?
    ///对方-联系人电话
    var phone : String?
    var remark : String?
    ///行程id
    var scheduleId : Int?
    var simple : String?
    ///预约时间
    var time : Int?
}

class ScheduleViewModelList: NSObject {
    ///行程审核状态 0预约待接受 1预约成功 2预约失败 3已看房
    var auditStatus : Int?
    ///浅蓝色 灰色
    var autitBgViewColor: UIColor?
    ///蓝色 灰色
    var autitStatusTimeIcon: String?
    ///状态文案
    var auditStatusString : String?
    ///状态文字颜色 蓝色 灰色666
    var autitStatusLabelColor: UIColor?
    ///蓝色 灰色 - 约看房源 333 666
    var autitBuildingNameColor: UIColor?
    
    var buildingId : Int?
    ///行程id
    var scheduleId : Int?
    ///预约时间 - 日期
    var dateTimeString : String?
    ///预约时间 - 时分
    var hourMinuterTimeString : String?
    var contactNameString : String?
    var companyJobString : String?

    var btype : Int?
    var schedulebuildingName : String?
    var businessDistrict : String?
    
    init(model:ScheduleList) {
        btype = model.btype
        auditStatus = model.auditStatus
        if let status = auditStatus {
            switch status {
            case 0:
                autitBgViewColor = kAppLightBlueColor
                autitStatusTimeIcon = "timeIcon"
                auditStatusString = "待接受"
                autitStatusLabelColor = kAppBlueColor
                autitBuildingNameColor = kAppColor_333333
            case 1:
                autitBgViewColor = kAppLightBlueColor
                autitStatusTimeIcon = "timeIcon"
                auditStatusString = "已预约"
                autitStatusLabelColor = kAppBlueColor
                autitBuildingNameColor = kAppColor_333333
            case 3:
                autitBgViewColor = kAppColor_bgcolor_F7F7F7
                autitStatusTimeIcon = "timeIconGray"
                auditStatusString = "已完成"
                autitStatusLabelColor = kAppColor_666666
                autitBuildingNameColor = kAppColor_666666
            default:
                auditStatusString = ""
                autitStatusTimeIcon = "timeIconGray"

            }
        }
        
        buildingId = model.buildingId
        scheduleId = model.scheduleId
        dateTimeString = SSTool.timeIntervalChangeToYYMMTimeStr(timeInterval: TimeInterval.init(model.time ?? 0))
        hourMinuterTimeString = SSTool.timeIntervalChangeToMMSSTimeStr(timeInterval: TimeInterval.init(model.time ?? 0))
        contactNameString = model.contact
        companyJobString = "\(model.company ?? "")·\(model.job ?? "")"
        if btype == 1 {
            schedulebuildingName = "约看 「\(model.buildingName ?? "")」"
        }else if btype == 2 {
            schedulebuildingName = "约看 「\(model.branchesName ?? "")」"
        }
        businessDistrict = model.businessDistrict
    }
}


//MARK: 看房日程- 每天日程模型里边的单个日程详情
class ScheduleListDetailModel : BaseModel {
    var building : ScheduleListDetailBuildingModel?
    var house : [ScheduleListDetailHouseModel]?
}

class ScheduleListDetailViewModel : NSObject {
    var buildingViewModel : ScheduleListDetailBuildingViewModel?
    var house : [ScheduleListDetailHouseModel]?
    init(model:ScheduleListDetailModel) {
        buildingViewModel = ScheduleListDetailBuildingViewModel.init(model: model.building ?? ScheduleListDetailBuildingModel())
        house = model.house
    }
}

class ScheduleListDetailHouseModel : BaseModel {
    var area : Float?
    var dayPrice : Float?
    var decoration : String?
    var floor : String?
    var houseId : Int?
    var mainPic : String?
    var monthPrice : Float?
    var officeType : Int?
    var scheduleId : Int?
    var seats : Int?
    var simple : String?
}

//MARK: building详情模型
class ScheduleListDetailBuildingModel : BaseModel {
    var address : String?
    var area : String?
    var auditStatus : Int?
    var avatar : String?
    var branchesName : String?
    var btype : Int?
    var buildingId : Int?
    var buildingName : String?
    var businessDistrict : String?
    var chatUserId : Int?
    var company : String?
    var contact : String?
    var dayPrice : String?
    var houseCount : Int?
    var job : String?
    var latitude : String?
    var longitude : String?
    var mainPic : String?
    var nearbySubwayTime : [String]?
    var phone : String?
    var remark : String?
    var scheduleId : Int?
    var stationColours : [String]?
    var stationNames : [String]?
    var stationline : [String]?
    var time : Int?
    var wxId : String?
}
//MARK: building详情viewModel
class ScheduleListDetailBuildingViewModel : NSObject {
    var btype : Int?
    var buildingId : Int?
    var chatUserId : Int?
    ///行程id
    var scheduleId : Int?
    var latitude : String?
    var longitude : String?
    
    var phone : String?
    var remark : String?
    
    ///行程审核状态 0预约待接受 1预约成功 2预约失败 3已看房
    var auditStatus : Int?
    ///状态文案
    var auditStatusString : String?
    var schedulebuildingName : String?
    var avatarString : String?
    var contactNameString : String?
    var companyJobString : String?

    ///预约时间 - 日期 时分
    var dateTimeString : String?
    var addressString : String?
    
    //2号线 ·东昌路站
    var trafficString: String?
    
    var trafficHeight: CGFloat = 30

    init(model:ScheduleListDetailBuildingModel) {
        
        super.init()
        
        self.btype = model.btype
        self.buildingId = model.buildingId
        self.chatUserId = model.chatUserId
        self.scheduleId = model.scheduleId
        self.latitude = model.latitude
        self.longitude = model.longitude
        self.phone = model.phone
        self.remark = model.remark
        self.auditStatus = model.auditStatus
        if let status = auditStatus {
            switch status {
            case 0:
                auditStatusString = "待接受"
            case 1:
                auditStatusString = "已预约"
            case 3:
                auditStatusString = "已完成"
            default:
                auditStatusString = ""
            }
        }
        if btype == 1 {
            schedulebuildingName = "约看 「\(model.buildingName ?? "")」"
        }else if btype == 2 {
            schedulebuildingName = "约看 「\(model.branchesName ?? "")」"
        }
        avatarString = model.avatar
        contactNameString = model.contact
        companyJobString = "\(model.company ?? "")·\(model.job ?? "")"
        dateTimeString = SSTool.timeIntervalChangeToTimeStr(timeInterval: TimeInterval.init(model.time ?? 0), dateFormat: "yyyy-MM-dd HH:mm")
        addressString = model.address
        guard let stationline = model.stationline else {
            return
        }
        
        let xianStr = "号线 ·"
        guard let stationNames = model.stationNames else {
            return
        }
        
        let zhanStr = "站"
        
        if stationNames.count == stationline.count && stationNames.count > 0 {
                        
            trafficString = ""
            
            stationline.forEach { (time) in
                var timestring = ""
                let index = stationline.firstIndex(of: time)
                let stationlineStr = stationline[index ?? 0]
                timestring.append(stationlineStr)
                timestring.append(xianStr)
                let stationName = stationNames[index ?? 0]
                timestring.append(stationName)
                timestring.append(zhanStr)
                
                if index == stationline.count - 1 {
                    trafficString?.append("\(timestring)")
                }else {
                    trafficString?.append("\(timestring) \n")
                }
            }
        }
        
        let size = trafficString?.boundingRect(with: CGSize(width: kWidth - 35 - left_pending_space_17 * 2, height: kHeight), font: FONT_12)
        if size?.height ?? 0 <= 30.0 {
            trafficHeight = 30
        }else {
            trafficHeight = size?.height ?? 0
        }
        
    }
}

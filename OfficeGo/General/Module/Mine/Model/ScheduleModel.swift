//
//  ScheduleModel.swift
//  OfficeGo
//
//  Created by mac on 2020/6/9.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

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
    ///行程审核状态 0预约待接受 1预约成功 2预约失败 3已看房 4未看房
    var auditStatus : Int?
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


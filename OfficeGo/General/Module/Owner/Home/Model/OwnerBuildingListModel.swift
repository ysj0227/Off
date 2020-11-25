//
//  OwnerBuildingListModel.swift
//  OfficeGo
//
//  Created by Mac pro on 2020/10/21.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class OwnerBuildingModel: BaseModel {

    var auditStatus: Int?
    var page: [OwnerBuildingListModel]?
    var companyVerify: Int?
}
class OwnerBuildingListModel: BaseModel {
    
    ///是否是管理员
    var isBuildingManager : Bool?
    ///是否可以编辑 为0时不可以编辑楼盘，为1时可以编辑楼盘
    var isEdit : Bool?
    ///是不是临时的楼盘；0不是，1是
    var isTemp : Bool?
    ///1:楼盘,2:网点
    var btype : Int?
    var buildingId : Int?
    var buildingName : String?
    ///所属商圈-静安区-静安市
    var businessDistrict : String?
    var dayPrice : String?
    var mainPic : String?
    var nCount : Int?
    var payStatus : Int?
    var perfect : String?
    //var remark : String?
    ///-1:不是管理员 暂无权限编辑楼盘(临时楼盘),0: 下架(未发布),1: 上架(已发布) ;2:资料待完善 ,3: 置顶推荐;4:已售完;5:删除;6待审核7已驳回 注意：（IsTemp为1时，status状态标记 1:待审核 -转6 ,2:已驳回 -转7 ）
    var status : Int?
    var updateTime : Int?
    var updateUser : String?
    var yCount : String?

    ///网点总层数
    var totalFloor: String?
    
    ///是否可以添加房源
    var isAddHouse: Bool?
    
    ///驳回原因
    var remark : [DictionaryModel]?

    ///开始请求时间戳
    var startTime: Double = 0
    
    ///结束请求时间戳
    var endTime: Double = 0
}
class OwnerBuildingListViewModel: NSObject {
    ///1是写字楼，2是共享办公
    var btype: Int?
    var buildingId: Int?                  //id
    var buildingName: String?           //楼盘名称
    var isEdit : Bool?
    ///是不是临时的楼盘；0不是，1是
    var isTemp : Bool?
    ///-1:不是管理员 暂无权限编辑楼盘(临时楼盘),0: 下架(未发布),1: 上架(已发布) ;2:资料待完善 ,3: 置顶推荐;4:已售完;5:删除;6待审核7已驳回 注意：（IsTemp为1时，status状态标记 1:待审核 -转6 ,2:已驳回 -转7 ）
    var status : Int?
    
    ///认证按钮是否展示修改 - 默认隐藏
    var isHiddenIdentifyBtn: Bool = true
    
    ///标签图片
    var houseTypTags: String?
    
    var redViewColor: String?
    
    ///红色小图标的左边距离
    var redViewLeading : CGFloat?
    
    
    ///网点总层数
    var totalFloor: String?
    
    ///是否可以添加房源
    var isAddHouse: Bool?

    ///驳回原因 - 文本
    var remarkString : String?
    
    ///开始请求时间戳
    var startTimeString: String = ""
    
    ///结束请求时间戳
    var endTimeString: String = ""
    
    init(model:OwnerBuildingListModel) {
        super.init()
        
        totalFloor = model.totalFloor
        isAddHouse = model.isAddHouse
        
        btype = model.btype
        buildingId = model.buildingId
        isEdit = model.isEdit
        isTemp = model.isTemp
        status = model.status
                
        startTimeString = SSTool.timeIntervalChangeToTimeStr(timeInterval: TimeInterval.init(model.startTime), dateFormat: "yyyy-MM-dd HH:mm")
        
        endTimeString = SSTool.timeIntervalChangeToTimeStr(timeInterval: TimeInterval.init(model.endTime), dateFormat: "yyyy-MM-dd HH:mm")
        
        if let remarkArr = model.remark {
            remarkString = "驳回原因："

            for model in remarkArr {
                
                remarkString?.append(model.dictCname ?? "")
                                
                let index = remarkArr.firstIndex(of: model)
                
                if index == remarkArr.count - 1 {
                    remarkString?.append("")
                }else {
                    remarkString?.append("\n")
                }

            }
        }
                
        /*
         1: 上架(已发布)
        待审核： status"= 6 ｜｜  isTemp": = 1
        资料待完善 status = 2:资料待完善
        status 7已驳回*/
        
        if model.status == 1 {
            houseTypTags = "empty"
            
            isHiddenIdentifyBtn = true
            ///16字
            //截取
            if model.buildingName?.count ?? 0 > 16 {
                let index = model.buildingName?.index((model.buildingName?.startIndex)!, offsetBy: 16)
                let str = model.buildingName?.substring(to: index!)
                buildingName = "\(str ?? "")..."
            }else {
                buildingName = model.buildingName
            }

        }else if model.status == 2 {
            houseTypTags = "identifyToAdvisedTag"
            
            isHiddenIdentifyBtn = true

            ///12
            //截取
            if model.buildingName?.count ?? 0 > 12 {
                let index = model.buildingName?.index((model.buildingName?.startIndex)!, offsetBy: 12)
                let str = model.buildingName?.substring(to: index!)
                buildingName = " \(str ?? "")..."
            }else {
                buildingName = " \(model.buildingName ?? "")"
            }

        }else if model.status == 7 {
            houseTypTags = "identifyRejectTag"
            
            isHiddenIdentifyBtn = false

            ///12
            //截取
            if model.buildingName?.count ?? 0 > 12 {
                let index = model.buildingName?.index((model.buildingName?.startIndex)!, offsetBy: 12)
                let str = model.buildingName?.substring(to: index!)
                buildingName = " \(str ?? "")..."
            }else {
                buildingName = " \(model.buildingName ?? "")"
            }

        }else if model.status == 6 || model.isTemp == true {
            houseTypTags = "identifyIngTag"
            
            isHiddenIdentifyBtn = true

            ///12
            //截取
            if model.buildingName?.count ?? 0 > 12 {
                let index = model.buildingName?.index((model.buildingName?.startIndex)!, offsetBy: 12)
                let str = model.buildingName?.substring(to: index!)
                buildingName = " \(str ?? "")..."
            }else {
                buildingName = " \(model.buildingName ?? "")"
            }

        }
        
        ///红色通知
        //redViewColor = "noReadRed"
        redViewColor = ""
        
        let size = buildingName?.boundingRect(with: CGSize(width: kWidth, height: OwnerBuildingListCell.rowHeight()), font: FONT_14)
        redViewLeading = size?.width
    }
}



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
    var remark : String?
    ///-1:不是管理员 暂无权限编辑楼盘(临时楼盘),0: 下架(未发布),1: 上架(已发布) ;2:资料待完善 ,3: 置顶推荐;4:已售完;5:删除;6待审核7已驳回 注意：（IsTemp为1时，status状态标记 1:待审核 -转6 ,2:已驳回 -转7 ）
    var status : Int?
    var updateTime : Int?
    var updateUser : String?
    var yCount : String?

}
class OwnerBuildingListViewModel: NSObject {
    ///1是写字楼，2是共享办公
    var btype: Int?
    var idString: Int?                  //房源id
    var buildingName: String?           //楼盘名称
    var isEdit : Bool?
    ///是不是临时的楼盘；0不是，1是
    var isTemp : Bool?
    
    ///标签图片
    var houseTypTags: String?
    
    
    init(model:OwnerBuildingListModel) {
        super.init()
        btype = model.btype
        idString = model.buildingId
        isEdit = model.isEdit
        isTemp = model.isTemp
        
        if btype == 1 {
            houseTypTags = "identifyToAdvisedTag"
            ///12
            //截取
            if model.buildingName?.count ?? 0 > 12 {
                let index = model.buildingName?.index((model.buildingName?.startIndex)!, offsetBy: 12)
                let str = model.buildingName?.substring(to: index!)
                buildingName = " \(str ?? "")..."
            }else {
                buildingName = " \(model.buildingName ?? "")"
            }

        }else {
            houseTypTags = "empty"
            ///16字
            //截取
            if model.buildingName?.count ?? 0 > 16 {
                let index = model.buildingName?.index((model.buildingName?.startIndex)!, offsetBy: 16)
                let str = model.buildingName?.substring(to: index!)
                buildingName = "\(str ?? "")..."
            }else {
                buildingName = model.buildingName
            }

        }
//        "identifyRejectTag"
//        "identifyIngTag"
//        "identifyToAdvisedTag"
    }
}


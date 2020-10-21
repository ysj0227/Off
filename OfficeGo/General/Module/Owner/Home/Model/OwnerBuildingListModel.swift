//
//  OwnerBuildingListModel.swift
//  OfficeGo
//
//  Created by Mac pro on 2020/10/21.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class OwnerBuildingListModel: BaseModel {
    ///是否有vr，1 有，0 没有
    var vr: String?
    
    var address : String?               //距离
    var areaMap : [Float]?
    var btype : Int?                    //类型,1:楼盘,2:网点,当是1的时候,网点名称可为空
    var buildingMap : BuildingMap?      //
    var businessDistrict : String?      //所属商圈-静安区-静安市
    var createTime : Int?
    var distance : String?              //距离
    var Isfailure : Int?                //0: 下架(未发布),1: 上架(已发布) ;2:资料待完善 ,3: 置顶推荐;4:已售完;5:删除
    var id: Int?                        //楼盘id
    var independenceOffice : Int?       //独立办公室数量
    var mainPic : String?               //封面图
    var maxArea : Float?
    var maxDayPrice : Float?
    var maxSeats : Int?
    var minDayPrice : Float?
    var minSeats : Int?
    var name : String?                  //楼盘名称, 网点名称
    var officeType: String?             //逗号分隔的办公类型1是独立办公室，2是开放工位
    var openStation : Int?              //开放工位数量
    var passengerLift : String?
    var releaseTime : Int?        //发布时间
    var remark : AnyObject?
    var seatMonthPrice : Float?
    var storeyHeight : String?
    var tags : [DictionaryModel]?       //楼盘网点特色
    var totalFloor : String?
    var updateTime : Int?
    var userId : String?             //用户id 发布者
}
class OwnerBuildingListViewModel: NSObject {
    ///1是写字楼，2是共享办公
    var btype: Int?
    var idString: Int?                  //房源id
    var Isfailure : Int?                //0: 下架(未发布),1: 上架(已发布) ;2:资料待完善 ,3: 置顶推荐;4:已售完;5:删除
    var buildingName: String?           //楼盘名称
    
    ///标签图片
    var houseTypTags: String?
    
    
    init(model:OwnerBuildingListModel) {
        super.init()
        btype = model.btype
        idString = model.id
        Isfailure = model.Isfailure
        
        if btype == 1 {
            houseTypTags = "identifyToAdvisedTag"
            ///12
            //截取
            if model.name?.count ?? 0 > 12 {
                let index = model.name?.index((model.name?.startIndex)!, offsetBy: 12)
                let str = model.name?.substring(to: index!)
                buildingName = " \(str ?? "")..."
            }else {
                buildingName = " \(model.name ?? "")"
            }

        }else {
            houseTypTags = "empty"
            ///16字
            //截取
            if model.name?.count ?? 0 > 16 {
                let index = model.name?.index((model.name?.startIndex)!, offsetBy: 16)
                let str = model.name?.substring(to: index!)
                buildingName = "\(str ?? "")..."
            }else {
                buildingName = model.name
            }

        }
//        "identifyRejectTag"
//        "identifyIngTag"
//        "identifyToAdvisedTag"
    }
}



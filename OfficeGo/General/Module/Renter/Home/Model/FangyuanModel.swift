//
//  FangYuanListModel.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/5/9.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class FangYuanListModel: BaseModel {
    
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

//地址模型
class BuildingMap : BaseModel {
    
    var nearbySubwayTime : [String]?    //距离最近地铁达到时间
    var stationColours : [String]?      //地铁线颜色
    var stationNames : [String]?        //站名
    var stationline : [String]?         //距离最近地铁先，进的在前
}
class FangYuanListViewModel: NSObject {
    ///是否有vr，1 有，0 没有
    var vr: String?
    ///1是写字楼，2是共享办公
    var btype: Int?
    var idString: Int?                  //房源id
    var Isfailure : Int?                //0: 下架(未发布),1: 上架(已发布) ;2:资料待完善 ,3: 置顶推荐;4:已售完;5:删除
    var mainPicImgString: String?       //封面图
    var buildingName: String?           //楼盘名称
    var distanceString: String?         //距离 1.0km
    var addressString: String?          //区域和商圈 徐汇区 · 徐家汇
    var walkTimesubwayAndStationString: String?  //步行5分钟到 | 2号线 ·东昌路站
    var dayPriceString: String?         //日租金
    var unitString: String?             //单位 /m²/天起
    var areaString: [String]?             //平方米
    var tagsString: [String]?             //特色
    var jointDuliAndLianheNumString: [String]?//共享办公 独立办公室和开放工位的数量
    var rowHeight: CGFloat = 192
    
    init(model:FangYuanListModel) {
        super.init()
        vr = model.vr
        btype = model.btype
        idString = model.id
        Isfailure = model.Isfailure
        mainPicImgString = model.mainPic
        buildingName = model.name
        distanceString = model.distance ?? ""
        addressString = model.businessDistrict ?? ""
        guard let nearbySubwayTime = model.buildingMap?.nearbySubwayTime else {
            return
        }
        if nearbySubwayTime.count > 0 {
            walkTimesubwayAndStationString = "步行"
            walkTimesubwayAndStationString?.append(nearbySubwayTime.count > 0 ? nearbySubwayTime[0] : "")
            walkTimesubwayAndStationString?.append("分钟到 | ")
            guard let stationline = model.buildingMap?.stationline else {
                return
            }
            walkTimesubwayAndStationString?.append(stationline.count > 0 ? stationline[0] : "")
            walkTimesubwayAndStationString?.append("号线 ·")
            guard let stationNames = model.buildingMap?.stationNames else {
                return
            }
            walkTimesubwayAndStationString?.append(stationNames.count > 0 ? stationNames[0] : "")
            
        }

        dayPriceString = "¥\(model.minDayPrice ?? 0)"
        if model.btype == 1  {
            unitString = "/m²/天起"
        }else if model.btype == 2  {
            unitString = "/位/月起"
        }
        
        //面积
        areaString = []
        model.areaMap?.forEach({[weak self] (area) in
            self?.areaString?.append(String(format: "%.0fm²", area))
        })
        //特色
        tagsString = []
        model.tags?.forEach({[weak self] (model) in
            self?.tagsString?.append(model.dictCname ?? "")
        })
        
        
        //开放工位数和独立办公室数量
        jointDuliAndLianheNumString = []
        if model.independenceOffice ?? 0 > 0 {
            jointDuliAndLianheNumString?.append("独立办公室\(model.independenceOffice ?? 0)间")
        }
        if model.openStation ?? 0 > 0 {
            jointDuliAndLianheNumString?.append("开放工位\(model.openStation ?? 0)个")
        }
        
        if model.tags?.count ?? 0 <= 0 {
            rowHeight = 192 - 30
        }else {
            rowHeight = 192
        }
    }
}



//
//  OwnerFYListModel.swift
//  OfficeGo
//
//  Created by Mac pro on 2020/10/14.
//  Copyright © 2020 Senwei. All rights reserved.
//

///房源列表模型
class OwnerFYListModel: FangYuanBuildingOpenStationModel {
    
}
///房源列表viewmodel模型
class OwnerFYListViewModel: NSObject {
    ///是否有vr，1 有，0 没有
    var vr: String?
    ///1是写字楼，2是共享办公
    var btype: Int?
    ///房源id
    var id : Int?
    
    ///0: 下架(未发布),1: 上架(已发布) ;2:资料待完善 ,3: 置顶推荐;4:已售完;5:删除
    var Isfailure : Int?

    /// 办公类型1是独立办公室，2是开放工位
    var officeType : Int?
    
    var mainPic : String?
    
    var buildingName : String?
    
    var addressString : String?
    
    ///开放工位
    ///工位数 - 30工位
    var openSeatsString : String?
    var openSeatsStringAttri : NSMutableAttributedString?

    ///工位
    var openSeatsUnitLBString : String?
    ///月租金
    var openMonthPriceString : String?
    ///最短租期---6个月可租
    var openMinimumLeaseString : String?
    
    
    ///独立办公室
    ///
    ///面积
    var individualAreaString : String?
    ///每工位每月租金  3000.0
    var individualMonthPriceString : String?
    ///工位数 - 30工位
    var individualSeatsString : String?
    var individualSeatsStringAttri : NSMutableAttributedString?
    ///每工位每天租金  3000.0
    var individualDayPriceString : String?
    
    
    ///面积
    var buildingArea : String?
    ///工位数
    var buildinSeats : String?
    var buildingDayPriceString : String?
    ///月租金
    var buildingMonthPriceString : String?
    ///装修
    var buildingDecoration : String?
    ///楼层 - 只显示8楼，不显示总层数
    var buildingFloor : String?
    
    ///房源标签图片
    var houseTypTags: String?
    
    ///失效icon
    var houseFailureImg : String?
    
    ///上架下架按钮标题
    var closePublishBtnTitle : String?
    
    ///上架下架按钮隐藏
    var closePublishBtnHidden : Bool?
    
    
    init(model:OwnerFYListModel) {
        super.init()
        vr = model.vr
        Isfailure = model.Isfailure
        btype = model.btype
        id = model.id
        mainPic = model.mainPic
        buildingName = model.buildingName
        addressString = model.businessDistrict ?? ""

        if btype == 1 {
            buildingArea = String(format: "%.0f㎡", model.area ?? 0)
            let arr = model.simple?.split{$0 == ","}.map(String.init)
            if let simpleArr = arr {
                if simpleArr.count >= 2 {
                    buildinSeats = "最多\(simpleArr[1])个工位"
                }
            }else {
                buildinSeats = "最多0个工位"
            }
            buildingDayPriceString = "¥\(model.dayPrice ?? 0)/㎡/天"
            buildingMonthPriceString = "¥\(model.monthPrice ?? 0)/月"
            buildingDecoration = model.decoration ?? ""
            if model.floor?.isBlankString ?? false == true && model.totalFloor?.isBlankString ?? false == true {
                buildingFloor = "--"
            }else {
                buildingFloor = "\(model.floor ?? "0")楼"
            }
            
            
            houseTypTags = ""
            
            ///下架
            if Isfailure == 0 {
                closePublishBtnTitle = "   重新发布   "
                closePublishBtnHidden = false
                houseFailureImg = "isFailureIcon"
            }else {
                closePublishBtnTitle = ""
                closePublishBtnHidden = true
                houseFailureImg = ""
            }
            

            
        }else if btype == 2 {
            
            officeType = model.officeType
            
            ///独立办公室
            if officeType == 1 {
                individualAreaString = String(format: "%.0f㎡", model.area ?? 0)
                individualMonthPriceString = "¥\(model.monthPrice ?? 0)"
                individualSeatsString = "\(model.seats ?? 0)" + "人间"
                individualSeatsStringAttri = FuWenBen(name: "\(model.seats ?? 0)", centerStr: "人间")
                individualDayPriceString = "¥\(model.dayPrice ?? 0)/位/月"
                
                
                houseTypTags = "individualOfficeTag"
                
                ///下架
                if Isfailure == 0 {
                    closePublishBtnTitle = "   重新发布   "
                    closePublishBtnHidden = false
                    houseFailureImg = "isFailureIcon"
                }else {
                    closePublishBtnTitle = ""
                    closePublishBtnHidden = true
                    houseFailureImg = ""
                }
                           

            }else {
                openSeatsString = "\(model.seats ?? 0)" + "工位"
                openSeatsStringAttri = FuWenBen(name: "\(model.seats ?? 0)", centerStr: "工位")
                openSeatsUnitLBString = "开放工位"
                openMonthPriceString = "¥\(model.dayPrice ?? 0)"
                openMinimumLeaseString = "\(model.minimumLease ?? "")" + "个月起租"
                
                
                houseTypTags = "openstationTag"

                if Isfailure == 0 {
                    closePublishBtnTitle = "   重新发布   "
                    closePublishBtnHidden = false
                    houseFailureImg = "isFailureIcon"
                }else {
                    closePublishBtnTitle = "   关闭   "
                    closePublishBtnHidden = false
                    houseFailureImg = ""
                }
                
            }
        }
    }
    
    func FuWenBen(name: String, centerStr: String) -> NSMutableAttributedString {
        //定义富文本即有格式的字符串
        let attributedStrM : NSMutableAttributedString = NSMutableAttributedString()
        
        if name.count > 0 {
            let nameAtt = NSAttributedString.init(string: name, attributes: [NSAttributedString.Key.backgroundColor : kAppWhiteColor , NSAttributedString.Key.foregroundColor : kAppColor_333333 , NSAttributedString.Key.font : FONT_MEDIUM_13])
            attributedStrM.append(nameAtt)
            
        }
        
        if centerStr.count > 0 {
            //*
            let xingxing = NSAttributedString.init(string: centerStr, attributes: [NSAttributedString.Key.backgroundColor : kAppWhiteColor , NSAttributedString.Key.foregroundColor : kAppColor_666666 , NSAttributedString.Key.font : FONT_12])

            attributedStrM.append(xingxing)
            
        }
        
        return attributedStrM
    }
}

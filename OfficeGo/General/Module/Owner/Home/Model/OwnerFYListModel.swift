//
//  OwnerFYListModel.swift
//  OfficeGo
//
//  Created by Mac pro on 2020/10/14.
//  Copyright © 2020 Senwei. All rights reserved.
//

///房源列表模型
class OwnerFYListModel: BaseModel {
    ///是否有添加管理员的权限 true：是，false：否
    var ispermissions : Bool?
    ///房源面积
    var area : Float?
    var btype : Int?
    ///单价
    var dayPrice : Float?
    ///房源装修类型
    var dictCname : String?
    var houseId : Int?
    ///房源当前状态0未发布，1发布，2下架,3:待完善
    var houseStatus : Int?
    var mainPic : String?
    var monthPrice : Float?
    ///办公类型1是独立办公室，2是开放工位
    var officeType : Int?
    var perfect : String?
    ///楼盘下房源的时候是预估工位数，网点下面房源时为工位数
    var seats : String?
    var title : String?
    var updateTime : Int?
    var updateUser : String?
    
    ///0是正式表1临时表
    var isTemp : Bool?
    
    var buildingId : Int?

    
}
///房源列表viewmodel模型
class OwnerFYListViewModel: NSObject {
       ///是否有添加管理员的权限 true：是，false：否
    var ispermissions : Bool?
    ///房源面积
    var area : Float?

    ///单价
    var dayPrice : Float?
    ///房源装修类型
    var dictCname : String?
    
    var houseId : Int?
    
    ///房源当前状态0未发布，1发布，2下架,3:待完善
    var houseStatus : Int?

    var monthPrice : Float?
    
    var perfect : String?
    
    ///楼盘下房源的时候是预估工位数，网点下面房源时为工位数
    var seats : String?

    var updateTime : Int?
    
    var updateUser : String?
    
    
    var houseName : String?

    ///1是写字楼，2是共享办公
    var btype: Int?

    /// 办公类型1是独立办公室，2是开放工位
    var officeType : Int?
    
    var mainPic : String?
    
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
    
    ///如果已经发布，可以分享 否则不能分享
    var isPublish : Bool?
    
    ///更多按钮里边的选项 - 如果是开放工位，只有删除
    ///其他，只有上架的时候，才有下架
    var moreSettingArr : [OWnerFYMoreSettingEnum] = []
    
    ///0是正式表1临时表
    var isTemp : Bool?
    
    var buildingId : Int?

        
    init(model:OwnerFYListModel) {
        super.init()
        btype = model.btype
        houseName = model.title
        houseId = model.houseId
        mainPic = model.mainPic
        houseStatus = model.houseStatus
        isTemp = model.isTemp
        buildingId = model.buildingId
        
        
        if model.houseStatus == 1 {
            isPublish = true
        }else {
            isPublish = false
        }
        
        if btype == 1 {
            buildingArea = String(format: "%.0f㎡", model.area ?? 0)
            let arr = model.seats?.split{$0 == ","}.map(String.init)
            if let simpleArr = arr {
                if simpleArr.count >= 2 {
                    buildinSeats = "最多\(simpleArr[1])个工位"
                }
            }else {
                buildinSeats = "最多0个工位"
            }
            buildingDayPriceString = "¥\(model.dayPrice ?? 0)/㎡/天起"
            buildingMonthPriceString = "¥\(model.monthPrice ?? 0)/月"
            buildingDecoration = model.dictCname ?? ""
            
            houseTypTags = "empty"
            
            ///房源当前状态0未发布，1发布，2下架,3:待完善
            if houseStatus == 1 {
                closePublishBtnTitle = ""
                closePublishBtnHidden = true
                houseFailureImg = ""
                moreSettingArr = [OWnerFYMoreSettingEnum.xiaJiaEnum, OWnerFYMoreSettingEnum.deleteEnum]
            }else if houseStatus == 2 {
                closePublishBtnTitle = "   重新发布   "
                closePublishBtnHidden = false
                houseFailureImg = "isFailureIcon"
                moreSettingArr = [OWnerFYMoreSettingEnum.deleteEnum]
            }else {
                closePublishBtnTitle = "   发布   "
                closePublishBtnHidden = false
                houseFailureImg = ""
                moreSettingArr = [OWnerFYMoreSettingEnum.deleteEnum]
            }
            
            
        }else if btype == 2 {
            
            officeType = model.officeType
            
            ///独立办公室
            if officeType == 1 {
                individualAreaString = String(format: "%.0f㎡", model.area ?? 0)
                individualMonthPriceString = "¥\(model.monthPrice ?? 0)"
                individualSeatsString = "\(model.seats ?? "0")" + "人间"
                individualSeatsStringAttri = FuWenBen(name: "\(model.seats ?? "0")", centerStr: "人间")
                individualDayPriceString = "¥\(model.dayPrice ?? 0)/位/月"
                
                
                houseTypTags = "individualOfficeTag"
                
                ///房源当前状态0未发布，1发布，2下架,3:待完善
                if houseStatus == 1 {
                    closePublishBtnTitle = ""
                    closePublishBtnHidden = true
                    houseFailureImg = ""
                    moreSettingArr = [OWnerFYMoreSettingEnum.xiaJiaEnum, OWnerFYMoreSettingEnum.deleteEnum]
                }else if houseStatus == 2 {
                    closePublishBtnTitle = "   重新发布   "
                    closePublishBtnHidden = false
                    houseFailureImg = "isFailureIcon"
                    moreSettingArr = [OWnerFYMoreSettingEnum.deleteEnum]
                }else {
                    closePublishBtnTitle = "   发布   "
                    closePublishBtnHidden = false
                    houseFailureImg = ""
                    moreSettingArr = [OWnerFYMoreSettingEnum.deleteEnum]
                }
                           

            }else {
                openSeatsString = "共\(model.seats ?? "0")" + "工位"
                openSeatsStringAttri = FuWenBen(name: "\(model.seats ?? "0")", centerStr: "工位")
                openSeatsUnitLBString = "开放工位"
                openMonthPriceString = "¥\(model.dayPrice ?? 0)/位/月"
                
                
                houseTypTags = "openstationTag"

                ///房源当前状态0未发布，1发布，2下架,3:待完善
                if houseStatus == 1 {
                    closePublishBtnTitle = "   关闭   "
                    closePublishBtnHidden = false
                    houseFailureImg = ""
                }else {
                    closePublishBtnTitle = "   重新发布   "
                    closePublishBtnHidden = false
                    houseFailureImg = "isFailureIcon"
//                    if houseStatus == 0 || houseStatus == 3{
//                        closePublishBtnTitle = "   发布   "
//                        closePublishBtnHidden = false
//                        houseFailureImg = ""
//                    }else if houseStatus == 2 {
//                        closePublishBtnTitle = "   重新发布   "
//                        closePublishBtnHidden = false
//                        houseFailureImg = "isFailureIcon"
//                    }
                }
                
                moreSettingArr = [OWnerFYMoreSettingEnum.deleteEnum]
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

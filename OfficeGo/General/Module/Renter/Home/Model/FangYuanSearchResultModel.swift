//
//  FangYuanSearchResultModel.swift
//  OfficeGo
//
//  Created by mac on 2020/6/5.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

///搜索历史记录
class SearchHistoryModel: BaseModel {
    var id : Int?
    var keywords: String?
}

class FangYuanSearchResultModel: BaseModel {
    ///1是办公楼，2是联合办公
    var buildType: Int?
    ///楼盘id
    var bid : Int?
    var buildingName: String?
    ///区域
    var district : String?
    ///商圈
    var business : String?
    ///地址
    var address : String?
    ///价格
    var dayPrice : Float?
}

class FangYuanSearchResultViewModel: NSObject {
    ///1是办公楼，2是联合办公
    var buildType: Int?
    ///楼盘id
    var bid : Int?
    var buildingAttributedName: NSMutableAttributedString?
    ///区域
    var districtBusinessString : NSMutableAttributedString?
    var districtString : NSMutableAttributedString?
    var businessString : NSMutableAttributedString?

    
    ///地址
    var addressString : NSMutableAttributedString?
    ///价格
    var dayPriceString : String?
    
    init(model:FangYuanSearchResultModel) {
        
        buildType = model.buildType
        
        bid = model.bid
        
        if let address = model.address {
            if let str = address.removingPercentEncoding, let data = str.data(using: String.Encoding.unicode) {
                
                let strOptions = [NSAttributedString.DocumentReadingOptionKey.documentType : NSAttributedString.DocumentType.html]
                do {
                    
                    let attrStr = try NSMutableAttributedString.init(data: data, options: strOptions, documentAttributes: nil)
                    addressString = attrStr
                } catch  {

                }
            }
        }else {
            addressString = NSMutableAttributedString.init()
        }
        
        
        if let address = model.district {
            if let str = address.removingPercentEncoding, let data = str.data(using: String.Encoding.unicode) {
                
                let strOptions = [NSAttributedString.DocumentReadingOptionKey.documentType : NSAttributedString.DocumentType.html]
                do {
                    
                    let attrStr = try NSMutableAttributedString.init(data: data, options: strOptions, documentAttributes: nil)
                    districtString = attrStr
                } catch  {

                }
            }
        }else {
            districtString = NSMutableAttributedString.init()
        }
        
        if let address = model.business {
            if let str = address.removingPercentEncoding, let data = str.data(using: String.Encoding.unicode) {
                
                let strOptions = [NSAttributedString.DocumentReadingOptionKey.documentType : NSAttributedString.DocumentType.html]
                do {
                    
                    let attrStr = try NSMutableAttributedString.init(data: data, options: strOptions, documentAttributes: nil)
                    businessString = attrStr
                } catch  {

                }
            }
        }else {
            businessString = NSMutableAttributedString.init()
        }
        
        districtBusinessString = NSMutableAttributedString.init()
        districtBusinessString?.append(districtString ?? NSMutableAttributedString.init())
        districtBusinessString?.append(NSMutableAttributedString.init(string: "-"))
        districtBusinessString?.append(businessString ?? NSMutableAttributedString.init())
                
        if let address = model.buildingName {
            if let str = address.removingPercentEncoding, let data = str.data(using: String.Encoding.unicode) {
                
                let strOptions = [NSAttributedString.DocumentReadingOptionKey.documentType : NSAttributedString.DocumentType.html]
                do {
                    
                    let attrStr = try NSMutableAttributedString.init(data: data, options: strOptions, documentAttributes: nil)
                    buildingAttributedName = attrStr
                } catch  {

                }
            }
        }else {
            buildingAttributedName = NSMutableAttributedString.init()
        }
        
        dayPriceString = "¥\(model.dayPrice ?? 0)" + "/m²/天起"

    }
}

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
    var districtBusinessString : String?
    ///地址
    var addressString : String?
    ///价格
    var dayPriceString : String?
    
    init(model:FangYuanSearchResultModel) {
        
        buildType = model.buildType
        
        bid = model.bid
        
        addressString = model.address
        
        districtBusinessString = "\(model.district ?? "")" + "-" + "\(model.business ?? "")"
                
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
        
        dayPriceString = String(format: "%.0f", model.dayPrice ?? 0) + "/m²/天起"

    }
}

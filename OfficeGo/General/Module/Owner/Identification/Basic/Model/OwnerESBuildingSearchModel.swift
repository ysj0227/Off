//
//  OwnerESBuildingSearchModel.swift
//  OfficeGo
//
//  Created by mac on 2020/7/14.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class OwnerESBuildingSearchModel: BaseModel {
    var address : String?
    var bid : Int?
    var buildType : Int?
    var buildingName : String?
    var business : String?
    var dayPrice : Float?
    var district : String?
    var mainPic : String?
}
class OwnerESBuildingSearchViewModel: NSObject {
    ///1是办公楼，2是联合办公
    var buildType: Int?
    ///楼盘id
    var bid : Int?
    ///楼盘名字
    var buildingAttributedName: NSMutableAttributedString?
    ///地址
    var addressString : NSMutableAttributedString?
    
    init(model:OwnerESBuildingSearchModel) {
        
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
    }
}

//
//  OwnerESBuildingSearchModel.swift
//  OfficeGo
//
//  Created by mac on 2020/7/14.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class OwnerESBuildingSearchModel: BaseModel {
    //详细地址
    var address : String?
    var bid : String?
    var buildType : Int?
    var buildingName : String?
    var business : String?
    var dayPrice : Float?
    var district : String?
    var mainPic : String?
    //城市商圈地址
    var buildingAddress : String?
}
class OwnerESBuildingSearchViewModel: NSObject {
    var mainPic : String?

    ///1是写字楼，2是共享办公
    var buildType: Int?
    ///楼盘id
    var bid : String?
    ///楼盘名字
    var buildingAttributedName: NSMutableAttributedString?
    ///地址
    var addressString : NSMutableAttributedString?
    
    var business : String?

    var district : String?
    
    init(model:OwnerESBuildingSearchModel) {
        
        mainPic = model.mainPic
        
        buildType = model.buildType
        
        bid = model.bid
        
        business = model.business
        
        district = model.district
        
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

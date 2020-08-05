//
//  OwnerEMSearchModel.swift
//  OfficeGo
//
//  Created by mac on 2020/7/14.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class OwnerESCompanySearchModel: BaseModel {
    var address : String?
    var bid : String?
    var branchesName : String?
    var buildingName : String?
    
    var realname : String?

    //1 企业认证 2已认证网点
    var identityType : String?
    /*
     公司名称
     */
    var company : String?
    ///营业执照
    var creditNo : String?
}
class OwnerESCompanySearchViewModel: NSObject {
    
    var realname : String?
    
    ///楼盘id
    var bid : String?
    ///地址
    var companyString : NSMutableAttributedString?
    
    ///地址
    var addressString : NSMutableAttributedString?
    
    ///营业执照
    var creditNo : String?
    
    //1 企业认证 2已认证网点
    var identityType : String?
    
    init(model:OwnerESCompanySearchModel) {
                
        bid = model.bid
        
        identityType = model.identityType
        
        realname = model.realname
        
        creditNo = model.creditNo
        
        if let company = model.company {
            if let str = company.removingPercentEncoding, let data = str.data(using: String.Encoding.unicode) {
                
                let strOptions = [NSAttributedString.DocumentReadingOptionKey.documentType : NSAttributedString.DocumentType.html]
                do {
                    
                    let attrStr = try NSMutableAttributedString.init(data: data, options: strOptions, documentAttributes: nil)
                    companyString = attrStr
                } catch  {

                }
            }
        }else {
            companyString = NSMutableAttributedString.init()
        }
        
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
    }
}

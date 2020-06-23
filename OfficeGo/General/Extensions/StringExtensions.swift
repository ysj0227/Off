//
//  StringExtensions.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/4/26.
//  Copyright © 2020 Senwei. All rights reserved.
//

import Foundation
import CommonCrypto
import SwiftyJSON

extension String {
    func parseQueryToDictionary() -> [String: String] {
        var dic = [String: String]()
        let querys = self.components(separatedBy: "&")
        for query in querys {
            if query.contains("=") {
                let array = query.components(separatedBy: "=")
                if array.count < 2 {
                    continue
                }
                if let key = array[0].removingPercentEncoding, let value = array[1].removingPercentEncoding {
                    dic[key] = value
                }
            }
        }
        return dic
    }
    
    var MD5: String {        
        let cStrl = cString(using: String.Encoding.utf8);
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 16);
        CC_MD5(cStrl, CC_LONG(strlen(cStrl!)), buffer);
        var md5String = ""
        for idx in 0...15 {
            let obcStrl = String.init(format: "%02x", buffer[idx]);
            md5String.append(obcStrl);
        }
        free(buffer);
        return md5String
    }
    
    var length:Int {return self.count}
    
    var isBlankString: Bool {
        let trimmedStr = self.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedStr.isEmpty
    }

    var dictionary: Dictionary<String,AnyObject> {
        if let data: Data = self.data(using: .utf8) {
            let dic = JSON.init(data).dictionaryObject
            return dic! as Dictionary<String, AnyObject>
        }
        return[:]
    }
    
    func getSecretPhoneString() -> String{
//        var re = "/^(\d{3})\d{4}(\d{4})$/"
//        return phoneNumber.replace(re, "$1****$2")
        if self.count > 7 {
            let start = self.index(self.startIndex, offsetBy: 3)
            let end = self.index(self.startIndex, offsetBy: 7)
            let range = Range(uncheckedBounds: (lower: start, upper: end))
            return self.replacingCharacters(in: range, with: "****")
        }else {
            return self
        }
        
    }
}

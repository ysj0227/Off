//
//  User.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/4/26.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit
import HandyJSON

class User: NSObject, HandyJSON {
    
    @objc var id: Int64 = 0
    @objc var gName: String?
    @objc var gPicture: String?
    @objc var gEmail: String?
    @objc var gLocale: String?
    @objc var mobile: String?
    @objc var nickName: String?
    var sex: Int32?
    @objc var invitationCode: String?
    @objc var isWalletForbid: Bool = false
    
    required override init() {}
    
    func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.gName <-- "gname"
        mapper <<<
            self.gPicture <-- "gpicture"
        mapper <<<
            self.gEmail <-- "gemail"
        mapper <<<
            self.gLocale <-- "glocale"
    }
}

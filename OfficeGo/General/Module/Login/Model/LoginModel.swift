//
//  RegistModel.swift
//  UUStudent
//
//  Created by mac on 2019/5/21.
//  Copyright © 2019 bike. All rights reserved.
//

import UIKit
import HandyJSON

class LoginModel: NSObject, HandyJSON {
    
    required override init(){
        
    }
    
    var rid: Int?
    var rongyuntoken: String?
    var token: String?
    var uid: Int?
}

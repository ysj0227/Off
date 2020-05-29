//
//  DictionaryModel.swift
//  OfficeGo
//
//  Created by mac on 2020/5/29.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class DictionaryModel: BaseModel {
    ///id
    var dictValue: Int?
    
    ///图标
    var dictImg: String?
    
    ///名称
    var dictCname: String?

    required init() {
        dictValue = 0
        dictImg = ""
        dictCname = ""
    }
}

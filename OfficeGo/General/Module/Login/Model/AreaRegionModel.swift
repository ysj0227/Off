//
//  AreaRegionModel.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/5/6.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit
import HandyJSON


class AreaModel: HandyJSON {
   var areaModelCount = [AreaCategorySelectModel]()

   required init() {
   }

}

class AreaCategorySelectModel: HandyJSON {
    
   var id: String?
   var name: String?
   var c = [AreaCategoryFirstLevelSelectModel]()

   required init() {
   }

}

//区域选择model
class AreaCategoryFirstLevelSelectModel: HandyJSON {
    var id: String?
    var n: String?
    var list = [AreaCategorySecondLevelSelectModel]()

    required init() {
    }
}

//区域选择model
class AreaCategorySecondLevelSelectModel: HandyJSON {
    var id: String?
    var n: String?
    var isSelected: Bool? //地铁站，可以多选
    required init() {
    }
}

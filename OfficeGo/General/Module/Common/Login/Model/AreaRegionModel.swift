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
    
    //选中的id 判断是商圈1 还是地铁2
    var selectedCategoryID: String?
    
    var areaModelCount = AreaCategorySelectModel()
    
    var subwayModelCount = SubwayCategorySelectModel()
    
    required init() {
    }
    
}

//商圈模型
class AreaCategorySelectModel: HandyJSON {
    
    ///商圈
    var name: String?
    
    var id = "1"

    //用来标记 选中的商圈区
    var isFirstSelectedModel: AreaCategoryFirstLevelSelectModel?

    ///商圈数组
    var data = [AreaCategoryFirstLevelSelectModel]()
    
    required init() {
    }
    
}

//商圈选择model
class AreaCategoryFirstLevelSelectModel: HandyJSON {
    ///1号线
    var district: String?
    
    var districtID: String?

    ///商圈数组
    var list = [AreaCategorySecondLevelSelectModel]()
    
    required init() {
    }
}

//商圈选择model
class AreaCategorySecondLevelSelectModel: HandyJSON {
    var id: String?
    var area: String?
    var district: String?
    var districtNum: String?
    var isSelected: Bool? //商圈区，可以多选
    required init() {
    }
}


//地铁模型接口
class SubwayCategorySelectModel: HandyJSON {
    
    ///地铁或商圈
    var name: String?
    
    var id = "2"
    
    //用来标记 选中的商圈区
    var isFirstSelectedModel: SubwayCategoryFirstLevelSelectModel?
    
    ///地铁数组数组
    var data = [SubwayCategoryFirstLevelSelectModel]()
    
    required init() {
    }
    
}

//地铁选择model
class SubwayCategoryFirstLevelSelectModel: HandyJSON {
    ///1号线
    var line: String?
    
    var lid: String?
    
    ///地铁站路数组
    var list = [SubwayCategorySecondLevelSelectModel]()
    
    required init() {
    }
}

//地铁选择model
class SubwayCategorySecondLevelSelectModel: HandyJSON {
    var id: String?
    var stationName: String?
    var isSelected: Bool? //地铁站，可以多选
    required init() {
    }
}

//
//  HouseFeatureModel.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/4/29.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit
import HandyJSON

//条件选择model，用于搜索筛选
class HouseSelectModel: HandyJSON {
    var areaModel: AreaModel = AreaModel()
    var typeModel: HouseTypeSelectModel = HouseTypeSelectModel()
    var sortModel: HouseSortSelectModel = HouseSortSelectModel()
    var shaixuanModel: HouseShaixuanModel = HouseShaixuanModel()

    required init() {
    }
}
////区域选择model
//class AreaSelectModel: HandyJSON {
//    var id: String?
//    var title: String?
//    required init() {
//    }
//}
//类型选择model
class HouseTypeSelectModel: HandyJSON {
    var id: String?
    var title: String?
    var type: HouseTypeEnum?
    required init() {
    }
}
//排序选择model
class HouseSortSelectModel: HandyJSON {
    var id: String?
    var title: String?
    var type: HouseSortEnum = HouseSortEnum.defaultSortEnum
    required init() {
    }
}
//筛选
class HouseShaixuanModel: HandyJSON {
    /*
     联合办公
     租金：    范围 0 - 10万         默认 2000 - 20000
     工位：    范围 0 - 20          默认 2 -10
     写字楼
     租金：    范围 0- 10          默认 0 - 4
     工位：    范围 0 - 500           默认 0 - 100
     面积：    范围 0 - 1000          默认 0 - 200
     */
    
    //办公楼筛选范围
    var mianjiofficeBuildingExtentModel: SliderExtentModel = {
        var model = SliderExtentModel()
        model.minimumValue = 0
        model.maximumValue = 1000
        return model
    }()
    var zujinofficeBuildingExtentModel: SliderExtentModel = {
           var model = SliderExtentModel()
           model.minimumValue = 0
           model.maximumValue = 10
           return model
       }()
    var gongweiofficeBuildingExtentModel: SliderExtentModel = {
           var model = SliderExtentModel()
           model.minimumValue = 0
           model.maximumValue = 500
           return model
       }()
    //联合办公少选范围
//    var mianjijointOfficeExtentModel: SliderExtentModel = SliderExtentModel()
    var zujinjointOfficeExtentModel: SliderExtentModel = {
           var model = SliderExtentModel()
           model.minimumValue = 0
           model.maximumValue = 100000
           return model
       }()
    var gongweijointOfficeExtentModel: SliderExtentModel = {
           var model = SliderExtentModel()
           model.minimumValue = 0
           model.maximumValue = 20
           return model
       }()
    //装修 - 写字楼特有
    var documentTypeModelArr = [HouseFeatureModel]()
    
    // 房源特色数据
    var featureModelArr = [HouseFeatureModel]()
    
//    //房源特色 - 选择办公楼
//    var featureofficeBuildingSelectedArr = [HouseFeatureModel]()
//
//    //房源特色 - 选择联合办公
//    var featurejointOfficeSelectedArr = [HouseFeatureModel]()
    
    required init() {
    }
}
class SliderExtentModel: HandyJSON {
    var minimumValue: Double?
    var maximumValue: Double?
    var lowValue: Double?
    var highValue: Double?
    required init() {
    }
}

//装修类型
//筛选特色
class HouseFeatureModel: HandyJSON {
    var id: String?
    var title: String?
    
    //办公楼特色选择
    var isOfficeBuildingSelected: Bool = false
    
    //联合办公特色选择
    var isOfficejointOfficeSelected: Bool = false
    
    //装修类型选择
    var isDocumentSelected: Bool = false

    required init() {
    }
}

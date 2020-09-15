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

//类型选择model
class HouseTypeSelectModel: HandyJSON {
    var btype: Int? //类型,1:楼盘 写字楼,2:网点 共享办公
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
     共享办公
     租金：    范围 0 - 5万
     工位：    范围 0 - 30
     写字楼
     租金：    范围 0- 50
     工位：    范围 0 - 500
     面积：    范围 0 -2000
     
     如果选择的是0-不限，真正传值为0-999999noLimitMaxNum
     */
    
    var isShaixuan: Bool?
    
    //写字楼筛选范围
    var mianjiofficeBuildingExtentModel: SliderExtentModel = {
        var model = SliderExtentModel()
        model.minimumValue = 0
        model.maximumValue = 2000
        model.lowValue = 0
        model.highValue = 2000
        return model
    }()
    var zujinofficeBuildingExtentModel: SliderExtentModel = {
        var model = SliderExtentModel()
        model.minimumValue = 0
        model.maximumValue = 50
        model.lowValue = 0
        model.highValue = 50
        return model
    }()
    var gongweiofficeBuildingExtentModel: SliderExtentModel = {
        var model = SliderExtentModel()
        model.minimumValue = 0
        model.maximumValue = 500
        model.lowValue = 0
        model.highValue = 500
        return model
    }()
    //共享办公少选范围
    //    var mianjijointOfficeExtentModel: SliderExtentModel = SliderExtentModel()
    var zujinjointOfficeExtentModel: SliderExtentModel = {
        var model = SliderExtentModel()
        model.minimumValue = 0
        model.maximumValue = 50000
        model.lowValue = 0
        model.highValue = 50000
        return model
    }()
    var gongweijointOfficeExtentModel: SliderExtentModel = {
        var model = SliderExtentModel()
        model.minimumValue = 0
        model.maximumValue = 30
        model.lowValue = 0
        model.highValue = 30
        return model
    }()
    //装修 - 写字楼特有
    var documentTypeModelArr = [HouseFeatureModel]()
    
    // 房源特色数据
    var featureModelArr = [HouseFeatureModel]()
    
    //    //房源特色 - 选择写字楼
    //    var featureofficeBuildingSelectedArr = [HouseFeatureModel]()
    //
    //    //房源特色 - 选择共享办公
    //    var featurejointOfficeSelectedArr = [HouseFeatureModel]()
    
    required init() {
    }
}
class SliderExtentModel: HandyJSON {
    var minimumValue: Double?
    var maximumValue: Double?
    var lowValue: Double?
    var highValue: Double?
    var noLimitNum: Double = noLimitMaxNum
    required init() {
    }
}

//装修类型
//筛选特色
class HouseFeatureModel: DictionaryModel {
    
    //写字楼特色选择
    var isOfficeBuildingSelected: Bool = false
    
    //共享办公特色选择
    var isOfficejointOfficeSelected: Bool = false
    
    //装修类型选择
    var isDocumentSelected: Bool = false
    
    required init() {
    }
    
}

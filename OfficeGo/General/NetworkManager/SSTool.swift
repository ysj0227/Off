//
//  SSTool.swift
//  UUEnglish
//
//  Created by Aibo on 2018/3/27.
//  Copyright © 2018年 uuabc. All rights reserved.
//

import UIKit
import AVFoundation
import Lottie
import SnapKit

struct SensorsAnalyticsEvent {
    
    /**
     *访问注册/登录页面
     */
    static let visit_reg_login = "visit_reg_login"
    
    /**
     *点击获取验证码
     */
    static let click_code = "click_code"
    
    /**
     *点击验证码输入框
     */
    static let click_code_input = "click_code_input"
    
    /**
     *搜索-楼盘推荐页面点击搜索按钮
     */
    static let click_search_button_index = "click_search_button_index"
    
    /**
     *搜索-访问搜索页面
     */
    static let visit_search_page = "visit_search_page"
    
    /**
     *搜索-点击搜索结果（相关内容推荐
     */
    static let click_search_result = "click_search_result"
    
    /**
     *搜索-访问搜索结果页
     */
    static let visit_search_results_page = "visit_search_results_page"
    
    /**
     *搜索-点击搜索结果页某一条数据内容
     */
    static let click_search_results_page = "click_search_results_page"
    
    /**
     *访问楼盘网点列表
     */
    static let visit_building_network_list = "visit_building_network_list"
    
    /**
     *访问楼盘详情页
     */
    static let visit_building_data_page = "visit_building_data_page"
    
    
    /**
     *楼盘详情页阅读完成
     */
    static let visit_building_data_page_complete = "visit_building_data_page_complete"
    
    /**
     *点击收藏按钮
     */
    static let click_favorites_button = "click_favorites_button"
    
    /**
     *楼盘详情页筛选房源
     */
    static let building_data_page_screen = "building_data_page_screen"
    
    /**
     *点击楼盘详情页房源筛选按钮
     */
    static let click_building_data_page_screen_button = "click_building_data_page_screen_button"
    
    /**
     *访问房源详情页
     */
    static let visit_house_data_page = "visit_house_data_page"
    
    /**
     *IM中点击预约看房
     */
    static let click_im_order_see_house_button = "click_im_order_see_house_button"
    
    /**
     *预约看房时间选择
     */
    static let order_see_house_time = "order_see_house_time"
    
    /**
     *预约看房时间确定
     */
    static let confirm_see_house_time = "confirm_see_house_time"
    
    /**
     *点击添加更多房源按钮
     */
    static let click_add_more_house_button = "click_add_more_house_button"
    
    /**
     *点击选择房型确定按钮
     */
    static let click_confirm_selce_house_button = "click_confirm_selce_house_button"
    
    /**
     *预约看房申请提交
     */
    static let submit_booking_see_house = "submit_booking_see_house"
    
    /**
     *发起电话交换
     */
    static let click_phone_exchange_button = "click_phone_exchange_button"
    
    /**
     *电话交换状态确认
     */
    static let confirm_phone_exchange_state = "confirm_phone_exchange_state"
    
    /**
     *发起微信交换
     */
    static let click_wechat_exchange_button = "click_wechat_exchange_button"
    
    /**
     *微信交换状态确认
     */
    static let confirm_wechat_exchange_state = "confirm_wechat_exchange_state"
    
    /**
     *房源列表页面-点击新增房源
     */
    static let building_list_page_add_house = "building_list_page_add_house"
    
    /**
     *网点-新增网点房源
     */
    static let network_add_network_house = "network_add_network_house"
    
    
    /**
     *租户切换成房东
     */
    static let tenant_to_owner = "tenant_to_owner"
    
    /**
     *房东切换成租户
     */
    static let owne_to_tenant = "owne_to_tenant"
    
    /**
     *楼盘卡片展示
     */
    static let cardShow = "cardShow"
    
    /**
     *点击楼盘卡片
     */
    static let clickShow = "clickShow"
    
}

@objcMembers class SensorsAnalyticsFunc: NSObject {
    ///用户登录
    class func SensorsLogin() {
        if let userid = UserTool.shared.user_uid {
            
            //登录
            SensorsAnalyticsSDK.sharedInstance()?.login("\(userid)")
            
        }
        ///设置基本信息
        SensorsAnalyticsSDK.sharedInstance()?.registerSuperProperties(["platform_type": "iOS", "app_name": Device.appName ?? "OfficeGo"])
        
        ///设置动态属性
        SensorsAnalyticsSDK.sharedInstance()?.registerDynamicSuperProperties({ () -> [String : Any] in
            return ["is_login" : UserTool.shared.isLogin()]
        })

    }
    
    class func SensorsTrackInstallation() {
        
    }
    
    ///追踪用户行为事件，添加自定义属性
    class func SensorsTrackEvent(event: String, params: [AnyHashable: Any]?) {
        SensorsAnalyticsSDK.sharedInstance()?.track(event, withProperties: params)
    }
    
    /**
     *访问注册/登录页面
     *$预置属性
     */
    class func visit_reg_login() {
        SensorsTrackEvent(event: SensorsAnalyticsEvent.visit_reg_login, params: nil)
    }
    
    /**
     *点击获取验证码
     *$预置属性    STRING
     *uid    用户id    NUMBER  没有就不传
     */
    class func click_code() {
        if let uid = UserTool.shared.user_uid {
            SensorsTrackEvent(event: SensorsAnalyticsEvent.click_code, params: ["uid": uid])
        }else {
            SensorsTrackEvent(event: SensorsAnalyticsEvent.click_code, params: nil)
        }
    }
    
    /**
     *点击验证码输入框
     *$预置属性    STRING
     *uid    用户id    NUMBER  没有就不传
     */
    class func click_code_input() {
        if let uid = UserTool.shared.user_uid {
            SensorsTrackEvent(event: SensorsAnalyticsEvent.click_code_input, params: ["uid": uid])
        }else {
            SensorsTrackEvent(event: SensorsAnalyticsEvent.click_code_input, params: nil)
        }
    }
    /**
     *搜索-楼盘推荐页面点击搜索按钮
     *$预置属性    STRING        WEB
     *uid    用户id    NUMBER  没有就不传
     */
    class func click_search_button_index() {
        if let uid = UserTool.shared.user_uid {
            SensorsTrackEvent(event: SensorsAnalyticsEvent.click_search_button_index, params: ["uid": uid])
        }else {
            SensorsTrackEvent(event: SensorsAnalyticsEvent.click_search_button_index, params: nil)
        }
    }
    
    /**
     *搜索-访问搜索页面
     *$预置属性    STRING        WEB
     *uid    用户id    NUMBER  没有就不传
     */
    class func visit_search_page() {
        if let uid = UserTool.shared.user_uid {
            SensorsTrackEvent(event: SensorsAnalyticsEvent.visit_search_page, params: ["uid": uid])
        }else {
            SensorsTrackEvent(event: SensorsAnalyticsEvent.visit_search_page, params: nil)
        }
    }
    
    /**
     *搜索-访问搜索结果页 visit_search_results_page
     *$预置属性    STRING        WEB
     *searchType    点击搜索词类型    STRING    推荐词/历史词    WEB
     *userSearchContent    用户搜索内容    STRING    用户填写在搜索框内容    WEB
     */
    class func visit_search_results_page(searchType: String, userSearchContent: String) {
        SensorsTrackEvent(event: SensorsAnalyticsEvent.visit_search_results_page, params: ["searchType": searchType, "userSearchContent":userSearchContent])
    }
    
    /**
     *click_search_results_page
     *搜索-点击搜索结果页某一条数据内容
     *$预置属性    STRING        WEB
     *userSearchContent    用户搜索内容    STRING        WEB
     *clickLocal    用户点击位置    STRING    用户点击了搜索结果的第几条    WEB
     *buildingId    楼盘ID    STRING        WEB
     *buildOrHouse    页面类型    STRING    网点、楼盘    WEB
     */
    class func click_search_results_page(userSearchContent: String, clickLocal: String, buildingId: String, buildOrHouse: String) {
        SensorsTrackEvent(event: SensorsAnalyticsEvent.click_search_results_page, params: ["userSearchContent": userSearchContent, "clickLocal": clickLocal, "buildingId": buildingId, "buildOrHouse": buildOrHouse])
    }
    
    /**
     *visit_building_network_list
     *访问楼盘网点列表
     *$预置属性    STRING        WEB
     *uCity    地区    STRING    当前访问地区：全国、上海、北京    WEB
     *areaType    区域类型    STRING    "对应不同筛选类型
     *无对应筛选则为空"    WEB
     *areaContent    区域筛选内容    STRING        WEB
     *officeType    办公场地选择类型    STRING        WEB
     *oderType    排序选择类型    STRING        WEB
     *area    面积    逗号拼接字符串        WEB
     *dayPrice    租金    逗号拼接字符串        WEB
     *simple    工位    逗号拼接字符串        WEB
     *decoration    装修类型    STRING        WEB
     *tags    房源特色    STRING        WEB   无数据
     *isVr    是否只看VR    BOOL        WEB   无数据
     *isSelect    是否有筛选    BOOL        WEB
     */
    class func visit_building_network_list(selectModel: HouseSelectModel) {
        
        var params = [AnyHashable: Any]()

        params["uCity"] = "上海"
        
        var isSelect: Bool = false
        
        //地址
        var areaType: String?
                
        //商圈地铁 区域筛选内容
        var areaContent: String?
        
        //商圈1 还是地铁2
        if selectModel.areaModel.selectedCategoryID == "1" {
            
            if let firstLevelModel = selectModel.areaModel.areaModelCount.isFirstSelectedModel {
                
                isSelect = true
                
                areaType = "商圈"
                
                ///区域
                areaContent = firstLevelModel.district
                
                var businessArr: [String] = []
                
                for model in firstLevelModel.list {
                    if model.isSelected ?? false  {
                        businessArr.append(model.area ?? "")
                    }
                }
                
                //如果下面的商圈有选择 - 商圈地铁站拼接字符串
                if businessArr.count > 0 {
                    areaContent = businessArr.joined(separator: ",")
                }
            }
            
        }else if selectModel.areaModel.selectedCategoryID == "2" {
            
            if let firstLevelModel = selectModel.areaModel.subwayModelCount.isFirstSelectedModel {
                
                isSelect = true

                areaType = "地铁"

                //几号线 -
                areaContent = firstLevelModel.line

                //区域id
                               
                var businessArr: [String] = []
                
                for model in firstLevelModel.list {
                    if model.isSelected ?? false  {
                        businessArr.append(model.stationName ?? "")
                    }
                }
                
                //如果下面的地铁有选择 - 商圈地铁站拼接字符串
                if businessArr.count > 0 {
                    areaContent = businessArr.joined(separator: ",")
                }
            }
        }
        
        if areaType?.count ?? 0 > 0 {
            params["areaType"] = areaType
        }
        
        if areaContent?.count ?? 0 > 0 {
            params["areaContent"] = areaContent
        }
        
        //办公场地选择类型    STRING
        //类型,1:楼盘 写字楼,2:网点 联合办公 0全部
        let officeType = selectModel.typeModel.type?.rawValue
        params["officeType"] = officeType
       
        //oderType    排序选择类型    STRING        WEB
        let oderType = selectModel.sortModel.type.rawValue
        params["oderType"] = oderType
        
        //筛选 - 只有点击过筛选按钮 才把筛选的参数带过去
        if selectModel.shaixuanModel.isShaixuan == true {
            
            isSelect = true

            //工位 - 只有联合办公有
            //工位    逗号拼接字符串        WEB
            var simple: String?
            
            //租金 - 两者都有
            //租金    逗号拼接字符串        WEB
            var dayPrice: String?
            
            //联合办公
            if selectModel.typeModel.type == .jointOfficeEnum {
                 
                if selectModel.shaixuanModel.gongweijointOfficeExtentModel.highValue == selectModel.shaixuanModel.gongweijointOfficeExtentModel.maximumValue {
                    simple = String(format: "%.0f", selectModel.shaixuanModel.gongweijointOfficeExtentModel.lowValue ?? 0) + "," + String(format: "%.0f", selectModel.shaixuanModel.gongweijointOfficeExtentModel.noLimitNum)
                }else {
                    simple = String(format: "%.0f", selectModel.shaixuanModel.gongweijointOfficeExtentModel.lowValue ?? 0) + "," + String(format: "%.0f", selectModel.shaixuanModel.gongweijointOfficeExtentModel.highValue ?? 0)
                }
                
                if selectModel.shaixuanModel.zujinjointOfficeExtentModel.highValue == selectModel.shaixuanModel.zujinjointOfficeExtentModel.maximumValue {
                    dayPrice = String(format: "%.0f", selectModel.shaixuanModel.zujinjointOfficeExtentModel.lowValue ?? 0) + "," + String(format: "%.0f", selectModel.shaixuanModel.zujinjointOfficeExtentModel.noLimitNum)
                }else {
                    dayPrice = String(format: "%.0f", selectModel.shaixuanModel.zujinjointOfficeExtentModel.lowValue ?? 0) + "," + String(format: "%.0f", selectModel.shaixuanModel.zujinjointOfficeExtentModel.highValue ?? 0)
                }
                
            }else if selectModel.typeModel.type == .officeBuildingEnum {
                
                if selectModel.shaixuanModel.zujinofficeBuildingExtentModel.highValue == selectModel.shaixuanModel.zujinofficeBuildingExtentModel.maximumValue {
                    dayPrice = String(format: "%.0f", selectModel.shaixuanModel.zujinofficeBuildingExtentModel.lowValue ?? 0) + "," + String(format: "%.0f", selectModel.shaixuanModel.zujinofficeBuildingExtentModel.noLimitNum)
                }else {
                    dayPrice = String(format: "%.0f", selectModel.shaixuanModel.zujinofficeBuildingExtentModel.lowValue ?? 0) + "," + String(format: "%.0f", selectModel.shaixuanModel.zujinofficeBuildingExtentModel.highValue ?? 0)
                }
                
                //办公室 - 面积传值
                //面积    逗号拼接字符串        WEB
                var area: String?
                    
                if selectModel.shaixuanModel.mianjiofficeBuildingExtentModel.highValue == selectModel.shaixuanModel.mianjiofficeBuildingExtentModel.maximumValue {
                    area = String(format: "%.0f", selectModel.shaixuanModel.mianjiofficeBuildingExtentModel.lowValue ?? 0) + "," + String(format: "%.0f", selectModel.shaixuanModel.mianjiofficeBuildingExtentModel.noLimitNum)
                }else {
                    area = String(format: "%.0f", selectModel.shaixuanModel.mianjiofficeBuildingExtentModel.lowValue ?? 0) + "," + String(format: "%.0f", selectModel.shaixuanModel.mianjiofficeBuildingExtentModel.highValue ?? 0)
                }
                
                params["area"] = area as AnyObject?
                
                //办公室 - 装修类型传值
                var documentArr: [String] = []
                for model in selectModel.shaixuanModel.documentTypeModelArr {
                    if model.isDocumentSelected {
                        documentArr.append(model.dictCname ?? "")
                    }
                }
                
                //装修类型    STRING        WEB
                let decoration: String = documentArr.joined(separator: ",")
                if decoration.count > 0 {
                    params["decoration"] = decoration as AnyObject?
                }

            }
            params["dayPrice"] = dayPrice as AnyObject?
            
            params["simple"] = simple as AnyObject?
        }
        
        params["isSelect"] = isSelect as AnyObject?
        
        SensorsTrackEvent(event: SensorsAnalyticsEvent.visit_building_network_list, params: params)

    }
    
    /**
     *visit_building_data_page
     *访问楼盘详情页
     *$预置属性    STRING        WEB
     *buildingId    楼盘ID    STRING        WEB
     *buildLocation    楼盘列表位置    NUMBER    楼盘在楼盘列表显示位置，点击在列表中第几条    WEB
     */
    class func visit_building_data_page(buildingId: String, buildLocation: Int) {
        SensorsTrackEvent(event: SensorsAnalyticsEvent.visit_building_data_page, params: ["buildingId": buildingId, "buildLocation": buildLocation])
    }
    
    /**
     *楼盘详情页阅读完成
     *$预置属性    STRING        WEB
     *buildingId    楼盘ID    STRING        WEB
     *isRead    是否阅读完成    BOOL        WEB
     */
    class func visit_building_data_page_complete(buildingId: String, isRead: Bool) {
        SensorsTrackEvent(event: SensorsAnalyticsEvent.visit_building_data_page_complete, params: ["buildingId": buildingId, "isRead": isRead])
    }
    
    /**
     *点击收藏按钮
     *$预置属性    STRING        WEB
     *buildingId    楼盘ID    STRING    若不是楼盘回空值    WEB
     *isCollect    是否收藏成功    BOOL    记录用户是否收藏状态，还是取消了收藏状态    WEB
     */
    class func click_favorites_button(buildingId: String, isCollect: Bool) {
        SensorsTrackEvent(event: SensorsAnalyticsEvent.click_favorites_button, params: ["buildingId": buildingId, "isCollect": isCollect])
    }
    
    /**
     *楼盘详情页筛选房源
     *点击楼盘面积或工位按钮
     *$预置属性    STRING        WEB
     *buildingId    楼盘ID    STRING        WEB
     *houseCnt    房源套数    NUMBER        WEB
     */
    class func building_data_page_screen(buildingId: String, houseCnt: Int) {
        SensorsTrackEvent(event: SensorsAnalyticsEvent.building_data_page_screen, params: ["buildingId": buildingId, "houseCnt": houseCnt])
    }
    
    /**
     *buildingId    楼盘ID
     *area    面积
     *simple    工位
     *点击楼盘详情页房源筛选按钮
     */
    class func click_building_data_page_screen_button(buildingId: String, area: String, simple: String) {
        if area == "" {
            SensorsTrackEvent(event: SensorsAnalyticsEvent.click_building_data_page_screen_button, params: ["buildingId": buildingId, "simple": simple])
        }else {
            SensorsTrackEvent(event: SensorsAnalyticsEvent.click_building_data_page_screen_button, params: ["buildingId": buildingId, "area": area])

        }
    }
    
    /**
     *访问房源详情页        $预置属性    STRING        WEB
     *houseId    房源ID    STRING        WEB
     */
    class func visit_house_data_page(houseId: String) {
        SensorsTrackEvent(event: SensorsAnalyticsEvent.visit_house_data_page, params: ["houseId": houseId])
    }
    
    
    /**
     *IM中点击预约看房
     *$预置属性    STRING        WEB
     *buildingId    楼盘ID    STRING        WEB
     *houseId    房源ID    STRING    如无房源返回空值（对应从楼盘进入聊天）    WEB
     *chatedId    房东ID    STRING        WEB
     *chatedName    房东名称    STRING        WEB
     *timestamp    行程预约ID    STRING    NUMBER    WEB
     */
    class func click_im_order_see_house_button(buildingId: String, houseId: String, chatedId: String, chatedName: String, timestamp: String) {
        var params = [AnyHashable: Any]()
        params["timestamp"] = timestamp
        if buildingId.isBlankString != true && buildingId != "0" {
            params["buildingId"] = buildingId
        }
        if houseId.isBlankString != true && houseId != "0" {
            params["houseId"] = houseId
        }
        if chatedId.isBlankString != true && chatedId != "0" {
            params["chatedId"] = chatedId
        }
        if chatedName.isBlankString != true && chatedName != "0" {
            params["chatedName"] = chatedName
        }
        SensorsTrackEvent(event: SensorsAnalyticsEvent.click_im_order_see_house_button, params: params)
    }
    
    /**
     *点击看房时间选择按钮
     *$预置属性    STRING        WEB
     *buildingId    楼盘ID    STRING        WEB
     *timestamp    行程预约ID    STRING        WEB
     *buildOrHouse    页面类型    STRING    楼盘、网点、房源    WEB
     */
    class func order_see_house_time(buildingId: String, buildOrHouse: String, timestamp: String) {
        SensorsTrackEvent(event: SensorsAnalyticsEvent.order_see_house_time, params: ["buildingId": buildingId, "buildOrHouse": buildOrHouse, "timestamp": timestamp])
    }
    
    /**
     *预约看房时间确定
     *$预置属性    STRING        WEB
     *buildOrHouse    页面类型    STRING    楼盘、网点、房源    WEB
     *buildingId    楼盘ID    STRING        WEB
     *timestamp    行程预约ID    STRING    NUMBER    WEB
     *seeTime    预约时间    DATETIME        WEB
     */
    class func confirm_see_house_time(buildingId: String, buildOrHouse: String, timestamp: String, seeTime: String) {
        SensorsTrackEvent(event: SensorsAnalyticsEvent.confirm_see_house_time, params: ["buildingId": buildingId, "buildOrHouse": buildOrHouse, "timestamp": timestamp, "seeTime": seeTime])
    }
    
    /**
     *预约看房申请提交
     *submit_booking_see_house
     *$预置属性    STRING        WEB
     *buildOrHouse    页面类型    STRING        WEB
     *seeTime    预约时间    DATETIME        WEB
     *buildingId    楼盘ID    STRING        WEB
     *timestamp    行程预约ID    STRING        WEB
     *status    行程状态    STRING    取值只能是预约等待房东审核    WEB
     *chatedId    房东ID    STRING        WEB
     *chatedName    房东名称    STRING        WEB
     *createTime    时间    DATETIME    点击申请按钮的当前日期，2020-09-03    WEB
     */
    class func submit_booking_see_house(buildingId: String, buildOrHouse: String, timestamp: String, seeTime: String, chatedId: String, chatedName: String, createTime: String) {
        SensorsTrackEvent(event: SensorsAnalyticsEvent.submit_booking_see_house, params: ["buildingId": buildingId, "buildOrHouse": buildOrHouse, "timestamp": timestamp, "seeTime": seeTime, "status": "预约等待房东审核", "chatedId": chatedId, "chatedName": chatedName, "createTime": createTime])
    }
    
    /**
     *发起电话交换
     *click_phone_exchange_button
     *$预置属性    STRING        WEB
     *buildingId    楼盘ID    STRING        WEB
     *houseId    房源ID    STRING        WEB
     *rid    发起方身份    STRING    租户、房东    WEB
     *timestamp    行程预约ID    STRING        WEB
     *statusPhone    电话交换状态    STRING    申请中    WEB
     *createTime    时间    DATETIME    发起交换时间    WEB
     */
    class func click_phone_exchange_button(buildingId: String, houseId: String, rid: Int, timestamp: String, createTime: String) {
        var params = [AnyHashable: Any]()
        params["timestamp"] = timestamp
        params["createTime"] = createTime
        params["statusPhone"] = "申请中"

        if buildingId.isBlankString != true && buildingId != "0" {
            params["buildingId"] = buildingId
        }
        if houseId.isBlankString != true && houseId != "0" {
            params["houseId"] = houseId
        }
        if rid == 0 {
            params["rid"] = "租户"
        }else if rid == 1 {
            params["rid"] = "房东"
        }
        SensorsTrackEvent(event: SensorsAnalyticsEvent.click_phone_exchange_button, params: params)
    }
    
    /**
     *电话交换状态确认
     *confirm_phone_exchange_state
     *$预置属性    STRING        WEB
     *buildingId    楼盘ID    STRING        WEB
     *houseId    房源ID    STRING        WEB
     *buildOrHouse    页面类型    STRING        WEB
     *timestamp    行程预约ID    STRING
     *rid    发起方身份    STRING    租户、房东    WEB
     *statusPhone    电话交换状态    STRING    申请中、通过、拒绝    WEB
     *isSuccess    是否成功    BOOL    是否交换电话成功    WEB
     */
    class func confirm_phone_exchange_state(buildingId: String, houseId: String, buildOrHouse: String, timestamp: Int64, rid: String, isSuccess: Bool) {
        
        // timestamp为毫秒 转换为时间字符串
        
        var params = [AnyHashable: Any]()
        if isSuccess == true {
            params["statusPhone"] = "通过"
            params["isSuccess"] = true
        }else {
            params["statusPhone"] = "拒绝"
            params["isSuccess"] = false
        }
        
        params["timestamp"] = "\(timestamp / 1000)"

        if buildOrHouse.isBlankString != true {
            params["buildOrHouse"] = buildOrHouse
        }
        
        if buildingId.isBlankString != true && buildingId != "0" {
            params["buildingId"] = buildingId
        }
        if houseId.isBlankString != true && houseId != "0" {
            params["houseId"] = houseId
        }
        if rid.isBlankString != true && rid != "0" {
            if rid.count > 0 {
                let type = rid.suffix(1)
                if type == "0" {
                    params["rid"] = "租户"
                }else if type == "1" {
                    params["rid"] = "房东"
                }
            }
        }
        SensorsTrackEvent(event: SensorsAnalyticsEvent.confirm_phone_exchange_state, params: params)
    }
    
    /**
     *发起微信交换
     *click_wechat_exchange_button
     *$预置属性    STRING        WEB
     *buildingId    楼盘ID    STRING        WEB
     *houseId    房源ID    STRING        WEB
     *rid    发起方身份    STRING    租户、房东    WEB
     *timestamp    行程预约ID    STRING    微信交换事件ID    WEB
     *statusWechat    微信交换状态    STRING        WEB
     *createTime    时间    DATETIME    发起交换时间    WEB
     */
    class func click_wechat_exchange_button(buildingId: String, houseId: String, rid: Int, timestamp: String, createTime: String) {
        var params = [AnyHashable: Any]()
        params["timestamp"] = timestamp
        params["createTime"] = createTime
        params["statusWechat"] = "申请中"

        if buildingId.isBlankString != true && buildingId != "0" {
            params["buildingId"] = buildingId
        }
        if houseId.isBlankString != true && houseId != "0" {
            params["houseId"] = houseId
        }
        if rid == 0 {
            params["rid"] = "租户"
        }else if rid == 1 {
            params["rid"] = "房东"
        }
        SensorsTrackEvent(event: SensorsAnalyticsEvent.click_wechat_exchange_button, params: params)
    }
    
    /**
     *微信交换状态确认
     *confirm_wechat_exchange_state
     *$预置属性    STRING        WEB
     *buildingId    楼盘ID    STRING        WEB
     *houseId    房源ID    STRING        WEB
     *buildOrHouse    页面类型    STRING        WEB
     *timestamp    行程预约ID    STRING    微信交换事件ID    WEB
     *rid    发起方身份    STRING    租户、房东    WEB
     *statusWechat    微信交换状态    STRING    申请中、通过、拒绝    WEB
     *isSuccess    是否成功    BOOL    是否交换微信成功    WEB
     */
    class func confirm_wechat_exchange_state(buildingId: String, houseId: String, buildOrHouse: String, timestamp: Int64, rid: String, isSuccess: Bool) {
        
        // timestamp为毫秒 转换为时间字符串
        
        var params = [AnyHashable: Any]()
        if isSuccess == true {
            params["statusWechat"] = "通过"
            params["isSuccess"] = true
        }else {
            params["statusWechat"] = "拒绝"
            params["isSuccess"] = false
        }
        
        params["timestamp"] = "\(timestamp / 1000)"
        
        if buildOrHouse.isBlankString != true {
            params["buildOrHouse"] = buildOrHouse
        }
        
        if buildingId.isBlankString != true && buildingId != "0" {
            params["buildingId"] = buildingId
        }
        if houseId.isBlankString != true && houseId != "0" {
            params["houseId"] = houseId
        }
        if rid.isBlankString != true && rid != "0" {
            if rid.count > 0 {
                let type = rid.suffix(1)
                if type == "0" {
                    params["rid"] = "租户"
                }else if type == "1" {
                    params["rid"] = "房东"
                }
            }
        }
        SensorsTrackEvent(event: SensorsAnalyticsEvent.confirm_wechat_exchange_state, params: params)
    }
    
    /**
     *租户切换成房东
     *$预置属性    STRING
     */
    class func tenant_to_owner() {
        SensorsTrackEvent(event: SensorsAnalyticsEvent.tenant_to_owner, params: nil)
    }
    
    /**
     *房东切换成租户
     *$预置属性    STRING
     */
    class func owne_to_tenant() {
        SensorsTrackEvent(event: SensorsAnalyticsEvent.owne_to_tenant, params: nil)
    }
    
    /**
     *点击楼盘卡片
     *$预置属性    STRING
     *buildingId    楼盘ID    STRING
     *buildLocation    楼盘列表位置    NUMBER
     *isVr    是否VR    BOOL
     */
    class func clickShow(buildingId: String, buildLocation: Int, isVr: Bool) {
        SensorsTrackEvent(event: SensorsAnalyticsEvent.clickShow, params: ["buildingId": buildingId, "buildLocation": buildLocation, "isVr": isVr])
    }
    
}

@objcMembers class SSTool: NSObject {
    
    ///检查推送权限
    func checkPushNotification(checkNotificationStatus isEnable : ((Bool)->())? = nil){

        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().getNotificationSettings(){ (setttings) in

                switch setttings.authorizationStatus{
                case .authorized:

                    print("enabled notification setting")
                    isEnable?(true)
                case .denied:

                    print("setting has been disabled")
                    isEnable?(false)
                case .notDetermined:

                    print("something vital went wrong here")
                    isEnable?(false)
                case .provisional:
                    print("provisional")
                @unknown default:
                    print("default")
                }
            }
        } else {

            let isNotificationEnabled = UIApplication.shared.currentUserNotificationSettings?.types.contains(UIUserNotificationType.alert)
            if isNotificationEnabled == true{

                print("enabled notification setting")
                isEnable?(true)

            }else{

                print("setting has been disabled")
                isEnable?(false)
            }
        }
    }
    
    ///提示
    static func callPhoneTelpro(phone : String){
        let  phoneUrlStr = "telprompt://" + phone
        
        if let url = URL(string: phoneUrlStr) {
            if UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler:nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }

    ///验证邮箱
    class func validateEmail(email: String) -> Bool {
        if email.count == 0 {
            return false
        }
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest:NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
    
    ///验证手机号
    class func isPhoneNumber(phoneNumber:String) -> Bool {
        if phoneNumber.count == 0 {
            return false
        }
        let mobile = "^1([358][0-9]|4[579]|66|7[0135678]|9[89])[0-9]{8}$"
        let regexMobile = NSPredicate(format: "SELF MATCHES %@",mobile)
        if regexMobile.evaluate(with: phoneNumber) == true {
            return true
        }else
        {
            return false
        }
    }
    
    ///密码正则  6-8位字母和数字组合
    class func isPasswordRuler(password:String) -> Bool {
        let passwordRule = "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,8}$"
        let regexPassword = NSPredicate(format: "SELF MATCHES %@",passwordRule)
        if regexPassword.evaluate(with: password) == true {
            return true
        }else
        {
            return false
        }
    }
    
    ///验证是否是数字和字符串
    class func isPureStrOrNumNumber(text:String) -> Bool{
        let passwordRule = "^[a-zA-Z0-9]+$"
        let regexPassword = NSPredicate(format: "SELF MATCHES %@",passwordRule)
        if regexPassword.evaluate(with: text) == true {
            return true
        }else
        {
            return false
        }
    }
    func getStringByRangeIntValue(Str : NSString,location : Int, length : Int) -> Int{
        
        let a = Str.substring(with: NSRange(location: location, length: length))
        
        let intValue = (a as NSString).integerValue
        
        return intValue
    }
    static func dispatchBlock(block: @escaping VoidClosure,complete:VoidClosure?){
        DispatchQueue.global(qos: .userInitiated).async {
            autoreleasepool(invoking:{
                block()
                if let temp = complete {
                    temp()
                }
            })
        }
    }

    //时间戳转成字符串 - 10位
    static func timeIntervalChangeToTimeStr(timeInterval:TimeInterval, dateFormat:String?) -> String {
        let date:NSDate = NSDate.init(timeIntervalSince1970: timeInterval)
        let formatter = DateFormatter.init()
        if dateFormat == nil {
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        }else{
            formatter.dateFormat = dateFormat
        }
        return formatter.string(from: date as Date)
    }
    ///时间戳转成字符串 - MM月dd日
   static func timeIntervalChangeToYYMMHHMMTimeStr(timeInterval:TimeInterval) -> String {
       let date:NSDate = NSDate.init(timeIntervalSince1970: timeInterval)
       let formatter = DateFormatter.init()
       formatter.dateFormat = "MM月dd日HH:mm"
       return formatter.string(from: date as Date)
   }
    ///时间戳转成字符串 - MM月dd日
    static func timeIntervalChangeToYYMMTimeStr(timeInterval:TimeInterval) -> String {
        let date:NSDate = NSDate.init(timeIntervalSince1970: timeInterval)
        let formatter = DateFormatter.init()
        formatter.dateFormat = "MM月dd日"
        return formatter.string(from: date as Date)
    }
    ///时间戳转成字符串 - mm:ss
    static func timeIntervalChangeToHHMMTimeStr(timeInterval:TimeInterval) -> String {
        let date:NSDate = NSDate.init(timeIntervalSince1970: timeInterval)
        let formatter = DateFormatter.init()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date as Date)
    }
    
    static func invokeInDebug(closure: VoidClosure) {
        #if DEBUG
        closure()
        #endif
    }
    
     //字符串转时间戳
    static func timeStrChangeTotimeInterval(timeStr: String?, dateFormat:String?) -> String {
        if timeStr?.count ?? 0 > 0 {
            return ""
        }
        let format = DateFormatter.init()
        format.dateStyle = .medium
        format.timeStyle = .short
        if dateFormat == nil {
            format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        }else{
            format.dateFormat = dateFormat
        }
        let date = format.date(from: timeStr!)
        return String(date!.timeIntervalSince1970)
    }
    
    //字符串转时间戳
    static func timeStrChangeToDateYYYYMMdd(timeStr: String?) -> Date {
        
        let format = DateFormatter.init()
        format.dateStyle = .medium
        format.timeStyle = .short
        format.dateFormat = "yyyy-MM-dd"

        let date = format.date(from: timeStr!) ?? Date()
        return date
    }
    
    static func invokeInMainThread(closure: @escaping VoidClosure) {
        DispatchQueue.main.async {
            closure()
        }
    }
    
    static func invokeInGlobalThread(closure: @escaping VoidClosure) {
        DispatchQueue.global(qos: .default).async {
            closure()
        }
    }
    
    static func delay(time: TimeInterval, Block block: @escaping (() -> Void)){
        DispatchQueue.main.asyncAfter(deadline: .now() + time) {
            block()
        }
    }
    
    static func dateFrom(seconds:Int) -> NSDate {
        
        let currDate  = NSDate.init(timeIntervalSince1970: TimeInterval.init(seconds))
        let timeZone = NSTimeZone.system
        let interval = timeZone.secondsFromGMT(for: currDate as Date)
        let date = currDate.addingTimeInterval(TimeInterval.init(interval))
        return date
    }
    
    static func secondsDifferenceToCurrentDate(seconds:Int) -> TimeInterval {
        let date = dateFrom(seconds: seconds)
        let offset = date.timeIntervalSince1970 - getCurrentDate(interval: 0).timeIntervalSince1970
        return offset
    }
    
    static func differenceDates(startDate:NSDate,endDate:NSDate) -> TimeInterval{
        let offset = startDate.timeIntervalSince1970 - endDate.timeIntervalSince1970
        return offset
    }
    
    static func timeFormatted(totalSeconds:TimeInterval) -> String{
        let seconds = totalSeconds.truncatingRemainder(dividingBy: 60)
        let minutes = (totalSeconds / 60).truncatingRemainder(dividingBy: 60)
        let hours = totalSeconds / 3600
        
        return "\(Int.init(hours) == 0 ? "" : "\(Int.init(hours))时")\(Int.init(minutes) == 0 ? "" : "\(Int.init(minutes))分")\(Int.init(seconds) == 0 ? "" : "\(Int.init(seconds))秒")"
    }
    
    static func timeFormatted1(totalSeconds:TimeInterval) -> String{
        let seconds = totalSeconds.truncatingRemainder(dividingBy: 60)
        let minutes = (totalSeconds / 60).truncatingRemainder(dividingBy: 60)
        let hours = totalSeconds / 3600
        return "\(Int.init(hours) == 0 ? "" : "\(Int.init(hours))时")\(Int.init(minutes))分\(Int.init(seconds))秒"
    }
    
    static func timeFormattedHour(totalSeconds:TimeInterval) -> String{
        let seconds = totalSeconds.truncatingRemainder(dividingBy: 60)
        let minutes = (totalSeconds / 60).truncatingRemainder(dividingBy: 60)
        let hours = totalSeconds / 3600
        let remainHours = Int(hours) % 24
        //当小时数超过24小时后，显示减去整天之后的小时数
        if remainHours > 0 {
            return "\(Int.init(hours) == 0 ? "" : "\(Int.init(remainHours)):")\(Int.init(minutes)):\(Int.init(seconds))"
        }else {
            return "\(Int.init(hours) == 0 ? "" : "\(Int.init(hours)):")\(Int.init(minutes)):\(Int.init(seconds))"
        }
        
    }
    
    static func getCurrentDate(interval:TimeInterval) -> NSDate {
        
        let currDate  = NSDate.init()
        let timeZone = NSTimeZone.system
        let zoneInter = timeZone.secondsFromGMT(for: currDate as Date)
        let date = currDate.addingTimeInterval(interval + TimeInterval.init(zoneInter))
        return date
    }
    
    static func getMinutesAndHours(seconds:Int) ->String{
        let date = dateFrom(seconds: seconds)
        let formatter = DateFormatter.init()
        formatter.dateFormat = "HH:mm"
        let str = formatter.string(from: date as Date)
        return str
    }
    
    static func getMinutesAndHours()->String{
        let date = NSDate()
        let formatter = DateFormatter.init()
        formatter.dateFormat = "HH:mm"
        let str = formatter.string(from: date as Date as Date)
        return str
    }
    static func saveDataWithUserDefault(key:String,value:AnyObject){
        let userDefault = UserDefaults.standard
        userDefault.set(value, forKey: key)
        userDefault.synchronize()
    }
    
    static func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    
    static func removeUserDefault(key:String){
        let userDefault = UserDefaults.standard
        userDefault.removeObject(forKey: key)
        userDefault.synchronize()
    }

    // 相机权限
    static func isRightCamera() -> Bool {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        return authStatus != .restricted && authStatus != .denied
    }
    
    //  MARK:   --获取版本
    static func getVersion() -> String {
        
        let infoDictionary = Bundle.main.infoDictionary
        let appVersion = infoDictionary!["CFBundleShortVersionString"] as! String
        let appBuild = infoDictionary!["CFBundleVersion"] as! String
        var version = ""
        
        #if DEBUG
        version = appVersion + "." + appBuild
        #else
        version = appVersion
        #endif
        
        return appVersion
    }
    
    //  MARK:   --缓存占用
    static func fileSizeOfCache()-> Int {
        
        // 取出cache文件夹目录 缓存文件都在这个目录下
        let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, .userDomainMask, true).first
        // 取出文件夹下所有文件数组
        let fileArr = FileManager.default.subpaths(atPath: cachePath!)
        
        //快速枚举出所有文件名 计算文件大小
        var size = 0
        for file in fileArr! {
            
            // 把文件名拼接到路径中
            let path = cachePath?.appendingFormat("/\(file)")
            // 取出文件属性
            let floder = try! FileManager.default.attributesOfItem(atPath: path!)
            
            if FileManager.default.fileExists(atPath: path!) {
                // 用元组取出文件大小属性
                for (abc, bcd) in floder {
                    // 累加文件大小
                    if abc == FileAttributeKey.size {
                        size += (bcd as AnyObject).integerValue
                    }
                }
            }
        }
        
        let mm = size / 1024 / 1024
        
        return mm
    }
    
    //MARK: - 清除本地缓存
    static func  clearCache()  {
        let basePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, .userDomainMask, true).first
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: basePath!)
        {
            let childrenPath = fileManager.subpaths(atPath: basePath!)
            for childPath in childrenPath! {
                let cachePath = ((basePath)! + "/") + childPath
                do {
                    try fileManager.removeItem(atPath: cachePath)
                    
                } catch  {
                    
                }
            }
        }
    }
    
    
    /// 可用磁盘容量
    ///
    /// - Returns: Float
        func availableDiskSize() -> Float {
        var availableSize: Float  = 0
        let manager = FileManager.default
        let home = NSHomeDirectory() as NSString
        do {
            let attribute = try manager.attributesOfFileSystem(forPath: home as String)
            availableSize = (attribute[FileAttributeKey.systemFreeSize] as! NSNumber).floatValue / 1024 / 1024 / 1024
        } catch  {
            availableSize = 0
        }
        return availableSize
    }
    
    /// 总磁盘容量
    ///
    /// - Returns: Float
        func totalDiskSize() -> Float {
        var totalSize: Float  = 0
        let manager = FileManager.default
        let home = NSHomeDirectory() as NSString
        do {
            let attribute = try manager.attributesOfFileSystem(forPath: home as String)
            totalSize = (attribute[FileAttributeKey.systemFreeSize] as! NSNumber).floatValue / 1024 / 1024 / 1024
        } catch  {
            totalSize = 0
        }
        return totalSize
    }
    //总内存大小
        func totalMemorySize() -> UInt64 {
        return ProcessInfo.processInfo.physicalMemory
    }
    //获取今天日期
        func getTodayTime() -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy.MM.dd"
        return dateFormat.string(from: Date())
    }
    
    //返回是否可以弹出
        func getRepayNoticeCanShow() -> Bool {
        let defaults = UserDefaults()
        let dateStr = defaults.object(forKey: "popWindowOnceADay") as? String
        return dateStr == getTodayTime() ? false : true //判断时间是否相同
    }
    
    //窗口弹出后保存日期
        func setRepayNoticeTime() {
        let defaults = UserDefaults()
        defaults.set(getTodayTime(), forKey: "popWindowOnceADay")
        defaults.synchronize()
    }
    
    //  MARK:   --播放Mp3
        func playMp3() {
        var player = AVAudioPlayer()
        let mp3Url = Bundle.main.url(forResource: "ClickSing", withExtension: "mp3")
        player = try! AVAudioPlayer(contentsOf: mp3Url!)
        player.numberOfLoops = 0
        player.volume = 1.0
        player.prepareToPlay()
        player.play()
    }
    //   弹出内存提示窗
        func showTipAlert(judgeStr:String, titleStr:String) {
//        let alert = TipAlertView()
//        alert.setupDiskAlert(judgeStr: judgeStr, titleStr: titleStr)
//        alert.show()
    }
}

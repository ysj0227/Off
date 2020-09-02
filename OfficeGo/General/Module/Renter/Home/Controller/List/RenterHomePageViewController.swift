//
//  RenterHomePageViewController.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/5/8.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit
import HandyJSON
import SwiftyJSON

class RenterHomePageViewController: LLSegmentViewController, CycleViewDelegate, LLSegmentedControlDelegate {
    
    var bannerArr: [BannerModel?] = []
    
    //推荐房源搜索model
    var recommendSelectModel: HouseSelectModel = HouseSelectModel() {
        didSet {
            
            shaixuanview.houseSelectModel = recommendSelectModel
            
            isShowShaixuanView()
            
            NotificationCenter.default.post(name: NSNotification.Name.HomeSelectRefresh, object: recommendSelectModel)
        }
    }
    /*
     //附件房源搜索model
     var nearbySelectModel: HouseSelectModel = HouseSelectModel() {
     didSet {
     //            self.tableView.reloadData()
     }
     }*/
    
    //判断是否要展示筛选提交view
    func isShowShaixuanView() {
        //商圈地铁
        var subwayBusiniessString: String? = ""
        
        if recommendSelectModel.areaModel.selectedCategoryID == "1" {
            
            if let firstLevelModel = self.recommendSelectModel.areaModel.areaModelCount.isFirstSelectedModel {
                
                subwayBusiniessString = "have"
                
            }else {
                subwayBusiniessString = ""
            }
            
        }else if recommendSelectModel.areaModel.selectedCategoryID == "2" {
            
            if let firstLevelModel = self.recommendSelectModel.areaModel.subwayModelCount.isFirstSelectedModel {
                
                //地铁线
                subwayBusiniessString = "have"
                
            }else {
                subwayBusiniessString = ""
            }
        }
        
        //楼盘类型
        var btypeString: String? = "" //类型,1:楼盘 写字楼,2:网点 共享办公 0全部
        
        if recommendSelectModel.typeModel.type == .officeBuildingEnum {
            btypeString = "have"
            
        }else if recommendSelectModel.typeModel.type == .jointOfficeEnum {
            btypeString = "have"
        }else {
            btypeString = ""
        }
        
        //筛选条件
        var shaixuanString: String? = ""
        
        if recommendSelectModel.shaixuanModel.isShaixuan == true {
            
            //工位数 - 网点要
            if recommendSelectModel.typeModel.type == .jointOfficeEnum {
                
                if self.recommendSelectModel.shaixuanModel.gongweijointOfficeExtentModel.highValue == self.recommendSelectModel.shaixuanModel.gongweijointOfficeExtentModel.maximumValue && self.recommendSelectModel.shaixuanModel.gongweijointOfficeExtentModel.lowValue == self.recommendSelectModel.shaixuanModel.gongweijointOfficeExtentModel.minimumValue {
                    shaixuanString = ""
                }else {
                    shaixuanString = "have"
                }
                
            }else if recommendSelectModel.typeModel.type == .officeBuildingEnum {
                
                if self.recommendSelectModel.shaixuanModel.mianjiofficeBuildingExtentModel.highValue == self.recommendSelectModel.shaixuanModel.mianjiofficeBuildingExtentModel.maximumValue && self.recommendSelectModel.shaixuanModel.mianjiofficeBuildingExtentModel.lowValue == self.recommendSelectModel.shaixuanModel.mianjiofficeBuildingExtentModel.minimumValue {
                    shaixuanString = ""
                }else {
                    shaixuanString = "have"
                }
            }else {
                shaixuanString = ""
            }
        }
        
        if subwayBusiniessString?.count ?? 0 > 0 || btypeString?.count ?? 0 > 0 || shaixuanString?.count ?? 0 > 0 {
            shaixuanview.frame = CGRect(x: left_pending_space_17, y: kNavigationHeight + 60, width: kWidth - left_pending_space_17 * 2, height: 50)
        }else {
            shaixuanview.frame = CGRect(x: left_pending_space_17, y: kNavigationHeight + 60, width: kWidth - left_pending_space_17 * 2, height: 0)
        }
    }
    var titleview: ThorNavigationView?
    
    var itemStyle: LLSegmentItemTitleViewStyle?
    
    var segmentedCtlStyle: LLSegmentedControlStyle?
    
    var cycleView:CycleView?
    
    var segmentTitleSelectview: HomeSegmentSelectView = {
        let view = HomeSegmentSelectView(frame: CGRect(x: 0, y: 0, width: kWidth, height: kNavigationHeight + 58))
        return view
    }()
    
    var shaixuanview: RenterShaixuanView = {
        let view = RenterShaixuanView()
        view.frame = CGRect(x: left_pending_space_17, y: kNavigationHeight + 60, width: kWidth - left_pending_space_17 * 2, height: 0)
        view.isHidden = true
        return view
    }()
      
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let tab = self.navigationController?.tabBarController as? RenterMainTabBarController
        tab?.customTabBar.isHidden = true
        
        segmentTitleSelectview.selectView.removeShowView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        SSLog(kWidth)
        SSLog(kHeight)
        SSLog((UIDevice.current.systemVersion as NSString).doubleValue)
        
        let tab = self.navigationController?.tabBarController as? RenterMainTabBarController
        tab?.customTabBar.isHidden = false
        
        if self.cycleView?.imageURLStringArr.count ?? 0 <= 0 {
            request_bannerlist()
        }
        
        requestVersionUpdate()
    }
    
    ///版本更新判断
    func requestVersionUpdate() {
        
        SSNetworkTool.SSVersion.request_version(success: { [weak self] (response) in
            
            if let model = VersionModel.deserialize(from: response, designatedPath: "data") {
                self?.showUpdateAlertview(versionModel: model)
            }
            }, failure: { (error) in
                
        }) {(code, message) in
            
            //只有5000 提示给用户
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" {
                AppUtilities.makeToast(message)
            }
            
        }
        
    }
    
    //弹出版本更新弹框
    func showUpdateAlertview(versionModel: VersionModel) {
        
        if UserTool.shared.isCloseCancelVersionUpdate == true {
            return
        }
        
        let alert = SureAlertView(frame: self.view.frame)
        alert.isHiddenVersionCancel = versionModel.force ?? false
        alert.ShowAlertView(withalertType: AlertType.AlertTypeVersionUpdate, title: "版本更新", descMsg: versionModel.desc ?? "", cancelButtonCallClick: {
            UserTool.shared.isCloseCancelVersionUpdate = true
        }) {
            UserTool.shared.isCloseCancelVersionUpdate = true
            if let url = URL(string: versionModel.uploadUrl ?? "") {
                if UIApplication.shared.canOpenURL(url) {
                    if #available(iOS 10, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler:nil)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            }
        }
    }
    
    func setDataModel() {
        
        request_getDistrict()
        
        requestGetFeature()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //closeAutomaticallyAdjusts()
        
        request_bannerlist()
        
        //模拟数据 - 推荐和附近 - 不同的数据
        setDataModel()
        
        //首页头部view - 标题栏搜索 - 跳转搜索
        segmentTitleSelectview.titleView.rightBtnClickBlock = { [weak self] in
            
            ///搜索-楼盘推荐页面点击搜索按钮
            SensorsAnalyticsFunc.click_search_button_index()
            
            //移除筛选弹框
            self?.segmentTitleSelectview.selectView.removeShowView()
            
            let vc = BaseNavigationViewController.init(rootViewController: RenterSearchViewController())
            vc.navigationBar.isHidden = true
            vc.modalPresentationStyle = .overFullScreen
            self?.present(vc, animated: true, completion: nil)
        }
        
        //默认推荐
        segmentTitleSelectview.selectView.selectModel = recommendSelectModel
        
        
        //切换下面的筛选条件
        segmentTitleSelectview.titleView.segHead?.buttonCallBack = {[weak self] (index) in
            
            //点击切换 移除
            self?.segmentTitleSelectview.selectView.removeShowView()
            
            //更新选中下面的滑动和点击view
            self?.segmentCtlView.selected(at: index - 1, animation: true)
            
            if index == 1 {
                //推荐
                self?.segmentTitleSelectview.selectView.hiddenArea = false
                self?.segmentTitleSelectview.selectView.selectModel = self?.recommendSelectModel
            }else if index == 2 {
                /*
                 //附近
                 self?.segmentTitleSelectview.selectView.hiddenArea = true
                 self?.segmentTitleSelectview.selectView.selectModel = self?.nearbySelectModel
                 */
            }
            SSLog("--------index --********---\(index)")
        }
        
        //首页头部 - 筛选操作 - 判断是推荐还是附近 - 然后刷新数据
        segmentTitleSelectview.selectView.sureButtonButtonCallBack = { [weak self] (_ isNearby: Bool, _ selectModel: HouseSelectModel) -> Void in
            self?.recommendSelectModel = selectModel
            /*if isNearby == true {
             self?.nearbySelectModel = selectModel
             }else {
             self?.recommendSelectModel = selectModel
             }*/
        }
        
        self.view.addSubview(segmentTitleSelectview)
        //        segmentTitleSelectview.isHidden = true
        segmentTitleSelectview.alpha = 0
        segmentTitleSelectview.isUserInteractionEnabled = false
        self.view.bringSubviewToFront(segmentTitleSelectview)
        
        self.view.addSubview(shaixuanview)
        self.view.bringSubviewToFront(shaixuanview)
      
        titleview = ThorNavigationView.init(type: .locationSearchClear)
        titleview?.locationBtn.layoutButton(.imagePositionLeft, margin: 10)
        titleview?.rightBtnClickBlock = { [weak self] in
            
            ///搜索-楼盘推荐页面点击搜索按钮
            SensorsAnalyticsFunc.click_search_button_index()
            
            //移除筛选弹框
            self?.segmentTitleSelectview.selectView.removeShowView()
            
            let vc = BaseNavigationViewController.init(rootViewController: RenterSearchViewController())
            vc.navigationBar.isHidden = true
            vc.modalPresentationStyle = .overFullScreen
            self?.present(vc, animated: true, completion: nil)
        }
        titleview?.locationBtn.setTitle("  上海", for: .normal)
        self.view.addSubview(titleview ?? ThorNavigationView.init(type: .locationSearchClear))
        self.view.bringSubviewToFront(titleview ?? ThorNavigationView.init(type: .locationSearchClear))
        titleview?.leftButtonCallBack = { [weak self] in
            self?.shareVc()
        }
        
        let pointY: CGFloat = 0
        cycleView = CycleView(frame: CGRect(x: 0, y: pointY, width: kWidth, height: (CGFloat)(ceilf((Float)(kWidth * 240.0 / 320.0)))))
        cycleView?.delegate = self
        cycleView?.mode = .scaleAspectFill
        
        //cycleView?.addSubview(titleview ?? ThorNavigationView.init(type: .locationSearchClear))
        
        loadSegmentedConfig()
        
        //        requestGetBuildingList()
        
        notifyDeal()
    }
    
    func notifyDeal() {
        
        ///添加了如果上面的筛选view透明度大于等于0.97，则可以点击，否则筛选按钮不可点击
        NotificationCenter.default.addObserver(forName: NSNotification.Name.HomeBtnLocked, object: nil, queue: OperationQueue.main) { [weak self] (noti) in
            
            SSLog("-----``````----------****\(self?.containerScrView.contentOffset.y ?? 0)")
            
            if self?.containerScrView.contentOffset.y ?? 0 > -(60 + kStatusBarHeight) {
                self?.segmentTitleSelectview.alpha = 1
                self?.segmentTitleSelectview.isUserInteractionEnabled = true
                self?.shaixuanview.isHidden = false

            } else if self?.containerScrView.contentOffset.y ?? 0 > -(60 + kStatusBarHeight + 180){
                
                //y = k * x + b
                let k: CGFloat = 1 / 180.0
                let b: CGFloat = 1 / 180.0 * (60 + kStatusBarHeight) + 1
                let alpha = k * (self?.containerScrView.contentOffset.y ?? 0.0) + b
                self?.segmentTitleSelectview.alpha = alpha
                if alpha >= 0.97 {
                    self?.segmentTitleSelectview.isUserInteractionEnabled = true
                }else {
                    self?.segmentTitleSelectview.isUserInteractionEnabled = false
                }
                SSLog("*******************---****\(alpha)")
                
                self?.shaixuanview.isHidden = true
            }
            else {
                self?.segmentTitleSelectview.alpha = 0
                self?.segmentTitleSelectview.isUserInteractionEnabled = false
                self?.shaixuanview.isHidden = true
            }
            
            if self?.containerScrView.contentOffset.y ?? 0 > -(60 + kStatusBarHeight + 150){
                
                self?.titleview?.isHidden = true
//                self?.shaixuanview.isHidden = true
            }
            else {
                self?.titleview?.isHidden = false
//                self?.shaixuanview.isHidden = false
            }
        }
        
        ///商圈地铁清除
        NotificationCenter.default.addObserver(forName: NSNotification.Name.HomeSubwayBusinessClear, object: nil, queue: OperationQueue.main) { [weak self] (noti) in
            
            let model = noti.object as? HouseSelectModel
            self?.clearSubwayBusinessData(selectModel: model ?? HouseSelectModel())
        }
        
        ///楼盘类型
        NotificationCenter.default.addObserver(forName: NSNotification.Name.HomeBuildingTypeClear, object: nil, queue: OperationQueue.main) { [weak self] (noti) in
            
            let model = noti.object as? HouseSelectModel
            self?.clearTypeData(selectModel: model ?? HouseSelectModel())
        }
        
        ///筛选条件
        NotificationCenter.default.addObserver(forName: NSNotification.Name.HomeShaixuanClear, object: nil, queue: OperationQueue.main) { [weak self] (noti) in
            
            let model = noti.object as? HouseSelectModel
            self?.clearShaixuanData(selectModel: model ?? HouseSelectModel())
        }
    }
    
    //MARK: 清除数据操作
    func clearSubwayBusinessData(selectModel: HouseSelectModel) {
        
        ///清除商圈地铁选择的数据
        if selectModel.areaModel.selectedCategoryID == "1" {
            if let areaFirstLevelModel = selectModel.areaModel.areaModelCount.isFirstSelectedModel {
                for model in areaFirstLevelModel.list {
                    model.isSelected = false
                }
            }
        }else if selectModel.areaModel.selectedCategoryID == "2" {
            if let areaFirstLevelModel = selectModel.areaModel.subwayModelCount.isFirstSelectedModel {
                for model in areaFirstLevelModel.list {
                    model.isSelected = false
                }
            }
        }
        
        selectModel.areaModel.areaModelCount.isFirstSelectedModel = nil
        selectModel.areaModel.subwayModelCount.isFirstSelectedModel = nil
        
        ///点击筛选页面数据也清空
        segmentTitleSelectview.selectView.areaView.clearData()
        
        ///修改筛选按钮的标题
        if selectModel.areaModel.selectedCategoryID == "1" {
            
            if selectModel.areaModel.areaModelCount.isFirstSelectedModel == nil {
                segmentTitleSelectview.selectView.houseAreaSelectBtn.setTitle("区域", for: .normal)
                segmentTitleSelectview.selectView.houseAreaSelectBtn.isSelected = false
            }else {
                segmentTitleSelectview.selectView.houseAreaSelectBtn.setTitle("商圈", for: .normal)
                segmentTitleSelectview.selectView.houseAreaSelectBtn.isSelected = true
            }
            
        }else if selectModel.areaModel.selectedCategoryID == "2" {
            
            if selectModel.areaModel.subwayModelCount.isFirstSelectedModel == nil {
                segmentTitleSelectview.selectView.houseAreaSelectBtn.setTitle("区域", for: .normal)
                segmentTitleSelectview.selectView.houseAreaSelectBtn.isSelected = false
            }else {
                segmentTitleSelectview.selectView.houseAreaSelectBtn.setTitle("地铁", for: .normal)
                segmentTitleSelectview.selectView.houseAreaSelectBtn.isSelected = true
            }
            
        }else {
            segmentTitleSelectview.selectView.houseAreaSelectBtn.setTitle("区域", for: .normal)
            segmentTitleSelectview.selectView.houseAreaSelectBtn.isSelected = false
        }
        recommendSelectModel = selectModel

    }
    
    func clearTypeData(selectModel: HouseSelectModel) {
        
        selectModel.typeModel.type = .allEnum
        recommendSelectModel = selectModel
        
        segmentTitleSelectview.selectView.houseTypeSelectBtn.setTitle(selectModel.typeModel.type?.rawValue, for: .normal)
        segmentTitleSelectview.selectView.houseTypeSelectBtn.isSelected = true
    }
    
    func clearShaixuanData(selectModel: HouseSelectModel) {
        //清除操作
        if selectModel.typeModel.type == .officeBuildingEnum {
            
            //工位数清空
            selectModel.shaixuanModel.gongweiofficeBuildingExtentModel.lowValue = selectModel.shaixuanModel.gongweiofficeBuildingExtentModel.minimumValue
            
            selectModel.shaixuanModel.gongweiofficeBuildingExtentModel.highValue = selectModel.shaixuanModel.gongweiofficeBuildingExtentModel.maximumValue
            
            //租金清空
            selectModel.shaixuanModel.zujinofficeBuildingExtentModel.lowValue = selectModel.shaixuanModel.zujinofficeBuildingExtentModel.minimumValue
            
            selectModel.shaixuanModel.zujinofficeBuildingExtentModel.highValue = selectModel.shaixuanModel.zujinofficeBuildingExtentModel.maximumValue
            
            //面积清空
            selectModel.shaixuanModel.mianjiofficeBuildingExtentModel.lowValue = selectModel.shaixuanModel.mianjiofficeBuildingExtentModel.minimumValue
            
            selectModel.shaixuanModel.mianjiofficeBuildingExtentModel.highValue = selectModel.shaixuanModel.mianjiofficeBuildingExtentModel.maximumValue
            
            //选择特色清空
            for model in selectModel.shaixuanModel.featureModelArr {
                model.isOfficeBuildingSelected = false
            }
            
            //选择装修类型清空
            for model in selectModel.shaixuanModel.documentTypeModelArr {
                model.isDocumentSelected = false
            }
            
        }else {
            //工位数清空
            selectModel.shaixuanModel.gongweijointOfficeExtentModel.lowValue = selectModel.shaixuanModel.gongweijointOfficeExtentModel.minimumValue
            
            selectModel.shaixuanModel.gongweijointOfficeExtentModel.highValue = selectModel.shaixuanModel.gongweijointOfficeExtentModel.maximumValue
            
            //租金清空
            selectModel.shaixuanModel.zujinjointOfficeExtentModel.lowValue = selectModel.shaixuanModel.zujinjointOfficeExtentModel.minimumValue
            
            selectModel.shaixuanModel.zujinjointOfficeExtentModel.highValue = selectModel.shaixuanModel.zujinjointOfficeExtentModel.maximumValue
            
            //选择特色清空
            for model in selectModel.shaixuanModel.featureModelArr {
                model.isOfficejointOfficeSelected = false
            }
        }
        recommendSelectModel = selectModel
    }
    
    func shareVc() {
        
    }
}

//MARK: 接口处理
extension RenterHomePageViewController {
    
    //MARK: 获取商圈数据
    func request_getDistrict() {
        //查询类型，1：全部，0：系统已有楼盘的商圈
        var params = [String:AnyObject]()
        params["type"] = 1 as AnyObject?
        SSNetworkTool.SSBasic.request_getDistrictList(params: params, success: { [weak self] (response) in
            if let model = AreaCategorySelectModel.deserialize(from: response) {
                model.name = "商圈"
                self?.recommendSelectModel.areaModel.areaModelCount = model
            }
            self?.request_getSubwaylist()
            }, failure: { [weak self] (error) in
                self?.request_getSubwaylist()
        }) { [weak self] (code, message) in
            
            self?.request_getSubwaylist()
            //只有5000 提示给用户
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" {
                AppUtilities.makeToast(message)
            }
        }
    }
    
    //MARK: 获取地铁数据
    func request_getSubwaylist() {
        //查询类型，1：全部，0：系统已有楼盘的商圈
        var params = [String:AnyObject]()
        params["type"] = 1 as AnyObject?
        SSNetworkTool.SSBasic.request_getSubwayList(params: params, success: { [weak self] (response) in
            if let model = SubwayCategorySelectModel.deserialize(from: response) {
                model.name = "地铁"
                self?.recommendSelectModel.areaModel.subwayModelCount = model
            }
            
            }, failure: { (error) in
                
        }) { (code, message) in
            //只有5000 提示给用户
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" {
                AppUtilities.makeToast(message)
            }
        }
    }
    
    //MARK: 获取装修类型
    func requestGetDecorate() {
        
        SSNetworkTool.SSBasic.request_getDictionary(code: .codeEnumdecoratedType, success: { [weak self] (response) in
            guard let weakSelf = self else {return}
            if let decoratedArray = JSONDeserializer<HouseFeatureModel>.deserializeModelArrayFrom(json: JSON(response).rawString() ?? "", designatedPath: "data") {
                for model in decoratedArray {
                    weakSelf.recommendSelectModel.shaixuanModel.documentTypeModelArr.append(model ?? HouseFeatureModel())
                    /*weakSelf.nearbySelectModel.shaixuanModel.documentTypeModelArr.append(model ?? HouseFeatureModel())*/
                }
            }
            
            }, failure: {(error) in
                
        }) {(code, message) in
            
            //只有5000 提示给用户
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" {
                AppUtilities.makeToast(message)
            }
        }
    }
    
    //MARK: 获取特色接口
    func requestGetFeature() {
        
        SSNetworkTool.SSBasic.request_getDictionary(code: .codeEnumbranchUnique, success: { [weak self] (response) in
            guard let weakSelf = self else {return}
            if let decoratedArray = JSONDeserializer<HouseFeatureModel>.deserializeModelArrayFrom(json: JSON(response).rawString() ?? "", designatedPath: "data") {
                for model in decoratedArray {
                    weakSelf.recommendSelectModel.shaixuanModel.featureModelArr.append(model ?? HouseFeatureModel())
                    /*weakSelf.nearbySelectModel.shaixuanModel.featureModelArr.append(model ?? HouseFeatureModel())*/
                }
            }
            weakSelf.requestGetDecorate()
            
            }, failure: {[weak self] (error) in
                self?.requestGetDecorate()
        }) {[weak self] (code, message) in
            self?.requestGetDecorate()
            
            //只有5000 提示给用户
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" {
                AppUtilities.makeToast(message)
            }
        }
    }
    
    //MARK: 轮播图
    func request_bannerlist() {
        SSNetworkTool.SSHome.request_getbannerListt(success: { [weak self] (response) in
            guard let weakSelf = self else {return}
            if let decoratedArray = JSONDeserializer<BannerModel>.deserializeModelArrayFrom(json: JSON(response).rawString() ?? "", designatedPath: "data") {
                
                var arr: [String] = []
                for model in decoratedArray {
                    arr.append(model?.img ?? "")
                    weakSelf.bannerArr.append(model ?? BannerModel())
                }
                
                //                weakSelf.setCycleImg()
                weakSelf.cycleView?.imageURLStringArr = arr
                
            }
            
            }, failure: { (error) in
                
        }) { (code, message) in
            
            //只有5000 提示给用户
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" {
                AppUtilities.makeToast(message)
            }
        }
    }
    
    func setCycleImg() {
        SSTool.invokeInMainThread { [weak self] in
            self?.cycleView?.imageURLStringArr = ["bannerBgView"]
            
            
            //            self?.cycleView?.imageURLStringArr = ["https://img.officego.com/building/1592531586982.jpg?x-oss-process=style/large"]
            //                weakSelf.cycleView?.imageURLStringArr = arr
        }
        
    }
}


//MARK: LLSegmentedControlDelegate
extension RenterHomePageViewController {
    //设置自己上面的按钮状态
    /*******滚动ContentView*****/
    func segMegmentCtlView(segMegmentCtlView: LLSegmentedControl, dragToSelected itemView: LLSegmentBaseItemView) {
        segmentTitleSelectview.titleView.segHead?.selectedIndex = itemView.index + 1
    }
    /********点击ItemView*****/
    func segMegmentCtlView(segMegmentCtlView: LLSegmentedControl, clickItemAt sourceItemView: LLSegmentBaseItemView, to destinationItemView: LLSegmentBaseItemView) {
        segmentTitleSelectview.titleView.segHead?.selectedIndex = destinationItemView.index + 1
    }
}

//MARK: CycleViewDelegate
extension RenterHomePageViewController {
    func cycleViewDidSelectedItemAtIndex(_ index: NSInteger) {
        let banner = bannerArr[index]
        ///类型:0不可跳转,1内链 2:富文本 3外链
        if banner?.type == 0 {
            
        }else if banner?.type == 1 {
            ///内链类型，1：楼盘详情，2:网点详情 3:楼盘房源详情,4:网点房源详情
            ///pageId":,//内链类型的id
            if banner?.pageType == 1 {
                let model = FangYuanListModel()
                model.btype = 1
                model.id = banner?.pageId
                let vc = RenterOfficebuildingDetailVC()
                vc.buildingModel = model
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else if banner?.pageType == 2 {
                let model = FangYuanListModel()
                model.btype = 2
                model.id = banner?.pageId
                let vc = RenterOfficeJointDetailVC()
                vc.buildingModel = model
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else if banner?.pageType == 3 {
                let model = FangYuanBuildingOpenStationModel()
                model.btype = 1
                model.id = banner?.pageId
                let vc = RenterOfficebuildingFYDetailVC()
                vc.model = model
                self.navigationController?.pushViewController(vc, animated: true)
            }else if banner?.pageType == 4 {
                let model = FangYuanBuildingOpenStationModel()
                model.btype = 2
                model.id = banner?.pageId
                let vc = RenterOfficeJointFYDetailVC()
                vc.model = model
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else if banner?.type == 2 {
            
        }else if banner?.type == 3 {
            let vc = BannerOutClickWebViewController()
            vc.urlString = banner?.wurl
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}


extension RenterHomePageViewController{
    func loadSegmentedConfig() {
        
        layoutContentView()
        loadCtls()
        setUpSegmentStyle()
        ///首页列表滑动显示问题 - 
        //        closeAutomaticallyAdjusts()
    }
    
    func layoutContentView() {
        
        self.layoutInfo.refreshType = .list
        
        self.layoutInfo.headView = cycleView
        
        self.layoutInfo.segmentControlPositionType = .top(size: CGSize.init(width: UIScreen.main.bounds.width, height: 44), offset: 0)
        self.relayoutSubViews()
    }
    
    func loadCtls() {
        let introCtl = RenterFangYuanListViewController()
        introCtl.title = "推荐房源"
        
        /* 暂时隐藏附近房源
         let catalogCtl = RenterFangYuanListViewController()
         catalogCtl.title = "附近房源"
         let ctls =  [introCtl,catalogCtl]
         */
        
        let ctls =  [introCtl]
        reloadViewControllers(ctls:ctls)
    }
    
    func setUpSegmentStyle() {
        itemStyle = LLSegmentItemTitleViewStyle()
        itemStyle?.selectedColor = kAppColor_333333
        itemStyle?.unSelectedColor = kAppColor_666666
        itemStyle?.selectedTitleScale = 1.2
        itemStyle?.titleFontSize = 14
        itemStyle?.itemWidth = 100 //如果不指定是自动适配的
        //这里可以继续增加itemStyle的其他配置项... ...
        
        segmentCtlView.backgroundColor = UIColor.white
        segmentCtlView.separatorLineShowEnabled = false //间隔线显示，默认不显示
        //还有其他配置项：颜色、宽度、上下的间隔...
        
        //    segmentCtlView.bottomSeparatorStyle = (1,UIColor.red) //分割线:默认透明色
        segmentCtlView.indicatorView.widthChangeStyle = .stationary(baseWidth: 0)//横杆宽度:有默认值
        segmentCtlView.indicatorView.centerYGradientStyle = .bottom(margin: 0)//横杆位置:有默认值
        segmentCtlView.indicatorView.shapeStyle = .custom //形状样式:有默认值
        
        segmentedCtlStyle = LLSegmentedControlStyle()
        segmentedCtlStyle?.segmentItemViewClass = LLSegmentItemTitleView.self  //ItemView和ItemViewStyle要统一对应
        segmentedCtlStyle?.itemViewStyle = itemStyle ?? LLSegmentItemTitleViewStyle()
        segmentCtlView.reloadData(ctlViewStyle: segmentedCtlStyle)
        segmentCtlView.delegate = self
    }
}


//首页上面切换titleview和下面的筛选选择按钮
class HomeSegmentSelectView: UIView {
    
    var titleView: ThorNavigationView = {
        var view = ThorNavigationView.init(type: .homeTitleViewSearchBtn)
        return view
    }()
    
    var selectView: HouseSelectBtnView = {
        let view = HouseSelectBtnView.init(frame: CGRect(x: 0, y: kNavigationHeight, width: kWidth, height: 60))
        //   selectView?.selectModel = self.selectModel
        return view
    }()
    
    public override required init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        
        self.backgroundColor = kAppWhiteColor
        
        self.addSubview(titleView)
        self.addSubview(selectView)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


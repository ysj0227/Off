//
//  RenterFangYuanListViewController.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/5/8.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit
import HandyJSON
import SwiftyJSON

class RenterFangYuanListViewController: BaseTableViewController {
    
    //推荐房源搜索model
    var recommendSelectModel: HouseSelectModel = HouseSelectModel() {
        didSet {
            
            selectview.houseSelectModel = recommendSelectModel
            
            senors()
            
            loadNewData()
        }
    }
    
    func senors() {
        ///访问楼盘网点列表
        SensorsAnalyticsFunc.visit_building_network_list(selectModel: recommendSelectModel)
    }
    
    lazy var selectview: RenterShaixuanView = {
        let view = RenterShaixuanView(frame: CGRect(x: left_pending_space_17, y: 0, width: kWidth - left_pending_space_17 * 2, height: 50))
        return view
    }()
    
    var dataSourceViewModel: [FangYuanListViewModel?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //接收筛选条件
        NotificationCenter.default.addObserver(forName: NSNotification.Name.HomeSelectRefresh, object: nil, queue: OperationQueue.main) { [weak self] (noti) in
            
            let model = noti.object as? HouseSelectModel
            
            self?.recommendSelectModel = model ?? HouseSelectModel()
        }
        
        requestSet()
        
    }
    
    override func layoutSet () {
        
    }
    
    override func noDataViewSet() {
        //        noDataView.snp.remakeConstraints { (make) in
        //            make.centerX.equalToSuperview()
        //            make.centerX.equalToSuperview()
        //            make.top.equalTo(120)
        //            make.size.equalTo(CGSize(width: 160, height: 190))
        //        }
        //        if self.dataSource.count > 0 {
        //            noDataView.isHidden = true
        //        }else {
        //            noDataView.isHidden = false
        //            switch NetAlamofireReachability.shared.status {
        //            case .Unknown, .NotReachable:
        //                noDataButton.isHidden = false
        //                noDataImageView.image = UIImage(named: "no_network_image")
        //                noDataLabel.text = "网络连接失败，请查看你的网络设置"
        //            case .WiFi, .Wwan:
        //                noDataButton.isHidden = true
        //                noDataImageView.image = UIImage(named: "no_data_image")
        //                noDataLabel.text = "暂无数据，点击重试"
        //            }
        //        }
        
        noDataView.isHidden = true
    }
    
    //MARK: 获取首页列表数据
    override func refreshData() {
        
        if pageNo == 1 {
            if self.dataSourceViewModel.count > 0 {
                self.dataSourceViewModel.removeAll()
            }
        }
        
        var params = [String:AnyObject]()
        
        params["token"] = UserTool.shared.user_token as AnyObject?
        
        //商圈和地铁
        //商圈
        if recommendSelectModel.areaModel.selectedCategoryID == "1" {
            
            if let firstLevelModel = self.recommendSelectModel.areaModel.areaModelCount.isFirstSelectedModel {
                
                //区域id
                let district = firstLevelModel.districtID
                
                params["district"] = district as AnyObject?
                
                var businessArr: [String] = []
                
                for model in firstLevelModel.list {
                    if model.isSelected ?? false  {
                        businessArr.append(model.id ?? "0")
                    }
                }
                
                //商圈拼接字符串
                let business = businessArr.joined(separator: ",")
                
                params["business"] = business as AnyObject?
                
            }
            
            
        }else if recommendSelectModel.areaModel.selectedCategoryID == "2" {
            
            if let firstLevelModel = self.recommendSelectModel.areaModel.subwayModelCount.isFirstSelectedModel {
                
                //地铁线id
                let line = firstLevelModel.lid
                
                params["line"] = line as AnyObject?
                
                var nearbySubwayArr: [String] = []
                
                for model in firstLevelModel.list {
                    if model.isSelected ?? false  {
                        nearbySubwayArr.append(model.id ?? "0")
                    }
                }
                
                //地铁站拼接字符串
                let nearbySubway = nearbySubwayArr.joined(separator: ",")
                
                params["nearbySubway"] = nearbySubway as AnyObject?
                
            }
        }
        
        
        //类型
        var btype: Int? //类型,1:楼盘 写字楼,2:网点 共享办公 0全部
        if recommendSelectModel.typeModel.type == .officeBuildingEnum {
            btype = 1
        }else if recommendSelectModel.typeModel.type == .jointOfficeEnum {
            btype = 2
        }else {
            btype = 0
        }
        params["btype"] = btype as AnyObject?
        
        
        //排序
        //排序 0默认 1价格从高到低 2价格从低到高 3面积从大到小 4面积从小到大
        var sortNum: Int?
        if recommendSelectModel.sortModel.type == .defaultSortEnum {
            sortNum = 0
        }else if recommendSelectModel.sortModel.type == .priceTopToLowEnum {
            sortNum = 1
        }else if recommendSelectModel.sortModel.type == .priceLowToTopEnum {
            sortNum = 2
        }else if recommendSelectModel.sortModel.type == .squareTopToLowEnum {
            sortNum = 3
        }else if recommendSelectModel.sortModel.type == .squareLowToTopEnum {
            sortNum = 4
        }
        params["sort"] = sortNum as AnyObject?
        
        
        //筛选 - 只有点击过筛选按钮 才把筛选的参数带过去
        if self.recommendSelectModel.shaixuanModel.isShaixuan == true {
            //工位 - 两者都有
            var gongweiExtentStr: String?
            
            //租金 - 两者都有
            var zujinExtentStr: String?
            /*
            //房源特色 - 两者都有
            var featureArr: [String] = []*/
            
            //共享办公
            if btype == 2 {
                 
                if self.recommendSelectModel.shaixuanModel.gongweijointOfficeExtentModel.highValue == self.recommendSelectModel.shaixuanModel.gongweijointOfficeExtentModel.maximumValue {
                    gongweiExtentStr = String(format: "%.0f", self.recommendSelectModel.shaixuanModel.gongweijointOfficeExtentModel.lowValue ?? 0) + "," + String(format: "%.0f", self.recommendSelectModel.shaixuanModel.gongweijointOfficeExtentModel.noLimitNum)
                }else {
                    gongweiExtentStr = String(format: "%.0f", self.recommendSelectModel.shaixuanModel.gongweijointOfficeExtentModel.lowValue ?? 0) + "," + String(format: "%.0f", self.recommendSelectModel.shaixuanModel.gongweijointOfficeExtentModel.highValue ?? 0)
                }
                
                params["seats"] = gongweiExtentStr as AnyObject?
                
                if self.recommendSelectModel.shaixuanModel.zujinjointOfficeExtentModel.highValue == self.recommendSelectModel.shaixuanModel.zujinjointOfficeExtentModel.maximumValue {
                    zujinExtentStr = String(format: "%.0f", self.recommendSelectModel.shaixuanModel.zujinjointOfficeExtentModel.lowValue ?? 0) + "," + String(format: "%.0f", self.recommendSelectModel.shaixuanModel.zujinjointOfficeExtentModel.noLimitNum)
                }else {
                    zujinExtentStr = String(format: "%.0f", self.recommendSelectModel.shaixuanModel.zujinjointOfficeExtentModel.lowValue ?? 0) + "," + String(format: "%.0f", self.recommendSelectModel.shaixuanModel.zujinjointOfficeExtentModel.highValue ?? 0)
                }
                /*
                //房源特色 - 两者都有
                for model in self.recommendSelectModel.shaixuanModel.featureModelArr {
                    if model.isOfficejointOfficeSelected {
                        featureArr.append("\(model.dictValue ?? 0)")
                    }
                }*/
                
            }else if btype == 1 {
                
                if self.recommendSelectModel.shaixuanModel.zujinofficeBuildingExtentModel.highValue == self.recommendSelectModel.shaixuanModel.zujinofficeBuildingExtentModel.maximumValue {
                    zujinExtentStr = String(format: "%.0f", self.recommendSelectModel.shaixuanModel.zujinofficeBuildingExtentModel.lowValue ?? 0) + "," + String(format: "%.0f", self.recommendSelectModel.shaixuanModel.zujinofficeBuildingExtentModel.noLimitNum)
                }else {
                    zujinExtentStr = String(format: "%.0f", self.recommendSelectModel.shaixuanModel.zujinofficeBuildingExtentModel.lowValue ?? 0) + "," + String(format: "%.0f", self.recommendSelectModel.shaixuanModel.zujinofficeBuildingExtentModel.highValue ?? 0)
                }
                
                //办公室 - 面积传值
                var mianjiStr: String?
                    
                if self.recommendSelectModel.shaixuanModel.mianjiofficeBuildingExtentModel.highValue == self.recommendSelectModel.shaixuanModel.mianjiofficeBuildingExtentModel.maximumValue {
                    mianjiStr = String(format: "%.0f", self.recommendSelectModel.shaixuanModel.mianjiofficeBuildingExtentModel.lowValue ?? 0) + "," + String(format: "%.0f", self.recommendSelectModel.shaixuanModel.mianjiofficeBuildingExtentModel.noLimitNum)
                }else {
                    mianjiStr = String(format: "%.0f", self.recommendSelectModel.shaixuanModel.mianjiofficeBuildingExtentModel.lowValue ?? 0) + "," + String(format: "%.0f", self.recommendSelectModel.shaixuanModel.mianjiofficeBuildingExtentModel.highValue ?? 0)
                }
                params["area"] = mianjiStr as AnyObject?
                
                //办公室 - 装修类型传值
                var documentArr: [String] = []
                for model in self.recommendSelectModel.shaixuanModel.documentTypeModelArr {
                    if model.isDocumentSelected {
                        documentArr.append("\(model.dictValue ?? 0)")
                    }
                }
                let documentStr: String = documentArr.joined(separator: ",")
                params["decoration"] = documentStr as AnyObject?
                /*
                //房源特色 - 两者都有
                for model in self.recommendSelectModel.shaixuanModel.featureModelArr {
                    if model.isOfficeBuildingSelected {
                        featureArr.append("\(model.dictValue ?? 0)")
                    }
                }*/
            }
            
            params["dayPrice"] = zujinExtentStr as AnyObject?
            /*
            //房源特色 - 两者都有
            let featureStr: String = featureArr.joined(separator: ",")
            params["houseTags"] = featureStr as AnyObject?*/
        }
        
        params["pageNo"] = self.pageNo as AnyObject
        params["pageSize"] = self.pageSize as AnyObject
        //        params["time"] = "0" as AnyObject
        SSNetworkTool.SSHome.request_getselectBuildingApp(params: params, success: { [weak self] (response) in
            guard let weakSelf = self else {return}
            if let decoratedArray = JSONDeserializer<FangYuanListModel>.deserializeModelArrayFrom(json: JSON(response["data"] ?? "").rawString() ?? "", designatedPath: "list") {
                weakSelf.dataSource = weakSelf.dataSource + decoratedArray
                for model in decoratedArray {
                    let viewmodel = FangYuanListViewModel.init(model: model ?? FangYuanListModel())
                    weakSelf.dataSourceViewModel.append(viewmodel)
                }
                weakSelf.endRefreshWithCount(decoratedArray.count)
            }
            
            }, failure: {[weak self] (error) in
                guard let weakSelf = self else {return}
                
                weakSelf.endRefreshAnimation()
                
        }) {[weak self] (code, message) in
            
            guard let weakSelf = self else {return}
            
            weakSelf.endRefreshAnimation()
            
            //只有5000 提示给用户
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" {
                AppUtilities.makeToast(message)
            }
        }
    }
    
    func getDetailParams() -> [String:AnyObject] {
        
        var params = [String:AnyObject]()
        
        params["token"] = UserTool.shared.user_token as AnyObject?
        
        //类型
        var btype: Int? //类型,1:楼盘 写字楼,2:网点 共享办公 0全部
        if recommendSelectModel.typeModel.type == .officeBuildingEnum {
            btype = 1
        }else if recommendSelectModel.typeModel.type == .jointOfficeEnum {
            btype = 2
        }
        params["btype"] = btype as AnyObject?
        
        //筛选 - 只有点击过筛选按钮 才把筛选的参数带过去
        if self.recommendSelectModel.shaixuanModel.isShaixuan == true {
            //工位 - 两者都有
            var gongweiExtentStr: String?
            
            //租金 - 两者都有
            var zujinExtentStr: String?
            /*
            //房源特色 - 两者都有
            var featureArr: [String] = []*/
            
            //楼盘不要工位数 - 网点要
            //共享办公
            if btype == 2 {
                
                if self.recommendSelectModel.shaixuanModel.gongweijointOfficeExtentModel.highValue == self.recommendSelectModel.shaixuanModel.gongweijointOfficeExtentModel.maximumValue && self.recommendSelectModel.shaixuanModel.gongweijointOfficeExtentModel.lowValue == self.recommendSelectModel.shaixuanModel.gongweijointOfficeExtentModel.minimumValue {
                    
                }else {
                    if self.recommendSelectModel.shaixuanModel.gongweijointOfficeExtentModel.highValue == self.recommendSelectModel.shaixuanModel.gongweijointOfficeExtentModel.maximumValue {
                        gongweiExtentStr = String(format: "%.0f", self.recommendSelectModel.shaixuanModel.gongweijointOfficeExtentModel.lowValue ?? 0) + "," + String(format: "%.0f", self.recommendSelectModel.shaixuanModel.gongweijointOfficeExtentModel.noLimitNum)
                    }else {
                        gongweiExtentStr = String(format: "%.0f", self.recommendSelectModel.shaixuanModel.gongweijointOfficeExtentModel.lowValue ?? 0) + "," + String(format: "%.0f", self.recommendSelectModel.shaixuanModel.gongweijointOfficeExtentModel.highValue ?? 0)
                    }
                }

                
                params["seats"] = gongweiExtentStr as AnyObject?
                
                if self.recommendSelectModel.shaixuanModel.zujinjointOfficeExtentModel.highValue == self.recommendSelectModel.shaixuanModel.zujinjointOfficeExtentModel.maximumValue  {
                    zujinExtentStr = String(format: "%.0f", self.recommendSelectModel.shaixuanModel.zujinjointOfficeExtentModel.lowValue ?? 0) + "," + String(format: "%.0f", self.recommendSelectModel.shaixuanModel.zujinjointOfficeExtentModel.noLimitNum)
                }else {
                    zujinExtentStr = String(format: "%.0f", self.recommendSelectModel.shaixuanModel.zujinjointOfficeExtentModel.lowValue ?? 0) + "," + String(format: "%.0f", self.recommendSelectModel.shaixuanModel.zujinjointOfficeExtentModel.highValue ?? 0)
                }
                /*
                //房源特色 - 两者都有
                for model in self.recommendSelectModel.shaixuanModel.featureModelArr {
                    if model.isOfficejointOfficeSelected {
                        featureArr.append("\(model.dictValue ?? 0)")
                    }
                }*/
                
            }else if btype == 1 {
                
                if self.recommendSelectModel.shaixuanModel.zujinofficeBuildingExtentModel.highValue == self.recommendSelectModel.shaixuanModel.zujinofficeBuildingExtentModel.maximumValue {
                    zujinExtentStr = String(format: "%.0f", self.recommendSelectModel.shaixuanModel.zujinofficeBuildingExtentModel.lowValue ?? 0) + "," + String(format: "%.0f", self.recommendSelectModel.shaixuanModel.zujinofficeBuildingExtentModel.noLimitNum)
                }else {
                    zujinExtentStr = String(format: "%.0f", self.recommendSelectModel.shaixuanModel.zujinofficeBuildingExtentModel.lowValue ?? 0) + "," + String(format: "%.0f", self.recommendSelectModel.shaixuanModel.zujinofficeBuildingExtentModel.highValue ?? 0)
                }
                
                //办公室 - 面积传值
                var mianjiStr: String?
                    
                if self.recommendSelectModel.shaixuanModel.mianjiofficeBuildingExtentModel.highValue == self.recommendSelectModel.shaixuanModel.mianjiofficeBuildingExtentModel.maximumValue && self.recommendSelectModel.shaixuanModel.mianjiofficeBuildingExtentModel.lowValue == self.recommendSelectModel.shaixuanModel.mianjiofficeBuildingExtentModel.minimumValue {

                }else {
                    if self.recommendSelectModel.shaixuanModel.mianjiofficeBuildingExtentModel.highValue == self.recommendSelectModel.shaixuanModel.mianjiofficeBuildingExtentModel.maximumValue {
                        mianjiStr = String(format: "%.0f", self.recommendSelectModel.shaixuanModel.mianjiofficeBuildingExtentModel.lowValue ?? 0) + "," + String(format: "%.0f", self.recommendSelectModel.shaixuanModel.mianjiofficeBuildingExtentModel.noLimitNum)
                    }else {
                        mianjiStr = String(format: "%.0f", self.recommendSelectModel.shaixuanModel.mianjiofficeBuildingExtentModel.lowValue ?? 0) + "," + String(format: "%.0f", self.recommendSelectModel.shaixuanModel.mianjiofficeBuildingExtentModel.highValue ?? 0)
                    }
                }

                params["area"] = mianjiStr as AnyObject?
                
                //办公室 - 装修类型传值
                var documentArr: [String] = []
                for model in self.recommendSelectModel.shaixuanModel.documentTypeModelArr {
                    if model.isDocumentSelected {
                        documentArr.append("\(model.dictValue ?? 0)")
                    }
                }
                let documentStr: String = documentArr.joined(separator: ",")
                params["decoration"] = documentStr as AnyObject?
                /*
                //房源特色 - 两者都有
                for model in self.recommendSelectModel.shaixuanModel.featureModelArr {
                    if model.isOfficeBuildingSelected {
                        featureArr.append("\(model.dictValue ?? 0)")
                    }
                }*/
            }
            
            params["dayPrice"] = zujinExtentStr as AnyObject?
            /*
            //房源特色 - 两者都有
            let featureStr: String = featureArr.joined(separator: ",")
            params["houseTags"] = featureStr as AnyObject?*/
        }
        
        return params
    }
    
}

extension RenterFangYuanListViewController {
    
    func requestSet() {
        
        isShowRefreshHeader = false
        
        self.tableView.register(HouseListTableViewCell.self, forCellReuseIdentifier: HouseListTableViewCell.reuseIdentifierStr)
        
        self.tableView.snp.remakeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-kTabBarHeight)
        }
        
        refreshData()
    }
    
    
}

extension RenterFangYuanListViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HouseListTableViewCell.reuseIdentifierStr) as? HouseListTableViewCell
        cell?.selectionStyle = .none
        if self.dataSource.count > 0 {
            if let model = self.dataSource[indexPath.row]  {
                cell?.model = model as? FangYuanListModel ?? FangYuanListModel()
            }
        }
        return cell ?? HouseListTableViewCell.init(frame: .zero)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if dataSourceViewModel.count > 0 {
            return dataSourceViewModel[indexPath.row]?.rowHeight ?? 192
        }else {
            return 192
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.dataSource.count <= 0 {
            return
        }
        if let model = self.dataSource[indexPath.row] as? FangYuanListModel {
            
            ///点击楼盘卡片
            SensorsAnalyticsFunc.clickShow(buildingId: "\(model.id ?? 0)", buildLocation: indexPath.row, isVr: model.isVr ?? false)

            if model.btype == 1 {
                let vc = RenterOfficebuildingDetailVC()
                vc.buildLocation = indexPath.row
                vc.shaiXuanParams = self.getDetailParams()
                vc.buildingModel = model
                self.navigationController?.pushViewController(vc, animated: true)
            }else if model.btype == 2 {
                let vc = RenterOfficeJointDetailVC()
                vc.buildLocation = indexPath.row
                vc.shaiXuanParams = self.getDetailParams()
                vc.buildingModel = model
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = kAppWhiteColor
        view.addSubview(selectview)
        return view
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
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
            return 50
        }else {
            return 0
        }
    }
}


class RenterShaixuanView: UIView {
        
    ///地铁商圈
    lazy var bgview: UIView = {
        let view = UIView()
        view.backgroundColor = kAppLightBlueColor
        return view
    }()
    
    ///地铁商圈
    lazy var subwayBusinessBtn: UIButton = {
        let view = UIButton.init()
        view.tag = 1
        view.clipsToBounds = true
        view.layer.cornerRadius = 9
        view.backgroundColor = kAppBlueColor
        view.titleLabel?.font = FONT_11
        view.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
        return view
    }()
    ///楼盘类型
    lazy var buildingTypeBtn: UIButton = {
        let view = UIButton.init()
        view.tag = 2
        view.clipsToBounds = true
        view.layer.cornerRadius = 9
        view.backgroundColor = kAppBlueColor
        view.titleLabel?.font = FONT_11
        view.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
        return view
    }()
    ///筛选数据
    lazy var shaixuanBtn: UIButton = {
        let view = UIButton.init()
        view.tag = 3
        view.clipsToBounds = true
        view.layer.cornerRadius = 9
        view.backgroundColor = kAppBlueColor
        view.titleLabel?.font = FONT_11
        view.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
        return view
    }()
    
    @objc func btnClick(btn: UIButton) {
        ///商圈地铁清除
        if btn.tag == 1 {
            NotificationCenter.default.post(name: NSNotification.Name.HomeSubwayBusinessClear, object: houseSelectModel)
        }///楼盘类型
        else if btn.tag == 2 {
            NotificationCenter.default.post(name: NSNotification.Name.HomeBuildingTypeClear, object: houseSelectModel)
        }///筛选条件
        else if btn.tag == 3 {
            NotificationCenter.default.post(name: NSNotification.Name.HomeShaixuanClear, object: houseSelectModel)
        }
    }
    var houseSelectModel: HouseSelectModel = HouseSelectModel() {
        didSet {
            
            //商圈地铁
            var subwayBusiniessString: String?
            
            if houseSelectModel.areaModel.selectedCategoryID == "1" {
                
                if let firstLevelModel = self.houseSelectModel.areaModel.areaModelCount.isFirstSelectedModel {
                    
                    var selNum = 0
                    for model in firstLevelModel.list {
                        if model.isSelected ?? false  {
                            selNum += 1
                        }
                    }
                    
                    if selNum > 0 {
                        subwayBusiniessString = "  " + "商圈(\(selNum))  x" + "  "
                    }else {
                        subwayBusiniessString = "  " + "商圈" + "  x" + "  "
                    }
                }else {
                    subwayBusiniessString = ""
                }
                
            }else if houseSelectModel.areaModel.selectedCategoryID == "2" {
                
                if let firstLevelModel = self.houseSelectModel.areaModel.subwayModelCount.isFirstSelectedModel {
                    
                    //地铁线
                    var selNum = 0
                    
                    for model in firstLevelModel.list {
                        if model.isSelected ?? false  {
                            selNum += 1
                        }
                    }
                    if selNum > 0 {
                        subwayBusiniessString = "  " + "地铁(\(selNum))  x" + "  "
                    }else {
                        subwayBusiniessString = "  " + "地铁" + "  x" + "  "
                    }
                }else {
                    subwayBusiniessString = ""
                }
            }
            
            //楼盘类型
            var btypeString: String? //类型,1:楼盘 写字楼,2:网点 共享办公 0全部
            
            if houseSelectModel.typeModel.type == .officeBuildingEnum {
                btypeString = "  " + "写字楼  x" + "  "
                
            }else if houseSelectModel.typeModel.type == .jointOfficeEnum {
                btypeString = "  " + "共享办公  x" + "  "
            }
            
            //筛选条件
            var shaixuanString: String?
        
            if houseSelectModel.shaixuanModel.isShaixuan == true {
               
                //工位数 - 网点要
                if houseSelectModel.typeModel.type == .jointOfficeEnum {
                    
                    if self.houseSelectModel.shaixuanModel.gongweijointOfficeExtentModel.highValue == self.houseSelectModel.shaixuanModel.gongweijointOfficeExtentModel.maximumValue && self.houseSelectModel.shaixuanModel.gongweijointOfficeExtentModel.lowValue == self.houseSelectModel.shaixuanModel.gongweijointOfficeExtentModel.minimumValue {
                        shaixuanString = ""
                    }else {
                        if self.houseSelectModel.shaixuanModel.gongweijointOfficeExtentModel.highValue == self.houseSelectModel.shaixuanModel.gongweijointOfficeExtentModel.maximumValue {
//                            shaixuanString = "  " + String(format: "%.0f", self.houseSelectModel.shaixuanModel.gongweijointOfficeExtentModel.lowValue ?? 0) + "-" + String(format: "%.0f", self.houseSelectModel.shaixuanModel.gongweijointOfficeExtentModel.noLimitNum) + "人" + "  x" + "  "
                            shaixuanString = "  " + String(format: "%.0f", self.houseSelectModel.shaixuanModel.gongweijointOfficeExtentModel.lowValue ?? 0) + "-" + "不限" + "人" + "  x" + "  "

                        }else {
                            shaixuanString = "  " + String(format: "%.0f", self.houseSelectModel.shaixuanModel.gongweijointOfficeExtentModel.lowValue ?? 0) + "-" + String(format: "%.0f", self.houseSelectModel.shaixuanModel.gongweijointOfficeExtentModel.highValue ?? 0) + "人" + "  x" + "  "
                        }
                    }
                    
                }else if houseSelectModel.typeModel.type == .officeBuildingEnum {
                    
                    if self.houseSelectModel.shaixuanModel.mianjiofficeBuildingExtentModel.highValue == self.houseSelectModel.shaixuanModel.mianjiofficeBuildingExtentModel.maximumValue && self.houseSelectModel.shaixuanModel.mianjiofficeBuildingExtentModel.lowValue == self.houseSelectModel.shaixuanModel.mianjiofficeBuildingExtentModel.minimumValue {
                        shaixuanString = ""
                    }else {
                        if self.houseSelectModel.shaixuanModel.mianjiofficeBuildingExtentModel.highValue == self.houseSelectModel.shaixuanModel.mianjiofficeBuildingExtentModel.maximumValue {
//                            shaixuanString = "  " + String(format: "%.0f", self.houseSelectModel.shaixuanModel.mianjiofficeBuildingExtentModel.lowValue ?? 0) + "-" + String(format: "%.0f", self.houseSelectModel.shaixuanModel.mianjiofficeBuildingExtentModel.noLimitNum) + "m²" + "  x" + "  "
                            shaixuanString = "  " + String(format: "%.0f", self.houseSelectModel.shaixuanModel.mianjiofficeBuildingExtentModel.lowValue ?? 0) + "-" + "不限" + "m²" + "  x" + "  "

                        }else {
                            shaixuanString = "  " + String(format: "%.0f", self.houseSelectModel.shaixuanModel.mianjiofficeBuildingExtentModel.lowValue ?? 0) + "-" + String(format: "%.0f", self.houseSelectModel.shaixuanModel.mianjiofficeBuildingExtentModel.highValue ?? 0) + "m²" + "  x" + "  "
                        }
                    }
                }else {
                    shaixuanString = ""
                }
            }
            
            
            if subwayBusiniessString?.count ?? 0 > 0 {
                subwayBusinessBtn.setTitle(subwayBusiniessString, for: .normal)
                let textRect = subwayBusiniessString?.boundingRect(with: CGSize(width: kWidth, height: 18), options: [.usesLineFragmentOrigin, .usesDeviceMetrics, .usesFontLeading], attributes: [NSAttributedString.Key.font : FONT_11], context: nil)
                let width = (textRect?.width ?? 0) + 10
                subwayBusinessBtn.snp.remakeConstraints { (make) in
                    make.leading.equalToSuperview().offset(left_pending_space_17)
                    make.centerY.equalToSuperview()
                    make.height.equalTo(18)
                    make.width.equalTo(width)
                }
            }else {
                subwayBusinessBtn.setTitle("", for: .normal)
                subwayBusinessBtn.snp.remakeConstraints { (make) in
                    make.leading.equalToSuperview()
                    make.centerY.equalToSuperview()
                    make.height.equalTo(18)
                    make.width.equalTo(0)
                }
            }
            
            if btypeString?.count ?? 0 > 0 {
                buildingTypeBtn.setTitle(btypeString, for: .normal)
                let textRect = btypeString?.boundingRect(with: CGSize(width: kWidth, height: 18), options: [.usesLineFragmentOrigin, .usesDeviceMetrics, .usesFontLeading], attributes: [NSAttributedString.Key.font : FONT_11], context: nil)
                let width = (textRect?.width ?? 0) + 10
                buildingTypeBtn.snp.remakeConstraints { (make) in
                    make.leading.equalTo(subwayBusinessBtn.snp.trailing).offset(left_pending_space_17)
                    make.centerY.equalToSuperview()
                    make.height.equalTo(18)
                    make.width.equalTo(width)
                }
            }else {
                buildingTypeBtn.setTitle("", for: .normal)
                buildingTypeBtn.snp.remakeConstraints { (make) in
                    make.leading.equalTo(subwayBusinessBtn.snp.trailing)
                    make.centerY.equalToSuperview()
                    make.height.equalTo(18)
                    make.width.equalTo(0)
                }
            }
            
            if shaixuanString?.count ?? 0 > 0 {
                shaixuanBtn.setTitle(shaixuanString, for: .normal)
                let textRect = shaixuanString?.boundingRect(with: CGSize(width: kWidth, height: 18), options: [.usesLineFragmentOrigin, .usesDeviceMetrics, .usesFontLeading], attributes: [NSAttributedString.Key.font : FONT_11], context: nil)
                let width = (textRect?.width ?? 0) + 10
                shaixuanBtn.snp.remakeConstraints { (make) in
                    make.leading.equalTo(buildingTypeBtn.snp.trailing).offset(left_pending_space_17)
                    make.centerY.equalToSuperview()
                    make.height.equalTo(18)
                    make.width.equalTo(width)
                }
            }else {
                shaixuanBtn.setTitle("", for: .normal)
                shaixuanBtn.snp.remakeConstraints { (make) in
                    make.leading.equalTo(buildingTypeBtn.snp.trailing)
                    make.centerY.equalToSuperview()
                    make.height.equalTo(18)
                    make.width.equalTo(0)
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
          super.init(coder: aDecoder)
      }
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.frame = frame
        
        self.backgroundColor = kAppWhiteColor
        
        self.clipsToBounds = true
        
        bgview.layer.cornerRadius = 26 / 2.0
        
        addSubview(bgview)
        bgview.addSubview(subwayBusinessBtn)
        bgview.addSubview(buildingTypeBtn)
        bgview.addSubview(shaixuanBtn)
        
        bgview.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(26)
        }
        
        subwayBusinessBtn.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(18)
        }
        
        buildingTypeBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(subwayBusinessBtn.snp.trailing).offset(left_pending_space_17)
            make.centerY.equalToSuperview()
            make.height.equalTo(18)
        }
        
        shaixuanBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(buildingTypeBtn.snp.trailing).offset(left_pending_space_17)
            make.centerY.equalToSuperview()
            make.height.equalTo(18)
        }
    }
}

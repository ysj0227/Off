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
            loadNewData()
        }
    }
    
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
        var btype: Int? //类型,1:楼盘 写字楼,2:网点 联合办公 0全部
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
            
            //联合办公
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
        var btype: Int? //类型,1:楼盘 写字楼,2:网点 联合办公 0全部
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
            //联合办公
            if btype == 2 {
                
                if self.recommendSelectModel.shaixuanModel.gongweijointOfficeExtentModel.highValue == self.recommendSelectModel.shaixuanModel.gongweijointOfficeExtentModel.maximumValue {
//                    gongweiExtentStr = String(format: "%.0f", self.recommendSelectModel.shaixuanModel.gongweijointOfficeExtentModel.lowValue ?? 0) + "," + String(format: "%.0f", self.recommendSelectModel.shaixuanModel.gongweijointOfficeExtentModel.noLimitNum)
                }else {
                    gongweiExtentStr = String(format: "%.0f", self.recommendSelectModel.shaixuanModel.gongweijointOfficeExtentModel.lowValue ?? 0) + "," + String(format: "%.0f", self.recommendSelectModel.shaixuanModel.gongweijointOfficeExtentModel.highValue ?? 0)
                }
                
                params["seats"] = gongweiExtentStr as AnyObject?
                
                if self.recommendSelectModel.shaixuanModel.zujinjointOfficeExtentModel.highValue == self.recommendSelectModel.shaixuanModel.zujinjointOfficeExtentModel.maximumValue {
//                    zujinExtentStr = String(format: "%.0f", self.recommendSelectModel.shaixuanModel.zujinjointOfficeExtentModel.lowValue ?? 0) + "," + String(format: "%.0f", self.recommendSelectModel.shaixuanModel.zujinjointOfficeExtentModel.noLimitNum)
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
//                    zujinExtentStr = String(format: "%.0f", self.recommendSelectModel.shaixuanModel.zujinofficeBuildingExtentModel.lowValue ?? 0) + "," + String(format: "%.0f", self.recommendSelectModel.shaixuanModel.zujinofficeBuildingExtentModel.noLimitNum)
                }else {
                    zujinExtentStr = String(format: "%.0f", self.recommendSelectModel.shaixuanModel.zujinofficeBuildingExtentModel.lowValue ?? 0) + "," + String(format: "%.0f", self.recommendSelectModel.shaixuanModel.zujinofficeBuildingExtentModel.highValue ?? 0)
                }
                
                //办公室 - 面积传值
                var mianjiStr: String?
                    
                if self.recommendSelectModel.shaixuanModel.mianjiofficeBuildingExtentModel.highValue == self.recommendSelectModel.shaixuanModel.mianjiofficeBuildingExtentModel.maximumValue {
//                    mianjiStr = String(format: "%.0f", self.recommendSelectModel.shaixuanModel.mianjiofficeBuildingExtentModel.lowValue ?? 0) + "," + String(format: "%.0f", self.recommendSelectModel.shaixuanModel.mianjiofficeBuildingExtentModel.noLimitNum)
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
        
        return params
    }
    
}

extension RenterFangYuanListViewController {
    
    func requestSet() {
        
        isShowRefreshHeader = false
        
        self.tableView.register(HouseListTableViewCell.self, forCellReuseIdentifier: HouseListTableViewCell.reuseIdentifierStr)
        
        self.tableView.snp.remakeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-kStatusBarHeight)
        }
        
        refreshData()
    }
    
    
}

extension RenterFangYuanListViewController {
    
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
            if model.btype == 1 {
                let vc = RenterOfficebuildingDetailVC()
                vc.shaiXuanParams = self.getDetailParams()
                vc.buildingModel = model
                self.navigationController?.pushViewController(vc, animated: true)
            }else if model.btype == 2 {
                let vc = RenterOfficeJointDetailVC()
                vc.shaiXuanParams = self.getDetailParams()
                vc.buildingModel = model
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }
}


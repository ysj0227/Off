//
//  SearchResultListViewController.swift
//  OfficeGo
//
//  Created by mac on 2020/5/15.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit
import HandyJSON
import SwiftyJSON

class SearchResultListViewController: BaseTableViewController {
    
    var dataSourceViewModel: [FangYuanListViewModel?] = []

    var searchString: String = "" {
        //搜索接口
        //设置上面button的title
        didSet {
            titleview?.searchBarBtnTitleLabel?.text = searchString
        }
    }
    
    var selectView: HouseSelectBtnView = {
        let view = HouseSelectBtnView.init(frame: CGRect(x: 0, y: kNavigationHeight, width: kWidth, height: 60))
        view.hiddenArea = false
        return view
    }()
    
    var recommendSelectModel: HouseSelectModel = HouseSelectModel() {
        didSet {
            loadNewData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        selectView.removeShowView()
    }
    
    func setDataModel() {
        
        request_getDistrict()
        
        requestGetFeature()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDataModel()
        setupView()
    }
    
    func setupView() {
        titleview = ThorNavigationView.init(type: .homeBackSearchRightBlue)
        titleview?.searchBarBtnTitleLabel?.text = searchString
        self.view.addSubview(titleview ?? ThorNavigationView.init(type: .homeSearchRightBlue))
        self.view.bringSubviewToFront(titleview ?? ThorNavigationView.init(type: .homeSearchRightBlue))
        titleview?.leftButtonCallBack = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        titleview?.rightBtnClickBlock = { [weak self] in
            self?.navigationController?.popViewController(animated: false)
        }
        
        //设置筛选条件推荐
        selectView.selectModel = recommendSelectModel
        
        //首页头部 - 筛选操作 - 判断是推荐还是附近 - 然后刷新数据
        selectView.sureButtonButtonCallBack = { [weak self] (_ isNearby: Bool, _ selectModel: HouseSelectModel) -> Void in
            self?.recommendSelectModel = selectModel
        }
        self.view.addSubview(selectView)
        self.tableView.snp.updateConstraints { (make) in
            make.top.equalToSuperview().offset(selectView.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        requestSet()

    }
    
    //MARK: 获取列表数据
    override func refreshData() {
         
         if pageNo == 1 {
             if self.dataSourceViewModel.count > 0 {
                self.dataSourceViewModel.removeAll()
             }
         }
        
        var params = [String:AnyObject]()
        
        params["token"] = UserTool.shared.user_token as AnyObject?
        
        params["keyWord"] = searchString as AnyObject?

        
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
            
            //房源特色 - 两者都有
            var featureArr: [String] = []
            
            //联合办公
            if btype == 2 {
                
                gongweiExtentStr = String(format: "%.0f", self.recommendSelectModel.shaixuanModel.gongweijointOfficeExtentModel.lowValue ?? 0) + "," + String(format: "%.0f", self.recommendSelectModel.shaixuanModel.gongweijointOfficeExtentModel.highValue ?? 0)
                
                params["seats"] = gongweiExtentStr as AnyObject?

                zujinExtentStr = String(format: "%.0f", self.recommendSelectModel.shaixuanModel.zujinjointOfficeExtentModel.lowValue ?? 0) + "," + String(format: "%.0f", self.recommendSelectModel.shaixuanModel.zujinjointOfficeExtentModel.highValue ?? 0)
                
                //房源特色 - 两者都有
                for model in self.recommendSelectModel.shaixuanModel.featureModelArr {
                    if model.isOfficejointOfficeSelected {
                        featureArr.append("\(model.dictValue ?? 0)")
                    }
                }
                
            }else if btype == 1 {
                                
                zujinExtentStr = String(format: "%.0f", self.recommendSelectModel.shaixuanModel.zujinofficeBuildingExtentModel.lowValue ?? 0) + "," + String(format: "%.0f", self.recommendSelectModel.shaixuanModel.zujinofficeBuildingExtentModel.highValue ?? 0)
                
                //办公室 - 面积传值
                let mianjiStr: String = String(format: "%.0f", self.recommendSelectModel.shaixuanModel.mianjiofficeBuildingExtentModel.lowValue ?? 0) + "," + String(format: "%.0f", self.recommendSelectModel.shaixuanModel.mianjiofficeBuildingExtentModel.highValue ?? 0)
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
                
                //房源特色 - 两者都有
                for model in self.recommendSelectModel.shaixuanModel.featureModelArr {
                    if model.isOfficeBuildingSelected {
                        featureArr.append("\(model.dictValue ?? 0)")
                    }
                }
            }
            
            params["dayPrice"] = zujinExtentStr as AnyObject?
            
            //房源特色 - 两者都有
            let featureStr: String = featureArr.joined(separator: ",")
            params["houseTags"] = featureStr as AnyObject?
        }
        
        params["pageNo"] = self.pageNo as AnyObject
        params["pageSize"] = self.pageSize as AnyObject
        
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
}

extension SearchResultListViewController {
    
    func requestSet() {
        
        isShowRefreshHeader = false
        
        self.tableView.register(HouseListTableViewCell.self, forCellReuseIdentifier: HouseListTableViewCell.reuseIdentifierStr)

        refreshData()
    }
    
    
}

extension SearchResultListViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HouseListTableViewCell.reuseIdentifierStr) as? HouseListTableViewCell
        cell?.selectionStyle = .none
        if self.dataSource.count > 0 {
            if let model = self.dataSource[indexPath.row]  {
                cell?.model = model as! FangYuanListModel
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
                vc.buildingModel = model
                self.navigationController?.pushViewController(vc, animated: true)
            }else if model.btype == 2 {
                let vc = RenterOfficeJointDetailVC()
                vc.buildingModel = model
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }
}



//MARK: 接口处理
extension SearchResultListViewController {
    
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
                }
            }
            //            weakSelf.setModelShow()
            
            }, failure: { (error) in
                //            self?.setModelShow()
        }) { (code, message) in
            //            self?.setModelShow()
            
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
}

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
    
    var selectModel: HouseSelectModel = HouseSelectModel() {
        didSet {
            self.tableView.reloadData()
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
        self.view.addSubview(titleview ?? ThorNavigationView.init(type: .homeSearchRightBlue))
        self.view.bringSubviewToFront(titleview ?? ThorNavigationView.init(type: .homeSearchRightBlue))
        titleview?.leftButtonCallBack = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        titleview?.rightBtnClickBlock = { [weak self] in
            self?.navigationController?.popViewController(animated: false)
        }
        
        //设置筛选条件推荐
        selectView.selectModel = selectModel
        
        //首页头部 - 筛选操作 - 判断是推荐还是附近 - 然后刷新数据
        selectView.sureButtonButtonCallBack = { [weak self] (_ isNearby: Bool, _ selectModel: HouseSelectModel) -> Void in
            self?.selectModel = selectModel
        }
        self.view.addSubview(selectView)
        self.tableView.snp.updateConstraints { (make) in
            make.top.equalToSuperview().offset(selectView.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
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
                self?.selectModel.areaModel.areaModelCount = model
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
                self?.selectModel.areaModel.subwayModelCount = model
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
                    weakSelf.selectModel.shaixuanModel.documentTypeModelArr.append(model ?? HouseFeatureModel())
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
                    weakSelf.selectModel.shaixuanModel.featureModelArr.append(model ?? HouseFeatureModel())
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

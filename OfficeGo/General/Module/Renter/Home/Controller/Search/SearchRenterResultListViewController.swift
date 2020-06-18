//
//  ESearchRenterResultListViewController.swift
//  OfficeGo
//
//  Created by mac on 2020/6/5.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit
import HandyJSON
import SwiftyJSON

class ESearchRenterResultListViewController: BaseTableViewController {
    
    /// 点击cell回调闭包
    var callBack: (FangYuanListModel) -> () = {_ in }
    
    var keywords: String? = "" {
        didSet {
            dataSource.removeAll()
            refreshData()
        }
    }
    
    override func noDataViewSet() {
        noDataView.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestSet()
        
    }
    //MARK: 获取首页列表数据
    override func refreshData() {
        var params = [String:AnyObject]()
        
        params["keywords"] = keywords as AnyObject
        SSNetworkTool.SSSearch.request_getsearchList(params: params, success: { [weak self] (response) in
            guard let weakSelf = self else {return}
            if let decoratedArray = JSONDeserializer<FangYuanSearchResultModel>.deserializeModelArrayFrom(json: JSON(response).rawString() ?? "", designatedPath: "data") {
                weakSelf.dataSource = decoratedArray
                weakSelf.tableView.reloadData()
            }
            
            }, failure: {[weak self] (error) in
                guard let weakSelf = self
                    else {return}
                
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

extension ESearchRenterResultListViewController {
    
    @objc func requestSet() {
        
        isShowRefreshHeader = true
        
        self.tableView.register(SearchResultTableViewCell.self, forCellReuseIdentifier: SearchResultTableViewCell.reuseIdentifierStr)
        
    }
    
    
}

extension ESearchRenterResultListViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.reuseIdentifierStr) as? SearchResultTableViewCell
        cell?.selectionStyle = .none
        if self.dataSource.count > 0 {
            if let model = self.dataSource[indexPath.row]  {
                cell?.model = model as? FangYuanSearchResultModel
            }
        }
        return cell ?? SearchResultTableViewCell.init(frame: .zero)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return SearchResultTableViewCell.rowHeight()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.dataSource.count <= 0 {
            return
        }
        if let model = self.dataSource[indexPath.row] as? FangYuanSearchResultModel {
            let buildingModel = FangYuanListModel()
            buildingModel.btype = model.buildType
            buildingModel.id = model.bid
            // 点击cell调用闭包
            callBack(buildingModel)
        }
        
    }
}


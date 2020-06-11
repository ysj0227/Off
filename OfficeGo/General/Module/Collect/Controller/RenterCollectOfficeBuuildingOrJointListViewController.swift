//
//  RenterCollectOfficeBuuildingOrJointListViewController.swift
//  OfficeGo
//
//  Created by mac on 2020/5/14.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit
import HandyJSON
import SwiftyJSON

class RenterCollectOfficeBuuildingOrJointListViewController: BaseTableViewController {
    
    //1为楼盘网点收藏，2为房源收藏
    var type: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestSet()
        
    }
    //MARK: 获取首页列表数据
    override func refreshData() {
        var params = [String:AnyObject]()
        
        params["token"] = UserTool.shared.user_token as AnyObject
        params["longitude"] = "" as AnyObject
        params["latitude"] = "" as AnyObject
        params["pageNo"] = self.pageNo as AnyObject
        params["pageSize"] = self.pageSize as AnyObject
        params["type"] = self.type as AnyObject
        SSNetworkTool.SSCollect.request_getFavoriteListAPP(params: params, success: { [weak self] (response) in
            guard let weakSelf = self else {return}
            if let decoratedArray = JSONDeserializer<FangYuanListModel>.deserializeModelArrayFrom(json: JSON(response["data"] ?? "").rawString() ?? "", designatedPath: "list") {
                weakSelf.dataSource = weakSelf.dataSource + decoratedArray
                weakSelf.endRefreshWithCount(decoratedArray.count)
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

extension RenterCollectOfficeBuuildingOrJointListViewController {
    
    @objc func requestSet() {
        
        isShowRefreshHeader = false
        
        self.tableView.register(UINib.init(nibName: HouseListTableViewCell.reuseIdentifierStr, bundle: nil), forCellReuseIdentifier: HouseListTableViewCell.reuseIdentifierStr)
        
        self.type = 1
        
        refreshData()
    }
    
    
}

extension RenterCollectOfficeBuuildingOrJointListViewController {
    
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
        
        return HouseListTableViewCell.rowHeight()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.dataSource.count <= 0 {
            return
        }
        if let model = self.dataSource[indexPath.row] as? FangYuanListModel {
            if let Isfailure = model.Isfailure {
                if Isfailure == 1 {
                    let vc = RenterOfficebuildingJointDetailVC()
                    vc.shaiXuanParams = [:]
                    vc.buildingModel = model
                    self.navigationController?.pushViewController(vc, animated: true)
                }else if Isfailure == 0 {
                    AppUtilities.makeToast(SSCode.ERROR_CODE_7012.msg)
                }else if Isfailure == 4 {
                    AppUtilities.makeToast(SSCode.ERROR_CODE_7013.msg)
                }else if Isfailure == 5 {
                    AppUtilities.makeToast(SSCode.ERROR_CODE_7014.msg)
                }
            }
            
        }
        
    }
}


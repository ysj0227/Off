//
//  RenterCollectOfficeListViewController.swift
//  OfficeGo
//
//  Created by mac on 2020/5/14.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit
import HandyJSON
import SwiftyJSON

class RenterCollectOfficeListViewController: RenterCollectOfficeBuuildingOrJointListViewController {
    
    override func requestSet() {
        
        isShowRefreshHeader = false
        
        self.tableView.register(RenterCollectOfficeCell.self, forCellReuseIdentifier: RenterCollectOfficeCell.reuseIdentifierStr)
        
        self.type = 2
        
        refreshData()
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
            if let decoratedArray = JSONDeserializer<FangYuanBuildingOpenStationModel>.deserializeModelArrayFrom(json: JSON(response["data"] ?? "").rawString() ?? "", designatedPath: "list") {
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

extension RenterCollectOfficeListViewController {
    
    
    
    
}

extension RenterCollectOfficeListViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RenterCollectOfficeCell.reuseIdentifierStr) as? RenterCollectOfficeCell
        cell?.selectionStyle = .none
        if let model = self.dataSource[indexPath.row] as? FangYuanBuildingOpenStationModel {
            cell?.model = model
        }
        return cell ?? HouseListTableViewCell.init(frame: .zero)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return RenterCollectOfficeCell.rowHeight()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //独立办公室
        if let model = self.dataSource[indexPath.row] as? FangYuanBuildingOpenStationModel {
            if let Isfailure = model.Isfailure {
                if Isfailure == 1 {
                    let vc = RenterOfficebuildingFYDetailVC()
                    vc.model = model
                    self.navigationController?.pushViewController(vc, animated: true)
                }else if Isfailure == 0 {
                    AppUtilities.makeToast(SSCode.ERROR_CODE_7016.msg)
                }else if Isfailure == 4 {
                    AppUtilities.makeToast(SSCode.ERROR_CODE_7013.msg)
                }else if Isfailure == 5 {
                    AppUtilities.makeToast(SSCode.ERROR_CODE_7014.msg)
                }
            }

        }
    }
}

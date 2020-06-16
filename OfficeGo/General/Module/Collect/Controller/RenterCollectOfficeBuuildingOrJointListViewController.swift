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
    
    
    //无数据view
    var nologindataView :NoDataShowView?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        juddgeIsLogin()
    }
    
    ///判断有没有登录
    func juddgeIsLogin() {
        //登录直接请求数据
        if isLogin() == true {
            
            nologindataView?.isHidden = true
            
            refreshData()
            
        }else {
            //没登录 - 显示登录按钮view
            nologindataView?.isHidden = false
            
            if self.dataSource.count > 0 {
                self.dataSource.removeAll()
                self.dataSourceViewModel.removeAll()
                self.tableView.reloadData()
            }
        }
    }
    
    
    var dataSourceViewModel: [FangYuanListViewModel?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestSet()
        
    }
    //MARK: 获取首页列表数据
    override func refreshData() {
        if pageNo == 1 {
            if self.dataSourceViewModel.count > 0 {
                self.dataSourceViewModel.removeAll()
            }
        }
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
                for model in decoratedArray {
                    let viewmodel = FangYuanListViewModel.init(model: model ?? FangYuanListModel())
                    weakSelf.dataSourceViewModel.append(viewmodel)
                }
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
        
        nologindataView = NoDataShowView.init(frame: CGRect(x: 0, y: -kNavigationHeight, width: self.view.width, height: self.view.height - kNavigationHeight))
        nologindataView?.isHidden = true
        self.view.addSubview(nologindataView ?? NoDataShowView(frame: CGRect(x: 0, y: -kNavigationHeight, width: self.view.width, height: self.view.height - kNavigationHeight)))
        
        nologindataView?.loginCallBack = {[weak self] in
            
            guard let weakSelf = self else {return}
            
            weakSelf.showLoginVC()
        }
        
    }
    
    func showLoginVC() {
        let vc = ReviewLoginViewController()
        vc.isFromOtherVC = true
        vc.closeViewBack = {[weak self] (isClose) in
            guard let weakSelf = self else {return}
            weakSelf.juddgeIsLogin()
        }
        let loginNav = BaseNavigationViewController.init(rootViewController: vc)
        loginNav.modalPresentationStyle = .overFullScreen
        //TODO: 这块弹出要设置
        self.present(loginNav, animated: true, completion: nil)
        
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
        
        if dataSourceViewModel.count > indexPath.row {
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
            if let Isfailure = model.Isfailure {
                if Isfailure == 1 {
                    if model.btype == 1 {
                        let vc = RenterOfficebuildingDetailVC()
                        vc.shaiXuanParams = [:]
                        vc.buildingModel = model
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else if model.btype == 2 {
                        let vc = RenterOfficeJointDetailVC()
                        vc.shaiXuanParams = [:]
                        vc.buildingModel = model
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
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


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

class RenterCollectOfficeListViewController: BaseTableViewController {
    
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
            
            loadNewData()
            
        }else {
            //没登录 - 显示登录按钮view
            nologindataView?.isHidden = false
            
            if self.dataSource.count > 0 {
                self.dataSource.removeAll()
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestSet()
    }
    
    func requestSet() {
        
        isShowRefreshHeader = false
        
        self.tableView.register(RenterCollectOfficeCell.self, forCellReuseIdentifier: RenterCollectOfficeCell.reuseIdentifierStr)
        
        self.type = 2
        
        nologindataView = NoDataShowView.init(frame: CGRect(x: 0, y: -kNavigationHeight, width: self.view.width, height: self.view.height - kNavigationHeight))
        nologindataView?.isHidden = true
        self.view.addSubview(nologindataView ?? NoDataShowView(frame: CGRect(x: 0, y: -kNavigationHeight, width: self.view.width, height: self.view.height - kNavigationHeight)))
        
        nologindataView?.loginCallBack = {[weak self] in
            
            guard let weakSelf = self else {return}
            
            weakSelf.showLoginVC()
        }
        
    }
    
    func showLoginVC() {
        let vc = RenterLoginViewController()
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
    
    //MARK: 获取首页列表数据
    override func refreshData() {
        var params = [String:AnyObject]()
        
        params["token"] = UserTool.shared.user_token as AnyObject
        
        params["longitude"] = (UIApplication.shared.delegate as? AppDelegate)?.longitude as AnyObject?
        params["latitude"] = (UIApplication.shared.delegate as? AppDelegate)?.latitude as AnyObject?
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //独立办公室
        if let model = self.dataSource[indexPath.row] as? FangYuanBuildingOpenStationModel {
            if let Isfailure = model.Isfailure {
                if Isfailure == 1 || Isfailure == 3 {
                    if model.btype == 1 {
                        let vc = RenterOfficebuildingFYDetailVC()
                        vc.model = model
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else if model.btype == 2 {
                        let vc = RenterOfficeJointFYDetailVC()
                        vc.model = model
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    
                }else if Isfailure == 0 || Isfailure == 2{
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

//
//  OwnerBuildingNameESearchResultListViewController.swift
//  OfficeGo
//
//  Created by mac on 2020/7/14.
//  Copyright © 2020 Senwei. All rights reserved.
//

import HandyJSON
import SwiftyJSON

class OwnerBuildingNameESearchResultListViewController: BaseTableViewController {
    
    lazy var lineView: UIView = {
        let view = UIView(frame: CGRect(x: kWidth - 60 - left_pending_space_17, y: cell_height_58 - 1, width: 60, height: 1))
        view.backgroundColor = kAppColor_line_EEEEEE
        return view
    }()
    ///点击关闭按钮 - 关闭页面
    var closeButtonCallClick:(() -> Void)?
    
    ///创建回调
    var creatButtonCallClick:(() -> Void)?
    
    /// 点击cell回调闭包
    var buildingCallBack: (OwnerESBuildingSearchViewModel) -> () = {_ in }
    
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
        self.view.backgroundColor = kAppAlphaWhite0_alpha_7
        self.tableView.backgroundColor = kAppClearColor

        requestSet()
        
    }
    //MARK: 获取楼盘网点数据
    override func refreshData() {
        
        if keywords?.isBlankString == true {
            return
        }
        
        var params = [String:AnyObject]()
        params["token"] = UserTool.shared.user_token as AnyObject
        params["keywords"] = keywords as AnyObject
        ///身份类型0个人1企业2联合 - 楼盘和网点一个接口
        
        SSNetworkTool.SSSearch.request_getsearchList(params: params, success: { [weak self] (response) in
            guard let weakSelf = self else {return}
            if let decoratedArray = JSONDeserializer<OwnerESBuildingSearchModel>.deserializeModelArrayFrom(json: JSON(response).rawString() ?? "", designatedPath: "data") {
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

extension OwnerBuildingNameESearchResultListViewController {
    
    @objc func requestSet() {
        
        isShowRefreshHeader = true
        
        self.tableView.register(OwnerBuildingNameESSearchIdentifyCell.self, forCellReuseIdentifier: OwnerBuildingNameESSearchIdentifyCell.reuseIdentifierStr)
    }
}

extension OwnerBuildingNameESearchResultListViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingNameESSearchIdentifyCell.reuseIdentifierStr) as? OwnerBuildingNameESSearchIdentifyCell
        cell?.selectionStyle = .none
        if self.dataSource.count > 0 {
            if let model = self.dataSource[indexPath.row]  {
                cell?.buildingModel = model as? OwnerESBuildingSearchModel
            }
        }
        return cell ?? OwnerBuildingNameESSearchIdentifyCell.init(frame: .zero)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return OwnerBuildingNameESSearchIdentifyCell.rowHeight()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.dataSource.count <= 0 {
            return
        }
        if let model = self.dataSource[indexPath.row] as? OwnerESBuildingSearchModel {
            // 点击cell调用闭包
            let viewModel = OwnerESBuildingSearchViewModel.init(model: model)
            buildingCallBack(viewModel)
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = OwnerCreateView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.width, height: cell_height_58))
        view.isNewIdentifyES = true
        view.creatButtonCallClick = { [weak self] in
            guard let blockk = self?.creatButtonCallClick else {
                return
            }
            blockk()
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return cell_height_58
    }
}

//
//  OwnerBuildingJointESSearchViewController.swift
//  OfficeGo
//
//  Created by Mac pro on 2020/11/6.
//  Copyright © 2020 Senwei. All rights reserved.
//

import HandyJSON
import SwiftyJSON

class OwnerBuildingJointESSearchViewController: BaseTableViewController {
    
    ///房源管理 - 写字楼展示
    var isManagerBuilding: Bool? = false
    
    ///房源管理 - 网点无数据展示
    var isManagerBranch: Bool? = false
    
    let topView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: kWidth, height: cell_height_58))
        view.backgroundColor = kAppWhiteColor
        return view
    }()
    
    lazy var descLabel: UILabel = {
        let view = UILabel(frame: CGRect(x: left_pending_space_17, y: 0, width: kWidth - left_pending_space_17 - cell_height_30, height: cell_height_58))
        view.textAlignment = .left
        view.font = FONT_13
        view.isHidden = true
        view.text = "楼盘不存在"
        view.textColor = kAppColor_999999
        return view
    }()
    
    lazy var closeBtn: UIButton = {
        let view = UIButton(frame: CGRect(x: kWidth - 60 - left_pending_space_17, y: 0, width: 60, height: cell_height_58))
        view.setTitleColor(kAppBlueColor, for: .normal)
        view.setTitle("创建楼盘", for: .normal)
        view.titleLabel?.font = FONT_13
        return view
    }()
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
    //MARK: 获取首页列表数据
    override func refreshData() {
        
        if keywords?.isBlankString == true {
            return
        }
        
        var params = [String:AnyObject]()
        params["token"] = UserTool.shared.user_token as AnyObject
        params["keywords"] = keywords as AnyObject
        
        
        if isManagerBuilding == true {

            SSNetworkTool.SSOwnerIdentify.request_getESBuild(params: params, success: { [weak self] (response) in
                guard let weakSelf = self else {return}
                if let decoratedArray = JSONDeserializer<OwnerESBuildingSearchModel>.deserializeModelArrayFrom(json: JSON(response).rawString() ?? "", designatedPath: "data") {
                    weakSelf.dataSource = decoratedArray
                    if weakSelf.dataSource.count > 0 {
                        weakSelf.descLabel.isHidden = true
                    }else {
                        weakSelf.descLabel.isHidden = false
                    }
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
        }else if isManagerBranch == true {

            SSNetworkTool.SSOwnerIdentify.request_getESBranch(params: params, success: { [weak self] (response) in
                guard let weakSelf = self else {return}
                if let decoratedArray = JSONDeserializer<OwnerESBuildingSearchModel>.deserializeModelArrayFrom(json: JSON(response).rawString() ?? "", designatedPath: "data") {
                    weakSelf.dataSource = decoratedArray
                    if weakSelf.dataSource.count > 0 {
                        weakSelf.descLabel.isHidden = true
                    }else {
                        weakSelf.descLabel.isHidden = false
                    }
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
    
}

extension OwnerBuildingJointESSearchViewController {
    
    @objc func requestSet() {
        
        isShowRefreshHeader = true
        
        self.tableView.register(OwnerBuildingNameESSearchIdentifyCell.self, forCellReuseIdentifier: OwnerBuildingNameESSearchIdentifyCell.reuseIdentifierStr)
            
        topView.addSubview(descLabel)
        topView.addSubview(closeBtn)
        topView.addSubview(lineView)
        closeBtn.addTarget(self, action: #selector(closeVC), for: .touchUpInside)
    }

    //关闭按钮
    @objc func closeVC() {
        guard let blockk = closeButtonCallClick else {
            return
        }
        blockk()
    }
}

extension OwnerBuildingJointESSearchViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingNameESSearchIdentifyCell.reuseIdentifierStr) as? OwnerBuildingNameESSearchIdentifyCell
        cell?.selectionStyle = .none
        cell?.isManagerBuilding = isManagerBuilding
        cell?.isManagerBranch = isManagerBranch
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
        if isManagerBuilding == true {
            view.isManagerBuilding = true
        }else if isManagerBranch == true {
            view.isManagerBranch = true
        }else {
            view.isBuilding = true
        }
        view.creatButtonCallClick = { [weak self] in
            guard let blockk = self?.creatButtonCallClick else {
                return
            }
            blockk()
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if UserTool.shared.user_owner_identifytype == 2 {
            return 0
        }else {
            return cell_height_58
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return topView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if UserTool.shared.user_owner_identifytype == 2 {
            return cell_height_58
        }else {
            return 0
        }
    }
}


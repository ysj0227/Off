//
//  OwnerCompanyESearchResultListViewController.swift
//  OfficeGo
//
//  Created by mac on 2020/7/14.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit
import HandyJSON
import SwiftyJSON

class OwnerCompanyESearchResultListViewController: BaseTableViewController {
    
    var isBranch: Bool? = false
    
    ///创建回调
    var creatButtonCallClick:(() -> Void)?
    
    /// 点击cell回调闭包
    var companyCallBack: (OwnerESCompanySearchViewModel) -> () = {_ in }
    
    ///网点搜索回调
    var branchCallBack: (OwnerESBuildingSearchViewModel) -> () = {_ in }

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
        
        if keywords?.isBlankString == true {
            return
        }
        
        var params = [String:AnyObject]()
        params["token"] = UserTool.shared.user_token as AnyObject
        params["keywords"] = keywords as AnyObject
        if UserTool.shared.user_owner_identifytype == 2 {
            //网点
            if isBranch == true {
                SSNetworkTool.SSOwnerIdentify.request_getESBranch(params: params, success: { [weak self] (response) in
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
            }else {
                //网点公司名字搜索
                SSNetworkTool.SSOwnerIdentify.request_getESCompany(params: params, success: { [weak self] (response) in
                    guard let weakSelf = self else {return}
                    if let decoratedArray = JSONDeserializer<OwnerESCompanySearchModel>.deserializeModelArrayFrom(json: JSON(response).rawString() ?? "", designatedPath: "data") {
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
            
        }else {
            SSNetworkTool.SSOwnerIdentify.request_getESCompany(params: params, success: { [weak self] (response) in
                guard let weakSelf = self else {return}
                if let decoratedArray = JSONDeserializer<OwnerESCompanySearchModel>.deserializeModelArrayFrom(json: JSON(response).rawString() ?? "", designatedPath: "data") {
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
    
}

extension OwnerCompanyESearchResultListViewController {
    
    @objc func requestSet() {
        
        self.view.backgroundColor = kAppColor_bgcolor_F7F7F7
        
        self.tableView.backgroundColor = kAppColor_bgcolor_F7F7F7
        
        isShowRefreshHeader = true
        
        self.tableView.register(OwnerCompanyESSearchIdentifyCell.self, forCellReuseIdentifier: OwnerCompanyESSearchIdentifyCell.reuseIdentifierStr)
        
    }
    
    
}

extension OwnerCompanyESearchResultListViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OwnerCompanyESSearchIdentifyCell.reuseIdentifierStr) as? OwnerCompanyESSearchIdentifyCell
        cell?.isBranch = isBranch
        cell?.selectionStyle = .none
        if isBranch == true {
            if self.dataSource.count > 0 {
                       if let model = self.dataSource[indexPath.row]  {
                           cell?.buildingModel = model as? OwnerESBuildingSearchModel
                       }
                   }
        }else {
            if self.dataSource.count > 0 {
                       if let model = self.dataSource[indexPath.row]  {
                           cell?.companyModel = model as? OwnerESCompanySearchModel
                       }
                   }
        }
       
        return cell ?? OwnerCompanyESSearchIdentifyCell.init(frame: .zero)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return OwnerCompanyESSearchIdentifyCell.rowHeight()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.dataSource.count <= 0 {
            return
        }
        if isBranch == true {
            if let model = self.dataSource[indexPath.row] as? OwnerESBuildingSearchModel {
                // 点击cell调用闭包
                let viewModel = OwnerESBuildingSearchViewModel.init(model: model)
                branchCallBack(viewModel)
            }
        }else {
            if let model = self.dataSource[indexPath.row] as? OwnerESCompanySearchModel {
                // 点击cell调用闭包
                let viewModel = OwnerESCompanySearchViewModel.init(model: model)
                companyCallBack(viewModel)
            }
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = OwnerCreateView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.width, height: cell_height_58))
        view.isBranch = isBranch
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

class OwnerCreateView: UIView {
    
    lazy var descLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_LIGHT_13
        view.text = ""
        view.textColor = kAppColor_999999
        return view
    }()
    
    lazy var creatBtn: UIButton = {
        let view = UIButton()
        view.setTitleColor(kAppBlueColor, for: .normal)
        view.setTitle("", for: .normal)
        view.titleLabel?.font = FONT_12
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    
    ///公司或者网点无数据展示
    var isBranch: Bool? = false {
        didSet {
            ///身份类型0个人1企业2联合
            //个人没有公司
            if UserTool.shared.user_owner_identifytype == 0 {
                descLabel.text = ""
                creatBtn.setTitle("", for: .normal)
            }
            else if UserTool.shared.user_owner_identifytype == 1 {
                descLabel.text = "公司不存在，去创建公司"
                creatBtn.setTitle("创建公司", for: .normal)
            }
            else if UserTool.shared.user_owner_identifytype == 2 {
                if self.isBranch == true {
                    descLabel.text = "网点不存在，去创建网点"
                    creatBtn.setTitle("创建网点", for: .normal)
                }else {
                    descLabel.text = "公司不存在，去创建公司"
                    creatBtn.setTitle("创建公司", for: .normal)
                }
                
            }
        }
        
    }
    
    ///写字楼展示
    var isBuilding: Bool? = false {
        didSet {
            ///身份类型0个人1企业2联合
            if UserTool.shared.user_owner_identifytype == 0 {
                descLabel.text = "写字楼不存在，去创建写字楼"
                creatBtn.setTitle("创建写字楼", for: .normal)
            }else if UserTool.shared.user_owner_identifytype == 1 {
                descLabel.text = "写字楼不存在，去创建写字楼"
                creatBtn.setTitle("创建写字楼", for: .normal)
            }
                //联合办公没有写字楼创建按钮
            else if UserTool.shared.user_owner_identifytype == 2 {
                descLabel.text = ""
                creatBtn.setTitle("", for: .normal)
            }
        }
        
    }
    
    ///创建回调
    var creatButtonCallClick:(() -> Void)?
    
    private func setupView() {
        
        self.backgroundColor = kAppWhiteColor
        
        
        addSubview(descLabel)
        addSubview(creatBtn)
        creatBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(-left_pending_space_17)
            make.top.bottom.equalToSuperview()
        }
        
        descLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(left_pending_space_17)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(-(60 + left_pending_space_17))
        }
        
        creatBtn.addTarget(self, action: #selector(creatBtnClick), for: .touchUpInside)
    }
    
    @objc func creatBtnClick() {
        guard let blockk = creatButtonCallClick else {
            return
        }
        blockk()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
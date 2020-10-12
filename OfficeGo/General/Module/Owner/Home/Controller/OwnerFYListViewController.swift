//
//  OwnerFYListViewController.swift
//  OfficeGo
//
//  Created by Mac pro on 2020/9/28.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit
import HandyJSON
import SwiftyJSON

class OwnerFYListViewController: BaseTableViewController {
            
    var dataSourceViewModel: [FangYuanListViewModel?] = []
    
    lazy var ownerFYMoreSettingView: OwnerFYMoreSettingView = {
        let view = OwnerFYMoreSettingView.init(frame: CGRect(x: 0.0, y: 0, width: kWidth, height: kHeight))
        return view
    }()
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let tab = self.navigationController?.tabBarController as? OwnerMainTabBarController
        tab?.customTabBar.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let tab = self.navigationController?.tabBarController as? OwnerMainTabBarController
        tab?.customTabBar.isHidden = false
                
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
    }

    //MARK: 获取首页列表数据
    override func refreshData() {
        
        requestHouseList()
    }
    
    
    func requestHouseList() {
        if pageNo == 1 {
            if self.dataSourceViewModel.count > 0 {
                self.dataSourceViewModel.removeAll()
            }
        }
        
        var params = [String:AnyObject]()
        
        params["token"] = UserTool.shared.user_token as AnyObject?
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

extension OwnerFYListViewController {
    
    func setUpView() {
                
        titleview = ThorNavigationView.init(type: .backTitleRight)
        //设置背景颜色为蓝色 文字白色 -
        titleview?.backgroundColor = kAppBlueColor
        titleview?.backTitleRightView.backgroundColor = kAppClearColor
        titleview?.titleLabel.textColor = kAppWhiteColor
        titleview?.rightButton.setTitleColor(kAppWhiteColor, for: .normal)
        titleview?.rightButton.snp.remakeConstraints { (make) in
            make.trailing.equalToSuperview()
            make.width.equalTo(65)
            make.top.bottom.equalToSuperview()
        }
        titleview?.rightButton.setImage(UIImage.init(named: "addBlue"), for: .normal)
        titleview?.leftButton.isHidden = true
        titleview?.rightButton.isHidden = false
        titleview?.rightButton.layoutButton(.imagePositionRight, margin: 2)
        titleview?.titleLabel.text = "房源列表"
        titleview?.rightBtnClickBlock = { [weak self] in
            let vc = OwnerBuildingCreateViewController()
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        self.view.addSubview(titleview ?? ThorNavigationView.init(type: .backTitleRight))

        requestSet()
    }
    
    func requestSet() {
        
        isShowRefreshHeader = false
        
        self.view.backgroundColor = kAppColor_bgcolor_F7F7F7
        
        self.tableView.backgroundColor = kAppColor_bgcolor_F7F7F7
        
        self.tableView.snp.remakeConstraints { (make) in
            make.top.equalTo(kNavigationHeight + 7)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-kTabBarHeight)
        }
        self.tableView.register(OwnerFYListCell.self, forCellReuseIdentifier: OwnerFYListCell.reuseIdentifierStr)
        
        refreshData()
        
    }
    
    
}

extension OwnerFYListViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OwnerFYListCell.reuseIdentifierStr) as? OwnerFYListCell
        cell?.selectionStyle = .none
        if self.dataSource.count > 0 {
            if let model = self.dataSource[indexPath.row]  {
                cell?.model = model as? FangYuanListModel ?? FangYuanListModel()
                cell?.moreBtnClickBlock = { [weak self] in
                    self?.ownerFYMoreSettingView.ShowOwnerFYMoreSettingView(datasource: [OWnerFYMoreSettingEnum.xiaJiaEnum.rawValue, OWnerFYMoreSettingEnum.deleteEnum.rawValue, OWnerFYMoreSettingEnum.sharepEnum.rawValue], clearButtonCallBack: {
                        
                    }) { (settingEnumIndex) in
                        SSLog("-----点击的是---\(settingEnumIndex)")
                    }
                }
            }
        }
        return cell ?? OwnerFYListCell.init(frame: .zero)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return OwnerFYListCell.rowHeight()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.dataSource.count <= 0 {
            return
        }
        if let model = self.dataSource[indexPath.row] as? FangYuanListModel {
            
            if model.btype == 1 {
                let vc = RenterOfficebuildingDetailVC()
                vc.buildLocation = indexPath.row
                vc.buildingModel = model
                self.navigationController?.pushViewController(vc, animated: true)
            }else if model.btype == 2 {
                let vc = RenterOfficeJointDetailVC()
                vc.buildLocation = indexPath.row
                vc.buildingModel = model
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = kAppWhiteColor
        return view
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    
        return 0
    }
}




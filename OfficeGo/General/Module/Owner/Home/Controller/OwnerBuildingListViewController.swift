//
//  OwnerBuildingListViewController.swift
//  OfficeGo
//
//  Created by Mac pro on 2020/10/21.
//  Copyright © 2020 Senwei. All rights reserved.
//
import UIKit
import HandyJSON
import SwiftyJSON

class OwnerBuildingListViewController: BaseTableViewController {
            
    var dataSourceViewModel: [OwnerBuildingListViewModel?] = []
    
    lazy var ownerFYMoreSettingView: OwnerFYMoreSettingView = {
        let view = OwnerFYMoreSettingView.init(frame: CGRect(x: 0.0, y: 0, width: kWidth, height: kHeight))
        return view
    }()
    
    var titleLabel : UIView = {
        let view = UIView()
        view.backgroundColor = kAppWhiteColor
        let label = UILabel(frame: CGRect(x: left_pending_space_17, y: 5, width: kWidth - left_pending_space_17 * 2, height: 30))
        label.textColor = kAppColor_999999
        label.font = FONT_14
        label.text = "楼盘"
        view.addSubview(label)
        return view
    }()
    
    
    var addBottomView : UIView = {
        let view = UIView()
        view.backgroundColor = kAppColor_bgcolor_F7F7F7
        return view
    }()
    
    var addButton : UIButton = {
        let addButton = UIButton(frame: CGRect(x: 0, y: 18, width: kWidth, height: 91))
        addButton.backgroundColor = kAppWhiteColor
        addButton.setImage(UIImage.init(named: "addCircle"), for: .normal)
        addButton.setTitle("添加楼盘", for: .normal)
        addButton.setTitleColor(kAppColor_999999, for: .normal)
        addButton.titleLabel?.font = FONT_14
        addButton.layoutButton(.imagePositionTop, space: 10)
        return addButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        
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
        params["type"] = 2 as AnyObject

        SSNetworkTool.SSHome.request_getselectBuildingApp(params: params, success: { [weak self] (response) in
            guard let weakSelf = self else {return}
            if let decoratedArray = JSONDeserializer<OwnerBuildingListModel>.deserializeModelArrayFrom(json: JSON(response["data"] ?? "").rawString() ?? "", designatedPath: "list") {
                weakSelf.dataSource = weakSelf.dataSource + decoratedArray
                for model in decoratedArray {
                    let viewmodel = OwnerBuildingListViewModel.init(model: model ?? OwnerBuildingListModel())
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

extension OwnerBuildingListViewController {
    
    func setUpView() {
                
        
        self.view.backgroundColor = kAppAlphaWhite0_alpha_7
               
        self.tableView.backgroundColor = kAppWhiteColor
        
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
        titleview?.leftButton.setTitle("收起", for: .normal)
        titleview?.leftButton.isHidden = false
        titleview?.rightButton.isHidden = true
        titleview?.leftButtonCallBack = { [weak self] in
            self?.navigationController?.dismiss(animated: true, completion: nil)
        }
        self.view.addSubview(titleview ?? ThorNavigationView.init(type: .backTitleRight))
        
        self.view.addSubview(titleLabel)
        self.view.addSubview(addBottomView)
        addBottomView.addSubview(addButton)
               
        titleLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(kNavigationHeight)
            make.height.equalTo(35)
        }
        addBottomView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(110)
            make.bottom.equalToSuperview().offset(-kTabBarHeight)
        }
        self.tableView.snp.remakeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(addBottomView.snp.top)
        }
        
        requestSet()
        
        addButton.setTitle("添加网点", for: .normal)

    }
    
    func requestSet() {
        
        isShowRefreshHeader = false
        
       
        self.tableView.register(OwnerBuildingListCell.self, forCellReuseIdentifier: OwnerBuildingListCell.reuseIdentifierStr)
        
        refreshData()
        
    }
    
    
}

extension OwnerBuildingListViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingListCell.reuseIdentifierStr) as? OwnerBuildingListCell
        cell?.selectionStyle = .none
        if self.dataSource.count > 0 {
            if let model = self.dataSource[indexPath.row]  {
                cell?.model = model as? OwnerBuildingListModel ?? OwnerBuildingListModel()
                
                ///预览 - 自己页面dismiss - 跳转到详情页面
                cell?.scanClickBlock = { [weak self] in
                    
                    let vc = RenterOfficebuildingDetailVC()
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
                
                ///编辑
                cell?.editClickBlock = { [weak self] in
                    
                    let vc = OwnerBuildingCreateViewController()
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
        return cell ?? OwnerBuildingListCell.init(frame: .zero)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return OwnerBuildingListCell.rowHeight()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.dataSource.count <= 0 {
            return
        }
        
    }
    
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let view = UIView()
//        view.backgroundColor = kAppWhiteColor
//        view.addSubview(titleLabel)
//        return view
//    }
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//
//        return 35
//    }
}




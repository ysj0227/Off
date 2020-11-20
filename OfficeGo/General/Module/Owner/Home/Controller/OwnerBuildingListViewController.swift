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
            
    ///预览 编辑
    var clickBuildingScanEditBlock:((_ viewmodel: OwnerBuildingListViewModel, _ isScan: Bool) -> Void)?

    ///点击
    var clickBuildingBlock:((OwnerBuildingListViewModel) -> Void)?
    
    ///判断身份和认证类型
    var userModel: LoginUserModel?
    
    var dataSourceViewModel: [[OwnerBuildingListViewModel?]] = []
    
    var buildingList: [OwnerBuildingListViewModel?] = []
    
    var branchList: [OwnerBuildingListViewModel?] = []

    
    lazy var ownerFYMoreSettingView: OwnerFYMoreSettingView = {
        let view = OwnerFYMoreSettingView.init(frame: CGRect(x: 0.0, y: 0, width: kWidth, height: kHeight))
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
        addButton.setTitle("添加楼盘/网点", for: .normal)
        addButton.setTitleColor(kAppColor_999999, for: .normal)
        addButton.titleLabel?.font = FONT_14
        addButton.layoutButton(.imagePositionTop, space: 10)
        addButton.addTarget(self, action: #selector(addBuilding), for: .touchUpInside)
        return addButton
    }()
    
    //MARK: 添加楼盘和网点
    @objc func addBuilding() {
        let vc = NewIdentifyViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refreshData()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        setUpView()
    }

    //MARK: 获取首页列表数据
    override func refreshData() {
        
        requestBuildingList()
    }
    
    
    func requestBuildingList() {
        if dataSourceViewModel.count > 0 {
            dataSourceViewModel.removeAll()
            buildingList.removeAll()
            branchList.removeAll()
        }
        
        var params = [String:AnyObject]()
        
        params["token"] = UserTool.shared.user_token as AnyObject?
        //params["pageNo"] = self.pageNo as AnyObject
        //params["pageSize"] = self.pageSize as AnyObject

        SSNetworkTool.SSFYManager.request_getBuildingList(params: params, success: { [weak self] (response) in
            guard let weakSelf = self else {return}
            if let decoratedArray = JSONDeserializer<OwnerBuildingListModel>.deserializeModelArrayFrom(json: JSON(response["data"] ?? "").rawString() ?? "", designatedPath: "list") {
                weakSelf.dataSource = weakSelf.dataSource + decoratedArray
                for model in decoratedArray {
                    
                    let viewmodel = OwnerBuildingListViewModel.init(model: model ?? OwnerBuildingListModel())
                    if model?.btype == 1 {
                        weakSelf.buildingList.append(viewmodel)
                    }else if model?.btype == 2 {
                        weakSelf.branchList.append(viewmodel)
                    }
                }
                weakSelf.dataSourceViewModel.append(weakSelf.buildingList)
                weakSelf.dataSourceViewModel.append(weakSelf.branchList)
                weakSelf.endRefreshWithCount(0)
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
        titleview?.leftButton.snp.remakeConstraints { (make) in
            make.leading.equalToSuperview()
            make.height.equalTo(44)
            make.width.equalTo(65)
            make.bottom.equalToSuperview()
        }
        titleview?.leftButton.setImage(UIImage.init(named: ""), for: .normal)
        titleview?.leftButton.setTitle("  收起", for: .normal)
        titleview?.leftButton.isHidden = false
        titleview?.rightButton.isHidden = true
        titleview?.leftButtonCallBack = { [weak self] in
            self?.navigationController?.dismiss(animated: true, completion: nil)
        }
        
        self.view.addSubview(titleview ?? ThorNavigationView.init(type: .backTitleRight))
        
        self.view.addSubview(addBottomView)
        addBottomView.addSubview(addButton)
               
        addBottomView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(110)
            make.bottom.equalToSuperview().offset(-kTabBarHeight)
        }
        self.tableView.snp.remakeConstraints { (make) in
            make.top.equalTo(kNavigationHeight)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(addBottomView.snp.top)
        }
        
        requestSet()

    }
    
    func requestSet() {
        
        isShowRefreshHeader = false
        
       
        self.tableView.register(OwnerBuildingListCell.self, forCellReuseIdentifier: OwnerBuildingListCell.reuseIdentifierStr)
                
    }
    
    func dismissCVCScanEdit(viewModel: OwnerBuildingListViewModel, isScan: Bool) {

        self.navigationController?.dismiss(animated: false, completion: { [weak self] in
                   
            guard let block = self?.clickBuildingScanEditBlock else { return }
            
            block(viewModel, isScan)
        })
    }
}

extension OwnerBuildingListViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingListCell.reuseIdentifierStr) as? OwnerBuildingListCell
        cell?.selectionStyle = .none
        cell?.lineView.isHidden = false

        if indexPath.section == 0 {
            if let viewModel = buildingList[indexPath.row]  {
                
                if indexPath.row == buildingList.count - 1 {
                    cell?.lineView.isHidden = true
                }
                
                cell?.viewModel = viewModel
                
                ///预览 - 自己页面dismiss - 跳转到详情页面
                cell?.scanClickBlock = { [weak self] in
                    
                    //self?.dismissCVCScanEdit(viewModel: viewModel, isScan: true)

                    
                    if viewModel.btype == 1 {
                        let model = FangYuanListModel()
                        model.btype = viewModel.btype
                        model.id = viewModel.buildingId
                        model.isTemp = viewModel.isTemp
                        model.status = viewModel.status
                        let vc = RenterOfficebuildingDetailVC()
                        vc.isFromOwnerScan = true
                        vc.buildingModel = model
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }else if viewModel.btype == 2 {
                        let model = FangYuanListModel()
                        model.btype = viewModel.btype
                        model.id = viewModel.buildingId
                        model.isTemp = viewModel.isTemp
                        model.status = viewModel.status
                        let vc = RenterOfficeJointDetailVC()
                        vc.isFromOwnerScan = true
                        vc.buildingModel = model
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                    
                }
                
                ///编辑
                cell?.editClickBlock = { [weak self] in
                    
                    //self?.dismissCVCScanEdit(viewModel: viewModel, isScan: false)
                
                    if viewModel.btype == 1 {
                        if viewModel.isEdit != true {
                            //AppUtilities.makeToast("暂不可编辑")
                            return
                        }
                        let buildingModel = FangYuanBuildingEditModel()
                        buildingModel.isTemp = viewModel.isTemp
                        buildingModel.buildingId = viewModel.buildingId
                        let vc = OwnerBuildingCreateViewController()
                        vc.isTemp = viewModel.isTemp
                        vc.buildingModel = buildingModel
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }else if viewModel.btype == 2 {
                        if viewModel.isEdit != true {
                            //AppUtilities.makeToast("暂不可编辑")
                            return
                        }
                        let buildingModel = FangYuanBuildingEditModel()
                        buildingModel.isTemp = viewModel.isTemp
                        buildingModel.buildingId = viewModel.buildingId
                        let vc = OwnerBuildingJointCreateViewController()
                        vc.isTemp = viewModel.isTemp
                        vc.buildingModel = buildingModel
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                
                ///重新认证
                cell?.identifyClickBlock = { [weak self] in
                    if self?.userModel?.identityType == 2 {
                        ///网点
                        let vc = OwnerBuildingJointNewIdentifyCreatAddViewController()
                        vc.isBranchs = true
                        vc.buildingId = viewModel.buildingId
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }else {
                        ///楼盘
                        let vc = OwnerBuildingJointNewIdentifyCreatAddViewController()
                        vc.isBuilding = true
                        vc.buildingId = viewModel.buildingId
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
        }else if indexPath.section == 1 {
            if let viewModel = branchList[indexPath.row]  {
                cell?.viewModel = viewModel
                
                ///预览 - 自己页面dismiss - 跳转到详情页面
                cell?.scanClickBlock = { [weak self] in
                    
                    //self?.dismissCVCScanEdit(viewModel: viewModel, isScan: true)

                    
                    if viewModel.btype == 1 {
                        let model = FangYuanListModel()
                        model.btype = viewModel.btype
                        model.id = viewModel.buildingId
                        model.isTemp = viewModel.isTemp
                        model.status = viewModel.status
                        let vc = RenterOfficebuildingDetailVC()
                        vc.isFromOwnerScan = true
                        vc.buildingModel = model
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }else if viewModel.btype == 2 {
                        let model = FangYuanListModel()
                        model.btype = viewModel.btype
                        model.id = viewModel.buildingId
                        model.isTemp = viewModel.isTemp
                        model.status = viewModel.status
                        let vc = RenterOfficeJointDetailVC()
                        vc.isFromOwnerScan = true
                        vc.buildingModel = model
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                    
                }
                
                ///编辑
                cell?.editClickBlock = { [weak self] in
                    
                    //self?.dismissCVCScanEdit(viewModel: viewModel, isScan: false)
                
                    if viewModel.btype == 1 {
                        if viewModel.isEdit != true {
                            //AppUtilities.makeToast("暂不可编辑")
                            return
                        }
                        let buildingModel = FangYuanBuildingEditModel()
                        buildingModel.isTemp = viewModel.isTemp
                        buildingModel.buildingId = viewModel.buildingId
                        let vc = OwnerBuildingCreateViewController()
                        vc.isTemp = viewModel.isTemp
                        vc.buildingModel = buildingModel
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }else if viewModel.btype == 2 {
                        if viewModel.isEdit != true {
                            //AppUtilities.makeToast("暂不可编辑")
                            return
                        }
                        let buildingModel = FangYuanBuildingEditModel()
                        buildingModel.isTemp = viewModel.isTemp
                        buildingModel.buildingId = viewModel.buildingId
                        let vc = OwnerBuildingJointCreateViewController()
                        vc.isTemp = viewModel.isTemp
                        vc.buildingModel = buildingModel
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                
                ///重新认证
                cell?.identifyClickBlock = { [weak self] in
                    if self?.userModel?.identityType == 2 {
                        ///网点
                        let vc = OwnerBuildingJointNewIdentifyCreatAddViewController()
                        vc.isBranchs = true
                        vc.buildingId = viewModel.buildingId
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }else {
                        ///楼盘
                        let vc = OwnerBuildingJointNewIdentifyCreatAddViewController()
                        vc.isBuilding = true
                        vc.buildingId = viewModel.buildingId
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
        }

        return cell ?? OwnerBuildingListCell.init(frame: .zero)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return buildingList.count
        }else {
            return branchList.count
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return OwnerBuildingListCell.rowHeight()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.dataSourceViewModel.count <= 0 {
            return
        }
        if indexPath.section == 0 {
            if let viewModel = buildingList[indexPath.row]  {
                guard let block = clickBuildingBlock else { return }
                block(viewModel)
                self.navigationController?.dismiss(animated: true, completion: nil)
            }
        }else {
            if let viewModel = branchList[indexPath.row]  {
                guard let block = clickBuildingBlock else { return }
                block(viewModel)
                self.navigationController?.dismiss(animated: true, completion: nil)
            }
        }
        
        
       
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = kAppWhiteColor
        let bg = UIView(frame: CGRect(x: 0, y: 0, width: kWidth, height: 18))
        bg.backgroundColor = kAppColor_bgcolor_F7F7F7
        view.addSubview(bg)
        let label = UILabel()
        label.textColor = kAppColor_999999
        label.font = FONT_14
        view.addSubview(label)
        if section == 0 {
            bg.backgroundColor = kAppWhiteColor
            label.text = "楼盘"
            label.frame = CGRect(x: left_pending_space_17, y: 15, width: kWidth - left_pending_space_17 * 2, height: 30)
        }else {
            label.text = "网点"
            label.frame = CGRect(x: left_pending_space_17, y: 35, width: kWidth - left_pending_space_17 * 2, height: 30)
        }
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 45
        }else {
            return 65
        }
    }
}




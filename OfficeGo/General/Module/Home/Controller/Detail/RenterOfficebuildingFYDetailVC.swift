//
//  RenterOfficebuildingFYDetailVC.swift
//  OfficeGo
//
//  Created by mac on 2020/5/13.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class RenterOfficebuildingFYDetailVC: BaseTableViewController {
    
    //表头
    let tableHeaderView: RenterDetailSourceView = {
        let item = RenterDetailSourceView(frame: CGRect(x: 0, y: 0, width: kWidth, height: kWidth * 267 / 320.0))
        return item
    }()
    
    var isTrafficUp: Bool = false
    
    let itemview: RenterHeaderItemSelectView = {
        let item = RenterHeaderItemSelectView(frame: CGRect(x: left_pending_space_17, y: 44, width: kWidth - left_pending_space_17, height: 40))
        item.backgroundColor = kAppBlueColor
        return item
    }()
    
    //房源详情model
    var buildingFYDetailModel: FangYuanBuildingFYDetailModel?
    
    //房源详情viewmodel
    var buildingFYDetailViewModel: FangYuanBuildingFYDetailViewModel?
    
    //总体数据源
    var dataSourceArr = [[FYDetailItemType]]()
    
    var model: FangYuanBuildingOpenStationModel = FangYuanBuildingOpenStationModel() {
        didSet {
            bottomBtnView.leftBtn.isSelected  = false
            //1是办公楼，2是联合办公
            if model.btype == 1 {
                //办公楼 - 办公室
                //名称基本信息 -房源信息- 户型 - 工交 -特色 - 周边配套
                
                self.dataSourceArr.append([
                    FYDetailItemType.FYDetailItemOfficeBuildingNameView,
                    FYDetailItemType.FYDetailItemTypeOfficeDeatail,
                    FYDetailItemType.FYDetailItemTypeHuxing,
                    FYDetailItemType.FYDetailItemTypeTraffic,
                    FYDetailItemType.FYDetailItemTypeFeature
                    //                    FYDetailItemType.FYDetailItemTypeAmbitusMating
                ])
                
                refreshData()
                
            }else {
                //网点 - 独立办公室
                //名称基本信息 -房源信息- 户型 - 工交 -特色 - 周边配套
                
                self.dataSourceArr.append([
                    FYDetailItemType.FYDetailItemOfficeBuildingNameView,
                    FYDetailItemType.FYDetailItemTypeOfficeDeatail,
                    FYDetailItemType.FYDetailItemTypeHuxing,
                    FYDetailItemType.FYDetailItemTypeTraffic,
                    //                    FYDetailItemType.FYDetailItemTypeAmbitusMating
                ])
                
                refreshData()
            }
            
        }
    }
    
    lazy var bottomBtnView: BottomBtnView = {
        let view = BottomBtnView.init(frame: CGRect(x: 0, y: 0, width: kWidth, height: 50))
        view.bottomType = BottomBtnViewType.BottomBtnViewTypeOfficeDetail
        view.backgroundColor = kAppWhiteColor
        return view
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tableHeaderView.pausePlayer()
    }
    
    override func leftBtnClick() {
         tableHeaderView.cycleView.removeFromSuperview()
         tableHeaderView.releaseWMplayer()
         self.navigationController?.popViewController(animated: true)
     }
     
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
    }
    
    func setData() {
        
        setupUI()
    }
    
    func setupUI() {
        
        self.view.backgroundColor = kAppColor_bgcolor_F7F7F7
        
        //设置头部
        titleview = ThorNavigationView.init(type: .backMoreRightClear)
        self.view.addSubview(titleview ?? ThorNavigationView.init(type: .locationSearchClear))
        self.view.bringSubviewToFront(titleview ?? ThorNavigationView.init(type: .locationSearchClear))
        titleview?.leftButtonCallBack = {
            self.leftBtnClick()
        }
        
        
        //设置头部
        self.tableView.tableHeaderView = tableHeaderView
        
        //头部
        self.tableView.register(RenterDetailNameCell.self, forCellReuseIdentifier: RenterDetailNameCell.reuseIdentifierStr)
        
        //房源信息
        self.tableView.register(UINib.init(nibName: RenterOfficebuildingFYDeatailCell.reuseIdentifierStr, bundle: nil), forCellReuseIdentifier: RenterOfficebuildingFYDeatailCell.reuseIdentifierStr)
        
        //户型
        self.tableView.register(UINib.init(nibName: RenterOfficebuildingDeatailHuxingCell.reuseIdentifierStr, bundle: nil), forCellReuseIdentifier: RenterOfficebuildingDeatailHuxingCell.reuseIdentifierStr)
        
        
        //交通
        self.tableView.register(UINib.init(nibName: RenterDetailTrafficCell.reuseIdentifierStr, bundle: nil), forCellReuseIdentifier: RenterDetailTrafficCell.reuseIdentifierStr)
        
        //特色
        self.tableView.register(RenterFeatureCell.self, forCellReuseIdentifier: RenterFeatureCell.reuseIdentifierStr)
        
        //周边配套
        //        self.tableView.register(UINib.init(nibName: RenterAmbitusMatingCell.reuseIdentifierStr, bundle: nil), forCellReuseIdentifier: RenterAmbitusMatingCell.reuseIdentifierStr)
        
        self.view.addSubview(bottomBtnView)
        
        bottomBtnView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
            make.bottom.equalToSuperview().offset(-bottomMargin())
        }
        self.tableView.snp.updateConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(0)
            make.bottom.equalToSuperview().offset(-(bottomMargin() + 50))
        }
        //左边收藏按钮
        bottomBtnView.leftBtnClickBlock = { [weak self] in
            self?.collectClick()
        }
        
        //找房东
        bottomBtnView.rightBtnClickBlock = { [weak self] in
            
            let vc = RenterChatViewController()
            vc.conversationType = .ConversationType_PRIVATE
            vc.targetId = AppKey.rcTargetid
            vc.title = "聊天房源"
            vc.displayUserNameInCell = false
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: 收藏按钮点击 - 调用接口 0是收藏1是取消收藏
    func collectClick() {
                
        var params = [String:AnyObject]()
        
        //0 添加收藏
        params["token"] = UserTool.shared.user_token as AnyObject?
        //取消收藏
        if self.buildingFYDetailModel?.IsFavorite ?? false == true {
            params["flag"] = 1 as AnyObject?
        }else {
            params["flag"] = 0 as AnyObject?
        }
        params["houseId"] = buildingFYDetailModel?.house?.id as AnyObject?
        
        SSNetworkTool.SSCollect.request_addCollection(params: params, success: {[weak self] (response) in
            
            guard let weakSelf = self else {return}
            
            weakSelf.buildingFYDetailModel?.IsFavorite = !(weakSelf.buildingFYDetailModel?.IsFavorite ?? false)
            SSTool.invokeInMainThread {
                weakSelf.setCollectBtnState(isCollect: weakSelf.buildingFYDetailModel?.IsFavorite ?? false)
            }
            }, failure: { (error) in
                
        }) { (code, message) in
            
            //只有5000 提示给用户
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" {
                AppUtilities.makeToast(message)
            }
        }
    }
    
    //设置收藏按钮的状态
    func setCollectBtnState(isCollect: Bool) {
        
        bottomBtnView.leftBtn.isSelected = isCollect
    }
    
    
    //MARK: 加载头部的图片和视频
    func loadHeaderview() {
        tableHeaderView.FYModel = self.buildingFYDetailModel ?? FangYuanBuildingFYDetailModel()
    }
    
    //MARK: 调用详情接口 -
    override func refreshData() {
        
        var params = [String:AnyObject]()
        
        params["token"] = UserTool.shared.user_token as AnyObject?
        params["btype"] = model.btype as AnyObject?
        params["houseId"] = model.id as AnyObject?
        
        
        SSNetworkTool.SSFYDetail.request_getBuildingFYDetailbyHouseId(params: params, success: {[weak self] (response) in
            
            guard let weakSelf = self else {return}
            
            if let model = FangYuanBuildingFYDetailModel.deserialize(from: response, designatedPath: "data") {
                //                model.building?.openStationFlag = false
                self?.buildingFYDetailModel = model
                self?.buildingFYDetailViewModel = FangYuanBuildingFYDetailViewModel.init(model: self?.buildingFYDetailModel ?? FangYuanBuildingFYDetailModel())
                
                self?.loadHeaderview()
                self?.setCollectBtnState(isCollect: model.IsFavorite ?? false)
                self?.tableView.reloadData()
            }
            weakSelf.endRefreshAnimation()
            
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

//MARK: CycleViewDelegate
extension RenterOfficebuildingFYDetailVC: CycleViewDelegate{
    func cycleViewDidSelectedItemAtIndex(_ index: NSInteger) {
        
    }
}


extension RenterOfficebuildingFYDetailVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        //办公楼
        dataSourceArr.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.model.btype == 1 { //办公楼
            //在租写字楼
            return self.dataSourceArr[section].count
            
        }else if self.model.btype == 2 {
            return self.dataSourceArr[section].count

        }else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.model.btype == 1 {
            let type:FYDetailItemType = dataSourceArr[indexPath.section][indexPath.row]
            switch type {
                
            case FYDetailItemType.FYDetailItemOfficeBuildingNameView:
                let cell = tableView.dequeueReusableCell(withIdentifier: RenterDetailNameCell.reuseIdentifierStr) as? RenterDetailNameCell
                cell?.selectionStyle = .none
                if let buildingViewModel = self.buildingFYDetailViewModel?.houseViewModel {
                    cell?.fyViewModel = buildingViewModel
                }else {
                    cell?.fyModel = self.buildingFYDetailModel?.house ?? FangYuanBuildingFYDetailHouseModel()
                }
                return cell ?? RenterDetailNameCell()
                
            case FYDetailItemType.FYDetailItemTypeJointNameView:
                return UITableViewCell.init(frame: .zero)
                
            case FYDetailItemType.FYDetailItemTypeOfficeDeatail:
                let cell = tableView.dequeueReusableCell(withIdentifier: RenterOfficebuildingFYDeatailCell.reuseIdentifierStr) as? RenterOfficebuildingFYDeatailCell
                cell?.selectionStyle = .none
                if let model = self.buildingFYDetailViewModel?.houseViewModel?.basicInformation {
                    cell?.model = model
                }
                return cell ?? RenterOfficebuildingFYDeatailCell()
                
            case .FYDetailItemTypeHuxing:
                let cell = tableView.dequeueReusableCell(withIdentifier: RenterOfficebuildingDeatailHuxingCell.reuseIdentifierStr) as? RenterOfficebuildingDeatailHuxingCell
                cell?.selectionStyle = .none
                if let model = self.buildingFYDetailViewModel?.houseViewModel?.basicInformation {
                    cell?.model = model
                }
                return cell ?? RenterOfficebuildingDeatailHuxingCell()
                
            case FYDetailItemType.FYDetailItemTypeTraffic:
                let cell = tableView.dequeueReusableCell(withIdentifier: RenterDetailTrafficCell.reuseIdentifierStr) as? RenterDetailTrafficCell
                cell?.selectionStyle = .none
                if let houseViewModel = self.buildingFYDetailViewModel?.houseViewModel {
                    cell?.fYViewModel = houseViewModel
                }
                cell?.trafficBtnClick = {[weak self] (isup) in
                    self?.isTrafficUp = isup
                    self?.tableView.reloadData()
                }
                return cell ?? RenterDetailTrafficCell.init(frame: .zero)
                
            case FYDetailItemType.FYDetailItemTypeFeature:
                let cell = tableView.dequeueReusableCell(withIdentifier: RenterFeatureCell.reuseIdentifierStr) as? RenterFeatureCell
                cell?.selectionStyle = .none
                cell?.featureString = self.buildingFYDetailViewModel?.houseViewModel?.tagsString ?? ""
                return cell ?? RenterFeatureCell.init(frame: .zero)
                
                
            case FYDetailItemType.FYDetailItemTypeAmbitusMating:
                let cell = tableView.dequeueReusableCell(withIdentifier: RenterAmbitusMatingCell.reuseIdentifierStr) as? RenterAmbitusMatingCell
                cell?.selectionStyle = .none
                cell?.selectModel = HouseSelectModel()
                return cell ?? RenterAmbitusMatingCell()
                
                
            case FYDetailItemType.FYDetailItemTypeLianheOpenList:
                return UITableViewCell.init(frame: .zero)
                
            case FYDetailItemType.FYDetailItemTypeFYList: //在租办公楼 -
                return UITableViewCell.init(frame: .zero)
                
            case .FYDetailItemTypeShareServices:
                return UITableViewCell()
            }
        }else if self.model.btype == 2 {
            let type:FYDetailItemType = dataSourceArr[indexPath.section][indexPath.row]
            switch type {
                
            case FYDetailItemType.FYDetailItemOfficeBuildingNameView:
                let cell = tableView.dequeueReusableCell(withIdentifier: RenterDetailNameCell.reuseIdentifierStr) as? RenterDetailNameCell
                cell?.selectionStyle = .none
                if let buildingViewModel = self.buildingFYDetailViewModel?.houseViewModel {
                    cell?.fyViewModel = buildingViewModel
                }else {
                    cell?.fyModel = self.buildingFYDetailModel?.house ?? FangYuanBuildingFYDetailHouseModel()
                }
                return cell ?? RenterDetailNameCell()
                
            case FYDetailItemType.FYDetailItemTypeJointNameView:
                return UITableViewCell.init(frame: .zero)
                
            case FYDetailItemType.FYDetailItemTypeOfficeDeatail:
                let cell = tableView.dequeueReusableCell(withIdentifier: RenterOfficebuildingFYDeatailCell.reuseIdentifierStr) as? RenterOfficebuildingFYDeatailCell
                cell?.selectionStyle = .none
                if let model = self.buildingFYDetailViewModel?.houseViewModel?.basicInformation {
                    cell?.model = model
                }
                return cell ?? RenterOfficebuildingFYDeatailCell()
                
            case .FYDetailItemTypeHuxing:
                let cell = tableView.dequeueReusableCell(withIdentifier: RenterOfficebuildingDeatailHuxingCell.reuseIdentifierStr) as? RenterOfficebuildingDeatailHuxingCell
                cell?.selectionStyle = .none
                if let model = self.buildingFYDetailViewModel?.houseViewModel?.basicInformation {
                    cell?.model = model
                }
                return cell ?? RenterOfficebuildingDeatailHuxingCell()
                
            case FYDetailItemType.FYDetailItemTypeTraffic:
               let cell = tableView.dequeueReusableCell(withIdentifier: RenterDetailTrafficCell.reuseIdentifierStr) as? RenterDetailTrafficCell
                cell?.selectionStyle = .none
                if let houseViewModel = self.buildingFYDetailViewModel?.houseViewModel {
                    cell?.fYViewModel = houseViewModel
                }
                cell?.trafficBtnClick = {[weak self] (isup) in
                    self?.isTrafficUp = isup
                    self?.tableView.reloadData()
                }
                return cell ?? RenterDetailTrafficCell.init(frame: .zero)
                
            case FYDetailItemType.FYDetailItemTypeFeature:
                let cell = tableView.dequeueReusableCell(withIdentifier: RenterFeatureCell.reuseIdentifierStr) as? RenterFeatureCell
                cell?.selectionStyle = .none
                cell?.featureString = self.buildingFYDetailViewModel?.houseViewModel?.tagsString ?? ""
                return cell ?? RenterFeatureCell.init(frame: .zero)
                
                
            case FYDetailItemType.FYDetailItemTypeAmbitusMating:
                let cell = tableView.dequeueReusableCell(withIdentifier: RenterAmbitusMatingCell.reuseIdentifierStr) as? RenterAmbitusMatingCell
                cell?.selectionStyle = .none
                cell?.selectModel = HouseSelectModel()
                return cell ?? RenterAmbitusMatingCell()
                
                
            case FYDetailItemType.FYDetailItemTypeLianheOpenList:
                return UITableViewCell.init(frame: .zero)
                
            case FYDetailItemType.FYDetailItemTypeFYList: //在租办公楼 -
                return UITableViewCell.init(frame: .zero)
                
            case .FYDetailItemTypeShareServices:
                return UITableViewCell()
            }
        }
        else {
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if self.model.btype == 1 {
            let type:FYDetailItemType = dataSourceArr[indexPath.section][indexPath.row]
            switch type {
                
            case FYDetailItemType.FYDetailItemOfficeBuildingNameView:
                return RenterDetailNameCell.rowHeight()
                
            case FYDetailItemType.FYDetailItemTypeJointNameView:
                return 0
                
            case FYDetailItemType.FYDetailItemTypeOfficeDeatail:
                return RenterOfficebuildingFYDeatailCell.rowHeight()
                
            case .FYDetailItemTypeHuxing:
                if let model = self.buildingFYDetailViewModel?.houseViewModel?.basicInformation {
                    if let height = model.textHeight {
                        return RenterOfficebuildingDeatailHuxingCell.rowHeight() + height
                    }else {
                        return RenterOfficebuildingDeatailHuxingCell.rowHeight() + 25
                    }
                }else {
                    return RenterOfficebuildingDeatailHuxingCell.rowHeight() + 25
                }
                
            case FYDetailItemType.FYDetailItemTypeAmbitusMating:
                return 79 + (41 + 10) * 3
                
            case FYDetailItemType.FYDetailItemTypeTraffic:
                if isTrafficUp == true {
                    if let arr = buildingFYDetailViewModel?.houseViewModel?.walkTimesubwayAndStationStringArr {
                        return CGFloat(40 + 30 * arr.count + 1)
                    }else {
                        return 40 + 30 + 1
                    }
                }else {
                    return 40 + 30 + 1
                }
                
            case FYDetailItemType.FYDetailItemTypeFeature:

                if let height = buildingFYDetailViewModel?.houseViewModel?.tagsHeight {
                   return RenterFeatureCell.rowHeight0() + height
               }else {
                   return RenterFeatureCell.rowHeight0() + 30
               }
            case FYDetailItemType.FYDetailItemTypeLianheOpenList:
                return 0
                
            case FYDetailItemType.FYDetailItemTypeFYList:
                return 0
                
            case .FYDetailItemTypeShareServices:
                return 0
            }
        }else {
            let type:FYDetailItemType = dataSourceArr[indexPath.section][indexPath.row]
            switch type {
                
            case FYDetailItemType.FYDetailItemOfficeBuildingNameView:
                return RenterDetailNameCell.rowHeight()
                
            case FYDetailItemType.FYDetailItemTypeJointNameView:
                return 0
                
            case FYDetailItemType.FYDetailItemTypeOfficeDeatail:
                return RenterOfficebuildingFYDeatailCell.rowHeight()
                
            case .FYDetailItemTypeHuxing:
                if let model = self.buildingFYDetailViewModel?.houseViewModel?.basicInformation {
                    if let height = model.textHeight {
                        return RenterOfficebuildingDeatailHuxingCell.rowHeight() + height
                    }else {
                        return RenterOfficebuildingDeatailHuxingCell.rowHeight() + 25
                    }
                }else {
                    return RenterOfficebuildingDeatailHuxingCell.rowHeight() + 25
                }
                
            case FYDetailItemType.FYDetailItemTypeAmbitusMating:
                return 79 + (41 + 10) * 3
                
            case FYDetailItemType.FYDetailItemTypeTraffic:
                if isTrafficUp == true {
                    if let arr = buildingFYDetailViewModel?.houseViewModel?.walkTimesubwayAndStationStringArr {
                        return CGFloat(40 + 30 * arr.count + 1)
                    }else {
                        return 40 + 30 + 1
                    }
                }else {
                    return 40 + 30 + 1
                }
                
            case FYDetailItemType.FYDetailItemTypeFeature:
                return 0
                
            case FYDetailItemType.FYDetailItemTypeLianheOpenList:
                return 0
                
            case FYDetailItemType.FYDetailItemTypeFYList:
                return 0
                
            case .FYDetailItemTypeShareServices:
                return 0
            }
        }
    }
    
    
}

extension RenterOfficebuildingFYDetailVC {
    
}



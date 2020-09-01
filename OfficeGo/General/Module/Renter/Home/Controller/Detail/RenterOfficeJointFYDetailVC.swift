//
//  RenterOfficeJointFYDetailVC.swift
//  OfficeGo
//
//  Created by mac on 2020/6/13.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class RenterOfficeJointFYDetailVC: BaseTableViewController {
    
    //表头
    let tableHeaderView: RenterDetailSourceView = {
        let item = RenterDetailSourceView(frame: CGRect(x: 0, y: 0, width: kWidth, height: kWidth * imgScale))
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
            
            setCollectBtnState(isCollect:false)
            
            refreshData()
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
    
    ///点击分享按钮调用的方法
    func shareClick() {
        var params = [String:AnyObject]()
        params["token"] = UserTool.shared.user_token as AnyObject?
        params["houseId"] = buildingFYDetailModel?.house?.id as AnyObject?

        SSNetworkTool.SSFYDetail.request_clickShareClick(params: params, success: { (response) in
            
            }, failure: { (error) in
                
        }) { (code, message) in
          
        }
    }
    
    func shareVc() {
        let shareVC = ShareViewController.initialization()
        shareVC.buildingName = buildingFYDetailViewModel?.houseViewModel?.buildingName ?? ""
        shareVC.descriptionString = buildingFYDetailViewModel?.houseViewModel?.addressString ?? ""
        shareVC.thumbImage = buildingFYDetailViewModel?.houseViewModel?.mainPic
        shareVC.shareUrl = "\(SSAPI.SSH5Host)\(SSDelegateURL.h5BJointFYDetailShareUrl)?isShare=\(UserTool.shared.user_channel)&buildingId=\(buildingFYDetailViewModel?.houseViewModel?.buildingId ?? 0)&houseId=\(buildingFYDetailModel?.house?.id ?? 0)"
        shareVC.modalPresentationStyle = .overFullScreen
        self.present(shareVC, animated: true, completion: {})
    }
    
    func setItemFunc() {
        //网点 - 独立办公室
        //名称基本信息 -房源信息- 户型 - 工交 -特色 - 周边配套
        
        self.dataSourceArr.append([
            FYDetailItemType.FYDetailItemOfficeBuildingNameView,
            FYDetailItemType.FYDetailItemTypeOfficeDeatail,
            FYDetailItemType.FYDetailItemTypeHuxing,
            FYDetailItemType.FYDetailItemTypeTraffic,
            //                    FYDetailItemType.FYDetailItemTypeAmbitusMating
        ])
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
    
    ///MARK: 隐藏无数据view
    override func noDataViewSet() {
        noDataView.isHidden = true
    }
    
    func setupUI() {
        
        self.view.backgroundColor = kAppColor_bgcolor_F7F7F7
        
        //设置头部
        titleview = ThorNavigationView.init(type: .backMoreRightClear)
        titleview?.rightBtnsssClickBlock = {[weak self] (index) in
            guard let weakSelf = self else {return}
            ///添加登录状态
            if weakSelf.isLogin() != true {
                return
            }
            
            ///举报
            if index == 97 {
                
            }
                ///聊天
            else if index == 98 {
                weakSelf.requestCreateChat()
            }
                ///分享
            else {
                
            }
        }
        self.view.addSubview(titleview ?? ThorNavigationView.init(type: .locationSearchClear))
        self.view.bringSubviewToFront(titleview ?? ThorNavigationView.init(type: .locationSearchClear))
        titleview?.leftButtonCallBack = { [weak self] in
            self?.leftBtnClick()
        }
        titleview?.rightBtnsssClickBlock = { [weak self] (index) in
            if index == 99 {
                self?.shareClick()
                self?.shareVc()
            }
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
        //左边收藏按钮 - 判断有没有登录 -
        bottomBtnView.leftBtnClickBlock = { [weak self] in
            self?.juddgeIsLogin(isCollect: true)
        }
        
        //找房东
        bottomBtnView.rightBtnClickBlock = { [weak self] in
            self?.juddgeIsLogin(isCollect: false)
        }
        
        tableHeaderView.imgScanDelegate = self
    }
    
    func clickToChat(chatModel: MessageFYChattedModel) {
        SSTool.invokeInMainThread { [weak self] in
            guard let weakSelf = self else {return}
            let vc = RenterChatViewController()
            vc.conversationType = .ConversationType_PRIVATE
            vc.targetId = chatModel.targetId
            vc.displayUserNameInCell = false
            vc.houseId = weakSelf.buildingFYDetailModel?.house?.id
            weakSelf.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func requestCreateChat() {
        
        var params = [String:AnyObject]()
        
        params["token"] = UserTool.shared.user_token as AnyObject?
        params["houseId"] = buildingFYDetailModel?.house?.id as AnyObject?
        params["buildingId"] = "" as AnyObject?
        
        SSNetworkTool.SSChat.request_getCreatFirstChatApp(params: params, success: {[weak self] (response) in
            
            guard let weakSelf = self else {return}
            
            if let model = MessageFYChattedModel.deserialize(from: response, designatedPath: "data") {
                weakSelf.clickToChat(chatModel: model)
            }
            
            }, failure: { (error) in
                
        }) { (code, message) in
            
            //只有5000 提示给用户 - 失效原因
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" || code == "\(SSCode.ERROR_CODE_7016.code)" {
                AppUtilities.makeToast(message)
            }
        }
    }
    ///判断有没有登录
    func juddgeIsLogin(isCollect: Bool) {
        //登录直接请求数据
        if isLogin() == true {
            if isCollect == true {
                collectClick()
            }else {
                requestCreateChat()
            }
            
        }else {
            //没登录 - 谈登录
            showLoginVC(isCollect: isCollect)
        }
    }
    
    func showLoginVC(isCollect: Bool) {
        let vc = RenterLoginViewController()
        vc.isFromOtherVC = true
        vc.closeViewBack = {[weak self] (isClose) in
            guard let weakSelf = self else {return}
            //登录直接请求数据
            if weakSelf.isLogin() == true {
                if isCollect == true {
                    weakSelf.collectClick()
                }else {
                    weakSelf.requestCreateChat()
                }
            }
        }
        let loginNav = BaseNavigationViewController.init(rootViewController: vc)
        loginNav.modalPresentationStyle = .overFullScreen
        //TODO: 这块弹出要设置
        self.present(loginNav, animated: true, completion: nil)
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
        
        bottomBtnView.setCollectBtnSelect(collect: isCollect)
    }
    
    
    //MARK: 加载头部的图片和视频
    func loadHeaderview() {
        
        titleview?.titleLabel.text = buildingFYDetailViewModel?.houseViewModel?.buildingName
        
        tableHeaderView.FYModel = self.buildingFYDetailModel ?? FangYuanBuildingFYDetailModel()
    }
    
    //MARK: 调用详情接口 -
    override func refreshData() {
        
        ///访问房源详情页
        SensorsAnalyticsFunc.visit_house_data_page(houseId: "\(model.id ?? 0)")
        
        var params = [String:AnyObject]()
        
        params["token"] = UserTool.shared.user_token as AnyObject?
        params["btype"] = model.btype as AnyObject?
        params["houseId"] = model.id as AnyObject?
        
        
        SSNetworkTool.SSFYDetail.request_getBuildingFYDetailbyHouseId(params: params, success: {[weak self] (response) in
            
            guard let weakSelf = self else {return}
            
            if let model = FangYuanBuildingFYDetailModel.deserialize(from: response, designatedPath: "data") {
                //                model.building?.openStationFlag = false
                model.btype = self?.model.btype
                self?.buildingFYDetailModel = model
                self?.buildingFYDetailViewModel = FangYuanBuildingFYDetailViewModel.init(model: self?.buildingFYDetailModel ?? FangYuanBuildingFYDetailModel())
                self?.refreshTableview()
            }
            weakSelf.endRefreshAnimation()
            
            }, failure: {[weak self] (error) in
                
                guard let weakSelf = self else {return}
                
                weakSelf.endRefreshAnimation()
                
        }) {[weak self] (code, message) in
            
            guard let weakSelf = self else {return}
            
            weakSelf.endRefreshAnimation()
            
            //只有5000 提示给用户 - 失效原因
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" || code == "\(SSCode.ERROR_CODE_7016.code)" {
                AppUtilities.makeToast(message)
            }
        }
    }
    
    func refreshTableview() {
        SSTool.invokeInMainThread { [weak self] in
            self?.setItemFunc()
            self?.loadHeaderview()
            self?.setCollectBtnState(isCollect: self?.buildingFYDetailViewModel?.IsFavorite ?? false)
            self?.tableView.reloadData()
        }
    }
}

///头部图片点击展示代理
extension RenterOfficeJointFYDetailVC: RenterDetailSourceViewImgScanDelegate{
    func imgClickScan(index: Int, imgURLs: [String]) {
        let vc = DVImageBrowserVC()
        vc.images = imgURLs
        vc.index = index
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: {})
    }
}

extension RenterOfficeJointFYDetailVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        //办公楼
        dataSourceArr.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSourceArr[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
            cell?.featureString = self.buildingFYDetailViewModel?.houseViewModel?.tagsString ?? []
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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
                    return CGFloat(45 + 30 * arr.count + 2)
                }else {
                    return 45 + 2
                }
            }else {
                if buildingFYDetailViewModel?.houseViewModel?.walkTimesubwayAndStationStringArr?.count ?? 0 > 0 {
                    return 45 + 30 + 2
                }else {
                    return 45 + 2
                }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
               
        let type:FYDetailItemType = dataSourceArr[indexPath.section][indexPath.row]
        switch type {
            
        case FYDetailItemType.FYDetailItemOfficeBuildingNameView,
             FYDetailItemType.FYDetailItemTypeJointNameView,
             FYDetailItemType.FYDetailItemTypeOfficeDeatail,
             FYDetailItemType.FYDetailItemTypeAmbitusMating,
             FYDetailItemType.FYDetailItemTypeTraffic,
             FYDetailItemType.FYDetailItemTypeFeature,
             FYDetailItemType.FYDetailItemTypeLianheOpenList,
             FYDetailItemType.FYDetailItemTypeFYList,
             FYDetailItemType.FYDetailItemTypeShareServices: break
            
            
        case .FYDetailItemTypeHuxing:
            
            if let unitPattern = buildingFYDetailModel?.house?.basicInformation?.unitPatternImg {
                imageBroswerVC(index: 0, images: [unitPattern])
            }
            
            //, images: <#[String]#>            if let vrArr = buildingFYDetailModel?.vrUrl {
//                if vrArr.count > 0 {
//                    let vrModel = vrArr[0]
//                    let vc = DVImageBrowserVC()
//                    vc.images = [vrModel.imgUrl ?? ""]
//                    vc.index = 0
//                    vc.modalPresentationStyle = .overFullScreen
//                    self.present(vc, animated: true, completion: {})
//                }else {
//
//                }
//            }
        }
    }
    
}

extension RenterOfficeJointFYDetailVC {
    //MARK: 滑动- 设置标题颜色
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        SSLog("scrollViewDidScroll ----*\(scrollView.contentOffset.y)")
        if scrollView.contentOffset.y >= kWidth * imgScale - kNavigationHeight {
            titleview?.backgroundColor = kAppBlueColor
            titleview?.titleLabel.isHidden = false
            
        }else {
            titleview?.backgroundColor = kAppClearColor
            titleview?.titleLabel.isHidden = true
        }
    }
}


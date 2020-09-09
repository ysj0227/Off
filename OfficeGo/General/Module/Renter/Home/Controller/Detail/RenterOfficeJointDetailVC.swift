//
//  RenterOfficeJointDetailVC.swift
//  OfficeGo
//
//  Created by mac on 2020/6/13.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit
import WMPlayer
import HandyJSON
import SwiftyJSON

class RenterOfficeJointDetailVC: BaseTableViewController, WMPlayerDelegate {
    
    ///神策添加字段
    var buildLocation: Int = 0
    
    ///是否阅读完成
    var isRead: Bool = false
    
    //首页带过来的面积或者工位数
    var shaixuanAreaSeatsString: String?
    
    //点击清楚按钮之后 - 隐藏筛选条件
    var isClearCondition: Bool = false {
        didSet {
            if isClearCondition == true {
                shaixuanConditionView.isHidden = true
                shaixuanConditionView.removeFromSuperview()
            }else {
                
            }
        }
    }
    
    
    //筛选条件
    let shaixuanConditionView: ShaixuanConditionSelectView = {
        let item = ShaixuanConditionSelectView(frame: CGRect(x: left_pending_space_17, y: 61, width: kWidth - left_pending_space_17 * 2, height: 46))
        return item
    }()
    
    //表头
    let tableHeaderView: RenterDetailSourceView = {
        let item = RenterDetailSourceView(frame: CGRect(x: 0, y: 0, width: kWidth, height: kWidth * imgScale))
        return item
    }()
    
    var isTrafficUp: Bool = false
    
    //tableview头部
    let itemview: RenterHeaderItemSelectView = {
        let item = RenterHeaderItemSelectView(frame: CGRect(x: left_pending_space_17, y: 61, width: kWidth - left_pending_space_17, height: 46))
        item.backgroundColor = kAppBlueColor
        return item
    }()
    
    //总体数据源
    var dataSourceArr = [[FYDetailItemType]]()
    
    var amtitusMatingListARR = [String]()
    
    //房源详情model
    var buildingDetailModel: FangYuanBuildingDetailModel?
    
    //楼盘详情viewmodel
    var buildingDetailViewModel: FangYuanBuildingDetailViewModel?
    
    var isHiddenMoreData: Bool?
    
    //从列表传过来的筛选参数
    var shaiXuanParams: [String:AnyObject]?
    
    //列表传过来的模型
    var buildingModel: FangYuanListModel = FangYuanListModel() {
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
    
    //点击头部的条件 要传的参数
    var clickItemString: String = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tableHeaderView.pausePlayer()
    }
    
    ///点击分享按钮调用的方法
    func shareClick() {
        var params = [String:AnyObject]()
        params["token"] = UserTool.shared.user_token as AnyObject?
        params["buildingId"] = buildingDetailViewModel?.buildingViewModel?.buildingId as AnyObject?
        SSNetworkTool.SSFYDetail.request_clickShareClick(params: params, success: { (response) in
            
            }, failure: { (error) in
                
        }) { (code, message) in
          
        }
    }
    
    func shareVc() {
        let shareVC = ShareViewController.initialization()
        shareVC.buildingName = buildingDetailViewModel?.buildingViewModel?.buildingName ?? ""
        shareVC.descriptionString = buildingDetailViewModel?.buildingViewModel?.addressString ?? ""
        shareVC.thumbImage = buildingDetailViewModel?.buildingViewModel?.mainPic
        shareVC.shareUrl = "\(SSAPI.SSH5Host)\(SSDelegateURL.h5JointDetailShareUrl)?isShare=\(UserTool.shared.user_channel)&buildingId=\(buildingDetailViewModel?.buildingViewModel?.buildingId ?? 0)"
        shareVC.modalPresentationStyle = .overFullScreen
        self.present(shareVC, animated: true, completion: {})
    }
    
    func setItemFunc() {
        
        //1是写字楼，2是共享办公
        //判断 - 如果传过来的面积值字符串大于0 说明有筛选过
        if let params = shaiXuanParams {
            if let seats = params["seats"] {
                let str = seats as? String
                if str?.count ?? 0 > 0 {
                    shaixuanAreaSeatsString = str?.replacingOccurrences(of: ",", with: "~")
                    isClearCondition = false
                }else {
                    isClearCondition = true
                }
            }else {
                isClearCondition = true
            }
        }else {
            isClearCondition = true
        }
        
        //共享办公 -
        //名称基本信息 - 开放工位和独立办公室
        self.dataSourceArr.append([
            FYDetailItemType.FYDetailItemTypeJointNameView])
        //- 公交 特色
        self.dataSourceArr.append([
            FYDetailItemType.FYDetailItemTypeTraffic,
            FYDetailItemType.FYDetailItemTypeFeature])
        //开放工位
        self.dataSourceArr.append([
            FYDetailItemType.FYDetailItemTypeLianheOpenList])
        //独立办公室
        self.dataSourceArr.append([
            FYDetailItemType.FYDetailItemTypeFYList])
        //共享服务 - 楼盘信息 - 周边配套
        self.dataSourceArr.append([
            FYDetailItemType.FYDetailItemTypeShareServices,
            FYDetailItemType.FYDetailItemTypeOfficeDeatail,
            //                    FYDetailItemType.FYDetailItemTypeAmbitusMating
        ])
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setData()
    }
    
    ///获取点击的条件
    func getClickItemString(index: Int) {
        switch index {
        case 0:
            clickItemString = ""
        case 1:
            clickItemString = "0,1"
        case 2:
            clickItemString = "2,3"
        case 3:
            clickItemString = "4,6"
        case 4:
            clickItemString = "7,10"
        case 5:
            clickItemString = "11,15"
        case 6:
            clickItemString = "16,20"
        case 7:
            clickItemString = "21,99999"
        default:
            clickItemString = ""
        }
    }
    
    func setData() {
        
        //筛选条件清除回掉
        shaixuanConditionView.clearCallBack = { [weak self] in
            
            self?.isClearCondition = true
            
            //默认选择第一个全部获取筛选参数
            self?.getClickItemString(index: 0)
            
            //点击头部 每次调用接口 - page设为1
            self?.loadNewData()
            
        }
        
        //面积和工位选择
        itemview.itemSelectCallBack = {[weak self] (index) in
            
            //获取筛选参数
            self?.getClickItemString(index: index)
            
            //点击头部 每次调用接口 - page设为1
            self?.loadNewData()
        }
    }
    
    //MARK: 请求列表数据
    /// 刷新数据
    @objc func refreshDataList() {
        
        var params = [String:AnyObject]()
        
        if let parr = shaiXuanParams {
            params = parr
        }
        params["pageNo"] = self.pageNo as AnyObject
        params["pageSize"] = self.pageSize as AnyObject
        params["btype"] = buildingModel.btype as AnyObject?
        params["buildingId"] = buildingModel.id as AnyObject?
        
        ///只有点击清楚按钮之后 - 用自己选择的面积
        if isClearCondition == true {
            params["seats"] = clickItemString as AnyObject?
        }
        
        SSNetworkTool.SSFYDetail.request_getBuildingFYList(params: params, success: { [weak self] (response) in
            guard let weakSelf = self else {return}
            if let decoratedArray = JSONDeserializer<FangYuanBuildingOpenStationModel>.deserializeModelArrayFrom(json: JSON(response["data"] ?? "").rawString() ?? "", designatedPath: "list") {
                weakSelf.dataSource = weakSelf.dataSource + decoratedArray
                weakSelf.endRefreshWithCount(decoratedArray.count)
                
                //显示带过来的筛选条件
                if weakSelf.isClearCondition != true {
                    
                    SSTool.invokeInMainThread {
                        weakSelf.shaixuanConditionView.titleView.text = "\(weakSelf.shaixuanAreaSeatsString ?? "全部")人 \n \(weakSelf.dataSource.count)套"
                    }
                    
                    ///神策楼盘详情页筛选房源
                    SensorsAnalyticsFunc.building_data_page_screen(buildingId: "\(weakSelf.buildingModel.id ?? 0)", houseCnt: weakSelf.dataSource.count)
                    
                }else {
                    ///点击楼盘详情页房源筛选按钮
                    if weakSelf.clickItemString == "" {
                        SensorsAnalyticsFunc.click_building_data_page_screen_button(buildingId: "\(weakSelf.buildingModel.id ?? 0)", area: "", simple: "全部")
                    }else {
                        SensorsAnalyticsFunc.click_building_data_page_screen_button(buildingId: "\(weakSelf.buildingModel.id ?? 0)", area: "", simple: weakSelf.clickItemString)
                    }
                }
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
    /// 结束刷新
    public override func endRefreshAnimation() {
        endRefreshWithCount(0)
    }
    
    public override func endRefreshWithCount(_ count: Int) {
        
        SSTool.invokeInMainThread { [weak self] in
            
            guard let weakSelf = self else {return}
            
            weakSelf.isHiddenMoreData = count < weakSelf.pageSize || count == 0
            
            weakSelf.tableView.reloadData()
        }
        
    }
    @objc override func loadNewData(){
        
        pageNo = 1
        
        if self.dataSource.count > 0 {
            self.dataSource.removeAll()
        }
        
        refreshDataList()
    }
    
    @objc override func loadNextPage() {
        pageNo += 1
        refreshDataList()
    }
    
    deinit {
        SSLog("officedismiss")
        
        ///楼盘详情页阅读完成
         SensorsAnalyticsFunc.visit_building_data_page_complete(buildingId: "\(buildingModel.id ?? 0)", isRead: isRead)
    }
    
    override func leftBtnClick() {
        
        tableHeaderView.cycleView.removeFromSuperview()
        tableHeaderView.releaseWMplayer()
        self.navigationController?.popViewController(animated: true)
    }
    func requestSet() {
        
        isShowRefreshHeader = true
        
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
                self?.requestCreateChat()
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
        
        //头部-三项显示 - 写字楼-
        self.tableView.register(RenterDetailNameCell.self, forCellReuseIdentifier: RenterDetailNameCell.reuseIdentifierStr)
        
        //头部-三项显示 - 共享办公- 有标签-
        self.tableView.register(RenterJointDetailNameCell.self, forCellReuseIdentifier: RenterJointDetailNameCell.reuseIdentifierStr)
        
        //交通
        self.tableView.register(UINib.init(nibName: RenterDetailTrafficCell.reuseIdentifierStr, bundle: nil), forCellReuseIdentifier: RenterDetailTrafficCell.reuseIdentifierStr)
        
        //特色
        self.tableView.register(RenterFeatureCell.self, forCellReuseIdentifier: RenterFeatureCell.reuseIdentifierStr)
        
        //共享服务
        self.tableView.register(RenterShareServiceCell.self, forCellReuseIdentifier: RenterShareServiceCell.reuseIdentifierStr)

        //楼盘信息
        self.tableView.register(RenterOfficeBuildingMsgCell.self, forCellReuseIdentifier: RenterOfficeBuildingMsgCell.reuseIdentifierStr)

        //周边配套
        //        self.tableView.register(UINib.init(nibName: RenterAmbitusMatingCell.reuseIdentifierStr, bundle: nil), forCellReuseIdentifier: RenterAmbitusMatingCell.reuseIdentifierStr)
        
        //开放工位 - 独立办公室
        self.tableView.register(RenterDetailFYListCell.self, forCellReuseIdentifier: RenterDetailFYListCell.reuseIdentifierStr)
        
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
        
        requestSet()
        
        tableHeaderView.imgScanDelegate = self
    }
    /*
     ///调用创建聊天 -  判断是不是单房东
     ///单房东直接跳转 多房东选择房源
     */
    func requestCreateChat() {
        
        var params = [String:AnyObject]()
        
        params["token"] = UserTool.shared.user_token as AnyObject?
        params["buildingId"] = buildingDetailModel?.building?.buildingId as AnyObject?
        params["houseId"] = "" as AnyObject?
        
        SSNetworkTool.SSChat.request_getCreatFirstChatApp(params: params, success: {[weak self] (response) in
            
            guard let weakSelf = self else {return}
            
            if let model = MessageFYChattedModel.deserialize(from: response, designatedPath: "data") {
                
                weakSelf.judgeOneOrMoreOwner(model: model)
            }
            
            }, failure: { (error) in
                
        }) { (code, message) in
            
            //只有5000 提示给用户 - 失效原因
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" || code == "\(SSCode.ERROR_CODE_7016.code)" {
                AppUtilities.makeToast(message)
            }
        }
    }
    
    ///判断是单房东还是双房东
    func judgeOneOrMoreOwner(model: MessageFYChattedModel) {
        //双房东
        if model.multiOwner == 1 {
            scrollToFY()
        }else {
            clickToChat(chatModel: model)
        }
    }
    
    
    func scrollToFY() {
        
        SSTool.invokeInMainThread { [weak self] in
            guard let weakSelf = self else {return}
            
            AppUtilities.makeToast("请先选择房源，再和房东聊")
            //3
            if weakSelf.dataSourceArr.count > 3 {
                if weakSelf.dataSource.count > 0 {
                    weakSelf.tableView.scrollToRow(at: IndexPath.init(row: 0, section: 3), at: UITableView.ScrollPosition.top, animated: true)
                }
                
            }
        }
    }
    
    func clickToChat(chatModel: MessageFYChattedModel) {
        SSTool.invokeInMainThread { [weak self] in
            guard let weakSelf = self else {return}
            let vc = RenterChatViewController()
            vc.conversationType = .ConversationType_PRIVATE
            vc.targetId = chatModel.targetId
            vc.displayUserNameInCell = false
            vc.buildingId = weakSelf.buildingModel.id
            weakSelf.navigationController?.pushViewController(vc, animated: true)
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
        if self.buildingDetailModel?.IsFavorite ?? false == true {
            params["flag"] = 1 as AnyObject?
        }else {
            params["flag"] = 0 as AnyObject?
        }
        params["buildingId"] = buildingModel.id as AnyObject?
        
        SSNetworkTool.SSCollect.request_addCollection(params: params, success: {[weak self] (response) in
            
            guard let weakSelf = self else {return}
            
            weakSelf.buildingDetailModel?.IsFavorite = !(weakSelf.buildingDetailModel?.IsFavorite ?? false)
            SSTool.invokeInMainThread {
                weakSelf.setCollectBtnState(isCollect: weakSelf.buildingDetailModel?.IsFavorite ?? false)
                
                SensorsAnalyticsFunc.click_favorites_button(buildingId: "\(weakSelf.buildingModel.id ?? 0)", isCollect: weakSelf.buildingDetailModel?.IsFavorite ?? false)
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
        
        titleview?.titleLabel.text = buildingDetailViewModel?.buildingViewModel?.buildingName
        
        tableHeaderView.model = buildingDetailViewModel ?? FangYuanBuildingDetailViewModel.init(model: buildingDetailModel ?? FangYuanBuildingDetailModel())
    }
    
    //MARK: 调用详情接口 -
    override func refreshData() {
        
        ///访问楼盘详情页
        SensorsAnalyticsFunc.visit_building_data_page(buildingId: "\(buildingModel.id ?? 0)", buildLocation: buildLocation)
        
        var params = [String:AnyObject]()
        
        if let parr = shaiXuanParams {
            params = parr
        }
        
        params["token"] = UserTool.shared.user_token as AnyObject?
        params["btype"] = buildingModel.btype as AnyObject?
        params["buildingId"] = buildingModel.id as AnyObject?
        
        
        SSNetworkTool.SSFYDetail.request_getBuildingDetailbyBuildingId(params: params, success: {[weak self] (response) in
            
            guard let weakSelf = self else {return}
            
            if let model = FangYuanBuildingDetailModel.deserialize(from: response, designatedPath: "data") {
                //                model.building?.openStationFlag = false
                model.btype = self?.buildingModel.btype
                model.building?.btype = self?.buildingDetailModel?.btype
                self?.buildingDetailModel = model
                self?.buildingDetailViewModel = FangYuanBuildingDetailViewModel.init(model: self?.buildingDetailModel ?? FangYuanBuildingDetailModel())
                
                //只有获取详情成功 - 请求房源列表数据
                self?.loadNewData()
                //刷新view
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
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" || code == "\(SSCode.ERROR_CODE_7012.code)" || code == "\(SSCode.ERROR_CODE_7013.code)" || code == "\(SSCode.ERROR_CODE_7014.code)"{
                AppUtilities.makeToast(message)
            }
        }
    }
    
    func refreshTableview() {
        SSTool.invokeInMainThread { [weak self] in
            self?.setItemFunc()
            self?.loadHeaderview()
            self?.setCollectBtnState(isCollect: self?.buildingDetailModel?.IsFavorite ?? false)
            
            self?.tableView.reloadData()
        }
    }
    
    
}

///头部图片点击展示代理
extension RenterOfficeJointDetailVC: RenterDetailSourceViewImgScanDelegate{
    func vrClick() {
        if let vrArr = buildingDetailModel?.vrUrl {
            if vrArr.count > 0 {
                let vrModel = vrArr[0]
                let vc = VRScanWebViewController()
                vc.urlString = vrModel.imgUrl
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }
    
    func imgClickScan(index: Int, imgURLs: [String]) {
        let vc = DVImageBrowserVC()
        vc.images = imgURLs
        vc.index = index
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: {})
    }
}


extension RenterOfficeJointDetailVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        //写字楼
        dataSourceArr.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            //开放工位
            return 2
        }else if section == 2 { //在租写字楼
            //开放工位
            //判断是否显示开放工位
            if self.buildingDetailModel?.building?.openStationFlag == true {
                return 1
            }else {
                return 0
            }
        }else if section == 3 {
            //独立办公室
            return dataSource.count
        }else {
            return self.dataSourceArr[section].count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { //共享办公
        //共享办公- 开放工位和独立nameview
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: RenterJointDetailNameCell.reuseIdentifierStr) as? RenterJointDetailNameCell
            cell?.selectionStyle = .none
            //独立办公室
            if indexPath.row == 0 {
                cell?.isOpenSeats = false
                if let buildingViewModel = self.buildingDetailViewModel?.buildingViewModel {
                    cell?.viewModel = buildingViewModel
                }else {
                    cell?.model = self.buildingDetailModel?.building ?? FangYuanBuildingBuildingModel()
                }
            }else if indexPath.row == 1 { //开放工位
                cell?.isOpenSeats = true
                //判断是否显示开放工位
                if let buildingViewModel = self.buildingDetailViewModel?.buildingViewModel {
                    cell?.viewModel = buildingViewModel
                }else {
                    cell?.model = self.buildingDetailModel?.building ?? FangYuanBuildingBuildingModel()
                }
            }
            return cell ?? RenterJointDetailNameCell()
        }else if indexPath.section == 2 {
            //开发工位列表 2
            let cell = tableView.dequeueReusableCell(withIdentifier: RenterDetailFYListCell.reuseIdentifierStr) as? RenterDetailFYListCell
            cell?.selectionStyle = .none
            //判断是否显示开放工位
            if let buildingViewModel = self.buildingDetailViewModel?.buildingViewModel {
                cell?.viewModel = buildingViewModel
            }else {
                cell?.model = self.buildingDetailModel?.building ?? FangYuanBuildingBuildingModel()
            }
            return cell ?? RenterDetailFYListCell.init(frame: .zero)
        }else if indexPath.section == 3 {
            //独立办公室 1
            let cell = tableView.dequeueReusableCell(withIdentifier: RenterDetailFYListCell.reuseIdentifierStr) as? RenterDetailFYListCell
            cell?.selectionStyle = .none
            if let model = self.dataSource[indexPath.row] as? FangYuanBuildingOpenStationModel {
                model.btype = 2
                model.officeType = 1
                cell?.duliModel = model
            }
            return cell ?? RenterDetailFYListCell.init(frame: .zero)
        }else {
            let type:FYDetailItemType = dataSourceArr[indexPath.section][indexPath.row]
            switch type {
                
            case FYDetailItemType.FYDetailItemOfficeBuildingNameView:
                return UITableViewCell()
                
            case FYDetailItemType.FYDetailItemTypeJointNameView:
                return UITableViewCell()
                
            case FYDetailItemType.FYDetailItemTypeTraffic:
                let cell = tableView.dequeueReusableCell(withIdentifier: RenterDetailTrafficCell.reuseIdentifierStr) as? RenterDetailTrafficCell
                cell?.selectionStyle = .none
                if let buildingViewModel = self.buildingDetailViewModel?.buildingViewModel {
                    cell?.viewModel = buildingViewModel
                }else {
                    cell?.model = self.buildingDetailModel?.building ?? FangYuanBuildingBuildingModel()
                }
                cell?.trafficBtnClick = {[weak self] (isup) in
                    self?.isTrafficUp = isup
                    self?.tableView.reloadData()
                }
                return cell ?? RenterDetailTrafficCell.init(frame: .zero)
                
            case FYDetailItemType.FYDetailItemTypeFeature:
                let cell = tableView.dequeueReusableCell(withIdentifier: RenterFeatureCell.reuseIdentifierStr) as? RenterFeatureCell
                cell?.selectionStyle = .none
                cell?.featureString = self.buildingDetailViewModel?.tagsString ?? []
                return cell ?? RenterFeatureCell.init(frame: .zero)
                //TODO:
                //共享办公专享 -
            //开发工位列表
            case FYDetailItemType.FYDetailItemTypeLianheOpenList:
                return UITableViewCell.init(frame: .zero)
                
            //独立办公室列表
            case FYDetailItemType.FYDetailItemTypeFYList:
                return UITableViewCell.init(frame: .zero)
                
            case FYDetailItemType.FYDetailItemTypeOfficeDeatail:
                let cell = tableView.dequeueReusableCell(withIdentifier: RenterOfficeBuildingMsgCell.reuseIdentifierStr) as? RenterOfficeBuildingMsgCell
                cell?.selectionStyle = .none
                if let introductionViewModel = self.buildingDetailViewModel?.introductionViewModel {
                    cell?.btype = buildingModel.btype
                    cell?.buildingMsgViewModel = introductionViewModel
                }
                return cell ?? RenterOfficeBuildingMsgCell()
                
            case FYDetailItemType.FYDetailItemTypeAmbitusMating:
                let cell = tableView.dequeueReusableCell(withIdentifier: RenterAmbitusMatingCell.reuseIdentifierStr) as? RenterAmbitusMatingCell
                cell?.selectionStyle = .none
                return cell ?? RenterAmbitusMatingCell()
                
            case .FYDetailItemTypeShareServices:
                let cell = tableView.dequeueReusableCell(withIdentifier: RenterShareServiceCell.reuseIdentifierStr) as? RenterShareServiceCell
                cell?.selectionStyle = .none
                if let buildingViewModel = self.buildingDetailViewModel?.buildingViewModel {
                    cell?.buildingViewModel = buildingViewModel
                }
                
                return cell ?? RenterShareServiceCell()
                
            case FYDetailItemType.FYDetailItemTypeHuxing:
                return UITableViewCell()
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { //共享办公
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return RenterJointDetailNameCell.rowHeight()
            }else {
                //判断是否显示开放工位
                if self.buildingDetailModel?.building?.openStationFlag == true {
                    return RenterJointDetailNameCell.rowHeight()
                    
                }else {
                    return 0
                }
            }
            
        }else if indexPath.section == 2 || indexPath.section == 3 {
            return RenterDetailFYListCell.rowHeight()
        }else {
            let type:FYDetailItemType = dataSourceArr[indexPath.section][indexPath.row]
            switch type {
            case FYDetailItemType.FYDetailItemOfficeBuildingNameView:
                return 0
            case FYDetailItemType.FYDetailItemTypeJointNameView:
                return 0
            case FYDetailItemType.FYDetailItemTypeTraffic:
                if isTrafficUp == true {
                    if let arr = buildingDetailModel?.building?.nearbySubwayTime {
                        return CGFloat(45 + 30 * arr.count + 2)
                    }else {
                        return 45 + 2
                    }
                }else {
                    if buildingDetailModel?.building?.nearbySubwayTime?.count ?? 0 > 0 {
                        return 45 + 30 + 2
                    }else {
                        return 45 + 2
                    }
                }
            case FYDetailItemType.FYDetailItemTypeFeature:
                if let tags = buildingDetailModel?.tags {
                    if tags.count > 0 {
                        if let height = buildingDetailViewModel?.tagsHeight {
                            return RenterFeatureCell.rowHeight0() + height
                        }else {
                            return RenterFeatureCell.rowHeight0() + 30
                        }
                    }else {
                        return 0
                    }
                }else {
                    return 0
                }
            case FYDetailItemType.FYDetailItemTypeLianheOpenList:
                return 0
            case FYDetailItemType.FYDetailItemTypeFYList:
                return 0
            case FYDetailItemType.FYDetailItemTypeOfficeDeatail:
                if let introductionViewModel = self.buildingDetailViewModel?.introductionViewModel {
                    return introductionViewModel.cellHeight
                }else {
                    return 0
                }


            case FYDetailItemType.FYDetailItemTypeAmbitusMating:
                return 79 + (41 + 10) * 3
            case .FYDetailItemTypeShareServices:
                if let buildingViewModel = self.buildingDetailViewModel?.buildingViewModel {
                    return buildingViewModel.shareServicesHeight
                }else {
                    return 0
                }
            case FYDetailItemType.FYDetailItemTypeHuxing:
                return 0
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { //共享办公
        if section == 0 {
            return 50
        }else if section == 2 {
            //判断是否显示开放工位
            if self.buildingDetailModel?.building?.openStationFlag == true {
                return 50
            }else {
                return 0
            }
        }else if section == 3 {
            //如果独立办公室数据数组大于0显示
            return 61 + 46 + 15
        }else {
            return 0
        }
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? { //共享办公
        if section == 0 {
            //如果开放工位数据数组大于0显示
            let view = UIView()
            view.backgroundColor = kAppWhiteColor
            let title = UILabel()
            title.frame = CGRect(x: left_pending_space_17, y: 15, width: kWidth - left_pending_space_17, height: 25)
            title.textColor = kAppColor_333333
            title.text = self.buildingDetailViewModel?.buildingViewModel?.buildingName
            title.font = FONT_16
            view.addSubview(title)
            return view
        }else if section == 2 {
            //判断是否显示开放工位
            let view = UIView()
            view.backgroundColor = kAppWhiteColor
            let title = UILabel()
            title.frame = CGRect(x: left_pending_space_17, y: 15, width: kWidth - left_pending_space_17, height: 25)
            title.textColor = kAppColor_333333
            title.text = "开放工位"
            title.font = FONT_15
            view.addSubview(title)
            //判断是否显示开放工位
            if self.buildingDetailModel?.building?.openStationFlag == true {
                return view
            }else {
                return UIView()
            }
        }else if section == 3 {
            //如果独立办公室数据数组大于0显示
            let view = UIView()
            view.backgroundColor = kAppWhiteColor
            let title = UILabel()
            title.frame = CGRect(x: left_pending_space_17, y: 9, width: kWidth - left_pending_space_17, height: 44)
            title.textColor = kAppColor_333333
            title.text = "独立办公室"
            title.font = FONT_15
            view.addSubview(title)
            
            if isClearCondition != true {
                view.addSubview(shaixuanConditionView)
            }else {
                if let factorMap = self.buildingDetailViewModel?.factorMap {
                    itemview.factorMap = factorMap
                }
                view.addSubview(itemview)
            }
            return view
        }else {
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat { //共享办公
        if section == 0 {
            return 0
        }else if section == 2 {
            return 0
        }else if section == 3 {
            //如果独立办公室数据数组大于0显示
            if isHiddenMoreData ?? false == true {
                return 0
            }else {
                return 78
            }
        }else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? { //共享办公
        if section == 2 {
            //如果开放工位数据数组大于0显示
            let view = UIView()
            return view
        }else if section == 3 {
            //如果独立办公室数据数组大于0显示
            let view = UIView()
            view.backgroundColor = kAppWhiteColor
            let btn = UIButton.init(frame: CGRect(x: left_pending_space_17, y: 22, width: kWidth - left_pending_space_17 * 2, height: 34))
            btn.titleLabel?.font = FONT_11
            btn.clipsToBounds = true
            btn.layer.cornerRadius = button_cordious_2
            btn.layer.borderColor = kAppBlueColor.cgColor
            btn.layer.borderWidth = 1.0
            btn.addTarget(self, action: #selector(loadNextPage), for: .touchUpInside)
            if isHiddenMoreData ?? false == true {
                btn.setTitle("没有更多了", for: .normal)
                btn.setTitleColor(kAppColor_333333, for: .normal)
                btn.layer.borderColor = kAppColor_line_EEEEEE.cgColor
                btn.backgroundColor = kAppColor_line_EEEEEE
                btn.isUserInteractionEnabled = false
            }else {
                btn.setTitle("查看更多", for: .normal)
                btn.setTitleColor(kAppBlueColor, for: .normal)
                btn.layer.borderColor = kAppBlueColor.cgColor
                btn.backgroundColor = kAppWhiteColor
                btn.isUserInteractionEnabled = true
            }
            view.addSubview(btn)
            return view
        }else {
            return UIView()
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { //共享办公
        
        if indexPath.section == 2 {
            //如果开放工位数据数组大于0显示
            
        }else if indexPath.section == 3 {
            //独立办公室
            if let model = self.dataSource[indexPath.row] as? FangYuanBuildingOpenStationModel {
                model.btype = 2
                let vc = RenterOfficeJointFYDetailVC()
                vc.model = model
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
}

extension RenterOfficeJointDetailVC {
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
        
        //只有不是true的时候调用
        if isRead != true {
            if (scrollView.contentSize.height - scrollView.contentOffset.y) <= (1 + self.view.height) {
                isRead = true
            }
        }
    }
}

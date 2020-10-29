//
//  RenterOfficebuildingDetailVC.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/5/11.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit
import WMPlayer
import HandyJSON
import SwiftyJSON

class RenterOfficebuildingDetailVC: BaseGroupTableViewController, WMPlayerDelegate {
    
    ///是否来自于房源管理 预览 -
    var isFromOwnerScan : Bool?
    
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
            setCollectBtnState(isCollect: false)
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
        if let img = buildingDetailViewModel?.buildingViewModel?.smallImg {
            shareVC.thumbImage = img
        }else {
            shareVC.thumbImage = buildingDetailViewModel?.buildingViewModel?.mainPic
        }
        shareVC.shareUrl = "\(SSAPI.SSH5Host)\(SSDelegateURL.h5BuildingDetailShareUrl)?isShare=\(UserTool.shared.user_channel)&buildingId=\(buildingDetailViewModel?.buildingViewModel?.buildingId ?? 0)"
        shareVC.modalPresentationStyle = .overFullScreen
        self.present(shareVC, animated: true, completion: {})
    }
    
    func setItemFunc() {
        
        //1是写字楼，2是共享办公
        
        //判断 - 如果传过来的面积值字符串大于0 说明有筛选过
        if let params = shaiXuanParams {
            if let seats = params["area"] {
                let str = seats as? String
                if str?.count ?? 0 > 0 {
                    shaixuanAreaSeatsString = str?.replacingOccurrences(of: ",", with: "~")
                    shaixuanAreaSeatsString = shaixuanAreaSeatsString?.replacingOccurrences(of: String(format: "%.0f", noLimitMaxNum_999999999), with: "不限")
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
        
        
        //写字楼 -
        //名称基本信息 - 公交 特色
        self.dataSourceArr.append([
            FYDetailItemType.FYDetailItemOfficeBuildingNameView,
            FYDetailItemType.FYDetailItemTypeTraffic,
            FYDetailItemType.FYDetailItemTypeFeature])
        //在租写字楼
        self.dataSourceArr.append([
            FYDetailItemType.FYDetailItemTypeFYList])
        //楼盘信息 - 周边配套
        self.dataSourceArr.append([
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
    func getClickItemString(index: Int) { //写字楼
        
        switch index {
        case 0:
            clickItemString = ""
        case 1:
            clickItemString = "0,100"
        case 2:
            clickItemString = "100,200"
        case 3:
            clickItemString = "200,300"
        case 4:
            clickItemString = "300,400"
        case 5:
            clickItemString = "400,500"
        case 6:
            clickItemString = "500,1000"
        case 7:
            clickItemString = "1000,999999999"
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
        
        
        ///如果是来自于业主预览或者是业主身份的时候，请求业主房源列表
        if isFromOwnerScan == true && UserTool.shared.user_id_type == 1 {

            var params = [String:AnyObject]()
            
            if let parr = shaiXuanParams {
                params = parr
            }
            params["pageNo"] = self.pageNo as AnyObject
            params["pageSize"] = self.pageSize as AnyObject
            params["btype"] = buildingModel.btype as AnyObject?
            params["buildingId"] = buildingModel.id as AnyObject?
            params["isTemp"] = buildingModel.isTemp as AnyObject?

            ///只有点击清楚按钮之后 - 用自己选择的面积
            if isClearCondition == true {
                params["area"] = clickItemString as AnyObject?
            }
            SSNetworkTool.SSFYDetail.request_getBuildingFYList(params: params, success: { [weak self] (response) in
                guard let weakSelf = self else {return}
                if let decoratedArray = JSONDeserializer<FangYuanBuildingOpenStationModel>.deserializeModelArrayFrom(json: JSON(response["data"] ?? "").rawString() ?? "", designatedPath: "list") {
                    weakSelf.dataSource = weakSelf.dataSource + decoratedArray
                    weakSelf.endRefreshWithCount(decoratedArray.count)
                    
                    //显示带过来的筛选条件
                    if weakSelf.isClearCondition != true {
                        
                        SSTool.invokeInMainThread {
                            weakSelf.shaixuanConditionView.titleView.text = "\(weakSelf.shaixuanAreaSeatsString ?? "全部")㎡ \n \(weakSelf.dataSource.count)套"
                        }
                        
                        ///神策楼盘详情页筛选房源
                        SensorsAnalyticsFunc.building_data_page_screen(buildingId: "\(weakSelf.buildingModel.id ?? 0)", houseCnt: weakSelf.dataSource.count)
                        
                    }else {
                        
                        ///点击楼盘详情页房源筛选按钮
                        if weakSelf.clickItemString == "" {
                            SensorsAnalyticsFunc.click_building_data_page_screen_button(buildingId: "\(weakSelf.buildingModel.id ?? 0)", area: "全部", simple: "")
                        }else {
                            SensorsAnalyticsFunc.click_building_data_page_screen_button(buildingId: "\(weakSelf.buildingModel.id ?? 0)", area: weakSelf.clickItemString, simple: "")
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
        }else {

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
                params["area"] = clickItemString as AnyObject?
            }
            SSNetworkTool.SSFYDetail.request_getBuildingFYList(params: params, success: { [weak self] (response) in
                guard let weakSelf = self else {return}
                if let decoratedArray = JSONDeserializer<FangYuanBuildingOpenStationModel>.deserializeModelArrayFrom(json: JSON(response["data"] ?? "").rawString() ?? "", designatedPath: "list") {
                    weakSelf.dataSource = weakSelf.dataSource + decoratedArray
                    weakSelf.endRefreshWithCount(decoratedArray.count)
                    
                    //显示带过来的筛选条件
                    if weakSelf.isClearCondition != true {
                        
                        SSTool.invokeInMainThread {
                            weakSelf.shaixuanConditionView.titleView.text = "\(weakSelf.shaixuanAreaSeatsString ?? "全部")㎡ \n \(weakSelf.dataSource.count)套"
                        }
                        
                        ///神策楼盘详情页筛选房源
                        SensorsAnalyticsFunc.building_data_page_screen(buildingId: "\(weakSelf.buildingModel.id ?? 0)", houseCnt: weakSelf.dataSource.count)
                        
                    }else {
                        
                        ///点击楼盘详情页房源筛选按钮
                        if weakSelf.clickItemString == "" {
                            SensorsAnalyticsFunc.click_building_data_page_screen_button(buildingId: "\(weakSelf.buildingModel.id ?? 0)", area: "全部", simple: "")
                        }else {
                            SensorsAnalyticsFunc.click_building_data_page_screen_button(buildingId: "\(weakSelf.buildingModel.id ?? 0)", area: weakSelf.clickItemString, simple: "")
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
        
        ///如果是来自于业主预览或者是业主身份的时候，不展示收藏和聊天按钮
        if isFromOwnerScan == true && UserTool.shared.user_id_type == 1 {
              ///房源当前状态0未发布，1发布，2下架,3:待完善
            if buildingModel.status != 1 {
                titleview?.shareButton.isHidden = true
            }
            
        }
        titleview?.rightBtnsssClickBlock = { [weak self] (index) in
            if index == 99 {
                
                ///如果是来自于业主预览或者是业主身份的时候，不展示收藏和聊天按钮
                if self?.isFromOwnerScan == true && UserTool.shared.user_id_type == 1 {
                      ///-1:不是管理员 暂无权限编辑楼盘(临时楼盘),0: 下架(未发布),1: 上架(已发布) ;2:资料待完善 ,3: 置顶推荐;4:已售完;5:删除;6待审核7已驳回 注意：（IsTemp为1时，status状态标记 1:待审核 -转6 ,2:已驳回 -转7 ）
                    if self?.buildingModel.status != 1 {
                        AppUtilities.makeToast("楼盘已下架，请先上架后再分享")
                    }else {
                        self?.shareClick()
                        self?.shareVc()
                    }
                }else {
                    self?.shareClick()
                    self?.shareVc()
                }
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
        
        //楼盘信息
        self.tableView.register(RenterOfficeBuildingMsgCell.self, forCellReuseIdentifier: RenterOfficeBuildingMsgCell.reuseIdentifierStr)

        //周边配套
        //        self.tableView.register(UINib.init(nibName: RenterAmbitusMatingCell.reuseIdentifierStr, bundle: nil), forCellReuseIdentifier: RenterAmbitusMatingCell.reuseIdentifierStr)
        
        //        在租写字楼
        self.tableView.register(RenterDetailOfficeListCell.self, forCellReuseIdentifier: RenterDetailOfficeListCell.reuseIdentifierStr)
        
        self.view.addSubview(bottomBtnView)
        
        bottomBtnView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
            make.bottom.equalToSuperview().offset(-bottomMargin())
        }
        
        ///如果是来自于业主预览或者是业主身份的时候，不展示收藏和聊天按钮
        if isFromOwnerScan == true && UserTool.shared.user_id_type == 1 {
            bottomBtnView.isHidden = true
            self.tableView.snp.remakeConstraints { (make) in
                make.leading.trailing.equalToSuperview()
                make.top.equalTo(0)
                make.bottom.equalToSuperview().offset(-(bottomMargin()))
            }
        }else {
            self.tableView.snp.remakeConstraints { (make) in
                make.leading.trailing.equalToSuperview()
                make.top.equalTo(0)
                make.bottom.equalToSuperview().offset(-(bottomMargin() + 50))
            }
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
            //1
            if weakSelf.dataSourceArr.count > 0 {
                if weakSelf.dataSource.count > 0 {
                    weakSelf.tableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: true)
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
    
    
    //MARK: 获取租户详情
    func requestRenterDetail() {
        
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
    
    
    //MARK: 获取业主预览详情
    func requestOwnerDetail() {
        
        var params = [String:AnyObject]()
        
        if let parr = shaiXuanParams {
            params = parr
        }
        
        params["token"] = UserTool.shared.user_token as AnyObject?
        params["btype"] = buildingModel.btype as AnyObject?
        params["buildingId"] = buildingModel.id as AnyObject?
        params["isTemp"] = buildingModel.isTemp as AnyObject?
        
        SSNetworkTool.SSFYDetail.request_getBuildingbyBuildingIdPreviewApp(params: params, success: {[weak self] (response) in
            
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
    
    
    //MARK: 调用详情接口 -
    override func refreshData() {
        
        ///如果是来自于业主预览或者是业主身份的时候，请求预览接口
        if isFromOwnerScan == true && UserTool.shared.user_id_type == 1 {
            requestOwnerDetail()
        }else {
            requestRenterDetail()
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
extension RenterOfficebuildingDetailVC: RenterDetailSourceViewImgScanDelegate{
    func vrClick() {
        if let vrArr = buildingDetailModel?.vrUrl {
            if vrArr.count > 0 {
                let vrModel = vrArr[0]
                let vc = VRScanWebViewController()
                vc.urlString = vrModel.imgUrl
                vc.titleString = buildingDetailModel?.building?.name
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


extension RenterOfficebuildingDetailVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        //写字楼
        dataSourceArr.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { //写字楼
        //在租写字楼
        if section == 1 {
            return dataSource.count
        }else {
            return self.dataSourceArr[section].count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { //写字楼
        if indexPath.section == 1 {
            //办公室
            let cell = tableView.dequeueReusableCell(withIdentifier: RenterDetailOfficeListCell.reuseIdentifierStr) as? RenterDetailOfficeListCell
            cell?.selectionStyle = .none
            if let model = self.dataSource[indexPath.row] as? FangYuanBuildingOpenStationModel {
                model.btype = 1
                cell?.model = model
            }
            
            return cell ?? RenterDetailOfficeListCell.init(frame: .zero)
        }else {
            let type:FYDetailItemType = dataSourceArr[indexPath.section][indexPath.row]
            
            switch type {
                
            case FYDetailItemType.FYDetailItemOfficeBuildingNameView:
                let cell = tableView.dequeueReusableCell(withIdentifier: RenterDetailNameCell.reuseIdentifierStr) as? RenterDetailNameCell
                cell?.selectionStyle = .none
                if let buildingViewModel = self.buildingDetailViewModel?.buildingViewModel {
                    cell?.viewModel = buildingViewModel
                }else {
                    cell?.model = self.buildingDetailModel?.building ?? FangYuanBuildingBuildingModel()
                }
                return cell ?? RenterDetailNameCell()
            case FYDetailItemType.FYDetailItemTypeJointNameView:
                return UITableViewCell.init(frame: .zero)
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
                
            case FYDetailItemType.FYDetailItemTypeLianheOpenList:
                return UITableViewCell.init(frame: .zero)
                
            case FYDetailItemType.FYDetailItemTypeFYList: //在租写字楼 -
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
                return UITableViewCell()
                
            case FYDetailItemType.FYDetailItemTypeHuxing:
                return UITableViewCell()
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { //写字楼
        if indexPath.section == 1 {
            return RenterDetailOfficeListCell.rowHeight()
        }else {
            let type:FYDetailItemType = dataSourceArr[indexPath.section][indexPath.row]
            switch type {
            case FYDetailItemType.FYDetailItemOfficeBuildingNameView:
                return RenterDetailNameCell.rowHeight()
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
                        return 42 + 30 + 2
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
            //            return 241 + huxingConstangHeight.constant
            case .FYDetailItemTypeShareServices:
                return 0
            case FYDetailItemType.FYDetailItemTypeHuxing:
                return 0
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { //写字楼
        if section == 1 {
            return 61 + 46 + 15
        }else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? { //写字楼
        if section == 1 {
            //如果开放工位数据数组大于0显示
            let view = UIView()
            view.backgroundColor = kAppWhiteColor
            let title = UILabel()
            title.frame = CGRect(x: left_pending_space_17, y: 9, width: kWidth - left_pending_space_17, height: 44)
            title.textColor = kAppColor_333333
            title.text = "在租写字楼"
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
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat { //写字楼
        if section == 1 {
            //如果写字楼数据数组大于0显示
            if isHiddenMoreData ?? false == true {
                return 0
            }else {
                return 78
            }
        }else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? { //写字楼
        if section == 1 {
            //如果开放工位数据数组大于0显示
            let view = UIView()
            view.backgroundColor = kAppWhiteColor
            let btn = UIButton.init(frame: CGRect(x: left_pending_space_17, y: 22, width: kWidth - left_pending_space_17 * 2, height: 34))
            btn.titleLabel?.font = FONT_11
            btn.clipsToBounds = true
            btn.layer.cornerRadius = button_cordious_2
            btn.layer.borderWidth = 1.0
            btn.addTarget(self, action: #selector(loadNextPage), for: .touchUpInside)
            //如果没有更多就显示灰色
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { //写字楼
        if indexPath.section == 1 {
            if let model = self.dataSource[indexPath.row] as? FangYuanBuildingOpenStationModel {
                model.btype = 1
                let vc = RenterOfficebuildingFYDetailVC()
                vc.isFromOwnerScan = isFromOwnerScan
                vc.model = model
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
}

extension RenterOfficebuildingDetailVC {
    
}

extension RenterDetailSourceView: CycleViewDelegate{
    
    func cycleViewDidSelectedItemAtIndex(_ index: NSInteger) {
        imgScanDelegate?.imgClickScan(index: index, imgURLs: cycleView.imageURLStringArr)
    }
}

extension RenterDetailSourceView: WMPlayerDelegate{
    //点击播放暂停按钮代理方法
    func wmplayer(_ wmplayer: WMPlayer!, clickedPlayOrPause playOrPauseBtn: UIButton!) {
        
    }
    //播放完毕的代理方法
    func wmplayerFinishedPlay(_ wmplayer: WMPlayer!) {
        
    }
    
    
    func wmplayer(_ wmplayer: WMPlayer!, isHiddenTopAndBottomView isHidden: Bool) {
        //        if isHidden {
        //            self.changeBtnView.isHidden = true
        //        }else {
        //            self.changeBtnView.isHidden = false
        //        }
    }
    
    //点击全屏按钮代理
    func wmplayer(_ wmplayer: WMPlayer!, clickedFullScreenButton fullScreenBtn: UIButton!) {
        
    }
    
    func wmplayerReady(toPlay wmplayer: WMPlayer!, wmPlayerStatus state: WMPlayerState) {
        
    }
    
}


public protocol RenterDetailSourceViewImgScanDelegate {
    
    ///图片点击查看代理
    func imgClickScan(index: Int, imgURLs: [String])
    
    ///vr点击查看
    func vrClick()
}

class RenterDetailSourceView: UIView {
    
    open var imgScanDelegate: RenterDetailSourceViewImgScanDelegate?

    deinit {
        wmPlayer?.pause()
        wmPlayer?.removeFromSuperview()
        wmPlayer = nil
    }
    
    func pausePlayer() {
        wmPlayer?.pause()
    }
    
    func releaseWMplayer() {
        pausePlayer()
        wmPlayer?.removeFromSuperview()
        wmPlayer = nil
    }
    
    var model: FangYuanBuildingDetailViewModel = FangYuanBuildingDetailViewModel(model: FangYuanBuildingDetailModel()) {
        didSet {
            
            self.cycleView.imageURLStringArr = model.imgUrl ?? []
            if model.imgUrl?.count ?? 0 > 0 {
                vrView.setImage(with: model.imgUrl?[0] ?? "")
            }
            
            ///只要有vr，其他的都隐藏
            if model.isHasVR == true {
                
                changeBtnView.isHidden = false
                
                vrView.isHidden = false
                videoView.isHidden = true
                wmPlayer?.isHidden = true
                cycleView.isHidden = true
                
                if model.isHasVideo == true {
                    
                    let videoUrl = model.videoUrl?[0]
                    let player = WMPlayerModel()
                    player.videoURL = URL.init(string: videoUrl ?? "")
                    playerModel = player
                    
                    changeBtnView.titleArrs = [BuildingDetailHeaderTypeEnum.vr, BuildingDetailHeaderTypeEnum.video, BuildingDetailHeaderTypeEnum.image]
                }else {
                    changeBtnView.titleArrs = [BuildingDetailHeaderTypeEnum.vr, BuildingDetailHeaderTypeEnum.image]
                }
                
            } else {
                
                ///没有vr
                ///有视频
                if model.isHasVideo == true {
                    
                    let videoUrl = model.videoUrl?[0]
                    let player = WMPlayerModel()
                    player.videoURL = URL.init(string: videoUrl ?? "")
                    playerModel = player
                    
                    changeBtnView.isHidden = false
                    
                    changeBtnView.titleArrs = [ BuildingDetailHeaderTypeEnum.video, BuildingDetailHeaderTypeEnum.image]

                    vrView.isHidden = true
                    videoView.isHidden = false
                    wmPlayer?.isHidden = false
                    cycleView.isHidden = true
                    
                }else {
                    ///没视频
                    
                    changeBtnView.isHidden = true
                    
                    changeBtnView.titleArrs = []

                    vrView.isHidden = true
                    videoView.isHidden = true
                    wmPlayer?.isHidden = true
                    cycleView.isHidden = false
                    
                }
            }
        }
    }
    
    var FYModel: FangYuanBuildingFYDetailViewModel = FangYuanBuildingFYDetailViewModel(model: FangYuanBuildingFYDetailModel()) {
        didSet {
            
            self.cycleView.imageURLStringArr = FYModel.imgUrl ?? []
            if FYModel.imgUrl?.count ?? 0 > 0 {
                vrView.setImage(with: FYModel.imgUrl?[0] ?? "")
            }
            
            ///只要有vr，其他的都隐藏
            if FYModel.isHasVR == true {
                
                changeBtnView.isHidden = false
                
                vrView.isHidden = false
                videoView.isHidden = true
                wmPlayer?.isHidden = true
                cycleView.isHidden = true
                
                if FYModel.isHasVideo == true {
                    
                    let videoUrl = FYModel.videoUrl?[0]
                    let player = WMPlayerModel()
                    player.videoURL = URL.init(string: videoUrl ?? "")
                    playerModel = player
                    
                    changeBtnView.titleArrs = [BuildingDetailHeaderTypeEnum.vr, BuildingDetailHeaderTypeEnum.video, BuildingDetailHeaderTypeEnum.image]
                }else {
                    changeBtnView.titleArrs = [BuildingDetailHeaderTypeEnum.vr, BuildingDetailHeaderTypeEnum.image]
                }
                
            } else {
                
                ///没有vr
                ///有视频
                if FYModel.isHasVideo == true {
                    
                    let videoUrl = FYModel.videoUrl?[0]
                    let player = WMPlayerModel()
                    player.videoURL = URL.init(string: videoUrl ?? "")
                    playerModel = player
                    
                    changeBtnView.isHidden = false
                    
                    changeBtnView.titleArrs = [ BuildingDetailHeaderTypeEnum.video, BuildingDetailHeaderTypeEnum.image]

                    vrView.isHidden = true
                    videoView.isHidden = false
                    wmPlayer?.isHidden = false
                    cycleView.isHidden = true
                    
                }else {
                    ///没视频
                    
                    changeBtnView.isHidden = true
                    
                    changeBtnView.titleArrs = []

                    vrView.isHidden = true
                    videoView.isHidden = true
                    wmPlayer?.isHidden = true
                    cycleView.isHidden = false
                    
                }
            }
        }
    }
    
    lazy var cycleView: CycleView = {
        //轮播图加载 - 设置头部
        let pointY: CGFloat = 0
        let view = CycleView(frame: self.frame)
        view.delegate = self
        view.mode = .scaleAspectFill
        return view
    }()
    
    //视频播放view
    lazy var videoView: UIView = {
        let view = UIView.init(frame: self.frame)
        view.isHidden = true
        view.backgroundColor = kAppBlackColor
        return view
    }()
    
    //vr播放view
    lazy var vrView: BaseImageView = {
        let view = BaseImageView.init(frame: self.frame)
        view.isHidden = true
        view.isUserInteractionEnabled = true
        view.backgroundColor = kAppClearColor
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    //vr播放按钮
    lazy var vrPlayBtn: UIButton = {
        let view = UIButton()
        view.setImage(UIImage.init(named: "vrPlayBlue"), for: .normal)
        return view
    }()
    
    var playerModel: WMPlayerModel = WMPlayerModel() {
        didSet {
            setPlayer()
        }
    }
    
    var wmPlayer: WMPlayer?
    
    func setPlayer() {
        wmPlayer = WMPlayer(playerModel: playerModel)
        wmPlayer?.delegate = self
        wmPlayer?.backBtnStyle = .none
        wmPlayer?.fullScreenBtn.isHidden = true
        videoView.addSubview(wmPlayer ?? WMPlayer(playerModel: playerModel))
        wmPlayer?.snp.makeConstraints { (make) in
            make.top.leading.bottom.trailing.equalToSuperview()
        }
    }
    
    var changeBtnView: ButtonCycleSelectItemView = {
        let view = ButtonCycleSelectItemView.init(frame: CGRect(x: (kWidth - 45 * 3) / 2.0, y: 220, width: 45 * 3, height: 24), selectedindex: 0)
        view.isHidden = true
        return view
    }()
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func vrPlay() {
        imgScanDelegate?.vrClick()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        
        cycleView.invalidateTimer()
        
        addSubview(cycleView)
        addSubview(videoView)
        addSubview(vrView)
        vrView.addSubview(vrPlayBtn)
        vrPlayBtn.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(50)
        }
        vrPlayBtn.addTarget(self, action: #selector(vrPlay), for: .touchUpInside)
        
        addSubview(changeBtnView)
        
        changeBtnView.buttonCallBack = {[weak self] (index) in
            
            if index == 1 {
                self?.vrView.isHidden = false
                self?.videoView.isHidden = true
                self?.wmPlayer?.isHidden = true
                self?.cycleView.isHidden = true
                self?.wmPlayer?.pause()
            }else if index == 2 {
                self?.vrView.isHidden = true
                self?.videoView.isHidden = false
                self?.wmPlayer?.isHidden = false
                self?.cycleView.isHidden = true
                self?.wmPlayer?.pause()
            }else if index == 3 {
                self?.vrView.isHidden = true
                self?.videoView.isHidden = true
                self?.wmPlayer?.isHidden = true
                self?.cycleView.isHidden = false
                self?.wmPlayer?.pause()
            }
            self?.changeBtnView.isHidden = false
        }
    }
    
}


//筛选条件view显示
class ShaixuanConditionSelectView: UIView {
    
    var titleView: UILabel = {
        var view = UILabel()
        view.numberOfLines = 2
        view.font = FONT_13
        view.textColor = kAppBlueColor
        return view
    }()
    
    var clearBtn: UIButton = {
        let view = UIButton()
        view.setImage(UIImage.init(named: "closeBlue"), for: .normal)
        return view
    }()
    
    var clearCallBack:(() -> Void)?
    
    @objc func btnClick(btn: UIButton) {
        
        guard let block = clearCallBack else {
            return
        }
        block()
    }
    
    public override required init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        
        self.clipsToBounds = true
        self.layer.cornerRadius = button_cordious_2
        self.layer.borderColor = kAppBlueColor.cgColor
        self.layer.borderWidth = 1.0
        
        self.backgroundColor = kAppWhiteColor
        
        self.addSubview(titleView)
        self.addSubview(clearBtn)
        
        clearBtn.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
        
        titleView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(left_pending_space_17)
        }
        
        clearBtn.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.trailing.equalTo(-left_pending_space_17)
            make.width.equalTo(20)
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension RenterOfficebuildingDetailVC {
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

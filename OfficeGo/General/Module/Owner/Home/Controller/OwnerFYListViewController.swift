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


class OwnerVRView: UIView {

    lazy var bgview:UIView = {
        let view = UIView()
        view.backgroundColor = kAppLightBlueColor
        return view
    }()
   
    lazy var img : UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        view.image = UIImage.init(named: "VRCreat")
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.text = "现在预约，即可享受优惠！"
        view.textColor = kAppBlueColor
        view.font = FONT_14
        return view
    }()
            
    lazy var button : UIButton = {
        let view = UIButton()
        view.setTitle("预约VR录制", for: .normal)
        view.titleLabel?.font = FONT_MEDIUM_14
        view.clipsToBounds = true
        view.layer.cornerRadius = button_cordious_8
        view.backgroundColor = kAppBlueColor
        view.addTarget(self, action: #selector(leftBtnClick), for: .touchUpInside)
        return view
    }()
    
    var headerBtnClickBlock: (() -> Void)?
    
    
    @objc func leftBtnClick() {
        guard let blockk = headerBtnClickBlock else {
            return
        }
        blockk()
    }
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    private func setupView() {
        
        addSubview(bgview)
        addSubview(img)
        addSubview(titleLabel)
        addSubview(button)

       
        bgview.snp.makeConstraints { (make) in
            make.top.leading.bottom.trailing.equalToSuperview().inset(10)
        }
        img.snp.makeConstraints { (make) in
            make.top.leading.bottom.equalTo(bgview)
            make.size.equalTo(38)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(bgview)
            make.leading.equalTo(img.snp.trailing).offset(3)
        }
        //只有房东才会出现
        button.snp.makeConstraints { (make) in
            make.trailing.equalTo(bgview.snp.trailing).offset(-6)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 100, height: 30))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class OwnerFYListViewController: BaseGroupTableViewController {
    
    
    lazy var loginPCScanView: OWnerAddFYFirstAlertView = {
        let view = OWnerAddFYFirstAlertView(frame: self.view.frame)
        return view
    }()
    
    ///未认证页面
    lazy var toIdentifyView: OWnerToIdentifyView = {
        let view = OWnerToIdentifyView(frame: CGRect(x: 0, y: kNavigationHeight + 68 , width: kWidth, height: kHeight - kNavigationHeight - 68))
        view.isHidden = true
        return view
    }()
    
    ///认证中
    lazy  var identifyStatusView: OWnerIdentifyStatusView = {
        let view = OWnerIdentifyStatusView(frame: CGRect(x: 0, y: kNavigationHeight + 68 , width: kWidth, height: kHeight - kNavigationHeight - 68))
        view.isHidden = true
        return view
    }()
    
    lazy var vrView: OwnerVRView = {
        let view = OwnerVRView()
        return view
    }()
    
    ///判断身份和认证类型
    var userModel: LoginUserModel?
    
    var buildingListVC = OwnerBuildingListViewController()

        ///身份类型0个人1企业2联合
    //    let identify: Int = userModel?.identityType ?? -1

    ///楼盘模型
    var buildingListViewModel : OwnerBuildingListViewModel? {
        didSet {
            
            ///是否已经展示过添加房源浮层
            if UserTool.shared.isShowAddFYGuide != true {
                loginPCScanView.ShowOWnerAddFYFirstAlertView {
                    
                } sureHouseSortButtonCallBack: {
                    
                }
            }
            
            ///可以添加，按钮不隐藏
            if  buildingListViewModel?.isAddHouse == true  {
                titleview?.rightButton.isHidden = false
            }else {
                titleview?.rightButton.isHidden = true
            }
            
            titleview?.titleLabel.text = buildingListViewModel?.buildingName
            
            ///根据楼盘状态展示样式设置楼盘样式
            ///-1:不是管理员 暂无权限编辑楼盘(临时楼盘),0: 下架(未发布),1: 上架(已发布) ;2:资料待完善 ,3: 置顶推荐;4:已售完;5:删除;6待审核7已驳回 注意：（IsTemp为1时，status状态标记 1:待审核 -转6 ,2:已驳回 -转7 ）
            identifyStatusView.buildingListViewModel = buildingListViewModel
            
            ///临时
            if buildingListViewModel?.isTemp == true {
                
                ///没值的时候，清除列表数据
                pageNo = 1
                
                if self.dataSource.count > 0 {
                    self.dataSource.removeAll()
                }
                
                if self.dataSourceViewModel.count > 0 {
                    self.dataSourceViewModel.removeAll()
                }
                                
                noDataViewSet()
                
                self.tableView.reloadData()


            }else {
                loadNewData()
            }
        }
    }
    
    ///点击重新加载
    override func clickReloadData() {
        
        SendNetworkStatus()

        if buildingListViewModel == nil {
            
            requestBuildingList()
        }else {
                        
            loadNewData()
        }
        
    }
    
    @objc override func loadNewData(){
        
        pageNo = 1
        
        if self.dataSource.count > 0 {
            self.dataSource.removeAll()
        }
        
        if self.dataSourceViewModel.count > 0 {
            self.dataSourceViewModel.removeAll()
        }
        
        requestHouseList()
    }
    
    @objc override func loadNextPage() {
        pageNo += 1
        requestHouseList()
    }
    
    
    var dataSourceViewModel: [OwnerFYListViewModel?] = []
    
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
                
        requestUserMessage()

    }
    
    func addNotify() {
        
        //房源信息更改
        NotificationCenter.default.addObserver(forName: NSNotification.Name.OwnerFYReload, object: nil, queue: OperationQueue.main) { [weak self] (noti) in
            
            self?.loadNewData()
        }
        
        //楼盘重新认证 成功通知 - 请求楼盘列表，刷新这个楼盘的状态和数据
        NotificationCenter.default.addObserver(forName: NSNotification.Name.OwnerIdentifySuccess, object: nil, queue: OperationQueue.main) { [weak self] (noti) in
        
            self?.delay3request()
        }
        
    }
    
    func delay3request() {
        SSTool.delay(time: 1) { [weak self] in
            self?.requestReIdentifyBuildingList()
        }
    }
    func requestReIdentifyBuildingList() {
        
        var params = [String:AnyObject]()
        
        params["token"] = UserTool.shared.user_token as AnyObject?
        params["pageNo"] = 1 as AnyObject
        params["pageSize"] = 1 as AnyObject

        SSNetworkTool.SSFYManager.request_getBuildingList(params: params, success: { [weak self] (response) in
            guard let weakSelf = self else {return}
            if let decoratedArray = JSONDeserializer<OwnerBuildingListModel>.deserializeModelArrayFrom(json: JSON(response["data"] ?? "").rawString() ?? "", designatedPath: "list") {
                for model in decoratedArray {
                    if model?.buildingId == weakSelf.buildingListViewModel?.buildingId {
                        weakSelf.buildingListViewModel = OwnerBuildingListViewModel.init(model: model ?? OwnerBuildingListModel())
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        
        addNotify()
        
    }
    
    @objc func requestUserMessage() {
        
        SSNetworkTool.SSMine.request_getOwnerUserMsg(success: {[weak self] (response) in

            guard let weakSelf = self else {return}
            
            if let model = LoginUserModel.deserialize(from: response, designatedPath: "data") {
                
                weakSelf.userModel = model
                
                UserTool.shared.user_name = model.nickname
                UserTool.shared.user_nickname = model.nickname
                UserTool.shared.user_avatars = model.avatar
                UserTool.shared.user_company = model.company
                UserTool.shared.user_job = model.job
                UserTool.shared.user_sex = model.sex
                UserTool.shared.user_phone = model.phone
                UserTool.shared.user_wechat = model.wxId
                weakSelf.idifyShowView()
            }
            
            }, failure: { (error) in
                
        }) { (code, message) in
            
            //只有5000 提示给用户
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" {
                AppUtilities.makeToast(message)
            }
        }
    }
    
    //认证状态和引导显示 -
    //如果没有认证 - 显示弹框 -
    func idifyShowView() {
        
        
        ///审核状态0待审核1审核通过2审核未通过 3过期，当驳回2处理 - 没有提交过为-1
        let auditStatus: Int = userModel?.auditStatus ?? -1
        
        ///未认证 - 去认证弹框
        if auditStatus == -1 {
            
            /// 是否已经展示过去认证弹框 - 切换身份或者换账号登录都要展示
            if UserTool.shared.isShowOWnerToIdentifyGuide != true {
                let alert = OwnerNoIdentifyShowView(frame: self.view.frame)
                alert.ShowOwnerNoIdentifyShowView(clearButtonCallBack: { [weak self] in
                    ///隐藏弹框 - 展示去认证页面
                    self?.showNoIdentifyView()
                }) { [weak self] in
                    ///跳转去认证页面
                    ///点击跳转认证页面
                    let vc = NewIdentifyViewController()
                    vc.isFrist = "1"
                    self?.navigationController?.pushViewController(vc, animated: false)
                }
            }else {
                identifyStatusView.isHidden = true
                toIdentifyView.isHidden = false
            }

        }
        ///审核通过 - 判断有没有buildinglist
        else if auditStatus == 1 {
            
            toIdentifyView.isHidden = true
            
            ///没有选择过楼盘，请求楼盘，请求房源列表
            if buildingListViewModel == nil {
                
                requestBuildingList()
                
            }else {
                ///数据不做刷新
                ///已经选择过楼盘了，请求房源列表
//                if pageNo == 1 {
//                    loadNewData()
//                }
            }
        }
        ///0待审核 2审核未通过 3过期 2驳回处理
        else {
            identifyStatusView.isHidden = false
            toIdentifyView.isHidden = true
        }
        
    }
    
    ///MARK: 隐藏无数据view
    override func noDataViewSet() {
        noDataView.isHidden = true
        ///数据大于0 隐藏状态页面
        if self.dataSource.count > 0 {
            identifyStatusView.isHidden = true
        }else {
            //展示楼盘状态页面
            identifyStatusView.isHidden = false
            self.tableView.mj_footer?.isHidden = true
        }
    }
    
    
    func requestHouseList() {
        
        var params = [String:AnyObject]()
        
        params["token"] = UserTool.shared.user_token as AnyObject?
        params["pageNo"] = self.pageNo as AnyObject
        params["pageSize"] = 10 as AnyObject
        params["btype"] = buildingListViewModel?.btype as AnyObject?
        params["buildingId"] = buildingListViewModel?.buildingId as AnyObject?
        ///是不是临时的楼盘；0不是，1是
        params["isTemp"] = buildingListViewModel?.isTemp as AnyObject?

        SSNetworkTool.SSFYManager.request_getHouseLists(params: params, success: { [weak self] (response) in
            guard let weakSelf = self else {return}
            if let decoratedArray = JSONDeserializer<OwnerFYListModel>.deserializeModelArrayFrom(json: JSON(response["data"] ?? "").rawString() ?? "", designatedPath: "list") {
                weakSelf.dataSource = weakSelf.dataSource + decoratedArray
                for model in decoratedArray {
                    model?.btype = weakSelf.buildingListViewModel?.btype
                    let viewmodel = OwnerFYListViewModel.init(model: model ?? OwnerFYListModel())
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
    
    
    func showNoIdentifyView() {
        
        toIdentifyView.isHidden = false
    }
    
    func identifyStatus() {
        
        ///未认证弹框
        self.view.addSubview(toIdentifyView)
        
        ///认证状态页面
        self.view.addSubview(identifyStatusView)
        
        toIdentifyView.sureIdentifyButtonCallBack = { [weak self] in
            ///跳转去认证页面
            ///点击跳转认证页面
            let vc = NewIdentifyViewController()
            vc.isFrist = "1"
            self?.navigationController?.pushViewController(vc, animated: false)
        }
        
        identifyStatusView.sureIdentifyButtonCallBack = { [weak self] in
            ///认证驳回
            let vc = NewIdentifyViewController()
            vc.buildingId = "\(self?.buildingListViewModel?.buildingId ?? 0)"
            self?.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    //展示在pc登录的弹框
    func showAddFYAlertView() {
        
        ///点击过
        if buildingListViewModel?.btype == 1 {
            ///办公室
            let vc = OwnerBuildingOfficeViewController()
            vc.buildingIsTemp = buildingListViewModel?.isTemp
            vc.BuildingID = buildingListViewModel?.buildingId
            vc.totalFloor = buildingListViewModel?.totalFloor
            vc.isFromAdd = true
            self.navigationController?.pushViewController(vc, animated: true)
        }else if buildingListViewModel?.btype == 2 {
            ///独立办公室
            let vc = OwnerBuildingJointIndepententOfficeViewController()
            vc.buildingIsTemp = buildingListViewModel?.isTemp
            vc.BuildingID = buildingListViewModel?.buildingId
            vc.totalFloor = buildingListViewModel?.totalFloor
            vc.isFromAdd = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
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
        titleview?.leftButton.setImage(UIImage.init(named: "moreBuildingIcon"), for: .normal)
        titleview?.rightButton.setImage(UIImage.init(named: "addWhite"), for: .normal)
        titleview?.leftButton.isHidden = false
        titleview?.rightButton.isHidden = true
        titleview?.rightButton.layoutButton(.imagePositionRight, margin: 2)
        titleview?.rightBtnClickBlock = { [weak self] in
            
            self?.showAddFYAlertView()
        }
        titleview?.leftButtonCallBack = { [weak self] in
            
            if self?.userModel?.auditStatus == -1 {
                AppUtilities.makeToast("请先认证")
            }else {
                
                self?.buildingListVC.userModel = self?.userModel
                let nav = BaseNavigationViewController.init(rootViewController: self?.buildingListVC ?? OwnerBuildingListViewController())
                nav.navigationBar.isHidden = true
                nav.modalPresentationStyle = .overFullScreen
                self?.present(nav, animated: true, completion: nil)
            }

        }
        self.view.addSubview(titleview ?? ThorNavigationView.init(type: .backTitleRight))
        
        self.view.addSubview(vrView)
        
        vrView.headerBtnClickBlock = { [weak self] in
            ///跳转到vr录制页面
            let vc = BaseWebViewController.init(protocalType: .VRCreat)
            vc.titleString = "预约VR录制"
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        vrView.snp.makeConstraints { (make) in
            make.top.equalTo(kNavigationHeight)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(68)
        }
        
        self.view.backgroundColor = kAppColor_bgcolor_F7F7F7
        
        self.tableView.backgroundColor = kAppColor_bgcolor_F7F7F7
        
        self.tableView.snp.remakeConstraints { (make) in
            make.top.equalTo(vrView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-kTabBarHeight)
        }
        self.tableView.register(OwnerFYListCell.self, forCellReuseIdentifier: OwnerFYListCell.reuseIdentifierStr)

        buildingListVC.clickBuildingBlock = { [weak self] (viewmodel) in
            self?.buildingListViewModel = viewmodel
        }
        
        buildingListVC.clickBuildingScanEditBlock = { [weak self] (viewModel, isScan) in
            
        }
        
        identifyStatus()
        
        requestSet()
    }
    
    func requestBuildingList() {
        
        var params = [String:AnyObject]()
        
        params["token"] = UserTool.shared.user_token as AnyObject?
        params["pageNo"] = 1 as AnyObject
        params["pageSize"] = 1 as AnyObject

        SSNetworkTool.SSFYManager.request_getBuildingList(params: params, success: { [weak self] (response) in
            guard let weakSelf = self else {return}
            if let decoratedArray = JSONDeserializer<OwnerBuildingListModel>.deserializeModelArrayFrom(json: JSON(response["data"] ?? "").rawString() ?? "", designatedPath: "list") {
                if decoratedArray.count >= 1 {
                    weakSelf.buildingListViewModel = OwnerBuildingListViewModel.init(model: decoratedArray[0] ?? OwnerBuildingListModel())
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
    
    
    func loadSecion(section: Int) {
        tableView.reloadSections(NSIndexSet.init(index: section) as IndexSet, with: UITableView.RowAnimation.none)
    }
    
    func requestSet() {
        
        isShowRefreshHeader = false
                
    }
    
    //MARK: 更多按钮
    func moreBtnFY(index: OWnerFYMoreSettingEnum, viewModel: OwnerFYListViewModel, section: Int) {
        ///下架
        if index == OWnerFYMoreSettingEnum.xiaJiaEnum {
            
            var params = [String:AnyObject]()
            params["token"] = UserTool.shared.user_token as AnyObject?
            params["houseId"] = viewModel.houseId as AnyObject?
            params["isTemp"] = viewModel.isTemp as AnyObject?
            
            ///1发布2下架
            ///房源当前状态0未发布，1发布，2下架,3:待完善
            if viewModel.houseStatus == 1 {
                params["isRelease"] = 2 as AnyObject?
            }else {
                params["isRelease"] = 1 as AnyObject?
            }
            

            SSNetworkTool.SSFYManager.request_getHousePublishOrRelease(params: params, success: {[weak self] (response) in
                if let model = self?.dataSource[section] as? OwnerFYListModel {
                    if viewModel.houseStatus == 1 {
                        model.houseStatus = 2
                        AppUtilities.makeToast("房源已下架")
                    }else {
                        model.houseStatus = 1
                        AppUtilities.makeToast("房源已发布")
                    }
                    let viewmodel = OwnerFYListViewModel.init(model: model)
                    self?.dataSourceViewModel.remove(at: section)
                    self?.dataSourceViewModel.insert(viewmodel, at: section)
                }
                
                self?.loadSecion(section: section)
                }, failure: { (error) in
                    
            }) { (code, message) in
                //只有5000 提示给用户
                if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" {
                    AppUtilities.makeToast(message)
                }
            }
        }
            ///删除
        else if index == OWnerFYMoreSettingEnum.deleteEnum {
            
            if viewModel.btype == 2 {
                if viewModel.officeType != 1 {
                    AppUtilities.makeToast("开放工位不可删除")
                    return
                }
            }
            
            let alert = SureAlertView(frame: self.view.frame)
            alert.ShowAlertView(withalertType: AlertType.AlertTypeMessageAlert, title: "确定删除房源吗？", descMsg: "", cancelButtonCallClick: {

            }) { [weak self] in
                self?.deleteFY(viewModel: viewModel, section: section)
            }
            
        }
    }
    
    //MARK: 发布 下架 关闭
    func publishFY(viewModel: OwnerFYListViewModel, section: Int) {
        
        var params = [String:AnyObject]()
        params["token"] = UserTool.shared.user_token as AnyObject?
        params["houseId"] = viewModel.houseId as AnyObject?
        params["isTemp"] = viewModel.isTemp as AnyObject?
        
        ///1发布2下架
        ///房源当前状态0未发布，1发布，2下架,3:待完善
        if viewModel.houseStatus == 1 {
            params["isRelease"] = 2 as AnyObject?
        }else {
            params["isRelease"] = 1 as AnyObject?
        }
        
        SSNetworkTool.SSFYManager.request_getHousePublishOrRelease(params: params, success: {[weak self] (response) in
        if let model = self?.dataSource[section] as? OwnerFYListModel {
            if viewModel.houseStatus == 1 {
                model.houseStatus = 2
                AppUtilities.makeToast("房源已下架")
            }else {
                model.houseStatus = 1
                AppUtilities.makeToast("房源已发布")
            }
            let viewmodel = OwnerFYListViewModel.init(model: model)
            self?.dataSourceViewModel.remove(at: section)
            self?.dataSourceViewModel.insert(viewmodel, at: section)
        }
        
        self?.loadSecion(section: section)
        }, failure: { (error) in
                
        }) { (code, message) in
            //只有5000 提示给用户
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" {
                AppUtilities.makeToast(message)
            }
        }
    }
    
    //MARK: 分享 - 只有发布的可以关闭
    func shareFY(viewModel: OwnerFYListViewModel) {
        shareClick(viewModel: viewModel)
        shareVc(viewModel: viewModel)
    }
    
    
    //MARK: 删除
    func deleteFY(viewModel: OwnerFYListViewModel, section: Int) {
        
        var params = [String:AnyObject]()
        params["token"] = UserTool.shared.user_token as AnyObject?
        params["houseId"] = viewModel.houseId as AnyObject?
        params["isTemp"] = viewModel.isTemp as AnyObject?
        
        SSNetworkTool.SSFYManager.request_getHouseDelete(params: params, success: {[weak self] (response) in
            
            self?.dataSourceViewModel.remove(viewModel)
            self?.tableView.reloadData()
            
            }, failure: { (error) in
                
        }) { (code, message) in
            //只有5000 提示给用户
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" {
                AppUtilities.makeToast(message)
            }
        }
    }
    
    ///点击分享按钮调用的方法
    func shareClick(viewModel: OwnerFYListViewModel) {
        var params = [String:AnyObject]()
        params["token"] = UserTool.shared.user_token as AnyObject?
        params["houseId"] = viewModel.houseId as AnyObject?

        SSNetworkTool.SSFYDetail.request_clickShareClick(params: params, success: { (response) in
            
            }, failure: { (error) in
                
        }) { (code, message) in
          
        }
    }
    
    func shareVc(viewModel: OwnerFYListViewModel) {
        let shareVC = ShareViewController.initialization()
        shareVC.buildingName = buildingListViewModel?.buildingName ?? ""
        shareVC.descriptionString = viewModel.houseName ?? ""
        shareVC.thumbImage = viewModel.mainPic
        shareVC.shareUrl = "\(SSAPI.SSH5Host)\(SSDelegateURL.h5BuildingFYDetailShareUrl)?isShare=\(UserTool.shared.user_channel)&buildingId=\(viewModel.buildingId ?? 0)&houseId=\(viewModel.houseId ?? 0)"
        shareVC.modalPresentationStyle = .overFullScreen
        self.present(shareVC, animated: true, completion: {})
    }
}

extension OwnerFYListViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return dataSourceViewModel.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OwnerFYListCell.reuseIdentifierStr) as? OwnerFYListCell
        cell?.selectionStyle = .none
        if self.dataSourceViewModel.count > 0 {
            if let viewModel = self.dataSourceViewModel[indexPath.section]  {
                cell?.viewModel = viewModel
                cell?.moreBtnClickBlock = { [weak self] in
                    self?.ownerFYMoreSettingView.ShowOwnerFYMoreSettingView(datasource: viewModel.moreSettingArr, clearButtonCallBack: {
                        
                    }) {[weak self] (settingEnumIndex) in
                        SSLog("-----点击的是---\(settingEnumIndex)")
                        self?.moreBtnFY(index: settingEnumIndex, viewModel: viewModel, section: indexPath.section)
                    }
                }
                
                ///关闭 - 发布
                cell?.closeBtnClickBlock = { [weak self] in
                    self?.publishFY(viewModel: viewModel, section: indexPath.section)
                }
                
                ///分享
                cell?.shareBtnClickBlock = { [weak self] in
                   self?.shareFY(viewModel: viewModel)
                }
                
                ///编辑
                cell?.editBtnClickBlock = { [weak self] in
                    if viewModel.btype == 1 {
                        ///办公室
                        let vc = OwnerBuildingOfficeViewController()
                        let buildingModel = FangYuanHouseEditModel()
                        buildingModel.isTemp = viewModel.isTemp
                        buildingModel.id = viewModel.houseId
                        vc.houseID = viewModel.houseId
                        vc.houseIsTemp = viewModel.isTemp
                        vc.FYModel = buildingModel
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }else {
                        if viewModel.officeType == 1 {

                            ///独立办公室
                            let vc = OwnerBuildingJointIndepententOfficeViewController()
                            let buildingModel = FangYuanHouseEditModel()
                            buildingModel.isTemp = viewModel.isTemp
                            buildingModel.id = viewModel.houseId
                            vc.houseID = viewModel.houseId
                            vc.houseIsTemp = viewModel.isTemp
                            vc.FYModel = buildingModel
                            self?.navigationController?.pushViewController(vc, animated: true)
                        }else {

                            ///开放工位
                            let vc = OwnerBuildingJointOpenStationViewController()
                            let buildingModel = FangYuanHouseEditModel()
                            buildingModel.isTemp = viewModel.isTemp
                            buildingModel.id = viewModel.houseId
                            vc.houseID = viewModel.houseId
                            vc.houseIsTemp = viewModel.isTemp
                            vc.FYModel = buildingModel
                            self?.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                }
            }
        }
        return cell ?? OwnerFYListCell.init(frame: .zero)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return OwnerFYListCell.rowHeight()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.dataSource.count <= 0 {
            return
        }
                    //独立办公室
        if let model = self.dataSource[indexPath.section] as? OwnerFYListModel {
            
            if model.btype == 1 {
                let vc = RenterOfficebuildingFYDetailVC()
                vc.isFromOwnerScan = true
                let detail = FangYuanBuildingOpenStationModel()
                detail.btype = model.btype
                detail.id = model.houseId
                detail.isTemp = model.isTemp
                detail.houseStatus = model.houseStatus
                vc.model = detail
                self.navigationController?.pushViewController(vc, animated: true)
            }else if model.btype == 2 {
                if model.officeType == 1 {

                    let vc = RenterOfficeJointFYDetailVC()
                    vc.isFromOwnerScan = true
                    let detail = FangYuanBuildingOpenStationModel()
                    detail.btype = model.btype
                    detail.id = model.houseId
                    detail.isTemp = model.isTemp
                    detail.houseStatus = model.houseStatus
                    vc.model = detail
                    self.navigationController?.pushViewController(vc, animated: true)
                }else {
                    AppUtilities.makeToast("开放工位不支持预览")
                }
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




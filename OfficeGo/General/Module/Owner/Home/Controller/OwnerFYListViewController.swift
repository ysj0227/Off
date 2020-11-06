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

class OwnerFYListViewController: BaseGroupTableViewController {
    
    
    ///判断身份和认证类型
    var userModel: LoginUserModel?
    
    var buildingListVC = OwnerBuildingListViewController()

        ///身份类型0个人1企业2联合
    //    let identify: Int = userModel?.identityType ?? -1

    ///楼盘模型
    var buildingListViewModel : OwnerBuildingListViewModel? {
        didSet {
            titleview?.rightButton.isHidden = false
            titleview?.titleLabel.text = buildingListViewModel?.buildingName
            loadNewData()
        }
    }
    
    ///点击重新加载
    override func clickReloadData() {
        
        SendNetworkStatus()
        
        loadNewData()
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
                
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        
        requestUserMessage()
    }
    
    @objc func requestUserMessage() {
        
        SSNetworkTool.SSMine.request_getOwnerUserMsg(success: {[weak self] (response) in

            guard let weakSelf = self else {return}
            
            if let model = LoginUserModel.deserialize(from: response, designatedPath: "data") {
                
                weakSelf.userModel = model
                
                UserTool.shared.user_name = model.proprietorRealname
                UserTool.shared.user_nickname = model.proprietorRealname
                UserTool.shared.user_avatars = model.avatar
                UserTool.shared.user_company = model.proprietorCompany
                UserTool.shared.user_job = model.proprietorJob
                UserTool.shared.user_sex = model.sex
                UserTool.shared.user_phone = model.phone
                UserTool.shared.user_wechat = model.wxId
                
            }
            
            }, failure: { (error) in
                
        }) { (code, message) in
            
            //只有5000 提示给用户
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" {
                AppUtilities.makeToast(message)
            }
        }
    }
    
    func requestHouseList() {
        
        var params = [String:AnyObject]()
        
        params["token"] = UserTool.shared.user_token as AnyObject?
        params["pageNo"] = self.pageNo as AnyObject
        params["pageSize"] = 10 as AnyObject
        if userModel?.identityType == 2 {
            //类型,1:楼盘,2:网点,当是1的时候,网点名称可为空
            params["btype"] = buildingListViewModel?.btype as AnyObject?
        }else {
            params["btype"] = buildingListViewModel?.btype as AnyObject?
        }
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
        titleview?.titleLabel.text = "房源列表"
        titleview?.rightBtnClickBlock = { [weak self] in
            if self?.buildingListViewModel?.btype == 1 {
                ///办公室
                let vc = OwnerBuildingOfficeViewController()
                vc.buildingIsTemp = self?.buildingListViewModel?.isTemp
                vc.BuildingID = self?.buildingListViewModel?.buildingId
                vc.isFromAdd = true
                self?.navigationController?.pushViewController(vc, animated: true)
            }else if self?.buildingListViewModel?.btype == 2 {
                ///独立办公室
                let vc = OwnerBuildingJointIndepententOfficeViewController()
                vc.buildingIsTemp = self?.buildingListViewModel?.isTemp
                vc.BuildingID = self?.buildingListViewModel?.buildingId
                vc.isFromAdd = true
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
        titleview?.leftButtonCallBack = { [weak self] in
            self?.buildingListVC.userModel = self?.userModel
            let nav = BaseNavigationViewController.init(rootViewController: self?.buildingListVC ?? OwnerBuildingListViewController())
            nav.navigationBar.isHidden = true
            nav.modalPresentationStyle = .overFullScreen
            self?.present(nav, animated: true, completion: nil)
        }
        self.view.addSubview(titleview ?? ThorNavigationView.init(type: .backTitleRight))
        
        buildingListVC.clickBuildingBlock = { [weak self] (viewmodel) in
            self?.buildingListViewModel = viewmodel
        }
        
        buildingListVC.clickBuildingScanEditBlock = { [weak self] (viewModel, isScan) in
//            if isScan == true {
//                if viewModel.btype == 1 {
//                    let model = FangYuanListModel()
//                    model.btype = viewModel.btype
//                    model.id = viewModel.idString
//                    let vc = RenterOfficebuildingDetailVC()
//                    vc.buildingModel = model
//                    self?.navigationController?.pushViewController(vc, animated: true)
//                }else if viewModel.btype == 2 {
//                    let model = FangYuanListModel()
//                    model.btype = viewModel.btype
//                    model.id = viewModel.idString
//                    let vc = RenterOfficeJointDetailVC()
//                    vc.buildingModel = model
//                    self?.navigationController?.pushViewController(vc, animated: true)
//                }
//            }else {
//
//                if viewModel.btype == 1 {
//                    let vc = OwnerBuildingCreateViewController()
//                    self?.navigationController?.pushViewController(vc, animated: true)
//                }else if viewModel.btype == 2 {
//                    let vc = OwnerBuildingJointCreateViewController()
//                    self?.navigationController?.pushViewController(vc, animated: true)
//                }
//            }
        }
        
        
        requestSet()
        
        requestBuildingList()
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
        
        self.view.backgroundColor = kAppColor_bgcolor_F7F7F7
        
        self.tableView.backgroundColor = kAppColor_bgcolor_F7F7F7
        
        self.tableView.snp.remakeConstraints { (make) in
            make.top.equalTo(kNavigationHeight + 7)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-kTabBarHeight)
        }
        self.tableView.register(OwnerFYListCell.self, forCellReuseIdentifier: OwnerFYListCell.reuseIdentifierStr)
                
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




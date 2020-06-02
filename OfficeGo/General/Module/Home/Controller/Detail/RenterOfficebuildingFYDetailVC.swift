//
//  RenterOfficebuildingFYDetailVC.swift
//  OfficeGo
//
//  Created by mac on 2020/5/13.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class RenterOfficebuildingFYDetailVC: BaseTableViewController {
    
    var isTrafficUp: Bool = false
    
    let itemview: RenterHeaderItemSelectView = {
        let item = RenterHeaderItemSelectView(frame: CGRect(x: left_pending_space_17, y: 44, width: kWidth - left_pending_space_17, height: 40))
        item.backgroundColor = kAppBlueColor
        return item
    }()
    
    //总体数据源
    var dataSourceArr = [[FYDetailItemType]]()
    
    var model: FangYuanListModel = FangYuanListModel() {
        didSet {
            bottomBtnView.leftBtn.isSelected  = false
            //1是办公楼，2是联合办公
            if model.btype == 1 {
                //办公楼 -
                //名称基本信息 -房源信息- 户型 - 工交 - 周边配套
                
                self.dataSourceArr.append([
                    FYDetailItemType.FYDetailItemOfficeBuildingNameView,
                    FYDetailItemType.FYDetailItemTypeOfficeDeatail,
                    FYDetailItemType.FYDetailItemTypeHuxing,
                    FYDetailItemType.FYDetailItemTypeTraffic,
                    FYDetailItemType.FYDetailItemTypeAmbitusMating])
                
                self.tableView.reloadData()
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
        
        //轮播图加载 - 设置头部
        let pointY: CGFloat = 0
        let cycleView = CycleView(frame: CGRect(x: 0, y: pointY, width: kWidth, height: kWidth * 267 / 320.0))
        cycleView.delegate = self
        cycleView.mode = .scaleAspectFill
        //本地图片测试--加载网络图片,请用第三方库如SDWebImage等
        cycleView.imageURLStringArr = ["loginBgImg", "wechat", "loginBgImg", "wechat"]
        self.tableView.tableHeaderView = cycleView
        
        //头部
        self.tableView.register(RenterDetailNameCell.self, forCellReuseIdentifier: RenterDetailNameCell.reuseIdentifierStr)
        
        //房源信息
        self.tableView.register(UINib.init(nibName: RenterOfficebuildingFYDeatailCell.reuseIdentifierStr, bundle: nil), forCellReuseIdentifier: RenterOfficebuildingFYDeatailCell.reuseIdentifierStr)
        
        //户型
        self.tableView.register(UINib.init(nibName: RenterOfficebuildingDeatailHuxingCell.reuseIdentifierStr, bundle: nil), forCellReuseIdentifier: RenterOfficebuildingDeatailHuxingCell.reuseIdentifierStr)
        
        
        //交通
        self.tableView.register(UINib.init(nibName: RenterDetailTrafficCell.reuseIdentifierStr, bundle: nil), forCellReuseIdentifier: RenterDetailTrafficCell.reuseIdentifierStr)
        
        
        //周边配套
        self.tableView.register(UINib.init(nibName: RenterAmbitusMatingCell.reuseIdentifierStr, bundle: nil), forCellReuseIdentifier: RenterAmbitusMatingCell.reuseIdentifierStr)
        
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
    
    func collectClick() {
        bottomBtnView.leftBtn.isSelected = !bottomBtnView.leftBtn.isSelected
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
                cell?.itemModel = ""
                return cell ?? RenterDetailNameCell()
                
            case FYDetailItemType.FYDetailItemTypeJointNameView:
                return UITableViewCell.init(frame: .zero)
                
            case FYDetailItemType.FYDetailItemTypeOfficeDeatail:
                let cell = tableView.dequeueReusableCell(withIdentifier: RenterOfficebuildingFYDeatailCell.reuseIdentifierStr) as? RenterOfficebuildingFYDeatailCell
                cell?.selectionStyle = .none
                return cell ?? RenterOfficebuildingFYDeatailCell()
                
            case .FYDetailItemTypeHuxing:
                let cell = tableView.dequeueReusableCell(withIdentifier: RenterOfficebuildingDeatailHuxingCell.reuseIdentifierStr) as? RenterOfficebuildingDeatailHuxingCell
                cell?.selectionStyle = .none
                return cell ?? RenterOfficebuildingDeatailHuxingCell()
                
            case FYDetailItemType.FYDetailItemTypeTraffic:
                let cell = tableView.dequeueReusableCell(withIdentifier: RenterDetailTrafficCell.reuseIdentifierStr) as? RenterDetailTrafficCell
                cell?.selectionStyle = .none
//                cell?.model = FangYuanBuildingBuildingModel()
                cell?.trafficBtnClick = {[weak self] (isup) in
                    self?.isTrafficUp = isup
                    self?.tableView.reloadData()
                }
                return cell ?? RenterDetailTrafficCell.init(frame: .zero)
                
            case FYDetailItemType.FYDetailItemTypeAmbitusMating:
                let cell = tableView.dequeueReusableCell(withIdentifier: RenterAmbitusMatingCell.reuseIdentifierStr) as? RenterAmbitusMatingCell
                cell?.selectionStyle = .none
                cell?.selectModel = HouseSelectModel()
                return cell ?? RenterAmbitusMatingCell()
                
            case FYDetailItemType.FYDetailItemTypeFeature:
                return UITableViewCell.init(frame: .zero)
                
            case FYDetailItemType.FYDetailItemTypeLianheOpenList:
                return UITableViewCell.init(frame: .zero)
                
            case FYDetailItemType.FYDetailItemTypeFYList: //在租办公楼 -
                return UITableViewCell.init(frame: .zero)
                
            case .FYDetailItemTypeShareServices:
                return UITableViewCell()
            }
        }else {
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
                return RenterOfficebuildingDeatailHuxingCell.rowHeight()
                
            case FYDetailItemType.FYDetailItemTypeAmbitusMating:
                return 79 + (41 + 10) * 3
            //            return 241 + huxingConstangHeight.constant
                
            case FYDetailItemType.FYDetailItemTypeTraffic:
                //                    return RenterDetailTrafficCell.rowHeight()
                if isTrafficUp == true {
                    return 40 + 30 * 2 + 1
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
        }else {
            return 0
        }
    }
    
    
}

extension RenterOfficebuildingFYDetailVC {
    
}



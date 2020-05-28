//
//  RenterOfficebuildingJointDetailVC.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/5/11.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit
import WMPlayer

class RenterOfficebuildingJointDetailVC: BaseTableViewController, WMPlayerDelegate {
    
    //表头
    let tableHeaderView: RenterDetailSourceView = {
        let item = RenterDetailSourceView(frame: CGRect(x: 0, y: 0, width: kWidth, height: kWidth * 267 / 320.0))
        return item
    }()
    
    var isTrafficUp: Bool = false
    
    //tableview头部
    let itemview: RenterHeaderItemSelectView = {
        let item = RenterHeaderItemSelectView(frame: CGRect(x: left_pending_space_17, y: 44, width: kWidth - left_pending_space_17, height: 40))
        item.backgroundColor = kAppBlueColor
        return item
    }()
    
    //总体数据源
    var dataSourceArr = [[FYDetailItemType]]()
    //办公楼 - 办公室。     联合办公 - 独立办公室数组
    var dataOfficeListSourceArr = [String]()
    //开发工位数组
    var dataGongweiListSourceArr = [String]()
    
    var amtitusMatingListARR = [String]()
    
    var model: FangYuanListModel = FangYuanListModel() {
        didSet {
            bottomBtnView.leftBtn.isSelected  = false
            //1是办公楼，2是联合办公
            if model.houseType == 1 {
                //办公楼 -
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
                    FYDetailItemType.FYDetailItemTypeAmbitusMating])
                
                dataOfficeListSourceArr.append("11")
                dataOfficeListSourceArr.append("12")
                dataOfficeListSourceArr.append("13")
                dataOfficeListSourceArr.append("14")
                
                //周边配套
                amtitusMatingListARR.append("11")
                amtitusMatingListARR.append("12")
                amtitusMatingListARR.append("13")
                amtitusMatingListARR.append("14")
                
                self.tableView.reloadData()
            }else if model.houseType == 2 {
                //联合办公 -
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
                    FYDetailItemType.FYDetailItemTypeAmbitusMating])
                
                dataOfficeListSourceArr.append("21")
                dataOfficeListSourceArr.append("22")
                dataOfficeListSourceArr.append("23")
                dataOfficeListSourceArr.append("24")
                
                dataGongweiListSourceArr.append("31")
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
    
    override func viewWillDisappear(_ animated: Bool) {
        tableHeaderView.pausePlayer()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setData()
    }
    
    func setData() {
        
        tableHeaderView.model = ""
        
        itemview.itemSelectCallBack = {[weak self] (index) in
            self?.dataOfficeListSourceArr.removeAll()
            self?.loadMore()
        }
    }
    
    override func leftBtnClick() {
        tableHeaderView.cycleView.removeFromSuperview()
        tableHeaderView.releaseWMplayer()
        self.navigationController?.popViewController(animated: true)
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
        
        //头部-三项显示 - 办公楼-
        self.tableView.register(RenterDetailNameCell.self, forCellReuseIdentifier: RenterDetailNameCell.reuseIdentifierStr)
        
        //头部-三项显示 - 联合办公- 有标签-
        self.tableView.register(RenterJointDetailNameCell.self, forCellReuseIdentifier: RenterJointDetailNameCell.reuseIdentifierStr)
        
        //交通
        self.tableView.register(UINib.init(nibName: RenterDetailTrafficCell.reuseIdentifierStr, bundle: nil), forCellReuseIdentifier: RenterDetailTrafficCell.reuseIdentifierStr)
        
        //特色
        self.tableView.register(RenterFeatureCell.self, forCellReuseIdentifier: RenterFeatureCell.reuseIdentifierStr)
        
        //共享服务
        self.tableView.register(UINib.init(nibName: RenterShareServiceCell.reuseIdentifierStr, bundle: nil), forCellReuseIdentifier: RenterShareServiceCell.reuseIdentifierStr)
        
        //楼盘信息
        self.tableView.register(UINib.init(nibName: RenterOfficeDeatailCell.reuseIdentifierStr, bundle: nil), forCellReuseIdentifier: RenterOfficeDeatailCell.reuseIdentifierStr)
        
        //周边配套
        self.tableView.register(UINib.init(nibName: RenterAmbitusMatingCell.reuseIdentifierStr, bundle: nil), forCellReuseIdentifier: RenterAmbitusMatingCell.reuseIdentifierStr)
        
        //开放工位 - 独立办公室
        self.tableView.register(UINib.init(nibName: RenterDetailFYListCell.reuseIdentifierStr, bundle: nil), forCellReuseIdentifier: RenterDetailFYListCell.reuseIdentifierStr)
        
        //        在租写字楼
        self.tableView.register(UINib.init(nibName: RenterDetailOfficeListCell.reuseIdentifierStr, bundle: nil), forCellReuseIdentifier: RenterDetailOfficeListCell.reuseIdentifierStr)
        
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
extension RenterOfficebuildingJointDetailVC: CycleViewDelegate{
    func cycleViewDidSelectedItemAtIndex(_ index: NSInteger) {
        //判断点击的是视频
        if index == 0 {
            
        }
    }
}


extension RenterOfficebuildingJointDetailVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        //办公楼
        dataSourceArr.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.model.houseType == 1 { //办公楼
            //在租写字楼
            if section == 1 {
                return dataOfficeListSourceArr.count
            }else {
                return self.dataSourceArr[section].count
            }
        }else {
            if section == 0 {
                //开放工位
                return 2
            }else if section == 2 { //在租写字楼
                //开放工位
                return dataGongweiListSourceArr.count
            }else if section == 3 {
                //独立办公室
                return dataOfficeListSourceArr.count
            }else {
                return self.dataSourceArr[section].count
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.model.houseType == 1 { //办公楼
            if indexPath.section == 1 {
                //办公室
                let cell = tableView.dequeueReusableCell(withIdentifier: RenterDetailOfficeListCell.reuseIdentifierStr) as? RenterDetailOfficeListCell
                cell?.selectionStyle = .none
                return cell ?? RenterDetailOfficeListCell.init(frame: .zero)
            }else {
                let type:FYDetailItemType = dataSourceArr[indexPath.section][indexPath.row]
                
                switch type {
                    
                case FYDetailItemType.FYDetailItemOfficeBuildingNameView:
                    let cell = tableView.dequeueReusableCell(withIdentifier: RenterDetailNameCell.reuseIdentifierStr) as? RenterDetailNameCell
                    cell?.selectionStyle = .none
                    cell?.itemModel = ""
                    return cell ?? RenterDetailNameCell()
                case FYDetailItemType.FYDetailItemTypeJointNameView:
                    return UITableViewCell.init(frame: .zero)
                case FYDetailItemType.FYDetailItemTypeTraffic:
                    let cell = tableView.dequeueReusableCell(withIdentifier: RenterDetailTrafficCell.reuseIdentifierStr) as? RenterDetailTrafficCell
                    cell?.selectionStyle = .none
                    cell?.model = "步行5分钟到 | 7号线·长寿路站,步行1分钟到 | 12号线·长路站,"
                    cell?.trafficBtnClick = {[weak self] (isup) in
                        self?.isTrafficUp = isup
                        self?.tableView.reloadData()
                    }
                    return cell ?? RenterDetailTrafficCell.init(frame: .zero)
                    
                case FYDetailItemType.FYDetailItemTypeFeature:
                    let cell = tableView.dequeueReusableCell(withIdentifier: RenterFeatureCell.reuseIdentifierStr) as? RenterFeatureCell
                    cell?.selectionStyle = .none
                    cell?.featureString = "免费停车,近地铁,近地铁1"
                    return cell ?? RenterFeatureCell.init(frame: .zero)
                    
                case FYDetailItemType.FYDetailItemTypeLianheOpenList:
                    return UITableViewCell.init(frame: .zero)
                    
                case FYDetailItemType.FYDetailItemTypeFYList: //在租办公楼 -
                    return UITableViewCell.init(frame: .zero)
                    
                case FYDetailItemType.FYDetailItemTypeOfficeDeatail:
                    let cell = tableView.dequeueReusableCell(withIdentifier: RenterOfficeDeatailCell.reuseIdentifierStr) as? RenterOfficeDeatailCell
                    cell?.selectionStyle = .none
                    cell?.ruzhuQiyeConstantHeight.constant = 50
                    return cell ?? RenterOfficeDeatailCell()
                    
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
            
        }else if self.model.houseType == 2 { //联合办公
            //联合办公- 开放工位和独立nameview
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: RenterJointDetailNameCell.reuseIdentifierStr) as? RenterJointDetailNameCell
                cell?.selectionStyle = .none
                cell?.itemModel = ""
                return cell ?? RenterJointDetailNameCell()
            }else if indexPath.section == 2 {
                //开发工位列表
                let cell = tableView.dequeueReusableCell(withIdentifier: RenterDetailFYListCell.reuseIdentifierStr) as? RenterDetailFYListCell
                cell?.selectionStyle = .none
                cell?.leftTopLabel.text = "工位"
                return cell ?? RenterDetailFYListCell.init(frame: .zero)
            }else if indexPath.section == 3 {
                //独立办公室
                let cell = tableView.dequeueReusableCell(withIdentifier: RenterDetailFYListCell.reuseIdentifierStr) as? RenterDetailFYListCell
                cell?.selectionStyle = .none
                cell?.leftTopLabel.text = "独立办公室"
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
                    cell?.model = "步行5分钟到 | 7号线·长寿路站,步行1分钟到 | 12号线·长路站,"
                    cell?.trafficBtnClick = {[weak self] (isup) in
                        self?.isTrafficUp = isup
                        self?.tableView.reloadData()
                    }
                    return cell ?? RenterDetailTrafficCell.init(frame: .zero)
                    
                case FYDetailItemType.FYDetailItemTypeFeature:
                    let cell = tableView.dequeueReusableCell(withIdentifier: RenterFeatureCell.reuseIdentifierStr) as? RenterFeatureCell
                    cell?.selectionStyle = .none
                    cell?.featureString = "免费停车,近地铁,近地铁1"
                    return cell ?? RenterFeatureCell.init(frame: .zero)
                    //TODO:
                    //联合办公专享 -
                //开发工位列表
                case FYDetailItemType.FYDetailItemTypeLianheOpenList:
                    return UITableViewCell.init(frame: .zero)
                    
                //独立办公室列表
                case FYDetailItemType.FYDetailItemTypeFYList:
                    return UITableViewCell.init(frame: .zero)
                    
                case FYDetailItemType.FYDetailItemTypeOfficeDeatail:
                    let cell = tableView.dequeueReusableCell(withIdentifier: RenterOfficeDeatailCell.reuseIdentifierStr) as? RenterOfficeDeatailCell
                    cell?.selectionStyle = .none
                    cell?.ruzhuQiyeConstantHeight.constant = 50
                    return cell ?? RenterOfficeDeatailCell()
                    
                case FYDetailItemType.FYDetailItemTypeAmbitusMating:
                    let cell = tableView.dequeueReusableCell(withIdentifier: RenterAmbitusMatingCell.reuseIdentifierStr) as? RenterAmbitusMatingCell
                    cell?.selectionStyle = .none
                    return cell ?? RenterAmbitusMatingCell()
                    
                case .FYDetailItemTypeShareServices:
                    let cell = tableView.dequeueReusableCell(withIdentifier: RenterShareServiceCell.reuseIdentifierStr) as? RenterShareServiceCell
                    cell?.selectionStyle = .none
                    cell?.featureitemArr = ["111", "2222"]
                    cell?.basicitemArr = ["111", "2222", "2222", "2222", "2222", "2222", "2222"]
                    return cell ?? RenterShareServiceCell()
                    
                case FYDetailItemType.FYDetailItemTypeHuxing:
                    return UITableViewCell()
                }
            }
            
        }else {
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if self.model.houseType == 1 { //办公楼
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
                    //                    return RenterDetailTrafficCell.rowHeight()
                    if isTrafficUp == true {
                        return 40 + 30 * 2 + 1
                    }else {
                        return 40 + 30 + 1
                    }
                case FYDetailItemType.FYDetailItemTypeFeature:
                    return RenterFeatureCell.rowHeight()
                case FYDetailItemType.FYDetailItemTypeLianheOpenList:
                    return 0
                case FYDetailItemType.FYDetailItemTypeFYList:
                    return 0
                case FYDetailItemType.FYDetailItemTypeOfficeDeatail:
                    return 493 - 25 + 50
                case FYDetailItemType.FYDetailItemTypeAmbitusMating:
                    return 79 + (41 + 10) * 3
                //            return 241 + huxingConstangHeight.constant
                case .FYDetailItemTypeShareServices:
                    return 0
                case FYDetailItemType.FYDetailItemTypeHuxing:
                    return 0
                }
            }
        }else if self.model.houseType == 2 { //联合办公
            if indexPath.section == 0 {
                return RenterJointDetailNameCell.rowHeight()
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
                    //                    return RenterDetailTrafficCell.rowHeight()
                    if isTrafficUp == true {
                        return 40 + 30 * 2 + 1
                    }else {
                        return 40 + 30 + 1
                    }
                case FYDetailItemType.FYDetailItemTypeFeature:
                    return RenterFeatureCell.rowHeight()
                case FYDetailItemType.FYDetailItemTypeLianheOpenList:
                    return 0
                case FYDetailItemType.FYDetailItemTypeFYList:
                    return 0
                case FYDetailItemType.FYDetailItemTypeOfficeDeatail:
                    //                return RenterOfficeDeatailCell.rowHeight()
                    //                return 493 - 25 + ruzhuQiyeConstantHeight.constant
                    return 493 - 25 + 50
                case FYDetailItemType.FYDetailItemTypeAmbitusMating:
                    return 79 + (41 + 10) * 3
                //            return 241 + huxingConstangHeight.constant
                case .FYDetailItemTypeShareServices:
                    return RenterShareServiceCell.rowHeight()
                case FYDetailItemType.FYDetailItemTypeHuxing:
                    return 0
                }
            }
            
        }else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if self.model.houseType == 1 { //办公楼
            if section == 1 {
                return 52 + 39 + 15
            }else {
                return 0
            }
        }else if self.model.houseType == 2 { //联合办公
            if section == 0 {
                return 50
            }else if section == 2 {
                //如果开放工位数据数组大于0显示
                return 50
            }else if section == 3 {
                //如果独立办公室数据数组大于0显示
                return 52 + 39 + 15
            }else {
                return 0
            }
            
        }else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.model.houseType == 1 { //办公楼
            if section == 1 {
                //如果开放工位数据数组大于0显示
                let view = UIView()
                view.backgroundColor = kAppWhiteColor
                let title = UILabel()
                title.frame = CGRect(x: left_pending_space_17, y: 0, width: kWidth - left_pending_space_17, height: 44)
                title.textColor = kAppColor_333333
                title.text = "在租写字楼"
                title.font = FONT_15
                view.addSubview(title)
                view.addSubview(itemview)
                return view
            }else {
                return UIView()
            }
        }else if self.model.houseType == 2 { //联合办公
            if section == 0 {
                //如果开放工位数据数组大于0显示
                let view = UIView()
                view.backgroundColor = kAppWhiteColor
                let title = UILabel()
                title.frame = CGRect(x: left_pending_space_17, y: 15, width: kWidth - left_pending_space_17, height: 25)
                title.textColor = kAppColor_333333
                title.text = "JA-Space上时大厦"
                title.font = FONT_15
                view.addSubview(title)
                return view
            }else if section == 2 {
                //如果开放工位数据数组大于0显示
                let view = UIView()
                view.backgroundColor = kAppWhiteColor
                let title = UILabel()
                title.frame = CGRect(x: left_pending_space_17, y: 15, width: kWidth - left_pending_space_17, height: 25)
                title.textColor = kAppColor_333333
                title.text = "开放工位"
                title.font = FONT_15
                view.addSubview(title)
                return view
            }else if section == 3 {
                //如果独立办公室数据数组大于0显示
                let view = UIView()
                view.backgroundColor = kAppWhiteColor
                let title = UILabel()
                title.frame = CGRect(x: left_pending_space_17, y: 15, width: kWidth - left_pending_space_17, height: 25)
                title.textColor = kAppColor_333333
                title.text = "独立办公室"
                title.font = FONT_15
                view.addSubview(title)
                view.addSubview(itemview)
                return view
            }else {
                return UIView()
            }
        }else {
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        if self.model.houseType == 1 { //办公楼
            if section == 1 {
                return 78
            }else {
                return 0
            }
        }else if self.model.houseType == 2 { //联合办公
            if section == 0 {
                return 0
            }else if section == 2 {
                return 0
            }else if section == 3 {
                //如果独立办公室数据数组大于0显示
                return 78
            }else {
                return 0
            }
            
        }else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if self.model.houseType == 1 { //办公楼
            if section == 1 {
                //如果开放工位数据数组大于0显示
                let view = UIView()
                view.backgroundColor = kAppWhiteColor
                let btn = UIButton.init(frame: CGRect(x: left_pending_space_17, y: 22, width: kWidth - left_pending_space_17 * 2, height: 34))
                btn.setTitle("查看更多", for: .normal)
                btn.setTitleColor(kAppBlueColor, for: .normal)
                btn.titleLabel?.font = FONT_11
                btn.clipsToBounds = true
                btn.layer.cornerRadius = button_cordious_2
                btn.layer.borderColor = kAppBlueColor.cgColor
                btn.layer.borderWidth = 1.0
                btn.addTarget(self, action: #selector(loadMore), for: .touchUpInside)
                view.addSubview(btn)
                return view
            }else {
                return UIView()
            }
        }else if self.model.houseType == 2 { //联合办公
            if section == 2 {
                //如果开放工位数据数组大于0显示
                let view = UIView()
                return view
            }else if section == 3 {
                //如果独立办公室数据数组大于0显示
                let view = UIView()
                view.backgroundColor = kAppWhiteColor
                let btn = UIButton.init(frame: CGRect(x: left_pending_space_17, y: 22, width: kWidth - left_pending_space_17 * 2, height: 34))
                btn.setTitle("查看更多", for: .normal)
                btn.setTitleColor(kAppBlueColor, for: .normal)
                btn.titleLabel?.font = FONT_11
                btn.clipsToBounds = true
                btn.layer.cornerRadius = button_cordious_2
                btn.layer.borderColor = kAppBlueColor.cgColor
                btn.layer.borderWidth = 1.0
                btn.addTarget(self, action: #selector(loadMore), for: .touchUpInside)
                view.addSubview(btn)
                return view
            }else {
                return UIView()
            }
            
        }else {
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.model.houseType == 1 { //办公楼
            if indexPath.section == 1 {
                let model = FangYuanListModel()
                let vc = RenterOfficebuildingFYDetailVC()
                model.houseType = 1
                vc.model = model
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else if self.model.houseType == 2 { //联合办公
            
            if indexPath.section == 1 {
                //如果开放工位数据数组大于0显示
                
            }else if indexPath.section == 2 {
                //独立办公室
            }
        }
        
    }
    
}

extension RenterOfficebuildingJointDetailVC {
    @objc func loadMore() {
        dataOfficeListSourceArr.append("15")
        dataOfficeListSourceArr.append("16")
        dataOfficeListSourceArr.append("17")
        dataOfficeListSourceArr.append("18")
        dataOfficeListSourceArr.append("19")
        //        self.tableView.reloadSections(IndexSet.init(integer: 1), with: .fade)
        self.tableView.reloadData()
    }
}

extension RenterDetailSourceView: CycleViewDelegate{
    
    func cycleViewDidSelectedItemAtIndex(_ index: NSInteger) {
        
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

class RenterDetailSourceView: UIView {
    
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
    
    var model: String = "" {
        didSet {
            //本地图片测试--加载网络图片,请用第三方库如SDWebImage等
            cycleView.imageURLStringArr = ["loginBgImg", "wechat", "loginBgImg", "wechat"]
            let model = WMPlayerModel()
            //            model.title = "视频"
            model.videoURL = URL.init(string: "http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4")
            playerModel = model
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
        //        wmPlayer?.play()
    }
    
    var changeBtnView: ButtonCycleSelectItemView = {
        let view = ButtonCycleSelectItemView.init(frame: CGRect(x: (kWidth - 45 * 3) / 2.0, y: 220, width: 45 * 3, height: 24), titleArrs: ["视频", "图片"], selectedIndex: 0)
        return view
    }()
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame    
        
        addSubview(cycleView)
        addSubview(videoView)
        addSubview(changeBtnView)
        
        changeBtnView.buttonCallBack = {[weak self] (index) in
            
            if index == 1 {
                self?.videoView.isHidden = false
                self?.wmPlayer?.isHidden = false
                self?.cycleView.isHidden = true
            }else {
                self?.videoView.isHidden = true
                self?.wmPlayer?.isHidden = true
                self?.cycleView.isHidden = false
                self?.wmPlayer?.pause()
            }
            self?.changeBtnView.isHidden = false
        }
    }
    
}

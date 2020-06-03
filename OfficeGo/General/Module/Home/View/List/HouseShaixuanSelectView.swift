//
//  HouseShaixuanSelectView.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/5/6.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class HouseShaixuanSelectView: UIView {
    
    lazy var blackAlphabgView: UIButton = {
        let button = UIButton.init()
        button.backgroundColor = UIColor.init(white: 0, alpha: 0.7)
        button.addTarget(self, action: #selector(clickRemoveFromSuperview), for: .touchUpInside)
        return button
    }()
    
    
    lazy var tableView: UITableView = {
        let view = UITableView.init(frame: .zero, style: .grouped)
        view.backgroundColor = kAppWhiteColor
        view.separatorStyle = .none
        view.estimatedRowHeight = 40
        return view
    }()
    
    lazy var bottomBtnView: BottomBtnView = {
        let view = BottomBtnView.init(frame: CGRect(x: 0, y: 0, width: kWidth, height: 50))
        view.bottomType = BottomBtnViewType.BottomBtnViewTypeShaixuan
        view.backgroundColor = kAppWhiteColor
        return view
    }()
    
    // MARK: - block
    //清除block
    fileprivate var clearButtonCallBack:(() -> Void)?
    
    //筛选block
    fileprivate var sureHouseShaixuanButtonCallBack:((HouseSelectModel) -> Void)?
    
    var selectModel: HouseSelectModel = HouseSelectModel() {
        didSet {
            if selectModel.typeModel.type == HouseTypeEnum.jointOfficeEnum {
                isLianHeBanGong = selectModel.typeModel.type
                LianHeBanGongdataArray.remove(at: 0)
                XieZiLouDataArray.remove(at: 0)
            }else if selectModel.typeModel.type == HouseTypeEnum.officeBuildingEnum {
                isLianHeBanGong = selectModel.typeModel.type
                LianHeBanGongdataArray.remove(at: 0)
                XieZiLouDataArray.remove(at: 0)
            }else {
                
            }
            self.tableView.reloadData()
        }
    }
    
    var LianHeBanGongdataArray = [[IWantToFindType]]()
    
    var XieZiLouDataArray = [[IWantToFindType]]()
    
    var isLianHeBanGong: HouseTypeEnum?
    
    fileprivate var alertStyle: HouseShaixuanStyle?
    
    @objc func clickRemoveFromSuperview() {
        //        guard let blockk = clearButtonCallBack else {
        //            return
        //        }
        //        blockk()
        selfRemove()
    }
    
    func selfRemove() {
        self.removeFromSuperview()
    }
    
    
    //判断是筛选还是添加到页面 - 默认是弹框
    var isSubView = false {
        didSet {
            //如果是添加到页面- 是子view
            if isSubView == true {
                
                blackAlphabgView.isUserInteractionEnabled = false
                blackAlphabgView.backgroundColor = kAppWhiteColor
                bottomBtnView.snp.updateConstraints { (make) in
                    make.bottom.equalToSuperview().offset(-10)
                    make.leading.trailing.equalToSuperview()
                    make.height.equalTo(44)
                }
                tableView.snp.updateConstraints { (make) in
                    make.top.leading.trailing.equalToSuperview()
                    make.bottom.equalTo(bottomBtnView.snp.top)
                }
                
                bottomBtnView.bottomType = BottomBtnViewType.BottomBtnViewTypeIwantToFind
            }
        }
    }
    
    // MARK: - 弹出view显示
    // MARK: - 弹出view显示 - 筛选
    func ShowHouseShaixuanView(issubView: Bool, model: HouseSelectModel, clearButtonCallBack: @escaping (() -> Void), sureHouseShaixuanButtonCallBack: @escaping ((HouseSelectModel) -> Void)) -> Void {
        
        UIApplication.shared.keyWindow?.subviews.forEach({ (view) in
            if view.isKind(of: AreaAddressView.self) {
                view.removeFromSuperview()
            }
            if view.isKind(of: HouseTypeAndSortSelectView.self) {
                view.removeFromSuperview()
            }
            if view.isKind(of: HouseShaixuanSelectView.self) {
                view.removeFromSuperview()
            }
        })
        if issubView == true {
            self.frame = CGRect(x: 0.0, y: kNavigationHeight + 50, width: kWidth, height: kHeight - kNavigationHeight - 50)
        }else {
            self.frame = CGRect(x: 0.0, y: kNavigationHeight + 60, width: kWidth, height: kHeight - kNavigationHeight - 60)
        }
        self.isSubView = issubView
        self.clearButtonCallBack = clearButtonCallBack
        self.sureHouseShaixuanButtonCallBack = sureHouseShaixuanButtonCallBack
        self.selectModel = model
        
        
        //        self.tableView.frame = CGRect(x: 0, y: 0, width: self.width, height: self.height - kTabBarHeight - 50)
        //        self.bottomBtnView.frame = CGRect(x: 0, y: self.tableView.bottom, width: self.width, height: 50)
        
        UIApplication.shared.keyWindow?.addSubview(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.frame = frame
        
        //默认联合办公
        LianHeBanGongdataArray.append([
            //            IWantToFindType.IWantToFindTypeCity,
            IWantToFindType.IWantToFindTypeHouseType])
        LianHeBanGongdataArray.append([IWantToFindType.IWantToFindTypeGongwei, IWantToFindType.IWantToFindTypeZujin])
        LianHeBanGongdataArray.append([IWantToFindType.IWantToFindTypeFeature])
        
        //办公楼
        XieZiLouDataArray.append([
            IWantToFindType.IWantToFindTypeHouseType])
        XieZiLouDataArray.append([
            //            IWantToFindType.IWantToFindTypeCity,
            IWantToFindType.IWantToFindTypeMianji,
            IWantToFindType.IWantToFindTypeZujin,
            IWantToFindType.IWantToFindTypeGongwei,
            IWantToFindType.IWantToFindTypeDocumentType,
            IWantToFindType.IWantToFindTypeFeature
        ])
        
        setUpSubviews()
    }
    
    //MARK: 清除数据操作
    func clearData() {
        //清除操作
        if self.selectModel.typeModel.type == .officeBuildingEnum {
            
            //工位数清空
            self.selectModel.shaixuanModel.gongweiofficeBuildingExtentModel.lowValue = self.selectModel.shaixuanModel.gongweiofficeBuildingExtentModel.minimumValue
            
            self.selectModel.shaixuanModel.gongweiofficeBuildingExtentModel.highValue = self.selectModel.shaixuanModel.gongweiofficeBuildingExtentModel.maximumValue
            
            //租金清空
            self.selectModel.shaixuanModel.zujinofficeBuildingExtentModel.lowValue = self.selectModel.shaixuanModel.zujinofficeBuildingExtentModel.minimumValue
            
            self.selectModel.shaixuanModel.zujinofficeBuildingExtentModel.highValue = self.selectModel.shaixuanModel.zujinofficeBuildingExtentModel.maximumValue
            
            //面积清空
            self.selectModel.shaixuanModel.mianjiofficeBuildingExtentModel.lowValue = self.selectModel.shaixuanModel.mianjiofficeBuildingExtentModel.minimumValue
            
            self.selectModel.shaixuanModel.mianjiofficeBuildingExtentModel.highValue = self.selectModel.shaixuanModel.mianjiofficeBuildingExtentModel.maximumValue
            
            //选择特色清空
            for model in self.selectModel.shaixuanModel.featureModelArr {
                model.isOfficeBuildingSelected = false
            }
            
            //选择装修类型清空
            for model in self.selectModel.shaixuanModel.documentTypeModelArr {
                model.isDocumentSelected = false
            }
            
        }else {
            //工位数清空
            self.selectModel.shaixuanModel.gongweijointOfficeExtentModel.lowValue = self.selectModel.shaixuanModel.gongweijointOfficeExtentModel.minimumValue
            
            self.selectModel.shaixuanModel.gongweijointOfficeExtentModel.highValue = self.selectModel.shaixuanModel.gongweijointOfficeExtentModel.maximumValue
            
            //租金清空
            self.selectModel.shaixuanModel.zujinjointOfficeExtentModel.lowValue = self.selectModel.shaixuanModel.zujinjointOfficeExtentModel.minimumValue
            
            self.selectModel.shaixuanModel.zujinjointOfficeExtentModel.highValue = self.selectModel.shaixuanModel.zujinjointOfficeExtentModel.maximumValue
            
            //选择特色清空
            for model in self.selectModel.shaixuanModel.featureModelArr {
                model.isOfficejointOfficeSelected = false
            }
        }
        
        self.tableView.reloadData()
    }
    
    
    func setUpSubviews() {
        self.addSubview(blackAlphabgView)
        self.addSubview(tableView)
        self.addSubview(bottomBtnView)
        blackAlphabgView.snp.makeConstraints { (make) in
            make.top.leading.bottom.trailing.equalToSuperview()
        }
        
        bottomBtnView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-kTabBarHeight)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        
        bottomBtnView.leftBtnClickBlock = { [weak self] in
            
            self?.clearData()
            //            guard let blockk = self?.clearButtonCallBack else {
            //                return
            //            }
            //            blockk()
            //            self?.selfRemove()
        }
        bottomBtnView.rightBtnClickBlock = { [weak self] in
            guard let blockk = self?.sureHouseShaixuanButtonCallBack else {
                return
            }
            //判断 如果是筛选页面 - 则如果之前没有选择过，默认选中联合办公
            if self?.isSubView != true {
                
                guard let type = self?.selectModel.typeModel.type else {
                    self?.selectModel.typeModel.type = HouseTypeEnum.jointOfficeEnum
                    return
                }
                if type == HouseTypeEnum.allEnum {
                    self?.selectModel.typeModel.type = HouseTypeEnum.jointOfficeEnum
                }
            }
            self?.selectModel.shaixuanModel.isShaixuan = true
            blockk(self?.selectModel ?? HouseSelectModel())
            if self?.isSubView == true {
                
            }else {
                self?.selfRemove()
            }
        }
        
        tableView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(bottomBtnView.snp.top)
        }
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.register(UINib.init(nibName: CityOrRegionSelectCell.reuseIdentifierStr, bundle: nil), forCellReuseIdentifier: CityOrRegionSelectCell.reuseIdentifierStr)
        
        self.tableView.register(UINib.init(nibName: HouseTypeCell.reuseIdentifierStr, bundle: nil), forCellReuseIdentifier: HouseTypeCell.reuseIdentifierStr)
        
        self.tableView.register(UINib.init(nibName: ExtentSelectCell.reuseIdentifierStr, bundle: nil), forCellReuseIdentifier: ExtentSelectCell.reuseIdentifierStr)
        
        self.tableView.register(UINib.init(nibName: HouseFeatureCell.reuseIdentifierStr, bundle: nil), forCellReuseIdentifier: HouseFeatureCell.reuseIdentifierStr)
    }
    
}

extension HouseShaixuanSelectView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if isLianHeBanGong != HouseTypeEnum.officeBuildingEnum {
            return LianHeBanGongdataArray.count
        }else {
            return XieZiLouDataArray.count
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLianHeBanGong != HouseTypeEnum.officeBuildingEnum {
            return LianHeBanGongdataArray[section].count
        }else {
            return XieZiLouDataArray[section].count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var iwanttType:IWantToFindType
        if isLianHeBanGong != HouseTypeEnum.officeBuildingEnum {
            iwanttType = LianHeBanGongdataArray[indexPath.section][indexPath.row]
        }else {
            iwanttType = XieZiLouDataArray[indexPath.section][indexPath.row]
        }
        
        switch iwanttType {
            
        case .IWantToFindTypeCity:
            return CityOrRegionSelectCell.rowHeight()
            
        case .IWantToFindTypeHouseType:
            return HouseTypeCell.rowHeight()
            
        case .IWantToFindTypeGongwei:
            return ExtentSelectCell.rowHeight()
            
        case .IWantToFindTypeZujin:
            return ExtentSelectCell.rowHeight()
            
        case .IWantToFindTypeMianji:
            return ExtentSelectCell.rowHeight()
            
        case .IWantToFindTypeFeature:
            
            return CGFloat((self.selectModel.shaixuanModel.featureModelArr.count / 3 + 1) * (60 + 10))
            
        case .IWantToFindTypeDocumentType:
            if isLianHeBanGong == HouseTypeEnum.jointOfficeEnum {
                return 0
            }else {
                return CGFloat((self.selectModel.shaixuanModel.documentTypeModelArr.count / 3 + 1) * (60 + 10))
            }
        case .IWantToFindTypeGongwei1:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var iwanttType:IWantToFindType
        //联合办公
        if isLianHeBanGong != HouseTypeEnum.officeBuildingEnum {
            iwanttType = LianHeBanGongdataArray[indexPath.section][indexPath.row]
            switch iwanttType {
            case .IWantToFindTypeCity:
                let cell = tableView.dequeueReusableCell(withIdentifier: CityOrRegionSelectCell.reuseIdentifierStr) as? CityOrRegionSelectCell
                cell?.selectionStyle = .none
                return cell ?? CityOrRegionSelectCell.init(frame: .zero)
            case .IWantToFindTypeHouseType:
                let cell = tableView.dequeueReusableCell(withIdentifier: HouseTypeCell.reuseIdentifierStr) as? HouseTypeCell
                cell?.houseTypeBlock = {[weak self] (type: HouseTypeEnum) -> Void in
                    if self?.isLianHeBanGong == type {
                        
                    }else {
                        self?.selectModel.typeModel.type = type
                        self?.isLianHeBanGong = type
                        self?.tableView.reloadData()
                    }
                }
                cell?.selectionStyle = .none
                return cell ?? HouseTypeCell.init(frame: .zero)
            case .IWantToFindTypeGongwei:
                let cell = tableView.dequeueReusableCell(withIdentifier: ExtentSelectCell.reuseIdentifierStr) as? ExtentSelectCell
                cell?.selectionStyle = .none
                cell?.categoryTitleLabel.text = "工位"
                cell?.unit = "个"
                cell?.minimumValue = self.selectModel.shaixuanModel.gongweijointOfficeExtentModel.minimumValue
                cell?.maximumValue = self.selectModel.shaixuanModel.gongweijointOfficeExtentModel.maximumValue
                cell?.lowValue = self.selectModel.shaixuanModel.gongweijointOfficeExtentModel.lowValue
                cell?.highValue = self.selectModel.shaixuanModel.gongweijointOfficeExtentModel.highValue
                cell?.sureExtentButtonCallBack = { [weak self] (low, high) in
                    self?.selectModel.shaixuanModel.gongweijointOfficeExtentModel.lowValue = low
                    self?.selectModel.shaixuanModel.gongweijointOfficeExtentModel.highValue = high
                }
                return cell ?? ExtentSelectCell.init(frame: .zero)
            case .IWantToFindTypeZujin:
                let cell = tableView.dequeueReusableCell(withIdentifier: ExtentSelectCell.reuseIdentifierStr) as? ExtentSelectCell
                cell?.categoryTitleLabel.text = "租金"
                cell?.unit = "元/m²/天"
                cell?.minimumValue = self.selectModel.shaixuanModel.zujinjointOfficeExtentModel.minimumValue
                cell?.maximumValue = self.selectModel.shaixuanModel.zujinjointOfficeExtentModel.maximumValue
                cell?.lowValue = self.selectModel.shaixuanModel.zujinjointOfficeExtentModel.lowValue
                cell?.highValue = self.selectModel.shaixuanModel.zujinjointOfficeExtentModel.highValue
                cell?.sureExtentButtonCallBack = { [weak self] (low, high) in
                    self?.selectModel.shaixuanModel.zujinjointOfficeExtentModel.lowValue = low
                    self?.selectModel.shaixuanModel.zujinjointOfficeExtentModel.highValue = high
                }
                cell?.selectionStyle = .none
                return cell ?? ExtentSelectCell.init(frame: .zero)
            case .IWantToFindTypeMianji:
                let cell = tableView.dequeueReusableCell(withIdentifier: ExtentSelectCell.reuseIdentifierStr) as? ExtentSelectCell
                cell?.selectionStyle = .none
                return cell ?? ExtentSelectCell.init(frame: .zero)
            case .IWantToFindTypeFeature:
                let cell = tableView.dequeueReusableCell(withIdentifier: HouseFeatureCell.reuseIdentifierStr) as? HouseFeatureCell
                cell?.selectionStyle = .none
                cell?.categoryTitleLabel.text = "装修特色"
                cell?.isDocumentType = false
                cell?.selectModel = self.selectModel
                return cell ?? HouseFeatureCell.init(frame: .zero)
            case .IWantToFindTypeDocumentType:
                let cell = tableView.dequeueReusableCell(withIdentifier: HouseFeatureCell.reuseIdentifierStr) as? HouseFeatureCell
                cell?.isDocumentType = true
                return cell ?? HouseFeatureCell.init(frame: .zero)
            case .IWantToFindTypeGongwei1:
                return BaseTableViewCell()
            }
        }else {
            iwanttType = XieZiLouDataArray[indexPath.section][indexPath.row]
            switch iwanttType {
            case .IWantToFindTypeCity:
                let cell = tableView.dequeueReusableCell(withIdentifier: CityOrRegionSelectCell.reuseIdentifierStr) as? CityOrRegionSelectCell
                cell?.selectionStyle = .none
                return cell ?? CityOrRegionSelectCell.init(frame: .zero)
            case .IWantToFindTypeHouseType:
                let cell = tableView.dequeueReusableCell(withIdentifier: HouseTypeCell.reuseIdentifierStr) as? HouseTypeCell
                
                cell?.houseTypeBlock = {[weak self] (type: HouseTypeEnum) -> Void in
                    if self?.isLianHeBanGong == type {
                        
                    }else {
                        self?.isLianHeBanGong = type
                        self?.selectModel.typeModel.type = type
                        self?.tableView.reloadData()
                    }
                }
                cell?.selectionStyle = .none
                return cell ?? HouseTypeCell.init(frame: .zero)
            case .IWantToFindTypeGongwei:
                let cell = tableView.dequeueReusableCell(withIdentifier: ExtentSelectCell.reuseIdentifierStr) as? ExtentSelectCell
                cell?.selectionStyle = .none
                cell?.categoryTitleLabel.text = "工位"
                cell?.unit = "个"
                cell?.minimumValue = self.selectModel.shaixuanModel.gongweiofficeBuildingExtentModel.minimumValue
                cell?.maximumValue = self.selectModel.shaixuanModel.gongweiofficeBuildingExtentModel.maximumValue
                cell?.lowValue = self.selectModel.shaixuanModel.gongweiofficeBuildingExtentModel.lowValue
                cell?.highValue = self.selectModel.shaixuanModel.gongweiofficeBuildingExtentModel.highValue
                cell?.sureExtentButtonCallBack = { [weak self] (low, high) in
                    self?.selectModel.shaixuanModel.gongweiofficeBuildingExtentModel.lowValue = low
                    self?.selectModel.shaixuanModel.gongweiofficeBuildingExtentModel.highValue = high
                }
                return cell ?? ExtentSelectCell.init(frame: .zero)
            case .IWantToFindTypeZujin:
                let cell = tableView.dequeueReusableCell(withIdentifier: ExtentSelectCell.reuseIdentifierStr) as? ExtentSelectCell
                cell?.selectionStyle = .none
                cell?.categoryTitleLabel.text = "租金"
                cell?.unit = "元/m²/天"
                cell?.minimumValue = self.selectModel.shaixuanModel.zujinofficeBuildingExtentModel.minimumValue
                cell?.maximumValue = self.selectModel.shaixuanModel.zujinofficeBuildingExtentModel.maximumValue
                cell?.lowValue = self.selectModel.shaixuanModel.zujinofficeBuildingExtentModel.lowValue
                cell?.highValue = self.selectModel.shaixuanModel.zujinofficeBuildingExtentModel.highValue
                cell?.sureExtentButtonCallBack = { [weak self] (low, high) in
                    self?.selectModel.shaixuanModel.zujinofficeBuildingExtentModel.lowValue = low
                    self?.selectModel.shaixuanModel.zujinofficeBuildingExtentModel.highValue = high
                }
                return cell ?? ExtentSelectCell.init(frame: .zero)
            case .IWantToFindTypeMianji:
                let cell = tableView.dequeueReusableCell(withIdentifier: ExtentSelectCell.reuseIdentifierStr) as? ExtentSelectCell
                cell?.selectionStyle = .none
                cell?.categoryTitleLabel.text = "面积"
                cell?.unit = "m²"
                cell?.minimumValue = self.selectModel.shaixuanModel.mianjiofficeBuildingExtentModel.minimumValue
                cell?.maximumValue = self.selectModel.shaixuanModel.mianjiofficeBuildingExtentModel.maximumValue
                cell?.lowValue = self.selectModel.shaixuanModel.mianjiofficeBuildingExtentModel.lowValue
                cell?.highValue = self.selectModel.shaixuanModel.mianjiofficeBuildingExtentModel.highValue
                cell?.sureExtentButtonCallBack = { [weak self] (low, high) in
                    self?.selectModel.shaixuanModel.mianjiofficeBuildingExtentModel.lowValue = low
                    self?.selectModel.shaixuanModel.mianjiofficeBuildingExtentModel.highValue = high
                }
                return cell ?? ExtentSelectCell.init(frame: .zero)
            case .IWantToFindTypeFeature:
                let cell = tableView.dequeueReusableCell(withIdentifier: HouseFeatureCell.reuseIdentifierStr) as? HouseFeatureCell
                cell?.selectionStyle = .none
                cell?.categoryTitleLabel.text = "装修特色"
                cell?.isDocumentType = false
                cell?.selectModel = self.selectModel
                return cell ?? HouseFeatureCell.init(frame: .zero)
            case .IWantToFindTypeDocumentType:
                let cell = tableView.dequeueReusableCell(withIdentifier: HouseFeatureCell.reuseIdentifierStr) as? HouseFeatureCell
                cell?.selectionStyle = .none
                cell?.categoryTitleLabel.text = "装修类型"
                cell?.isDocumentType = true
                cell?.selectModel = self.selectModel
                return cell ?? HouseFeatureCell.init(frame: .zero)
            case .IWantToFindTypeGongwei1:
                return BaseTableViewCell()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}


class BottomBtnView: UIView {
    
    lazy var leftBtn: UIButton = {
        let button = UIButton.init()
        button.clipsToBounds = true
        button.backgroundColor = kAppColor_bgcolor_F7F7F7
        button.titleLabel?.font = FONT_MEDIUM_16
        button.addTarget(self, action: #selector(leftBtnClick), for: .touchUpInside)
        return button
    }()
    
    lazy var rightSelectBtn: UIButton = {
        let button = UIButton.init()
        button.clipsToBounds = true
        button.backgroundColor = kAppBlueColor
        button.titleLabel?.font = FONT_MEDIUM_16
        button.setTitleColor(kAppWhiteColor, for: .normal)
        button.addTarget(self, action: #selector(sureSelectClick), for: .touchUpInside)
        return button
    }()
    
    
    var leftBtnClickBlock: (() -> Void)?
    
    var rightBtnClickBlock: (() -> Void)?
    
    
    @objc func leftBtnClick() {
        guard let blockk = leftBtnClickBlock else {
            return
        }
        blockk()
    }
    
    @objc func sureSelectClick() {
        guard let blockk = rightBtnClickBlock else {
            return
        }
        blockk()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    
    var bottomType: BottomBtnViewType = BottomBtnViewType.BottomBtnViewTypeIwantToFind {
        didSet {
            updateViewFrame()
        }
    }
    
    func updateViewFrame() {
        switch bottomType {
        case .BottomBtnViewTypeIwantToFind: //我想找页面 - 只显示一个确定按钮
            leftBtn.isHidden = true
            rightSelectBtn.layer.cornerRadius = button_cordious_2
            
            rightSelectBtn.setTitle("确定", for: .normal)
            rightSelectBtn.snp.makeConstraints { (make) in
                make.leading.equalTo(left_pending_space_17)
                make.trailing.equalToSuperview().offset(-left_pending_space_17)
                make.centerY.equalToSuperview()
                make.height.equalTo(40)
            }
        case .BottomBtnViewTypeShaixuan:    //筛选页面 - 两个按钮 清除 确定
            leftBtn.isHidden = false
            leftBtn.layer.cornerRadius = button_cordious_2
            rightSelectBtn.layer.cornerRadius = button_cordious_2
            leftBtn.setTitle("清除", for: .normal)
            leftBtn.setTitleColor(kAppBlackColor, for: .normal)
            rightSelectBtn.setTitle("确定", for: .normal)
            let width = (self.width - left_pending_space_17 * 2 - 15) / 3.0
            
            leftBtn.snp.makeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.height.equalTo(40)
                make.width.equalTo(width)
                make.leading.equalTo(left_pending_space_17)
            }
            rightSelectBtn.snp.makeConstraints { (make) in
                make.trailing.equalToSuperview().offset(-left_pending_space_17)
                make.centerY.equalToSuperview()
                make.height.equalTo(40)
                make.width.equalTo(width * 2)
            }
        case .BottomBtnViewTypeOfficeDetail://详情页面 - 收藏 - 找房东
            leftBtn.isHidden = false
            leftBtn.layer.cornerRadius = button_cordious_2
            rightSelectBtn.layer.cornerRadius = button_cordious_2
            leftBtn.backgroundColor = kAppWhiteColor
            leftBtn.titleLabel?.font = FONT_9
            leftBtn.setTitleColor(kAppColor_999999, for: .normal)
            leftBtn.setTitle("收藏", for: .normal)
            leftBtn.setImage(UIImage.init(named: "collectItemUnSel"), for: .normal)
            leftBtn.setTitle("已收藏", for: .selected)
            leftBtn.setImage(UIImage.init(named: "collectItemSel"), for: .selected)
            leftBtn.layoutButton(.imagePositionTop, space: 10)
            
            rightSelectBtn.setTitle("找房东", for: .normal)
            
            leftBtn.snp.makeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.height.equalTo(40)
                make.width.equalTo(60)
                make.leading.equalTo(left_pending_space_17)
            }
            rightSelectBtn.snp.makeConstraints { (make) in
                make.leading.equalTo(leftBtn.snp.trailing)
                make.trailing.equalToSuperview().offset(-left_pending_space_17)
                make.centerY.equalToSuperview()
                make.height.equalTo(40)
            }
            
        case .BottomBtnViewTypeChatAlertBottomView://详情页面 - 收藏 - 找房东
            leftBtn.isHidden = false
            leftBtn.backgroundColor = kAppLightLightBlueColor
            leftBtn.titleLabel?.font = FONT_14
            leftBtn.setTitleColor(kAppColor_666666, for: .normal)
            leftBtn.setTitle("取消", for: .normal)
            rightSelectBtn.isHidden = false
            rightSelectBtn.backgroundColor = kAppBlueColor
            rightSelectBtn.titleLabel?.font = FONT_14
            rightSelectBtn.setTitleColor(kAppWhiteColor, for: .normal)
            rightSelectBtn.setTitle("确定", for: .normal)
            
            leftBtn.snp.makeConstraints { (make) in
                make.leading.height.centerY.equalToSuperview()
                make.width.equalTo(self.width / 2.0)
            }
            rightSelectBtn.snp.makeConstraints { (make) in
                make.trailing.height.centerY.equalToSuperview()
                make.width.equalTo(self.width / 2.0)
            }
        }
        
    }
    
    private func setupView() {
        
        self.backgroundColor = kAppWhiteColor
        
        self.addSubview(leftBtn)
        self.addSubview(rightSelectBtn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


//
//  AreaAddressView.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/4/30.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit


class AreaAddressView: UIView {
    
    var areaCategoryLevelModel = AreaCategorySelectModel()
    
    var subwayCategoryLevelModel = SubwayCategorySelectModel()
    
    var areaFirstLevelModel = AreaCategoryFirstLevelSelectModel()
    
    var subwayFirstLevelModel = SubwayCategoryFirstLevelSelectModel()
    
    //    var categoryIndex: Int = 2
    //
    //    var firstLevelIndex: Int = 0
    //
    //    var secondLevelIndex: Int = 0
    
    //数据结构
    var areaRegionModel: AreaModel = AreaModel()
    
    var selectModel: HouseSelectModel?
    
    lazy var blackAlphabgView: UIButton = {
        let button = UIButton.init()
        button.backgroundColor = kAppAlphaWhite0_alpha_7
        button.addTarget(self, action: #selector(clickRemoveFromSuperview), for: .touchUpInside)
        return button
    }()
    
    lazy var categoryTableview: UITableView = {
        let view = UITableView.init(frame: .zero, style: .grouped)
        view.backgroundColor = kAppColor_bgcolor_F7F7F7
        view.separatorStyle = .none
        view.dataSource = self
        view.delegate = self
        view.estimatedRowHeight = 40
        view.tag = 1
        view.register(TypeAndSortCell.self, forCellReuseIdentifier: TypeAndSortCell.reuseIdentifierStr)
        return view
    }()
    
    lazy var firstLevelTableView: UITableView = {
        let view = UITableView.init(frame: .zero, style: .grouped)
        view.backgroundColor = kAppWhiteColor
        view.separatorStyle = .none
        view.dataSource = self
        view.delegate = self
        view.estimatedRowHeight = 40
        view.tag = 2
        view.register(TypeAndSortCell.self, forCellReuseIdentifier: TypeAndSortCell.reuseIdentifierStr)
        return view
    }()
    
    lazy var secondLevelTableView: UITableView = {
        let view = UITableView.init(frame: .zero, style: .grouped)
        view.backgroundColor = kAppWhiteColor
        view.separatorStyle = .none
        view.dataSource = self
        view.delegate = self
        view.estimatedRowHeight = 40
        view.tag = 3
        view.register(AreaSubwayMutileSelectCell.self, forCellReuseIdentifier: AreaSubwayMutileSelectCell.reuseIdentifierStr)
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
    var clearButtonCallBack:((HouseSelectModel) -> Void)?
    
    //筛选block
    var sureAreaaddressButtonCallBack:((HouseSelectModel) -> Void)?
    
    @objc func clickRemoveFromSuperview() {
        selfRemove()
    }
    
    func selfRemove() {
        self.removeFromSuperview()
    }
    
    // MARK: - 弹出view显示
    // MARK: - 弹出view显示 - 筛选
    func ShowAreaaddressView(isfirst: Bool, model: HouseSelectModel, clearButtonCallBack: @escaping ((HouseSelectModel) -> Void), sureAreaaddressButtonCallBack: @escaping ((HouseSelectModel) -> Void)) -> Void {
        
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
        self.frame = CGRect(x: 0.0, y: kNavigationHeight + 60, width: kWidth, height: kHeight - kNavigationHeight - 60)
        
        self.clearButtonCallBack = clearButtonCallBack
        self.sureAreaaddressButtonCallBack = sureAreaaddressButtonCallBack
        selectModel = model
        areaRegionModel = model.areaModel
        areaCategoryLevelModel = areaRegionModel.areaModelCount
        //        areaFirstLevelModel = areaCategoryLevelModel.data[0]
        subwayCategoryLevelModel = areaRegionModel.subwayModelCount
        //        subwayFirstLevelModel = SubwayCategoryFirstLevelSelectModel()
        
        if isfirst != true {
            reloadNodata()
        }
        
        UIApplication.shared.keyWindow?.addSubview(self)
    }
    
    func reloadNodata() {
        clearData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.frame = frame
        
        setUpSubviews()
    }
    
    func setUpSubviews() {
        self.addSubview(blackAlphabgView)
        self.addSubview(categoryTableview)
        self.addSubview(firstLevelTableView)
        self.addSubview(secondLevelTableView)
        self.addSubview(bottomBtnView)
        
        bottomBtnView.leftBtnClickBlock = { [weak self] in
            self?.clearData()
            guard let blockk = self?.clearButtonCallBack else {
                return
            }
            blockk(self?.selectModel ?? HouseSelectModel())
            self?.selfRemove()
        }
        bottomBtnView.rightBtnClickBlock = { [weak self] in
            guard let blockk = self?.sureAreaaddressButtonCallBack else {
                return
            }
            blockk(self?.selectModel ?? HouseSelectModel())
            self?.selfRemove()
        }
        
        blackAlphabgView.snp.makeConstraints { (make) in
            make.top.leading.bottom.trailing.equalToSuperview()
        }
        
        bottomBtnView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-kTabBarHeight)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        
        categoryTableview.snp.makeConstraints { (make) in
            make.top.leading.equalToSuperview()
            make.bottom.equalTo(bottomBtnView.snp.top)
            make.width.equalTo(1 / 4.0 * kWidth)
        }
        
        firstLevelTableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.equalTo(1 / 4.0 * kWidth)
            make.bottom.equalTo(categoryTableview.snp.bottom)
            make.width.equalTo(9 / 32.0 * kWidth)
        }
        
        secondLevelTableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.equalTo(1 / 4.0 * kWidth + 9 / 32.0 * kWidth)
            make.bottom.equalTo(categoryTableview.snp.bottom)
            make.trailing.equalToSuperview()
        }
        
    }
    
    //MARK: 清除数据操作
    func clearData() {
        
        if areaRegionModel.selectedCategoryID == "1" {
            for model in areaFirstLevelModel.list {
                model.isSelected = false
            }
            areaRegionModel.areaModelCount.isFirstSelectedModel = nil
            areaCategoryLevelModel = areaRegionModel.areaModelCount
            areaFirstLevelModel = AreaCategoryFirstLevelSelectModel()

            areaRegionModel.subwayModelCount.isFirstSelectedModel = nil
            subwayCategoryLevelModel = areaRegionModel.subwayModelCount            
            subwayFirstLevelModel = SubwayCategoryFirstLevelSelectModel()
            
        }else {
            for model in subwayFirstLevelModel.list {
                model.isSelected = false
            }
            areaRegionModel.areaModelCount.isFirstSelectedModel = nil
            areaCategoryLevelModel = areaRegionModel.areaModelCount
            areaFirstLevelModel = AreaCategoryFirstLevelSelectModel()

            areaRegionModel.subwayModelCount.isFirstSelectedModel = nil
            subwayCategoryLevelModel = areaRegionModel.subwayModelCount
            subwayFirstLevelModel = SubwayCategoryFirstLevelSelectModel()
            
        }
        //清除操作
        categoryTableview.reloadData()
        firstLevelTableView.reloadData()
        secondLevelTableView.reloadData()
    }
}

extension AreaAddressView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 1 {
            return 2
        }else if tableView.tag == 2 {
            if areaRegionModel.selectedCategoryID == "1" {
                return areaCategoryLevelModel.data.count
            }else {
                return subwayCategoryLevelModel.data.count
                
            }
        }else  {
            if areaRegionModel.selectedCategoryID == "1" {
                return areaFirstLevelModel.list.count
            }else {
                return subwayFirstLevelModel.list.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: TypeAndSortCell.reuseIdentifierStr) as? TypeAndSortCell
            cell?.selectionStyle = .none
            cell?.backgroundColor = kAppClearColor
            cell?.titleLabel.backgroundColor = kAppClearColor
            
            if indexPath.row == 0 {
                cell?.titleLabel.text = areaRegionModel.areaModelCount.name
                
                if areaCategoryLevelModel.id ==  areaRegionModel.selectedCategoryID {
                    var selNum = 0
                    for model in areaFirstLevelModel.list {
                        if model.isSelected ?? false {
                            selNum += 1
                        }
                    }
                    if selNum > 0 {
                        cell?.itemNumView.isHidden = false
                        cell?.itemNumView.text = "\(selNum)"
                    }else {
                        cell?.itemNumView.isHidden = true
                    }
                    cell?.titleLabel.textColor = kAppBlueColor
                    
                }else {
                    cell?.itemNumView.isHidden = true
                    cell?.titleLabel.textColor = kAppColor_333333
                }
            }else {
                
                cell?.titleLabel.text = areaRegionModel.subwayModelCount.name
                
                if subwayCategoryLevelModel.id ==  areaRegionModel.selectedCategoryID {
                    var selNum = 0
                    for model in subwayFirstLevelModel.list {
                        if model.isSelected ?? false {
                            selNum += 1
                        }
                    }
                    if selNum > 0 {
                        cell?.itemNumView.isHidden = false
                        cell?.itemNumView.text = "\(selNum)"
                    }else {
                        cell?.itemNumView.isHidden = true
                    }
                    cell?.titleLabel.textColor = kAppBlueColor
                    
                }else {
                    cell?.itemNumView.isHidden = true
                    cell?.titleLabel.textColor = kAppColor_333333
                }
            }
            
            
            return cell ?? TypeAndSortCell()
        }else if tableView.tag == 2 {
            if areaRegionModel.selectedCategoryID == "1" {
                let cell = tableView.dequeueReusableCell(withIdentifier: TypeAndSortCell.reuseIdentifierStr) as? TypeAndSortCell
                cell?.selectionStyle = .none
                if self.areaCategoryLevelModel.data.count > 0 {
                    cell?.titleLabel.text = areaCategoryLevelModel.data[indexPath.row].district
                    if areaFirstLevelModel.districtID ==  areaCategoryLevelModel.data[indexPath.row].districtID{
                        cell?.titleLabel.textColor = kAppBlueColor
                    }else {
                        cell?.titleLabel.textColor = kAppColor_333333
                    }
                }
                return cell ?? TypeAndSortCell()
            }else {
                let cell = tableView.dequeueReusableCell(withIdentifier: TypeAndSortCell.reuseIdentifierStr) as? TypeAndSortCell
                cell?.selectionStyle = .none
                if self.subwayCategoryLevelModel.data.count > 0 {
                    cell?.titleLabel.text = subwayCategoryLevelModel.data[indexPath.row].line
                    if subwayFirstLevelModel.lid ==  subwayCategoryLevelModel.data[indexPath.row].lid{
                        cell?.titleLabel.textColor = kAppBlueColor
                    }else {
                        cell?.titleLabel.textColor = kAppColor_333333
                    }
                }
                return cell ?? TypeAndSortCell()
            }
            
        }else  {
            if areaRegionModel.selectedCategoryID == "1" {
                let cell = tableView.dequeueReusableCell(withIdentifier: AreaSubwayMutileSelectCell.reuseIdentifierStr) as? AreaSubwayMutileSelectCell
                cell?.selectionStyle = .none
                if self.areaFirstLevelModel.list.count > indexPath.row {
                    cell?.layoutSubviews()
                    let model = areaFirstLevelModel.list[indexPath.row]
                    cell?.titleLabel.text = model.area
                    
                    if model.isSelected == true {
                        cell?.titleLabel.textColor = kAppBlueColor
                        cell?.itemImg.image = UIImage.init(named: "circleSelected")
                    }else {
                        cell?.titleLabel.textColor = kAppColor_333333
                        cell?.itemImg.image = UIImage.init(named: "circleUnSelected")
                    }
                }
                return cell ?? AreaSubwayMutileSelectCell()
            }else {
                let cell = tableView.dequeueReusableCell(withIdentifier: AreaSubwayMutileSelectCell.reuseIdentifierStr) as? AreaSubwayMutileSelectCell
                cell?.selectionStyle = .none
                if self.subwayFirstLevelModel.list.count > indexPath.row {
                    cell?.layoutSubviews()
                    let model = subwayFirstLevelModel.list[indexPath.row]
                    cell?.titleLabel.text = model.stationName
                    
                    if model.isSelected == true {
                        cell?.titleLabel.textColor = kAppBlueColor
                        cell?.itemImg.image = UIImage.init(named: "circleSelected")
                    }else {
                        cell?.titleLabel.textColor = kAppColor_333333
                        cell?.itemImg.image = UIImage.init(named: "circleUnSelected")
                    }
                }
                return cell ?? AreaSubwayMutileSelectCell()
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
        if tableView.tag == 1 {
            
            if indexPath.row == 0 {
                
                if areaRegionModel.selectedCategoryID == areaCategoryLevelModel.id {
                    
                }else {
                    areaRegionModel.selectedCategoryID = areaCategoryLevelModel.id
                    for model in areaFirstLevelModel.list {
                        model.isSelected = false
                    }
                    
                    areaRegionModel.areaModelCount.isFirstSelectedModel = nil
                    areaCategoryLevelModel = areaRegionModel.areaModelCount
                    areaFirstLevelModel = AreaCategoryFirstLevelSelectModel()

                    areaRegionModel.subwayModelCount.isFirstSelectedModel = nil
                    subwayCategoryLevelModel = areaRegionModel.subwayModelCount
                    subwayFirstLevelModel = SubwayCategoryFirstLevelSelectModel()
                    
                    categoryTableview.reloadData()
                    firstLevelTableView.reloadData()
                    secondLevelTableView.reloadData()
                }
                
            }else if indexPath.row == 1 {
                
                if areaRegionModel.selectedCategoryID == subwayCategoryLevelModel.id {
                    
                }else {
                    areaRegionModel.selectedCategoryID = subwayCategoryLevelModel.id
                    for model in subwayFirstLevelModel.list {
                        model.isSelected = false
                    }
                    
                    areaRegionModel.areaModelCount.isFirstSelectedModel = nil
                    areaCategoryLevelModel = areaRegionModel.areaModelCount
                    areaFirstLevelModel = AreaCategoryFirstLevelSelectModel()

                    areaRegionModel.subwayModelCount.isFirstSelectedModel = nil
                    subwayCategoryLevelModel = areaRegionModel.subwayModelCount
                    subwayFirstLevelModel = SubwayCategoryFirstLevelSelectModel()
                    
                    categoryTableview.reloadData()
                    firstLevelTableView.reloadData()
                    secondLevelTableView.reloadData()
                }
                
            }
            
            
        }else if tableView.tag == 2 {
            
            if areaRegionModel.selectedCategoryID == "1" {
                if areaFirstLevelModel.districtID == areaCategoryLevelModel.data[indexPath.row].districtID {
                    
                }else {
                    for model in areaFirstLevelModel.list {
                        model.isSelected = false
                    }
                    areaFirstLevelModel = areaCategoryLevelModel.data[indexPath.row]
                    areaRegionModel.areaModelCount.isFirstSelectedModel = areaFirstLevelModel
                    
                    categoryTableview.reloadData()
                    firstLevelTableView.reloadData()
                    secondLevelTableView.reloadData()
                }
                
            }else {
                if subwayFirstLevelModel.lid == subwayCategoryLevelModel.data[indexPath.row].lid {
                    
                }else {
                    for model in subwayFirstLevelModel.list {
                        model.isSelected = false
                    }
                    subwayFirstLevelModel = subwayCategoryLevelModel.data[indexPath.row]
                    areaRegionModel.subwayModelCount.isFirstSelectedModel = subwayFirstLevelModel
                    
                    categoryTableview.reloadData()
                    firstLevelTableView.reloadData()
                    secondLevelTableView.reloadData()
                }
            }
            
        }else  {
            if areaRegionModel.selectedCategoryID == "1" {
                areaFirstLevelModel.list[indexPath.row].isSelected = !(areaFirstLevelModel.list[indexPath.row].isSelected ?? false)
                categoryTableview.reloadData()
                secondLevelTableView.reloadData()
            }else {
                subwayFirstLevelModel.list[indexPath.row].isSelected = !(subwayFirstLevelModel.list[indexPath.row].isSelected ?? false)
                categoryTableview.reloadData()
                secondLevelTableView.reloadData()
            }
            
        }
    }
}

class AreaSubwayMutileSelectCell: BaseTableViewCell {
    
    lazy var itemImg: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.numberOfLines = 0
        view.font = FONT_LIGHT_13
        
        view.textColor = kAppColor_333333
        return view
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {

        self.backgroundColor = kAppWhiteColor
        self.contentView.addSubview(itemImg)
        self.contentView.addSubview(titleLabel)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        itemImg.frame = CGRect(x: 20, y: (self.height - 14) / 2.0, width: 14, height: 14)
        titleLabel.frame = CGRect(x: itemImg.right + 12, y: 0, width: self.width - itemImg.right - 12, height: self.height)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}

//
//  CityDistrictAddressSelectView.swift
//  OfficeGo
//
//  Created by mac on 2020/7/20.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class CityDistrictAddressSelectView: UIView {
    
    var areaCategoryLevelModel = CityAreaCategorySelectModel()
    
    var areaFirstLevelModel = CityAreaCategoryFirstLevelSelectModel()
    
    var areaSecondLevelModel = CityAreaCategorySecondLevelSelectModel()
    
    lazy var blackAlphabgView: UIButton = {
        let button = UIButton.init()
        button.backgroundColor = UIColor.init(white: 0, alpha: 0.7)
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
        view.leftBtn.setTitle("取消", for: .normal)
        return view
    }()
    
    lazy var cityLabel: UIButton = {
        let view = UIButton()
        view.titleLabel?.font = FONT_13
        view.setTitleColor(kAppColor_333333, for: .normal)
        view.backgroundColor = kAppLightBlueColor
        return view
    }()
    lazy var districtLabel: UIButton = {
        let view = UIButton()
        view.titleLabel?.font = FONT_13
        view.setTitleColor(kAppColor_333333, for: .normal)
        view.backgroundColor = kAppLightBlueColor
        return view
    }()
    lazy var areaDistrictLabel: UIButton = {
        let view = UIButton()
        view.titleLabel?.font = FONT_13
        view.setTitleColor(kAppColor_333333, for: .normal)
        view.backgroundColor = kAppLightBlueColor
        return view
    }()
    
    // MARK: - block
    //清除block
    var clearButtonCallBack:((CityAreaCategorySelectModel) -> Void)?
    
    //筛选block
    var sureAreaaddressButtonCallBack:((CityAreaCategorySelectModel) -> Void)?
    
    @objc func clickRemoveFromSuperview() {
        selfRemove()
    }
    
    func selfRemove() {
        self.removeFromSuperview()
    }
    
    class func removeShowView() {
        UIApplication.shared.keyWindow?.subviews.forEach({ (view) in
            if view.isKind(of: CityDistrictAddressSelectView.self) {
                view.removeFromSuperview()
            }
        })
    }
    
    // MARK: - 弹出view显示
    // MARK: - 弹出view显示 - 筛选
    func ShowCityDistrictAddressSelectView(isfirst: Bool, model: CityAreaCategorySelectModel, clearButtonCallBack: @escaping ((CityAreaCategorySelectModel) -> Void), sureAreaaddressButtonCallBack: @escaping ((CityAreaCategorySelectModel) -> Void)) -> Void {
        
        UIApplication.shared.keyWindow?.subviews.forEach({ (view) in
            if view.isKind(of: CityDistrictAddressSelectView.self) {
                view.removeFromSuperview()
            }
            if view.isKind(of: HouseTypeAndSortSelectView.self) {
                view.removeFromSuperview()
            }
            if view.isKind(of: HouseShaixuanSelectView.self) {
                view.removeFromSuperview()
            }
        })
        self.clearButtonCallBack = clearButtonCallBack
        self.sureAreaaddressButtonCallBack = sureAreaaddressButtonCallBack
        areaCategoryLevelModel = model
        areaFirstLevelModel = model.isFirstSelectedModel ?? CityAreaCategoryFirstLevelSelectModel()
        areaSecondLevelModel = areaFirstLevelModel.isSencondSelectedModel ?? CityAreaCategorySecondLevelSelectModel()
        
        districtLabel.setTitle(areaFirstLevelModel.district, for: .normal)

        areaDistrictLabel.setTitle(areaSecondLevelModel.area, for: .normal)
        
//        if isfirst != true {
//            reloadNodata()
//        }
        categoryTableview.reloadData()
        firstLevelTableView.reloadData()
        secondLevelTableView.reloadData()
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

        
        addSubview(blackAlphabgView)
        
        
        addSubview(cityLabel)
        addSubview(districtLabel)
        addSubview(areaDistrictLabel)
        
        addSubview(categoryTableview)
        addSubview(firstLevelTableView)
        addSubview(secondLevelTableView)
        addSubview(bottomBtnView)
        
        bottomBtnView.leftBtnClickBlock = { [weak self] in
//            self?.clearData()
//            guard let blockk = self?.clearButtonCallBack else {
//                return
//            }
//            blockk(self?.areaCategoryLevelModel ?? CityAreaCategorySelectModel())
            self?.selfRemove()
        }
        bottomBtnView.rightBtnClickBlock = { [weak self] in
            guard let blockk = self?.sureAreaaddressButtonCallBack else {
                return
            }
            self?.areaFirstLevelModel.isSencondSelectedModel = self?.areaSecondLevelModel
            self?.areaCategoryLevelModel.isFirstSelectedModel = self?.areaFirstLevelModel
            if self?.areaCategoryLevelModel.isFirstSelectedModel?.districtID == nil || self?.areaCategoryLevelModel.isFirstSelectedModel?.districtID?.isBlankString == true{
                AppUtilities.makeToast("请选择所在区域")
                return
            }
            
            if self?.areaCategoryLevelModel.isFirstSelectedModel?.isSencondSelectedModel?.id == nil || self?.areaCategoryLevelModel.isFirstSelectedModel?.isSencondSelectedModel?.id?.isBlankString == true{
                AppUtilities.makeToast("请选择所商圈")
                return
            }
            blockk(self?.areaCategoryLevelModel ?? CityAreaCategorySelectModel())
            self?.selfRemove()
        }
        
        blackAlphabgView.snp.makeConstraints { (make) in
            make.top.leading.bottom.trailing.equalToSuperview()
        }
        
        bottomBtnView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        
        cityLabel.snp.makeConstraints { (make) in
            make.top.leading.equalToSuperview()
            make.height.equalTo(cell_height_58)
            make.width.equalTo(1 / 4.0 * kWidth)
        }
        
        districtLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.equalTo(1 / 4.0 * kWidth)
            make.height.equalTo(cell_height_58)
            make.width.equalTo(9 / 32.0 * kWidth)
        }
        
        areaDistrictLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.equalTo(1 / 4.0 * kWidth + 9 / 32.0 * kWidth)
            make.height.equalTo(cell_height_58)
            make.trailing.equalToSuperview()
        }
        
        categoryTableview.snp.makeConstraints { (make) in
            make.leading.equalTo(cityLabel)
            make.top.equalTo(cityLabel.snp.bottom)
            make.bottom.equalTo(bottomBtnView.snp.top)
            make.width.equalTo(1 / 4.0 * kWidth)
        }
        
        firstLevelTableView.snp.makeConstraints { (make) in
            make.top.equalTo(categoryTableview)
            make.leading.equalTo(1 / 4.0 * kWidth)
            make.bottom.equalTo(categoryTableview.snp.bottom)
            make.width.equalTo(9 / 32.0 * kWidth)
        }
        
        secondLevelTableView.snp.makeConstraints { (make) in
            make.top.equalTo(categoryTableview)
            make.leading.equalTo(1 / 4.0 * kWidth + 9 / 32.0 * kWidth)
            make.bottom.equalTo(categoryTableview.snp.bottom)
            make.trailing.equalToSuperview()
        }
        
    }
    
    //MARK: 清除数据操作
    func clearData() {
        
        for model in areaFirstLevelModel.list {
            model.isSelected = false
        }
        areaFirstLevelModel = CityAreaCategoryFirstLevelSelectModel()
        //清除操作
        categoryTableview.reloadData()
        firstLevelTableView.reloadData()
        secondLevelTableView.reloadData()
    }
}

extension CityDistrictAddressSelectView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 1 {
            return 1
        }else if tableView.tag == 2 {
            return areaCategoryLevelModel.data.count
        }else  {
            return areaFirstLevelModel.list.count
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
                cell?.titleLabel.text = areaCategoryLevelModel.name
                cityLabel.setTitle("上海", for: .normal)
            }
            
            return cell ?? TypeAndSortCell()
        }else if tableView.tag == 2 {
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
        } else  {
            let cell = tableView.dequeueReusableCell(withIdentifier: AreaSubwayMutileSelectCell.reuseIdentifierStr) as? AreaSubwayMutileSelectCell
            cell?.selectionStyle = .none
            if self.areaFirstLevelModel.list.count > indexPath.row {
                cell?.layoutSubviews()
                let model = areaFirstLevelModel.list[indexPath.row]
                cell?.titleLabel.text = model.area
                if areaSecondLevelModel.id ==  self.areaFirstLevelModel.list[indexPath.row].id{
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return UIView()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 1 {
            areaFirstLevelModel = CityAreaCategoryFirstLevelSelectModel()
            
            categoryTableview.reloadData()
            firstLevelTableView.reloadData()
            secondLevelTableView.reloadData()
        }else if tableView.tag == 2 {
            if areaFirstLevelModel.districtID == areaCategoryLevelModel.data[indexPath.row].districtID {
                
            }else {
                areaSecondLevelModel = CityAreaCategorySecondLevelSelectModel()
                areaFirstLevelModel = areaCategoryLevelModel.data[indexPath.row]
                
                districtLabel.setTitle(areaFirstLevelModel.district, for: .normal)

                areaDistrictLabel.setTitle(areaSecondLevelModel.area, for: .normal)
                
                categoryTableview.reloadData()
                firstLevelTableView.reloadData()
                secondLevelTableView.reloadData()
            }
            
        }else  {
            areaSecondLevelModel = areaFirstLevelModel.list[indexPath.row]
            
            areaDistrictLabel.setTitle(areaSecondLevelModel.area, for: .normal)
            
            categoryTableview.reloadData()
            secondLevelTableView.reloadData()
        }
    }
}

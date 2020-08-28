//
//  HouseSelectBtnView.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/4/29.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import HandyJSON
import SwiftyJSON

class HouseSelectBtnView: UIView {
    
    var hiddenArea: Bool = false {
        didSet {
            reloadLayout()
        }
    }
    
    var selectModel: HouseSelectModel?
    
    var houseAreaSelectBtn: UIButton = {
        let button = UIButton.init()
        button.setTitle("区域", for: .normal)
        button.setImage(UIImage(named: "downIcon"), for: .normal)
        button.setTitleColor(kAppColor_666666, for: .normal)
        button.titleLabel?.font = FONT_14
        button.layoutButton(.imagePositionLeft, margin: 4)
        button.setTitleColor(kAppBlueColor, for: .selected)
        button.addTarget(self, action: #selector(showAreaSelectView), for: .touchUpInside)
        return button
    }()
    
    var houseTypeSelectBtn: UIButton = {
        let button = UIButton.init()
        button.setTitle("全部", for: .normal)
        button.setImage(UIImage(named: "downIcon"), for: .normal)
        button.setTitleColor(kAppBlueColor, for: .normal)
        button.titleLabel?.font = FONT_14
        button.setTitleColor(kAppBlueColor, for: .selected)
        button.layoutButton(.imagePositionLeft, margin: 4)
        button.addTarget(self, action: #selector(showHouseTypeSelectView), for: .touchUpInside)
        return button
    }()
    var houseSortBtn: UIButton = {
        let button = UIButton.init()
        button.setTitle("排序", for: .normal)
        button.setImage(UIImage(named: "downIcon"), for: .normal)
        button.setTitleColor(kAppColor_666666, for: .normal)
        button.titleLabel?.font = FONT_14
        button.layoutButton(.imagePositionLeft, margin: 4)
        button.addTarget(self, action: #selector(showSortSelectView), for: .touchUpInside)
        return button
    }()
    var houseShaixuanBtn: UIButton = {
        let button = UIButton.init()
        button.setTitle("筛选", for: .normal)
        button.setImage(UIImage(named: "downIcon"), for: .normal)
        button.setTitleColor(kAppColor_666666, for: .normal)
        button.titleLabel?.font = FONT_14
        button.layoutButton(.imagePositionLeft, margin: 4)
        button.addTarget(self, action: #selector(showShaixuanSelectView), for: .touchUpInside)
        return button
    }()
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = kAppColor_line_EEEEEE
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    func reloadLayout() {
        
        //点击的时候 - 切换显示样式
        if hiddenArea == true {
            
            let width = self.width / 3.0

            houseAreaSelectBtn.isHidden = true
            houseTypeSelectBtn.snp.remakeConstraints { (make) in
                make.leading.top.bottom.equalToSuperview()
                make.width.equalTo(width)
            }
            houseSortBtn.snp.remakeConstraints { (make) in
                make.leading.equalToSuperview().offset(width)
                make.top.bottom.equalToSuperview()
                make.width.equalTo(width)
            }
            houseShaixuanBtn.snp.remakeConstraints { (make) in
                make.leading.equalToSuperview().offset(width * 2)
                make.top.bottom.equalToSuperview()
                make.width.equalTo(width)
            }
            
        }else {
            
            let width = self.width / 4.0

            houseAreaSelectBtn.isHidden = false
            houseAreaSelectBtn.snp.remakeConstraints { (make) in
                make.leading.top.bottom.equalToSuperview()
                make.width.equalTo(width)
            }
            houseTypeSelectBtn.snp.remakeConstraints { (make) in
                make.leading.equalToSuperview().offset(width)
                make.top.bottom.equalToSuperview()
                make.width.equalTo(width)
            }
            houseSortBtn.snp.remakeConstraints { (make) in
                make.leading.equalToSuperview().offset(width * 2)
                make.top.bottom.equalToSuperview()
                make.width.equalTo(width)
            }
            houseShaixuanBtn.snp.remakeConstraints { (make) in
                make.top.bottom.equalToSuperview()
                make.trailing.equalToSuperview()
                make.width.equalTo(width)
            }
        }
    }
    
    private func setupView() {
        
        self.backgroundColor = kAppWhiteColor
        
        addSubview(houseAreaSelectBtn)
        addSubview(houseTypeSelectBtn)
        addSubview(houseSortBtn)
        addSubview(houseShaixuanBtn)
        addSubview(lineView)

        let width = self.width / 4.0
        
        houseAreaSelectBtn.snp.makeConstraints { (make) in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalTo(width)
        }
        houseTypeSelectBtn.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(width)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(width)
        }
        houseSortBtn.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(width * 2)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(width)
        }
        houseShaixuanBtn.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
            make.width.equalTo(width)
        }
        
        lineView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var typeAndSortView: HouseTypeAndSortSelectView = {
        let view = HouseTypeAndSortSelectView.init(frame: CGRect(x: 0.0, y: self.bottom, width: kWidth, height: kHeight - self.bottom))
        return view
    }()
    
    var shaixuanView: HouseShaixuanSelectView?
    
    lazy var areaView: AreaAddressView = {
        let view = AreaAddressView.init(frame: CGRect(x: 0.0, y: self.bottom, width: kWidth, height: kHeight - self.bottom))
        return view
    }()
    
    //设置按钮箭头方向
    func setBtnUpOrDown(button: UIButton?, isUp: Bool) {
        if isUp {
            button?.setImage(UIImage(named: "upIcon"), for: .normal)
        }else {
            button?.setImage(UIImage(named: "downIcon"), for: .normal)
        }
    }
    
    //点击筛选之后的确定回掉 - 判断是否是附近
    var sureButtonButtonCallBack:((_ isNearby: Bool, HouseSelectModel) -> Void)?
    
    
    func removeShowView() {
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
    }
    
    @objc func showAreaSelectView() {
        setBtnUpOrDown(button: houseAreaSelectBtn, isUp: true)
        setBtnUpOrDown(button: houseTypeSelectBtn, isUp: false)
        setBtnUpOrDown(button: houseSortBtn, isUp: false)
        setBtnUpOrDown(button: houseShaixuanBtn, isUp: false)
        
        
        if selectModel?.areaModel.areaModelCount.data.count ?? 0 > 0 {
            self.showArea(isFrist: true)
        }else {
            request_getDistrict()
        }
    }
    
    func showArea(isFrist: Bool) {
        areaView.ShowAreaaddressView(isfirst: isFrist, model: self.selectModel ?? HouseSelectModel(), clearButtonCallBack: { [weak self] (_ selectModel: HouseSelectModel) -> Void in
                if selectModel.areaModel.selectedCategoryID == "1" {
                    
                    if selectModel.areaModel.areaModelCount.isFirstSelectedModel == nil {
                        self?.houseAreaSelectBtn.setTitle("区域", for: .normal)
                        self?.houseAreaSelectBtn.isSelected = false
                    }else {
                        self?.houseAreaSelectBtn.setTitle("商圈", for: .normal)
                        self?.houseAreaSelectBtn.isSelected = true
                    }
                    
                }else if selectModel.areaModel.selectedCategoryID == "2" {
                    
                    if selectModel.areaModel.subwayModelCount.isFirstSelectedModel == nil {
                        self?.houseAreaSelectBtn.setTitle("区域", for: .normal)
                        self?.houseAreaSelectBtn.isSelected = false
                    }else {
                        self?.houseAreaSelectBtn.setTitle("地铁", for: .normal)
                        self?.houseAreaSelectBtn.isSelected = true
                    }
                    
                }else {
                    self?.houseAreaSelectBtn.setTitle("区域", for: .normal)
                    self?.houseAreaSelectBtn.isSelected = false
                }
                self?.selectModel = selectModel
                self?.setBtnUpOrDown(button: self?.houseAreaSelectBtn, isUp: false)
                
                //把筛选条件带到页面上去
                guard let blockk = self?.sureButtonButtonCallBack else {
                    return
                }
                blockk(self?.hiddenArea ?? false, self?.selectModel ?? selectModel)
        }, sureAreaaddressButtonCallBack: { [weak self] (_ selectModel: HouseSelectModel) -> Void in
                if selectModel.areaModel.selectedCategoryID == "1" {
                    
                    if selectModel.areaModel.areaModelCount.isFirstSelectedModel == nil {
                        self?.houseAreaSelectBtn.setTitle("区域", for: .normal)
                        self?.houseAreaSelectBtn.isSelected = false
                    }else {
                        self?.houseAreaSelectBtn.setTitle("商圈", for: .normal)
                        self?.houseAreaSelectBtn.isSelected = true
                    }
                    
                }else if selectModel.areaModel.selectedCategoryID == "2" {
                    
                    if selectModel.areaModel.subwayModelCount.isFirstSelectedModel == nil {
                        self?.houseAreaSelectBtn.setTitle("区域", for: .normal)
                        self?.houseAreaSelectBtn.isSelected = false
                    }else {
                        self?.houseAreaSelectBtn.setTitle("地铁", for: .normal)
                        self?.houseAreaSelectBtn.isSelected = true
                    }
                    
                }else {
                    self?.houseAreaSelectBtn.setTitle("区域", for: .normal)
                    self?.houseAreaSelectBtn.isSelected = false
                }
                self?.selectModel = selectModel
                self?.setBtnUpOrDown(button: self?.houseAreaSelectBtn, isUp: false)
                
                //把筛选条件带到页面上去
                guard let blockk = self?.sureButtonButtonCallBack else {
                    return
                }
                blockk(self?.hiddenArea ?? false, self?.selectModel ?? selectModel)
        })
    }
    
    @objc func showHouseTypeSelectView() {
        setBtnUpOrDown(button: houseAreaSelectBtn, isUp: false)
        setBtnUpOrDown(button: houseTypeSelectBtn, isUp: true)
        setBtnUpOrDown(button: houseSortBtn, isUp: false)
        setBtnUpOrDown(button: houseShaixuanBtn, isUp: false)
        typeAndSortView.ShowHouseTypeView(style: HouseShaixuanStyle.HouseType, typeSelectEnum:self.selectModel?.typeModel.type ?? HouseTypeEnum.allEnum, datasource: [HouseTypeEnum.allEnum, HouseTypeEnum.officeBuildingEnum, HouseTypeEnum.jointOfficeEnum], clearButtonCallBack: { [weak self] in
            self?.setBtnUpOrDown(button: self?.houseTypeSelectBtn, isUp: false)
            }, sureHouseTypeButtonCallBack: { [weak self] (_ houseType: HouseTypeEnum) -> Void in
                self?.houseTypeSelectBtn.setTitle(houseType.rawValue, for: .normal)
                self?.houseTypeSelectBtn.isSelected = true
                self?.selectModel?.typeModel.type = houseType
                self?.setBtnUpOrDown(button: self?.houseTypeSelectBtn, isUp: false)
                self?.houseTypeSelectBtn.layoutButton(.imagePositionRight, space: 6)
                
                //把筛选条件带到页面上去
                guard let blockk = self?.sureButtonButtonCallBack else {
                    return
                }
                blockk(self?.hiddenArea ?? false, self?.selectModel ?? HouseSelectModel())
        })
    }
    
    @objc func showSortSelectView() {
        setBtnUpOrDown(button: houseAreaSelectBtn, isUp: false)
        setBtnUpOrDown(button: houseTypeSelectBtn, isUp: false)
        setBtnUpOrDown(button: houseSortBtn, isUp: true)
        setBtnUpOrDown(button: houseShaixuanBtn, isUp: false)
        typeAndSortView.ShowHouseSortView(style: HouseShaixuanStyle.HouseSort, sortSelectEnum:self.selectModel?.sortModel.type ?? HouseSortEnum.defaultSortEnum, datasource: [HouseSortEnum.defaultSortEnum, HouseSortEnum.priceTopToLowEnum, HouseSortEnum.priceLowToTopEnum, HouseSortEnum.squareTopToLowEnum, HouseSortEnum.squareLowToTopEnum], clearButtonCallBack: { [weak self] in
            self?.setBtnUpOrDown(button: self?.houseSortBtn, isUp: false)
            }, sureHouseSortButtonCallBack: { [weak self] (_ huseSortEnum: HouseSortEnum) -> Void in
                self?.selectModel?.sortModel.type = huseSortEnum
                self?.setBtnUpOrDown(button: self?.houseSortBtn, isUp: false)
                //把筛选条件带到页面上去
                guard let blockk = self?.sureButtonButtonCallBack else {
                    return
                }
                blockk(self?.hiddenArea ?? false, self?.selectModel ?? HouseSelectModel())
        })
    }
    
    @objc func showShaixuanSelectView() {
        setBtnUpOrDown(button: houseAreaSelectBtn, isUp: false)
        setBtnUpOrDown(button: houseTypeSelectBtn, isUp: false)
        setBtnUpOrDown(button: houseSortBtn, isUp: false)
        setBtnUpOrDown(button: houseShaixuanBtn, isUp: true)
        
        if selectModel?.shaixuanModel.featureModelArr.count ?? 0 > 0 {
            showShaixuan()
        }else {
            requestGetFeature()
        }
    }
    
    
    func showShaixuan() {
        shaixuanView = HouseShaixuanSelectView.init(frame: CGRect(x: 0.0, y: self.bottom, width: kWidth, height: kHeight - self.bottom))
        
        shaixuanView?.ShowHouseShaixuanView(issubView:false, model: self.selectModel ?? HouseSelectModel(), clearButtonCallBack: { [weak self] (_ selectModel: HouseSelectModel) -> Void in
                self?.selectModel = selectModel
                self?.setBtnUpOrDown(button: self?.houseShaixuanBtn, isUp: false)
                
                ///点击筛选后，更改类型的文字和颜色
                  self?.houseTypeSelectBtn.setTitle(self?.selectModel?.typeModel.type?.rawValue, for: .normal)
                  self?.houseTypeSelectBtn.isSelected = true
                  self?.houseTypeSelectBtn.layoutButton(.imagePositionRight, space: 6)
                
                //把筛选条件带到页面上去
                guard let blockk = self?.sureButtonButtonCallBack else {
                    return
                }
                blockk(self?.hiddenArea ?? false, self?.selectModel ?? selectModel)
        }, sureHouseShaixuanButtonCallBack: { [weak self] (_ selectModel: HouseSelectModel) -> Void in
                self?.selectModel = selectModel
                self?.setBtnUpOrDown(button: self?.houseShaixuanBtn, isUp: false)
                
                ///点击筛选后，更改类型的文字和颜色
                  self?.houseTypeSelectBtn.setTitle(self?.selectModel?.typeModel.type?.rawValue, for: .normal)
                  self?.houseTypeSelectBtn.isSelected = true
                  self?.houseTypeSelectBtn.layoutButton(.imagePositionRight, space: 6)
                
                //把筛选条件带到页面上去
                guard let blockk = self?.sureButtonButtonCallBack else {
                    return
                }
                blockk(self?.hiddenArea ?? false, self?.selectModel ?? selectModel)
        })
    }
}

extension HouseSelectBtnView {
    
    
    //MARK: 获取装修类型
    func requestGetDecorate() {
        
        SSNetworkTool.SSBasic.request_getDictionary(code: .codeEnumdecoratedType, success: { [weak self] (response) in
            guard let weakSelf = self else {return}
            if let decoratedArray = JSONDeserializer<HouseFeatureModel>.deserializeModelArrayFrom(json: JSON(response).rawString() ?? "", designatedPath: "data") {
                for model in decoratedArray {
                    weakSelf.selectModel?.shaixuanModel.documentTypeModelArr.append(model ?? HouseFeatureModel())
                    /*weakSelf.nearbySelectModel.shaixuanModel.documentTypeModelArr.append(model ?? HouseFeatureModel())*/
                }
            }
            
            weakSelf.showShaixuan()
            }, failure: {[weak self] (error) in
                guard let weakSelf = self else {return}
                weakSelf.showShaixuan()
        }) {[weak self] (code, message) in
            guard let weakSelf = self else {return}
            weakSelf.showShaixuan()
            //只有5000 提示给用户
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" {
                AppUtilities.makeToast(message)
            }
        }
    }
    
    //MARK: 获取特色接口
    func requestGetFeature() {
        
        SSNetworkTool.SSBasic.request_getDictionary(code: .codeEnumbranchUnique, success: { [weak self] (response) in
            guard let weakSelf = self else {return}
            if let decoratedArray = JSONDeserializer<HouseFeatureModel>.deserializeModelArrayFrom(json: JSON(response).rawString() ?? "", designatedPath: "data") {
                for model in decoratedArray {
                    weakSelf.selectModel?.shaixuanModel.featureModelArr.append(model ?? HouseFeatureModel())
                    /*weakSelf.nearbySelectModel.shaixuanModel.featureModelArr.append(model ?? HouseFeatureModel())*/
                }
            }
            weakSelf.requestGetDecorate()
            
            }, failure: {[weak self] (error) in
                self?.requestGetDecorate()
        }) {[weak self] (code, message) in
            self?.requestGetDecorate()
            
            //只有5000 提示给用户
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" {
                AppUtilities.makeToast(message)
            }
        }
    }
    
    
    //MARK: 获取商圈数据
    func request_getDistrict() {
        //查询类型，1：全部，0：系统已有楼盘的商圈
        var params = [String:AnyObject]()
        params["type"] = 1 as AnyObject?
        SSNetworkTool.SSBasic.request_getDistrictList(params: params, success: { [weak self] (response) in
            if let model = AreaCategorySelectModel.deserialize(from: response) {
                model.name = "商圈"
                self?.selectModel?.areaModel.areaModelCount = model
            }
            self?.request_getSubwaylist()
            }, failure: { [weak self] (error) in
                self?.request_getSubwaylist()
        }) { [weak self] (code, message) in
            
            self?.request_getSubwaylist()
            //只有5000 提示给用户
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" {
                AppUtilities.makeToast(message)
            }
        }
    }
    
    //MARK: 获取地铁数据
    func request_getSubwaylist() {
        //查询类型，1：全部，0：系统已有楼盘的商圈
        var params = [String:AnyObject]()
        params["type"] = 1 as AnyObject?
        SSNetworkTool.SSBasic.request_getSubwayList(params: params, success: { [weak self] (response) in
            if let model = SubwayCategorySelectModel.deserialize(from: response) {
                model.name = "地铁"
                self?.selectModel?.areaModel.subwayModelCount = model
                self?.showArea(isFrist: false)
            }
            
            }, failure: {[weak self] (error) in
                self?.showArea(isFrist: false)
        }) {[weak self] (code, message) in
            self?.showArea(isFrist: false)
            //只有5000 提示给用户
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" {
                AppUtilities.makeToast(message)
            }
        }
    }
}

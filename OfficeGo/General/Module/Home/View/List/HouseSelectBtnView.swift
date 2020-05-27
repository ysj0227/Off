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

enum HouseTypeEnum: String {
    case allEnum = "所有"
    case officeBuildingEnum = "办公楼"
    case jointOfficeEnum = "联合办公"
}

enum HouseSortEnum: String {    
    case defaultSortEnum = "默认排序"
    case priceTopToLowEnum = "价格从高到低"
    case priceLowToTopEnum = "价格从低到高"
    case squareTopToLowEnum = "面积从大到小"
    case squareLowToTopEnum = "面积从小到大"
}


enum AreaCatogoryItem: String {
    case fujinCatogoryEnum = "附近"
    case mallsCatogoryEnum = "商圈"
    case subwaysCatogoryEnum = "地铁"
}

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
        button.addTarget(self, action: #selector(showAreaSelectView), for: .touchUpInside)
        return button
    }()
    
    var houseTypeSelectBtn: UIButton = {
        let button = UIButton.init()
        button.setTitle("类型", for: .normal)
        button.setImage(UIImage(named: "downIcon"), for: .normal)
        button.setTitleColor(kAppColor_666666, for: .normal)
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
        areaView.ShowAreaaddressView(model: self.selectModel ?? HouseSelectModel(), clearButtonCallBack: { [weak self] in
            self?.setBtnUpOrDown(button: self?.houseAreaSelectBtn, isUp: false)
            
            self?.houseAreaSelectBtn.setTitle("商圈", for: .normal)
            self?.houseAreaSelectBtn.layoutButton(.imagePositionRight, space: 6)
            }, sureAreaaddressButtonCallBack: { [weak self] (_ selectModel: HouseSelectModel) -> Void in
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
        typeAndSortView.ShowHouseTypeView(style: HouseShaixuanStyle.HouseType, datasource: [HouseTypeEnum.allEnum, HouseTypeEnum.officeBuildingEnum, HouseTypeEnum.jointOfficeEnum], clearButtonCallBack: { [weak self] in
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
        typeAndSortView.ShowHouseSortView(style: HouseShaixuanStyle.HouseSort, datasource: [HouseSortEnum.defaultSortEnum, HouseSortEnum.priceTopToLowEnum, HouseSortEnum.priceLowToTopEnum, HouseSortEnum.squareTopToLowEnum, HouseSortEnum.squareLowToTopEnum], clearButtonCallBack: { [weak self] in
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
        shaixuanView = HouseShaixuanSelectView.init(frame: CGRect(x: 0.0, y: self.bottom, width: kWidth, height: kHeight - self.bottom))
        
        shaixuanView?.ShowHouseShaixuanView(issubView:false, model: self.selectModel ?? HouseSelectModel(), clearButtonCallBack: { [weak self] in
            self?.setBtnUpOrDown(button: self?.houseShaixuanBtn, isUp: false)
            }, sureHouseShaixuanButtonCallBack: { [weak self] (_ selectModel: HouseSelectModel) -> Void in
                self?.selectModel = selectModel
                self?.setBtnUpOrDown(button: self?.houseShaixuanBtn, isUp: false)
                //把筛选条件带到页面上去
                guard let blockk = self?.sureButtonButtonCallBack else {
                    return
                }
                blockk(self?.hiddenArea ?? false, self?.selectModel ?? selectModel)
        })
    }
    
}

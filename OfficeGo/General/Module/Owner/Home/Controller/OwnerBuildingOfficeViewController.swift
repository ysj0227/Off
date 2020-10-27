//
//  OwnerBuildingOfficeViewController.swift
//  OfficeGo
//
//  Created by Mac pro on 2020/10/16.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit
import HandyJSON
import SwiftyJSON

class OwnerBuildingOfficeViewController: BaseTableViewController {
    
    ///来自编辑还是添加
    var isFromAdd: Bool?
    
    ///弹出来的总价框
    var totalPriceView: UIButton = {
        let view = UIButton()
        view.backgroundColor = kAppLightBlueColor
        view.clipsToBounds = true
        view.titleLabel?.font = FONT_MEDIUM_12
        view.setTitleColor(kAppBlueColor, for: .normal)
        view.layer.cornerRadius = button_cordious_2
        view.addTarget(self, action: #selector(totalPriceClick), for: .touchUpInside)
        return view
    }()
    
    ///选择弹框
    lazy var ownerFYMoreSettingView: OwnerFYMoreSettingView = {
        let view = OwnerFYMoreSettingView.init(frame: CGRect(x: 0.0, y: 0, width: kWidth, height: kHeight))
        view.titleString = "请选择"
        return view
    }()
    
    //记录是否已经点了关闭pc按钮
    var isClose: Bool?
    
    ///类型数据源
    var typeSourceArray:[OwnerBuildingOfficeConfigureModel] = [OwnerBuildingOfficeConfigureModel]()
    
    ///
    var buildingModel: FangYuanBuildingEditDetailModel?
    
    lazy var saveBtn: UIButton = {
        let button = UIButton.init()
        button.clipsToBounds = true
        button.layer.cornerRadius = button_cordious_2
        button.backgroundColor = kAppBlueColor
        button.titleLabel?.font = FONT_MEDIUM_16
        button.setTitleColor(kAppWhiteColor, for: .normal)
        button.setTitle("下一步", for: .normal)
        button.addTarget(self, action: #selector(saveClick), for: .touchUpInside)
        return button
    }()
    
    lazy var pcEditBtn: UIButton = {
        let button = UIButton.init()
        button.clipsToBounds = true
        button.layer.cornerRadius = button_cordious_2
        button.layer.borderColor = kAppBlueColor.cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = kAppWhiteColor
        button.titleLabel?.font = FONT_MEDIUM_16
        button.setTitleColor(kAppBlueColor, for: .normal)
        button.setTitle("在电脑上编辑", for: .normal)
        button.addTarget(self, action: #selector(pcEditClick), for: .touchUpInside)
        return button
    }()
    
    lazy var closePcEditBtn: UIButton = {
        let button = UIButton.init()
        button.setImage(UIImage.init(named: "closeBlue"), for: .normal)
        button.addTarget(self, action: #selector(closePcEditClick), for: .touchUpInside)
        return button
    }()
    
    @objc func totalPriceClick() {
        
        buildingModel?.totalPrice = buildingModel?.totalPriceTemp
        
        //        endEdting()
        
        totalPriceView.setTitle("", for: .normal)
        
        totalPriceView.snp.remakeConstraints({ (make) in
            make.size.equalTo(0)
            make.leading.equalToSuperview().offset(90)
        })
        
        loadSecion(section: 4)
    }
    
    @objc func saveClick() {
        let vc = OwnerBuildingCreateVideoVRViewController()
        vc.isClose = isClose
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func pcEditClick() {
        clickToQCode()
    }
    
    @objc func closePcEditClick() {
        isClose = true
        pcEditBtn.snp.remakeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(left_pending_space_17)
            make.bottom.equalToSuperview().offset(-(bottomMargin()))
            make.height.equalTo(0)
        }
        closePcEditBtn.isHidden = true
    }
    ///跳转二维码页面页面
    func clickToQCode() {
        //设置扫码区域参数
        var style = LBXScanViewStyle()
        style.centerUpOffset = 44
        style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle.Inner
        style.photoframeLineW = 2
        style.photoframeAngleW = 18
        style.photoframeAngleH = 18
        style.isNeedShowRetangle = false
        
        style.anmiationStyle = LBXScanViewAnimationStyle.LineMove
        
        style.colorAngle = UIColor(red: 0.0/255, green: 200.0/255.0, blue: 20.0/255.0, alpha: 1.0)
        
        style.animationImage = UIImage(named: "CodeScan.bundle/qrcode_Scan_weixin_Line")
        
        
        let vc = LBXScanViewController()
        vc.scanStyle = style
        vc.isOpenInterestRect = true
        let nav = BaseNavigationViewController.init(rootViewController: vc)
        nav.modalPresentationStyle = .overFullScreen
        //TODO: 这块弹出要设置
        self.present(nav, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpData()
        
        setUpView()
    }
    
    func setUpData() {
        
        ///标题
        typeSourceArray.append(OwnerBuildingOfficeConfigureModel.init(types: .OwnerBuildingOfficeTypeName))
        
        ///面积 *
        typeSourceArray.append(OwnerBuildingOfficeConfigureModel.init(types: .OwnerBuildingOfficeTypeArea))
        
        ///可置工位 *
        typeSourceArray.append(OwnerBuildingOfficeConfigureModel.init(types: .OwnerBuildingOfficeTypeSeats))
        
        ///租金单价 *
        typeSourceArray.append(OwnerBuildingOfficeConfigureModel.init(types: .OwnerBuildingOfficeTypePrice))
        
        ///租金总价 *
        typeSourceArray.append(OwnerBuildingOfficeConfigureModel.init(types: .OwnerBuildingOfficeTypeTotalPrice))
        
        ///所在楼层 *
        typeSourceArray.append(OwnerBuildingOfficeConfigureModel.init(types: .OwnerBuildingOfficeTypeTotalFloor))
        
        ///净高 *
        typeSourceArray.append(OwnerBuildingOfficeConfigureModel.init(types: .OwnerBuildingOfficeTypeClearHeight))
        
        ///层高
        typeSourceArray.append(OwnerBuildingOfficeConfigureModel.init(types: .OwnerBuildingOfficeTypeFloorHeight))
        
        ///最短租期 *
        typeSourceArray.append(OwnerBuildingOfficeConfigureModel.init(types: .OwnerBuildingOfficeTypeMinRentalPeriod))
        
        ///免租期 *
        typeSourceArray.append(OwnerBuildingOfficeConfigureModel.init(types: .OwnerBuildingOfficeTypeRentFreePeriod))
        
        ///物业费 *
        typeSourceArray.append(OwnerBuildingOfficeConfigureModel.init(types: .OwnerBuildingOfficeTypePropertyCoast))
        
        ///装修程度 *
        typeSourceArray.append(OwnerBuildingOfficeConfigureModel.init(types: .OwnerBuildingOfficeTypeDocument))
        
        ///户型格局简介
        typeSourceArray.append(OwnerBuildingOfficeConfigureModel.init(types: .OwnerBuildingOfficeTypeIntrodution))
        
        ///办公室特色
        typeSourceArray.append(OwnerBuildingOfficeConfigureModel.init(types: .OwnerBuildingOfficeTypeFeature))
        
        ///上传办公室图片 *
        typeSourceArray.append(OwnerBuildingOfficeConfigureModel.init(types: .OwnerBuildingOfficeTypeBuildingImage))
        
        
        if buildingModel != nil {
            
        }else {
            buildingModel = FangYuanBuildingEditDetailModel()
        }
        
        requestGetDecorate()
    }
    
    
    //MARK: 获取装修类型接口
    func requestGetDecorate() {
        
        SSNetworkTool.SSBasic.request_getDictionary(code: .codeEnumdecoratedType, success: { [weak self] (response) in
            guard let weakSelf = self else {return}
            if let decoratedArray = JSONDeserializer<HouseFeatureModel>.deserializeModelArrayFrom(json: JSON(response).rawString() ?? "", designatedPath: "data") {
                for model in decoratedArray {
                    weakSelf.buildingModel?.decoratesLocal.append(model ?? HouseFeatureModel())
                }
            }
            weakSelf.requestGetFeature()
            
            }, failure: {[weak self] (error) in
                self?.requestGetFeature()
                
        }) {[weak self] (code, message) in
            self?.requestGetFeature()
            
            //只有5000 提示给用户
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" {
                AppUtilities.makeToast(message)
            }
        }
    }
    
    //MARK: 获取特色接口
    func requestGetFeature() {
        
        SSNetworkTool.SSBasic.request_getDictionary(code: .codeEnumhouseUnique, success: { [weak self] (response) in
            guard let weakSelf = self else {return}
            if let decoratedArray = JSONDeserializer<HouseFeatureModel>.deserializeModelArrayFrom(json: JSON(response).rawString() ?? "", designatedPath: "data") {
                for model in decoratedArray {
                    weakSelf.buildingModel?.tagsLocal.append(model ?? HouseFeatureModel())
                }
            }
            weakSelf.loadTableview()
            
            }, failure: {[weak self] (error) in
                self?.loadTableview()
                
        }) {[weak self] (code, message) in
            self?.loadTableview()
            
            //只有5000 提示给用户
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" {
                AppUtilities.makeToast(message)
            }
        }
    }
    
    
    ///点击问好弹出的弹框
    func showLeaveAlert(index: Int) {
        let alert = SureAlertView(frame: self.view.frame)
        alert.isHiddenVersionCancel = true
        alert.bottomBtnView.rightSelectBtn.setTitle("我知道了", for: .normal)
        if index == 1 {
            alert.ShowAlertView(withalertType: AlertType.AlertTypeMessageAlert, title: "\n 可置工位根据面积生成，可修改 \n", descMsg: "", cancelButtonCallClick: {
                
            }) {
                
            }
        }else {
            alert.ShowAlertView(withalertType: AlertType.AlertTypeMessageAlert, title: "\n 总价根据单价生成，可修改", descMsg: "总价计算规则：单价X面积X天数 \n 总价：0.3万元/月（1元 X 100㎡ X 30天）", cancelButtonCallClick: {
                
            }) {
                
            }
        }
        
    }
}

extension OwnerBuildingOfficeViewController {
    
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
        
        titleview?.leftButton.setImage(UIImage.init(named: "backWhite"), for: .normal)
        //        titleview?.rightButton.setImage(UIImage.init(named: "scanIcon"), for: .normal)
        titleview?.leftButton.isHidden = false
        titleview?.rightButton.isHidden = true
        if isFromAdd == true {
            titleview?.titleLabel.text = "添加办公室"
        }else {
            titleview?.titleLabel.text = "编辑办公室"
        }
        titleview?.leftButtonCallBack = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        titleview?.rightBtnClickBlock = { [weak self] in
            let vc = OwnerBuildingOfficeViewController()
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        self.view.addSubview(titleview ?? ThorNavigationView.init(type: .backTitleRight))
        
        
        self.view.addSubview(pcEditBtn)
        self.view.addSubview(closePcEditBtn)
        self.view.addSubview(saveBtn)
        
        pcEditBtn.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(left_pending_space_17)
            make.bottom.equalToSuperview().offset(-(bottomMargin() + 20))
            make.height.equalTo(40)
        }
        closePcEditBtn.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview()
            make.bottom.equalTo(pcEditBtn.snp.top).offset(20)
            make.size.equalTo(40)
        }
        saveBtn.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(left_pending_space_17)
            make.bottom.equalTo(pcEditBtn.snp.top).offset(-20)
            make.height.equalTo(40)
        }
        self.tableView.snp.remakeConstraints { (make) in
            make.top.equalTo(kNavigationHeight)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(saveBtn.snp.top)
        }
        
        self.view.addSubview(totalPriceView)
        
        
        
        requestSet()
    }
    
    func requestSet() {
        
        isShowRefreshHeader = true
        
        ///选择cell
        ///免租期
        ///所在楼层
        self.tableView.register(OwnerBuildingClickCell.self, forCellReuseIdentifier: OwnerBuildingClickCell.reuseIdentifierStr)
        
        ///所在楼层
        self.tableView.register(OwnerBuildingFYFloorCell.self, forCellReuseIdentifier: OwnerBuildingFYFloorCell.reuseIdentifierStr)
        
        ///文本输入cell
        ///标题
        self.tableView.register(OwnerBuildingInputCell.self, forCellReuseIdentifier: OwnerBuildingInputCell.reuseIdentifierStr)
        
        ///正数字文本输入cell
        ///最短租期
        self.tableView.register(OwnerBuildingNumInputCell.self, forCellReuseIdentifier: OwnerBuildingNumInputCell.reuseIdentifierStr)
        
        ///数字 - 一位小数点文本输入cell
        ///建筑面积 - 两位
        ///净高
        ///层高
        ///物业费
        ///租金单价 - 两位
        self.tableView.register(OwnerBuildingDecimalNumInputCell.self, forCellReuseIdentifier: OwnerBuildingDecimalNumInputCell.reuseIdentifierStr)
        
        ///租金总价 - 两位
        self.tableView.register(OwnerBuildingFYRenterTotalPriceCell.self, forCellReuseIdentifier: OwnerBuildingFYRenterTotalPriceCell.reuseIdentifierStr)
        
        
        ///可置工位
        self.tableView.register(OwnerBuildingFYCanSeatsCell.self, forCellReuseIdentifier: OwnerBuildingFYCanSeatsCell.reuseIdentifierStr)
        
        ///装修程度
        ///特色
        self.tableView.register(OwnerBuildingNetworkSelectCell.self, forCellReuseIdentifier: OwnerBuildingNetworkSelectCell.reuseIdentifierStr)
        
        ///户型格局简介
        self.tableView.register(OwnerBuildingFYIntroductionCell.self, forCellReuseIdentifier: OwnerBuildingFYIntroductionCell.reuseIdentifierStr)
        
        ///图片选择
        self.tableView.register(OwnerBuildingImgCell.self, forCellReuseIdentifier: OwnerBuildingImgCell.reuseIdentifierStr)
        
        refreshData()
        
    }
    
    func loadSecion(section: Int) {
        tableView.reloadSections(NSIndexSet.init(index: section) as IndexSet, with: UITableView.RowAnimation.none)
    }
    
    func loadSections(indexSet: IndexSet) {
        tableView.reloadSections(NSIndexSet.init(indexSet: indexSet) as IndexSet, with: UITableView.RowAnimation.none)
    }
}

extension OwnerBuildingOfficeViewController {
    
    func loadTableview() {
        tableView.reloadData()
    }
}

extension OwnerBuildingOfficeViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return typeSourceArray.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        ///所在楼层
        if typeSourceArray[section].type == .OwnerBuildingOfficeTypeTotalFloor {
            return 2
        }else {
            return 1
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model:OwnerBuildingOfficeConfigureModel = typeSourceArray[indexPath.section]
        
        switch model.type {
            ///选择cell
            
        case .OwnerBuildingOfficeTypeRentFreePeriod:
            
            ///免租期
            let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingClickCell.reuseIdentifierStr) as? OwnerBuildingClickCell
            cell?.selectionStyle = .none
            cell?.buildingModel = buildingModel ?? FangYuanBuildingEditDetailModel()
            cell?.officeModel = model
            return cell ?? OwnerBuildingClickCell.init(frame: .zero)
            
        ///所在楼层
        case .OwnerBuildingOfficeTypeTotalFloor:
            if indexPath.row == 0 {
                ///点击cell
                let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingClickCell.reuseIdentifierStr) as? OwnerBuildingClickCell
                cell?.selectionStyle = .none
                cell?.buildingModel = buildingModel ?? FangYuanBuildingEditDetailModel()
                cell?.officeModel = model
                return cell ?? OwnerBuildingClickCell.init(frame: .zero)
            }else {
                
                ///文本输入cell
                let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingFYFloorCell.reuseIdentifierStr) as? OwnerBuildingFYFloorCell
                cell?.selectionStyle = .none
                cell?.buildingModel = buildingModel ?? FangYuanBuildingEditDetailModel()
                cell?.officeModel = model
                return cell ?? OwnerBuildingFYFloorCell.init(frame: .zero)
                
            }
            
            
            
            ///文本输入cell
        ///标题
        case .OwnerBuildingOfficeTypeName:
            
            ///文本输入cell
            let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingInputCell.reuseIdentifierStr) as? OwnerBuildingInputCell
            cell?.selectionStyle = .none
            cell?.buildingModel = buildingModel ?? FangYuanBuildingEditDetailModel()
            cell?.officeModel = model
            return cell ?? OwnerBuildingInputCell.init(frame: .zero)
            
            
            
            ///正数字文本输入cell
        ///最短租期
        case .OwnerBuildingOfficeTypeMinRentalPeriod:
            
            ///数字文本输入cell
            let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingNumInputCell.reuseIdentifierStr) as? OwnerBuildingNumInputCell
            cell?.selectionStyle = .none
            cell?.buildingModel = buildingModel ?? FangYuanBuildingEditDetailModel()
            cell?.officeModel = model
            return cell ?? OwnerBuildingNumInputCell.init(frame: .zero)
            
            
            ///数字 - 一位小数点文本输入cell
            ///建筑面积 - 两位
            ///净高
            ///层高
            ///物业费
        ///租金单价 - 两位
        case .OwnerBuildingOfficeTypeArea, .OwnerBuildingOfficeTypeClearHeight, .OwnerBuildingOfficeTypeFloorHeight, .OwnerBuildingOfficeTypePropertyCoast, .OwnerBuildingOfficeTypePrice:
            
            ///数字文本输入cell
            let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingDecimalNumInputCell.reuseIdentifierStr) as? OwnerBuildingDecimalNumInputCell
            cell?.selectionStyle = .none
            cell?.buildingModel = buildingModel ?? FangYuanBuildingEditDetailModel()
            cell?.officeModel = model
            cell?.endEditingMessageCell = { [weak self] (model) in
                self?.buildingModel = model
                self?.loadSections(indexSet: [indexPath.section, indexPath.section + 1])
            }
            return cell ?? OwnerBuildingDecimalNumInputCell.init(frame: .zero)
            
            
        ///租金总价 - 两位
        case .OwnerBuildingOfficeTypeTotalPrice:
            
            ///数字文本输入cell
            let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingFYRenterTotalPriceCell.reuseIdentifierStr) as? OwnerBuildingFYRenterTotalPriceCell
            cell?.selectionStyle = .none
            cell?.buildingModel = buildingModel ?? FangYuanBuildingEditDetailModel()
            cell?.officeModel = model
            cell?.endEditingMessageCell = { [weak self] (buildingModel) in
                self?.buildingModel = buildingModel
                self?.totalPriceView.setTitle("", for: .normal)
                self?.totalPriceView.snp.remakeConstraints({ (make) in
                    make.size.equalTo(0)
                    make.leading.equalToSuperview().offset(90)
                })
                self?.loadSecion(section: indexPath.section)
            }
            cell?.alertBtnClickClouse = { [weak self] in
                self?.showLeaveAlert(index: 2)
            }
            cell?.inputClickClouse = { [weak self] in
                
                if let dayPrice = self?.buildingModel?.dayPrice, let areaOffice = self?.buildingModel?.areaOffice {
                    if dayPrice.isBlankString != true && areaOffice.isBlankString != true {
                        
                        ///单价 x 面积 x 30
                        let price = (Double(dayPrice) ?? 0) * (Double(areaOffice) ?? 0) * 30
                        self?.buildingModel?.totalPriceTemp = "\(price)"
                        self?.totalPriceView.setTitle(" 租金总价：\(price)元/月 ", for: .normal)
                        
                        let rect = self?.tableView.rectForRow(at: IndexPath.init(row: indexPath.row, section: indexPath.section))
                        
                        let cellRect = self?.tableView.convert(rect ?? CGRect.zero, to: self?.view)
                        
                        let y = CGFloat(cellRect?.minY ?? 0)
                        SSLog("companyNamerect-\(rect ?? CGRect.zero)------cellRect\(cellRect ?? CGRect.zero)")
                        
                        self?.totalPriceView.snp.remakeConstraints({ (make) in
                            make.top.equalTo(y - 23)
                            make.leading.equalToSuperview().offset(90)
                        })
                    }
                }
                
                /*
                 ///只有没有点击过的时候，点击才弹出值 - 用totalPriceTemp控制
                 if self?.buildingModel?.totalPrice != nil && self?.buildingModel?.totalPrice?.isBlankString != true {
                 
                 }else {
                 
                 
                 }*/
                
            }
            return cell ?? OwnerBuildingFYRenterTotalPriceCell.init(frame: .zero)
            
            
        ///可置工位
        case .OwnerBuildingOfficeTypeSeats:
            ///数字文本输入cell
            let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingFYCanSeatsCell.reuseIdentifierStr) as? OwnerBuildingFYCanSeatsCell
            cell?.selectionStyle = .none
            cell?.buildingModel = buildingModel ?? FangYuanBuildingEditDetailModel()
            cell?.officeModel = model
            cell?.endEditingMessageCell = { [weak self] (buildingModel) in
                self?.buildingModel = buildingModel
            }
            cell?.alertBtnClickClouse = { [weak self] in
                self?.showLeaveAlert(index: 1)
            }
            return cell ?? OwnerBuildingFYCanSeatsCell.init(frame: .zero)
            
        ///装修程度
        case .OwnerBuildingOfficeTypeDocument:
            let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingNetworkSelectCell.reuseIdentifierStr) as? OwnerBuildingNetworkSelectCell
            cell?.selectionStyle = .none
            cell?.categoryTitleLabel.attributedText = model.getNameFormType(type: model.type ?? OwnerBuildingOfficeType.OwnerBuildingOfficeTypeDocument)
            cell?.isMutTags = false
            cell?.isMutNetworks = false
            cell?.isSimpleDocument = true
            cell?.buildingModel = self.buildingModel ?? FangYuanBuildingEditDetailModel()
            return cell ?? OwnerBuildingNetworkSelectCell.init(frame: .zero)
            
        ///户型格局简介
        case .OwnerBuildingOfficeTypeIntrodution:
            let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingFYIntroductionCell.reuseIdentifierStr) as? OwnerBuildingFYIntroductionCell
            cell?.selectionStyle = .none
            cell?.buildingModel = self.buildingModel ?? FangYuanBuildingEditDetailModel()
            return cell ?? OwnerBuildingFYIntroductionCell.init(frame: .zero)
            
        ///特色
        case .OwnerBuildingOfficeTypeFeature:
            let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingNetworkSelectCell.reuseIdentifierStr) as? OwnerBuildingNetworkSelectCell
            cell?.selectionStyle = .none
            cell?.categoryTitleLabel.attributedText = model.getNameFormType(type: model.type ?? OwnerBuildingOfficeType.OwnerBuildingOfficeTypeFeature)
            cell?.isMutTags = true
            cell?.isMutNetworks = false
            cell?.isSimpleDocument = false
            cell?.buildingModel = self.buildingModel ?? FangYuanBuildingEditDetailModel()
            return cell ?? OwnerBuildingNetworkSelectCell.init(frame: .zero)
            
        ///上传楼盘图片
        case .OwnerBuildingOfficeTypeBuildingImage:
            let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingImgCell.reuseIdentifierStr) as? OwnerBuildingImgCell
            cell?.selectionStyle = .none
            cell?.officeModel = model
            cell?.buildingModel = self.buildingModel ?? FangYuanBuildingEditDetailModel()
            return cell ?? OwnerBuildingImgCell.init(frame: .zero)
            
        ///上传楼盘视频
        case .OwnerBuildingOfficeTypeBuildingVideo:
            return UITableViewCell.init(frame: .zero)
            
        ///上传楼盘vr
        case .OwnerBuildingOfficeTypeBuildingVR:
            return UITableViewCell.init(frame: .zero)
            
        case .none:
            return UITableViewCell.init(frame: .zero)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch typeSourceArray[indexPath.section].type {
        ///选择cell
        case .OwnerBuildingOfficeTypeRentFreePeriod:
            ///免租期
            return BaseEditCell.rowHeight()
            
        ///所在楼层
        case .OwnerBuildingOfficeTypeTotalFloor:
            if indexPath.row == 0 {
                return BaseEditCell.rowHeight()
            }else {
                if buildingModel?.floorType == "1" || buildingModel?.floorType == "2" {
                    return OwnerBuildingFYFloorCell.rowHeight()
                }else {
                    return 0
                }
            }
            
            
            ///文本输入cell
        ///标题
        case .OwnerBuildingOfficeTypeName:
            
            return BaseEditCell.rowHeight()
            
            ///正数字文本输入cell
        ///最短租期
        case .OwnerBuildingOfficeTypeMinRentalPeriod:
            
            return BaseEditCell.rowHeight()
            
            
            ///数字 - 一位小数点文本输入cell
            ///建筑面积 - 两位
            ///净高
            ///层高
            ///物业费
        ///租金单价 - 两位
        case .OwnerBuildingOfficeTypeArea, .OwnerBuildingOfficeTypeClearHeight, .OwnerBuildingOfficeTypeFloorHeight, .OwnerBuildingOfficeTypePropertyCoast, .OwnerBuildingOfficeTypePrice:
            
            return BaseEditCell.rowHeight()
            
        ///租金总价 - 两位
        case  .OwnerBuildingOfficeTypeTotalPrice:
            
            return BaseEditCell.rowHeight()
            
        ///可置工位
        case .OwnerBuildingOfficeTypeSeats:
            
            return BaseEditCell.rowHeight()
            
        ///装修程度
        case .OwnerBuildingOfficeTypeDocument:
            if let arr = buildingModel?.decoratesLocal {
                let count = ((arr.count  + 2) / 3)
                
                return CGFloat(count * 50 + 59 + 5)
            }else {
                return 59 + 5
            }
            
            
        ///户型格局简介
        case .OwnerBuildingOfficeTypeIntrodution:
            return OwnerBuildingFYIntroductionCell.rowHeight()
            
            
        ///特色
        case .OwnerBuildingOfficeTypeFeature:
            if let arr = buildingModel?.tagsLocal {
                let count = ((arr.count  + 2) / 3)
                
                return CGFloat(count * 50 + 59 + 5)
            }else {
                return 59 + 5
            }
            
        ///上传楼盘图片
        case .OwnerBuildingOfficeTypeBuildingImage:
            return ((kWidth - left_pending_space_17 * 2 - 5 * 2) / 3.0 + 10) * 4 + 68
            
        ///上传楼盘视频
        case .OwnerBuildingOfficeTypeBuildingVideo:
            return BaseEditCell.rowHeight()
            
        ///上传楼盘vr
        case .OwnerBuildingOfficeTypeBuildingVR:
            return BaseEditCell.rowHeight()
            
        case .none:
            return BaseEditCell.rowHeight()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.typeSourceArray.count <= 0 {
            return
        }
        switch typeSourceArray[indexPath.section].type {
        ///免租期
        case .OwnerBuildingOfficeTypeRentFreePeriod:
            
            SSLog(typeSourceArray[indexPath.section].type)
            
            endEdting()
            
            ownerFYMoreSettingView.ShowOwnerSettingView(datasource: [OwnerRentFreePeriodType.OwnerRentFreePeriodTypeDefault.rawValue,
                                                                           OwnerRentFreePeriodType.OwnerRentFreePeriodTypeMonth1.rawValue,
                                                                           OwnerRentFreePeriodType.OwnerRentFreePeriodTypeMonth2.rawValue,
                                                                           OwnerRentFreePeriodType.OwnerRentFreePeriodTypeMonth3.rawValue,
                                                                           OwnerRentFreePeriodType.OwnerRentFreePeriodTypeMonth4.rawValue,
                                                                           OwnerRentFreePeriodType.OwnerRentFreePeriodTypeMonth5.rawValue,
                                                                           OwnerRentFreePeriodType.OwnerRentFreePeriodTypeMonth6.rawValue,
                                                                           OwnerRentFreePeriodType.OwnerRentFreePeriodTypeMonth7.rawValue,
                                                                           OwnerRentFreePeriodType.OwnerRentFreePeriodTypeMonth8.rawValue,
                                                                           OwnerRentFreePeriodType.OwnerRentFreePeriodTypeMonth9.rawValue,
                                                                           OwnerRentFreePeriodType.OwnerRentFreePeriodTypeMonth10.rawValue,
                                                                           OwnerRentFreePeriodType.OwnerRentFreePeriodTypeMonth11.rawValue,
                                                                           OwnerRentFreePeriodType.OwnerRentFreePeriodTypeMonth12.rawValue], clearButtonCallBack: {
                                                                            
            }) {[weak self] (settingEnumIndex) in
                //单层1 多层2
                self?.loadSections(indexSet: [indexPath.section])
            }
            
        ///所在楼层
        case .OwnerBuildingOfficeTypeTotalFloor:
            
            if indexPath.row == 0 {
                
                endEdting()
                
                ownerFYMoreSettingView.ShowOwnerSettingView(datasource: [OwnerBuildingTotalFloorType.OwnerBuildingTotalFloorTypeOne.rawValue, OwnerBuildingTotalFloorType.OwnerBuildingTotalFloorTypeMore.rawValue], clearButtonCallBack: {
                    
                }) {[weak self] (settingEnumIndex) in
                    //单层1 多层2
                    if settingEnumIndex == 0 {
                        self?.buildingModel?.floorType = "1"
                    }else if settingEnumIndex == 1 {
                        self?.buildingModel?.floorType = "2"
                    }
                    self?.loadSections(indexSet: [indexPath.section])
                }
                
            }
            
            
            ///文本输入cell
        ///标题
        case .OwnerBuildingOfficeTypeName:
            
            SSLog(typeSourceArray[indexPath.section].type)
            
            ///正数字文本输入cell
        ///最短租期
        case .OwnerBuildingOfficeTypeMinRentalPeriod:
            
            SSLog(typeSourceArray[indexPath.section].type)
            
            
            ///数字 - 一位小数点文本输入cell
            ///建筑面积 - 两位
            ///净高
            ///层高
            ///物业费
            ///租金单价 - 两位
        ///租金总价 - 两位
        case .OwnerBuildingOfficeTypeArea, .OwnerBuildingOfficeTypeClearHeight, .OwnerBuildingOfficeTypeFloorHeight, .OwnerBuildingOfficeTypePropertyCoast, .OwnerBuildingOfficeTypePrice, .OwnerBuildingOfficeTypeTotalPrice:
            
            SSLog(typeSourceArray[indexPath.section].type)
            
        ///可置工位
        case .OwnerBuildingOfficeTypeSeats:
            
            SSLog(typeSourceArray[indexPath.section].type)
            
        ///装修程度
        case .OwnerBuildingOfficeTypeDocument:
            
            SSLog(typeSourceArray[indexPath.section].type)
            
        ///户型格局简介
        case .OwnerBuildingOfficeTypeIntrodution:
            
            SSLog(typeSourceArray[indexPath.section].type)
            
        ///特色
        case .OwnerBuildingOfficeTypeFeature:
            
            SSLog(typeSourceArray[indexPath.section].type)
            
        ///上传楼盘图片
        case .OwnerBuildingOfficeTypeBuildingImage:
            
            SSLog(typeSourceArray[indexPath.section].type)
            
        ///上传楼盘视频
        case .OwnerBuildingOfficeTypeBuildingVideo:
            SSLog(typeSourceArray[indexPath.section].type)
            
        ///上传楼盘vr
        case .OwnerBuildingOfficeTypeBuildingVR:
            
            SSLog(typeSourceArray[indexPath.section].type)
            
        case .none:
            
            SSLog(typeSourceArray[indexPath.section].type)
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




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
    
    var areaModelCount: CityAreaCategorySelectModel?
    
    ///地址区域
    lazy var areaView: CityDistrictAddressSelectView = {
        let view = CityDistrictAddressSelectView.init(frame: CGRect(x: 0.0, y: 0, width: kWidth, height: kHeight))
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
    
    ///入住公司数组
    var companyArr: [String] = [""]
    
    ///
    var buildingModel: FangYuanBuildingEditDetailModel?
    
    ///网络
    var networkModelArr = [HouseFeatureModel]()
    
    // 房源特色数据
    var featureModelArr = [HouseFeatureModel]()
    
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
        
        let model1 = HouseFeatureModel()
        model1.dictCname = "电信"
        buildingModel?.internetLocal.append(model1)
        
        let model2 = HouseFeatureModel()
        model2.dictCname = "联通"
        buildingModel?.internetLocal.append(model2)
        
        let model3 = HouseFeatureModel()
        model3.dictCname = "移动"
        buildingModel?.internetLocal.append(model3)
        
        requestGetFeature()
        
    }
    
    //MARK: 获取特色接口
    func requestGetFeature() {
        
        SSNetworkTool.SSBasic.request_getDictionary(code: .codeEnumbranchUnique, success: { [weak self] (response) in
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
        titleview?.titleLabel.text = "添加办公室"
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
        requestSet()
    }
    
    func requestSet() {
        
        isShowRefreshHeader = true
        
        ///选择cell
        ///免租期
        ///所在楼层
        self.tableView.register(OwnerBuildingClickCell.self, forCellReuseIdentifier: OwnerBuildingClickCell.reuseIdentifierStr)
        
        ///所在楼层
        self.tableView.register(OwnerBuildingFloorCell.self, forCellReuseIdentifier: OwnerBuildingFloorCell.reuseIdentifierStr)
        
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
        ///租金总价 - 两位
        self.tableView.register(OwnerBuildingDecimalNumInputCell.self, forCellReuseIdentifier: OwnerBuildingDecimalNumInputCell.reuseIdentifierStr)
        
        ///可置工位
        
        
        ///装修程度
        ///特色
        self.tableView.register(OwnerBuildingNetworkSelectCell.self, forCellReuseIdentifier: OwnerBuildingNetworkSelectCell.reuseIdentifierStr)
        
        ///户型格局简介
        self.tableView.register(OwnerBuildingFYIntroductionCell.self, forCellReuseIdentifier: OwnerBuildingFYIntroductionCell.reuseIdentifierStr)
        
        ///图片选择
        self.tableView.register(OwnerBuildingImgCell.self, forCellReuseIdentifier: OwnerBuildingImgCell.reuseIdentifierStr)
        
        refreshData()
        
    }
    
    
    func loadEnterCompany(section: Int, index: Int) {
        endEdting()
        if index == companyArr.count - 1 {
            if companyArr.count < enterCompanyMaxNum_5 {
                companyArr.append("")
            }
        }else {
            if index <= companyArr.count - 1 {
                companyArr.remove(at: index)
            }
        }
        
        loadSecion(section: section)
    }
    
    func loadEnterCompanyInputComplete(Str: String, index: Int) {
        if index <= companyArr.count - 1 {
            companyArr[index] = Str
        }
    }
    
    func loadSecion(section: Int) {
        tableView.reloadSections(NSIndexSet.init(index: section) as IndexSet, with: UITableView.RowAnimation.none)
    }
    
    func loadSections(indexSet: IndexSet) {
        tableView.reloadSections(NSIndexSet.init(indexSet: indexSet) as IndexSet, with: UITableView.RowAnimation.none)
    }
}

extension OwnerBuildingOfficeViewController {
    
    func showArea(section: Int, isFrist: Bool) {
        areaView.ShowCityDistrictAddressSelectView(isfirst: isFrist, model: self.areaModelCount ?? CityAreaCategorySelectModel(), clearButtonCallBack: { (_ selectModel: CityAreaCategorySelectModel) -> Void in
            
        }, sureAreaaddressButtonCallBack: { [weak self] (_ selectModel: CityAreaCategorySelectModel) -> Void in
            self?.areaModelCount = selectModel
            self?.buildingModel?.district = selectModel.isFirstSelectedModel?.districtID
            self?.buildingModel?.business = selectModel.isFirstSelectedModel?.isSencondSelectedModel?.id
            self?.buildingModel?.districtString = "\(selectModel.name ?? "上海市")\(selectModel.isFirstSelectedModel?.district ?? "")"
            self?.buildingModel?.businessString = "\(selectModel.isFirstSelectedModel?.isSencondSelectedModel?.area ?? "")"
            self?.loadSecion(section: section)
            
        })
    }
    
    func getSelectedDistrictBusiness() {
        areaModelCount?.data.forEach({ (model) in
            if model.districtID == buildingModel?.district {
                areaModelCount?.isFirstSelectedModel = model
                buildingModel?.districtString = "\(areaModelCount?.name ?? "上海市")\(model.district ?? "")"
                areaModelCount?.isFirstSelectedModel?.list.forEach({ (areaModel) in
                    if areaModel.id == buildingModel?.business {
                        areaModelCount?.isFirstSelectedModel?.isSencondSelectedModel = areaModel
                        buildingModel?.businessString = areaModel.area
                        loadTableview()
                    }
                })
                
            }
        })
    }
    
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
                let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingFloorCell.reuseIdentifierStr) as? OwnerBuildingFloorCell
                cell?.selectionStyle = .none
                cell?.buildingModel = buildingModel ?? FangYuanBuildingEditDetailModel()
                cell?.officeModel = model
                return cell ?? OwnerBuildingFloorCell.init(frame: .zero)
                
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
        ///租金总价 - 两位
        case .OwnerBuildingOfficeTypeArea, .OwnerBuildingOfficeTypeClearHeight, .OwnerBuildingOfficeTypeFloorHeight, .OwnerBuildingOfficeTypePropertyCoast, .OwnerBuildingOfficeTypePrice, .OwnerBuildingOfficeTypeTotalPrice:
            
            ///数字文本输入cell
            let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingDecimalNumInputCell.reuseIdentifierStr) as? OwnerBuildingDecimalNumInputCell
            cell?.selectionStyle = .none
            cell?.buildingModel = buildingModel ?? FangYuanBuildingEditDetailModel()
            cell?.officeModel = model
            return cell ?? OwnerBuildingDecimalNumInputCell.init(frame: .zero)
            
            
        ///可置工位
        case .OwnerBuildingOfficeTypeSeats:
            
            return UITableViewCell()
            
        ///装修程度
        case .OwnerBuildingOfficeTypeDocument:
            let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingNetworkSelectCell.reuseIdentifierStr) as? OwnerBuildingNetworkSelectCell
            cell?.selectionStyle = .none
            cell?.categoryTitleLabel.text = "装修程度"
            cell?.isDocumentType = false
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
            cell?.isDocumentType = true
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
                    return OwnerBuildingFloorCell.rowHeight()
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
        ///租金总价 - 两位
        case .OwnerBuildingOfficeTypeArea, .OwnerBuildingOfficeTypeClearHeight, .OwnerBuildingOfficeTypeFloorHeight, .OwnerBuildingOfficeTypePropertyCoast, .OwnerBuildingOfficeTypePrice, .OwnerBuildingOfficeTypeTotalPrice:
            
            return BaseEditCell.rowHeight()
            
        ///可置工位
        case .OwnerBuildingOfficeTypeSeats:
            
            return BaseEditCell.rowHeight()
            
        ///装修程度
        case .OwnerBuildingOfficeTypeDocument:
            let count = ((buildingModel?.internetLocal.count ?? 0  + 1) / 3)
            
            return CGFloat(count * 50 + 59 + 5)
            
        ///户型格局简介
        case .OwnerBuildingOfficeTypeIntrodution:
            return OwnerBuildingFYIntroductionCell.rowHeight()
            
            
        ///特色
        case .OwnerBuildingOfficeTypeFeature:
            let count = ((buildingModel?.tagsLocal.count ?? 0  + 1) / 3)
            
            return CGFloat(count * 50 + 59 + 5)
            
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
            
            ownerFYMoreSettingView.ShowOwnerFYMoreSettingView(datasource: ["面议", "1个月" , "9个月"], clearButtonCallBack: {
                
            }) {[weak self] (settingEnumIndex) in
                //单层1 多层2
                self?.loadSections(indexSet: [indexPath.section])
            }
            
        ///所在楼层
        case .OwnerBuildingOfficeTypeTotalFloor:
            
            if indexPath.row == 0 {
                
                endEdting()
                
                ownerFYMoreSettingView.ShowOwnerFYMoreSettingView(datasource: [OwnerBuildingTotalFloorType.OwnerBuildingTotalFloorTypeOne.rawValue, OwnerBuildingTotalFloorType.OwnerBuildingTotalFloorTypeMore.rawValue], clearButtonCallBack: {
                    
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




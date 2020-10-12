//
//  OwnerBuildingCreateViewController.swift
//  OfficeGo
//
//  Created by Mac pro on 2020/9/28.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit
import HandyJSON
import SwiftyJSON

class OwnerBuildingCreateViewController: BaseTableViewController {
    
    ///选择弹框
    lazy var ownerFYMoreSettingView: OwnerFYMoreSettingView = {
        let view = OwnerFYMoreSettingView.init(frame: CGRect(x: 0.0, y: 0, width: kWidth, height: kHeight))
        view.titleString = "请选择"
        return view
    }()
    
    //记录是否已经点了关闭pc按钮
    var isClose: Bool?
    
    ///类型数据源
    var typeSourceArray:[OwnerBuildingEditConfigureModel] = [OwnerBuildingEditConfigureModel]()
    
    ///入住公司数组
    var companyArr: [String] = [""]
    
    ///
    var buildingModel: FangYuanBuildingEditDetailModel?
    
    ///空调类型
    var airditionType: OwnerAircontiditonType = OwnerAircontiditonType.OwnerAircontiditonTypeNone
    
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
        
        ///楼盘类型
        typeSourceArray.append(OwnerBuildingEditConfigureModel.init(types: .OwnerBuildingEditTypeBuildingTypew))
        ///写字楼名称
        typeSourceArray.append(OwnerBuildingEditConfigureModel.init(types: .OwnerBuildingEditTypeBuildingName))
        ///所在区域
        typeSourceArray.append(OwnerBuildingEditConfigureModel.init(types: .OwnerBuildingEditTypeDisctict))
        ///详细地址
        typeSourceArray.append(OwnerBuildingEditConfigureModel.init(types: .OwnerBuildingEditTypeDetailAddress))
        ///总楼层
        typeSourceArray.append(OwnerBuildingEditConfigureModel.init(types: .OwnerBuildingEditTypeTotalFloor))
        ///竣工时间
        typeSourceArray.append(OwnerBuildingEditConfigureModel.init(types: .OwnerBuildingEditTypeCompelteTime))
        ///翻新时间
        typeSourceArray.append(OwnerBuildingEditConfigureModel.init(types: .OwnerBuildingEditTypeRenovationTime))
        ///建筑面积
        typeSourceArray.append(OwnerBuildingEditConfigureModel.init(types: .OwnerBuildingEditTypeArea))
        ///净高
        typeSourceArray.append(OwnerBuildingEditConfigureModel.init(types: .OwnerBuildingEditTypeClearHeight))
        ///层高
        typeSourceArray.append(OwnerBuildingEditConfigureModel.init(types: .OwnerBuildingEditTypeFloorHeight))
        ///物业公司
        typeSourceArray.append(OwnerBuildingEditConfigureModel.init(types: .OwnerBuildingEditTypePropertyCompany))
        ///物业费
        typeSourceArray.append(OwnerBuildingEditConfigureModel.init(types: .OwnerBuildingEditTypePropertyCoast))
        ///车位数
        typeSourceArray.append(OwnerBuildingEditConfigureModel.init(types: .OwnerBuildingEditTypeParkingNum))
        ///车位费
        typeSourceArray.append(OwnerBuildingEditConfigureModel.init(types: .OwnerBuildingEditTypeParkingCoast))
        ///空调类型
        typeSourceArray.append(OwnerBuildingEditConfigureModel.init(types: .OwnerBuildingEditTypeAirConditionType))
        ///空调费
        typeSourceArray.append(OwnerBuildingEditConfigureModel.init(types: .OwnerBuildingEditTypeAirConditionCoast))
        ///电梯数 - 客梯
        typeSourceArray.append(OwnerBuildingEditConfigureModel.init(types: .OwnerBuildingEditTypePassengerNum))
        ///电梯数 - 货梯
        typeSourceArray.append(OwnerBuildingEditConfigureModel.init(types: .OwnerBuildingEditTypeFloorCargoNum))
        ///网络
        typeSourceArray.append(OwnerBuildingEditConfigureModel.init(types: .OwnerBuildingEditTypeNetwork))
        ///入驻企业
        typeSourceArray.append(OwnerBuildingEditConfigureModel.init(types: .OwnerBuildingEditTypeEnterCompany))
        ///详细介绍
        typeSourceArray.append(OwnerBuildingEditConfigureModel.init(types: .OwnerBuildingEditTypeDetailIntroduction))
        ///特色
        typeSourceArray.append(OwnerBuildingEditConfigureModel.init(types: .OwnerBuildingEditTypeFeature))
        ///上传楼盘图片
        typeSourceArray.append(OwnerBuildingEditConfigureModel.init(types: .OwnerBuildingEditTypeBuildingImage))
        
        if buildingModel != nil {
            
        }else {
            buildingModel = FangYuanBuildingEditDetailModel()
        }
        
        let model1 = HouseFeatureModel()
        model1.dictCname = "电信"
        buildingModel?.networks.append(model1)
        
        let model2 = HouseFeatureModel()
        model2.dictCname = "联通"
        buildingModel?.networks.append(model2)
        
        let model3 = HouseFeatureModel()
        model3.dictCname = "移动"
        buildingModel?.networks.append(model3)
        
        requestGetFeature()
        
    }
    
    //MARK: 获取特色接口
    func requestGetFeature() {
        
        SSNetworkTool.SSBasic.request_getDictionary(code: .codeEnumbranchUnique, success: { [weak self] (response) in
            guard let weakSelf = self else {return}
            if let decoratedArray = JSONDeserializer<HouseFeatureModel>.deserializeModelArrayFrom(json: JSON(response).rawString() ?? "", designatedPath: "data") {
                for model in decoratedArray {
                    weakSelf.buildingModel?.tags.append(model ?? HouseFeatureModel())
                }
            }
            weakSelf.tableView.reloadData()
            
            }, failure: {[weak self] (error) in
                self?.tableView.reloadData()
                
        }) {[weak self] (code, message) in
            self?.tableView.reloadData()
            
            //只有5000 提示给用户
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" {
                AppUtilities.makeToast(message)
            }
        }
    }
}

extension OwnerBuildingCreateViewController {
    
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
        titleview?.titleLabel.text = "编辑写字楼"
        titleview?.leftButtonCallBack = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        titleview?.rightBtnClickBlock = { [weak self] in
            let vc = OwnerBuildingCreateViewController()
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
        
        //        self.view.backgroundColor = kAppColor_bgcolor_F7F7F7
        
        //        self.tableView.backgroundColor = kAppColor_bgcolor_F7F7F7
        
        ///选择cell
        self.tableView.register(OwnerBuildingClickCell.self, forCellReuseIdentifier: OwnerBuildingClickCell.reuseIdentifierStr)
        
        ///日期选择cell
        self.tableView.register(OwnerBuildingDateClickCell.self, forCellReuseIdentifier: OwnerBuildingDateClickCell.reuseIdentifierStr)
        
        
        ///文本输入cell
        self.tableView.register(OwnerBuildingInputCell.self, forCellReuseIdentifier: OwnerBuildingInputCell.reuseIdentifierStr)
        
        ///数字文本输入cell - 正整数
        self.tableView.register(OwnerBuildingNumInputCell.self, forCellReuseIdentifier: OwnerBuildingNumInputCell.reuseIdentifierStr)
        
        ///数字文本输入cell - 带一位小数点
        self.tableView.register(OwnerBuildingDecimalNumInputCell.self, forCellReuseIdentifier: OwnerBuildingDecimalNumInputCell.reuseIdentifierStr)
        
        ///带框文本输入cell
        self.tableView.register(OwnerBuildingBorderInputCell.self, forCellReuseIdentifier: OwnerBuildingBorderInputCell.reuseIdentifierStr)
        
        ///装修类型
        ///特色
        self.tableView.register(OwnerBuildingNetworkSelectCell.self, forCellReuseIdentifier: OwnerBuildingNetworkSelectCell.reuseIdentifierStr)
        
        ///详细介绍
        self.tableView.register(OwnerBuildingIntroductionCell.self, forCellReuseIdentifier: OwnerBuildingIntroductionCell.reuseIdentifierStr)
        
        ///图片选择
        self.tableView.register(OwnerBuildingImgCell.self, forCellReuseIdentifier: OwnerBuildingImgCell.reuseIdentifierStr)
        
        ///入住企业
        self.tableView.register(OwnerBuildingEnterCompanyCell.self, forCellReuseIdentifier: OwnerBuildingEnterCompanyCell.reuseIdentifierStr)
        
        
        refreshData()
        
    }
    
    
    func loadEnterCompany(index: Int) {
        if index == companyArr.count - 1 {
            if companyArr.count < 4 {
                companyArr.append("")
            }
        }else {
            if index <= companyArr.count - 1 {
                companyArr.remove(at: index)
            }
        }
        
        tableView.reloadSections(NSIndexSet.init(index: 19) as IndexSet, with: UITableView.RowAnimation.none)
    }
    
    func loadEnterCompanyInputComplete(Str: String, index: Int) {
        if index <= companyArr.count - 1 {
            companyArr[index] = Str
        }
        //        tableView.reloadSections(NSIndexSet.init(index: 19) as IndexSet, with: UITableView.RowAnimation.none)
        //        tableView.endEditing(true)
    }
}

extension OwnerBuildingCreateViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return typeSourceArray.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if typeSourceArray[section].type == .OwnerBuildingEditTypeEnterCompany {
            return companyArr.count
        }else {
            return 1
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model:OwnerBuildingEditConfigureModel = typeSourceArray[indexPath.section]
        
        switch model.type {
            ///选择cell
            ///楼盘类型
            ///所在区域
        ///空调类型
        case .OwnerBuildingEditTypeBuildingTypew, .OwnerBuildingEditTypeDisctict, .OwnerBuildingEditTypeAirConditionType:
            
            ///点击cell
            let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingClickCell.reuseIdentifierStr) as? OwnerBuildingClickCell
            cell?.selectionStyle = .none
            cell?.model = model
            return cell ?? OwnerBuildingClickCell.init(frame: .zero)
            
            ///竣工时间
        ///翻新时间
        case .OwnerBuildingEditTypeCompelteTime, .OwnerBuildingEditTypeRenovationTime:
            
            ///点击cell
            let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingDateClickCell.reuseIdentifierStr) as? OwnerBuildingDateClickCell
            cell?.selectionStyle = .none
            cell?.model = model
            return cell ?? OwnerBuildingDateClickCell.init(frame: .zero)
            
            
            ///文本输入cell
            ///写字楼名称
            ///详细地址
        ///物业公司
        case .OwnerBuildingEditTypeBuildingName, .OwnerBuildingEditTypeDetailAddress, .OwnerBuildingEditTypePropertyCompany:
            
            ///文本输入cell
            let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingInputCell.reuseIdentifierStr) as? OwnerBuildingInputCell
            cell?.selectionStyle = .none
            cell?.model = model
            return cell ?? OwnerBuildingInputCell.init(frame: .zero)
            
            
            
            ///正数字文本输入cell
            ///总楼层
            ///车位数
        ///车位费
        case .OwnerBuildingEditTypeTotalFloor, .OwnerBuildingEditTypeParkingNum,
             .OwnerBuildingEditTypeParkingCoast:
            
            ///数字文本输入cell
            let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingNumInputCell.reuseIdentifierStr) as? OwnerBuildingNumInputCell
            cell?.selectionStyle = .none
            cell?.model = model
            return cell ?? OwnerBuildingNumInputCell.init(frame: .zero)
            
            
            ///数字 - 一位小数点文本输入cell
            ///建筑面积
            ///净高
            ///层高
        ///物业费
        case .OwnerBuildingEditTypeArea, .OwnerBuildingEditTypeClearHeight, .OwnerBuildingEditTypeFloorHeight, .OwnerBuildingEditTypePropertyCoast:
            
            ///数字文本输入cell
            let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingDecimalNumInputCell.reuseIdentifierStr) as? OwnerBuildingDecimalNumInputCell
            cell?.selectionStyle = .none
            cell?.model = model
            return cell ?? OwnerBuildingDecimalNumInputCell.init(frame: .zero)
            
            
            ///有框框文本输入cell
            ///电梯数 - 客梯
        ///电梯数 - 客、货梯
        case .OwnerBuildingEditTypePassengerNum, .OwnerBuildingEditTypeFloorCargoNum:
            
            ///有框框文本输入cell
            let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingBorderInputCell.reuseIdentifierStr) as? OwnerBuildingBorderInputCell
            cell?.selectionStyle = .none
            cell?.model = model
            return cell ?? OwnerBuildingBorderInputCell.init(frame: .zero)
            
            
            
        ///空调费 - 没有右边的箭头
        case .OwnerBuildingEditTypeAirConditionCoast:
            ///点击cell
            let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingClickCell.reuseIdentifierStr) as? OwnerBuildingClickCell
            cell?.selectionStyle = .none
            cell?.detailIcon.isHidden = true
            cell?.model = model
            if airditionType == OwnerAircontiditonType.OwnerAircontiditonTypeDefault {
                cell?.editLabel.text = ""
            }else if airditionType == OwnerAircontiditonType.OwnerAircontiditonTypeCenter {
                cell?.editLabel.text = OwnerAircontiditonFeeType.OwnerAircontiditonFeeTypeCenter.rawValue
            }else if airditionType == OwnerAircontiditonType.OwnerAircontiditonTypeIndividual{
                cell?.editLabel.text = OwnerAircontiditonFeeType.OwnerAircontiditonFeeTypeIndividual.rawValue
            }else if airditionType == OwnerAircontiditonType.OwnerAircontiditonTypeNone {
                cell?.editLabel.text = OwnerAircontiditonFeeType.OwnerAircontiditonFeeTypeNone.rawValue
            }
            return cell ?? OwnerBuildingClickCell.init(frame: .zero)
            
        ///网络
        case .OwnerBuildingEditTypeNetwork:
            let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingNetworkSelectCell.reuseIdentifierStr) as? OwnerBuildingNetworkSelectCell
            cell?.selectionStyle = .none
            cell?.categoryTitleLabel.text = "网络"
            cell?.isDocumentType = false
            cell?.buildingModel = self.buildingModel ?? FangYuanBuildingEditDetailModel()
            return cell ?? OwnerBuildingNetworkSelectCell.init(frame: .zero)
            
        ///入驻企业
        case .OwnerBuildingEditTypeEnterCompany:
            let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingEnterCompanyCell.reuseIdentifierStr) as? OwnerBuildingEnterCompanyCell
            cell?.selectionStyle = .none
            cell?.indexPathRow = indexPath.row
            cell?.model = model
            cell?.editLabel.text = companyArr[indexPath.row]
            if indexPath.row == 0 {
                cell?.titleLabel.isHidden = false
            }else {
                cell?.titleLabel.isHidden = true
            }
            if indexPath.row == companyArr.count - 1 {
                cell?.detailIcon.setImage(UIImage.init(named: "addBlue"), for: .normal)
                cell?.lineView.isHidden = false
            }else {
                cell?.detailIcon.setImage(UIImage.init(named: "closeBlue"), for: .normal)
                cell?.lineView.isHidden = true
            }
            cell?.closeBtnClickClouse = { [weak self] (index) in
                self?.loadEnterCompany(index: index)
            }
            cell?.endEditingMessageCell = { [weak self] (str, index) in
                self?.loadEnterCompanyInputComplete(Str: str, index: index)
            }
            return cell ?? OwnerBuildingEnterCompanyCell.init(frame: .zero)
            
        ///详细介绍
        case .OwnerBuildingEditTypeDetailIntroduction:
            let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingIntroductionCell.reuseIdentifierStr) as? OwnerBuildingIntroductionCell
            cell?.selectionStyle = .none
            cell?.buildingModel = self.buildingModel ?? FangYuanBuildingEditDetailModel()
            return cell ?? OwnerBuildingIntroductionCell.init(frame: .zero)
            
        ///特色
        case .OwnerBuildingEditTypeFeature:
            let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingNetworkSelectCell.reuseIdentifierStr) as? OwnerBuildingNetworkSelectCell
            cell?.selectionStyle = .none
            cell?.categoryTitleLabel.text = "特色"
            cell?.isDocumentType = true
            cell?.buildingModel = self.buildingModel ?? FangYuanBuildingEditDetailModel()
            return cell ?? OwnerBuildingNetworkSelectCell.init(frame: .zero)
            
        ///上传楼盘图片
        case .OwnerBuildingEditTypeBuildingImage:
            let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingImgCell.reuseIdentifierStr) as? OwnerBuildingImgCell
            cell?.selectionStyle = .none
            cell?.buildingModel = self.buildingModel ?? FangYuanBuildingEditDetailModel()
            return cell ?? OwnerBuildingImgCell.init(frame: .zero)
            
        ///上传楼盘视频
        case .OwnerBuildingEditTypeBuildingVideo:
            return UITableViewCell.init(frame: .zero)
            
        ///上传楼盘vr
        case .OwnerBuildingEditTypeBuildingVR:
            return UITableViewCell.init(frame: .zero)
            
        case .none:
            return UITableViewCell.init(frame: .zero)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch typeSourceArray[indexPath.section].type {
            ///选择cell
            ///楼盘类型
            ///所在区域
            ///竣工时间
            ///翻新时间
        ///空调类型
        case .OwnerBuildingEditTypeBuildingTypew, .OwnerBuildingEditTypeDisctict, .OwnerBuildingEditTypeCompelteTime, .OwnerBuildingEditTypeRenovationTime, .OwnerBuildingEditTypeAirConditionType:
            
            return BaseEditCell.rowHeight()
            
            ///文本输入cell
            ///写字楼名称
            ///详细地址
        ///物业公司
        case .OwnerBuildingEditTypeBuildingName, .OwnerBuildingEditTypeDetailAddress, .OwnerBuildingEditTypePropertyCompany:
            
            return BaseEditCell.rowHeight()
            
            
            ///正数字文本输入cell
            ///总楼层
            ///车位数
        ///车位费
        case .OwnerBuildingEditTypeTotalFloor, .OwnerBuildingEditTypeParkingNum,
             .OwnerBuildingEditTypeParkingCoast:
            
            return BaseEditCell.rowHeight()
            
            ///数字 - 一位小数点文本输入cell
            ///建筑面积
            ///净高
            ///层高
        ///物业费
        case .OwnerBuildingEditTypeArea, .OwnerBuildingEditTypeClearHeight, .OwnerBuildingEditTypeFloorHeight, .OwnerBuildingEditTypePropertyCoast:
            
            return BaseEditCell.rowHeight()
            
            
            ///有框框文本输入cell
            ///车位费
            ///电梯数 - 客梯
        ///电梯数 - 客、货梯
        case .OwnerBuildingEditTypeParkingCoast, .OwnerBuildingEditTypePassengerNum, .OwnerBuildingEditTypeFloorCargoNum:
            
            return BaseEditCell.rowHeight()
            
            
        ///空调费 - 没有右边的箭头
        case .OwnerBuildingEditTypeAirConditionCoast:
            if airditionType == OwnerAircontiditonType.OwnerAircontiditonTypeDefault {
                return 0
            }else {
                return BaseEditCell.rowHeight()
            }
            
        ///网络
        case .OwnerBuildingEditTypeNetwork:
            
            let count = ((buildingModel?.networks.count ?? 0  + 1) / 3)
            
            return CGFloat(count * 50 + 59 + 5)
            
        ///入驻企业
        case .OwnerBuildingEditTypeEnterCompany:
            return OwnerBuildingEnterCompanyCell.rowHeight()
            
        ///详细介绍
        case .OwnerBuildingEditTypeDetailIntroduction:
            return OwnerBuildingIntroductionCell.rowHeight()
            
        ///特色
        case .OwnerBuildingEditTypeFeature:
            
            let count = ((buildingModel?.tags.count ?? 0  + 1) / 3)
            
            return CGFloat(count * 50 + 59 + 5)
            
        ///上传楼盘图片
        case .OwnerBuildingEditTypeBuildingImage:
            return ((kWidth - left_pending_space_17 * 2 - 5 * 2) / 3.0 + 10) * 4 + 68
            
        ///上传楼盘视频
        case .OwnerBuildingEditTypeBuildingVideo:
            return BaseEditCell.rowHeight()
            
        ///上传楼盘vr
        case .OwnerBuildingEditTypeBuildingVR:
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
            ///选择cell
            ///楼盘类型
        case .OwnerBuildingEditTypeBuildingTypew:
            ownerFYMoreSettingView.ShowOwnerFYMoreSettingView(datasource: [OWnerBuildingTypeEnum.xieziEnum.rawValue, OWnerBuildingTypeEnum.chuangyiEnum.rawValue, OWnerBuildingTypeEnum.chanyeEnum.rawValue], clearButtonCallBack: {
                
            }) { (settingEnumIndex) in
                SSLog("-----点击的是---\(settingEnumIndex)")
            }
            SSLog(typeSourceArray[indexPath.section].type)
            
        ///所在区域
        case .OwnerBuildingEditTypeDisctict:
            SSLog(typeSourceArray[indexPath.section].type)
        
            
        ///竣工时间
        case .OwnerBuildingEditTypeCompelteTime:
            SSLog(typeSourceArray[indexPath.section].type)
            
        ///翻新时间
        case .OwnerBuildingEditTypeRenovationTime:
            SSLog(typeSourceArray[indexPath.section].type)
            
        
        ///空调类型
        case .OwnerBuildingEditTypeAirConditionType:
            SSLog(typeSourceArray[indexPath.section].type)
            ownerFYMoreSettingView.ShowOwnerFYMoreSettingView(datasource: [OwnerAircontiditonType.OwnerAircontiditonTypeCenter.rawValue, OwnerAircontiditonType.OwnerAircontiditonTypeIndividual.rawValue, OwnerAircontiditonType.OwnerAircontiditonTypeNone.rawValue], clearButtonCallBack: {
                
            }) { (settingEnumIndex) in
                SSLog("-----点击的是---\(settingEnumIndex)")
            }
                
            
            ///文本输入cell
            ///写字楼名称
            ///详细地址
        ///物业公司
        case .OwnerBuildingEditTypeBuildingName, .OwnerBuildingEditTypeDetailAddress, .OwnerBuildingEditTypePropertyCompany:
            SSLog(typeSourceArray[indexPath.section].type)
            
            
            ///正数字文本输入cell
            ///总楼层
            ///车位数
        ///车位费
        case .OwnerBuildingEditTypeTotalFloor, .OwnerBuildingEditTypeParkingNum,
             .OwnerBuildingEditTypeParkingCoast:
            
            SSLog(typeSourceArray[indexPath.section].type)
            
            ///数字 - 一位小数点文本输入cell
            ///建筑面积
            ///净高
            ///层高
        ///物业费
        case .OwnerBuildingEditTypeArea, .OwnerBuildingEditTypeClearHeight, .OwnerBuildingEditTypeFloorHeight, .OwnerBuildingEditTypePropertyCoast:
            
            SSLog(typeSourceArray[indexPath.section].type)
            
            ///有框框文本输入cell
            ///车位费
            ///电梯数 - 客梯
        ///电梯数 - 客、货梯
        case .OwnerBuildingEditTypeParkingCoast, .OwnerBuildingEditTypePassengerNum, .OwnerBuildingEditTypeFloorCargoNum:
            SSLog(typeSourceArray[indexPath.section].type)
            
            
        ///空调费 - 没有右边的箭头
        case .OwnerBuildingEditTypeAirConditionCoast:
            SSLog(typeSourceArray[indexPath.section].type)
            
        ///网络
        case .OwnerBuildingEditTypeNetwork:
            SSLog(typeSourceArray[indexPath.section].type)
            
        ///入驻企业
        case .OwnerBuildingEditTypeEnterCompany:
            SSLog(typeSourceArray[indexPath.section].type)
            
        ///详细介绍
        case .OwnerBuildingEditTypeDetailIntroduction:
            SSLog(typeSourceArray[indexPath.section].type)
            
        ///特色
        case .OwnerBuildingEditTypeFeature:
            SSLog(typeSourceArray[indexPath.section].type)
            
        ///上传楼盘图片
        case .OwnerBuildingEditTypeBuildingImage:
            SSLog(typeSourceArray[indexPath.section].type)
            
        ///上传楼盘视频
        case .OwnerBuildingEditTypeBuildingVideo:
            SSLog(typeSourceArray[indexPath.section].type)
            
        ///上传楼盘vr
        case .OwnerBuildingEditTypeBuildingVR:
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




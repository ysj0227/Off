//
//  OwnerBuildingJointIndepententOfficeViewController.swift
//  OfficeGo
//
//  Created by Mac pro on 2020/10/16.
//  Copyright © 2020 Senwei. All rights reserved.
//
import UIKit
import HandyJSON
import SwiftyJSON

class OwnerBuildingJointIndepententOfficeViewController: BaseTableViewController {
    
    ///来自编辑还是添加
    var isFromAdd: Bool?
    
    ///选择弹框
    lazy var ownerFYMoreSettingView: OwnerFYMoreSettingView = {
        let view = OwnerFYMoreSettingView.init(frame: CGRect(x: 0.0, y: 0, width: kWidth, height: kHeight))
        view.titleString = "请选择"
        return view
    }()
    
    //记录是否已经点了关闭pc按钮
    var isClose: Bool?
    
    ///类型数据源
    var typeSourceArray:[OwnerBuildingJointOfficeConfigureModel] = [OwnerBuildingJointOfficeConfigureModel]()
    
    ///
    var FYModel: FangYuanHouseEditModel?
    
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
        vc.isBuildingJointOffice = true
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
        typeSourceArray.append(OwnerBuildingJointOfficeConfigureModel.init(types: .OwnerBuildingJointOfficeTypeName))
        
        ///出租方式 *
        //typeSourceArray.append(OwnerBuildingJointOfficeConfigureModel.init(types: .OwnerBuildingJointOfficeTypeRentType))
        
        ///工位数 *
        typeSourceArray.append(OwnerBuildingJointOfficeConfigureModel.init(types: .OwnerBuildingJointOfficeTypeSeats))
        
        ///面积
        typeSourceArray.append(OwnerBuildingJointOfficeConfigureModel.init(types: .OwnerBuildingJointOfficeTypeArea))
        
        ///租金 *
        typeSourceArray.append(OwnerBuildingJointOfficeConfigureModel.init(types: .OwnerBuildingJointOfficeTypePrice))
        
        ///所在楼层 *
        typeSourceArray.append(OwnerBuildingJointOfficeConfigureModel.init(types: .OwnerBuildingJointOfficeTypeTotalFloor))
        
        ///最短租期 *
        typeSourceArray.append(OwnerBuildingJointOfficeConfigureModel.init(types: .OwnerBuildingJointOfficeTypeMinRentalPeriod))
        
        ///免租期 *
        typeSourceArray.append(OwnerBuildingJointOfficeConfigureModel.init(types: .OwnerBuildingJointOfficeTypeRentFreePeriod))
        
        ///空调类型 *
        typeSourceArray.append(OwnerBuildingJointOfficeConfigureModel.init(types: .OwnerBuildingJointOfficeTypeAirConditionType))
        
        ///空调费
        typeSourceArray.append(OwnerBuildingJointOfficeConfigureModel.init(types: .OwnerBuildingJointOfficeTypeAirConditionCoast))
        
        ///车位数
        typeSourceArray.append(OwnerBuildingJointOfficeConfigureModel.init(types: .OwnerBuildingJointOfficeTypeParkingNum))
        
        ///车位费
        typeSourceArray.append(OwnerBuildingJointOfficeConfigureModel.init(types: .OwnerBuildingJointOfficeTypeParkingCoast))
        
        ///净高
        typeSourceArray.append(OwnerBuildingJointOfficeConfigureModel.init(types: .OwnerBuildingJointOfficeTypeClearHeight))
        
        ///户型格局简介
        typeSourceArray.append(OwnerBuildingJointOfficeConfigureModel.init(types: .OwnerBuildingJointOfficeTypeIntrodution))
        
        ///上传办公室图片 *
        typeSourceArray.append(OwnerBuildingJointOfficeConfigureModel.init(types: .OwnerBuildingJointOfficeTypeBuildingImage))
        
        
        
        
        ///来自添加
        if isFromAdd == true {
            
            FYModel = FangYuanHouseEditModel()
                    
            loadTableview()
            
        }else {
            
            request_getEditBuilding()
            
        }
        
    }
    
    
    //MARK: 获取详情 request_getHouseMsgByHouseId
    func request_getEditBuilding() {
        
        var params = [String:AnyObject]()
        params["token"] = UserTool.shared.user_token as AnyObject?
        params["houseId"] = FYModel?.id as AnyObject?
        params["isTemp"] = FYModel?.isTemp as AnyObject?

        SSNetworkTool.SSFYManager.request_getHouseMsgByHouseId(params: params, success: {[weak self] (response) in
            guard let weakSelf = self else {return}
            if let model = FangYuanHouseEditModel.deserialize(from: response, designatedPath: "data") {
                weakSelf.FYModel = model
                
            }
            weakSelf.dealData()
            
            }, failure: {[weak self] (error) in
                self?.dealData()
                
        }) {[weak self] (code, message) in
            self?.dealData()
            
            //只有5000 提示给用户
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" {
                AppUtilities.makeToast(message)
            }
        }
    }
    
    
    func dealData() {
        
        /*
        空调
        中央空调 0
        独立空调 1
        无空调 2
        */
        if FYModel?.houseMsg?.conditioningType == OwnerAircontiditonType.OwnerAircontiditonTypeDefault.rawValue {
            FYModel?.houseMsg?.airditionType = OwnerAircontiditonType.OwnerAircontiditonTypeDefault
        }else if FYModel?.houseMsg?.conditioningType == OwnerAircontiditonType.OwnerAircontiditonTypeCenter.rawValue {
            FYModel?.houseMsg?.airditionType = OwnerAircontiditonType.OwnerAircontiditonTypeCenter
        }else if FYModel?.houseMsg?.conditioningType == OwnerAircontiditonType.OwnerAircontiditonTypeIndividual.rawValue {
            FYModel?.houseMsg?.airditionType = OwnerAircontiditonType.OwnerAircontiditonTypeIndividual
        }else if FYModel?.houseMsg?.conditioningType == OwnerAircontiditonType.OwnerAircontiditonTypeNone.rawValue {
            FYModel?.houseMsg?.airditionType = OwnerAircontiditonType.OwnerAircontiditonTypeNone
        }
        
        ///添加banner数据
        if let arr = FYModel?.banner {
            
            for fczBannerModel in arr {
                fczBannerModel.isLocal = false
                fczBannerModel.isMain = false
                FYModel?.buildingLocalImgArr.append(fczBannerModel)
            }
        }
        ///添加封面图
        if let url = FYModel?.houseMsg?.mainPic {

            let mainPicModel = BannerModel()
            mainPicModel.imgUrl = url
            mainPicModel.isLocal = false
            mainPicModel.isMain = true
            FYModel?.buildingLocalImgArr.insert(mainPicModel, at: 0)
        }
        
        
        ///添加vr数据
        if let arr = FYModel?.vr {
            
            for fczBannerModel in arr {
                fczBannerModel.isLocal = false
                FYModel?.buildingLocalVRArr.append(fczBannerModel)
            }
        }
        
        
        ///刷新列表
        loadTableview()
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

extension OwnerBuildingJointIndepententOfficeViewController {
    
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
            titleview?.titleLabel.text = "添加独立办公室"
        }else {
            titleview?.titleLabel.text = "编辑独立办公室"
        }
        titleview?.leftButtonCallBack = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        titleview?.rightBtnClickBlock = { [weak self] in
            let vc = OwnerBuildingJointIndepententOfficeViewController()
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        self.view.addSubview(titleview ?? ThorNavigationView.init(type: .backTitleRight))
        
        
        self.view.addSubview(pcEditBtn)
        self.view.addSubview(saveBtn)
        self.view.addSubview(closePcEditBtn)
        
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
        ///出租方式
        ///所在楼层
        ///免租期
        ///空调类型
        self.tableView.register(OwnerBuildingClickCell.self, forCellReuseIdentifier: OwnerBuildingClickCell.reuseIdentifierStr)
        
        ///所在楼层
        self.tableView.register(OwnerBuildingFYFloorCell.self, forCellReuseIdentifier: OwnerBuildingFYFloorCell.reuseIdentifierStr)
        
        ///文本输入cell
        ///标题
        self.tableView.register(OwnerBuildingInputCell.self, forCellReuseIdentifier: OwnerBuildingInputCell.reuseIdentifierStr)
        
        ///正数字文本输入cell
        ///工位数
        ///最短租期
        ///车位数
        ///车位费
        self.tableView.register(OwnerBuildingNumInputCell.self, forCellReuseIdentifier: OwnerBuildingNumInputCell.reuseIdentifierStr)
        
        ///数字 - 一位小数点文本输入cell
        ///建筑面积 - 一位
        ///净高
        ///租金
        self.tableView.register(OwnerBuildingDecimalNumInputCell.self, forCellReuseIdentifier: OwnerBuildingDecimalNumInputCell.reuseIdentifierStr)
        
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

extension OwnerBuildingJointIndepententOfficeViewController {
    
    func loadTableview() {
        tableView.reloadData()
    }
}

extension OwnerBuildingJointIndepententOfficeViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return typeSourceArray.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        ///所在楼层
        if typeSourceArray[section].type == .OwnerBuildingJointOfficeTypeTotalFloor {
            return 2
        }else {
            return 1
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model:OwnerBuildingJointOfficeConfigureModel = typeSourceArray[indexPath.section]
        
        switch model.type {
            ///选择cell
           
        case .OwnerBuildingJointOfficeTypeRentFreePeriod, .OwnerBuildingJointOfficeTypeAirConditionType:
        //case .OwnerBuildingJointOfficeTypeRentType, .OwnerBuildingJointOfficeTypeRentFreePeriod, .OwnerBuildingJointOfficeTypeAirConditionType:
            
            ///出租方式
            ///所在楼层
            ///免租期
            ///空调类型
            let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingClickCell.reuseIdentifierStr) as? OwnerBuildingClickCell
            cell?.selectionStyle = .none
            cell?.FYModel = FYModel ?? FangYuanHouseEditModel()
            cell?.jointIndepentOfficeModel = model
            return cell ?? OwnerBuildingClickCell.init(frame: .zero)
            
            
        ///空调费 - 没有右边的箭头
        case .OwnerBuildingJointOfficeTypeAirConditionCoast:
            ///点击cell
            let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingClickCell.reuseIdentifierStr) as? OwnerBuildingClickCell
            cell?.selectionStyle = .none
            cell?.detailIcon.isHidden = true
            cell?.FYModel = FYModel ?? FangYuanHouseEditModel()
            cell?.jointIndepentOfficeModel = model
            return cell ?? OwnerBuildingClickCell.init(frame: .zero)
            
        ///所在楼层
        case .OwnerBuildingJointOfficeTypeTotalFloor:
            if indexPath.row == 0 {
                ///点击cell
                let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingClickCell.reuseIdentifierStr) as? OwnerBuildingClickCell
                cell?.selectionStyle = .none
                cell?.FYModel = FYModel ?? FangYuanHouseEditModel()
                cell?.jointIndepentOfficeModel = model
                return cell ?? OwnerBuildingClickCell.init(frame: .zero)
            }else {
                
                ///文本输入cell
                let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingFYFloorCell.reuseIdentifierStr) as? OwnerBuildingFYFloorCell
                cell?.selectionStyle = .none
                cell?.FYModel = FYModel ?? FangYuanHouseEditModel()
                cell?.jointIndepentOfficeModel = model
                return cell ?? OwnerBuildingFYFloorCell.init(frame: .zero)
                
            }
            
            
            ///文本输入cell
        ///标题
        ///车位数
        ///车位费
        case .OwnerBuildingJointOfficeTypeName, .OwnerBuildingJointOfficeTypeParkingNum, .OwnerBuildingJointOfficeTypeParkingCoast:
            
            ///文本输入cell
            let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingInputCell.reuseIdentifierStr) as? OwnerBuildingInputCell
            cell?.selectionStyle = .none
            cell?.FYModel = FYModel ?? FangYuanHouseEditModel()
            cell?.jointIndepentOfficeModel = model
            return cell ?? OwnerBuildingInputCell.init(frame: .zero)
            
            
            
        ///正数字文本输入cell
        case .OwnerBuildingJointOfficeTypeSeats, .OwnerBuildingJointOfficeTypeMinRentalPeriod, .OwnerBuildingJointOfficeTypePrice:
            
            ///工位数
            ///最短租期
            ///租金
            let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingNumInputCell.reuseIdentifierStr) as? OwnerBuildingNumInputCell
            cell?.selectionStyle = .none
            cell?.FYModel = FYModel ?? FangYuanHouseEditModel()
            cell?.jointIndepentOfficeModel = model
            return cell ?? OwnerBuildingNumInputCell.init(frame: .zero)
            
            
            ///数字 - 一位小数点文本输入cell
            ///建筑面积 - 一位
            ///净高
        case .OwnerBuildingJointOfficeTypeArea, .OwnerBuildingJointOfficeTypeClearHeight:
            
            ///数字文本输入cell
            let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingDecimalNumInputCell.reuseIdentifierStr) as? OwnerBuildingDecimalNumInputCell
            cell?.selectionStyle = .none
            cell?.FYModel = FYModel ?? FangYuanHouseEditModel()
            cell?.jointIndepentOfficeModel = model
            return cell ?? OwnerBuildingDecimalNumInputCell.init(frame: .zero)
            
            
        ///户型格局简介
        case .OwnerBuildingJointOfficeTypeIntrodution:
            let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingFYIntroductionCell.reuseIdentifierStr) as? OwnerBuildingFYIntroductionCell
            cell?.selectionStyle = .none
            cell?.FYModel = self.FYModel ?? FangYuanHouseEditModel()
            return cell ?? OwnerBuildingFYIntroductionCell.init(frame: .zero)
            
            
        ///上传楼盘图片
        case .OwnerBuildingJointOfficeTypeBuildingImage:
            let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingImgCell.reuseIdentifierStr) as? OwnerBuildingImgCell
            cell?.selectionStyle = .none
            cell?.FYModel = self.FYModel ?? FangYuanHouseEditModel()
            cell?.jointIndepentOfficeModel = model
            return cell ?? OwnerBuildingImgCell.init(frame: .zero)
            
        ///上传楼盘视频
        case .OwnerBuildingJointOfficeTypeBuildingVideo:
            return UITableViewCell.init(frame: .zero)
            
        ///上传楼盘vr
        case .OwnerBuildingJointOfficeTypeBuildingVR:
            return UITableViewCell.init(frame: .zero)
            
        case .none:
            return UITableViewCell.init(frame: .zero)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch typeSourceArray[indexPath.section].type {
            ///选择cell
            
        //case .OwnerBuildingJointOfficeTypeRentType, .OwnerBuildingJointOfficeTypeRentFreePeriod, .OwnerBuildingJointOfficeTypeAirConditionType:
            
        case .OwnerBuildingJointOfficeTypeRentFreePeriod, .OwnerBuildingJointOfficeTypeAirConditionType:
            ///出租方式
            ///所在楼层
            ///免租期
            ///空调类型
            return BaseEditCell.rowHeight()
            
            
        ///空调费 - 没有右边的箭头
        case .OwnerBuildingJointOfficeTypeAirConditionCoast:
            if FYModel?.houseMsg?.airditionType == nil || FYModel?.houseMsg?.airditionType == OwnerAircontiditonType.OwnerAircontiditonTypeDefault {
                return 0
            }else {
                return BaseEditCell.rowHeight()
            }
            
            
            
        ///所在楼层
        case .OwnerBuildingJointOfficeTypeTotalFloor:
            if indexPath.row == 0 {
                return BaseEditCell.rowHeight()
            }else {
                if FYModel?.houseMsg?.floorType == "1" || FYModel?.houseMsg?.floorType == "2" {
                    return OwnerBuildingFYFloorCell.rowHeight()
                }else {
                    return 0
                }
            }
            
            
            
            ///文本输入cell
        ///标题
        case .OwnerBuildingJointOfficeTypeName:
            
            return BaseEditCell.rowHeight()
            
            
            
            
            ///正数字文本输入cell
        ///最短租期
        case .OwnerBuildingJointOfficeTypeSeats, .OwnerBuildingJointOfficeTypeMinRentalPeriod, .OwnerBuildingJointOfficeTypeParkingNum, .OwnerBuildingJointOfficeTypeParkingCoast, .OwnerBuildingJointOfficeTypePrice:
            
            ///工位数
            ///最短租期
            ///车位数
            ///车位费
            ///租金
            return BaseEditCell.rowHeight()
            
            
            
            ///数字 - 一位小数点文本输入cell
            ///建筑面积 - 一位
            ///净高
        case .OwnerBuildingJointOfficeTypeArea, .OwnerBuildingJointOfficeTypeClearHeight:
            
            return BaseEditCell.rowHeight()
            
            
            
        ///户型格局简介
        case .OwnerBuildingJointOfficeTypeIntrodution:
            return OwnerBuildingFYIntroductionCell.rowHeight()
            
            
            
        ///上传楼盘图片
        case .OwnerBuildingJointOfficeTypeBuildingImage:
            return ((kWidth - left_pending_space_17 * 2 - 5 * 2) / 3.0 + 10) * 4 + 68
            
            
        ///上传楼盘视频
        case .OwnerBuildingJointOfficeTypeBuildingVideo:
            return 0
            
            
        ///上传楼盘vr
        case .OwnerBuildingJointOfficeTypeBuildingVR:
            return 0
            
            
        case .none:
            return 0
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.typeSourceArray.count <= 0 {
            return
        }
        
        switch typeSourceArray[indexPath.section].type {
            ///选择cell
            
//        case .OwnerBuildingJointOfficeTypeRentType:
//            
//            ///出租方式
//            SSLog(typeSourceArray[indexPath.section].type)
            
            
        ///空调类型
        case .OwnerBuildingJointOfficeTypeAirConditionType:
            
            endEdting()
            
            ownerFYMoreSettingView.ShowOwnerSettingView(datasource: [OwnerAircontiditonType.OwnerAircontiditonTypeCenter.rawValue, OwnerAircontiditonType.OwnerAircontiditonTypeIndividual.rawValue, OwnerAircontiditonType.OwnerAircontiditonTypeNone.rawValue], clearButtonCallBack: {
                
            }) {[weak self] (settingEnumIndex) in
                //中央空调，独立空调，无空调
                if settingEnumIndex == 0 {
                    SSLog("-----点击的是---中央空调")
                    self?.FYModel?.houseMsg?.airditionType = .OwnerAircontiditonTypeCenter
                }else if settingEnumIndex == 1 {
                    SSLog("-----点击的是---独立空调")
                    self?.FYModel?.houseMsg?.airditionType = .OwnerAircontiditonTypeIndividual
                }else if settingEnumIndex == 2 {
                    SSLog("-----点击的是---无空调")
                    self?.FYModel?.houseMsg?.airditionType = .OwnerAircontiditonTypeNone
                }
                self?.loadSections(indexSet: [indexPath.section, indexPath.section + 1])
            }
            
        ///免租期
        case .OwnerBuildingJointOfficeTypeRentFreePeriod:
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
            
            
        ///空调费 - 没有右边的箭头
        case .OwnerBuildingJointOfficeTypeAirConditionCoast:
            SSLog(typeSourceArray[indexPath.section].type)
            
            
        ///所在楼层
        case .OwnerBuildingJointOfficeTypeTotalFloor:
            if indexPath.row == 0 {
                
                endEdting()
                
                /*
                endEdting()
                
                ownerFYMoreSettingView.ShowOwnerSettingView(datasource: [OwnerBuildingTotalFloorType.OwnerBuildingTotalFloorTypeOne.rawValue, OwnerBuildingTotalFloorType.OwnerBuildingTotalFloorTypeMore.rawValue], clearButtonCallBack: {
                    
                }) {[weak self] (settingEnumIndex) in
                    //单层1 多层2
                    if settingEnumIndex == 0 {
                        self?.FYModel?.houseMsg?.floorType = "1"
                    }else if settingEnumIndex == 1 {
                        self?.FYModel?.houseMsg?.floorType = "2"
                    }
                    self?.loadSections(indexSet: [indexPath.section])
                }*/
                
            }
            
            
            
            ///文本输入cell
        ///标题
        case .OwnerBuildingJointOfficeTypeName:
            
            SSLog(typeSourceArray[indexPath.section].type)
            
            
            
            
            ///正数字文本输入cell
        ///最短租期
        case .OwnerBuildingJointOfficeTypeSeats, .OwnerBuildingJointOfficeTypeMinRentalPeriod, .OwnerBuildingJointOfficeTypeParkingNum, .OwnerBuildingJointOfficeTypeParkingCoast, .OwnerBuildingJointOfficeTypePrice:
            
            ///工位数
            ///最短租期
            ///车位数
            ///车位费
            ///租金
            SSLog(typeSourceArray[indexPath.section].type)
            
            
            
            ///数字 - 一位小数点文本输入cell
            ///建筑面积 - 一位
            ///净高
        case .OwnerBuildingJointOfficeTypeArea, .OwnerBuildingJointOfficeTypeClearHeight:
            
            SSLog(typeSourceArray[indexPath.section].type)
            
            
            
        ///户型格局简介
        case .OwnerBuildingJointOfficeTypeIntrodution:
            SSLog(typeSourceArray[indexPath.section].type)
            
            
            
        ///上传楼盘图片
        case .OwnerBuildingJointOfficeTypeBuildingImage:
            SSLog(typeSourceArray[indexPath.section].type)
            
            
        ///上传楼盘视频
        case .OwnerBuildingJointOfficeTypeBuildingVideo:
            SSLog(typeSourceArray[indexPath.section].type)
            
            
        ///上传楼盘vr
        case .OwnerBuildingJointOfficeTypeBuildingVR:
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




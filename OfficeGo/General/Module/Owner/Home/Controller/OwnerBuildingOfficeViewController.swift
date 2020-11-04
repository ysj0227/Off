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
    
    var rentFreePeriodArr = [OwnerRentFreePeriodType.OwnerRentFreePeriodTypeDefault.rawValue,
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
                             OwnerRentFreePeriodType.OwnerRentFreePeriodTypeMonth12.rawValue]
    
    
    ///
    var FYModel: FangYuanHouseEditModel?
    
    var isTemp: Bool?
    
    var houseID: Int?

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
        
        FYModel?.houseMsg?.monthPrice = FYModel?.houseMsg?.monthPriceTemp
        
        //        endEdting()
        
        totalPriceView.setTitle("", for: .normal)
        
        totalPriceView.snp.remakeConstraints({ (make) in
            make.size.equalTo(0)
            make.leading.equalToSuperview().offset(90)
        })
        
        loadSecion(section: 4)
    }
    
    @objc func saveClick() {
        request_getUpdateHouse()
    }
    
    func clickToPublish() {
        let vc = OwnerBuildingCreateVideoVRViewController()
        vc.isBuildingFY = true
        vc.isClose = isClose
        vc.FYModel = FYModel
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
        
        
        ///来自添加
        if isFromAdd == true {
            
            FYModel = FangYuanHouseEditModel()
                    
            FYModel?.houseMsg = FangYuanHouseMsgEditModel()

            requestGetDecorate()

        }else {
            
            request_getHouseMsgByHouseId()
            
        }
    }
    
    
    //MARK: 获取装修类型接口
    func requestGetDecorate() {
        
        SSNetworkTool.SSBasic.request_getDictionary(code: .codeEnumdecoratedType, success: { [weak self] (response) in
            guard let weakSelf = self else {return}
            if let decoratedArray = JSONDeserializer<HouseFeatureModel>.deserializeModelArrayFrom(json: JSON(response).rawString() ?? "", designatedPath: "data") {
                for model in decoratedArray {
                    weakSelf.FYModel?.houseMsg?.decoratesLocal.append(model ?? HouseFeatureModel())
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
                    weakSelf.FYModel?.houseMsg?.tagsLocal.append(model ?? HouseFeatureModel())
                }
            }else {
                weakSelf.FYModel = FangYuanHouseEditModel()
                weakSelf.FYModel?.houseMsg = FangYuanHouseMsgEditModel()
            }
            weakSelf.dealData()
            
            }, failure: {[weak self] (error) in
                self?.FYModel = FangYuanHouseEditModel()
                self?.FYModel?.houseMsg = FangYuanHouseMsgEditModel()
                self?.dealData()
                
        }) {[weak self] (code, message) in
            self?.FYModel = FangYuanHouseEditModel()
            self?.FYModel?.houseMsg = FangYuanHouseMsgEditModel()
            self?.dealData()
            
            //只有5000 提示给用户
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" {
                AppUtilities.makeToast(message)
            }
        }
    }
    
    //MARK: 获取详情 request_getHouseMsgByHouseId
    func request_getHouseMsgByHouseId() {
        
        var params = [String:AnyObject]()
        params["token"] = UserTool.shared.user_token as AnyObject?
        params["houseId"] = houseID as AnyObject?
        params["isTemp"] = isTemp as AnyObject?

        SSNetworkTool.SSFYManager.request_getHouseMsgByHouseId(params: params, success: {[weak self] (response) in
            guard let weakSelf = self else {return}
            if let model = FangYuanHouseEditModel.deserialize(from: response, designatedPath: "data") {
                weakSelf.FYModel = model
                
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
    
    ///提交接口
    func request_getUpdateHouse() {

        var params = [String:AnyObject]()

        params["token"] = UserTool.shared.user_token as AnyObject?

        params["isTemp"] = isTemp as AnyObject?
        
        //MARK: 房源id
        params["id"] = houseID as AnyObject?

        //MARK: 标题 - 非
        if FYModel?.houseMsg?.title == nil || FYModel?.houseMsg?.title?.isBlankString == true{
            //AppUtilities.makeToast("请输入标题")
            //return
        }else {
            params["title"] = FYModel?.houseMsg?.title as AnyObject?
        }

        //MARK: 面积
        if FYModel?.houseMsg?.area == nil || FYModel?.houseMsg?.area?.isBlankString == true{
            AppUtilities.makeToast("请输入面积")
            return
        }else {
            params["area"] = FYModel?.houseMsg?.area as AnyObject?
        }
        
        //MARK: 可置工位
        if FYModel?.houseMsg?.minSeatsOffice == nil || FYModel?.houseMsg?.minSeatsOffice?.isBlankString == true || FYModel?.houseMsg?.maxSeatsOffice == nil || FYModel?.houseMsg?.maxSeatsOffice?.isBlankString == true{
            AppUtilities.makeToast("请输入可置工位")
            return
        }else {
            var arr: [String] = []
            arr.append(FYModel?.houseMsg?.minSeatsOffice ?? "0")
            arr.append(FYModel?.houseMsg?.maxSeatsOffice ?? "0")
            params["simple"] = arr.joined(separator: ",") as AnyObject?
        }
        
        //MARK: 租金单价
        if FYModel?.houseMsg?.dayPrice == nil || FYModel?.houseMsg?.dayPrice?.isBlankString == true{
            AppUtilities.makeToast("请输入租金单价")
            return
        }else {
            params["dayPrice"] = FYModel?.houseMsg?.dayPrice as AnyObject?
        }
        
        //MARK: 租金总价
        if FYModel?.houseMsg?.monthPrice == nil || FYModel?.houseMsg?.monthPrice?.isBlankString == true{
            AppUtilities.makeToast("请输入租金总价")
            return
        }else {
            params["monthPrice"] = FYModel?.houseMsg?.area as AnyObject?
        }
        
         //MARK: 所在楼层 - 第几层- 总楼层
        if FYModel?.houseMsg?.floor == nil || FYModel?.houseMsg?.floor?.isBlankString == true{
            AppUtilities.makeToast("请输入所在楼层")
            return
        }else {
            params["floor"] = FYModel?.houseMsg?.floor as AnyObject?
        }
        
        
        //MARK: 净高
        if FYModel?.houseMsg?.clearHeight == nil || FYModel?.houseMsg?.clearHeight?.isBlankString == true{
            AppUtilities.makeToast("请输入净高")
            return
        }else {
            params["clearHeight"] = FYModel?.houseMsg?.clearHeight as AnyObject?
        }
    
        //MARK: 层高 - 非
        if FYModel?.houseMsg?.storeyHeight == nil || FYModel?.houseMsg?.storeyHeight?.isBlankString == true{
            //AppUtilities.makeToast("请输入层高")
            //return
        }else {
            params["storeyHeight"] = FYModel?.houseMsg?.storeyHeight as AnyObject?
        }
        
        //MARK: 最短租期
        if FYModel?.houseMsg?.minimumLease == nil || FYModel?.houseMsg?.minimumLease?.isBlankString == true{
            AppUtilities.makeToast("请输入最短租期")
            return
        }else {
            params["minimumLease"] = FYModel?.houseMsg?.minimumLease as AnyObject?
        }
        
        
        //MARK: 免租期
        if FYModel?.houseMsg?.rentFreePeriod == nil || FYModel?.houseMsg?.rentFreePeriod.isBlankString == true{
            AppUtilities.makeToast("请选择免租期")
            return
        }else {
            params["rentFreePeriod"] = FYModel?.houseMsg?.rentFreePeriod as AnyObject?
        }
        
        //MARK: 物业费
        if FYModel?.houseMsg?.propertyHouseCosts == nil || FYModel?.houseMsg?.propertyHouseCosts?.isBlankString == true{
            AppUtilities.makeToast("请输入物业费")
            return
        }else {
            params["propertyHouseCosts"] = FYModel?.houseMsg?.propertyHouseCosts as AnyObject?
        }
        
        
        //MARK: 装修类型
        if let decoration = FYModel?.houseMsg?.decoration {
            params["decoration"] = FYModel?.houseMsg?.decoration as AnyObject?
        }else {
            AppUtilities.makeToast("请选择装修类型")
            return
        }


        
        //MARK: 户型介绍 - 非
        params["unitPatternRemark"] = FYModel?.houseMsg?.unitPatternRemark as AnyObject?

        
        //MARK: 户型介绍 - 图片 - 非
        params["unitPatternImg"] = FYModel?.houseMsg?.unitPatternImg as AnyObject?

        
        //MARK: 办公室特色 - 非
        if let tagsLocal = FYModel?.houseMsg?.tagsLocal {
            var deleteArr: [String] = []
            for model in tagsLocal {
                if model.isDocumentSelected == true {
                    deleteArr.append("\(model.dictValue ?? 0)")
                }
            }
            params["tags"] = deleteArr.joined(separator: ",") as AnyObject?
        }
        
        //MARK: 办公室图片
        if let buildingDeleteRemoteArr = FYModel?.buildingDeleteRemoteArr {
            var deleteArr: [String] = []
            for model in buildingDeleteRemoteArr {
                deleteArr.append(model.imgUrl ?? "")
            }
            params["delImgUrl"] = deleteArr.joined(separator: ",") as AnyObject?
        }
        
        if let buildingLocalImgArr = FYModel?.buildingLocalImgArr {
            if buildingLocalImgArr.count <= 0 {
                AppUtilities.makeToast("请上传办公室图片")
                return
            }else {
                var deleteArr: [String] = []
                for model in buildingLocalImgArr {
                    if model.isMain != true {
                        deleteArr.append(model.imgUrl ?? "")
                    }else {
                        params["mainPic"] = model.imgUrl as AnyObject?
                    }
                }
                params["addImgUrl"] = deleteArr.joined(separator: ",") as AnyObject?
            }
        }else {
            AppUtilities.makeToast("请上传办公室图片")
            return
        }
        
        SSNetworkTool.SSFYManager.request_getEditHouse(params: params, success: {[weak self] (response) in
            
            self?.clickToPublish()
            
            }, failure: { (error) in
                
                
        }) { (code, message) in
            
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
        
        
        ///网络展示回显 - 名称匹配
        let idd = FYModel?.houseMsg?.decoration
        if let internetLocal = FYModel?.houseMsg?.decoratesLocal {
           for dic in internetLocal {
                if idd == dic.dictValue {
                    dic.isOfficeBuildingSelected = true
                }
            }
        }
        
        
        ///特色展示回显 - id匹配
        let requestFeatureArr = FYModel?.houseMsg?.tags?.split{$0 == ","}.map(String.init)
        if let networkArr = requestFeatureArr, let internetLocal = FYModel?.houseMsg?.tagsLocal {
            if networkArr.count > 0 && internetLocal.count > 0 {
                for network in networkArr {
                    
                    for dic in internetLocal {
                        if network == "\(dic.dictValue ?? 0)" {
                            dic.isDocumentSelected = true
                        }
                    }
                }
            }
        }
        
        
        if let img = FYModel?.houseMsg?.unitPatternImg {
            if img.isBlankString != true {
                FYModel?.houseMsg?.unitPatternImgArr.imgUrl = img
            }
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
        
        if let simple = FYModel?.houseMsg?.simple {
            if simple.isBlankString != true {
                let simpleArr = FYModel?.houseMsg?.simple?.split{$0 == ","}.map(String.init)
                if simpleArr?.count == 2 {
                    FYModel?.houseMsg?.minSeatsOffice = simpleArr?[0]
                    FYModel?.houseMsg?.maxSeatsOffice = simpleArr?[1]
                }
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
            cell?.FYModel = FYModel ?? FangYuanHouseEditModel()
            cell?.officeModel = model
            return cell ?? OwnerBuildingClickCell.init(frame: .zero)
            
        ///所在楼层
        case .OwnerBuildingOfficeTypeTotalFloor:
            if indexPath.row == 0 {
                ///点击cell
                let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingClickCell.reuseIdentifierStr) as? OwnerBuildingClickCell
                cell?.selectionStyle = .none
                cell?.FYModel = FYModel ?? FangYuanHouseEditModel()
                cell?.officeModel = model
                return cell ?? OwnerBuildingClickCell.init(frame: .zero)
            }else {
                
                ///文本输入cell
                let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingFYFloorCell.reuseIdentifierStr) as? OwnerBuildingFYFloorCell
                cell?.selectionStyle = .none
                cell?.FYModel = FYModel ?? FangYuanHouseEditModel()
                cell?.officeModel = model
                return cell ?? OwnerBuildingFYFloorCell.init(frame: .zero)
                
            }
            
            
            
            ///文本输入cell
        ///标题
        case .OwnerBuildingOfficeTypeName:
            
            ///文本输入cell
            let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingInputCell.reuseIdentifierStr) as? OwnerBuildingInputCell
            cell?.selectionStyle = .none
            cell?.FYModel = FYModel ?? FangYuanHouseEditModel()
            cell?.officeModel = model
            return cell ?? OwnerBuildingInputCell.init(frame: .zero)
            
            
            
            ///正数字文本输入cell
        ///最短租期
        ///租金单价 -
        case .OwnerBuildingOfficeTypeMinRentalPeriod, .OwnerBuildingOfficeTypePrice:
            
            ///数字文本输入cell
            let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingNumInputCell.reuseIdentifierStr) as? OwnerBuildingNumInputCell
            cell?.selectionStyle = .none
            cell?.FYModel = FYModel ?? FangYuanHouseEditModel()
            cell?.officeModel = model
            return cell ?? OwnerBuildingNumInputCell.init(frame: .zero)
            
            
            ///数字 - 一位小数点文本输入cell
            ///建筑面积 - 两位
            ///净高
            ///层高
            ///物业费
        case .OwnerBuildingOfficeTypeArea, .OwnerBuildingOfficeTypeClearHeight, .OwnerBuildingOfficeTypeFloorHeight, .OwnerBuildingOfficeTypePropertyCoast:
            
            ///数字文本输入cell
            let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingDecimalNumInputCell.reuseIdentifierStr) as? OwnerBuildingDecimalNumInputCell
            cell?.selectionStyle = .none
            cell?.FYModel = FYModel ?? FangYuanHouseEditModel()
            cell?.officeModel = model
            cell?.endEditingFYMessageCell = { [weak self] (model) in
                self?.FYModel = model
                self?.loadSections(indexSet: [indexPath.section, indexPath.section + 1])
            }
            return cell ?? OwnerBuildingDecimalNumInputCell.init(frame: .zero)
            
            
        ///租金总价 - 两位
        case .OwnerBuildingOfficeTypeTotalPrice:
            
            ///数字文本输入cell
            let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingFYRenterTotalPriceCell.reuseIdentifierStr) as? OwnerBuildingFYRenterTotalPriceCell
            cell?.selectionStyle = .none
            cell?.FYModel = FYModel ?? FangYuanHouseEditModel()
            cell?.officeModel = model
            cell?.endEditingFYMessageCell = { [weak self] (FYModel) in
                self?.FYModel = FYModel
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
                
                if let dayPrice = self?.FYModel?.houseMsg?.dayPrice, let areaOffice = self?.FYModel?.houseMsg?.area {
                    if dayPrice.isBlankString != true && areaOffice.isBlankString != true {
                        
                        ///单价 x 面积 x 30
                        let price = (Double(dayPrice) ?? 0) * (Double(areaOffice) ?? 0) * 30
                        self?.FYModel?.houseMsg?.monthPriceTemp = "\(price)"
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
                 if self?.FYModel?.totalPrice != nil && self?.FYModel?.totalPrice?.isBlankString != true {
                 
                 }else {
                 
                 
                 }*/
                
            }
            return cell ?? OwnerBuildingFYRenterTotalPriceCell.init(frame: .zero)
            
            
        ///可置工位
        case .OwnerBuildingOfficeTypeSeats:
            ///数字文本输入cell
            let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingFYCanSeatsCell.reuseIdentifierStr) as? OwnerBuildingFYCanSeatsCell
            cell?.selectionStyle = .none
            cell?.FYModel = FYModel ?? FangYuanHouseEditModel()
            cell?.officeModel = model
            cell?.endEditingFYMessageCell = { [weak self] (FYModel) in
                self?.FYModel = FYModel
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
            cell?.ISFY = true
            cell?.isMutTags = false
            cell?.isMutNetworks = false
            cell?.isSimpleDocument = true
            cell?.FYModel = self.FYModel ?? FangYuanHouseEditModel()
            return cell ?? OwnerBuildingNetworkSelectCell.init(frame: .zero)
            
        ///户型格局简介
        case .OwnerBuildingOfficeTypeIntrodution:
            let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingFYIntroductionCell.reuseIdentifierStr) as? OwnerBuildingFYIntroductionCell
            cell?.selectionStyle = .none
            cell?.FYModel = self.FYModel ?? FangYuanHouseEditModel()
            return cell ?? OwnerBuildingFYIntroductionCell.init(frame: .zero)
            
        ///特色
        case .OwnerBuildingOfficeTypeFeature:
            let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingNetworkSelectCell.reuseIdentifierStr) as? OwnerBuildingNetworkSelectCell
            cell?.selectionStyle = .none
            cell?.categoryTitleLabel.attributedText = model.getNameFormType(type: model.type ?? OwnerBuildingOfficeType.OwnerBuildingOfficeTypeFeature)
            cell?.ISFY = true
            cell?.isMutTags = true
            cell?.isMutNetworks = false
            cell?.isSimpleDocument = false
            cell?.FYModel = self.FYModel ?? FangYuanHouseEditModel()
            return cell ?? OwnerBuildingNetworkSelectCell.init(frame: .zero)
            
        ///上传楼盘图片
        case .OwnerBuildingOfficeTypeBuildingImage:
            let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingImgCell.reuseIdentifierStr) as? OwnerBuildingImgCell
            cell?.selectionStyle = .none
            cell?.FYModel = self.FYModel ?? FangYuanHouseEditModel()
            cell?.officeModel = model
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
                if FYModel?.houseMsg?.floorType == "1" || FYModel?.houseMsg?.floorType == "2" {
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
        ///租金单价 -
        case .OwnerBuildingOfficeTypeMinRentalPeriod, .OwnerBuildingOfficeTypePrice:
            
            return BaseEditCell.rowHeight()
            
            
            ///数字 - 一位小数点文本输入cell
            ///建筑面积 - 两位
            ///净高
            ///层高
            ///物业费
        case .OwnerBuildingOfficeTypeArea, .OwnerBuildingOfficeTypeClearHeight, .OwnerBuildingOfficeTypeFloorHeight, .OwnerBuildingOfficeTypePropertyCoast:
            
            return BaseEditCell.rowHeight()
            
        ///租金总价 - 两位
        case  .OwnerBuildingOfficeTypeTotalPrice:
            
            return BaseEditCell.rowHeight()
            
        ///可置工位
        case .OwnerBuildingOfficeTypeSeats:
            
            return BaseEditCell.rowHeight()
            
        ///装修程度
        case .OwnerBuildingOfficeTypeDocument:
            if let arr = FYModel?.houseMsg?.decoratesLocal {
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
            if let arr = FYModel?.houseMsg?.tagsLocal {
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
            
            ownerFYMoreSettingView.ShowOwnerSettingView(datasource: rentFreePeriodArr, clearButtonCallBack: {
                                                                            
            }) {[weak self] (settingEnumIndex) in
                self?.FYModel?.houseMsg?.rentFreePeriod = self?.rentFreePeriodArr[settingEnumIndex] as! String
                //单层1 多层2
                self?.loadSections(indexSet: [indexPath.section])
            }
            
        ///所在楼层
        case .OwnerBuildingOfficeTypeTotalFloor:
            
            if indexPath.row == 0 {
                
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
        case .OwnerBuildingOfficeTypeName:
            
            SSLog(typeSourceArray[indexPath.section].type)
            
            ///正数字文本输入cell
        ///最短租期
        ///租金总价 -
        case .OwnerBuildingOfficeTypeMinRentalPeriod, .OwnerBuildingOfficeTypeTotalPrice:
            
            SSLog(typeSourceArray[indexPath.section].type)
            
            
            ///数字 - 一位小数点文本输入cell
            ///建筑面积 - 两位
            ///净高
            ///层高
            ///物业费
            ///租金单价 - 两位
        case .OwnerBuildingOfficeTypeArea, .OwnerBuildingOfficeTypeClearHeight, .OwnerBuildingOfficeTypeFloorHeight, .OwnerBuildingOfficeTypePropertyCoast, .OwnerBuildingOfficeTypePrice:
            
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




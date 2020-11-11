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
import CLImagePickerTool

class OwnerBuildingCreateViewController: BaseTableViewController {
    
    lazy var fczImagePickTool: CLImagePickerTool = {
        let picker = CLImagePickerTool()
        picker.cameraOut = true
        picker.isHiddenVideo = true
        return picker
    }()
    
    
    ///来自编辑还是添加
    var isFromAdd: Bool?
    
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
    var typeSourceArray:[OwnerBuildingEditConfigureModel] = [OwnerBuildingEditConfigureModel]()
    
    ///入住公司数组
    var companyArr: [String] = [""]
    
    var isTemp: Bool?
    
    ///
    var buildingModel: FangYuanBuildingEditModel?
    
    lazy var saveBtn: UIButton = {
        let button = UIButton.init()
        button.clipsToBounds = true
        button.layer.cornerRadius = button_cordious_2
        button.backgroundColor = kAppBlueColor
        button.titleLabel?.font = FONT_MEDIUM_16
        button.setTitleColor(kAppWhiteColor, for: .normal)
        button.setTitle("保存，下一步", for: .normal)
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
        
        endEdting()

        request_getUpdateBuilding()
    }
    
    func clickToPublish() {
        let vc = OwnerBuildingCreateVideoVRViewController()
        vc.isBuilding = true
        vc.isClose = isClose
        buildingModel?.isTemp = isTemp
        vc.buildingModel = buildingModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func pcEditClick() {
        
        endEdting()

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
        ///楼号/楼名
        typeSourceArray.append(OwnerBuildingEditConfigureModel.init(types: .OwnerBuildingEditTypeBuildingNum))
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
        
        ///来自添加
        if isFromAdd == true {
            
            buildingModel = FangYuanBuildingEditModel()
                    
            buildingModel?.buildingMsg = FangYuanBuildingMsgEditModel()                    
            
            request_getDistrict()

        }else {
            
            request_getEditBuilding()
            
        }
        
        
    }
    
    //MARK: 获取特色接口
    func requestGetFeature() {
        
        SSNetworkTool.SSBasic.request_getDictionary(code: .codeEnumbuildingUnique, success: { [weak self] (response) in
            guard let weakSelf = self else {return}
            if let decoratedArray = JSONDeserializer<HouseFeatureModel>.deserializeModelArrayFrom(json: JSON(response).rawString() ?? "", designatedPath: "data") {
                for model in decoratedArray {
                    weakSelf.buildingModel?.buildingMsg?.tagsLocal.append(model ?? HouseFeatureModel())
                }
            }else {
                weakSelf.buildingModel = FangYuanBuildingEditModel()
                
                weakSelf.buildingModel?.buildingMsg = FangYuanBuildingMsgEditModel()
            }
            
            weakSelf.dealData()
            
            }, failure: {[weak self] (error) in
                self?.buildingModel = FangYuanBuildingEditModel()
                self?.buildingModel?.buildingMsg = FangYuanBuildingMsgEditModel()
                self?.dealData()
                
        }) {[weak self] (code, message) in
            
            self?.buildingModel = FangYuanBuildingEditModel()
            self?.buildingModel?.buildingMsg = FangYuanBuildingMsgEditModel()
            self?.dealData()
            
            //只有5000 提示给用户
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" {
                AppUtilities.makeToast(message)
            }
        }
    }
    
    
    func dealData() {

        ///添加网络数据
        let model1 = HouseFeatureModel()
        model1.dictCname = "电信"
        buildingModel?.buildingMsg?.internetLocal.append(model1)
        
        let model2 = HouseFeatureModel()
        model2.dictCname = "联通"
        buildingModel?.buildingMsg?.internetLocal.append(model2)
        
        let model3 = HouseFeatureModel()
        model3.dictCname = "移动"
        buildingModel?.buildingMsg?.internetLocal.append(model3)
        
        
        ///写字楼，创意园，产业园 写字楼1,创意园3,产业园6
        if buildingModel?.buildingMsg?.buildingType == 1 {
            buildingModel?.buildingMsg?.buildingTypeEnum = .xieziEnum
        }else if buildingModel?.buildingMsg?.buildingType == 3 {
            buildingModel?.buildingMsg?.buildingTypeEnum = .chuangyiEnum
        }else if buildingModel?.buildingMsg?.buildingType == 6 {
            buildingModel?.buildingMsg?.buildingTypeEnum = .chanyeEnum
        }
        
        /*
        空调
        中央空调 0
        独立空调 1
        无空调 2
        */
        if buildingModel?.buildingMsg?.airConditioning == OwnerAircontiditonType.OwnerAircontiditonTypeDefault.rawValue {
            buildingModel?.buildingMsg?.airditionType = OwnerAircontiditonType.OwnerAircontiditonTypeDefault
        }else if buildingModel?.buildingMsg?.airConditioning == OwnerAircontiditonType.OwnerAircontiditonTypeCenter.rawValue {
            buildingModel?.buildingMsg?.airditionType = OwnerAircontiditonType.OwnerAircontiditonTypeCenter
        }else if buildingModel?.buildingMsg?.airConditioning == OwnerAircontiditonType.OwnerAircontiditonTypeIndividual.rawValue {
            buildingModel?.buildingMsg?.airditionType = OwnerAircontiditonType.OwnerAircontiditonTypeIndividual
        }else if buildingModel?.buildingMsg?.airConditioning == OwnerAircontiditonType.OwnerAircontiditonTypeNone.rawValue {
            buildingModel?.buildingMsg?.airditionType = OwnerAircontiditonType.OwnerAircontiditonTypeNone
        }
        
        
        ///网络展示回显 - 名称匹配
        let requestNetworkArr = buildingModel?.buildingMsg?.internet?.split{$0 == ","}.map(String.init)
        if let networkArr = requestNetworkArr, let internetLocal = buildingModel?.buildingMsg?.internetLocal {
            if networkArr.count > 0 && internetLocal.count > 0 {
                for network in networkArr {
                    
                    for dic in internetLocal {
                        if network == dic.dictCname {
                            dic.isOfficeBuildingSelected = true
                        }
                    }
                }
            }
        }
        
        
        ///特色展示回显 - id匹配
        let requestFeatureArr = buildingModel?.buildingMsg?.tags?.split{$0 == ","}.map(String.init)
        if let networkArr = requestFeatureArr, let internetLocal = buildingModel?.buildingMsg?.tagsLocal {
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
        
        ///入住企业展示回显
        let requestSettlementLicenceArr = buildingModel?.buildingMsg?.settlementLicence?.split{$0 == ","}.map(String.init)
        if let networkArr = requestSettlementLicenceArr {
            for company in networkArr {
                companyArr.insert(company, at: companyArr.count - 1)
            }
        }
        if companyArr.count >= enterCompanyMaxNum_5 {
            companyArr.remove(at: companyArr.count - 1)
        }
        
        ///添加banner数据
        if let arr = buildingModel?.banner {
            
            for fczBannerModel in arr {
                fczBannerModel.isLocal = false
                fczBannerModel.isMain = false
                buildingModel?.buildingLocalImgArr.append(fczBannerModel)
            }
        }
        ///添加封面图
        if let url = buildingModel?.buildingMsg?.mainPic {

            let mainPicModel = BannerModel()
            mainPicModel.imgUrl = url
            mainPicModel.isLocal = false
            mainPicModel.isMain = true
            buildingModel?.buildingLocalImgArr.insert(mainPicModel, at: 0)
        }
        
        
        ///添加vr数据
        if let arr = buildingModel?.vr {
            
            for fczBannerModel in arr {
                buildingModel?.vrUrl = fczBannerModel.imgUrl
                break
            }
        }
        
        
        
        ///刷新列表
        loadTableview()
    }
    
    
    //MARK: 获取商圈数据
    func request_getDistrict() {
        //查询类型，1：全部，0：系统已有楼盘的商圈
        var params = [String:AnyObject]()
        params["type"] = 1 as AnyObject?
        SSNetworkTool.SSBasic.request_getDistrictList(params: params, success: { [weak self] (response) in
            if let model = CityAreaCategorySelectModel.deserialize(from: response) {
                model.name = "上海市"
                self?.areaModelCount = model
                self?.getSelectedDistrictBusiness()
            }
            self?.requestGetFeature()
            }, failure: {[weak self] (error) in
                self?.requestGetFeature()
        }) {[weak self]  (code, message) in
            self?.requestGetFeature()
            //只有5000 提示给用户
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" {
                AppUtilities.makeToast(message)
            }
        }
    }
    
    //MARK: 获取详情 request_getEditBuilding
    func request_getEditBuilding() {
        
        var params = [String:AnyObject]()
        params["token"] = UserTool.shared.user_token as AnyObject?
        params["buildingId"] = buildingModel?.buildingId as AnyObject? //7661
        params["isTemp"] = buildingModel?.isTemp as AnyObject? //0
        
        SSNetworkTool.SSFYManager.request_getBuildingMsg(params: params, success: {[weak self] (response) in
            guard let weakSelf = self else {return}
            if let model = FangYuanBuildingEditModel.deserialize(from: response, designatedPath: "data") {
                weakSelf.buildingModel = model
                
            }
            weakSelf.request_getDistrict()
            
            }, failure: {[weak self] (error) in
                self?.request_getDistrict()
                
        }) {[weak self] (code, message) in
            self?.request_getDistrict()
            
            //只有5000 提示给用户
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" {
                AppUtilities.makeToast(message)
            }
        }
    }
    
    ///提交接口
    func request_getUpdateBuilding() {

        var params = [String:AnyObject]()

        params["token"] = UserTool.shared.user_token as AnyObject?

        params["isTemp"] = isTemp as AnyObject?

        //MARK: 楼id
        if buildingModel?.buildingMsg?.id == nil {
            AppUtilities.makeToast("请选择或创建楼盘")
            //return
        }else {
            params["buildingId"] = buildingModel?.buildingMsg?.id as AnyObject?
        }

        //MARK: 楼盘类型
        if buildingModel?.buildingMsg?.buildingTypeEnum == nil{
            AppUtilities.makeToast("请选择楼盘类型")
            return
        }else {
            ///写字楼 - 只传名字
            ///写字楼，创意园，产业园 写字楼1,创意园3,产业园6
            if buildingModel?.buildingMsg?.buildingTypeEnum == .xieziEnum {
                if buildingModel?.buildingMsg?.buildingName == nil || buildingModel?.buildingMsg?.buildingName?.isBlankString == true{
                    AppUtilities.makeToast("请输入写字楼名称")
                    return
                }else {
                    params["buildingType"] = 1 as AnyObject?
                    params["buildingName"] = buildingModel?.buildingMsg?.buildingName as AnyObject?
                }
            }
            ///园区 - 楼名 - 楼号
            else if buildingModel?.buildingMsg?.buildingTypeEnum == .chuangyiEnum {

                if buildingModel?.buildingMsg?.buildingName == nil || buildingModel?.buildingMsg?.buildingName?.isBlankString == true{
                    AppUtilities.makeToast("请输入园区名称")
                    return
                }else {
                    params["buildingType"] = 3 as AnyObject?
                    params["buildingName"] = buildingModel?.buildingMsg?.buildingName as AnyObject?
                }
                if buildingModel?.buildingMsg?.buildingNum == nil || buildingModel?.buildingMsg?.buildingNum?.isBlankString == true{
                    AppUtilities.makeToast("请输入楼号")
                    return
                }else {
                    params["buildingNum"] = buildingModel?.buildingMsg?.buildingNum as AnyObject?
                }
            }
            ///园区 - 产业园
            else if buildingModel?.buildingMsg?.buildingTypeEnum == .chanyeEnum {

                if buildingModel?.buildingMsg?.buildingName == nil || buildingModel?.buildingMsg?.buildingName?.isBlankString == true{
                    AppUtilities.makeToast("请输入园区名称")
                    return
                }else {
                    params["buildingType"] = 6 as AnyObject?
                    params["buildingName"] = buildingModel?.buildingMsg?.buildingName as AnyObject?
                }
                if buildingModel?.buildingMsg?.buildingNum == nil || buildingModel?.buildingMsg?.buildingNum?.isBlankString == true{
                    AppUtilities.makeToast("请输入楼号")
                    return
                }else {
                    params["buildingNum"] = buildingModel?.buildingMsg?.buildingNum as AnyObject?
                }
            }
        }

        //MARK: 所在区域
        if areaModelCount?.isFirstSelectedModel?.districtID == nil || areaModelCount?.isFirstSelectedModel?.districtID?.isBlankString == true{
            AppUtilities.makeToast("请选择所在区域")
            return
        }else {
            params["districtId"] = buildingModel?.buildingMsg?.districtId as AnyObject?
            params["businessDistrict"] = buildingModel?.buildingMsg?.businessDistrict as AnyObject?
        }
        
        //MARK: 详细地址
        if buildingModel?.buildingMsg?.address == nil || buildingModel?.buildingMsg?.address?.isBlankString == true{
            AppUtilities.makeToast("请输入详细地址")
            return
        }else {
            params["address"] = buildingModel?.buildingMsg?.address as AnyObject?
        }
        
         //MARK: 总楼层
        if buildingModel?.buildingMsg?.totalFloor == nil || buildingModel?.buildingMsg?.totalFloor?.isBlankString == true{
            AppUtilities.makeToast("请输入总楼层")
            return
        }else {
            params["floorType"] = buildingModel?.buildingMsg?.floorType as AnyObject?
            params["totalFloor"] = buildingModel?.buildingMsg?.totalFloor as AnyObject?
        }
        
        //MARK: 竣工时间
        if buildingModel?.buildingMsg?.completionTime == nil || buildingModel?.buildingMsg?.completionTime?.isBlankString == true{
            AppUtilities.makeToast("请输入竣工时间")
            return
        }else {
            params["completionTime"] = buildingModel?.buildingMsg?.completionTime as AnyObject?
        }
        
        //MARK: 翻新时间 - 非
        if buildingModel?.buildingMsg?.refurbishedTime == nil || buildingModel?.buildingMsg?.refurbishedTime?.isBlankString == true{
            //AppUtilities.makeToast("请输入翻新时间")
            //return
            params["refurbishedTime"] = "" as AnyObject?
        }else {
            params["refurbishedTime"] = buildingModel?.buildingMsg?.refurbishedTime as AnyObject?
        }
        
        //MARK: 建筑面积 - 非
        if buildingModel?.buildingMsg?.constructionArea == nil || buildingModel?.buildingMsg?.constructionArea?.isBlankString == true{
            //AppUtilities.makeToast("请输入建筑面积")
            //return
            params["constructionArea"] = "" as AnyObject?
        }else {
            params["constructionArea"] = buildingModel?.buildingMsg?.constructionArea as AnyObject?
        }
        
        //MARK: 净高
        if buildingModel?.buildingMsg?.clearHeight == nil || buildingModel?.buildingMsg?.clearHeight?.isBlankString == true{
            AppUtilities.makeToast("请输入净高")
            return
        }else {
            params["clearHeight"] = buildingModel?.buildingMsg?.clearHeight as AnyObject?
        }
        
        //MARK: 层高 - 非
        if buildingModel?.buildingMsg?.storeyHeight == nil || buildingModel?.buildingMsg?.storeyHeight?.isBlankString == true{
            //AppUtilities.makeToast("请输入层高")
            //return
            params["storeyHeight"] = "" as AnyObject?
        }else {
            params["storeyHeight"] = buildingModel?.buildingMsg?.storeyHeight as AnyObject?
        }
        
        //MARK: 物业公司
        if buildingModel?.buildingMsg?.property == nil || buildingModel?.buildingMsg?.property?.isBlankString == true{
            AppUtilities.makeToast("请输入物业公司")
            return
        }else {
            params["property"] = buildingModel?.buildingMsg?.property as AnyObject?
        }
        
        //MARK: 物业费
        if buildingModel?.buildingMsg?.propertyCosts == nil || buildingModel?.buildingMsg?.propertyCosts?.isBlankString == true{
            AppUtilities.makeToast("请输入物业费")
            return
        }else {
            params["propertyCosts"] = buildingModel?.buildingMsg?.propertyCosts as AnyObject?
        }
        
        //MARK: 车位数
        if buildingModel?.buildingMsg?.parkingSpace == nil || buildingModel?.buildingMsg?.parkingSpace?.isBlankString == true{
            AppUtilities.makeToast("请输入车位数")
            return
        }else {
            params["parkingSpace"] = buildingModel?.buildingMsg?.parkingSpace as AnyObject?
        }
        
        //MARK: 车位费 - 非
        if buildingModel?.buildingMsg?.parkingSpaceRent == nil || buildingModel?.buildingMsg?.parkingSpaceRent?.isBlankString == true{
            //AppUtilities.makeToast("请输入车位费")
            //return
            params["parkingSpaceRent"] = "" as AnyObject?
        }else {
            params["parkingSpaceRent"] = buildingModel?.buildingMsg?.parkingSpaceRent as AnyObject?
        }
        
        //MARK: 空调类型
        if buildingModel?.buildingMsg?.airditionType == nil || buildingModel?.buildingMsg?.airditionType == .OwnerAircontiditonTypeDefault {
            AppUtilities.makeToast("请输入空调类型")
            return
        }else {
            params["airConditioning"] = buildingModel?.buildingMsg?.airditionType?.rawValue as AnyObject?
            if buildingModel?.buildingMsg?.airditionType == OwnerAircontiditonType.OwnerAircontiditonTypeCenter {
                params["airConditioningFee"] = OwnerAircontiditonFeeType.OwnerAircontiditonFeeTypeCenter.rawValue as AnyObject
            }else if buildingModel?.buildingMsg?.airditionType == OwnerAircontiditonType.OwnerAircontiditonTypeIndividual{
                params["airConditioningFee"] = OwnerAircontiditonFeeType.OwnerAircontiditonFeeTypeIndividual.rawValue as AnyObject
            }else if buildingModel?.buildingMsg?.airditionType == OwnerAircontiditonType.OwnerAircontiditonTypeNone {
                params["airConditioningFee"] = OwnerAircontiditonFeeType.OwnerAircontiditonFeeTypeNone.rawValue as AnyObject
            }
        }
        
        //MARK: 电梯数 - 客梯
        if buildingModel?.buildingMsg?.passengerLift == nil || buildingModel?.buildingMsg?.passengerLift?.isBlankString == true{
            AppUtilities.makeToast("请输入客梯数")
            return
        }else {
            params["passengerLift"] = buildingModel?.buildingMsg?.passengerLift as AnyObject?
        }
        
        //MARK: 电梯数 - 货梯
        if buildingModel?.buildingMsg?.cargoLift == nil || buildingModel?.buildingMsg?.cargoLift?.isBlankString == true{
            AppUtilities.makeToast("请输入货梯数")
            return
        }else {
            params["cargoLift"] = buildingModel?.buildingMsg?.cargoLift as AnyObject?
        }

        //MARK: 网络 - 非
        if let internetLocal = buildingModel?.buildingMsg?.internetLocal {
            var deleteArr: [String] = []
            for model in internetLocal {
                if model.isOfficeBuildingSelected == true {
                    deleteArr.append(model.dictCname ?? "")
                }
            }
            params["internet"] = deleteArr.joined(separator: ",") as AnyObject?
        }else {
            params["internet"] = "" as AnyObject?
        }
        
        //MARK: 入驻企业 - 非
        params["settlementLicence"] = companyArr.joined(separator: ",") as AnyObject?

        //MARK: 详细介绍 - 非
        params["buildingIntroduction"] = buildingModel?.buildingMsg?.buildingIntroduction as AnyObject?

        //MARK: 楼盘特色 - 非
        if let tagsLocal = buildingModel?.buildingMsg?.tagsLocal {
            var deleteArr: [String] = []
            for model in tagsLocal {
                if model.isDocumentSelected == true {
                    deleteArr.append("\(model.dictValue ?? 0)")
                }
            }
            params["tags"] = deleteArr.joined(separator: ",") as AnyObject?
        }else {
            params["tags"] = "" as AnyObject?
        }
        
        //MARK: 楼盘图片
        if let buildingDeleteRemoteArr = buildingModel?.buildingDeleteRemoteArr {
            var deleteArr: [String] = []
            for model in buildingDeleteRemoteArr {
                deleteArr.append(model.imgUrl ?? "")
            }
            params["delImgUrl"] = deleteArr.joined(separator: ",") as AnyObject?
        }
        
        if let buildingLocalImgArr = buildingModel?.buildingLocalImgArr {
            if buildingLocalImgArr.count <= 0 {
                AppUtilities.makeToast("请上传楼盘图片")
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
            AppUtilities.makeToast("请上传楼盘图片")
            return
        }

        SSNetworkTool.SSFYManager.request_getUpdateBuilding(params: params, success: {[weak self] (response) in
            
            self?.clickToPublish()
            
            }, failure: { (error) in
                
                
        }) { (code, message) in
            
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
        if isFromAdd == true {
            titleview?.titleLabel.text = "添加楼盘"
        }else {
            titleview?.titleLabel.text = "编辑楼盘"
        }
        titleview?.leftButtonCallBack = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        titleview?.rightBtnClickBlock = { [weak self] in
            let vc = OwnerBuildingCreateViewController()
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
    
    
    func loadEnterCompany(section: Int, index: Int) {
        endEdting()
        if index == companyArr.count - 1 {
            if companyArr.count < enterCompanyMaxNum_5 {
                companyArr.append("")
            }else {
                AppUtilities.makeToast("最多能添\(enterCompanyMaxNum_5)个入住企业")
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

extension OwnerBuildingCreateViewController {
    func judgeHasData(section: Int) {
        if areaModelCount?.data.count ?? 0  > 0 {
            self.showArea(section: section, isFrist: true)
        }else {
            request_getDistrict()
        }
    }
    
    func showArea(section: Int, isFrist: Bool) {
        areaView.ShowCityDistrictAddressSelectView(isfirst: isFrist, model: self.areaModelCount ?? CityAreaCategorySelectModel(), clearButtonCallBack: { (_ selectModel: CityAreaCategorySelectModel) -> Void in
            
        }, sureAreaaddressButtonCallBack: { [weak self] (_ selectModel: CityAreaCategorySelectModel) -> Void in
            self?.areaModelCount = selectModel
            self?.buildingModel?.buildingMsg?.districtId = selectModel.isFirstSelectedModel?.districtID
            self?.buildingModel?.buildingMsg?.businessDistrict = selectModel.isFirstSelectedModel?.isSencondSelectedModel?.id
            self?.buildingModel?.buildingMsg?.districtString = "\(selectModel.name ?? "上海市")\(selectModel.isFirstSelectedModel?.district ?? "")"
            self?.buildingModel?.buildingMsg?.businessString = "\(selectModel.isFirstSelectedModel?.isSencondSelectedModel?.area ?? "")"
            self?.loadSecion(section: section)
            
        })
    }
    
    func getSelectedDistrictBusiness() {
        areaModelCount?.data.forEach({ (model) in
            if model.districtID == buildingModel?.buildingMsg?.districtId {
                areaModelCount?.isFirstSelectedModel = model
                buildingModel?.buildingMsg?.districtString = "\(areaModelCount?.name ?? "上海市")\(model.district ?? "")"
                areaModelCount?.isFirstSelectedModel?.list.forEach({ (areaModel) in
                    if areaModel.id == buildingModel?.buildingMsg?.businessDistrict {
                        areaModelCount?.isFirstSelectedModel?.isSencondSelectedModel = areaModel
                        buildingModel?.buildingMsg?.businessString = areaModel.area
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

extension OwnerBuildingCreateViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return typeSourceArray.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        ///入住企业
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
            cell?.buildingModel = buildingModel ?? FangYuanBuildingEditModel()
            cell?.model = model
            return cell ?? OwnerBuildingClickCell.init(frame: .zero)
            
            ///竣工时间
        ///翻新时间
        case .OwnerBuildingEditTypeCompelteTime, .OwnerBuildingEditTypeRenovationTime:
            
            ///点击cell
            let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingDateClickCell.reuseIdentifierStr) as? OwnerBuildingDateClickCell
            cell?.selectionStyle = .none
            cell?.buildingModel = buildingModel ?? FangYuanBuildingEditModel()
            cell?.model = model
            return cell ?? OwnerBuildingDateClickCell.init(frame: .zero)
            
            
            ///文本输入cell
            ///写字楼名称
            ///楼号/楼名
            ///详细地址
        ///物业公司
        ///车位数
        case .OwnerBuildingEditTypeBuildingName, .OwnerBuildingEditTypeBuildingNum, .OwnerBuildingEditTypeDetailAddress, .OwnerBuildingEditTypePropertyCompany, .OwnerBuildingEditTypeParkingNum:
            
            ///文本输入cell
            let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingInputCell.reuseIdentifierStr) as? OwnerBuildingInputCell
            cell?.selectionStyle = .none
            cell?.buildingModel = buildingModel ?? FangYuanBuildingEditModel()
            cell?.model = model
            cell?.endEditingMessageCell = { [weak self] (model) in
                self?.buildingModel = model
                self?.loadSecion(section: indexPath.section)
            }
            return cell ?? OwnerBuildingInputCell.init(frame: .zero)
            
            
            
            ///正数字文本输入cell
            ///总楼层
        ///车位费
        case .OwnerBuildingEditTypeTotalFloor, .OwnerBuildingEditTypeParkingCoast:
            
            ///数字文本输入cell
            let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingNumInputCell.reuseIdentifierStr) as? OwnerBuildingNumInputCell
            cell?.selectionStyle = .none
            cell?.buildingModel = buildingModel ?? FangYuanBuildingEditModel()
            cell?.model = model
            cell?.endEditingMessageCell = { [weak self] (model) in
                self?.buildingModel = model
                self?.loadSecion(section: indexPath.section)
            }
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
            cell?.buildingModel = buildingModel ?? FangYuanBuildingEditModel()
            cell?.model = model
            cell?.endEditingMessageCell = { [weak self] (model) in
                self?.buildingModel = model
                self?.loadSecion(section: indexPath.section)
            }
            return cell ?? OwnerBuildingDecimalNumInputCell.init(frame: .zero)
            
            
            ///有框框文本输入cell
            ///电梯数 - 客梯
        ///电梯数 - 客、货梯
        case .OwnerBuildingEditTypePassengerNum, .OwnerBuildingEditTypeFloorCargoNum:
            
            ///有框框文本输入cell
            let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingBorderInputCell.reuseIdentifierStr) as? OwnerBuildingBorderInputCell
            cell?.selectionStyle = .none
            cell?.buildingModel = buildingModel ?? FangYuanBuildingEditModel()
            cell?.model = model
            cell?.endEditingMessageCell = { [weak self] (model) in
                self?.buildingModel = model
                self?.loadSecion(section: indexPath.section)
            }
            return cell ?? OwnerBuildingBorderInputCell.init(frame: .zero)
            
            
            
        ///空调费 - 没有右边的箭头
        case .OwnerBuildingEditTypeAirConditionCoast:
            ///点击cell
            let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingClickCell.reuseIdentifierStr) as? OwnerBuildingClickCell
            cell?.selectionStyle = .none
            cell?.detailIcon.isHidden = true
            cell?.buildingModel = buildingModel ?? FangYuanBuildingEditModel()
            cell?.model = model
            return cell ?? OwnerBuildingClickCell.init(frame: .zero)
            
        ///网络
        case .OwnerBuildingEditTypeNetwork:
            let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingNetworkSelectCell.reuseIdentifierStr) as? OwnerBuildingNetworkSelectCell
            cell?.selectionStyle = .none
            cell?.categoryTitleLabel.text = "网络"
            cell?.isMutNetworks = true
            cell?.isMutTags = false
            cell?.buildingModel = self.buildingModel ?? FangYuanBuildingEditModel()
            return cell ?? OwnerBuildingNetworkSelectCell.init(frame: .zero)
            
        ///入驻企业
        case .OwnerBuildingEditTypeEnterCompany:
            let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingEnterCompanyCell.reuseIdentifierStr) as? OwnerBuildingEnterCompanyCell
            cell?.selectionStyle = .none
            cell?.indexPathRow = indexPath.row
            cell?.model = model
            cell?.editLabel.text = companyArr[indexPath.row]
            cell?.detailIcon.backgroundColor = kAppWhiteColor
            if indexPath.row == 0 {
                cell?.titleLabel.isHidden = false
            }else {
                cell?.titleLabel.isHidden = true
            }
            if indexPath.row == companyArr.count - 1 {
                cell?.detailIcon.setImage(UIImage.init(named: "addBlue"), for: .normal)
                cell?.lineView.isHidden = false
                cell?.shortLineView.isHidden = true
            }else {
                cell?.detailIcon.setImage(UIImage.init(named: "comDeleteBlue"), for: .normal)
                cell?.lineView.isHidden = true
                cell?.shortLineView.isHidden = false
            }
            cell?.closeBtnClickClouse = { [weak self] (index) in
                self?.loadEnterCompany(section: indexPath.section, index: index)
            }
            cell?.endEditingMessageCell = { [weak self] (str, index) in
                self?.loadEnterCompanyInputComplete(Str: str, index: index)
            }
            return cell ?? OwnerBuildingEnterCompanyCell.init(frame: .zero)
            
        ///详细介绍
        case .OwnerBuildingEditTypeDetailIntroduction:
            let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingIntroductionCell.reuseIdentifierStr) as? OwnerBuildingIntroductionCell
            cell?.selectionStyle = .none
            cell?.buildingModel = self.buildingModel ?? FangYuanBuildingEditModel()
            return cell ?? OwnerBuildingIntroductionCell.init(frame: .zero)
            
        ///特色
        case .OwnerBuildingEditTypeFeature:
            let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingNetworkSelectCell.reuseIdentifierStr) as? OwnerBuildingNetworkSelectCell
            cell?.selectionStyle = .none
            cell?.categoryTitleLabel.attributedText = model.getNameFormType(type: model.type ?? OwnerBuildingEditType.OwnerBuildingEditTypeFeature)
            cell?.isMutNetworks = false
            cell?.isMutTags = true
            cell?.buildingModel = self.buildingModel ?? FangYuanBuildingEditModel()
            return cell ?? OwnerBuildingNetworkSelectCell.init(frame: .zero)
            
        ///上传楼盘图片
        case .OwnerBuildingEditTypeBuildingImage:
            let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingImgCell.reuseIdentifierStr) as? OwnerBuildingImgCell
            cell?.selectionStyle = .none
            cell?.buildingCreatVC = self
            cell?.buildingJointCreatVC = nil
            cell?.buildingModel = self.buildingModel ?? FangYuanBuildingEditModel()
            cell?.model = model
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
        ///车位数
        case .OwnerBuildingEditTypeBuildingName, .OwnerBuildingEditTypeDetailAddress, .OwnerBuildingEditTypePropertyCompany, .OwnerBuildingEditTypeParkingNum:
            
            return BaseEditCell.rowHeight()
            
            
        ///楼号/楼名
        case .OwnerBuildingEditTypeBuildingNum:
            ///楼盘类型 - 当为创意园，产业园 多显示一个楼号
            if buildingModel?.buildingMsg?.buildingTypeEnum == nil || buildingModel?.buildingMsg?.buildingTypeEnum == OWnerBuildingTypeEnum.xieziEnum {
                return 0
            }else {
                return BaseEditCell.rowHeight()
            }
            
            
            ///正数字文本输入cell
            ///总楼层
        ///车位费
        case .OwnerBuildingEditTypeTotalFloor,
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
        case .OwnerBuildingEditTypePassengerNum, .OwnerBuildingEditTypeFloorCargoNum:
            
            return BaseEditCell.rowHeight()
            
            
        ///空调费 - 没有右边的箭头
        case .OwnerBuildingEditTypeAirConditionCoast:
            if buildingModel?.buildingMsg?.airditionType == nil || buildingModel?.buildingMsg?.airditionType == OwnerAircontiditonType.OwnerAircontiditonTypeDefault {
                return 0
            }else {
                return BaseEditCell.rowHeight()
            }
            
        ///网络
        case .OwnerBuildingEditTypeNetwork:
            
            let count = ((buildingModel?.buildingMsg?.internetLocal.count ?? 0  + 1) / 3)
            
            return CGFloat(count * 50 + 59 + 5)
            
        ///入驻企业
        case .OwnerBuildingEditTypeEnterCompany:
            return OwnerBuildingEnterCompanyCell.rowHeight()
            
        ///详细介绍
        case .OwnerBuildingEditTypeDetailIntroduction:
            return OwnerBuildingIntroductionCell.rowHeight()
            
        ///特色
        case .OwnerBuildingEditTypeFeature:
            
            if let arr = buildingModel?.buildingMsg?.tagsLocal {
                let count = ((arr.count  + 2) / 3)
                
                return CGFloat(count * 50 + 59 + 5)
            }else {
                return 59 + 5
            }
            
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
            
            endEdting()
            
            ownerFYMoreSettingView.ShowOwnerSettingView(datasource: [OWnerBuildingTypeEnum.xieziEnum.rawValue, OWnerBuildingTypeEnum.chuangyiEnum.rawValue, OWnerBuildingTypeEnum.chanyeEnum.rawValue], clearButtonCallBack: {
                
            }) {[weak self] (settingEnumIndex) in
                if settingEnumIndex == 0 {
                    SSLog("-----点击的是---写字楼")
                    self?.buildingModel?.buildingMsg?.buildingTypeEnum = .xieziEnum
                }else if settingEnumIndex == 1 {
                    SSLog("-----点击的是---创意园")
                    self?.buildingModel?.buildingMsg?.buildingTypeEnum = .chuangyiEnum
                }else if settingEnumIndex == 2 {
                    SSLog("-----点击的是---产业园")
                    self?.buildingModel?.buildingMsg?.buildingTypeEnum = .chanyeEnum
                }
                self?.loadSections(indexSet: [indexPath.section, indexPath.section + 1])
            }
            
        ///所在区域
        case .OwnerBuildingEditTypeDisctict:
                        
            endEdting()
            ///区域商圈选择
            judgeHasData(section: indexPath.section)
            
        ///竣工时间
        case .OwnerBuildingEditTypeCompelteTime:
            
            endEdting()
            
            let datePicker = YLDatePicker(currentDate: Date.getyyyyDateFomString(fromString: buildingModel?.buildingMsg?.completionTime ?? ""), minLimitDate: Date(timeIntervalSince1970: 315504000), maxLimitDate: Date(), datePickerType: .Y) { [weak self] (date) in
                self?.buildingModel?.buildingMsg?.completionTime = Date.getyyyyStringFromDate(FromDate: date)
                self?.loadSecion(section: indexPath.section)
            }
            datePicker.backLabel.text = "竣工时间"
            datePicker.show()
            
        ///翻新时间 1980-当前
        case .OwnerBuildingEditTypeRenovationTime:
            
            endEdting()
            let datePicker = YLDatePicker(currentDate: Date.getyyyyDateFomString(fromString: buildingModel?.buildingMsg?.refurbishedTime ?? ""), minLimitDate: Date(timeIntervalSince1970: 315504000), maxLimitDate: Date(), datePickerType: .Y) { [weak self] (date) in

                self?.buildingModel?.buildingMsg?.refurbishedTime = Date.getyyyyStringFromDate(FromDate: date)
                self?.loadSecion(section: indexPath.section)
            }
            datePicker.backLabel.text = "翻新时间"
            datePicker.show()
            
            SSLog(typeSourceArray[indexPath.section].type)
            
            
        ///空调类型
        case .OwnerBuildingEditTypeAirConditionType:
            
            endEdting()
            
            ownerFYMoreSettingView.ShowOwnerSettingView(datasource: [OwnerAircontiditonType.OwnerAircontiditonTypeCenter.rawValue, OwnerAircontiditonType.OwnerAircontiditonTypeIndividual.rawValue, OwnerAircontiditonType.OwnerAircontiditonTypeNone.rawValue], clearButtonCallBack: {
                
            }) {[weak self] (settingEnumIndex) in
                //中央空调，独立空调，无空调
                if settingEnumIndex == 0 {
                    SSLog("-----点击的是---中央空调")
                    self?.buildingModel?.buildingMsg?.airditionType = .OwnerAircontiditonTypeCenter
                }else if settingEnumIndex == 1 {
                    SSLog("-----点击的是---独立空调")
                    self?.buildingModel?.buildingMsg?.airditionType = .OwnerAircontiditonTypeIndividual
                }else if settingEnumIndex == 2 {
                    SSLog("-----点击的是---无空调")
                    self?.buildingModel?.buildingMsg?.airditionType = .OwnerAircontiditonTypeNone
                }
                self?.loadSections(indexSet: [indexPath.section, indexPath.section + 1])
            }
            
            
            ///文本输入cell
            ///写字楼名称
            ///楼号/楼名
            ///详细地址
        ///物业公司
        ///车位数
        case .OwnerBuildingEditTypeBuildingName, .OwnerBuildingEditTypeBuildingNum, .OwnerBuildingEditTypeDetailAddress, .OwnerBuildingEditTypePropertyCompany, .OwnerBuildingEditTypeParkingNum:
            SSLog(typeSourceArray[indexPath.section].type)
            
            
            ///正数字文本输入cell
            ///总楼层
        ///车位费
        case .OwnerBuildingEditTypeTotalFloor,
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
            ///电梯数 - 客梯
        ///电梯数 - 客、货梯
        case .OwnerBuildingEditTypePassengerNum, .OwnerBuildingEditTypeFloorCargoNum:
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




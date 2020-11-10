//
//  OwnerBuildingJointCreateViewController.swift
//  OfficeGo
//
//  Created by Mac pro on 2020/10/14.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit
import HandyJSON
import SwiftyJSON

class OwnerBuildingJointCreateViewController: BaseTableViewController {
    
    ///来自编辑还是添加
    var isFromAdd: Bool?
    
    var areaModelCount: CityAreaCategorySelectModel?
    
    ///地址区域
    lazy var areaView: CityDistrictAddressSelectView = {
        let view = CityDistrictAddressSelectView.init(frame: CGRect(x: 0.0, y: 0, width: kWidth, height: kHeight))
        return view
    }()
    
    
    ///共享服务选择弹框
    lazy var shareView: OwnerShareServiceShowView = {
        let view = OwnerShareServiceShowView.init(frame: CGRect(x: 0.0, y: 0, width: kWidth, height: kHeight))
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
    var typeSourceArray:[OwnerBuildingJointEditConfigureModel] = [OwnerBuildingJointEditConfigureModel]()
    
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
        
        endEdting()

        request_getUpdateBuilding()
    }
    
    
    func clickToPublish() {
        let vc = OwnerBuildingCreateVideoVRViewController()
        vc.isBuildingJoint = true
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
        
        ///写字楼名称
        typeSourceArray.append(OwnerBuildingJointEditConfigureModel.init(types: .OwnerBuildingJointEditTypeBuildingName))
        ///所在区域
        typeSourceArray.append(OwnerBuildingJointEditConfigureModel.init(types: .OwnerBuildingJointEditTypeDisctict))
        ///详细地址
        typeSourceArray.append(OwnerBuildingJointEditConfigureModel.init(types: .OwnerBuildingJointEditTypeDetailAddress))
        ///所在楼层
        typeSourceArray.append(OwnerBuildingJointEditConfigureModel.init(types: .OwnerBuildingJointEditTypeTotalFloor))
        ///净高
        typeSourceArray.append(OwnerBuildingJointEditConfigureModel.init(types: .OwnerBuildingJointEditTypeClearHeight))
        ///空调类型
        typeSourceArray.append(OwnerBuildingJointEditConfigureModel.init(types: .OwnerBuildingJointEditTypeAirConditionType))
        ///空调费
        typeSourceArray.append(OwnerBuildingJointEditConfigureModel.init(types: .OwnerBuildingJointEditTypeAirConditionCoast))
        ///会议室数量
        typeSourceArray.append(OwnerBuildingJointEditConfigureModel.init(types: .OwnerBuildingJointEditTypeConferenceNumber))
        ///最多容纳人数
        typeSourceArray.append(OwnerBuildingJointEditConfigureModel.init(types: .OwnerBuildingJointEditTypeConferencePeopleNumber))
        ///会议室配套
        typeSourceArray.append(OwnerBuildingJointEditConfigureModel.init(types: .OwnerBuildingJointEditTypeRoomMatching))
        ///车位数
        typeSourceArray.append(OwnerBuildingJointEditConfigureModel.init(types: .OwnerBuildingJointEditTypeParkingNum))
        ///车位费
        typeSourceArray.append(OwnerBuildingJointEditConfigureModel.init(types: .OwnerBuildingJointEditTypeParkingCoast))
        ///电梯数 - 客梯
        typeSourceArray.append(OwnerBuildingJointEditConfigureModel.init(types: .OwnerBuildingJointEditTypePassengerNum))
        ///电梯数 - 货梯
        typeSourceArray.append(OwnerBuildingJointEditConfigureModel.init(types: .OwnerBuildingJointEditTypeFloorCargoNum))
        ///网络
        typeSourceArray.append(OwnerBuildingJointEditConfigureModel.init(types: .OwnerBuildingJointEditTypeNetwork))
        ///入驻企业
        typeSourceArray.append(OwnerBuildingJointEditConfigureModel.init(types: .OwnerBuildingJointEditTypeEnterCompany))
        ///详细介绍
        typeSourceArray.append(OwnerBuildingJointEditConfigureModel.init(types: .OwnerBuildingJointEditTypeDetailIntroduction))
        ///特色
        typeSourceArray.append(OwnerBuildingJointEditConfigureModel.init(types: .OwnerBuildingJointEditTypeFeature))
        ///共享
        typeSourceArray.append(OwnerBuildingJointEditConfigureModel.init(types: .OwnerBuildingJointEditTypeShareService))
        ///上传网点图片
        typeSourceArray.append(OwnerBuildingJointEditConfigureModel.init(types: .OwnerBuildingJointEditTypeBuildingImage))
        
        ///来自添加
        if isFromAdd == true {
            
            buildingModel = FangYuanBuildingEditModel()
                    
            buildingModel?.buildingMsg = FangYuanBuildingMsgEditModel()
            
            request_getDistrict()

        }else {
            
            request_getEditBuilding()
            
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
            AppUtilities.makeToast("请选择或创建网点")
            //return
        }else {
            params["buildingId"] = buildingModel?.buildingMsg?.id as AnyObject?
        }

        //MARK: 网点名称
        if buildingModel?.buildingMsg?.branchesName == nil || buildingModel?.buildingMsg?.branchesName?.isBlankString == true{
            AppUtilities.makeToast("请输入网点名称")
            return
        }else {
            params["branchesName"] = buildingModel?.buildingMsg?.branchesName as AnyObject?
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
        
         //MARK: 所在楼层 - 第几层- 总楼层
        if buildingModel?.buildingMsg?.totalFloor == nil || buildingModel?.buildingMsg?.totalFloor?.isBlankString == true{
            AppUtilities.makeToast("请输入所在楼层")
            return
        }else {
            params["floorType"] = buildingModel?.buildingMsg?.floorType as AnyObject?
            params["totalFloor"] = buildingModel?.buildingMsg?.totalFloor as AnyObject?
        }
        if buildingModel?.buildingMsg?.branchesTotalFloor == nil || buildingModel?.buildingMsg?.branchesTotalFloor?.isBlankString == true{
            AppUtilities.makeToast("请输入总楼层")
            return
        }else {
            params["branchesTotalFloor"] = buildingModel?.buildingMsg?.branchesTotalFloor as AnyObject?
        }
        
        
        //MARK: 净高
        if buildingModel?.buildingMsg?.clearHeight == nil || buildingModel?.buildingMsg?.clearHeight?.isBlankString == true{
            AppUtilities.makeToast("请输入净高")
            return
        }else {
            params["clearHeight"] = buildingModel?.buildingMsg?.clearHeight as AnyObject?
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
        
        //MARK: 会议室数量
        if buildingModel?.buildingMsg?.conferenceNumber == nil || buildingModel?.buildingMsg?.conferenceNumber?.isBlankString == true{
            AppUtilities.makeToast("请输入会议室数量")
            return
        }else {
            params["conferenceNumber"] = buildingModel?.buildingMsg?.conferenceNumber as AnyObject?
        }
        
        
        //MARK: 最多容纳人数 - 非
        if buildingModel?.buildingMsg?.conferencePeopleNumber == nil || buildingModel?.buildingMsg?.conferencePeopleNumber?.isBlankString == true{
            //AppUtilities.makeToast("请输入最多容纳人数")
            //return
            params["conferencePeopleNumber"] = "" as AnyObject?
        }else {
            params["conferencePeopleNumber"] = buildingModel?.buildingMsg?.conferencePeopleNumber as AnyObject?
        }
        
        //MARK: 会议室配套 - 非
        if let roomMatchingsLocal = buildingModel?.buildingMsg?.roomMatchingsLocal {
            var deleteArr: [String] = []
            if let itemArr = roomMatchingsLocal.itemArr {
                for model in itemArr {
                    if model.isSelected == true {
                        deleteArr.append("\(model.dictValue ?? 0)")
                    }
                }
                params["roomMatching"] = deleteArr.joined(separator: ",") as AnyObject?
            }
        }else {
            params["roomMatching"] = "" as AnyObject?
        }
        
        //MARK: 车位数 - 非
        if buildingModel?.buildingMsg?.parkingSpace == nil || buildingModel?.buildingMsg?.parkingSpace?.isBlankString == true{
            //AppUtilities.makeToast("请输入车位数")
            //return
            params["parkingSpace"] = "" as AnyObject?
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
        
        
        //MARK: 电梯数 - 客梯 - 非
        if buildingModel?.buildingMsg?.passengerLift == nil || buildingModel?.buildingMsg?.passengerLift?.isBlankString == true{
            //AppUtilities.makeToast("请输入客梯数")
            //return
            params["passengerLift"] = "" as AnyObject?
        }else {
            params["passengerLift"] = buildingModel?.buildingMsg?.passengerLift as AnyObject?
        }
        
        //MARK: 电梯数 - 货梯 - 非
        if buildingModel?.buildingMsg?.cargoLift == nil || buildingModel?.buildingMsg?.cargoLift?.isBlankString == true{
            //AppUtilities.makeToast("请输入货梯数")
            //return
            params["cargoLift"] = "" as AnyObject?
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

        
        //MARK: 共享办公网点特色 - 非
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
        
        
        //MARK: 基础服务 - 非
        //MARK: 企业服务 - 非

        if let basicServicesLocal = buildingModel?.buildingMsg?.shareServices {
            let basic = basicServicesLocal[0]
            var deleteArr: [String] = []
            if let itemArr = basic.itemArr {
                for model in itemArr {
                    if model.isSelected == true {
                        deleteArr.append("\(model.dictValue ?? 0)")
                    }
                }
                params["basicServices"] = deleteArr.joined(separator: ",") as AnyObject?
            }else {
                params["basicServices"] = "" as AnyObject?
            }
            
            let corporate = basicServicesLocal[1]
            var deleteArr1: [String] = []
            if let itemArr = corporate.itemArr {
                for model in itemArr {
                    if model.isSelected == true {
                        deleteArr1.append("\(model.dictValue ?? 0)")
                    }
                }
                params["corporateServices"] = deleteArr1.joined(separator: ",") as AnyObject?
            }else {
                params["corporateServices"] = "" as AnyObject?
            }
        }else {
            params["basicServices"] = "" as AnyObject?
            params["corporateServices"] = "" as AnyObject?
        }
        
        
        //MARK: 网点图片
        if let buildingDeleteRemoteArr = buildingModel?.buildingDeleteRemoteArr {
            var deleteArr: [String] = []
            for model in buildingDeleteRemoteArr {
                deleteArr.append(model.imgUrl ?? "")
            }
            params["delImgUrl"] = deleteArr.joined(separator: ",") as AnyObject?
        }
        
        if let buildingLocalImgArr = buildingModel?.buildingLocalImgArr {
            if buildingLocalImgArr.count <= 0 {
                AppUtilities.makeToast("请上传网点图片")
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
            AppUtilities.makeToast("请上传网点图片")
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
    
    //MARK: 获取商圈数据
    func request_getDistrict() {
        //查询类型，1：全部，0：系统已有网点的商圈
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
    
    //MARK: 获取特色接口
    func requestGetFeature() {
        
        SSNetworkTool.SSBasic.request_getDictionary(code: .codeEnumbranchUnique, success: { [weak self] (response) in
            guard let weakSelf = self else {return}
            if let decoratedArray = JSONDeserializer<HouseFeatureModel>.deserializeModelArrayFrom(json: JSON(response).rawString() ?? "", designatedPath: "data") {
                for model in decoratedArray {
                    weakSelf.buildingModel?.buildingMsg?.tagsLocal.append(model ?? HouseFeatureModel())
                }
            }
            weakSelf.requestGetBasicServices()
            
            }, failure: {[weak self] (error) in
                self?.requestGetBasicServices()
                
        }) {[weak self] (code, message) in
            self?.requestGetBasicServices()
            
            //只有5000 提示给用户
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" {
                AppUtilities.makeToast(message)
            }
        }
    }
    
    //MARK: 获取基础服务
    func requestGetBasicServices() {
        
        SSNetworkTool.SSBasic.request_getDictionary(code: .codeEnumbasicServices, success: { [weak self] (response) in
            guard let weakSelf = self else {return}
            if let decoratedArray = JSONDeserializer<HouseFeatureModel>.deserializeModelArrayFrom(json: JSON(response).rawString() ?? "", designatedPath: "data") {
                for model in decoratedArray {
                    weakSelf.buildingModel?.buildingMsg?.basicServicesLocal.append(model ?? HouseFeatureModel())
                }
                let basicServicesModel = ShareServiceModel()
                basicServicesModel.title = "基础服务"
                basicServicesModel.itemArr =  weakSelf.buildingModel?.buildingMsg?.basicServicesLocal
                weakSelf.buildingModel?.buildingMsg?.shareServices.append(basicServicesModel)
            }
            weakSelf.requestGetCompanyService()
            
            }, failure: {[weak self] (error) in
                self?.requestGetCompanyService()
                
        }) {[weak self] (code, message) in
            self?.requestGetCompanyService()
            
            //只有5000 提示给用户
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" {
                AppUtilities.makeToast(message)
            }
        }
    }
    
    //MARK: 获取企业服务
    func requestGetCompanyService() {
        
        SSNetworkTool.SSBasic.request_getDictionary(code: .codeEnumcompanyService, success: { [weak self] (response) in
            guard let weakSelf = self else {return}
            if let decoratedArray = JSONDeserializer<HouseFeatureModel>.deserializeModelArrayFrom(json: JSON(response).rawString() ?? "", designatedPath: "data") {
                for model in decoratedArray {
                    weakSelf.buildingModel?.buildingMsg?.corporateServicesLocal.append(model ?? HouseFeatureModel())
                }
                let corporateServicesModel = ShareServiceModel()
                corporateServicesModel.title = "企业服务"
                corporateServicesModel.itemArr =  weakSelf.buildingModel?.buildingMsg?.corporateServicesLocal
                weakSelf.buildingModel?.buildingMsg?.shareServices.append(corporateServicesModel)
            }
            weakSelf.requestGetRoomMatchingUnique()
            
            }, failure: {[weak self] (error) in
                self?.requestGetRoomMatchingUnique()
                
        }) {[weak self] (code, message) in
            self?.requestGetRoomMatchingUnique()
            
            //只有5000 提示给用户
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" {
                AppUtilities.makeToast(message)
            }
        }
    }
    
    //MARK: 获取会议室配套
    func requestGetRoomMatchingUnique() {
        
        SSNetworkTool.SSBasic.request_getDictionary(code: .roomMatchingUnique, success: { [weak self] (response) in
            guard let weakSelf = self else {return}
            if let decoratedArray = JSONDeserializer<HouseFeatureModel>.deserializeModelArrayFrom(json: JSON(response).rawString() ?? "", designatedPath: "data") {
                var arr:[HouseFeatureModel] = []
                for model in decoratedArray {
                    arr.append(model ?? HouseFeatureModel())
                }
                let model = ShareServiceModel()
                model.title = "会议室配套"
                model.itemArr = arr
                weakSelf.buildingModel?.buildingMsg?.roomMatchingsLocal = model
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
        
        
        /// basicServices 基础服务,多个用英文逗号隔开 1,2,4,6,9  - id匹配
        let basicServicesArr = buildingModel?.buildingMsg?.basicServices?.split{$0 == ","}.map(String.init)
        if let networkArr = basicServicesArr, let internetLocal = buildingModel?.buildingMsg?.basicServicesLocal {
            if networkArr.count > 0 && internetLocal.count > 0 {
                for network in networkArr {
                    
                    for dic in internetLocal {
                        if network == "\(dic.dictValue ?? 0)" {
                            dic.isSelected = true
                        }
                    }
                }
            }
        }
        

        ///corporateServices  企业服务,多个用英文逗号隔开 - id匹配
        let corporateServicesArr = buildingModel?.buildingMsg?.corporateServices?.split{$0 == ","}.map(String.init)
        if let networkArr = corporateServicesArr, let internetLocal = buildingModel?.buildingMsg?.corporateServicesLocal {
            if networkArr.count > 0 && internetLocal.count > 0 {
                for network in networkArr {
                    
                    for dic in internetLocal {
                        if network == "\(dic.dictValue ?? 0)" {
                            dic.isSelected = true
                        }
                    }
                }
            }
        }
        
        
        ///roomMatching 会议室配套,多个用英文逗号隔开,会议室配套详情，看字典 - id匹配
        let roomMatchingArr = buildingModel?.buildingMsg?.roomMatching?.split{$0 == ","}.map(String.init)
        if let networkArr = roomMatchingArr, let internetLocal = buildingModel?.buildingMsg?.roomMatchingsLocal?.itemArr {
            if networkArr.count > 0 && internetLocal.count > 0 {
                for network in networkArr {
                    
                    for dic in internetLocal {
                        if network == "\(dic.dictValue ?? 0)" {
                            dic.isSelected = true
                        }
                    }
                }
            }
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
}

extension OwnerBuildingJointCreateViewController {
    
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
            titleview?.titleLabel.text = "添加共享办公网点"
        }else {
            titleview?.titleLabel.text = "编辑共享办公网点"
        }
        titleview?.leftButtonCallBack = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
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
        
        ///所在楼层
        self.tableView.register(OwnerBuildingFloorCell.self, forCellReuseIdentifier: OwnerBuildingFloorCell.reuseIdentifierStr)
        
        ///会议室配套
        self.tableView.register(OwnerBuildingRoomMatchingClickCell.self, forCellReuseIdentifier: OwnerBuildingRoomMatchingClickCell.reuseIdentifierStr)
        
        ///装修类型
        ///特色
        self.tableView.register(OwnerBuildingNetworkSelectCell.self, forCellReuseIdentifier: OwnerBuildingNetworkSelectCell.reuseIdentifierStr)
        
        ///详细介绍
        self.tableView.register(OwnerBuildingIntroductionCell.self, forCellReuseIdentifier: OwnerBuildingIntroductionCell.reuseIdentifierStr)
        
        //共享服务
        self.tableView.register(RenterShareServiceCell.self, forCellReuseIdentifier: RenterShareServiceCell.reuseIdentifierStr)
        
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

extension OwnerBuildingJointCreateViewController {
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

extension OwnerBuildingJointCreateViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return typeSourceArray.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        ///入住企业
        if typeSourceArray[section].type == .OwnerBuildingJointEditTypeEnterCompany {
            return companyArr.count
        }
        ///所在楼层 - 一行点击 一行展示
        else if typeSourceArray[section].type == .OwnerBuildingJointEditTypeTotalFloor {
            return 2
        }else {
            return 1
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model:OwnerBuildingJointEditConfigureModel = typeSourceArray[indexPath.section]
        
        switch model.type {
            ///选择cell
            ///所在区域
        ///空调类型
        case .OwnerBuildingJointEditTypeDisctict, .OwnerBuildingJointEditTypeAirConditionType:
            
            ///点击cell
            let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingClickCell.reuseIdentifierStr) as? OwnerBuildingClickCell
            cell?.selectionStyle = .none
            cell?.buildingModel = buildingModel ?? FangYuanBuildingEditModel()
            cell?.jointModel = model
            return cell ?? OwnerBuildingClickCell.init(frame: .zero)
            
            
            ///文本输入cell
            ///写字楼名称
            ///详细地址
            ///车位数
        ///车位费
        case .OwnerBuildingJointEditTypeBuildingName, .OwnerBuildingJointEditTypeDetailAddress, .OwnerBuildingJointEditTypeParkingNum, .OwnerBuildingJointEditTypeParkingCoast:
            
            ///文本输入cell
            let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingInputCell.reuseIdentifierStr) as? OwnerBuildingInputCell
            cell?.selectionStyle = .none
            cell?.buildingModel = buildingModel ?? FangYuanBuildingEditModel()
            cell?.jointModel = model
            cell?.endEditingMessageCell = { [weak self] (model) in
                self?.buildingModel = model
                self?.loadSecion(section: indexPath.section)
            }
            return cell ?? OwnerBuildingInputCell.init(frame: .zero)
            
        ///所在楼层
        case .OwnerBuildingJointEditTypeTotalFloor:
            if indexPath.row == 0 {
                ///点击cell
                let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingClickCell.reuseIdentifierStr) as? OwnerBuildingClickCell
                cell?.selectionStyle = .none
                cell?.buildingModel = buildingModel ?? FangYuanBuildingEditModel()
                cell?.jointModel = model
                return cell ?? OwnerBuildingClickCell.init(frame: .zero)
            }else {

                ///文本输入cell
                let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingFloorCell.reuseIdentifierStr) as? OwnerBuildingFloorCell
                cell?.selectionStyle = .none
                cell?.buildingModel = buildingModel ?? FangYuanBuildingEditModel()
                cell?.jointModel = model
                cell?.endEditingMessageCell = { [weak self] (model) in
                    self?.buildingModel = model
//                    self?.loadSecion(section: indexPath.section)
                }
                return cell ?? OwnerBuildingFloorCell.init(frame: .zero)
                            
            }
            
            ///正数字文本输入cell
            ///会议室数量，数字，必填，支持输入0-10的正整数，单位 个；
            ///最多容纳人数，数字，选填，0-50的正整数，单位 人；
        case .OwnerBuildingJointEditTypeConferenceNumber, .OwnerBuildingJointEditTypeConferencePeopleNumber:
            
            ///数字文本输入cell
            let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingNumInputCell.reuseIdentifierStr) as? OwnerBuildingNumInputCell
            cell?.selectionStyle = .none
            cell?.buildingModel = buildingModel ?? FangYuanBuildingEditModel()
            cell?.jointModel = model
            cell?.endEditingMessageCell = { [weak self] (model) in
                self?.buildingModel = model
                self?.loadSecion(section: indexPath.section)
            }
            return cell ?? OwnerBuildingNumInputCell.init(frame: .zero)
            
            
            ///数字 - 一位小数点文本输入cell
        ///净高
        case .OwnerBuildingJointEditTypeClearHeight:
            
            ///数字文本输入cell
            let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingDecimalNumInputCell.reuseIdentifierStr) as? OwnerBuildingDecimalNumInputCell
            cell?.selectionStyle = .none
            cell?.buildingModel = buildingModel ?? FangYuanBuildingEditModel()
            cell?.jointModel = model
            cell?.endEditingMessageCell = { [weak self] (model) in
                self?.buildingModel = model
                self?.loadSecion(section: indexPath.section)
            }
            return cell ?? OwnerBuildingDecimalNumInputCell.init(frame: .zero)
            
            
            ///有框框文本输入cell
            ///电梯数 - 客梯
        ///电梯数 - 客、货梯
        case .OwnerBuildingJointEditTypePassengerNum, .OwnerBuildingJointEditTypeFloorCargoNum:
            
            ///有框框文本输入cell
            let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingBorderInputCell.reuseIdentifierStr) as? OwnerBuildingBorderInputCell
            cell?.selectionStyle = .none
            cell?.buildingModel = buildingModel ?? FangYuanBuildingEditModel()
            cell?.jointModel = model
            cell?.endEditingMessageCell = { [weak self] (model) in
                self?.buildingModel = model
                self?.loadSecion(section: indexPath.section)
            }
            return cell ?? OwnerBuildingBorderInputCell.init(frame: .zero)
            
            
        ///会议室配套
        case .OwnerBuildingJointEditTypeRoomMatching:
            let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingRoomMatchingClickCell.reuseIdentifierStr) as? OwnerBuildingRoomMatchingClickCell
            cell?.selectionStyle = .none
            cell?.buildingModel = buildingModel ?? FangYuanBuildingEditModel()
            cell?.jointModel = model
            return cell ?? OwnerBuildingRoomMatchingClickCell.init(frame: .zero)
            
            
        ///空调费 - 没有右边的箭头
        case .OwnerBuildingJointEditTypeAirConditionCoast:
            ///点击cell
            let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingClickCell.reuseIdentifierStr) as? OwnerBuildingClickCell
            cell?.selectionStyle = .none
            cell?.detailIcon.isHidden = true
            cell?.buildingModel = buildingModel ?? FangYuanBuildingEditModel()
            cell?.jointModel = model
            return cell ?? OwnerBuildingClickCell.init(frame: .zero)
            
        ///网络
        case .OwnerBuildingJointEditTypeNetwork:
            let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingNetworkSelectCell.reuseIdentifierStr) as? OwnerBuildingNetworkSelectCell
            cell?.selectionStyle = .none
            cell?.categoryTitleLabel.text = "网络"
            cell?.isMutNetworks = true
            cell?.isMutTags = false
            cell?.buildingModel = self.buildingModel ?? FangYuanBuildingEditModel()
            return cell ?? OwnerBuildingNetworkSelectCell.init(frame: .zero)
            
        ///入驻企业
        case .OwnerBuildingJointEditTypeEnterCompany:
            let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingEnterCompanyCell.reuseIdentifierStr) as? OwnerBuildingEnterCompanyCell
            cell?.selectionStyle = .none
            cell?.indexPathRow = indexPath.row
            cell?.jointModel = model
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
                cell?.detailIcon.setImage(UIImage.init(named: "comDeleteBlue"), for: .normal)
                cell?.lineView.isHidden = true
            }
            cell?.closeBtnClickClouse = { [weak self] (index) in
                self?.loadEnterCompany(section: indexPath.section, index: index)
            }
            cell?.endEditingMessageCell = { [weak self] (str, index) in
                self?.loadEnterCompanyInputComplete(Str: str, index: index)
            }
            return cell ?? OwnerBuildingEnterCompanyCell.init(frame: .zero)
            
        ///详细介绍
        case .OwnerBuildingJointEditTypeDetailIntroduction:
            let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingIntroductionCell.reuseIdentifierStr) as? OwnerBuildingIntroductionCell
            cell?.selectionStyle = .none
            cell?.buildingModel = self.buildingModel ?? FangYuanBuildingEditModel()
            return cell ?? OwnerBuildingIntroductionCell.init(frame: .zero)
            
        ///特色
        case .OwnerBuildingJointEditTypeFeature:
            let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingNetworkSelectCell.reuseIdentifierStr) as? OwnerBuildingNetworkSelectCell
            cell?.selectionStyle = .none
            cell?.categoryTitleLabel.attributedText = model.getNameFormType(type: model.type ?? OwnerBuildingJointEditType.OwnerBuildingJointEditTypeFeature)
            cell?.isMutTags = true
            cell?.isMutNetworks = false
            cell?.buildingModel = self.buildingModel ?? FangYuanBuildingEditModel()
            return cell ?? OwnerBuildingNetworkSelectCell.init(frame: .zero)
            
        ///共享服务
        case .OwnerBuildingJointEditTypeShareService:
            let cell = tableView.dequeueReusableCell(withIdentifier: RenterShareServiceCell.reuseIdentifierStr) as? RenterShareServiceCell
            cell?.selectionStyle = .none
            cell?.buildingModel = self.buildingModel ?? FangYuanBuildingEditModel()
            
            return cell ?? RenterShareServiceCell()
            
        ///上传网点图片
        case .OwnerBuildingJointEditTypeBuildingImage:
            let cell = tableView.dequeueReusableCell(withIdentifier: OwnerBuildingImgCell.reuseIdentifierStr) as? OwnerBuildingImgCell
            cell?.selectionStyle = .none
            cell?.buildingCreatVC = nil
            cell?.buildingJointCreatVC = self
            cell?.buildingModel = self.buildingModel ?? FangYuanBuildingEditModel()
            cell?.jointModel = model
            return cell ?? OwnerBuildingImgCell.init(frame: .zero)
            
        ///上传网点视频
        case .OwnerBuildingJointEditTypeBuildingVideo:
            return UITableViewCell.init(frame: .zero)
            
        ///上传网点vr
        case .OwnerBuildingJointEditTypeBuildingVR:
            return UITableViewCell.init(frame: .zero)
            
        case .none:
            return UITableViewCell.init(frame: .zero)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch typeSourceArray[indexPath.section].type {
            ///选择cell
            ///所在区域
        ///空调类型
        case .OwnerBuildingJointEditTypeDisctict, .OwnerBuildingJointEditTypeAirConditionType:
            
            return BaseEditCell.rowHeight()
            
            
            ///文本输入cell
            ///写字楼名称
            ///详细地址
            ///车位数
        ///车位费
        case .OwnerBuildingJointEditTypeBuildingName, .OwnerBuildingJointEditTypeDetailAddress, .OwnerBuildingJointEditTypeParkingNum, .OwnerBuildingJointEditTypeParkingCoast:
            
            return BaseEditCell.rowHeight()
            
        ///所在楼层
        case .OwnerBuildingJointEditTypeTotalFloor:
            
            if indexPath.row == 0 {
                return BaseEditCell.rowHeight()
            }else {
                if buildingModel?.buildingMsg?.floorType == "1" || buildingModel?.buildingMsg?.floorType == "2" {
                    return OwnerBuildingFloorCell.rowHeight()
                }else {
                    return 0
                }
            }
            
            ///正数字文本输入cell
            ///会议室数量，数字，必填，支持输入0-10的正整数，单位 个；
            ///最多容纳人数，数字，选填，0-50的正整数，单位 人；
        case .OwnerBuildingJointEditTypeConferenceNumber, .OwnerBuildingJointEditTypeConferencePeopleNumber:
            
            return BaseEditCell.rowHeight()
            
            ///数字 - 一位小数点文本输入cell
        ///净高
        case .OwnerBuildingJointEditTypeClearHeight:
            
            return BaseEditCell.rowHeight()
            
            
            ///有框框文本输入cell
            ///车位费
            ///电梯数 - 客梯
        ///电梯数 - 客、货梯
        case .OwnerBuildingJointEditTypePassengerNum, .OwnerBuildingJointEditTypeFloorCargoNum:
            
            return BaseEditCell.rowHeight()
            
            
        ///会议室配套
        case .OwnerBuildingJointEditTypeRoomMatching:
            return BaseEditCell.rowHeight()
            
        ///空调费 - 没有右边的箭头
        case .OwnerBuildingJointEditTypeAirConditionCoast:
            if buildingModel?.buildingMsg?.airditionType == nil || buildingModel?.buildingMsg?.airditionType == OwnerAircontiditonType.OwnerAircontiditonTypeDefault {
                return 0
            }else {
                return BaseEditCell.rowHeight()
            }
            
        ///网络
        case .OwnerBuildingJointEditTypeNetwork:
            
            let count = ((buildingModel?.buildingMsg?.internetLocal.count ?? 0  + 1) / 3)
            
            return CGFloat(count * 50 + 59 + 5)
            
        ///入驻企业
        case .OwnerBuildingJointEditTypeEnterCompany:
            return OwnerBuildingEnterCompanyCell.rowHeight()
            
        ///详细介绍
        case .OwnerBuildingJointEditTypeDetailIntroduction:
            return OwnerBuildingIntroductionCell.rowHeight()
            
        ///特色
        case .OwnerBuildingJointEditTypeFeature:
            
            if let arr = buildingModel?.buildingMsg?.tagsLocal {
                let count = ((arr.count  + 2) / 3)

                return CGFloat(count * 50 + 59 + 5)
            }else {
                return 59 + 5
            }
            
        ///共享服务
        case .OwnerBuildingJointEditTypeShareService:
            //            return 50 + 2 * (20 + 18 + 18 + 26) + 20
            return 50 + 2 * 82 + 20
            
        ///上传网点图片
        case .OwnerBuildingJointEditTypeBuildingImage:
            return ((kWidth - left_pending_space_17 * 2 - 5 * 2) / 3.0 + 10) * 4 + 68
            
        ///上传网点视频
        case .OwnerBuildingJointEditTypeBuildingVideo:
            return BaseEditCell.rowHeight()
            
        ///上传网点vr
        case .OwnerBuildingJointEditTypeBuildingVR:
            return BaseEditCell.rowHeight()
            
        case .none:
            return BaseEditCell.rowHeight()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.typeSourceArray.count <= 0 {
            return
        }
        
        endEdting()

        switch typeSourceArray[indexPath.section].type {
            
        ///所在区域
        case .OwnerBuildingJointEditTypeDisctict:
            
            endEdting()
            
            ///区域商圈选择
            judgeHasData(section: indexPath.section)
            
        ///空调类型
        case .OwnerBuildingJointEditTypeAirConditionType:
            
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
            ///详细地址
            ///车位数
        ///车位费
        case .OwnerBuildingJointEditTypeBuildingName, .OwnerBuildingJointEditTypeDetailAddress, .OwnerBuildingJointEditTypeParkingNum, .OwnerBuildingJointEditTypeParkingCoast:
            SSLog(typeSourceArray[indexPath.section].type)
            
            
        ///所在楼层 - 只有点击头部才行
        case .OwnerBuildingJointEditTypeTotalFloor:
            SSLog(typeSourceArray[indexPath.section].type)
            if indexPath.row == 0 {
                
                endEdting()
                
                ownerFYMoreSettingView.ShowOwnerSettingView(datasource: [OwnerBuildingTotalFloorType.OwnerBuildingTotalFloorTypeOne.rawValue, OwnerBuildingTotalFloorType.OwnerBuildingTotalFloorTypeMore.rawValue], clearButtonCallBack: {
                    
                }) {[weak self] (settingEnumIndex) in
                    //单层1 多层2
                    if settingEnumIndex == 0 {
                        self?.buildingModel?.buildingMsg?.floorType = "1"
                    }else if settingEnumIndex == 1 {
                        self?.buildingModel?.buildingMsg?.floorType = "2"
                    }
                    self?.loadSections(indexSet: [indexPath.section])
                }
                
            }
            
            ///正数字文本输入cell
            ///会议室数量，数字，必填，支持输入0-10的正整数，单位 个；
            ///最多容纳人数，数字，选填，0-50的正整数，单位 人；
        case .OwnerBuildingJointEditTypeConferenceNumber, .OwnerBuildingJointEditTypeConferencePeopleNumber:
            
            SSLog(typeSourceArray[indexPath.section].type)
            
            ///数字 - 一位小数点文本输入cell
        ///净高
        case .OwnerBuildingJointEditTypeClearHeight:
            
            SSLog(typeSourceArray[indexPath.section].type)
            
            ///有框框文本输入cell
            ///车位费
            ///电梯数 - 客梯
        ///电梯数 - 客、货梯
        case .OwnerBuildingJointEditTypePassengerNum, .OwnerBuildingJointEditTypeFloorCargoNum:
            SSLog(typeSourceArray[indexPath.section].type)
            
            
        case .OwnerBuildingJointEditTypeRoomMatching:
            
            endEdting()

            SSLog(typeSourceArray[indexPath.section].type)
            ///编辑添加页面
            let serviceModel = buildingModel?.buildingMsg?.roomMatchingsLocal ?? ShareServiceModel()
            shareView.ShowShareView(serviceModel: serviceModel)
            shareView.sureSelectedBlock = {[weak self] (servicemodel) in
                self?.buildingModel?.buildingMsg?.roomMatchingsLocal = servicemodel
                self?.loadTableview()
            }
            shareView.cancelBlock = {[weak self] in
                self?.loadTableview()
            }
            
        ///空调费 - 没有右边的箭头
        case .OwnerBuildingJointEditTypeAirConditionCoast:
            SSLog(typeSourceArray[indexPath.section].type)
            
        ///网络
        case .OwnerBuildingJointEditTypeNetwork:
            SSLog(typeSourceArray[indexPath.section].type)
            
        ///入驻企业
        case .OwnerBuildingJointEditTypeEnterCompany:
            SSLog(typeSourceArray[indexPath.section].type)
            
        ///详细介绍
        case .OwnerBuildingJointEditTypeDetailIntroduction:
            SSLog(typeSourceArray[indexPath.section].type)
            
        ///特色
        case .OwnerBuildingJointEditTypeFeature:
            SSLog(typeSourceArray[indexPath.section].type)
            
        ///共享服务
        case .OwnerBuildingJointEditTypeShareService:
            SSLog(typeSourceArray[indexPath.section].type)
            
        ///上传网点图片
        case .OwnerBuildingJointEditTypeBuildingImage:
            SSLog(typeSourceArray[indexPath.section].type)
            
        ///上传网点视频
        case .OwnerBuildingJointEditTypeBuildingVideo:
            SSLog(typeSourceArray[indexPath.section].type)
            
        ///上传网点vr
        case .OwnerBuildingJointEditTypeBuildingVR:
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




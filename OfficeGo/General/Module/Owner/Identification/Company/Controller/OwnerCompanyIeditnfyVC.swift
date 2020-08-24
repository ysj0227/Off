//
//  OwnerCompanyIeditnfyVC.swift
//  OfficeGo
//
//  Created by mac on 2020/7/13.
//  Copyright © 2020 Senwei. All rights reserved.
//
import CLImagePickerTool

class OwnerCompanyIeditnfyVC: BaseViewController {
    
    ///时候有公司 =
    var iaHasCompany: Bool?
    
    ///时候有楼盘
    var isHasBuilding: Bool?
    
    ///临时添加的几个字段
    ///管理楼id
    var buildingIdTemp : String?
    
    var licenceIdTemp : String?
    
    ///申请id
    var userLicenceIdTemp : String?
    
    ///楼id 认证的时候传的字段 - 自己创建的楼的id - 关联
    ///楼名称传过 就会有这个id
    var buildingTempIdTemp : String?
    
    ///判断页面时候来自于个人中心驳回页面
    var isFromPersonalVc: Bool = false
    
    var userModel: OwnerIdentifyUserModel?
    
    //公司名称搜索结果vc
    var companySearchResultVC: OwnerCompanyESearchResultListViewController?
    
    //写字楼名称搜索结果vc
    var buildingNameSearchResultVC: OwnerBuildingNameESearchResultListViewController?
    
    var companyName: String? {
        didSet {
            let rect = headerCollectionView.layoutAttributesForItem(at: IndexPath.init(row: 1, section: 0))
            let cellRect = rect?.frame ?? CGRect.zero
            let cellFrame = headerCollectionView.convert(cellRect, to: self.view)
            SSLog("companyNamerect-\(rect)------cellRect\(cellRect)------cellFrame\(cellFrame)")
            if companyName?.isBlankString == true {
                companySearchResultVC?.view.isHidden = true
                companySearchResultVC?.keywords = ""
            }else {
                companySearchResultVC?.view.isHidden = false
                companySearchResultVC?.keywords = companyName
            }
            companySearchResultVC?.view.snp.remakeConstraints({ (make) in
                make.top.equalTo(cellFrame.minY + cell_height_58 + 1)
                make.leading.trailing.equalToSuperview()
                make.bottom.equalToSuperview()
            })
            //隐藏写字楼搜索的框
            buildingNameSearchResultVC?.view.isHidden = true
        }
    }
    
    var buildingName: String? {
        didSet {
            let rect = headerCollectionView.layoutAttributesForItem(at: IndexPath.init(row: 0, section: 1))
            let cellRect = rect?.frame ?? CGRect.zero
            let cellFrame = headerCollectionView.convert(cellRect, to: self.view)
            SSLog("buildingNamerect-\(rect)------cellRect\(cellRect)------cellFrame\(cellFrame)")
            if buildingName?.isBlankString == true {
                buildingNameSearchResultVC?.view.isHidden = true
                buildingNameSearchResultVC?.keywords = ""
            }else {
                buildingNameSearchResultVC?.view.isHidden = false
                buildingNameSearchResultVC?.keywords = buildingName
            }
            buildingNameSearchResultVC?.view.snp.remakeConstraints({ (make) in
                make.top.equalTo(cellFrame.minY + cell_height_58 + 17 + 1)
                make.leading.trailing.equalToSuperview()
                make.bottom.equalToSuperview()
            })
            //隐藏公司搜索的框
            companySearchResultVC?.view.isHidden = true
        }
    }
    
    @objc var uploadPicModelFCZArr = [BannerModel]()  // 在实际的项目中可能用于存储图片的url
    
    @objc var uploadPicModelZLAgentArr = [BannerModel]()  // 在实际的项目中可能用于存储图片的url
    
    @objc var uplaodMainPageimg = UIImage.init(named: "addImgBg")  // 在实际的项目中可能用于存储图片的url
    
    lazy var fczImagePickTool: CLImagePickerTool = {
        let picker = CLImagePickerTool()
        picker.cameraOut = true
        picker.isHiddenVideo = true
        return picker
    }()
    lazy var zlAgentImagePickTool: CLImagePickerTool = {
        let picker = CLImagePickerTool()
        picker.cameraOut = true
        picker.isHiddenVideo = true
        return picker
    }()
    lazy var mainPicImagePickTool: CLImagePickerTool = {
        let picker = CLImagePickerTool()
        picker.cameraOut = true
        picker.isHiddenVideo = true
        picker.singleImageChooseType = .singlePicture   //设置单选
        return picker
    }()
    
    var headerCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = kAppWhiteColor
        return view
    }()
    
    var typeSourceArray:[[OwnerCompanyIedntifyConfigureModel]] = {
        var arr = [[OwnerCompanyIedntifyConfigureModel]]()
        
        arr.append([OwnerCompanyIedntifyConfigureModel.init(types: .OwnerCompanyIedntifyTypeIdentigy),
                    OwnerCompanyIedntifyConfigureModel.init(types: .OwnerCompanyIedntifyTypeCompanyname)])
        
        arr.append([OwnerCompanyIedntifyConfigureModel.init(types: .OwnerCompanyIedntifyTypeBuildingName),
                    //                    OwnerCompanyIedntifyConfigureModel.init(types: .OwnerCompanyIedntifyTypeBuildingAddress),
            OwnerCompanyIedntifyConfigureModel.init(types: .OwnerCompanyIedntifyTypeBuildingFCType)])
        
        arr.append([OwnerCompanyIedntifyConfigureModel.init(types: .OwnerCompanyIedntifyTypeUploadFangchanzheng)])
        
        arr.append([OwnerCompanyIedntifyConfigureModel.init(types: .OwnerCompanyIedntifyTypeUploadZulinAgent)])
        /*
         arr.append([OwnerCompanyIedntifyConfigureModel.init(types: .OwnerCompanyIedntifyTypeUploadMainimg)])*/
        
        return arr
    }()
    
    var commitBtn: UIButton {
        let btn = UIButton.init(frame: CGRect(x: left_pending_space_17, y: 0, width: kWidth - left_pending_space_17 * 2, height: btnHeight_44))
        btn.backgroundColor = kAppBlueColor
        btn.clipsToBounds = true
        btn.layer.cornerRadius = button_cordious_2
        btn.setTitle("提交认证", for: .normal)
        btn.setTitleColor(kAppWhiteColor, for: .normal)
        btn.titleLabel?.font = FONT_15
        btn.addTarget(self, action: #selector(logotClick), for: .touchUpInside)
        return btn
    }
    
    var LogotView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: kWidth, height: btnHeight_44 + bottomMargin()))
        return view
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        addNotify()
        requestCompanyIdentifyDetail()
    }
    
    func addNotify() {
        
        //公司认证 - 创建公司成功通知
        NotificationCenter.default.addObserver(forName: NSNotification.Name.OwnerCreateCompany, object: nil, queue: OperationQueue.main) { [weak self] (noti) in
            
            self?.iaHasCompany = true
            self?.requestCreateCompanySuccess()
        }
        
        //公司认证 - 创建办公楼通知
        NotificationCenter.default.addObserver(forName: NSNotification.Name.OwnerCreateBuilding, object: nil, queue: OperationQueue.main) { [weak self] (noti) in
            
            self?.isHasBuilding = true
            self?.requestCreateBuildingSuccess()
        }
        
        
    }
    
    func requestCreateCompanySuccess() {
        
        var params = [String:AnyObject]()
        
        params["token"] = UserTool.shared.user_token as AnyObject?
        
        
        //身份类型0个人认证1企业认证2网点认证
        params["identityType"] = UserTool.shared.user_owner_identifytype as AnyObject?
        
        
        SSNetworkTool.SSOwnerIdentify.request_getSelectIdentityTypeApp(params: params, success: {[weak self] (response) in
            
            guard let weakSelf = self else {return}
            
            if let model = OwnerIdentifyUserModel.deserialize(from: response, designatedPath: "data") {
                                     
                weakSelf.userModel?.auditStatus = model.auditStatus
                weakSelf.userModel?.authority = model.authority
                
                weakSelf.userModel?.isCreateCompany = model.isCreateCompany
                weakSelf.userModel?.userLicenceId = model.userLicenceId
                weakSelf.userModel?.licenceId = model.licenceId
                weakSelf.userModel?.company = model.company
                weakSelf.userModel?.address = model.address
                weakSelf.userModel?.creditNo = model.creditNo
                weakSelf.userModel?.businessLicense = model.businessLicense
                
                weakSelf.companySearchResultVC?.view.isHidden = true
                weakSelf.loadCollectionData()
            }
            
            }, failure: { (error) in
                
                
        }) { (code, message) in
            
        }
    }
    
    
    func requestCreateBuildingSuccess() {
        
        var params = [String:AnyObject]()
        
        params["token"] = UserTool.shared.user_token as AnyObject?
        
        
        //身份类型0个人认证1企业认证2网点认证
        params["identityType"] = UserTool.shared.user_owner_identifytype as AnyObject?
        
        
        SSNetworkTool.SSOwnerIdentify.request_getSelectIdentityTypeApp(params: params, success: {[weak self] (response) in
            
            guard let weakSelf = self else {return}
            
            if let model = OwnerIdentifyUserModel.deserialize(from: response, designatedPath: "data") {
                                   
                weakSelf.userModel?.auditStatus = model.auditStatus
                weakSelf.userModel?.authority = model.authority
                
                weakSelf.userModel?.isCreateBuilding = model.isCreateBuilding
                weakSelf.userModel?.userLicenceId = model.userLicenceId
                weakSelf.userModel?.licenceId = model.licenceId
                weakSelf.userModel?.buildingId = model.buildingId
                weakSelf.userModel?.buildingTempId = model.buildingTempId
                weakSelf.userModel?.buildingName = model.buildingName
                weakSelf.userModel?.buildingAddress = model.buildingAddress
                weakSelf.userModel?.district = model.district
                weakSelf.userModel?.business = model.business
                weakSelf.userModel?.mainPic = model.mainPic

                
                weakSelf.buildingNameSearchResultVC?.view.isHidden = true
                weakSelf.loadCollectionData()
            }
            
            }, failure: { (error) in
                
                
        }) { (code, message) in
            
        }
    }
    
    ///页面上面切换按钮
    func showChangeAlert() {
        self.headerCollectionView.endEditing(true)
        let alert = SureAlertView(frame: self.view.frame)
        alert.ShowAlertView(withalertType: AlertType.AlertTypeMessageAlert, title: "信息尚未提交，是否确认切换身份？", descMsg: "", cancelButtonCallClick: {
            
        }) { [weak self] in
            
            self?.leftBtnClick()
        }
    }
    
    ///左上角按钮
    func showLeaveAlert() {
        self.headerCollectionView.endEditing(true)
        let alert = SureAlertView(frame: self.view.frame)
        alert.bottomBtnView.rightSelectBtn.setTitle("离开", for: .normal)
        alert.ShowAlertView(withalertType: AlertType.AlertTypeMessageAlert, title: "信息尚未提交，是否确认离开？", descMsg: "", cancelButtonCallClick: {
            
        }) { [weak self] in
            
//            self?.showSureLeaveAlert()
            if self?.isFromPersonalVc == true {
                self?.navigationController?.popToRootViewController(animated: true)
            }else {
                self?.leftBtnClick()
            }
        }
    }
    
//    func showSureLeaveAlert() {
//        let alert = SureAlertView(frame: self.view.frame)
//        alert.ShowAlertView(withalertType: AlertType.AlertTypeMessageAlert, title: "请再次确认是否离开？", descMsg: "", cancelButtonCallClick: {
//
//        }) { [weak self] in
//
//            if self?.isFromPersonalVc == true {
//                self?.navigationController?.popToRootViewController(animated: true)
//            }else {
//                self?.leftBtnClick()
//            }
//
//        }
//    }
    
}

extension OwnerCompanyIeditnfyVC {
    
    func detailDataShow() {
        
        if userModel?.company?.count ?? 0 > 0 {
            iaHasCompany = true
        }else {
            iaHasCompany = false
        }
        
        if userModel?.buildingName?.count ?? 0 > 0 {
            isHasBuilding = true
        }else {
            isHasBuilding = false
        }
        
        ///移除之前的房产证数据
        for fczBannerModel in uploadPicModelFCZArr {
            if fczBannerModel.isLocal == false {
                uploadPicModelFCZArr.remove(fczBannerModel)
            }
        }
        ///添加新的房产证数据
        if let premisesPermit = userModel?.premisesPermit {
            
            for fczBannerModel in premisesPermit {
                fczBannerModel.isLocal = false
                uploadPicModelFCZArr.append(fczBannerModel)
            }
        }
        
        ///移除之前的租赁协议数据
        for lzAgentBannerModel in uploadPicModelZLAgentArr {
            if lzAgentBannerModel.isLocal == false {
                uploadPicModelZLAgentArr.remove(lzAgentBannerModel)
            }
        }
        
        ///添加新的租赁协议数据
        if let contract = userModel?.contract {
            
            for lzAgentBannerModel in contract {
                lzAgentBannerModel.isLocal = false
                uploadPicModelZLAgentArr.append(lzAgentBannerModel)
            }
        }
        
        loadCollectionData()
    }
    
    ///获取信息
    func requestCompanyIdentifyDetail() {
        
        var params = [String:AnyObject]()
        
        params["token"] = UserTool.shared.user_token as AnyObject?
        
        
        //身份类型0个人认证1企业认证2网点认证
        params["identityType"] = UserTool.shared.user_owner_identifytype as AnyObject?
        
        
        SSNetworkTool.SSOwnerIdentify.request_getSelectIdentityTypeApp(params: params, success: {[weak self] (response) in
            
            guard let weakSelf = self else {return}
            
            if let model = OwnerIdentifyUserModel.deserialize(from: response, designatedPath: "data") {
                weakSelf.userModel = model
                weakSelf.detailDataShow()
                
            }else {
                weakSelf.setUpData()
                weakSelf.loadCollectionData()
            }
            
            }, failure: {[weak self] (error) in
                
                guard let weakSelf = self else {return}
                
                weakSelf.setUpData()
                weakSelf.loadCollectionData()
                
        }) {[weak self] (code, message) in
            
            guard let weakSelf = self else {return}
            
            weakSelf.setUpData()
            weakSelf.loadCollectionData()
            //只有5000 提示给用户 - 失效原因
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" || code == "\(SSCode.ERROR_CODE_7016.code)" {
                AppUtilities.makeToast(message)
            }
        }
    }
    
    ///提交认证
    func requestCompanyIdentify() {
        
        if userModel?.company == nil || userModel?.company?.isBlankString == true{
            AppUtilities.makeToast("请选择或创建公司")
            return
        }
        
        if userModel?.buildingName == nil || userModel?.buildingName?.isBlankString == true{
            AppUtilities.makeToast("请选择或创建写字楼")
            return
        }
        
        if userModel?.leaseType == nil || userModel?.leaseType?.isBlankString == true{
            AppUtilities.makeToast("请选择房产类型")
            return
        }
        
        if uploadPicModelFCZArr.count <= 0 {
            AppUtilities.makeToast("请上传房产证")
            return
        }
        
        if userModel?.leaseType == "1" {
            if uploadPicModelZLAgentArr.count <= 0 {
                AppUtilities.makeToast("请上传租赁协议")
                return
            }
        }

        var params = [String:AnyObject]()
        
        params["token"] = UserTool.shared.user_token as AnyObject?
        
        //身份类型0个人认证1企业认证2网点认证
        params["identityType"] = UserTool.shared.user_owner_identifytype as AnyObject?
        
        //1提交认证2企业确认3网点楼盘创建确认
        params["createCompany"] = 1 as AnyObject?
        
        params["leaseType"] = userModel?.leaseType as AnyObject?
        
        
        ///企业关系id  接口给
        if userModel?.userLicenceId != "0" || userModel?.userLicenceId?.isBlankString != true {
            params["userLicenceId"] = userModel?.userLicenceId as AnyObject?
        }
        
        ///企业id  接口给
        if userModel?.licenceId != "0" || userModel?.licenceId?.isBlankString != true {
            params["licenceId"] = userModel?.licenceId as AnyObject?
        }
        
        ///楼id
        ///关联的。- 覆盖 - 两种
        //        if userModel?.buildingId != 0 {
        //            params["buildingId"] = userModel?.buildingId as AnyObject?
        //        }
        
        //关联 - 楼盘，名字和地址都要给
        params["buildingId"] = userModel?.buildingId as AnyObject?
        
        params["buildingAddress"] = userModel?.buildingAddress as AnyObject?
        
        params["buildingName"] = userModel?.buildingName as AnyObject?
        
        
        ///关联楼id  接口给
        if userModel?.buildingTempId != "0" || userModel?.buildingTempId?.isBlankString != true {
            params["buildingTempId"] = userModel?.buildingTempId as AnyObject?
        }
        
        
        //房产证
        var fczArr: [UIImage] = []
        for model in uploadPicModelFCZArr {
            if model.isLocal == true {
                fczArr.append(model.image ?? UIImage())
            }
        }
        
        //租赁
        var alAgentArr: [UIImage] = []
        if userModel?.leaseType == "1" {
            for model in uploadPicModelZLAgentArr {
                if model.isLocal == true {
                    alAgentArr.append(model.image ?? UIImage())
                }
            }
        }
        
        setCommitEnables(isUserinterface: false)
        
        SSNetworkTool.SSOwnerIdentify.request_companyIdentityApp(params: params, fczImagesArray: fczArr, zlAgentImagesArray: alAgentArr, success: {[weak self] (response) in
            
            guard let weakSelf = self else {return}
            
            weakSelf.setCommitEnables(isUserinterface: false)
            
            weakSelf.showCommitAlertview()
            
            }, failure: {[weak self] (error) in
                
                self?.setCommitEnables(isUserinterface: false)
        }) {[weak self] (code, message) in
            
            self?.setCommitEnables(isUserinterface: false)

            //只有5000 提示给用户 - 失效原因
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" || code == "\(SSCode.ERROR_CODE_7016.code)" {
                AppUtilities.makeToast(message)
            }
        }
        

    }
    
    func setCommitEnables(isUserinterface: Bool) {
        commitBtn.isUserInteractionEnabled = false
    }
        
}

extension OwnerCompanyIeditnfyVC {
    
    @objc func logotClick() {
        self.headerCollectionView.endEditing(true)
        requestCompanyIdentify()
    }
    func setUpData() {
        userModel = OwnerIdentifyUserModel()
        userModel?.leaseType = ""
        
    }
    func setUpView() {
        
        titleview = ThorNavigationView.init(type: .backTitleRightBlueBgclolor)
        titleview?.titleLabel.text = "公司认证"
        titleview?.rightButton.isHidden = true
        titleview?.leftButtonCallBack = { [weak self] in
            self?.showLeaveAlert()
        }
        self.view.addSubview(titleview ?? ThorNavigationView.init(type: .backTitleRight))
        
        self.view.addSubview(headerCollectionView)
        headerCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(kNavigationHeight)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-(bottomMargin() + btnHeight_44))
        }
        headerCollectionView.delegate = self
        headerCollectionView.dataSource = self
        self.view.addSubview(LogotView)
        LogotView.addSubview(commitBtn)
        LogotView.snp.remakeConstraints { (make) in
            make.height.equalTo(bottomMargin() + btnHeight_44)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        headerCollectionView.register(OwnerCompanyIdentifyCell.self, forCellWithReuseIdentifier: OwnerCompanyIdentifyCell.reuseIdentifierStr)
        headerCollectionView.register(OwnerImagePickerCell.self, forCellWithReuseIdentifier: OwnerImagePickerCell.reuseIdentifierStr)
        headerCollectionView.register(OwnerImgPickerCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "OwnerImgPickerCollectionViewHeader")
        
        //公司名
        companySearchResultVC = OwnerCompanyESearchResultListViewController.init()
        companySearchResultVC?.view.isHidden = true
        self.view.addSubview(companySearchResultVC?.view ?? UIView())
        
        // 传递闭包 当点击’搜索结果‘的cell调用
        companySearchResultVC?.companyCallBack = {[weak self] (model) in
            let vc = OwnerApplyEnterCompanyViewController()
            vc.companyModel = model
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        // 创建按钮 - 跳转到创建公司页面
        companySearchResultVC?.creatButtonCallClick = {[weak self] in
            
            ///TODO: 要判断能不能创建
            self?.isCanCreateCompany()
        }
        // 关闭按钮 - 隐藏页面
        companySearchResultVC?.closeButtonCallClick = {[weak self] in
            self?.companySearchResultVC?.view.isHidden = true
        }
        //办公楼
        buildingNameSearchResultVC = OwnerBuildingNameESearchResultListViewController.init()
        buildingNameSearchResultVC?.view.isHidden = true
        self.view.addSubview(buildingNameSearchResultVC?.view ?? UIView())
        
        // 传递闭包 当点击’搜索结果‘的cell调用
        buildingNameSearchResultVC?.buildingCallBack = {[weak self] (model) in
            // 搜索完成 关闭resultVC
            
            self?.isHasBuilding = true

            //判断楼盘是关联的还是自己创建的
            self?.userModel?.isCreateBuilding = "2"
            
            self?.userModel?.buildingId = model.bid
            self?.userModel?.buildingName = model.buildingAttributedName?.string
            self?.userModel?.buildingAddress = model.addressString?.string
            
            self?.buildingNameSearchResultVC?.view.isHidden = true
            self?.loadCollectionData()
        }
        
        // 创建按钮 - 隐藏 - 创建楼盘
        buildingNameSearchResultVC?.creatButtonCallClick = {[weak self] in
            let vc = OwnerCreateBuildingViewController()
            let userModel = OwnerIdentifyUserModel()
            userModel.licenceId = self?.userModel?.licenceId
            userModel.userLicenceId = self?.userModel?.userLicenceId
            userModel.buildingId = self?.userModel?.buildingId
            userModel.buildingTempId = self?.userModel?.buildingTempId
            userModel.buildingName = self?.buildingName
            userModel.buildingAddress = ""
            userModel.creditNo = ""
            userModel.mainPic = ""
            userModel.district = ""
            userModel.business = ""
            userModel.districtString = ""
            userModel.businessString = ""
            vc.userModel = userModel
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        // 关闭按钮 - 隐藏页面
        buildingNameSearchResultVC?.closeButtonCallClick = {[weak self] in
            self?.buildingNameSearchResultVC?.view.isHidden = true
        }
    }
    
    ///判断是否可以创建公司
    func isCanCreateCompany() {
        
        var params = [String:AnyObject]()
        
        params["company"] = companyName as AnyObject?
        
        
        //身份类型0个人认证1企业认证2网点认证
        params["identityType"] = UserTool.shared.user_owner_identifytype as AnyObject?
        
        params["token"] = UserTool.shared.user_token as AnyObject?
        
        SSNetworkTool.SSOwnerIdentify.request_getIsCanCreatCompany(params: params, success: {[weak self] (response) in
            
            guard let weakSelf = self else {return}
            
            if let model = BranchOrCompanyIIsExistedModel.deserialize(from: response, designatedPath: "data") {
                weakSelf.createCompanyJudge(model: model)
            }
            
            }, failure: { (error) in
                
        }) { (code, message) in
            
            //只有5000 提示给用户 - 失效原因
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" || code == "\(SSCode.ERROR_CODE_7016.code)" {
                AppUtilities.makeToast(message)
            }
        }
    }
    
    ///判断是否可以创建的跳转处理
    func createCompanyJudge(model: BranchOrCompanyIIsExistedModel) {
        SSTool.invokeInMainThread {[weak self] in
            guard let weakSelf = self else {return}
            
            //0不存在1存在
            if model.flag == 0 {
                let vc = OwnerCreateCompanyViewController()
                let companyModel = OwnerIdentifyUserModel()
                companyModel.licenceId = self?.userModel?.licenceId
                companyModel.userLicenceId = self?.userModel?.userLicenceId
                companyModel.buildingId = self?.userModel?.buildingId
                companyModel.buildingTempId = self?.userModel?.buildingTempId
                companyModel.company = weakSelf.companyName
                companyModel.address = ""
                companyModel.creditNo = ""
                companyModel.businessLicense = ""
                vc.companyModel = companyModel
                weakSelf.navigationController?.pushViewController(vc, animated: true)
            }else if model.flag == 1 {
                AppUtilities.makeToast(model.explain ?? "公司已经存在，不能重复创建")
            }
        }
        
    }
    
    func loadCollectionData() {
        headerCollectionView.reloadData()
    }
    
    func loadFCZSectionData() {
        headerCollectionView.reloadSections(NSIndexSet.init(index: 2) as IndexSet)
    }
    
    func loadZLAgentData() {
        headerCollectionView.reloadSections(NSIndexSet.init(index: 3) as IndexSet)
    }
    
    func showCommitAlertview() {
        let alert = SureAlertView(frame: self.view.frame)
        alert.isHiddenVersionCancel = true
        alert.ShowAlertView(withalertType: AlertType.AlertTypeMessageAlert, title: "提交成功", descMsg: "我们会在1-2个工作日完成审核", cancelButtonCallClick: {
            
        }) {[weak self] in
            self?.navigationController?.popToRootViewController(animated: true)
        }
    }
}

extension OwnerCompanyIeditnfyVC {
    func selectFCZPicker() {
        var imgArr = [BannerModel]()
        fczImagePickTool.cl_setupImagePickerWith(MaxImagesCount: ownerMaxFCZNumber - uploadPicModelFCZArr.count) {[weak self] (asset,cutImage) in
            // 内部提供的方法可以异步获取图片，同步获取的话时间比较长，不建议！，如果是iCloud中的照片就直接从icloud中下载，下载完成后返回图片,同时也提供了下载失败的方法
            CLImagePickerTool.convertAssetArrToOriginImage(assetArr: asset, scale: 0.1, successClouse: {[weak self] (image,assetItem) in
                let img = image.resizeMax1500Image()
                
                let fczBannerModel = BannerModel()
                fczBannerModel.isLocal = true
                fczBannerModel.image = img
                imgArr.append(fczBannerModel)
                }, failedClouse: { () in
                    
            })
            //房产证
            self?.uploadPicModelFCZArr.append(contentsOf: imgArr)
            self?.loadCollectionData()
        }
    }
    
    func selectZLAgentPicker() {
        var imgArr = [BannerModel]()
        zlAgentImagePickTool.cl_setupImagePickerWith(MaxImagesCount: ownerMaxZLAgentNumber - uploadPicModelZLAgentArr.count) {[weak self] (asset,cutImage) in
            // 内部提供的方法可以异步获取图片，同步获取的话时间比较长，不建议！，如果是iCloud中的照片就直接从icloud中下载，下载完成后返回图片,同时也提供了下载失败的方法
            CLImagePickerTool.convertAssetArrToOriginImage(assetArr: asset, scale: 0.1, successClouse: {[weak self] (image,assetItem) in
                let img = image.resizeMax1500Image()
                
                let zlAgentBannerModel = BannerModel()
                zlAgentBannerModel.isLocal = true
                zlAgentBannerModel.image = img
                imgArr.append(zlAgentBannerModel)
                }, failedClouse: { () in
                    
            })
            self?.uploadPicModelZLAgentArr.append(contentsOf: imgArr)
            self?.loadCollectionData()
        }
    }
    
    func selectMainPagePicker() {
        
        mainPicImagePickTool.cl_setupImagePickerWith(MaxImagesCount: 1) {[weak self] (asset,cutImage) in
            // 内部提供的方法可以异步获取图片，同步获取的话时间比较长，不建议！，如果是iCloud中的照片就直接从icloud中下载，下载完成后返回图片,同时也提供了下载失败的方法
            CLImagePickerTool.convertAssetArrToOriginImage(assetArr: asset, scale: 0.1, successClouse: {[weak self] (image,assetItem) in
                let img = image.resizeMax1500Image()
                
                self?.uplaodMainPageimg = img
                }, failedClouse: { () in
                    
            })
            self?.loadCollectionData()
        }
    }
    
    ///删除房产证图片接口
    func request_deleteFCZImgApp(index: Int) {
        
        if uploadPicModelFCZArr[index].isLocal == true {
            uploadPicModelFCZArr.remove(at: index)
            loadFCZSectionData()
            return
        }
        
        var params = [String:AnyObject]()
        
        params["id"] = uploadPicModelFCZArr[index].id as AnyObject?
        
        params["token"] = UserTool.shared.user_token as AnyObject?
        
        SSNetworkTool.SSOwnerIdentify.request_getDeleteImgApp(params: params, success: {[weak self] (response) in
            
            guard let weakSelf = self else {return}
            
            weakSelf.uploadPicModelFCZArr.remove(at: index)
            weakSelf.loadFCZSectionData()
            
            }, failure: { (error) in
                
        }) { (code, message) in
            
            //只有5000 提示给用户 - 失效原因
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" || code == "\(SSCode.ERROR_CODE_7016.code)" {
                AppUtilities.makeToast(message)
            }
        }
    }
    
    ///删除租赁协议图片接口
    func request_deleteZLAgentImgApp(index: Int) {
        
        if uploadPicModelZLAgentArr[index].isLocal == true {
            uploadPicModelZLAgentArr.remove(at: index)
            loadZLAgentData()

            return
        }
        
        var params = [String:AnyObject]()
        
        params["id"] = uploadPicModelZLAgentArr[index].id as AnyObject?
        
        params["token"] = UserTool.shared.user_token as AnyObject?
        
        SSNetworkTool.SSOwnerIdentify.request_getDeleteImgApp(params: params, success: {[weak self] (response) in
            
            guard let weakSelf = self else {return}
            
            weakSelf.uploadPicModelZLAgentArr.remove(at: index)
            weakSelf.loadZLAgentData()

            
            }, failure: { (error) in
                
        }) { (code, message) in
            
            //只有5000 提示给用户 - 失效原因
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" || code == "\(SSCode.ERROR_CODE_7016.code)" {
                AppUtilities.makeToast(message)
            }
        }
    }
}

extension OwnerCompanyIeditnfyVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 || indexPath.section == 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OwnerCompanyIdentifyCell.reuseIdentifierStr, for: indexPath as IndexPath) as? OwnerCompanyIdentifyCell
            cell?.userModel = self.userModel
            cell?.model = typeSourceArray[indexPath.section][indexPath.item]
            cell?.companyNameClickClouse = { [weak self] (companyName) in
                //清除 公司名字 字段改为空
                self?.userModel?.isCreateCompany = ""
                
                self?.userModel?.company = ""
                self?.companyName = companyName
            }
            cell?.buildingNameClickClouse = { [weak self] (buildingName) in
                //清除 公司名字 字段改为空
                self?.userModel?.isCreateBuilding = ""
                
                self?.userModel?.buildingName = ""
                self?.userModel?.buildingAddress = ""
                self?.buildingName = buildingName
            }
            cell?.editClickBack = { [weak self] (type) in
                //公司编辑
                if type == OwnerCompanyIedntifyType.OwnerCompanyIedntifyTypeCompanyname {
                    let vc = OwnerCreateCompanyViewController()
                    vc.companyModel = self?.userModel
                    self?.navigationController?.pushViewController(vc, animated: true)
                }else if type == OwnerCompanyIedntifyType.OwnerCompanyIedntifyTypeBuildingName {
                    let vc = OwnerCreateBuildingViewController()
                    vc.userModel = self?.userModel
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            }
            cell?.closeClickBack = { [weak self] (type) in
                //公司编辑
                if type == .OwnerCompanyIedntifyTypeCompanyname{
                    //清除 公司名字 字段改为空
                    self?.userModel?.isCreateCompany = ""
                    
                    self?.userModel?.company = ""
                    self?.companyName = ""
                    
                }else if type == .OwnerCompanyIedntifyTypeBuildingName {
                    //清除 楼盘名字地址 字段改为空
                    self?.userModel?.isCreateBuilding = ""
                    
                    self?.userModel?.buildingName = ""
                    self?.userModel?.buildingAddress = ""
                    
                    self?.buildingName = ""
                }
            }
            return cell ?? OwnerCompanyIdentifyCell()
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OwnerImagePickerCell.reuseIdentifierStr, for: indexPath as IndexPath) as? OwnerImagePickerCell
            cell?.indexPath = indexPath
            if indexPath.section == 2 {
                if indexPath.item <= uploadPicModelFCZArr.count - 1  {
                    if uploadPicModelFCZArr[indexPath.item].isLocal == false {
                        cell?.image.setImage(with: uploadPicModelFCZArr[indexPath.item].imgUrl ?? "", placeholder: UIImage(named: Default_1x1))
                    }else {
                        cell?.image.image = uploadPicModelFCZArr[indexPath.item].image
                    }
                    cell?.closeBtnClickClouse = { [weak self] (index) in
                        self?.request_deleteFCZImgApp(index: index)
                    }
                }else {
                    cell?.image.image = UIImage.init(named: "addImgBg")
                }
                
                if indexPath.item == uploadPicModelFCZArr.count {
                    cell?.closeBtn.isHidden = true
                }else {
                    cell?.closeBtn.isHidden = false
                }
            }else if indexPath.section == 3 {
                if indexPath.item <= uploadPicModelZLAgentArr.count - 1  {
                    if uploadPicModelZLAgentArr[indexPath.item].isLocal == false {
                        cell?.image.setImage(with: uploadPicModelZLAgentArr[indexPath.item].imgUrl ?? "", placeholder: UIImage(named: Default_1x1))
                    }else {
                        cell?.image.image = uploadPicModelZLAgentArr[indexPath.item].image
                    }
                    cell?.closeBtnClickClouse = { [weak self] (index) in
                        self?.request_deleteZLAgentImgApp(index: index)
                    }
                }else {
                    cell?.image.image = UIImage.init(named: "addImgBg")
                }
                
                if indexPath.item == uploadPicModelZLAgentArr.count {
                    cell?.closeBtn.isHidden = true
                }else {
                    cell?.closeBtn.isHidden = false
                }
            }
            /*else if indexPath.section == 4 {
             cell?.image.image = uplaodMainPageimg
             cell?.closeBtn.isHidden = true
             }*/
            return cell ?? OwnerImagePickerCell()
        }
        
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        ///如果是审核被驳回并且是加入的某个企业
//        if (userModel?.auditStatus == "2" && userModel?.authority == "0") || (userModel?.auditStatus == "3" && userModel?.authority == "0") {
        if userModel?.isCreateCompany == "2" {
            return 1
        }else {
            if iaHasCompany == true {
                if isHasBuilding == true {
                    //直租
                    if userModel?.leaseType == "0" {
                        return typeSourceArray.count - 1
                    }else if userModel?.leaseType == "1" {
                        return typeSourceArray.count
                    }else {
                        return typeSourceArray.count - 2
                    }
                }else {
                    return typeSourceArray.count - 2
                }
            }else {
                return 1
            }
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        ///如果是审核被驳回并且是加入的某个企业
        //        if (userModel?.auditStatus == "2" && userModel?.authority == "0") || (userModel?.auditStatus == "3" && userModel?.authority == "0") {
        if userModel?.isCreateCompany == "2" {
            
            if section == 0 {
                return typeSourceArray[0].count
            }else {
                return 0
            }
        }else {
            if section == 0 {
                return typeSourceArray[0].count
            }else if section == 1 {
                if isHasBuilding == true {
                    return typeSourceArray[1].count
                }else {
                    return 1
                }
            }else if section == 2 {
                if userModel?.leaseType == "0" || userModel?.leaseType == "1" {
                    return uploadPicModelFCZArr.count + 1
                }else {
                    return 0
                }
                
            }else if section == 3 {
                if userModel?.leaseType == "1" {
                    return uploadPicModelZLAgentArr.count + 1
                }else {
                    return 0
                }
            }
            return 0
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0 {
            return CGSize(width: kWidth - left_pending_space_17 * 2, height: cell_height_58)
        }else if indexPath.section == 1 {
            let model = typeSourceArray[1][indexPath.item]
            if model.type == .OwnerCompanyIedntifyTypeBuildingName {
                return CGSize(width: kWidth - left_pending_space_17 * 2, height: cell_height_58 + 18)
            }else {
                return CGSize(width: kWidth - left_pending_space_17 * 2, height: cell_height_58)
            }
        }else if indexPath.section == 2 {
            return CGSize(width: (kWidth - left_pending_space_17 * 2 - 5 * 2) / 3.0 - 1, height: (kWidth - left_pending_space_17 * 2 - 5 * 2) / 3.0 - 1)
        }else if indexPath.section == 3 {
            return CGSize(width: (kWidth - left_pending_space_17 * 2 - 5 * 2) / 3.0 - 1, height: (kWidth - left_pending_space_17 * 2 - 5 * 2) / 3.0 - 1)
        }
        return CGSize(width: 0, height: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 || section == 1 {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            
        }else {
            return UIEdgeInsets(top: 0, left: left_pending_space_17, bottom: 0, right: left_pending_space_17)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.item == 0 {
                showChangeAlert()
            }
        }else if indexPath.section == 1 {
            if indexPath.item == 1 {
                
                let alertController = UIAlertController.init(title: "房产类型", message: nil, preferredStyle: .actionSheet)
                let refreshAction = UIAlertAction.init(title: "自有房产", style: .default) {[weak self] (action: UIAlertAction) in
                    self?.userModel?.leaseType = "0"
                    self?.loadCollectionData()
                }
                let copyAction = UIAlertAction.init(title: "租赁房产", style: .default) {[weak self] (action: UIAlertAction) in
                    self?.userModel?.leaseType = "1"
                    self?.loadCollectionData()
                }
                let cancelAction = UIAlertAction.init(title: "取消", style: .cancel) { (action: UIAlertAction) in
                    
                }
                alertController.addAction(refreshAction)
                alertController.addAction(copyAction)
                alertController.addAction(cancelAction)
                
                present(alertController, animated: true, completion: nil)
            }
        }else {
            if indexPath.section == 2 {
                if indexPath.item == uploadPicModelFCZArr.count {
                    selectFCZPicker()
                }
            }else if indexPath.section == 3 {
                if indexPath.item == uploadPicModelZLAgentArr.count {
                    selectZLAgentPicker()
                }
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "OwnerImgPickerCollectionViewHeader", for: indexPath) as? OwnerImgPickerCollectionViewHeader
            if indexPath.section == 0 || indexPath.section == 1  {
                header?.backgroundColor = kAppColor_line_EEEEEE
                header?.titleLabel.text = ""
                header?.descLabel.text = ""
            }else if indexPath.section == 2{
                header?.backgroundColor = kAppWhiteColor
                header?.titleLabel.text = "上传房产证"
                header?.descLabel.text = "请确保所上传的房产信息与公司信息一致"
            }else if indexPath.section == 3{
                header?.backgroundColor = kAppWhiteColor
                header?.titleLabel.text = "上传租赁协议"
                header?.descLabel.text = "上传内容务必包含承租方名称、租赁大厦名称和出租方公章"
            }
            
            return header ?? UICollectionReusableView()
        }
        
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: kWidth - left_pending_space_17 * 2, height: 0)
            
        }else if section == 1 {
            return CGSize(width: kWidth, height: 10)
            
        }else if section == 2 {
            if userModel?.leaseType == "0" || userModel?.leaseType == "1" {
                return CGSize(width: kWidth, height: 68)
            }else {
                return CGSize(width: kWidth, height: 0)
            }
        }else if section == 3 {
            if userModel?.leaseType == "1" {
                return CGSize(width: kWidth, height: 68)
            }else {
                return CGSize(width: kWidth, height: 0)
            }
            
        }
        else {
            return CGSize.zero
        }
    }
    
    //这个是两行cell之间的间距（上下行cell的间距）
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if section == 0 || section == 1 {
            return 0
        }else {
            return 5
        }
    }
    
    ////两个cell之间的间距（同一行的cell的间距）
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if section == 0 || section == 1 {
            return 0
        }else {
            return 5
        }
    }
}



//
//  OwnerJointIeditnfyVC.swift
//  OfficeGo
//
//  Created by mac on 2020/7/15.
//  Copyright © 2020 Senwei. All rights reserved.
//

import CLImagePickerTool

class OwnerJointIeditnfyVC: BaseViewController {
    
    ///判断页面时候来自于个人中心驳回页面
    var isFromPersonalVc: Bool = false
    
    ///网点名字 自己选择的 - 可能是接口返回的
     var branchNameTemp: String?
    
    ///公司名字 自己选择的 - 可能是接口返回的
    var companyNameTemp: String?
    
    ///楼盘名字 自己选择的 - 可能是接口返回的
    var buildingNameTemp: String?
    
    ///租赁类型0直租1转租 自己选择的 - 可能是接口返回的
    var leaseType: String?
    
    var userModel: OwnerIdentifyUserModel?
    
    //网点名称搜索结果vc
    var branchSearchResultVC: OwnerCompanyESearchResultListViewController?
    
    //公司名称搜索结果vc
    var companySearchResultVC: OwnerCompanyESearchResultListViewController?
    
    //写字楼名称搜索结果vc
    var buildingNameSearchResultVC: OwnerBuildingNameESearchResultListViewController?
    
    ///网点名称
    var branchName: String? {
        didSet {
            let rect = headerCollectionView.layoutAttributesForItem(at: IndexPath.init(row: 1, section: 0))
            let cellRect = rect?.frame ?? CGRect.zero
            let cellFrame = headerCollectionView.convert(cellRect, to: self.view)
            SSLog("buildingNamerect-\(rect)------cellRect\(cellRect)------cellFrame\(cellFrame)")
            if branchName?.isBlankString == true {
                branchSearchResultVC?.view.isHidden = true
                branchSearchResultVC?.keywords = ""
            }else {
                branchSearchResultVC?.view.isHidden = false
                branchSearchResultVC?.keywords = branchName
            }
            branchSearchResultVC?.view.snp.remakeConstraints({ (make) in
                make.top.equalTo(cellFrame.minY + cell_height_58 + 17 + 1)
                make.leading.trailing.equalToSuperview()
                make.bottom.equalToSuperview().offset(-bottomMargin())
            })
            //隐藏公司搜索的框
            companySearchResultVC?.view.isHidden = true
            
            buildingNameSearchResultVC?.view.isHidden = true
        }
    }
    
    var companyName: String? {
        didSet {
            let rect = headerCollectionView.layoutAttributesForItem(at: IndexPath.init(row: 2, section: 0))
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
                make.bottom.equalToSuperview().offset(-bottomMargin())
            })
            //隐藏写字楼搜索的框
            
            branchSearchResultVC?.view.isHidden = true
            
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
                make.bottom.equalToSuperview().offset(-bottomMargin())
            })
            //隐藏公司搜索的框
            branchSearchResultVC?.view.isHidden = true
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
    
    var typeSourceArray:[[OwnerJointIedntifyConfigureModel]] = {
        var arr = [[OwnerJointIedntifyConfigureModel]]()
        
        arr.append([OwnerJointIedntifyConfigureModel.init(types: .OwnerJointIedntifyTypeIdentigy),
                    OwnerJointIedntifyConfigureModel.init(types: .OwnerJointIedntifyTypeBranchname),
                    OwnerJointIedntifyConfigureModel.init(types: .OwnerJointIedntifyTypeCompanyname)])
        
        arr.append([OwnerJointIedntifyConfigureModel.init(types: .OwnerJointIedntifyTypeBuildingName),
                    OwnerJointIedntifyConfigureModel.init(types: .OwnerPersonalIedntifyTypeBuildingFCType)])
        
        arr.append([OwnerJointIedntifyConfigureModel.init(types: .OwnerJointIedntifyTypeUploadFangchanzheng)])
        
        arr.append([OwnerJointIedntifyConfigureModel.init(types: .OwnerJointIedntifyTypeUploadZulinAgent)])
        
        /*
         arr.append([OwnerJointIedntifyConfigureModel.init(types: .OwnerJointIedntifyTypeUploadMainimg)])*/
        
        return arr
    }()
    
    
    var LogotView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: kWidth, height: btnHeight_44 + bottomMargin()))
        let btn = UIButton.init(frame: CGRect(x: left_pending_space_17, y: 0, width: kWidth - left_pending_space_17 * 2, height: btnHeight_44))
        btn.backgroundColor = kAppBlueColor
        btn.clipsToBounds = true
        btn.layer.cornerRadius = button_cordious_2
        btn.setTitle("提交认证", for: .normal)
        btn.setTitleColor(kAppWhiteColor, for: .normal)
        btn.titleLabel?.font = FONT_15
        btn.addTarget(self, action: #selector(logotClick), for: .touchUpInside)
        view.addSubview(btn)
        return view
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestCompanyIdentifyDetail()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        addNotify()
    }
    
    func addNotify() {
        
        //公司认证 - 发送加入网点通知
        NotificationCenter.default.addObserver(forName: NSNotification.Name.OwnerApplyEnterCompanyJoint, object: nil, queue: OperationQueue.main) { [weak self] (noti) in
            if let model = noti.object as? OwnerESBuildingSearchViewModel {
                self?.userModel?.branchesName = model.buildingAttributedName?.string
                self?.branchSearchResultVC?.view.isHidden = true
                self?.loadCollectionData()
            }
        }
        
        //公司认证 - 创建网点成功通知
        NotificationCenter.default.addObserver(forName: NSNotification.Name.OwnerCreateBranchJoint, object: nil, queue: OperationQueue.main) { [weak self] (noti) in
            if let model = noti.object as? OwnerIdentifyUserModel {
                self?.userModel?.branchNameTemp = model.buildingName
                self?.userModel?.buildingAddressTemp = "\(model.buildingAddress ?? "")\(model.address ?? "")"
                self?.branchSearchResultVC?.view.isHidden = true
                self?.loadCollectionData()
            }
        }
        
        //公司认证 - 发送加入公司通知
        NotificationCenter.default.addObserver(forName: NSNotification.Name.OwnerApplyEnterCompany, object: nil, queue: OperationQueue.main) { [weak self] (noti) in
            if let model = noti.object as? OwnerESCompanySearchViewModel {
                self?.userModel?.company = model.companyString?.string
                self?.companySearchResultVC?.view.isHidden = true
                self?.loadCollectionData()
            }
        }
        
        //公司认证 - 创建公司成功通知
        NotificationCenter.default.addObserver(forName: NSNotification.Name.OwnerCreateCompany, object: nil, queue: OperationQueue.main) { [weak self] (noti) in
            if let model = noti.object as? OwnerIdentifyUserModel {
                self?.companyNameTemp = model.company
                self?.userModel?.companyNameTemp = model.company
                self?.companySearchResultVC?.view.isHidden = true
                self?.loadCollectionData()
            }
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
        alert.ShowAlertView(withalertType: AlertType.AlertTypeMessageAlert, title: "确认离开吗？", descMsg: "信息尚未提交。点击离开，已编辑信息不保存", cancelButtonCallClick: {
            
        }) { [weak self] in
            
            self?.showSureLeaveAlert()
        }
    }
    
    func showSureLeaveAlert() {
        let alert = SureAlertView(frame: self.view.frame)
        alert.ShowAlertView(withalertType: AlertType.AlertTypeMessageAlert, title: "请再次确认是否返回？", descMsg: "", cancelButtonCallClick: {
        
        }) { [weak self] in
            
            if self?.isFromPersonalVc == true {
                self?.navigationController?.popToRootViewController(animated: true)
            }else {
                self?.leftBtnClick()
            }
            
        }
    }
}

extension OwnerJointIeditnfyVC {
    
    func detailDataShow() {
        
        if branchNameTemp == nil {
            branchNameTemp = userModel?.branchesName
            userModel?.branchNameTemp = userModel?.branchesName
        }else {
            userModel?.branchNameTemp = branchNameTemp
        }
        
        
        if companyNameTemp == nil {
            companyNameTemp = userModel?.company
            userModel?.companyNameTemp = userModel?.company
        }else {
            userModel?.companyNameTemp = companyNameTemp
        }
        
        if buildingNameTemp == nil {
            buildingNameTemp = userModel?.buildingName
            userModel?.buildingNameTemp = userModel?.buildingName
        }else {
            userModel?.buildingNameTemp = buildingNameTemp
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
                uploadPicModelFCZArr.insert(fczBannerModel, at: 0)
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
                uploadPicModelZLAgentArr.insert(lzAgentBannerModel, at: 0)
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
                if weakSelf.leaseType == nil {
                    weakSelf.leaseType = model.leaseType
                }
                
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

        if userModel?.branchesName == nil || userModel?.branchesName?.isBlankString == true{
            AppUtilities.makeToast("请选择或创建网点")
            return
        }
        
        if userModel?.company == nil || userModel?.company?.isBlankString == true{
            AppUtilities.makeToast("请选择或创建公司")
            return
        }
        
        if userModel?.buildingNameTemp == nil || userModel?.buildingNameTemp?.isBlankString == true{
            AppUtilities.makeToast("请输入写字楼")
            return
        }
        
        if uploadPicModelFCZArr.count - 1 <= 0 {
            AppUtilities.makeToast("请上传房产证")
            return
        }
        
        if leaseType == "1" {
            if uploadPicModelZLAgentArr.count - 1 <= 0 {
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

        params["leaseType"] = leaseType as AnyObject?

        ///企业关系id
        if userModel?.userLicenceId != "0" || userModel?.userLicenceId?.isBlankString != true {
            params["userLicenceId"] = userModel?.userLicenceId as AnyObject?
        }

        ///企业id

        ///如果是创建的 我给你id，你给我的id 传给你

        ///如果 我是选择关联的。我只把企业名字给你


        if userModel?.licenceId != "0" || userModel?.licenceId?.isBlankString != true {
            params["licenceId"] = userModel?.licenceId as AnyObject?
        }
        //不需要，直接就是跳转到创建公司页面
        //企业名字 - 如果关联 传
        //params["company"] = userModel?.company as AnyObject?


        ///网点id
        if userModel?.buildingId != "0" || userModel?.buildingId?.isBlankString != true {
            params["buildingId"] = userModel?.buildingId as AnyObject?
        }
        ///网点id
        if userModel?.buildingTempId != "0" || userModel?.buildingTempId?.isBlankString != true {
            params["buildingTempId"] = userModel?.buildingTempId as AnyObject?
        }

        //底部楼盘名
        if userModel?.buildingNameTemp != userModel?.buildingName {
            params["buildingName"] = userModel?.buildingNameTemp as AnyObject?

        }

        //房产证
        var fczArr: [UIImage] = []
        for model in uploadPicModelFCZArr {
            if model.isLocal == true {
                fczArr.append(model.image ?? UIImage())
            }
        }
        fczArr.remove(at: fczArr.count - 1)

        //租赁
        var alAgentArr: [UIImage] = []
        for model in uploadPicModelZLAgentArr {
            if model.isLocal == true {
                alAgentArr.append(model.image ?? UIImage())
            }
        }
        alAgentArr.remove(at: alAgentArr.count - 1)

        SSNetworkTool.SSOwnerIdentify.request_jointIdentityApp(params: params, fczImagesArray: fczArr, zlAgentImagesArray: alAgentArr, success: {[weak self] (response) in

            guard let weakSelf = self else {return}

            weakSelf.showCommitAlertview()

            }, failure: { (error) in


        }) { (code, message) in

            //只有5000 提示给用户 - 失效原因
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" || code == "\(SSCode.ERROR_CODE_7016.code)" {
                AppUtilities.makeToast(message)
            }
        }
    }
}

extension OwnerJointIeditnfyVC {
    
    @objc func logotClick() {
        self.headerCollectionView.endEditing(true)
        requestCompanyIdentify()
    }
    func setUpData() {
        userModel = OwnerIdentifyUserModel()
        userModel?.leaseType = "1"
    }
    func setUpView() {
        
        let fczBannerModel = BannerModel()
        fczBannerModel.isLocal = true
        fczBannerModel.image = UIImage.init(named: "addImgBg")
        uploadPicModelFCZArr.append(fczBannerModel)
        
        let zlAgentBannerModel = BannerModel()
        zlAgentBannerModel.isLocal = true
        zlAgentBannerModel.image = UIImage.init(named: "addImgBg")
        uploadPicModelZLAgentArr.append(zlAgentBannerModel)

        titleview = ThorNavigationView.init(type: .backTitleRightBlueBgclolor)
        titleview?.titleLabel.text = "联合办公业主认证"
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
        LogotView.snp.remakeConstraints { (make) in
            make.height.equalTo(bottomMargin() + btnHeight_44)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        headerCollectionView.register(OwnerJointIdentifyCell.self, forCellWithReuseIdentifier: OwnerJointIdentifyCell.reuseIdentifierStr)
        headerCollectionView.register(OwnerImagePickerCell.self, forCellWithReuseIdentifier: OwnerImagePickerCell.reuseIdentifierStr)
        headerCollectionView.register(OwnerImgPickerCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "OwnerImgPickerCollectionViewHeader")
        
        
        //网点
        branchSearchResultVC = OwnerCompanyESearchResultListViewController.init()
        branchSearchResultVC?.isBranch = true
        branchSearchResultVC?.view.isHidden = true
        self.view.addSubview(branchSearchResultVC?.view ?? UIView())
        
        // 传递闭包 当点击’搜索结果‘的cell调用
        branchSearchResultVC?.branchCallBack = {[weak self] (model) in
            let vc = OwnerApplyEnterCompanyViewController()
            //区分网点和公司
            vc.isBranch = true
            vc.branchModel = model
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        // 网点创建按钮 - 跳转到创建网点页面
        branchSearchResultVC?.creatButtonCallClick = {[weak self] in
            ///TODO: 要判断能不能创建
            self?.isCanCreateBranch()
        }
        
        // 关闭按钮 - 隐藏页面
        branchSearchResultVC?.closeButtonCallClick = {[weak self] in
            self?.branchSearchResultVC?.view.isHidden = true
        }
        
        //公司名
        companySearchResultVC = OwnerCompanyESearchResultListViewController.init()
        companySearchResultVC?.view.isHidden = true
        self.view.addSubview(companySearchResultVC?.view ?? UIView())
        
        // 传递闭包 当点击’搜索结果‘的cell调用 - 点击关联公司 - 带搜索信息到下个页面
        companySearchResultVC?.companyCallBack = {[weak self] (model) in
            //self?.companySearchResultVC? .view.isHidden = true
            let vc = OwnerCreateCompanyViewController()
            vc.companyModel = self?.userModel
            vc.companyModel?.company = model.companyString?.string
            vc.companyModel?.address = model.addressString?.string
            vc.companyModel?.creditNo = ""
            vc.companyModel?.businessLicense = ""
            self?.navigationController?.pushViewController(vc, animated: true)
            self?.loadCollectionData()
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
            //只需要楼盘名字
            self?.buildingNameTemp = model.buildingAttributedName?.string
            self?.userModel?.buildingNameTemp = model.buildingAttributedName?.string
            self?.buildingNameSearchResultVC?.view.isHidden = true
            self?.loadCollectionData()
        }
        
        //网点 - 楼盘没有创建
        // 创建按钮 - 隐藏 - 展示下面的楼盘地址 - 地址置空
        buildingNameSearchResultVC?.creatButtonCallClick = {[weak self] in
            
        }
        // 关闭按钮 - 隐藏页面
        buildingNameSearchResultVC?.closeButtonCallClick = {[weak self] in
            self?.buildingNameSearchResultVC?.view.isHidden = true
            self?.loadCollectionData()
        }
        
        //第一次刷新列表
        loadCollectionData()
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
                vc.companyModel = weakSelf.userModel
                vc.companyModel?.company = weakSelf.companyNameTemp
                vc.companyModel?.address = ""
                vc.companyModel?.creditNo = ""
                vc.companyModel?.businessLicense = ""
                weakSelf.navigationController?.pushViewController(vc, animated: true)
            }else if model.flag == 1 {
                AppUtilities.makeToast(model.explain ?? "公司已经存在，不能重复创建")
            }
        }
    }
    
    
    ///判断是否可以创建网点
    func isCanCreateBranch() {
        
        var params = [String:AnyObject]()
        
        params["name"] = branchName as AnyObject?
        
        
        //身份类型0个人认证1企业认证2网点认证
        params["identityType"] = UserTool.shared.user_owner_identifytype as AnyObject?
        
        params["token"] = UserTool.shared.user_token as AnyObject?
        
        SSNetworkTool.SSOwnerIdentify.request_getIsCanCreatBranch(params: params, success: {[weak self] (response) in
            
            guard let weakSelf = self else {return}
            
            if let model = BranchOrCompanyIIsExistedModel.deserialize(from: response, designatedPath: "data") {
                weakSelf.createBranchJudge(model: model)
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
    func createBranchJudge(model: BranchOrCompanyIIsExistedModel) {
        SSTool.invokeInMainThread {[weak self] in
            guard let weakSelf = self else {return}
            
            //0不存在1存在
            if model.flag == 0 {
                
                let vc = OwnerCreateBranchViewController()
                vc.userModel = weakSelf.userModel
                vc.userModel?.branchesName = self?.branchNameTemp
                vc.userModel?.buildingAddress = ""
                vc.userModel?.creditNo = ""
                vc.userModel?.fileBusinessLicense = ""
                weakSelf.navigationController?.pushViewController(vc, animated: true)
            }else if model.flag == 1 {
                AppUtilities.makeToast(model.explain ?? "网点已经存在，不能重复创建")
            }
        }
    }
    
    func loadCollectionData() {
        headerCollectionView.reloadData()
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

extension OwnerJointIeditnfyVC {
    func selectFCZPicker() {
        fczImagePickTool.cl_setupImagePickerWith(MaxImagesCount: 10 - uploadPicModelFCZArr.count) {[weak self] (asset,cutImage) in
            // 内部提供的方法可以异步获取图片，同步获取的话时间比较长，不建议！，如果是iCloud中的照片就直接从icloud中下载，下载完成后返回图片,同时也提供了下载失败的方法
            CLImagePickerTool.convertAssetArrToOriginImage(assetArr: asset, scale: 0.1, successClouse: {[weak self] (image,assetItem) in
                let img = image.resizeMax1500Image()

                let fczBannerModel = BannerModel()
                fczBannerModel.isLocal = true
                fczBannerModel.image = img
                self?.uploadPicModelFCZArr.insert(fczBannerModel, at: 0)
                }, failedClouse: { () in
                    
            })
            self?.loadCollectionData()
        }
    }
    
    func selectZLAgentPicker() {
        zlAgentImagePickTool.cl_setupImagePickerWith(MaxImagesCount: 10 - uploadPicModelZLAgentArr.count) {[weak self] (asset,cutImage) in
            // 内部提供的方法可以异步获取图片，同步获取的话时间比较长，不建议！，如果是iCloud中的照片就直接从icloud中下载，下载完成后返回图片,同时也提供了下载失败的方法
            CLImagePickerTool.convertAssetArrToOriginImage(assetArr: asset, scale: 0.1, successClouse: {[weak self] (image,assetItem) in
                let img = image.resizeMax1500Image()

                let zlAgentBannerModel = BannerModel()
                zlAgentBannerModel.isLocal = true
                zlAgentBannerModel.image = img
                self?.uploadPicModelZLAgentArr.insert(zlAgentBannerModel, at: 0)
                }, failedClouse: { () in
                    
            })
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
            loadCollectionData()
            return
        }
        
        var params = [String:AnyObject]()
        
        params["id"] = uploadPicModelFCZArr[index].id as AnyObject?
        
        params["token"] = UserTool.shared.user_token as AnyObject?
        
        SSNetworkTool.SSOwnerIdentify.request_getDeleteImgApp(params: params, success: {[weak self] (response) in
            
            guard let weakSelf = self else {return}
            
            weakSelf.uploadPicModelFCZArr.remove(at: index)
            weakSelf.loadCollectionData()
            
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
            loadCollectionData()
            return
        }
        
        var params = [String:AnyObject]()
        
        params["id"] = uploadPicModelZLAgentArr[index].id as AnyObject?
        
        params["token"] = UserTool.shared.user_token as AnyObject?
        
        SSNetworkTool.SSOwnerIdentify.request_getDeleteImgApp(params: params, success: {[weak self] (response) in
            
            guard let weakSelf = self else {return}
            
            weakSelf.uploadPicModelZLAgentArr.remove(at: index)
            weakSelf.loadCollectionData()
            
            }, failure: { (error) in
                
        }) { (code, message) in
            
            //只有5000 提示给用户 - 失效原因
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" || code == "\(SSCode.ERROR_CODE_7016.code)" {
                AppUtilities.makeToast(message)
            }
        }
    }
}

extension OwnerJointIeditnfyVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 || indexPath.section == 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OwnerJointIdentifyCell.reuseIdentifierStr, for: indexPath as IndexPath) as? OwnerJointIdentifyCell
            cell?.userModel = self.userModel
            cell?.model = typeSourceArray[indexPath.section][indexPath.item]
            
            cell?.branchNameClickClouse = { [weak self] (branchName) in
                self?.userModel?.buildingAddressTemp = ""
                self?.branchName = branchName
                self?.branchNameTemp = branchName
            }
            cell?.companyNameClickClouse = { [weak self] (companyName) in
                self?.companyName = companyName
                self?.companyNameTemp = companyName
            }
            cell?.buildingNameClickClouse = { [weak self] (buildingName) in
                self?.buildingName = buildingName
                self?.buildingNameTemp = buildingName
                self?.userModel?.buildingNameTemp = buildingName
            }
            //            cell?.buildingNameEndEditingMessageCell = { [weak self] (buildingNAme) in
            //                self?.userModel?.buildingName = buildingNAme
            //                self?.loadCollectionData()
            //            }
            return cell ?? OwnerJointIdentifyCell()
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OwnerImagePickerCell.reuseIdentifierStr, for: indexPath as IndexPath) as? OwnerImagePickerCell
            cell?.indexPath = indexPath
            if indexPath.section == 2 {
                if uploadPicModelFCZArr[indexPath.item].isLocal == false {
                    cell?.image.setImage(with: uploadPicModelFCZArr[indexPath.item].imgUrl ?? "", placeholder: UIImage(named: Default_1x1))
                }else {
                    cell?.image.image = uploadPicModelFCZArr[indexPath.item].image
                }
                cell?.closeBtnClickClouse = { [weak self] (index) in
                    self?.request_deleteFCZImgApp(index: index)
                }
                if indexPath.item == uploadPicModelFCZArr.count - 1 {
                    cell?.closeBtn.isHidden = true
                }else {
                    cell?.closeBtn.isHidden = false
                }
            }else if indexPath.section == 3 {
                if uploadPicModelZLAgentArr[indexPath.item].isLocal == false {
                    cell?.image.setImage(with: uploadPicModelZLAgentArr[indexPath.item].imgUrl ?? "", placeholder: UIImage(named: Default_1x1))
                }else {
                    cell?.image.image = uploadPicModelZLAgentArr[indexPath.item].image
                }
                cell?.closeBtnClickClouse = { [weak self] (index) in
                    self?.request_deleteZLAgentImgApp(index: index)
                }
                if indexPath.item == uploadPicModelZLAgentArr.count - 1 {
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
        ///如果是审核被驳回并且是加入的某个网点
        if userModel?.auditStatus == "2" && userModel?.authority == "0" {
            return 1
        }else {
            if let company = userModel?.company {
                if company.isBlankString == true {
                    return 1
                }else {
                    //直租
                    if leaseType == "0" {
                        return typeSourceArray.count - 1
                        }else if leaseType == "1" {
                        return typeSourceArray.count
                    }else {
                        return typeSourceArray.count - 1
                    }
                }
            }else {
                return 1
            }
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        ///如果是审核被驳回并且是加入的某个网点
        if userModel?.auditStatus == "2" && userModel?.authority == "0" {
            if section == 0 {
                return 2
            }else {
                return 0
            }
        }else {
            if section == 0 {
                if let branchName = userModel?.branchesName {
                    
                    if branchName.isBlankString == true {
                        return 2
                    }else {
                        return typeSourceArray[0].count
                    }
                }else {
                    return 2
                }
            }else if section == 1 {
                if let company = userModel?.company {
                    if company.isBlankString == true {
                        return 0
                    }else {
                        return typeSourceArray[1].count
                    }
                }else {
                    return 0
                }
            }else if section == 2 {
                if let company = userModel?.buildingNameTemp {
                    if company.isBlankString == true {
                        return 0
                    }else {
                        return uploadPicModelFCZArr.count
                    }
                }else {
                    return 0
                }
                
            }else if section == 3 {
                if let company = userModel?.buildingNameTemp {
                    if company.isBlankString == true {
                        return 0
                    }else {
                        return uploadPicModelZLAgentArr.count
                    }
                }else {
                    return 0
                }
                
            }
            /*else if section == 4 {
             if let company = userModel?.buildingName {
             if company.isBlankString == true {
             return 0
             }else {
             return 1
             }
             }else {
             return 0
             }
             
             }*/
            return 0
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0 {
            let model = typeSourceArray[0][indexPath.item]
            if model.type == .OwnerJointIedntifyTypeBranchname {
                return CGSize(width: kWidth - left_pending_space_17 * 2, height: cell_height_58 + 18)
            }else {
                return CGSize(width: kWidth - left_pending_space_17 * 2, height: cell_height_58)
            }
        }else if indexPath.section == 1 {
            let model = typeSourceArray[1][indexPath.item]
            if model.type == .OwnerJointIedntifyTypeBuildingName {
                return CGSize(width: kWidth - left_pending_space_17 * 2, height: cell_height_58 + 18)
            }else {
                return CGSize(width: kWidth - left_pending_space_17 * 2, height: cell_height_58)
            }
        }else if indexPath.section == 2 {
            return CGSize(width: (kWidth - left_pending_space_17 * 2 - 5 * 2) / 3.0 - 1, height: (kWidth - left_pending_space_17 * 2 - 5 * 2) / 3.0 - 1)
        }else if indexPath.section == 3 {
            return CGSize(width: (kWidth - left_pending_space_17 * 2 - 5 * 2) / 3.0 - 1, height: (kWidth - left_pending_space_17 * 2 - 5 * 2) / 3.0 - 1)
        }
        /*else if indexPath.section == 4 {
         return CGSize(width: (kWidth - left_pending_space_17 * 2 - 5 * 2) / 3.0 - 1, height: (kWidth - left_pending_space_17 * 2 - 5 * 2) / 3.0 - 1)
         }*/
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
            
        }else {
            if indexPath.section == 2 {
                if indexPath.item == uploadPicModelFCZArr.count - 1 {
                    selectFCZPicker()
                }
            }else if indexPath.section == 3 {
                if indexPath.item == uploadPicModelZLAgentArr.count - 1 {
                    selectZLAgentPicker()
                }
            }
            /*else if indexPath.section == 4 {
             selectMainPagePicker()
             }*/
            
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
            /*else if indexPath.section == 4{
             header?.backgroundColor = kAppWhiteColor
             header?.titleLabel.text = "上传楼盘封面图"
             header?.descLabel.text = ""
             }*/
            
            return header ?? UICollectionReusableView()
        }
        
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: kWidth - left_pending_space_17 * 2, height: 0)
            
        }else if section == 1 {
            return CGSize(width: kWidth, height: 10)
            
        }else if section == 2 || section == 3 {
            if let buildingName = userModel?.buildingNameTemp {
                if buildingName.isBlankString == true {
                    return CGSize(width: kWidth, height: 0)
                }else {
                    return CGSize(width: kWidth, height: 68)
                }
            }else {
                return CGSize(width: kWidth, height: 0)
            }
            
        }
            /*else if section == 4 {
             if let buildingName = userModel?.buildingName {
             if buildingName.isBlankString == true {
             return CGSize(width: kWidth, height: 0)
             }else {
             return CGSize(width: kWidth, height: 46)
             }
             
             }else {
             return CGSize(width: kWidth, height: 0)
             }
             
             }*/
        else {
            return CGSize.zero
        }
    }
    
    //这个是两行cell之间的间距（上下行cell的间距）
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if section == 0 || section == 1 {
            return 0
        }else {
            //            return left_pending_space_17
            return 5
        }
    }
    
    ////两个cell之间的间距（同一行的cell的间距）
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if section == 0 || section == 1 {
            return 0
        }else {
            //            return left_pending_space_17
            return 5
        }
    }
}

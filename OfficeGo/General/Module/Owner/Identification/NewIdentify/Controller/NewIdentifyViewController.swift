//
//  NewIdentifyViewController.swift
//  OfficeGo
//
//  Created by Mac pro on 2020/11/17.
//  Copyright © 2020 Senwei. All rights reserved.
//

import CLImagePickerTool

class NewIdentifyViewController: BaseViewController {
    
    var buildingId : String?

    var isOpen: Bool? {
        didSet {
            loadCollectionSectionData(section: 0)
        }
    }
    
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
    
    //写字楼名称搜索结果vc
    var buildingNameSearchResultVC: OwnerBuildingNameESearchResultListViewController?
        
    var buildingName: String? {
        didSet {
            let rect = headerCollectionView.layoutAttributesForItem(at: IndexPath.init(row: 0, section: 0))
            let cellRect = rect?.frame ?? CGRect.zero
            let cellFrame = headerCollectionView.convert(cellRect, to: self.view)
            if buildingName?.isBlankString == true {
                buildingNameSearchResultVC?.view.isHidden = true
                buildingNameSearchResultVC?.keywords = ""
            }else {
                buildingNameSearchResultVC?.view.isHidden = false
                buildingNameSearchResultVC?.keywords = buildingName
            }
            buildingNameSearchResultVC?.view.snp.remakeConstraints({ (make) in
                make.top.equalTo(cellFrame.minY + cell_height_58 + cell_height_58 + 1)
                make.leading.trailing.equalToSuperview()
                make.bottom.equalToSuperview()
            })
        }
    }
    
    ///房产证
    @objc var uploadPicModelFCZArr = [BannerModel]()  // 在实际的项目中可能用于存储图片的url
    ///补充材料
    @objc var uploadPicModelBuChongArr = [BannerModel]()  // 在实际的项目中可能用于存储图片的url
    ///营业执照和身份证
    @objc var uploadPicModelYingyeArr = [BannerModel]()  // 在实际的项目中可能用于存储图片的url
    
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
    var typeSourceArray:[[OwnerNewIedntifyConfigureModel]] = {
        var arr = [[OwnerNewIedntifyConfigureModel]]()
        arr.append([OwnerNewIedntifyConfigureModel.init(types: .OwnerNewIdentifyTypeBuildingName)])
        
        arr.append([OwnerNewIedntifyConfigureModel.init(types: .OwnerNewIdentifyTypeUploadFangchanzheng)])
        
        arr.append([OwnerNewIedntifyConfigureModel.init(types: .OwnerNewIdentifyTypeQuanLiRenType)])

        arr.append([OwnerNewIedntifyConfigureModel.init(types: .OwnerNewIdentifyTypeYinYeOrIdCard)])

        arr.append([OwnerNewIedntifyConfigureModel.init(types: .OwnerNewIdentifyTypeAddtional)])
        
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
        UserTool.shared.user_owner_identifytype = 1
        setUpView()
        addNotify()
        requestCompanyIdentifyDetail()
    }
    
    func addNotify() {
        
        //公司认证 - 创建写字楼通知
        NotificationCenter.default.addObserver(forName: NSNotification.Name.OwnerCreateBuilding, object: nil, queue: OperationQueue.main) { [weak self] (noti) in
            let model = noti.object as? OwnerIdentifyUserModel

            self?.isHasBuilding = true
            
            self?.userModel?.isCreateBuilding = "1"
            self?.userModel?.btype = model?.btype
            self?.userModel?.buildingName = model?.buildingName
            self?.userModel?.buildingAddress = model?.buildingAddress
            self?.userModel?.district = model?.district
            self?.userModel?.business = model?.business
            self?.userModel?.districtString = model?.districtString
            self?.userModel?.businessString = model?.businessString
            self?.userModel?.creditNo = model?.creditNo
            self?.userModel?.businessLicense = model?.businessLicense
            self?.userModel?.mainPicBannermodel = model?.mainPicBannermodel
            self?.buildingName = ""
            self?.buildingNameSearchResultVC?.view.isHidden = true
            self?.headerCollectionView.endEditing(true)
            self?.loadCollectionSectionData(section: 0)
        }
        
        
    }
    ///左上角按钮
    func showLeaveAlert() {
        self.headerCollectionView.endEditing(true)
        let alert = SureAlertView(frame: self.view.frame)
        alert.bottomBtnView.rightSelectBtn.setTitle("离开", for: .normal)
        alert.ShowAlertView(withalertType: AlertType.AlertTypeMessageAlert, title: "信息尚未提交，是否确认离开？", descMsg: "", cancelButtonCallClick: {
            
        }) { [weak self] in
            
            if self?.isFromPersonalVc == true {
                self?.navigationController?.popToRootViewController(animated: true)
            }else {
                self?.leftBtnClick()
            }
        }
    }
    
}

extension NewIdentifyViewController {
    
    func detailDataShow() {
        
        userModel?.frontBannerModel = BannerModel()
        
        userModel?.reverseBannerModel = BannerModel()

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
        for lzAgentBannerModel in uploadPicModelBuChongArr {
            if lzAgentBannerModel.isLocal == false {
                uploadPicModelBuChongArr.remove(lzAgentBannerModel)
            }
        }
        
        ///添加新的租赁协议数据
        if let contract = userModel?.contract {
            
            for lzAgentBannerModel in contract {
                lzAgentBannerModel.isLocal = false
                uploadPicModelBuChongArr.append(lzAgentBannerModel)
            }
        }
        
        loadCollectionData()
    }
    
    ///获取信息
    func requestCompanyIdentifyDetail() {
        
        var params = [String:AnyObject]()
        
        params["token"] = UserTool.shared.user_token as AnyObject?
        
        
        params["buildingId"] = buildingId as AnyObject?
        
        
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
            if uploadPicModelBuChongArr.count <= 0 {
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
            for model in uploadPicModelBuChongArr {
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

extension NewIdentifyViewController {
    
    @objc func logotClick() {
        NotificationCenter.default.post(name: NSNotification.Name.OwnerIdentifySuccess, object: nil)
        self.navigationController?.popToRootViewController(animated: true)

//        self.headerCollectionView.endEditing(true)
//        requestCompanyIdentify()
    }
    func setUpData() {
        userModel = OwnerIdentifyUserModel()
        userModel?.frontBannerModel = BannerModel()
        userModel?.reverseBannerModel = BannerModel()
    }
    func setUpView() {
        
        titleview = ThorNavigationView.init(type: .backTitleRightBlueBgclolor)
        titleview?.titleLabel.text = "房东认证"
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
        
        headerCollectionView.register(OwnerNewIdentifyRejectViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "OwnerNewIdentifyRejectViewHeader")

        ///楼盘名字地址展示cell
        headerCollectionView.register(OwnerNewIdentifyCell.self, forCellWithReuseIdentifier: OwnerNewIdentifyCell.reuseIdentifierStr)
        ///权利人cell
        headerCollectionView.register(OwnerCompanyIdentifyCell.self, forCellWithReuseIdentifier: OwnerCompanyIdentifyCell.reuseIdentifierStr)
        ///房产证 营业执照 补充材料
        headerCollectionView.register(OwnerNewIdentifyImgCell.self, forCellWithReuseIdentifier: OwnerNewIdentifyImgCell.reuseIdentifierStr)
        ///身份证
        headerCollectionView.register(OwnerNewPersonIDCardIdentifyImgCell.self, forCellWithReuseIdentifier: "OwnerNewPersonIDCardIdentifyImgCell.reuseIdentifierStr")
        //写字楼
        buildingNameSearchResultVC = OwnerBuildingNameESearchResultListViewController.init()
        buildingNameSearchResultVC?.view.isHidden = true
        self.view.addSubview(buildingNameSearchResultVC?.view ?? UIView())
        
        // 传递闭包 当点击’搜索结果‘的cell调用
        buildingNameSearchResultVC?.buildingCallBack = {[weak self] (model) in
            // 搜索完成 关闭resultVC
            
            self?.isHasBuilding = true

            //判断楼盘是关联的还是自己创建的
            self?.userModel?.isCreateBuilding = "2"
            
            self?.userModel?.btype = "\(model.buildType ?? 0)"
            self?.userModel?.buildingId = model.bid
            self?.userModel?.buildingName = model.buildingAttributedName?.string
            self?.userModel?.buildingAddress = model.addressString?.string
            
            self?.buildingNameSearchResultVC?.view.isHidden = true
            self?.loadCollectionSectionData(section: 0)
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
            userModel.btype = nil
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
    
    func loadCollectionData() {
        headerCollectionView.reloadData()
    }
    
    func loadCollectionSectionData(section: Int) {
        headerCollectionView.reloadSections(NSIndexSet.init(index: section) as IndexSet)
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

extension NewIdentifyViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OwnerNewIdentifyCell.reuseIdentifierStr, for: indexPath as IndexPath) as? OwnerNewIdentifyCell
            cell?.userModel = self.userModel
            cell?.model = typeSourceArray[indexPath.section][indexPath.item]
            cell?.buildingNameClickClouse = { [weak self] (buildingName) in
                //清除 公司名字 字段改为空
                self?.userModel?.isCreateBuilding = ""
                
                self?.userModel?.buildingName = ""
                self?.userModel?.buildingAddress = ""
                self?.buildingName = buildingName
            }
            cell?.editClickBack = { [weak self] (type) in
                //楼盘编辑
                if type == OwnerNewIdentifyType.OwnerNewIdentifyTypeBuildingName {
                    let vc = OwnerCreateBuildingViewController()
                    vc.userModel = self?.userModel
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            }
            cell?.closeClickBack = { [weak self] (type) in
                //公司编辑
                if type == .OwnerNewIdentifyTypeBuildingName {
                    //清除 楼盘名字地址 字段改为空
                    self?.userModel?.isCreateBuilding = ""
                    
                    self?.userModel?.buildingName = ""
                    self?.userModel?.buildingAddress = ""
                    
                    self?.buildingName = ""
                }
            }
            return cell ?? OwnerNewIdentifyCell()
        }else if indexPath.section == 2{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OwnerCompanyIdentifyCell.reuseIdentifierStr, for: indexPath as IndexPath) as? OwnerCompanyIdentifyCell
            cell?.userModel = userModel
            let model = typeSourceArray[indexPath.section][indexPath.item]
            cell?.titleLabel.attributedText = model.getNameFormType(type: model.type ?? .OwnerNewIdentifyTypeQuanLiRenType)
            cell?.numDescTF.placeholder = model.getDescFormType(type: model.type ?? .OwnerNewIdentifyTypeQuanLiRenType)
            cell?.editBtn.isHidden = true
            cell?.closeBtn.isHidden = true
            cell?.numDescTF.isUserInteractionEnabled = false
            return cell ?? OwnerCompanyIdentifyCell()
        }else {
            
            if indexPath.section == 3 {
                
                if UserTool.shared.user_owner_identifytype == 0 {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OwnerNewPersonIDCardIdentifyImgCell.reuseIdentifierStr", for: indexPath as IndexPath) as? OwnerNewPersonIDCardIdentifyImgCell
                    cell?.presentVC = self
                    cell?.userModel = userModel
                    cell?.model = typeSourceArray[indexPath.section][indexPath.item]
                    return cell ?? OwnerNewPersonIDCardIdentifyImgCell()
                }else {
                    
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OwnerNewIdentifyImgCell.reuseIdentifierStr, for: indexPath) as? OwnerNewIdentifyImgCell
                    cell?.presentVC = self
                    cell?.userModel = userModel ?? OwnerIdentifyUserModel()
                    cell?.model = typeSourceArray[indexPath.section][indexPath.item]
                    cell?.imgSelectClickBlock = { [weak self] (usermodel) in
                        self?.userModel = usermodel
                        self?.loadCollectionSectionData(section: indexPath.section)
                    }
                    return cell ?? OwnerNewIdentifyImgCell.init(frame: .zero)
                    
                }
            }else {
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OwnerNewIdentifyImgCell.reuseIdentifierStr, for: indexPath) as? OwnerNewIdentifyImgCell
                cell?.presentVC = self
                cell?.userModel = userModel ?? OwnerIdentifyUserModel()
                cell?.model = typeSourceArray[indexPath.section][indexPath.item]
                cell?.imgSelectClickBlock = { [weak self] (usermodel) in
                    self?.userModel = usermodel
                    self?.loadCollectionSectionData(section: indexPath.section)
                }
                return cell ?? OwnerNewIdentifyImgCell.init(frame: .zero)
                
            }
            
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {

        return 5
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        ///楼盘名
        if section == 0 {
            return 1
        }
        ///房产证
        else if section == 1 {
            return 1
        }
        ///权利人类型 - 只有楼盘和个人有
        else if section == 2 {
            ///身份类型0个人1企业2联合
            if UserTool.shared.user_owner_identifytype == 0 {
                return 1
            }else if UserTool.shared.user_owner_identifytype == 1 {
                return 1
            }else if UserTool.shared.user_owner_identifytype == 2 {
                return 0
            }else {
                return 0
            }
        }
        ///营业执照 - 只有楼盘和网点有
        ///身份证 - 个人
        else if section == 3 {
            ///身份类型0个人1企业2联合
            if UserTool.shared.user_owner_identifytype == 0 {
                return 1
            }else if UserTool.shared.user_owner_identifytype == 1 {
                return 1
            }else if UserTool.shared.user_owner_identifytype == 2 {
                return 1
            }else {
                return 0
            }
        }else {
            return 1
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (kWidth - left_pending_space_17 * 2) / 3.0 - 1

        if indexPath.section == 0 {
            if userModel?.buildingName != nil {
                return CGSize(width: kWidth, height: cell_height_58 * 2)
            }else {
                return CGSize(width: kWidth, height: cell_height_58 * 2)
            }
        }else if indexPath.section == 1 {
            if let count = userModel?.fczLocalLocalImgArr.count {
                return CGSize(width: kWidth, height: CGFloat((count + 3) / 3) * CGFloat(width + 5) + 68)
            }else {
                return CGSize(width: kWidth, height: width + 68)
            }

        }else if indexPath.section == 2 {
            ///身份类型0个人1企业2联合
            if UserTool.shared.user_owner_identifytype == 0 {
                return CGSize(width: kWidth - left_pending_space_17 * 2, height: cell_height_58)
            }else if UserTool.shared.user_owner_identifytype == 1 {
                return CGSize(width: kWidth - left_pending_space_17 * 2, height: cell_height_58)
            }else if UserTool.shared.user_owner_identifytype == 2 {
                return CGSize(width: 0, height: 0)
            }else {
                return CGSize(width: 0, height: 0)
            }
        }else if indexPath.section == 3 {
            if UserTool.shared.user_owner_identifytype == 0 {
                return CGSize(width: kWidth, height: OwnerNewPersonIDCardIdentifyImgCell.rowHeight())
            }else {
                if let count = userModel?.businessLicenseLocalImgArr.count {
                    return CGSize(width: kWidth, height: CGFloat((count + 3) / 3) * CGFloat(width + 5) + 68)
                }else {
                    return CGSize(width: kWidth, height: width + 68)
                }
            }
            
        }else {
            if let count = userModel?.addtionalLocalImgArr.count {
                return CGSize(width: kWidth, height: CGFloat((count + 3) / 3) * CGFloat(width + 5) + 68)
            }else {
                return CGSize(width: kWidth, height: width + 68)
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 || section == 2 {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        }else {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            if indexPath.item == 0 {
                
                let alertController = UIAlertController.init(title: "权利人类型", message: nil, preferredStyle: .actionSheet)
                let refreshAction = UIAlertAction.init(title: "公司", style: .default) {[weak self] (action: UIAlertAction) in
                    UserTool.shared.user_owner_identifytype = 1
                    self?.loadCollectionData()
                }
                let copyAction = UIAlertAction.init(title: "个人", style: .default) {[weak self] (action: UIAlertAction) in
                    UserTool.shared.user_owner_identifytype = 0
                    self?.loadCollectionData()
                }
                let copy1Action = UIAlertAction.init(title: "网点", style: .default) {[weak self] (action: UIAlertAction) in
                    UserTool.shared.user_owner_identifytype = 2
                    self?.loadCollectionData()
                }
                let cancelAction = UIAlertAction.init(title: "取消", style: .cancel) { (action: UIAlertAction) in
                    
                }
                alertController.addAction(refreshAction)
                alertController.addAction(copyAction)
                alertController.addAction(copy1Action)
                alertController.addAction(cancelAction)
                
                present(alertController, animated: true, completion: nil)
            }
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "OwnerNewIdentifyRejectViewHeader", for: indexPath) as? OwnerNewIdentifyRejectViewHeader
            header?.backgroundColor = kAppColor_line_EEEEEE
            
            if indexPath.section == 0 {
                header?.backgroundColor = kAppLightRedColor
                header?.isOpenBlock = { [weak self] (isOpen) in
                    self?.isOpen = isOpen
                }
                header?.isOpen = isOpen
                header?.openBtn.isHidden = false
                userModel?.remark = "userModel?.remarkuserModel?.remarkuserModel?.remarkuserModel?.remarkuserModel?.remarkuserModel?.remarkuserModel?.remarkuserModel?.remarkuserModel?.remarkuserModel?.remarkuserModel?.remarkuserModel?.remarkuserModel?.remarkuserModel?.remarkuserModel?.remarkuserModel?.remarkuserModel?.remarkuserModel?.remarkuserModel?.remarkuserModel?.remarkuserModel?.remarkuserModel?.remark"
                
                header?.rejectReasonLabel.text = "驳回原因：\(userModel?.remark ?? "")"
                
            }else if indexPath.section == 2 {
                header?.rejectReasonLabel.text = ""
                header?.openBtn.isHidden = true
                header?.backgroundColor = kAppColor_line_EEEEEE
            }else {
                header?.backgroundColor = kAppWhiteColor
            }
            return header ?? UICollectionReusableView()
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            if isOpen == true {
                
                userModel?.remark = "userModel?.remarkuserModel?.remarkuserModel?.remarkuserModel?.remarkuserModel?.remarkuserModel?.remarkuserModel?.remarkuserModel?.remarkuserModel?.remarkuserModel?.remarkuserModel?.remarkuserModel?.remarkuserModel?.remarkuserModel?.remarkuserModel?.remarkuserModel?.remarkuserModel?.remarkuserModel?.remarkuserModel?.remarkuserModel?.remarkuserModel?.remarkuserModel?.remark"
                
                if userModel?.remark?.count ?? 0 > 0 {
                    let str = "驳回原因：\(userModel?.remark ?? "")"

                    let size = str.boundingRect(with: CGSize(width: kWidth - left_pending_space_17 - 42, height: 8000), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : FONT_13], context: nil)
                    
                    var height: CGFloat = 0
                    height = size.height + 24
                    
                    return CGSize(width: kWidth, height: height)
                }else {
                    return CGSize.zero
                }
                
            }else {
                return CGSize(width: kWidth, height: 42)
            }
        }else if section == 2 {
            return CGSize(width: kWidth, height: 12)
        }
        return CGSize.zero
    }
    //这个是两行cell之间的间距（上下行cell的间距）
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    ////两个cell之间的间距（同一行的cell的间距）
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

class OwnerNewIdentifyCell: BaseCollectionViewCell {
    
    lazy var rejectImg: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.init(named: "redLine")
//        view.backgroundColor = kAppRedColor
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.setContentCompressionResistancePriority(.required, for: .horizontal)
        view.font = FONT_14
        view.textColor = kAppColor_999999
        return view
    }()
    lazy var numDescTF: UITextField = {
        let view = UITextField()
        view.textAlignment = .left
        view.font = FONT_14
        view.delegate = self
        view.textColor = kAppColor_333333
        return view
    }()
    lazy var buildingMsgView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var tagView: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.font = FONT_MEDIUM_10
        view.textColor = kAppWhiteColor
        view.backgroundColor = kAppBlueColor
        view.clipsToBounds = true
        view.layer.cornerRadius = button_cordious_2
        return view
    }()
    lazy var buildingNameLabel: UILabel = {
        let view = UILabel()
        view.font = FONT_14
        view.textColor = kAppColor_333333
        return view
    }()
    lazy var houselocationIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.init(named: "locationGray")
        view.contentMode = .scaleAspectFit
        return view
    }()
    lazy var houseAddressLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_LIGHT_11
        view.textColor = kAppColor_333333
        return view
    }()
    lazy var editBtn: UIButton = {
        let btn = UIButton.init()
        btn.setImage(UIImage.init(named: "idenEdit"), for: .normal)
        btn.addTarget(self, action: #selector(editClick), for: .touchUpInside)
        return btn
    }()
    lazy var closeBtn: UIButton = {
        let btn = UIButton.init()
        btn.setImage(UIImage.init(named: "idenDelete"), for: .normal)
        btn.addTarget(self, action: #selector(closeClick), for: .touchUpInside)
        return btn
    }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = kAppColor_line_EEEEEE
        return view
    }()
    
    //按钮点击方法
    var editClickBack:((OwnerNewIdentifyType) -> Void)?
    
    @objc func editClick() {
        guard let blockk = editClickBack else {
            return
        }
        blockk(OwnerNewIdentifyType.OwnerNewIdentifyTypeBuildingName)
    }
    
    var closeClickBack:((OwnerNewIdentifyType) -> Void)?
    
    @objc func closeClick() {
        editBtn.isHidden = true
        numDescTF.isHidden = false
        buildingMsgView.isHidden = true
        numDescTF.text = ""
        numDescTF.becomeFirstResponder()
        guard let blockk = self.closeClickBack else {
            return
        }
        blockk(OwnerNewIdentifyType.OwnerNewIdentifyTypeBuildingName)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    class func rowHeight() -> CGFloat {
        return cell_height_58
    }
    //公司名字
    @objc var companyNameClickClouse: IdentifyEditingClickClouse?
    
    //大楼名称
    @objc var buildingNameClickClouse: IdentifyEditingClickClouse?
    
    //写字楼地址
    var buildingAddresEndEditingMessageCell:((String) -> Void)?
    
    //写字楼名称址
    var buildingNameEndEditingMessageCell:((String) -> Void)?
    
    //模拟认证模型
    var userModel: OwnerIdentifyUserModel?
    
    var model: OwnerNewIedntifyConfigureModel = OwnerNewIedntifyConfigureModel(types: .OwnerNewIdentifyTypeBuildingName) {
        didSet {
                        
            titleLabel.attributedText = model.getNameFormType(type: model.type ?? .OwnerNewIdentifyTypeBuildingName)
            numDescTF.placeholder = model.getDescFormType(type: model.type ?? .OwnerNewIdentifyTypeBuildingName)
            if userModel?.btype == "1" {
                tagView.text = "楼盘"
            }else {
                tagView.text = "网点"
            }
            if model.type == .OwnerNewIdentifyTypeBuildingName {
                closeBtn.isHidden = false
                //0 空   无定义     1创建  2关联吗
                //就是自己创建
                if userModel?.isCreateBuilding == "1" {
                    //1的就是自己创建
                    //不能输入框修改
                    //有编辑按钮
                    //有清空
                    numDescTF.isHidden = true
                    editBtn.isHidden = false
                    buildingMsgView.isHidden = false
                    buildingNameLabel.text = userModel?.buildingName
                    houseAddressLabel.text = userModel?.buildingAddress
                }else if userModel?.isCreateBuilding == "2" {
                    //0 就是关联的公司
                    //不能输入框修改
                    //无编辑按钮
                    //有清空
                    numDescTF.isHidden = true
                    editBtn.isHidden = true
                    buildingMsgView.isHidden = false
                    buildingNameLabel.text = userModel?.buildingName
                    houseAddressLabel.text = userModel?.buildingAddress
                }else {
                    //如果没有提交过，应该返回一个""
                    //"" 没有提交过
                    //能输入框修改
                    //无编辑按钮
                    //有清空
                    numDescTF.isHidden = false
                    editBtn.isHidden = true
                    buildingMsgView.isHidden = true
                }
            }
        }
    }
    func setupViews() {

        self.backgroundColor = kAppWhiteColor
  
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(numDescTF)
        self.contentView.addSubview(buildingMsgView)
        self.contentView.addSubview(lineView)
        self.contentView.addSubview(rejectImg)

        buildingMsgView.addSubview(tagView)
        buildingMsgView.addSubview(buildingNameLabel)
        buildingMsgView.addSubview(houselocationIcon)
        buildingMsgView.addSubview(houseAddressLabel)
        buildingMsgView.addSubview(editBtn)
        buildingMsgView.addSubview(closeBtn)
        
        rejectImg.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(10)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(left_pending_space_17)
            make.top.equalToSuperview()
            make.height.equalTo(cell_height_58)
        }
        
        numDescTF.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.trailing.equalTo(titleLabel)
        }
        
        buildingMsgView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.trailing.equalTo(titleLabel)
            make.bottom.equalToSuperview()
        }

        buildingNameLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(38)
            make.top.equalToSuperview()
            make.trailing.equalToSuperview().inset(-50)
        }
        tagView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.centerY.equalTo(buildingNameLabel)
            make.size.equalTo(CGSize(width: 30, height: 16))
        }
        houseAddressLabel.snp.makeConstraints { (make) in
            make.top.equalTo(buildingNameLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(14)
            make.trailing.equalToSuperview()
        }
        houselocationIcon.snp.makeConstraints { (make) in
            make.leading.equalTo(tagView)
            make.centerY.height.equalTo(houseAddressLabel)
            make.width.equalTo(12)
        }
        
        closeBtn.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview()
            make.width.equalTo(25)
            make.centerY.equalTo(buildingNameLabel)
            make.height.equalTo(25)
        }
        editBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(closeBtn.snp.leading).offset(-3)
            make.width.equalTo(25)
            make.centerY.equalTo(buildingNameLabel)
            make.height.equalTo(25)
        }
        lineView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        
        numDescTF.addTarget(self, action: #selector(valueDidChange), for: .editingChanged)
        
    }
    @objc func valueDidChange() {
        
        if model.type == .OwnerNewIdentifyTypeBuildingName {
            guard let blockk = self.buildingNameClickClouse else {
                return
            }
            let textNum = numDescTF.text?.count
            
            //截取
            if textNum! > ownerMaxBuildingnameNumber_20 {
                let index = numDescTF.text?.index((numDescTF.text?.startIndex)!, offsetBy: ownerMaxBuildingnameNumber_20)
                let str = numDescTF.text?.substring(to: index!)
                numDescTF.text = str
            }
            
            blockk(numDescTF.text ?? "")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
}

extension OwnerNewIdentifyCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        //只有写字楼名称要在编辑结束的时候传过去
        if model.type == .OwnerNewIdentifyTypeBuildingName {
            guard let blockk = self.buildingNameEndEditingMessageCell else {
                return
            }
            blockk(textField.text ?? "")
        }
    }
}

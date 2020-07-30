//
//  OwnerPersonalIeditnfyVC.swift
//  OfficeGo
//
//  Created by mac on 2020/7/16.
//  Copyright © 2020 Senwei. All rights reserved.
//

import CLImagePickerTool

class OwnerPersonalIeditnfyVC: BaseViewController {
    
    ///判断页面时候来自于个人中心驳回页面
    var isFromPersonalVc: Bool = false
    
    //判断身份证照片是否是第一次调取接口
    var isFirst: Bool = false
    
    var userNameTemp: String?
    
    var userIdCardTemp: String?
    
    ///楼盘名字 自己选择的 - 可能是接口返回的
    var buildingNameTemp: String?

    ///楼地址
    var buildingAddressTemp : String?
    
    ///租赁类型0直租1转租 自己选择的 - 可能是接口返回的
    var leaseTypeTemp: String?
    
    ///楼盘id 自己选择关联之后用自己的 - 没有选择可能是接口返回的
    var buildingTempSelfId: String?

    var isFront: Bool? = true
    
    //身份证 - 正
    var frontBannerModel: BannerModel?
    
    //身份证 - 反
    var reverseBannerModel: BannerModel?
    
    var userModel: OwnerIdentifyUserModel?
    
    //写字楼名称搜索结果vc
    var buildingNameSearchResultVC: OwnerBuildingNameESearchResultListViewController?
    
    var buildingName: String? {
        didSet {
            let rect = headerCollectionView.layoutAttributesForItem(at: IndexPath.init(row: 0, section: 2))
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
    
    var typeSourceArray:[[OwnerPersonalIedntifyConfigureModel]] = {
        var arr = [[OwnerPersonalIedntifyConfigureModel]]()
        
        arr.append([OwnerPersonalIedntifyConfigureModel.init(types: .OwnerPersonalIedntifyTypeIdentify),
                    OwnerPersonalIedntifyConfigureModel.init(types: .OwnerPersonalIedntifyTypeUserName),
                    OwnerPersonalIedntifyConfigureModel.init(types: .OwnerPersonalIedntifyTypeUserIdentifyCode)
        ])
        arr.append([OwnerPersonalIedntifyConfigureModel.init(types: .OwnerPersonalIedntifyTypeUploadIdentifyPhoto)])
        arr.append([OwnerPersonalIedntifyConfigureModel.init(types: .OwnerPersonalIedntifyTypeBuildingName),
                    //                    OwnerPersonalIedntifyConfigureModel.init(types: .OwnerPersonalIedntifyTypeBuildingAddress),
            OwnerPersonalIedntifyConfigureModel.init(types: .OwnerPersonalIedntifyTypeBuildingFCType)])
        
        arr.append([OwnerPersonalIedntifyConfigureModel.init(types: .OwnerPersonalIedntifyTypeUploadFangchanzheng)])
        
        arr.append([OwnerPersonalIedntifyConfigureModel.init(types: .OwnerPersonalIedntifyTypeUploadZulinAgent)])
        
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
        
        //个人认证 - 创建办公楼通知
        NotificationCenter.default.addObserver(forName: NSNotification.Name.OwnerCreateBuilding, object: nil, queue: OperationQueue.main) { [weak self] (noti) in
            if let model = noti.object as? OwnerIdentifyUserModel {
                self?.buildingNameTemp = model.buildingName
                self?.userModel?.buildingNameTemp = model.buildingName
                self?.buildingAddressTemp = model.buildingAddress
                self?.userModel?.buildingAddressTemp = model.buildingAddress
                self?.buildingNameSearchResultVC?.view.isHidden = true
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

extension OwnerPersonalIeditnfyVC {
    
    func detailDataShow() {
        
        if isFirst == true {
            
        }else {
            if let front = userModel?.idFront {
                frontBannerModel?.image = nil
                frontBannerModel?.imgUrl = front
            }else {
                frontBannerModel?.imgUrl = nil
            }
            
            if let reverse = userModel?.idBack {
                reverseBannerModel?.image = nil
                reverseBannerModel?.imgUrl = reverse
            }else {
                reverseBannerModel?.imgUrl = nil
            }
        }
        
        if buildingTempSelfId == nil {
            buildingTempSelfId = userModel?.buildingId
        }
        //租赁类型
        if leaseTypeTemp == nil {
            if let leaseType = userModel?.leaseType {
                leaseTypeTemp = leaseType
                userModel?.leaseTypeTemp = leaseType
            }else {
                leaseTypeTemp = "0"
                userModel?.leaseTypeTemp = "0"
            }

        }else {
            userModel?.leaseTypeTemp = leaseTypeTemp
        }
        
        //姓名处理
        if userNameTemp == nil {
            userNameTemp = userModel?.proprietorRealname
            userModel?.userNameTemp = userModel?.proprietorRealname
        }else {
            userModel?.userNameTemp = userNameTemp
        }
        //身份证
        if userIdCardTemp == nil {
            userIdCardTemp = userModel?.idCard
            userModel?.userIdCardTemp = userModel?.idCard
        }else {
            userModel?.userIdCardTemp = userIdCardTemp
        }
        //楼盘名字
        if buildingNameTemp == nil {
            buildingNameTemp = userModel?.buildingName
            userModel?.buildingNameTemp = userModel?.buildingName
        }else {
            userModel?.buildingNameTemp = buildingNameTemp
        }
        if buildingAddressTemp == nil {
            buildingAddressTemp = userModel?.buildingAddress
            userModel?.buildingAddressTemp = userModel?.buildingAddress
        }else {
            userModel?.buildingAddressTemp = buildingAddressTemp
        }
               
        isFirst = true
        
       
                
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
        
        if userModel?.userNameTemp == nil || userModel?.userNameTemp?.isBlankString == true{
            AppUtilities.makeToast("请输入姓名")
            return
        }
        
        if userModel?.userIdCardTemp == nil || userModel?.userIdCardTemp?.isBlankString == true{
            AppUtilities.makeToast("请输入身份证号")
            return
        }else if SSTool.isPureStrOrNumNumber(text: userModel?.userIdCardTemp ?? "") != true {
            AppUtilities.makeToast("请输入的正确身份证号")
            return
        }
        
        
        var frontArr: [UIImage] = []
        
        if let imgUrl = frontBannerModel?.imgUrl {
            if imgUrl.count > 0 {
                
            }else {
                if let image = frontBannerModel?.image {
                    frontArr.append(image)
                }
                if frontArr.count <= 0 {
                    AppUtilities.makeToast("请上传身份证人像片")
                    return
                }
            }
        }else {
            if let image = frontBannerModel?.image {
                frontArr.append(image)
            }
            if frontArr.count <= 0 {
                AppUtilities.makeToast("请上传身份证人像片")
                return
            }
        }
        
        var reverseArr: [UIImage] = []
        
        if let imgUrl = reverseBannerModel?.imgUrl {
            if imgUrl.count > 0 {
                
            }else {
                if let image = reverseBannerModel?.image {
                    reverseArr.append(image)
                }
                if reverseArr.count <= 0 {
                    AppUtilities.makeToast("请上传身份证国徽片")
                    return
                }
            }
        }else {
            if let image = reverseBannerModel?.image {
                reverseArr.append(image)
            }
            if reverseArr.count <= 0 {
                AppUtilities.makeToast("请上传身份证国徽片")
                return
            }
        }
        
        
        
        if userModel?.buildingNameTemp == nil || userModel?.buildingNameTemp?.isBlankString == true{
            AppUtilities.makeToast("请输入写字楼")
            return
        }
        
        if uploadPicModelFCZArr.count <= 0 {
            AppUtilities.makeToast("请上传房产证")
            return
        }
        
        if leaseTypeTemp == "1" {
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
        
        params["leaseType"] = leaseTypeTemp as AnyObject?
        
        
        ///企业关系id  接口给
        if userModel?.userLicenceId != "0" || userModel?.userLicenceId?.isBlankString != true {
            params["userLicenceId"] = userModel?.userLicenceId as AnyObject?
        }
        
        ///企业id  接口给
        if userModel?.licenceId != "0" || userModel?.licenceId?.isBlankString != true {
            params["licenceId"] = userModel?.licenceId as AnyObject?
        }
        
        ///关联楼id
        if userModel?.buildingId != "0" || userModel?.buildingId?.isBlankString != true {
            params["buildingId"] = userModel?.buildingId as AnyObject?
        }
        //关联 - 楼盘，名字和地址都要给
        params["buildingId"] = buildingTempSelfId as AnyObject?
        
        params["buildingAddress"] = buildingAddressTemp as AnyObject?
        
        params["buildingName"] = buildingNameTemp as AnyObject?
        
        ///关联楼id
        if userModel?.buildingTempId != "0" || userModel?.buildingTempId?.isBlankString != true {
            params["buildingTempId"] = userModel?.buildingTempId as AnyObject?
        }
        
        params["userName"] = userModel?.userNameTemp as AnyObject?
        params["idCard"] = userModel?.userIdCardTemp as AnyObject?
        //       params["fileIdFront"]
        //       params["fileIdBack"]
        
        //房产证
        var fczArr: [UIImage] = []
        for model in uploadPicModelFCZArr {
            if model.isLocal == true {
                fczArr.append(model.image ?? UIImage())
            }
        }
        
        //租赁
        var alAgentArr: [UIImage] = []
        for model in uploadPicModelZLAgentArr {
            if model.isLocal == true {
                alAgentArr.append(model.image ?? UIImage())
            }
        }
       
        SSNetworkTool.SSOwnerIdentify.request_personalIdentityApp(params: params, frontImage: frontArr, reverseImage: reverseArr, fczImagesArray: fczArr, zlAgentImagesArray: alAgentArr, success: {[weak self] (response) in
            
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

extension OwnerPersonalIeditnfyVC {
    
    @objc func logotClick() {
        self.headerCollectionView.endEditing(true)
        requestCompanyIdentify()
    }
    func setUpData() {
        userModel = OwnerIdentifyUserModel()
        userModel?.leaseType = "0"
    }
    func setUpView() {
        
        frontBannerModel = BannerModel()
        
        reverseBannerModel = BannerModel()

        titleview = ThorNavigationView.init(type: .backTitleRightBlueBgclolor)
        titleview?.titleLabel.text = "个人业主认证"
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
        headerCollectionView.register(OwnerPersonalIdentifyCell.self, forCellWithReuseIdentifier: OwnerPersonalIdentifyCell.reuseIdentifierStr)
        headerCollectionView.register(OwnerImagePickerCell.self, forCellWithReuseIdentifier: OwnerImagePickerCell.reuseIdentifierStr)
        headerCollectionView.register(OwnerIdCardImagePickerCell.self, forCellWithReuseIdentifier: OwnerIdCardImagePickerCell.reuseIdentifierStr)
        
        headerCollectionView.register(OwnerImgPickerCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "OwnerImgPickerCollectionViewHeader")
        
        //办公楼
        buildingNameSearchResultVC = OwnerBuildingNameESearchResultListViewController.init()
        buildingNameSearchResultVC?.view.isHidden = true
        self.view.addSubview(buildingNameSearchResultVC?.view ?? UIView())
        
        // 传递闭包 当点击’搜索结果‘的cell调用
        buildingNameSearchResultVC?.buildingCallBack = {[weak self] (model) in
            // 搜索完成 关闭resultVC
            self?.buildingTempSelfId = model.bid
            self?.userModel?.buildingTempSelfId = model.bid
            // 搜索完成 关闭resultVC
            self?.buildingNameTemp = model.buildingAttributedName?.string
            self?.userModel?.buildingNameTemp = model.buildingAttributedName?.string
            self?.buildingAddressTemp = model.addressString?.string
            self?.userModel?.buildingAddressTemp = model.addressString?.string
            self?.buildingNameSearchResultVC?.view.isHidden = true
            self?.loadCollectionData()
        }
    
        // 创建按钮 - 隐藏 - 展示下面的楼盘地址 - 地址置空
        buildingNameSearchResultVC?.creatButtonCallClick = {[weak self] in
            let vc = OwnerCreateBuildingViewController()
            vc.userModel = self?.userModel
            vc.userModel?.buildingName = self?.buildingNameTemp
            vc.userModel?.buildingAddress = ""
            vc.userModel?.creditNo = ""
            vc.userModel?.fileMainPic = ""
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        // 关闭按钮 - 隐藏页面
        buildingNameSearchResultVC?.closeButtonCallClick = {[weak self] in
            self?.userModel?.buildingName = self?.buildingName
            self?.buildingNameSearchResultVC?.view.isHidden = true
            self?.loadCollectionData()
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

extension OwnerPersonalIeditnfyVC {
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
    
    func pickerSelectIDCard() {
        let alertController = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        let refreshAction = UIAlertAction.init(title: "拍照", style: .default) {[weak self] (action: UIAlertAction) in
            self?.isFront = false
            let vc = ZKIDCardCameraController.init(type: .reverse)
            vc.modalPresentationStyle = .overFullScreen
            vc.delegate = self
            self?.present(vc, animated: true, completion: nil)
        }
        let copyAction = UIAlertAction.init(title: "从手机相册选择", style: .default) {[weak self] (action: UIAlertAction) in
            let picker = CLImagePickerTool()
            picker.cameraOut = false
            picker.isHiddenVideo = true
            picker.singleImageChooseType = .singlePicture   //设置单选
            picker.singleModelImageCanEditor = false        //单选不可编辑
            picker.cl_setupImagePickerWith(MaxImagesCount: 2) {[weak self] (asset,cutImage) in
                SSLog("返回的asset数组是\(asset)")
                
                var index = asset.count // 标记失败的次数
                
                // 获取原图，异步
                // scale 指定压缩比
                // 内部提供的方法可以异步获取图片，同步获取的话时间比较长，不建议！，如果是iCloud中的照片就直接从icloud中下载，下载完成后返回图片,同时也提供了下载失败的方法
                CLImagePickerTool.convertAssetArrToOriginImage(assetArr: asset, scale: 0.1, successClouse: {[weak self] (image,assetItem) in
                    let img = image.resizeMax1500Image()

                    self?.reverseBannerModel?.imgUrl = nil
                    self?.reverseBannerModel?.image = img?.crop(ratio: 4 / 3.0)
                    self?.loadCollectionData()
                    
                    }, failedClouse: { () in
                        index = index - 1
                        //                    self?.dealImage(imageArr: imageArr, index: index)
                })
            }
        }
        let cancelAction = UIAlertAction.init(title: "取消", style: .cancel) { (action: UIAlertAction) in
            
        }
        alertController.addAction(refreshAction)
        alertController.addAction(copyAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func pickerSelectIDCardFront() {
        let alertController = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        let refreshAction = UIAlertAction.init(title: "拍照", style: .default) {[weak self] (action: UIAlertAction) in
            self?.isFront = true
            let vc = ZKIDCardCameraController.init(type: .front)
            vc.modalPresentationStyle = .overFullScreen
            vc.delegate = self
            self?.present(vc, animated: true, completion: nil)
        }
        let copyAction = UIAlertAction.init(title: "从手机相册选择", style: .default) {[weak self] (action: UIAlertAction) in
            let picker = CLImagePickerTool()
            picker.cameraOut = false
            picker.isHiddenVideo = true
            picker.singleImageChooseType = .singlePicture   //设置单选
            picker.singleModelImageCanEditor = false        //单选不可编辑
            picker.cl_setupImagePickerWith(MaxImagesCount: 2) {[weak self] (asset,cutImage) in
                SSLog("返回的asset数组是\(asset)")
                
                var index = asset.count // 标记失败的次数
                
                // 获取原图，异步
                // scale 指定压缩比
                // 内部提供的方法可以异步获取图片，同步获取的话时间比较长，不建议！，如果是iCloud中的照片就直接从icloud中下载，下载完成后返回图片,同时也提供了下载失败的方法
                CLImagePickerTool.convertAssetArrToOriginImage(assetArr: asset, scale: 0.1, successClouse: {[weak self] (image,assetItem) in
                    let img = image.resizeMax1500Image()

                    self?.frontBannerModel?.imgUrl = nil
                    self?.frontBannerModel?.image = img?.crop(ratio: 4 / 3.0)
                    self?.loadCollectionData()
                    
                    }, failedClouse: { () in
                        index = index - 1
                        //                    self?.dealImage(imageArr: imageArr, index: index)
                })
            }
        }
        let cancelAction = UIAlertAction.init(title: "取消", style: .cancel) { (action: UIAlertAction) in
            
        }
        alertController.addAction(refreshAction)
        alertController.addAction(copyAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
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
extension OwnerPersonalIeditnfyVC: ZKIDCardCameraControllerDelegate {
    func cameraDidFinishShoot(withCameraImage image: UIImage) {
        if isFront == true {
            frontBannerModel?.imgUrl = nil
            frontBannerModel?.image = image.crop(ratio: 4 / 3.0)
        }else {
            reverseBannerModel?.imgUrl = nil
            reverseBannerModel?.image = image.crop(ratio: 4 / 3.0)
        }
        self.loadCollectionData()
    }
}

extension OwnerPersonalIeditnfyVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OwnerPersonalIdentifyCell.reuseIdentifierStr, for: indexPath as IndexPath) as? OwnerPersonalIdentifyCell
            cell?.userModel = self.userModel
            cell?.model = typeSourceArray[indexPath.section][indexPath.item]
            
            cell?.buildingUserNameEndEditingMessageCell = { [weak self] (nickname) in
                self?.userModel?.userNameTemp = nickname
                self?.userNameTemp = nickname
                self?.loadCollectionData()
            }
            cell?.buildingIdCardEndEditingMessageCell = { [weak self] (idCard) in
                self?.userModel?.userIdCardTemp = idCard
                self?.userIdCardTemp = idCard
                self?.loadCollectionData()
            }
            return cell ?? OwnerPersonalIdentifyCell()
        }else if indexPath.section == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OwnerPersonalIdentifyCell.reuseIdentifierStr, for: indexPath as IndexPath) as? OwnerPersonalIdentifyCell
            cell?.userModel = self.userModel
            cell?.model = typeSourceArray[indexPath.section][indexPath.item]
            
            cell?.buildingNameClickClouse = { [weak self] (buildingName) in
                self?.userModel?.buildingName = ""
                self?.buildingName = buildingName
                self?.buildingNameTemp = buildingName
            }
            //            cell?.buildingAddresEndEditingMessageCell = { [weak self] (buildingAddres) in
            //                self?.userModel?.address = buildingAddres
            //                self?.loadCollectionData()
            //            }
            //            cell?.buildingNameEndEditingMessageCell = { [weak self] (buildingNAme) in
            //                self?.userModel?.buildingName = buildingNAme
            //                self?.loadCollectionData()
            //            }
            return cell ?? OwnerPersonalIdentifyCell()
        }else if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OwnerIdCardImagePickerCell.reuseIdentifierStr, for: indexPath as IndexPath) as? OwnerIdCardImagePickerCell
            if indexPath.item == 0 {
                cell?.addTitleLabel.text = "上传身份证人像面"
                if let imgUrl = frontBannerModel?.imgUrl {
                    if imgUrl.count > 0 {
                        cell?.image.setImage(with: imgUrl, placeholder: UIImage(named: Default_1x1))
                    }else {
                        cell?.image.image = reverseBannerModel?.image
                    }
                }else {
                    cell?.image.image = frontBannerModel?.image
                }
            }else if indexPath.item == 1 {
                cell?.addTitleLabel.text = "上传身份证国徽面"
                if let imgUrl = reverseBannerModel?.imgUrl {
                    if imgUrl.count > 0 {
                        cell?.image.setImage(with: imgUrl, placeholder: UIImage(named: Default_1x1))
                    }else {
                        cell?.image.image = reverseBannerModel?.image
                    }
                }else {
                    cell?.image.image = reverseBannerModel?.image
                }
            }
            return cell ?? OwnerIdCardImagePickerCell()
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OwnerImagePickerCell.reuseIdentifierStr, for: indexPath as IndexPath) as? OwnerImagePickerCell
            cell?.indexPath = indexPath
            if indexPath.section == 3 {
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
            }else if indexPath.section == 4 {
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
            return cell ?? OwnerImagePickerCell()
        }
        
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        //直租
        if leaseTypeTemp == "0" {
            return typeSourceArray.count - 1
        }else if leaseTypeTemp == "1" {
            return typeSourceArray.count
        }else {
            return typeSourceArray.count - 1
        }
        /*
        if let idCard = userModel?.userIdCardTemp {
            if idCard.isBlankString == true {
                return 2
            }else {
                //直租
                if leaseTypeTemp == 0 {
                    return typeSourceArray.count - 1
                }else if leaseTypeTemp == 1 {
                    return typeSourceArray.count
                }else {
                    return typeSourceArray.count - 1
                }
            }
        }else {
            return 2
        }*/
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return typeSourceArray[0].count
        }else if section == 1 {
            //身份证
            return 2
        }else if section == 2 {
            /*
            if let buildingName = userModel?.buildingNameTemp {
                if buildingName.isBlankString == true {
                    return 2
                }else {
                    return typeSourceArray[2].count
                }
            }else {
                return 2
            }*/
            return typeSourceArray[2].count
        }else if section == 3 {
            /*
            if let buildingName = userModel?.buildingNameTemp {
                if buildingName.isBlankString == true {
                    return 0
                }else {
                    return uploadPicModelFCZArr.count + 1
                }
            }else {
                return 0
            }*/
            return uploadPicModelFCZArr.count + 1
        }else if section == 4 {
            /*
            if let buildingName = userModel?.buildingNameTemp {
                if buildingName.isBlankString == true {
                    return 0
                }else {
                    return uploadPicModelZLAgentArr.count + 1
                }
            }else {
                return 0
            }*/
            return uploadPicModelZLAgentArr.count + 1
        }
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0 {
            return CGSize(width: kWidth - left_pending_space_17 * 2, height: cell_height_58)
        }else if indexPath.section == 1 {
            let width = (kWidth - left_pending_space_17 * 3) / 2.0 - 1
            return CGSize(width: width, height: width * 3 / 4.0)
        }else if indexPath.section == 2 {
            let model = typeSourceArray[2][indexPath.item]
            if model.type == .OwnerPersonalIedntifyTypeBuildingName {
                return CGSize(width: kWidth - left_pending_space_17 * 2, height: cell_height_58 + 18)
            }else {
                return CGSize(width: kWidth - left_pending_space_17 * 2, height: cell_height_58)
            }
        }else if indexPath.section == 3 || indexPath.section == 4 {
            return CGSize(width: (kWidth - left_pending_space_17 * 2 - 5 * 2) / 3.0 - 1, height: (kWidth - left_pending_space_17 * 2 - 5 * 2) / 3.0 - 1)
        }
        return CGSize(width: 0, height: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 || section == 2 {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            
        }else if section == 1{
            return UIEdgeInsets(top: 0, left: left_pending_space_17, bottom: 26, right: left_pending_space_17)
        }else if section == 3 || section == 4 {
            return UIEdgeInsets(top: 0, left: left_pending_space_17, bottom: 0, right: left_pending_space_17)
        }else {
            return .zero
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.item == 0 {
                showChangeAlert()
            }
        }else if indexPath.section == 1 {
            
            //上传身份证人像面
            if indexPath.item == 0 {
                pickerSelectIDCardFront()
            }else if indexPath.item == 1 {
                //上传身份证国徽面
                pickerSelectIDCard()
            }
            
        }else if indexPath.section == 2 {
            if indexPath.item == 1 {
                
                let alertController = UIAlertController.init(title: "房产类型", message: nil, preferredStyle: .actionSheet)
                let refreshAction = UIAlertAction.init(title: "自有房产", style: .default) {[weak self] (action: UIAlertAction) in
                    self?.leaseTypeTemp = "0"
                    self?.userModel?.leaseTypeTemp = "0"
                    self?.loadCollectionData()
                }
                let copyAction = UIAlertAction.init(title: "租赁房产", style: .default) {[weak self] (action: UIAlertAction) in
                    self?.leaseTypeTemp = "1"
                    self?.userModel?.leaseTypeTemp = "1"
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
            if indexPath.section == 3 {
                if indexPath.item == uploadPicModelFCZArr.count {
                    selectFCZPicker()
                }
            }else if indexPath.section == 4 {
                if indexPath.item == uploadPicModelZLAgentArr.count {
                    selectZLAgentPicker()
                }
            }
            
        }
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "OwnerImgPickerCollectionViewHeader", for: indexPath) as? OwnerImgPickerCollectionViewHeader
            if indexPath.section == 0 || indexPath.section == 2  {
                header?.backgroundColor = kAppColor_line_EEEEEE
                header?.titleLabel.text = ""
                header?.descLabel.text = ""
            }else if indexPath.section == 1{
                header?.backgroundColor = kAppWhiteColor
                header?.titleLabel.text = "上传身份证"
                header?.descLabel.text = ""
            }else if indexPath.section == 3{
                header?.backgroundColor = kAppWhiteColor
                header?.titleLabel.text = "上传房产证"
                header?.descLabel.text = "请确保所上传的房产信息与公司信息一致"
            }else if indexPath.section == 4{
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
            return CGSize(width: kWidth, height: cell_height_58)
            
        }else if section == 2 {
            return CGSize(width: kWidth, height: 10)
            
        }else if section == 3 || section == 4 {
            /*
            if let buildingName = userModel?.buildingNameTemp {
                if buildingName.isBlankString == true {
                    return CGSize(width: kWidth, height: 0)
                }else {
                    return CGSize(width: kWidth, height: 68)
                }
            }else {
                return CGSize(width: kWidth, height: 0)
            }*/
            return CGSize(width: kWidth, height: 68)
            
        }else {
            return CGSize.zero
        }
    }
    
    //这个是两行cell之间的间距（上下行cell的间距）
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if section != 3 {
            return 0
        }else {
            //            return left_pending_space_17
            return 5
        }
    }
    
    ////两个cell之间的间距（同一行的cell的间距）
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if section != 3 {
            return 0
        }else {
            //            return left_pending_space_17
            return 5
        }
    }
}

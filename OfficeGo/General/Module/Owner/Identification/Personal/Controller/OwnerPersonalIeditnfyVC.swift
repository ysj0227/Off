//
//  OwnerPersonalIeditnfyVC.swift
//  OfficeGo
//
//  Created by mac on 2020/7/16.
//  Copyright © 2020 Senwei. All rights reserved.
//

import CLImagePickerTool

class OwnerPersonalIeditnfyVC: BaseViewController {
    
    //判断身份证照片是否是第一次调取接口
    var isFirst: Bool = false
    
    var userNameTemp: String?
    
    var userIdCardTemp: String?
    
    ///楼盘名字 自己选择的 - 可能是接口返回的
    var buildingNameTemp: String?
    
    ///租赁类型0直租1转租 自己选择的 - 可能是接口返回的
    var leaseTypeTemp: Int?
    
    ///楼盘id 自己选择关联之后用自己的 - 没有选择可能是接口返回的
    var buildingId: Int?

    var isFront: Bool? = true
    
    var frontBannerModel: BannerModel?
    
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
            if let model = noti.object as? OwnerESBuildingSearchModel {
                self?.userModel?.buildingName = model.buildingName
                self?.userModel?.buildingAddress = model.address
                self?.buildingNameSearchResultVC?.view.isHidden = true
                self?.loadCollectionData()
            }
        }
        
        
    }
    override func leftBtnClick() {
        
        self.headerCollectionView.endEditing(true)
        
        let alert = SureAlertView(frame: self.view.frame)
        alert.ShowAlertView(withalertType: AlertType.AlertTypeMessageAlert, title: "确认离开吗？", descMsg: "个人认证未完成，点击保存下次可继续编辑。点击离开，已编辑信息不保存", cancelButtonCallClick: { [weak self] in
            
            self?.navigationController?.popViewController(animated: true)
        }) { [weak self] in
            
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
}

extension OwnerPersonalIeditnfyVC {
    
    func detailDataShow() {
        
        if isFirst == true {
            
        }else {
            if let front = userModel?.fileIdFront {
                frontBannerModel?.image = nil
                frontBannerModel?.imgUrl = front
            }else {
                frontBannerModel?.imgUrl = nil
            }
            
            if let reverse = userModel?.fileIdBack {
                reverseBannerModel?.image = nil
                reverseBannerModel?.imgUrl = reverse
            }else {
                reverseBannerModel?.imgUrl = nil
            }
        }
        
        if buildingId == nil {
            buildingId = userModel?.buildingId
        }
        //租赁类型
        if leaseTypeTemp == nil {
            if let leaseType = userModel?.leaseType {
                leaseTypeTemp = leaseType
                userModel?.leaseTypeTemp = leaseType
            }else {
                leaseTypeTemp = 0
                userModel?.leaseTypeTemp = 0
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
        
        isFirst = true
        
       
                
        ///移除之前的房产证数据
        for fczBannerModel in uploadPicModelFCZArr {
            if fczBannerModel.imgUrl?.count ?? 0 > 0 {
                uploadPicModelFCZArr.remove(fczBannerModel)
            }
        }
        
        ///添加新的房产证数据
        if let premisesPermit = userModel?.premisesPermit {
            
            for fczBannerModel in premisesPermit {
                uploadPicModelFCZArr.insert(fczBannerModel, at: 0)
            }
        }
        
        ///移除之前的租赁协议数据
        for lzAgentBannerModel in uploadPicModelZLAgentArr {
            if lzAgentBannerModel.imgUrl?.count ?? 0 > 0 {
                uploadPicModelZLAgentArr.remove(lzAgentBannerModel)
            }
        }
        
        ///添加新的租赁协议数据
        if let contract = userModel?.contract {
            
            for lzAgentBannerModel in contract {
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
        
        var params = [String:AnyObject]()
        
        params["token"] = UserTool.shared.user_token as AnyObject?
        
        //身份类型0个人认证1企业认证2网点认证
        params["identityType"] = UserTool.shared.user_owner_identifytype as AnyObject?
        
        //1提交认证2企业确认3网点楼盘创建确认
        params["createCompany"] = 1 as AnyObject?
        
        params["leaseType"] = leaseTypeTemp as AnyObject?
        
        
        ///企业关系id  接口给
        if userModel?.userLicenceId != 0 {
            params["userLicenceId"] = userModel?.userLicenceId as AnyObject?
        }
        
        ///企业id  接口给
        if userModel?.licenceId != 0 {
            params["licenceId"] = userModel?.licenceId as AnyObject?
        }
        
        ///关联楼id
        if userModel?.buildingId != 0 {
            params["buildingId"] = userModel?.buildingId as AnyObject?
        }
        ///关联楼id
        if userModel?.buildingTempId != 0 {
            params["buildingTempId"] = userModel?.buildingTempId as AnyObject?
        }
        
        params["userName"] = userModel?.userNameTemp as AnyObject?
        params["idCard"] = userModel?.userIdCardTemp as AnyObject?
        //       params["fileIdFront"]
        //       params["fileIdBack"]
        
        //房产证
        var fczArr: [UIImage] = []
        for model in uploadPicModelFCZArr {
            if model.image != nil {
                fczArr.append(model.image ?? UIImage())
            }
        }
        fczArr.remove(at: fczArr.count - 1)
        
        //租赁
        var alAgentArr: [UIImage] = []
        for model in uploadPicModelZLAgentArr {
            if model.image != nil {
                alAgentArr.append(model.image ?? UIImage())
            }
        }
        alAgentArr.remove(at: alAgentArr.count - 1)
        
        SSNetworkTool.SSOwnerIdentify.request_companyIdentityApp(params: params, fczImagesArray: fczArr, zlAgentImagesArray: alAgentArr, success: {[weak self] (response) in
            
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
        userModel?.leaseType = 0
    }
    func setUpView() {
        
        frontBannerModel = BannerModel()
        
        reverseBannerModel = BannerModel()
        
        let fczBannerModel = BannerModel()
        fczBannerModel.image = UIImage.init(named: "addImgBg")
        uploadPicModelFCZArr.append(fczBannerModel)
        
        let zlAgentBannerModel = BannerModel()
        zlAgentBannerModel.image = UIImage.init(named: "addImgBg")
        uploadPicModelZLAgentArr.append(zlAgentBannerModel)

        titleview = ThorNavigationView.init(type: .backTitleRightBlueBgclolor)
        titleview?.titleLabel.text = "个人业主认证"
        titleview?.rightButton.isHidden = true
        titleview?.leftButtonCallBack = { [weak self] in
            self?.leftBtnClick()
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
            self?.buildingId = model.bid
            self?.userModel?.buildingId = model.bid
            // 搜索完成 关闭resultVC
            //只需要楼盘名字
            self?.buildingNameTemp = model.buildingAttributedName?.string
            self?.userModel?.buildingNameTemp = model.buildingAttributedName?.string
            self?.userModel?.buildingAddress = model.addressString?.string
            self?.buildingNameSearchResultVC?.view.isHidden = true
            self?.loadCollectionData()
        }
        
        // 创建按钮 - 隐藏 - 展示下面的楼盘地址 - 地址置空
        buildingNameSearchResultVC?.creatButtonCallClick = {[weak self] in
            let vc = OwnerCreateBuildingViewController()
            vc.userModel = self?.userModel
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
        alert.ShowAlertView(withalertType: AlertType.AlertTypeMessageAlert, title: "提交成功", descMsg: "我们会在1-2个工作日完成审核\n你还可以", cancelButtonCallClick: {
            
        }) {
            
        }
    }
    
}

extension OwnerPersonalIeditnfyVC {
    func selectFCZPicker() {
        fczImagePickTool.cl_setupImagePickerWith(MaxImagesCount: 10 - uploadPicModelFCZArr.count) {[weak self] (asset,cutImage) in
            // 内部提供的方法可以异步获取图片，同步获取的话时间比较长，不建议！，如果是iCloud中的照片就直接从icloud中下载，下载完成后返回图片,同时也提供了下载失败的方法
            CLImagePickerTool.convertAssetArrToOriginImage(assetArr: asset, scale: 0.1, successClouse: {[weak self] (image,assetItem) in
                let fczBannerModel = BannerModel()
                fczBannerModel.image = image
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
                let zlAgentBannerModel = BannerModel()
                zlAgentBannerModel.image = image
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
                self?.uplaodMainPageimg = image
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
                    self?.reverseBannerModel?.imgUrl = nil
                    self?.reverseBannerModel?.image = image.crop(ratio: 4 / 3.0)
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
                    self?.frontBannerModel?.imgUrl = nil
                    self?.frontBannerModel?.image = image.crop(ratio: 4 / 3.0)
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
                    cell?.image.setImage(with: imgUrl, placeholder: UIImage(named: Default_1x1))
                }else {
                    cell?.image.image = frontBannerModel?.image
                }
            }else if indexPath.item == 1 {
                cell?.addTitleLabel.text = "上传身份证国徽面"
                if let imgUrl = reverseBannerModel?.imgUrl {
                    cell?.image.setImage(with: imgUrl, placeholder: UIImage(named: Default_1x1))
                }else {
                    cell?.image.image = reverseBannerModel?.image
                }
            }
            return cell ?? OwnerIdCardImagePickerCell()
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OwnerImagePickerCell.reuseIdentifierStr, for: indexPath as IndexPath) as? OwnerImagePickerCell
            cell?.indexPath = indexPath
            if indexPath.section == 3 {
                if let imgUrl = uploadPicModelFCZArr[indexPath.item].imgUrl {
                    cell?.image.setImage(with: imgUrl, placeholder: UIImage(named: Default_1x1))
                }else {
                    cell?.image.image = uploadPicModelFCZArr[indexPath.item].image
                }
                cell?.closeBtnClickClouse = { [weak self] (index) in
                    self?.uploadPicModelFCZArr.remove(at: index)
                    self?.loadCollectionData()
                }
                if indexPath.item == uploadPicModelFCZArr.count - 1 {
                    cell?.closeBtn.isHidden = true
                }else {
                    cell?.closeBtn.isHidden = false
                }
            }else if indexPath.section == 4 {
                if let imgUrl = uploadPicModelZLAgentArr[indexPath.item].imgUrl {
                    cell?.image.setImage(with: imgUrl, placeholder: UIImage(named: Default_1x1))
                }else {
                    cell?.image.image = uploadPicModelZLAgentArr[indexPath.item].image
                }
                cell?.closeBtnClickClouse = { [weak self] (index) in
                    self?.uploadPicModelZLAgentArr.remove(at: index)
                    self?.loadCollectionData()
                }
                if indexPath.item == uploadPicModelZLAgentArr.count - 1 {
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
        if leaseTypeTemp == 0 {
            return typeSourceArray.count - 1
        }else if leaseTypeTemp == 1 {
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
                    return uploadPicModelFCZArr.count
                }
            }else {
                return 0
            }*/
            return uploadPicModelFCZArr.count
        }else if section == 4 {
            /*
            if let buildingName = userModel?.buildingNameTemp {
                if buildingName.isBlankString == true {
                    return 0
                }else {
                    return uploadPicModelZLAgentArr.count
                }
            }else {
                return 0
            }*/
            return uploadPicModelZLAgentArr.count
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
                leftBtnClick()
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
                    self?.leaseTypeTemp = 0
                    self?.userModel?.leaseTypeTemp = 0
                    self?.loadCollectionData()
                }
                let copyAction = UIAlertAction.init(title: "租赁房产", style: .default) {[weak self] (action: UIAlertAction) in
                    self?.leaseTypeTemp = 1
                    self?.userModel?.leaseTypeTemp = 1
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
                if indexPath.item == uploadPicModelFCZArr.count - 1 {
                    selectFCZPicker()
                }
            }else if indexPath.section == 4 {
                if indexPath.item == uploadPicModelZLAgentArr.count - 1 {
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

//
//  OwnerBuildingJointCreatAddViewController.swift
//  OfficeGo
//
//  Created by Mac pro on 2020/11/4.
//  Copyright © 2020 Senwei. All rights reserved.
//

import CLImagePickerTool
import HandyJSON
import SwiftyJSON

class OwnerBuildingJointCreatAddViewController: BaseViewController {
    
    ///楼盘
    var isBuilding: Bool?
    
    ///网点
    var isBranchs: Bool?
    
    var areaModelCount: CityAreaCategorySelectModel?
    
    lazy var areaView: CityDistrictAddressSelectView = {
        let view = CityDistrictAddressSelectView.init(frame: CGRect(x: 0.0, y: kNavigationHeight + cell_height_58 * 2, width: kWidth, height: kHeight - kNavigationHeight - cell_height_58 * 2 - bottomMargin()))
        return view
    }()
    
        //封面图
    lazy var mainPicBannermodel: BannerModel = {
        let model = BannerModel()
        model.isLocal = true
        model.image = UIImage.init(named: "addImgBg")
        return model
    }()
    
    ///时候有楼盘
    var isHasBuilding: Bool?
    
    var userModel: OwnerIdentifyUserModel?
    
    //写字楼名称搜索结果vc
    var buildingNameSearchResultVC: OwnerBuildingJointESSearchViewController?
        
    var buildingName: String? {
        didSet {
            let rect = headerCollectionView.layoutAttributesForItem(at: IndexPath.init(row: 0, section: 0))
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
        }
    }
    
    @objc var uploadPicModelFCZArr = [BannerModel]()  // 在实际的项目中可能用于存储图片的url
    
    @objc var uplaodMainPageimg = UIImage.init(named: "addImgBg")  // 在实际的项目中可能用于存储图片的url
    
    lazy var fczImagePickTool: CLImagePickerTool = {
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
    
    var typeSourceArray:[[OwnerBuildingJointCreatAddConfigureModel]] = {
        var arr = [[OwnerBuildingJointCreatAddConfigureModel]]()
        
        arr.append([OwnerBuildingJointCreatAddConfigureModel.init(types: .OwnerBuildingCreteAddTypeBuildingName),
                    OwnerBuildingJointCreatAddConfigureModel.init(types: .OwnerBuildingCreteAddTypeBuildingDistrictArea),
                    OwnerBuildingJointCreatAddConfigureModel.init(types: .OwnerBuildingCreteAddTypeBuildingAddress)
        ])
        arr.append([OwnerBuildingJointCreatAddConfigureModel.init(types: .OwnerBuildingCreteAddTypeUploadMainPhoto)])
        arr.append([OwnerBuildingJointCreatAddConfigureModel.init(types: .OwnerBuildingCreteAddTypeUploadFCZPhoto)])
        
        return arr
    }()
    
    var commitBtn: UIButton {
        let btn = UIButton.init(frame: CGRect(x: left_pending_space_17, y: 0, width: kWidth - left_pending_space_17 * 2, height: btnHeight_44))
        btn.backgroundColor = kAppBlueColor
        btn.clipsToBounds = true
        btn.layer.cornerRadius = button_cordious_2
        btn.setTitle("确认创建", for: .normal)
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
        setUpData()
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
            }
            
            }, failure: {  (error) in
                
        }) {  (code, message) in
            
            
            //只有5000 提示给用户
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" {
                AppUtilities.makeToast(message)
            }
        }
    }
    
    func getSelectedDistrictBusiness() {
        areaModelCount?.data.forEach({ (model) in
            if model.districtID == userModel?.district {
                areaModelCount?.isFirstSelectedModel = model
                userModel?.districtString = "\(areaModelCount?.name ?? "上海市")\(model.district ?? "")"
                areaModelCount?.isFirstSelectedModel?.list.forEach({ (areaModel) in
                    if areaModel.id == userModel?.business {
                        areaModelCount?.isFirstSelectedModel?.isSencondSelectedModel = areaModel
                        userModel?.businessString = areaModel.area
                        loadCollectionData()
                    }
                })
                
            }
        })
    }
    
    func judgeHasData() {
        if areaModelCount?.data.count ?? 0  > 0 {
            self.showArea(isFrist: true)
        }else {
            request_getDistrict()
        }
    }
    
    func showArea(isFrist: Bool) {
        areaView.ShowCityDistrictAddressSelectView(isfirst: isFrist, model: self.areaModelCount ?? CityAreaCategorySelectModel(), clearButtonCallBack: { (_ selectModel: CityAreaCategorySelectModel) -> Void in

            }, sureAreaaddressButtonCallBack: { [weak self] (_ selectModel: CityAreaCategorySelectModel) -> Void in
                self?.areaModelCount = selectModel
                self?.userModel?.district = selectModel.isFirstSelectedModel?.districtID
                self?.userModel?.business = selectModel.isFirstSelectedModel?.isSencondSelectedModel?.id
                self?.userModel?.districtString = "\(selectModel.name ?? "上海市")\(selectModel.isFirstSelectedModel?.district ?? "")"
                self?.userModel?.businessString = "\(selectModel.isFirstSelectedModel?.isSencondSelectedModel?.area ?? "")"
                self?.loadCollectionData()
                
        })
    }
    
    
    func addNotify() {

        
    }
    
    ///左上角按钮
    func showLeaveAlert() {
        self.headerCollectionView.endEditing(true)
        let alert = SureAlertView(frame: self.view.frame)
        alert.bottomBtnView.rightSelectBtn.setTitle("离开", for: .normal)
        alert.ShowAlertView(withalertType: AlertType.AlertTypeMessageAlert, title: "信息尚未提交，是否确认离开？", descMsg: "", cancelButtonCallClick: {
            
        }) { [weak self] in
            self?.leftBtnClick()
        }
    }
    
}

extension OwnerBuildingJointCreatAddViewController {
    
    func detailDataShow() {
        
        loadCollectionData()
    }
    
    ///提交认证
    func requestCompanyIdentify() {
        
        if userModel?.buildingName == nil || userModel?.buildingName?.isBlankString == true{
            AppUtilities.makeToast("请选择或创建写字楼")
            return
        }
        
        if uploadPicModelFCZArr.count <= 0 {
            AppUtilities.makeToast("请上传房产证")
            return
        }

        var params = [String:AnyObject]()
        
        params["token"] = UserTool.shared.user_token as AnyObject?
        
        if isBranchs == true {
            params["btype"] = 2 as AnyObject?
        }else {
            params["btype"] = 1 as AnyObject?
        }
        params["buildingName"] = userModel?.buildingName as AnyObject?

        
        //房产证
        var fczArr: [UIImage] = []
        for model in uploadPicModelFCZArr {
            if model.isLocal == true {
                fczArr.append(model.image ?? UIImage())
            }
        }
        
        params["buildingAddress"] = userModel?.buildingAddress as AnyObject?
        
        params["mainPic"] = mainPicBannermodel.imgUrl as AnyObject?
        
        
        if userModel?.buildingId != nil {
            
            //关联 - 楼盘，名字和地址都要给
            params["buildingId"] = userModel?.buildingId as AnyObject?
            
        }else {
            
            params["districtId"] = userModel?.district as AnyObject?

            params["businessDistrict"] = userModel?.business as AnyObject?
        }
        
        var deleteArr: [String] = []
        for model in uploadPicModelFCZArr {
            deleteArr.append(model.imgUrl ?? "")
        }
        params["buildingCardTemp"] = deleteArr.joined(separator: ",") as AnyObject?

        setCommitEnables(isUserinterface: false)
        
        SSNetworkTool.SSFYManager.request_getinsertBuilding(params: params, success: {[weak self] (response) in

            guard let weakSelf = self else {return}
            
            weakSelf.leftBtnClick()
            
            }, failure: {[weak self] (error) in
                
                self?.setCommitEnables(isUserinterface: true)

        }) {[weak self] (code, message) in
            
            self?.setCommitEnables(isUserinterface: true)

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

extension OwnerBuildingJointCreatAddViewController {
    
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
        
        //写字楼
        buildingNameSearchResultVC = OwnerBuildingJointESSearchViewController.init()
        if isBuilding == true {
            titleview?.titleLabel.text = "添加楼盘"
            buildingNameSearchResultVC?.isManagerBuilding = true
        }else if isBranchs == true {
            titleview?.titleLabel.text = "添加共享办公网点"
            buildingNameSearchResultVC?.isManagerBranch = true
        }
        buildingNameSearchResultVC?.view.isHidden = true
        self.view.addSubview(buildingNameSearchResultVC?.view ?? UIView())
        
        // 传递闭包 当点击’搜索结果‘的cell调用
        buildingNameSearchResultVC?.buildingCallBack = {[weak self] (model) in
            // 搜索完成 关闭resultVC
            
            self?.isHasBuilding = true
            
            //判断楼盘是关联的还是自己创建的
            self?.userModel?.isCreateBuilding = "2"
            self?.areaModelCount?.isFirstSelectedModel = nil
            self?.userModel?.buildingId = model.bid
            self?.userModel?.buildingName = model.buildingAttributedName?.string
            self?.userModel?.buildingAddress = model.addressString?.string
            self?.userModel?.districtString = model.district
            self?.userModel?.businessString = model.business
            self?.userModel?.mainPic = model.mainPic
            self?.mainPicBannermodel.imgUrl = model.mainPic

            self?.areaModelCount?.isFirstSelectedModel = nil

            self?.buildingNameSearchResultVC?.view.isHidden = true
            self?.loadCollectionData()
        }
        
        // 创建按钮 - 隐藏 - 创建楼盘
        buildingNameSearchResultVC?.creatButtonCallClick = {[weak self] in
            self?.userModel?.buildingName = self?.buildingName
            if self?.buildingName?.isBlankString != true {
                self?.isHasBuilding = true
            }else {
                self?.isHasBuilding = false
            }
            self?.userModel?.buildingId = nil
            self?.userModel?.buildingAddress = nil
            self?.userModel?.district = nil
            self?.userModel?.business = nil
            self?.userModel?.mainPic = nil
            self?.userModel?.districtString = nil
            self?.userModel?.businessString = nil
            self?.userModel?.mainPic = nil
            self?.mainPicBannermodel.imgUrl = nil
            
            self?.areaModelCount?.isFirstSelectedModel = nil

            self?.buildingNameSearchResultVC?.view.isHidden = true
            self?.loadCollectionData()
        }
        // 关闭按钮 - 隐藏页面
        buildingNameSearchResultVC?.closeButtonCallClick = {[weak self] in
            self?.buildingNameSearchResultVC?.view.isHidden = true
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

extension OwnerBuildingJointCreatAddViewController {
    func selectFCZPicker() {
        var imgArr = [BannerModel]()
        var imggggArr = [UIImage]()

        fczImagePickTool.cl_setupImagePickerWith(MaxImagesCount: ownerMaxFCZNumber_4 - uploadPicModelFCZArr.count, superVC: self) {[weak self] (asset,cutImage) in
            // 内部提供的方法可以异步获取图片，同步获取的话时间比较长，不建议！，如果是iCloud中的照片就直接从icloud中下载，下载完成后返回图片,同时也提供了下载失败的方法
            CLImagePickerTool.convertAssetArrToOriginImage(assetArr: asset, scale: 0.1, successClouse: {[weak self] (image,assetItem) in
                let img = image.resizeMax1500Image()
                
                let fczBannerModel = BannerModel()
                fczBannerModel.isLocal = true
                fczBannerModel.image = img
                imgArr.append(fczBannerModel)
                imggggArr.append(img ?? UIImage())
                }, failedClouse: { () in
                    
            })
            self?.uploadBuildingImg(imgArr: imggggArr, existImgCount: self?.uploadPicModelFCZArr.count ?? 0)
            //房产证
            self?.uploadPicModelFCZArr.append(contentsOf: imgArr)
            self?.loadCollectionData()
        }
    }
        
    func selectMainPagePicker() {
        
        mainPicImagePickTool.cl_setupImagePickerWith(MaxImagesCount: 1, superVC: self) {[weak self] (asset,cutImage) in
            // 内部提供的方法可以异步获取图片，同步获取的话时间比较长，不建议！，如果是iCloud中的照片就直接从icloud中下载，下载完成后返回图片,同时也提供了下载失败的方法
            CLImagePickerTool.convertAssetArrToOriginImage(assetArr: asset, scale: 0.1, successClouse: {[weak self] (image,assetItem) in
                let img = image.resizeMax1500Image()
                
                self?.mainPicBannermodel.image = img
                }, failedClouse: { () in
                    
            })
            self?.loadCollectionData()
        }
    }
    
    
    func uploadImg(img: UIImage) {
        
        var params = [String:AnyObject]()
        params["token"] = UserTool.shared.user_token as AnyObject?
        
        ///0图片1视频
        params["filedirType"] = 0 as AnyObject?

        
        SSNetworkTool.SSFYManager.request_uploadResourcesUrl(params: params, imagesArray: [img], success: {[weak self] (response) in
            guard let weakSelf = self else {return}
            if let decoratedArray = JSONDeserializer<BannerModel>.deserializeModelArrayFrom(json: JSON(response["data"] ?? "").rawString() ?? "", designatedPath: "urls") {
                
                if decoratedArray.count >= 1 {
                    weakSelf.mainPicBannermodel.imgUrl = decoratedArray[0]?.url
                }
                
            }
            
            }, failure: {[weak self] (error) in

                
        }) {[weak self] (code, message) in

            
            //只有5000 提示给用户
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" {
                AppUtilities.makeToast(message)
            }
        }
    }
    
    
    
    func uploadBuildingImg(imgArr: [UIImage], existImgCount: Int) {
        
        var params = [String:AnyObject]()
        params["token"] = UserTool.shared.user_token as AnyObject?
        
        ///0图片1视频
        params["filedirType"] = 0 as AnyObject?
        
        SSNetworkTool.SSFYManager.request_uploadResourcesUrl(params: params, imagesArray: imgArr, success: {[weak self] (response) in
            guard let weakSelf = self else {return}
            if let decoratedArray = JSONDeserializer<BannerModel>.deserializeModelArrayFrom(json: JSON(response["data"] ?? "").rawString() ?? "", designatedPath: "urls") {
                
                if decoratedArray.count == imgArr.count {
                    var count = 0
                    for model in decoratedArray {
                        if count < decoratedArray.count {

                            weakSelf.uploadPicModelFCZArr[existImgCount + count].imgUrl = model?.url
                            count += 1
                        }
                    }
                }
                
            }
            
            }, failure: {[weak self] (error) in

                
        }) {[weak self] (code, message) in

            
            //只有5000 提示给用户
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" {
                AppUtilities.makeToast(message)
            }
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
    
    func endEdting() {
         headerCollectionView.endEditing(true)
     }
     
    
}

extension OwnerBuildingJointCreatAddViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OwnerCompanyIdentifyCell.reuseIdentifierStr, for: indexPath as IndexPath) as? OwnerCompanyIdentifyCell
            cell?.isBranchs = isBranchs
            cell?.userModel = self.userModel
            cell?.FYBuildingCreatAddmodel = typeSourceArray[indexPath.section][indexPath.item]
            cell?.buildingNameClickClouse = { [weak self] (buildingName) in
                
                self?.userModel?.buildingName = ""
                self?.userModel?.buildingAddress = ""
                self?.buildingName = buildingName
            }
            
            return cell ?? OwnerCompanyIdentifyCell()
        }else if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OwnerImagePickerCell.reuseIdentifierStr, for: indexPath as IndexPath) as? OwnerImagePickerCell
            cell?.indexPath = indexPath
            if let imgurl = mainPicBannermodel.imgUrl {
                cell?.closeBtn.isHidden = false
                cell?.image.setImage(with: imgurl, placeholder: UIImage(named: Default_1x1))
            }else {
                if let image = mainPicBannermodel.image {
                    cell?.closeBtn.isHidden = false
                    cell?.image.image = image
                }else {
                    cell?.closeBtn.isHidden = true
                    cell?.image.image = UIImage.init(named: "addImgBg")
                }
            }
            
            return cell ?? OwnerImagePickerCell()
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OwnerImagePickerCell.reuseIdentifierStr, for: indexPath as IndexPath) as? OwnerImagePickerCell
            cell?.indexPath = indexPath
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
            
            return cell ?? OwnerImagePickerCell()
        }
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        ///有楼盘
        if isHasBuilding == true {
            ///关联的 - 不展示封面图
            if userModel?.buildingId != nil {
                return 3
            }else {
                return 3
            }
        }else {
            return 1
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        ///有楼盘
        if isHasBuilding == true {
            if section == 0 {
                return 3
            }else if section == 1 {
                ///关联的 - 不展示封面图
                if userModel?.buildingId != nil {
                    return 0
                }else {
                    return 1
                }
            }else if section == 2 {
                return uploadPicModelFCZArr.count + 1
            }
        }else {
            if section == 0 {
                return 1
            }else if section == 1 {
                return 0
            }else if section == 2 {
                return 0
            }
        }
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0 {
            return CGSize(width: kWidth - left_pending_space_17 * 2, height: cell_height_58)
        }else if indexPath.section == 1 {
            return CGSize(width: (kWidth - left_pending_space_17 * 2 - 5 * 2) / 3.0 - 1, height: (kWidth - left_pending_space_17 * 2 - 5 * 2) / 3.0 - 1)
        }else if indexPath.section == 2 {
            return CGSize(width: (kWidth - left_pending_space_17 * 2 - 5 * 2) / 3.0 - 1, height: (kWidth - left_pending_space_17 * 2 - 5 * 2) / 3.0 - 1)
        }
        return CGSize(width: 0, height: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            
        }else {
            return UIEdgeInsets(top: 0, left: left_pending_space_17, bottom: 0, right: left_pending_space_17)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 1 {
                endEdting()
                ///区域商圈选择
                judgeHasData()
            }
        }
        else if indexPath.section == 1 {
            selectMainPagePicker()
        }else if indexPath.section == 2 {
            if indexPath.item == uploadPicModelFCZArr.count {
                selectFCZPicker()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "OwnerImgPickerCollectionViewHeader", for: indexPath) as? OwnerImgPickerCollectionViewHeader
            if indexPath.section == 0 {
                header?.backgroundColor = kAppColor_line_EEEEEE
                header?.titleLabel.text = ""
                header?.descLabel.text = ""
            }else if indexPath.section == 2 {
                header?.backgroundColor = kAppWhiteColor
                header?.titleLabel.text = "上传房产证"
                header?.descLabel.text = "请确保所上传的房产信息与公司信息一致"
            }else if indexPath.section == 1 {
                header?.backgroundColor = kAppWhiteColor
                header?.titleLabel.text = "上传封面图"
                header?.descLabel.text = ""
            }
            
            return header ?? UICollectionReusableView()
        }
        
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: 0, height: 0)
            
        }else if section == 1 {
            if isHasBuilding == true {
                if userModel?.buildingId != nil {
                    return CGSize(width: kWidth, height: 0)
                }else {
                    return CGSize(width: kWidth, height: 40)
                }
            }else {
                return CGSize(width: kWidth, height: 68)
            }

        }else if section == 2 {
            return CGSize(width: kWidth, height: 68)
        }else {
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



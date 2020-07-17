//
//  OwnerPersonalIeditnfyVC.swift
//  OfficeGo
//
//  Created by mac on 2020/7/16.
//  Copyright © 2020 Senwei. All rights reserved.
//

import CLImagePickerTool

class OwnerPersonalIeditnfyVC: BaseViewController {
    
    var isFront: Bool? = true
    
    var frontImage: UIImage?
    
    var reverseImage: UIImage?
    
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
                make.top.equalTo(cellFrame.minY + cell_height_58 + 1)
                make.leading.trailing.equalToSuperview()
                make.bottom.equalToSuperview().offset(-bottomMargin())
            })
            
        }
    }
    
    @objc var uploadPicFCZArr = [UIImage]()  // 在实际的项目中可能用于存储图片的url
    
    @objc var uploadPicZLAgentArr = [UIImage]()  // 在实际的项目中可能用于存储图片的url
    
    @objc var uplaodMainPageimg = UIImage.init(named: "addImgBg")  // 在实际的项目中可能用于存储图片的url
    
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
                    OwnerPersonalIedntifyConfigureModel.init(types: .OwnerPersonalIedntifyTypeBuildingAddress),
                    OwnerPersonalIedntifyConfigureModel.init(types: .OwnerPersonalIedntifyTypeBuildingFCType)])
        
        arr.append([OwnerPersonalIedntifyConfigureModel.init(types: .OwnerPersonalIedntifyTypeUploadFangchanzheng)])
        
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpData()
        setUpView()
        addNotify()
    }
    func addNotify() {
        
        //个人认证 - 创建办公楼通知
        NotificationCenter.default.addObserver(forName: NSNotification.Name.OwnerCreateBuilding, object: nil, queue: OperationQueue.main) { [weak self] (noti) in
            if let model = noti.object as? OwnerESBuildingSearchModel {
                self?.userModel?.buildingName = model.buildingName
                self?.userModel?.address = model.address
                self?.buildingNameSearchResultVC?.view.isHidden = true
                self?.loadCollectionData()
            }
        }
        
        
    }
    override func leftBtnClick() {
        let alert = SureAlertView(frame: self.view.frame)
        alert.ShowAlertView(withalertType: AlertType.AlertTypeMessageAlert, title: "确认离开吗？", descMsg: "个人认证未完成，点击保存下次可继续编辑。点击离开，已编辑信息不保存", cancelButtonCallClick: { [weak self] in
            
            self?.navigationController?.popViewController(animated: true)
        }) { [weak self] in
            
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
}


extension OwnerPersonalIeditnfyVC {
    
    @objc func logotClick() {
        
        showCommitAlertview()
    }
    func setUpData() {
        userModel = OwnerIdentifyUserModel()
    }
    func setUpView() {
        
        uploadPicFCZArr.append(UIImage.init(named: "addImgBg") ?? UIImage())
        uploadPicZLAgentArr.append(UIImage.init(named: "addImgBg") ?? UIImage())
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
            
            self?.userModel?.buildingName = model.buildingAttributedName?.string
            self?.userModel?.address = model.addressString?.string
            self?.buildingNameSearchResultVC?.view.isHidden = true
            self?.loadCollectionData()
        }
        
        // 创建按钮 - 隐藏 - 展示下面的楼盘地址 - 地址置空
        buildingNameSearchResultVC?.creatButtonCallClick = {[weak self] in
            self?.userModel?.buildingName = ""
            let vc = OwnerCreateBuildingViewController()
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        //第一次刷新列表
        loadCollectionData()
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
        mainPicImagePickTool.cl_setupImagePickerWith(MaxImagesCount: 10 - uploadPicFCZArr.count) {[weak self] (asset,cutImage) in
            // 内部提供的方法可以异步获取图片，同步获取的话时间比较长，不建议！，如果是iCloud中的照片就直接从icloud中下载，下载完成后返回图片,同时也提供了下载失败的方法
            CLImagePickerTool.convertAssetArrToOriginImage(assetArr: asset, scale: 0.1, successClouse: {[weak self] (image,assetItem) in
                self?.uploadPicFCZArr.insert(image, at: 0)
                }, failedClouse: { () in
                    
            })
            self?.loadCollectionData()
        }
    }
    
    
    func pickerSelectIDCard() {
        let alertController = UIAlertController.init(title: "", message: nil, preferredStyle: .actionSheet)
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
                    self?.reverseImage = image
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
        let alertController = UIAlertController.init(title: "", message: nil, preferredStyle: .actionSheet)
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
                    self?.frontImage = image
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
            frontImage = image
        }else {
            reverseImage = image
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
                self?.userModel?.nickname = nickname
                self?.loadCollectionData()
            }
            cell?.buildingIdCardEndEditingMessageCell = { [weak self] (idCard) in
                self?.userModel?.idCard = idCard
                self?.loadCollectionData()
            }
            return cell ?? OwnerPersonalIdentifyCell()
        }else if indexPath.section == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OwnerPersonalIdentifyCell.reuseIdentifierStr, for: indexPath as IndexPath) as? OwnerPersonalIdentifyCell
            cell?.userModel = self.userModel
            cell?.model = typeSourceArray[indexPath.section][indexPath.item]
            
            cell?.buildingNameClickClouse = { [weak self] (buildingName) in
                self?.buildingName = buildingName
            }
            cell?.buildingAddresEndEditingMessageCell = { [weak self] (buildingAddres) in
                self?.userModel?.address = buildingAddres
                self?.loadCollectionData()
            }
            cell?.buildingNameEndEditingMessageCell = { [weak self] (buildingNAme) in
                self?.userModel?.buildingName = buildingNAme
                self?.loadCollectionData()
            }
            return cell ?? OwnerPersonalIdentifyCell()
        }else if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OwnerIdCardImagePickerCell.reuseIdentifierStr, for: indexPath as IndexPath) as? OwnerIdCardImagePickerCell
            if indexPath.item == 0 {
                cell?.addTitleLabel.text = "上传身份证人像面"
                cell?.image.image = frontImage
            }else if indexPath.item == 1 {
                cell?.addTitleLabel.text = "上传身份证国徽面"
                cell?.image.image = reverseImage
            }
            return cell ?? OwnerIdCardImagePickerCell()
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OwnerImagePickerCell.reuseIdentifierStr, for: indexPath as IndexPath) as? OwnerImagePickerCell
            cell?.indexPath = indexPath
            cell?.image.image = uploadPicFCZArr[indexPath.item]
            cell?.closeBtnClickClouse = { [weak self] (index) in
                self?.uploadPicFCZArr.remove(at: index)
                self?.loadCollectionData()
            }
            if indexPath.item == uploadPicFCZArr.count - 1 {
                cell?.closeBtn.isHidden = true
            }else {
                cell?.closeBtn.isHidden = false
            }
            return cell ?? OwnerImagePickerCell()
        }
        
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if let idCard = userModel?.idCard {
            if idCard.isBlankString == true {
                return 2
            }else {
                return typeSourceArray.count
            }
        }else {
            return 2
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return typeSourceArray[0].count
        }else if section == 1 {
            //身份证
            return 2
        }else if section == 2 {
            if let buildingName = userModel?.buildingName {
                if buildingName.isBlankString == true {
                    return 2
                }else {
                    return typeSourceArray[2].count
                }
            }else {
                return 2
            }
            return typeSourceArray[2].count
        }else if section == 3 {
            if let buildingName = userModel?.buildingName {
                if buildingName.isBlankString == true {
                    return 2
                }else {
                    return uploadPicFCZArr.count
                }
            }else {
                return 0
            }
            return uploadPicFCZArr.count
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
            return CGSize(width: kWidth - left_pending_space_17 * 2, height: cell_height_58)
        }else if indexPath.section == 3 {
            return CGSize(width: (kWidth - left_pending_space_17 * 2 - 5 * 2) / 3.0 - 1, height: (kWidth - left_pending_space_17 * 2 - 5 * 2) / 3.0 - 1)
        }
        return CGSize(width: 0, height: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 || section == 2 {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            
        }else if section == 1{
            return UIEdgeInsets(top: 0, left: left_pending_space_17, bottom: 26, right: left_pending_space_17)
        }else if section == 3{
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
            if indexPath.item == 2 {
                
                let alertController = UIAlertController.init(title: "房产类型", message: nil, preferredStyle: .actionSheet)
                let refreshAction = UIAlertAction.init(title: "自有房产", style: .default) {[weak self] (action: UIAlertAction) in
                    self?.userModel?.leaseType = 0
                    self?.loadCollectionData()
                }
                let copyAction = UIAlertAction.init(title: "租赁房产", style: .default) {[weak self] (action: UIAlertAction) in
                    self?.userModel?.leaseType = 1
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
                if indexPath.item == uploadPicFCZArr.count - 1 {
                    selectFCZPicker()
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
            
        }else if section == 3 {
            if let buildingName = userModel?.buildingName {
                if buildingName.isBlankString == true {
                    return CGSize(width: kWidth, height: 0)
                }else {
                    return CGSize(width: kWidth, height: 68)
                }
            }else {
                return CGSize(width: kWidth, height: 0)
            }
            
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

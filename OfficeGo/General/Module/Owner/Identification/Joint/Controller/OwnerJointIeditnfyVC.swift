//
//  OwnerJointIeditnfyVC.swift
//  OfficeGo
//
//  Created by mac on 2020/7/15.
//  Copyright © 2020 Senwei. All rights reserved.
//

import CLImagePickerTool

class OwnerJointIeditnfyVC: BaseViewController {
    
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
                   branchSearchResultVC?.keywords = buildingName
               }
               branchSearchResultVC?.view.snp.remakeConstraints({ (make) in
                   make.top.equalTo(cellFrame.minY + cell_height_58 + 1)
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
                make.top.equalTo(cellFrame.minY + cell_height_58 + 1)
                make.leading.trailing.equalToSuperview()
                make.bottom.equalToSuperview().offset(-bottomMargin())
            })
            //隐藏公司搜索的框
            branchSearchResultVC?.view.isHidden = true
            companySearchResultVC?.view.isHidden = true
        }
    }
    
    @objc var uploadPicFCZArr = [UIImage]()  // 在实际的项目中可能用于存储图片的url
    
    @objc var uploadPicZLAgentArr = [UIImage]()  // 在实际的项目中可能用于存储图片的url
    
    @objc var uplaodMainPageimg = UIImage.init(named: "addImgBg")  // 在实际的项目中可能用于存储图片的url
    
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
        
        arr.append([OwnerJointIedntifyConfigureModel.init(types: .OwnerJointIedntifyTypeBuildingName)])
        
        arr.append([OwnerJointIedntifyConfigureModel.init(types: .OwnerJointIedntifyTypeUploadFangchanzheng)])
        
        arr.append([OwnerJointIedntifyConfigureModel.init(types: .OwnerJointIedntifyTypeUploadZulinAgent)])
        
        arr.append([OwnerJointIedntifyConfigureModel.init(types: .OwnerJointIedntifyTypeUploadMainimg)])
        
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
        
         //公司认证 - 发送加入网点通知
       NotificationCenter.default.addObserver(forName: NSNotification.Name.OwnerApplyEnterCompanyJoint, object: nil, queue: OperationQueue.main) { [weak self] (noti) in
           if let model = noti.object as? OwnerESCompanySearchViewModel {
               self?.userModel?.branchName = model.companyString?.string
               self?.branchSearchResultVC?.view.isHidden = true
               self?.loadCollectionData()
           }
       }
       
       //公司认证 - 创建网点成功通知
       NotificationCenter.default.addObserver(forName: NSNotification.Name.OwnerCreateCompanyJoint, object: nil, queue: OperationQueue.main) { [weak self] (noti) in
           if let model = noti.object as? OwnerESCompanySearchModel {
               self?.userModel?.branchName = model.company
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
            if let model = noti.object as? OwnerESCompanySearchModel {
                self?.userModel?.company = model.company
                self?.companySearchResultVC?.view.isHidden = true
                self?.loadCollectionData()
            }
        }
    }
    
    override func leftBtnClick() {
        let alert = SureAlertView(frame: self.view.frame)
        alert.ShowAlertView(withalertType: AlertType.AlertTypeMessageAlert, title: "确认离开吗？", descMsg: "联合办公认证未完成，点击保存下次可继续编辑。点击离开，已编辑信息不保存", cancelButtonCallClick: { [weak self] in
            
            self?.navigationController?.popViewController(animated: true)
        }) { [weak self] in
            
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
}


extension OwnerJointIeditnfyVC {
    
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
        titleview?.titleLabel.text = "联合办公业主认证"
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
        headerCollectionView.register(OwnerJointIdentifyCell.self, forCellWithReuseIdentifier: OwnerJointIdentifyCell.reuseIdentifierStr)
        headerCollectionView.register(OwnerImagePickerCell.self, forCellWithReuseIdentifier: OwnerImagePickerCell.reuseIdentifierStr)
        headerCollectionView.register(OwnerImgPickerCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "OwnerImgPickerCollectionViewHeader")
        
        
        //网点
        branchSearchResultVC = OwnerCompanyESearchResultListViewController.init()
        branchSearchResultVC?.isBranch = true
        branchSearchResultVC?.view.isHidden = true
        self.view.addSubview(branchSearchResultVC?.view ?? UIView())
        
        // 传递闭包 当点击’搜索结果‘的cell调用
        branchSearchResultVC?.callBack = {[weak self] (model) in
            let vc = OwnerApplyEnterCompanyViewController()
            //区分网点和公司
            vc.isBranch = true
            vc.companyModel = model
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        // 创建按钮 - 跳转到创建公司页面
        branchSearchResultVC?.creatButtonCallClick = {[weak self] in
            self?.userModel?.company = ""
            let vc = OwnerCreateCompanyViewController()
            //区分网点和公司
            vc.isBranch = true
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        
        
        //公司名
        companySearchResultVC = OwnerCompanyESearchResultListViewController.init()
        companySearchResultVC?.view.isHidden = true
        self.view.addSubview(companySearchResultVC?.view ?? UIView())
        
        // 传递闭包 当点击’搜索结果‘的cell调用
        companySearchResultVC?.callBack = {[weak self] (model) in
            let vc = OwnerApplyEnterCompanyViewController()
            vc.companyModel = model
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        // 创建按钮 - 跳转到创建公司页面
        companySearchResultVC?.creatButtonCallClick = {[weak self] in
            self?.userModel?.company = ""
            let vc = OwnerCreateCompanyViewController()
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        
        
        //办公楼
        buildingNameSearchResultVC = OwnerBuildingNameESearchResultListViewController.init()
        buildingNameSearchResultVC?.view.isHidden = true
        self.view.addSubview(buildingNameSearchResultVC?.view ?? UIView())
        
        // 传递闭包 当点击’搜索结果‘的cell调用
        buildingNameSearchResultVC?.callBack = {[weak self] (model) in
            // 搜索完成 关闭resultVC
            
            self?.userModel?.buildingName = model.buildingAttributedName?.string
            self?.userModel?.address = model.addressString?.string
            self?.buildingNameSearchResultVC?.view.isHidden = true
            self?.loadCollectionData()
        }
        
        // 创建按钮 - 隐藏 - 展示下面的楼盘地址 - 地址置空
        buildingNameSearchResultVC?.creatButtonCallClick = {[weak self] in
            self?.buildingNameSearchResultVC?.view.isHidden = true
            self?.userModel?.address = ""
            self?.loadCollectionData()
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
            let vc = OwnerCreateCompanyViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }) {
            
        }
    }
    
    ///切换身份ui
    func roleChangeClick() {
        
        let alert = SureAlertView(frame: self.view.frame)
        var aelrtMsg: String = ""
        if UserTool.shared.user_id_type == 0 {
            aelrtMsg = "是否确认切换为业主？"
            
        }else if UserTool.shared.user_id_type == 1 {
            aelrtMsg = "是否确认切换为租户？"
        }
        alert.ShowAlertView(withalertType: AlertType.AlertTypeMessageAlert, title: "温馨提示", descMsg: aelrtMsg, cancelButtonCallClick: {
            
        }) { [weak self] in
            
            self?.requestRoleChange()
        }
    }
    
    ///切换身份接口
    func requestRoleChange() {
        var params = [String:AnyObject]()
        if UserTool.shared.user_id_type == 0 {
            params["roleType"] = "1" as AnyObject?
        }else if UserTool.shared.user_id_type == 1 {
            params["roleType"] = "0" as AnyObject?
        }
        params["token"] = UserTool.shared.user_token as AnyObject?
        
        SSNetworkTool.SSMine.request_roleChange(params: params, success: { (response) in
            if let model = LoginModel.deserialize(from: response, designatedPath: "data") {
                UserTool.shared.user_id_type = model.rid
                UserTool.shared.user_rongyuntoken = model.rongyuntoken
                UserTool.shared.user_uid = model.uid
                UserTool.shared.user_token = model.token
                UserTool.shared.user_avatars = model.avatar
                UserTool.shared.user_name = model.nickName
                UserTool.shared.synchronize()
                NotificationCenter.default.post(name: NSNotification.Name.UserRoleChange, object: nil)
            }
        }, failure: {[weak self] (error) in
            
            
        }) {[weak self] (code, message) in
            //只有5000 提示给用户
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" {
                AppUtilities.makeToast(message)
            }
        }
        
        
    }
}

extension OwnerJointIeditnfyVC {
    func selectFCZPicker() {
        let imagePickTool = CLImagePickerTool()
        imagePickTool.cameraOut = true
        imagePickTool.isHiddenVideo = true
        imagePickTool.cl_setupImagePickerWith(MaxImagesCount: 10 - uploadPicFCZArr.count) {[weak self] (asset,cutImage) in
            // 内部提供的方法可以异步获取图片，同步获取的话时间比较长，不建议！，如果是iCloud中的照片就直接从icloud中下载，下载完成后返回图片,同时也提供了下载失败的方法
            CLImagePickerTool.convertAssetArrToOriginImage(assetArr: asset, scale: 0.1, successClouse: {[weak self] (image,assetItem) in
                self?.uploadPicFCZArr.insert(image, at: 0)
                }, failedClouse: { () in
                    
            })
            self?.loadCollectionData()
        }
    }
    
    func selectZLAgentPicker() {
        let imagePickTool = CLImagePickerTool()
        imagePickTool.cameraOut = true
        imagePickTool.isHiddenVideo = true
        imagePickTool.cl_setupImagePickerWith(MaxImagesCount: 10 - uploadPicZLAgentArr.count) {[weak self] (asset,cutImage) in
            // 内部提供的方法可以异步获取图片，同步获取的话时间比较长，不建议！，如果是iCloud中的照片就直接从icloud中下载，下载完成后返回图片,同时也提供了下载失败的方法
            CLImagePickerTool.convertAssetArrToOriginImage(assetArr: asset, scale: 0.1, successClouse: {[weak self] (image,assetItem) in
                self?.uploadPicZLAgentArr.insert(image, at: 0)
                }, failedClouse: { () in
                    
            })
            self?.loadCollectionData()
        }
    }
    
    func selectMainPagePicker() {
        let imagePickTool = CLImagePickerTool()
        imagePickTool.cameraOut = true
        imagePickTool.isHiddenVideo = true
        imagePickTool.singleImageChooseType = .singlePicture   //设置单选
        imagePickTool.cl_setupImagePickerWith(MaxImagesCount: 1) {[weak self] (asset,cutImage) in
            // 内部提供的方法可以异步获取图片，同步获取的话时间比较长，不建议！，如果是iCloud中的照片就直接从icloud中下载，下载完成后返回图片,同时也提供了下载失败的方法
            CLImagePickerTool.convertAssetArrToOriginImage(assetArr: asset, scale: 0.1, successClouse: {[weak self] (image,assetItem) in
                self?.uplaodMainPageimg = image
                }, failedClouse: { () in
                    
            })
            self?.loadCollectionData()
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
                self?.branchName = branchName
            }
            cell?.companyNameClickClouse = { [weak self] (companyName) in
                self?.companyName = companyName
            }
            cell?.buildingNameClickClouse = { [weak self] (buildingName) in
                self?.buildingName = buildingName
            }
            cell?.buildingNameEndEditingMessageCell = { [weak self] (buildingNAme) in
                self?.userModel?.buildingName = buildingNAme
                self?.loadCollectionData()
            }
            return cell ?? OwnerJointIdentifyCell()
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OwnerImagePickerCell.reuseIdentifierStr, for: indexPath as IndexPath) as? OwnerImagePickerCell
            cell?.indexPath = indexPath
            if indexPath.section == 2 {
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
            }else if indexPath.section == 3 {
                cell?.image.image = uploadPicZLAgentArr[indexPath.item]
                cell?.closeBtnClickClouse = { [weak self] (index) in
                    self?.uploadPicZLAgentArr.remove(at: index)
                    self?.loadCollectionData()
                }
                if indexPath.item == uploadPicZLAgentArr.count - 1 {
                    cell?.closeBtn.isHidden = true
                }else {
                    cell?.closeBtn.isHidden = false
                }
            }else if indexPath.section == 4 {
                cell?.image.image = uplaodMainPageimg
                cell?.closeBtn.isHidden = true
            }
            return cell ?? OwnerImagePickerCell()
        }
        
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if let company = userModel?.company {
            if company.isBlankString == true {
                return 1
            }else {
                return typeSourceArray.count
            }
        }else {
            return 1
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            if let branchName = userModel?.branchName {

                if branchName.isBlankString == true {
                    return 2
                }else {
                    return typeSourceArray[0].count
                }
            }else {
                return 2
            }
        }else if section == 1 {
            if let buildingName = userModel?.company {
                if buildingName.isBlankString == true {
                    return 0
                }else {
                    return typeSourceArray[1].count
                }
            }else {
                return 0
            }
        }else if section == 2 {
            if let buildingName = userModel?.buildingName {
                if buildingName.isBlankString == true {
                    return 0
                }else {
                    return uploadPicFCZArr.count
                }
            }else {
                return 0
            }
            
        }else if section == 3 {
            if let buildingName = userModel?.buildingName {
                if buildingName.isBlankString == true {
                    return 0
                }else {
                    return uploadPicZLAgentArr.count
                }
            }else {
                return 0
            }
            
        }else if section == 4 {
            if let buildingName = userModel?.buildingName {
                if buildingName.isBlankString == true {
                    return 0
                }else {
                    return 1
                }
            }else {
                return 0
            }
            
        }
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0 {
            return CGSize(width: kWidth - left_pending_space_17 * 2, height: cell_height_58)
        }else if indexPath.section == 1 {
            return CGSize(width: kWidth - left_pending_space_17 * 2, height: cell_height_58)
        }else if indexPath.section == 2 {
            return CGSize(width: (kWidth - left_pending_space_17 * 4) / 3.0 - 1, height: (kWidth - left_pending_space_17 * 4) / 3.0 - 1)
        }else if indexPath.section == 3 {
            return CGSize(width: (kWidth - left_pending_space_17 * 4) / 3.0 - 1, height: (kWidth - left_pending_space_17 * 4) / 3.0 - 1)
        }else if indexPath.section == 4 {
            return CGSize(width: (kWidth - left_pending_space_17 * 4) / 3.0 - 1, height: (kWidth - left_pending_space_17 * 4) / 3.0 - 1)
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
            
        }else if indexPath.section == 1 {
            
        }else {
            if indexPath.section == 2 {
                if indexPath.item == uploadPicFCZArr.count - 1 {
                    selectFCZPicker()
                }
            }else if indexPath.section == 3 {
                if indexPath.item == uploadPicZLAgentArr.count - 1 {
                    selectZLAgentPicker()
                }
            }else if indexPath.section == 4 {
                selectMainPagePicker()
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
            }else if indexPath.section == 4{
                header?.backgroundColor = kAppWhiteColor
                header?.titleLabel.text = "上传楼盘封面图"
                header?.descLabel.text = ""
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
            
        }else if section == 2 || section == 3 {
            if let buildingName = userModel?.buildingName {
                if buildingName.isBlankString == true {
                    return CGSize(width: kWidth, height: 0)
                }else {
                    return CGSize(width: kWidth, height: 68)
                }
            }else {
                return CGSize(width: kWidth, height: 0)
            }
            
        }else if section == 4 {
            if let buildingName = userModel?.buildingName {
                if buildingName.isBlankString == true {
                    return CGSize(width: kWidth, height: 0)
                }else {
                    return CGSize(width: kWidth, height: 46)
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
        if section == 0 || section == 1 {
            return 0
        }else {
            return left_pending_space_17
        }
    }
    
    ////两个cell之间的间距（同一行的cell的间距）
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if section == 0 || section == 1 {
            return 0
        }else {
            return left_pending_space_17
        }
    }
}
extension OwnerJointIeditnfyVC {
    //MARK: 滑动- 设置标题颜色
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        SSLog("scrollViewDidScroll ----*\(scrollView.contentOffset.y)")
    }
}

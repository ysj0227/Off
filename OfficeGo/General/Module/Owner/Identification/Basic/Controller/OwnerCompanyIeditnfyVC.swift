//
//  OwnerCompanyIeditnfyVC.swift
//  OfficeGo
//
//  Created by mac on 2020/7/13.
//  Copyright © 2020 Senwei. All rights reserved.
//
import CLImagePickerTool

class OwnerCompanyIeditnfyVC: BaseViewController {
    
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
    
    var typeSourceArray:[[OwnerCompanyIedntifyConfigureModel]] = {
        var arr = [[OwnerCompanyIedntifyConfigureModel]]()
        
        arr.append([OwnerCompanyIedntifyConfigureModel.init(types: .OwnerCompanyIedntifyTypeIdentigy),
                    OwnerCompanyIedntifyConfigureModel.init(types: .OwnerCompanyIedntifyTypeCompanyname)])
        
        arr.append([OwnerCompanyIedntifyConfigureModel.init(types: .OwnerCompanyIedntifyTypeBuildingName),
                    OwnerCompanyIedntifyConfigureModel.init(types: .OwnerCompanyIedntifyTypeBuildingAddress),
                    OwnerCompanyIedntifyConfigureModel.init(types: .OwnerCompanyIedntifyTypeBuildingFCType)])
        
        arr.append([OwnerCompanyIedntifyConfigureModel.init(types: .OwnerCompanyIedntifyTypeUploadFangchanzheng)])
        
        arr.append([OwnerCompanyIedntifyConfigureModel.init(types: .OwnerCompanyIedntifyTypeUploadZulinAgent)])
        
        arr.append([OwnerCompanyIedntifyConfigureModel.init(types: .OwnerCompanyIedntifyTypeUploadMainimg)])
        
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
        setUpData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
    }
    
}


extension OwnerCompanyIeditnfyVC {
    
    @objc func logotClick() {
        
        showLogotAlertview()
    }
    
    func setUpView() {
        
        uploadPicFCZArr.append(UIImage.init(named: "addImgBg") ?? UIImage())
        uploadPicZLAgentArr.append(UIImage.init(named: "addImgBg") ?? UIImage())
        titleview = ThorNavigationView.init(type: .backTitleRightBlueBgclolor)
        titleview?.titleLabel.text = "公司业主认证"
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
        headerCollectionView.register(OwnerCompanyIdentifyCell.self, forCellWithReuseIdentifier: OwnerCompanyIdentifyCell.reuseIdentifierStr)
        headerCollectionView.register(OwnerImagePickerCell.self, forCellWithReuseIdentifier: OwnerImagePickerCell.reuseIdentifierStr)
        headerCollectionView.register(OwnerImgPickerCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "OwnerImgPickerCollectionViewHeader")
        
    }
    
    func setUpData() {
        headerCollectionView.reloadData()
    }
    
    func showLogotAlertview() {
        let alert = SureAlertView(frame: self.view.frame)
        alert.ShowAlertView(withalertType: AlertType.AlertTypeMessageAlert, title: "温馨提示", descMsg: "是否确定退出？", cancelButtonCallClick: {
            
        }) {
            
            //退出登录 - 判断是业主还是租户
            //业主- 直接退出登录 -
            //租户- 返回个人中心 - 个人中心状态刷新为未登录
            /// role 角色 用户身份类型,,0:租户,1:业主,9:其他
            if UserTool.shared.user_id_type == 0 {
                //不清空身份类型
                UserTool.shared.removeAll()
                self.leftBtnClick()
                
            }else if UserTool.shared.user_id_type == 1 {
                NotificationCenter.default.post(name: NSNotification.Name.OwnerUserLogout, object: nil)
            }
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

extension OwnerCompanyIeditnfyVC {
    func selectFCZPicker() {
        let imagePickTool = CLImagePickerTool()
        imagePickTool.cl_setupImagePickerWith(MaxImagesCount: 10 - uploadPicFCZArr.count) {[weak self] (asset,cutImage) in
            // 内部提供的方法可以异步获取图片，同步获取的话时间比较长，不建议！，如果是iCloud中的照片就直接从icloud中下载，下载完成后返回图片,同时也提供了下载失败的方法
            CLImagePickerTool.convertAssetArrToOriginImage(assetArr: asset, scale: 0.1, successClouse: {[weak self] (image,assetItem) in
                self?.uploadPicFCZArr.insert(image, at: 0)
                }, failedClouse: { () in
                    
            })
            self?.headerCollectionView.reloadData()
        }
    }
    
    func selectZLAgentPicker() {
        let imagePickTool = CLImagePickerTool()
        imagePickTool.cl_setupImagePickerWith(MaxImagesCount: 10 - uploadPicZLAgentArr.count) {[weak self] (asset,cutImage) in
            // 内部提供的方法可以异步获取图片，同步获取的话时间比较长，不建议！，如果是iCloud中的照片就直接从icloud中下载，下载完成后返回图片,同时也提供了下载失败的方法
            CLImagePickerTool.convertAssetArrToOriginImage(assetArr: asset, scale: 0.1, successClouse: {[weak self] (image,assetItem) in
                self?.uploadPicZLAgentArr.insert(image, at: 0)
                }, failedClouse: { () in
                    
            })
            self?.headerCollectionView.reloadData()
        }
    }
    
    func selectMainPagePicker() {
        let imagePickTool = CLImagePickerTool()
        imagePickTool.cl_setupImagePickerWith(MaxImagesCount: 1) {[weak self] (asset,cutImage) in
            // 内部提供的方法可以异步获取图片，同步获取的话时间比较长，不建议！，如果是iCloud中的照片就直接从icloud中下载，下载完成后返回图片,同时也提供了下载失败的方法
            CLImagePickerTool.convertAssetArrToOriginImage(assetArr: asset, scale: 0.1, successClouse: {[weak self] (image,assetItem) in
                self?.uplaodMainPageimg = image
                }, failedClouse: { () in
                    
            })
            self?.headerCollectionView.reloadData()
        }
    }
}

extension OwnerCompanyIeditnfyVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 || indexPath.section == 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OwnerCompanyIdentifyCell.reuseIdentifierStr, for: indexPath as IndexPath) as? OwnerCompanyIdentifyCell
            cell?.model = typeSourceArray[indexPath.section][indexPath.item]
            return cell ?? OwnerCompanyIdentifyCell()
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OwnerImagePickerCell.reuseIdentifierStr, for: indexPath as IndexPath) as? OwnerImagePickerCell
            cell?.indexPath = indexPath
            if indexPath.section == 2 {
                cell?.image.image = uploadPicFCZArr[indexPath.item]
                cell?.closeBtnClickClouse = { [weak self] (index) in
                    self?.uploadPicFCZArr.remove(at: index)
                    self?.headerCollectionView.reloadData()
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
                   self?.headerCollectionView.reloadData()
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
        return typeSourceArray.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return typeSourceArray[0].count
        }else if section == 1 {
            return typeSourceArray[1].count
        }else if section == 2 {
            return uploadPicFCZArr.count
        }else if section == 3 {
            return uploadPicZLAgentArr.count
        }else if section == 4 {
            return 1
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
        if indexPath.section == 0 || indexPath.section == 1 {

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
            return CGSize(width: kWidth, height: 68)
        }else if section == 4 {
            return CGSize(width: kWidth, height: 46)
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

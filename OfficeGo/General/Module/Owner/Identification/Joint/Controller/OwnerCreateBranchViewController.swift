//
//  OwnerCreateBranchViewController.swift
//  OfficeGo
//
//  Created by mac on 2020/7/16.
//  Copyright © 2020 Senwei. All rights reserved.
//

import CLImagePickerTool
import Alamofire
class OwnerCreateBranchViewController: BaseTableViewController {
    
    var areaModelCount: CityAreaCategorySelectModel?
    
    var mainPicPhoto: UIImageView = {
        
        let view = UIImageView.init(frame: CGRect(x: left_pending_space_17, y: 0, width: (kWidth - left_pending_space_17 * 4) / 3.0 - 1, height: (kWidth - left_pending_space_17 * 4) / 3.0 - 1))
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.image = UIImage.init(named: "addImgBg")
        view.isUserInteractionEnabled = true
        return view
    }()
    
    //封面图
    var mainPicBannermodel: BannerModel?
    
    lazy var bottomBtnView: BottomBtnView = {
        let view = BottomBtnView.init(frame: CGRect(x: 0, y: 0, width: kWidth, height: 50))
        view.bottomType = BottomBtnViewType.BottomBtnViewTypeIwantToFind
        view.rightSelectBtn.setTitle("确认创建", for: .normal)
        view.backgroundColor = kAppWhiteColor
        return view
    }()
    
    lazy var imagePickTool: CLImagePickerTool = {
        let picker = CLImagePickerTool()
        picker.cameraOut = true
        picker.isHiddenVideo = true
        picker.singleImageChooseType = .singlePicture   //设置单选
        picker.singleModelImageCanEditor = false        //单选不可编辑
        return picker
    }()
    
    var typeSourceArray:[OwnerCreatBranchConfigureModel] = [OwnerCreatBranchConfigureModel]()
    
    var userModel: OwnerIdentifyUserModel?
    
    
    lazy var areaView: CityDistrictAddressSelectView = {
        let view = CityDistrictAddressSelectView.init(frame: CGRect(x: 0.0, y: kNavigationHeight + cell_height_58 * 2, width: kWidth, height: kHeight - kNavigationHeight - cell_height_58 * 2 - bottomMargin()))
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        
        setUpData()
        
        request_getDistrict()
    }
    
    func showLeaveAlert() {
        endEdting()
        let alert = SureAlertView(frame: self.view.frame)
        alert.ShowAlertView(withalertType: AlertType.AlertTypeMessageAlert, title: "确认离开吗？", descMsg: "信息尚未提交。点击离开，已编辑信息不保存", cancelButtonCallClick: {
            
        }) { [weak self] in
            
            self?.leftBtnClick()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //移除弹框
        CityDistrictAddressSelectView.removeShowView()
    }
    
    ///提交认证
    func requestCompanyIdentify() {
        
        if userModel?.branchesName == nil || userModel?.branchesName?.isBlankString == true{
            AppUtilities.makeToast("请输入网点名称")
            return
        }
        
        if areaModelCount?.isFirstSelectedModel?.districtID == nil || areaModelCount?.isFirstSelectedModel?.districtID?.isBlankString == true{
            AppUtilities.makeToast("请选择所在区域")
            return
        }
        
        if userModel?.buildingAddress == nil || userModel?.buildingAddress?.isBlankString == true{
            AppUtilities.makeToast("请输入详细地址")
            return
        }
        
        if mainPicBannermodel?.isLocal == false {
            AppUtilities.makeToast("请上传网点封面图")
            return
        }
        
        
        
        var params = [String:AnyObject]()
        
        params["token"] = UserTool.shared.user_token as AnyObject?
        
        //身份类型0个人认证1企业认证2网点认证
        params["identityType"] = UserTool.shared.user_owner_identifytype as AnyObject?
        
        //1提交认证2企业确认3网点楼盘创建确认
        params["createCompany"] = 3 as AnyObject?
        
        
        ///企业关系id
        if userModel?.userLicenceId != "0" || userModel?.userLicenceId?.isBlankString != true {
            params["userLicenceId"] = userModel?.userLicenceId as AnyObject?
        }
        
        ///企业id
        if userModel?.licenceId != "0" || userModel?.licenceId?.isBlankString != true {
            params["licenceId"] = userModel?.licenceId as AnyObject?
        }
        
        ///关联楼id
        if userModel?.buildingId != "0" || userModel?.buildingId?.isBlankString != true {
            params["buildingId"] = userModel?.buildingId as AnyObject?
        }
        
        ///关联楼id
        if userModel?.buildingTempId != "0" || userModel?.buildingTempId?.isBlankString != true {
            params["buildingTempId"] = userModel?.buildingTempId as AnyObject?
        }
        
        if let district = userModel?.district {
            
        }else {
            params["district"] = areaModelCount?.isFirstSelectedModel?.districtID as AnyObject?
        }
        
        if let business = userModel?.business {
            
        }else {
            params["business"] = areaModelCount?.isFirstSelectedModel?.isSencondSelectedModel?.id as AnyObject?
        }
        
        params["branchesName"] = userModel?.branchesName as AnyObject?
        
        params["buildingAddress"] = userModel?.buildingAddress as AnyObject?
        
        //params["fileMainPic"] = userModel?.fileMainPic as AnyObject?
        
        SSNetworkTool.SSOwnerIdentify.request_createBuildingApp(params: params, imagesArray: [mainPicPhoto.image ?? UIImage()], success: {[weak self] (response) in
            
            guard let weakSelf = self else {return}
            
            weakSelf.addNotify()
            
            }, failure: { (error) in
                
                
        }) { (code, message) in
            
            //只有5000 提示给用户 - 失效原因
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" || code == "\(SSCode.ERROR_CODE_7016.code)" {
                AppUtilities.makeToast(message)
            }
        }
    }
}


extension OwnerCreateBranchViewController {
    
    func setUpView() {
        
        titleview = ThorNavigationView.init(type: .backTitleRight)
        titleview?.titleLabel.text = "创建网点"
        titleview?.rightButton.isHidden = true
        titleview?.leftButtonCallBack = { [weak self] in
            self?.showLeaveAlert()
        }
        
        self.view.addSubview(titleview ?? ThorNavigationView.init(type: .backTitleRight))
        
        self.tableView.snp.remakeConstraints { (make) in
            make.top.equalTo(kNavigationHeight)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-kStatusBarHeight)
        }
        
        self.tableView.register(OwnerCreateBranchCell.self, forCellReuseIdentifier: OwnerCreateBranchCell.reuseIdentifierStr)
        
        self.view.addSubview(bottomBtnView)
        
        bottomBtnView.rightBtnClickBlock = { [weak self] in
            self?.requestCreateCompany()
        }
        bottomBtnView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-bottomMargin())
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        
        let textMessageTap = UITapGestureRecognizer(target: self, action: #selector(imgClickGesture(_:)))
        textMessageTap.numberOfTapsRequired = 1
        textMessageTap.numberOfTouchesRequired = 1
        mainPicPhoto.addGestureRecognizer(textMessageTap)
        
        let footerview = UIView(frame: CGRect(x: 0, y: 0, width: kWidth, height: (kWidth - left_pending_space_17 * 4) / 3.0 - 1))
        footerview.addSubview(mainPicPhoto)
        
        self.tableView.tableFooterView = footerview
    }
    @objc private func imgClickGesture(_ tap: UITapGestureRecognizer) {
        
        pickerSelect()
    }
    func pickerSelect() {
        imagePickTool.cl_setupImagePickerWith(MaxImagesCount: 2) {[weak self] (asset,cutImage) in
            SSLog("返回的asset数组是\(asset)")
            
            var imageArr = [UIImage]()
            var index = asset.count // 标记失败的次数
            
            // 获取原图，异步
            // scale 指定压缩比
            // 内部提供的方法可以异步获取图片，同步获取的话时间比较长，不建议！，如果是iCloud中的照片就直接从icloud中下载，下载完成后返回图片,同时也提供了下载失败的方法
            CLImagePickerTool.convertAssetArrToOriginImage(assetArr: asset, scale: 0.1, successClouse: {[weak self] (image,assetItem) in
                let img = image.resizeMax1500Image()
                
                self?.mainPicBannermodel?.isLocal = true
                self?.mainPicBannermodel?.image = img
                self?.mainPicPhoto.image = img
                }, failedClouse: {[weak self] () in
                    self?.mainPicBannermodel?.isLocal = false
                    index = index - 1
                    //                    self?.dealImage(imageArr: imageArr, index: index)
            })
        }
    }
    
    func setUpData() {
        
        typeSourceArray.append(OwnerCreatBranchConfigureModel.init(types: .OwnerCreteBranchTypeBranchName))
        typeSourceArray.append(OwnerCreatBranchConfigureModel.init(types: .OwnerCreteBranchTypeBranchDistrictArea))
        typeSourceArray.append(OwnerCreatBranchConfigureModel.init(types: .OwnerCreteBranchTypeBranchAddress))
        typeSourceArray.append(OwnerCreatBranchConfigureModel.init(types: .OwnerCreteBranchTypeUploadYingyePhoto))
        
        setData()
        loadTableview()
    }
    
    func setData() {
        if userModel != nil {
            
        }else {
            userModel = OwnerIdentifyUserModel()
        }
        
        if mainPicBannermodel != nil {
            
        }else {
            mainPicBannermodel = BannerModel()
        }
    }
    
    func loadTableview() {
        self.tableView.reloadData()
    }
    
    func setSureBtnEnable(can: Bool) {
        self.bottomBtnView.rightSelectBtn.isUserInteractionEnabled = can
    }
    
    func updateSuccess() {
        
        AppUtilities.makeToast("保存成功")
        
        SSTool.delay(time: 2) {[weak self] in
            
            self?.leftBtnClick()
            
            self?.setSureBtnEnable(can: true)
            
        }
    }
    
    //发送加入公司和网点公司的通知
    func addNotify() {
        ///身份类型0个人1企业2联合
        NotificationCenter.default.post(name: NSNotification.Name.OwnerCreateBranchJoint, object: userModel)
        leftBtnClick()
    }
    
    ///创建公司接口 -
    func requestCreateCompany() {
        endEdting()
        requestCompanyIdentify()
    }
    //MARK: 获取商圈数据
    func request_getDistrict() {
        //查询类型，1：全部，0：系统已有楼盘的商圈
        var params = [String:AnyObject]()
        params["type"] = 1 as AnyObject?
        SSNetworkTool.SSBasic.request_getDistrictList(params: params, success: { [weak self] (response) in
            if let model = CityAreaCategorySelectModel.deserialize(from: response) {
                model.name = "上海"
                self?.areaModelCount = model
                self?.getSelectedDistrictBusiness()
            }
            
            }, failure: { [weak self] (error) in
                
        }) { [weak self] (code, message) in
            
            
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
                userModel?.districtString = model.district
                areaModelCount?.isFirstSelectedModel?.list.forEach({ (areaModel) in
                    if areaModelCount?.isFirstSelectedModel?.districtID == areaModel.id {
                        areaModelCount?.isFirstSelectedModel?.isSencondSelectedModel = areaModel
                        userModel?.businessString = areaModel.area
                        loadTableview()
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
        areaView.ShowCityDistrictAddressSelectView(isfirst: isFrist, model: self.areaModelCount ?? CityAreaCategorySelectModel(), clearButtonCallBack: { [weak self] (_ selectModel: CityAreaCategorySelectModel) -> Void in
            
            }, sureAreaaddressButtonCallBack: { [weak self] (_ selectModel: CityAreaCategorySelectModel) -> Void in
                self?.areaModelCount = selectModel
                self?.userModel?.districtString = "\(selectModel.name ?? "上海")市 \(selectModel.isFirstSelectedModel?.district ?? "")区"
                self?.userModel?.businessString = "\(selectModel.isFirstSelectedModel?.isSencondSelectedModel?.area ?? "")"
                self?.tableView.reloadData()
                
        })
    }
    
    
}

extension OwnerCreateBranchViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OwnerCreateBranchCell.reuseIdentifierStr) as? OwnerCreateBranchCell
        cell?.selectionStyle = .none
        cell?.userModel = userModel
        cell?.model = typeSourceArray[indexPath.row]
        cell?.endEditingMessageCell = { [weak self] (userModel) in
            self?.userModel = userModel
        }
        return cell ?? OwnerCreateBranchCell.init(frame: .zero)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return typeSourceArray.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return OwnerCreateBranchCell.rowHeight()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if typeSourceArray[indexPath.row].type == .OwnerCreteBranchTypeBranchDistrictArea{
            endEdting()
            ///区域商圈选择
            judgeHasData()
        }
    }
}

class OwnerCreateBranchCell: BaseEditCell {
    
    var userModel: OwnerIdentifyUserModel?
    
    var endEditingMessageCell:((OwnerIdentifyUserModel) -> Void)?
    
    override func setDelegate() {
        editLabel.delegate = self
        editLabel.addTarget(self, action: #selector(valueDidChange), for: .editingChanged)
    }
    
    @objc func valueDidChange() {
        let textNum = editLabel.text?.count
        if model.type == .OwnerCreteBranchTypeBranchName{
            //截取
            if textNum! > ownerMaxBranchnameNumber {
                let index = editLabel.text?.index((editLabel.text?.startIndex)!, offsetBy: ownerMaxBranchnameNumber)
                let str = editLabel.text?.substring(to: index!)
                editLabel.text = str
            }
        }else if model.type == .OwnerCreteBranchTypeBranchAddress{
            //截取
            if textNum! > ownerMaxAddressDetailNumber {
                let index = editLabel.text?.index((editLabel.text?.startIndex)!, offsetBy: ownerMaxAddressDetailNumber)
                let str = editLabel.text?.substring(to: index!)
                editLabel.text = str
            }
        }
    }
    
    var model: OwnerCreatBranchConfigureModel = OwnerCreatBranchConfigureModel(types: OwnerCreteBranchType.OwnerCreteBranchTypeBranchName) {
        didSet {
            
            titleLabel.attributedText = model.getNameFormType(type: model.type ?? OwnerCreteBranchType.OwnerCreteBranchTypeBranchName)
            
            detailIcon.isHidden = true
            
            if model.type == .OwnerCreteBranchTypeBranchName{
                editLabel.isUserInteractionEnabled = true
                lineView.isHidden = false
                editLabel.text = userModel?.branchesName
            }else if model.type == .OwnerCreteBranchTypeBranchDistrictArea{
                editLabel.isUserInteractionEnabled = false
                lineView.isHidden = false
                detailIcon.isHidden = false
                editLabel.text = "\(userModel?.districtString ?? "") \(userModel?.businessString ?? "")"
            }else if model.type == .OwnerCreteBranchTypeBranchAddress{
                editLabel.isUserInteractionEnabled = true
                lineView.isHidden = false
                editLabel.text = userModel?.buildingAddress
            }else if model.type == .OwnerCreteBranchTypeUploadYingyePhoto{
                editLabel.isUserInteractionEnabled = false
                lineView.isHidden = true
                editLabel.text = ""
            }
        }
    }
}

extension OwnerCreateBranchCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if model.type == .OwnerCreteBranchTypeBranchName{
            userModel?.branchesName = textField.text
        }else if model.type == .OwnerCreteBranchTypeBranchAddress{
            userModel?.buildingAddress = textField.text
        }
        
        guard let blockk = self.endEditingMessageCell else {
            return
        }
        blockk(userModel ?? OwnerIdentifyUserModel())
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
}

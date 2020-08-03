//
//  OwnerCreateCompanyViewController.swift
//  OfficeGo
//
//  Created by mac on 2020/7/14.
//  Copyright © 2020 Senwei. All rights reserved.
//

import CLImagePickerTool
import Alamofire

class OwnerCreateCompanyViewController: BaseTableViewController {
    
    var yingYeZhiZhaoPhoto: BaseImageView = {
        
        let view = BaseImageView.init(frame: CGRect(x: left_pending_space_17, y: 0, width: kWidth - left_pending_space_17 * 2, height: (kWidth - left_pending_space_17 * 2) * 3 / 4.0))
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.isUserInteractionEnabled = true
        return view
    }()
    let bgimage: UIImageView = {
        let view = BaseImageView.init(frame: CGRect(x: left_pending_space_17, y: 0, width: kWidth - left_pending_space_17 * 2, height: (kWidth - left_pending_space_17 * 2) * 3 / 4.0))
        view.backgroundColor = kAppClearColor
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.image = UIImage.init(named: "uploadAlertBg")
        return view
    }()
        //营业执照
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
    
    var typeSourceArray:[OwnerCreatCompanyConfigureModel] = [OwnerCreatCompanyConfigureModel]()
    
    var companyModel: OwnerIdentifyUserModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        
        setUpData()
    }
    
    func showLeaveAlert() {
        endEdting()
        let alert = SureAlertView(frame: self.view.frame)
        alert.ShowAlertView(withalertType: AlertType.AlertTypeMessageAlert, title: "确认离开吗？", descMsg: "信息尚未提交。点击离开，已编辑信息不保存", cancelButtonCallClick: {
            
        }) { [weak self] in
            
            self?.leftBtnClick()
        }
    }

}


extension OwnerCreateCompanyViewController {
    
    func setUpView() {
        
        titleview = ThorNavigationView.init(type: .backTitleRight)
        titleview?.titleLabel.text = "创建公司"
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
        
        self.tableView.register(OwnerCreateCompanyCell.self, forCellReuseIdentifier: OwnerCreateCompanyCell.reuseIdentifierStr)
        
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
        yingYeZhiZhaoPhoto.addGestureRecognizer(textMessageTap)
        
        let footerview = UIView(frame: CGRect(x: 0, y: 0, width: kWidth, height: (kWidth - left_pending_space_17 * 2) * 3 / 4.0))
        footerview.addSubview(bgimage)
        footerview.addSubview(yingYeZhiZhaoPhoto)
        
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
                imageArr.append(img ?? image)
                self?.mainPicBannermodel?.isLocal = true
                self?.mainPicBannermodel?.image = img
                }, failedClouse: {[weak self] () in
                    self?.mainPicBannermodel?.isLocal = true
                    index = index - 1
                    //                    self?.dealImage(imageArr: imageArr, index: index)
            })
        }
    }

    func setUpData() {
        
        typeSourceArray.append(OwnerCreatCompanyConfigureModel.init(types: .OwnerCreteCompanyTypeCompanyName))
        typeSourceArray.append(OwnerCreatCompanyConfigureModel.init(types: .OwnerCreteCompanyTypeCompanyAddress))
        typeSourceArray.append(OwnerCreatCompanyConfigureModel.init(types: .OwnerCreteCompanyTypeYingyeCode))
        typeSourceArray.append(OwnerCreatCompanyConfigureModel.init(types: .OwnerCreteCompanyTypeUploadYingyePhoto))
        
        if companyModel != nil {
            
        }else {
            companyModel = OwnerIdentifyUserModel()
        }
        
        if mainPicBannermodel != nil {
            
        }else {
            mainPicBannermodel = BannerModel()
            if companyModel?.businessLicense != nil && companyModel?.businessLicense?.isBlankString != true {
                mainPicBannermodel?.isLocal = false
                mainPicBannermodel?.imgUrl = companyModel?.businessLicense
                yingYeZhiZhaoPhoto.setImage(with: mainPicBannermodel?.imgUrl ?? "", placeholder: UIImage.init(named: Default_4x3_large))
            }else {
                mainPicBannermodel?.isLocal = true
            }
        }
        
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
        if UserTool.shared.user_owner_identifytype == 1 {
            NotificationCenter.default.post(name: NSNotification.Name.OwnerCreateCompany, object: companyModel)
            leftBtnClick()
        }else if UserTool.shared.user_owner_identifytype == 2 {
            
            //联合 - 公司名称
            NotificationCenter.default.post(name: NSNotification.Name.OwnerCreateCompany, object: companyModel)
            leftBtnClick()
        }
    }
    
    ///创建公司接口 -
    func requestCreateCompany() {
        
        endEdting()

        if companyModel?.company == nil || companyModel?.company?.isBlankString == true{
            AppUtilities.makeToast("请输入公司名称")
            return
        }
        
        if companyModel?.address == nil || companyModel?.address?.isBlankString == true{
            AppUtilities.makeToast("请输入公司地址")
            return
        }
        
        if companyModel?.creditNo == nil || companyModel?.creditNo?.isBlankString == true{
            AppUtilities.makeToast("请输入营业执照注册号")
            return
            }else if SSTool.isPureStrOrNumNumber(text: companyModel?.creditNo ?? "") != true {
                AppUtilities.makeToast("请输入正确的营业执照注册号")
                return
            }
        if mainPicBannermodel?.isLocal == true {
            if mainPicBannermodel?.image == nil {
                AppUtilities.makeToast("请上传营业执照")
                return
            }
        }
        
        ///获取接口最新数据
        commitRequestDetailGetId()
    }
    
    func commitRequestDetailGetId() {
        
        var params = [String:AnyObject]()
        
        params["token"] = UserTool.shared.user_token as AnyObject?
        
        
        //身份类型0个人认证1企业认证2网点认证
        params["identityType"] = UserTool.shared.user_owner_identifytype as AnyObject?
        
        
        SSNetworkTool.SSOwnerIdentify.request_getSelectIdentityTypeApp(params: params, success: {[weak self] (response) in
            
            guard let weakSelf = self else {return}
            
            if let model = OwnerIdentifyUserModel.deserialize(from: response, designatedPath: "data") {
                
                weakSelf.detailCommitDetailData(model: model)
            }
            
            }, failure: { (error) in
                
                
        }) { (code, message) in
            
        }
    }
    
    func detailCommitDetailData(model: OwnerIdentifyUserModel) {
        
        //企业id用新返回的
        //buildingtempid用新返回的
        //userLicenceIdTemp用新返回的
        
        //building用当前页面自己的
        companyModel?.licenceId = model.licenceId
        companyModel?.buildingTempId = model.buildingTempId
        companyModel?.userLicenceId = model.userLicenceId
        companyModel?.buildingId = model.buildingId
        
        var params = [String:AnyObject]()
        
        params["token"] = UserTool.shared.user_token as AnyObject?
        
        //身份类型0个人认证1企业认证2网点认证
        params["identityType"] = UserTool.shared.user_owner_identifytype as AnyObject?
        
        //1提交认证2企业确认3网点楼盘创建确认
        params["createCompany"] = 2 as AnyObject?
        
        ///企业关系id
        if companyModel?.userLicenceId != "0" || companyModel?.userLicenceId?.isBlankString != true {
            params["userLicenceId"] = companyModel?.userLicenceId as AnyObject?
        }
        
        ///企业id
        if companyModel?.licenceId  != "0" || companyModel?.licenceId?.isBlankString != true {
            params["licenceId"] = companyModel?.licenceId as AnyObject?
        }
        
        ///关联楼id
        if companyModel?.buildingId  != "0" || companyModel?.buildingId?.isBlankString != true {
            params["buildingId"] = companyModel?.buildingId as AnyObject?
        }
        ///关联楼id
        if companyModel?.buildingTempId  != "0" || companyModel?.buildingTempId?.isBlankString != true {
            params["buildingTempId"] = companyModel?.buildingTempId as AnyObject?
        }
        
        params["company"] = companyModel?.company as AnyObject?
        
        params["address"] = companyModel?.address as AnyObject?
        
        params["creditNo"] = companyModel?.creditNo as AnyObject?
        
        //params["fileBusinessLicense"] = UserTool.shared.user_owner_identifytype as AnyObject?
        
        var imgArr: [UIImage] = []
        
        if mainPicBannermodel?.isLocal == false {
            imgArr.append(mainPicBannermodel?.image ?? UIImage())
        }
        
        SSNetworkTool.SSOwnerIdentify.request_createCompanyApp(params: params, imagesArray: imgArr, success: {[weak self] (response) in
            
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

extension OwnerCreateCompanyViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OwnerCreateCompanyCell.reuseIdentifierStr) as? OwnerCreateCompanyCell
        cell?.selectionStyle = .none
        cell?.companyModel = companyModel
        cell?.model = typeSourceArray[indexPath.row]
        cell?.endEditingMessageCell = { [weak self] (companyModel) in
            self?.companyModel = companyModel
            self?.companyModel?.company = companyModel.company
            self?.companyModel?.address = companyModel.address
        }
        return cell ?? OwnerCreateCompanyCell.init(frame: .zero)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return typeSourceArray.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return OwnerCreateCompanyCell.rowHeight()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}


class OwnerCreateCompanyCell: BaseEditCell {
    
    var companyModel: OwnerIdentifyUserModel?
    
    var endEditingMessageCell:((OwnerIdentifyUserModel) -> Void)?
    
    override func setDelegate() {
        editLabel.delegate = self
        editLabel.addTarget(self, action: #selector(valueDidChange), for: .editingChanged)
    }
    
    @objc func valueDidChange() {
        let textNum = editLabel.text?.count
          
        if model.type == .OwnerCreteCompanyTypeCompanyName{
            //截取
            if textNum! > ownerMaxCompanynameNumber {
                let index = editLabel.text?.index((editLabel.text?.startIndex)!, offsetBy: ownerMaxCompanynameNumber)
                let str = editLabel.text?.substring(to: index!)
                editLabel.text = str
            }
        }else if model.type == .OwnerCreteCompanyTypeCompanyAddress{
            //截取
            if textNum! > ownerMaxAddressDetailNumber {
                let index = editLabel.text?.index((editLabel.text?.startIndex)!, offsetBy: ownerMaxAddressDetailNumber)
                let str = editLabel.text?.substring(to: index!)
                editLabel.text = str
            }
        }else if model.type == .OwnerCreteCompanyTypeYingyeCode{
            //截取
            if textNum! > ownerMaxCompanyYingyezhizhaoNumber {
                let index = editLabel.text?.index((editLabel.text?.startIndex)!, offsetBy: ownerMaxCompanyYingyezhizhaoNumber)
                let str = editLabel.text?.substring(to: index!)
                editLabel.text = str
            }
        }
    }
    
    var model: OwnerCreatCompanyConfigureModel = OwnerCreatCompanyConfigureModel(types: OwnerCreteCompanyType.OwnerCreteCompanyTypeIedntify) {
        didSet {
            
            titleLabel.attributedText = model.getNameFormType(type: model.type ?? OwnerCreteCompanyType.OwnerCreteCompanyTypeIedntify)
            editLabel.keyboardType = .default

            detailIcon.isHidden = true
            
            if model.type == .OwnerCreteCompanyTypeCompanyName{
                editLabel.isUserInteractionEnabled = true
                lineView.isHidden = false
                editLabel.text = companyModel?.company
            }else if model.type == .OwnerCreteCompanyTypeCompanyAddress{
                editLabel.isUserInteractionEnabled = true
                lineView.isHidden = false
                editLabel.text = companyModel?.address
            }else if model.type == .OwnerCreteCompanyTypeYingyeCode {
                editLabel.keyboardType = .emailAddress
                editLabel.isUserInteractionEnabled = true
                lineView.isHidden = false
                editLabel.text = companyModel?.creditNo
            }else if model.type == .OwnerCreteCompanyTypeUploadYingyePhoto{
                editLabel.isUserInteractionEnabled = false
                lineView.isHidden = true
                editLabel.text = ""
            }
        }
    }
}

extension OwnerCreateCompanyCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if model.type == .OwnerCreteCompanyTypeCompanyName{
            companyModel?.company = textField.text
        }else if model.type == .OwnerCreteCompanyTypeCompanyAddress{
            companyModel?.address = textField.text
        }else if model.type == .OwnerCreteCompanyTypeYingyeCode{
            companyModel?.creditNo = textField.text
        }
        guard let blockk = self.endEditingMessageCell else {
            return
        }
        blockk(companyModel ?? OwnerIdentifyUserModel())
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
}



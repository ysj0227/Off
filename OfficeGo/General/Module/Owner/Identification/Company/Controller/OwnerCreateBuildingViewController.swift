//
//  OwnerCreateBuildingViewController.swift
//  OfficeGo
//
//  Created by mac on 2020/7/17.
//  Copyright © 2020 Senwei. All rights reserved.
//

import CLImagePickerTool
import Alamofire
import HandyJSON
import SwiftyJSON

class OwnerCreateBuildingViewController: BaseTableViewController {
        
    var areaModelCount: CityAreaCategorySelectModel?
    
    var mainPicPhoto: BaseImageView = {
        
        let view = BaseImageView.init(frame: CGRect(x: left_pending_space_17, y: 20, width: (kWidth - left_pending_space_17 * 4) / 3.0 - 1, height: (kWidth - left_pending_space_17 * 4) / 3.0 - 1))
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.image = UIImage.init(named: "addImgBg")
        view.isUserInteractionEnabled = true
        let control = UIButton(frame: CGRect(x: 0, y: 0, width: (kWidth - left_pending_space_17 * 4) / 3.0 - 1, height: (kWidth - left_pending_space_17 * 4) / 3.0 - 1))
        control.addTarget(self, action: #selector(pickerSelect), for: .touchUpInside)
        view.addSubview(control)
        return view
    }()
        
    lazy var bottomBtnView: BottomBtnView = {
        let view = BottomBtnView.init(frame: CGRect(x: 0, y: 0, width: kWidth, height: 50))
        view.bottomType = BottomBtnViewType.BottomBtnViewTypeIwantToFind
        view.rightSelectBtn.setTitle("确认创建", for: .normal)
        view.backgroundColor = kAppWhiteColor
        return view
    }()
    
    lazy var descLabel : UILabel = {
        let view = UILabel(frame: CGRect(x: left_pending_space_17, y: -10, width: kWidth - left_pending_space_17, height: 20))
        view.font = FONT_13
        view.text = "请上传楼盘外立面照片"
        view.textColor = kAppColor_btnGray_BEBEBE
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
    
    var typeSourceArray:[OwnerCreatBuildingConfigureModel] = [OwnerCreatBuildingConfigureModel]()
    
    var userModel: OwnerIdentifyUserModel?
    
    
    lazy var areaView: CityDistrictAddressSelectView = {
        let view = CityDistrictAddressSelectView.init(frame: CGRect(x: 0, y: kNavigationHeight + cell_height_58 * 3, width: kWidth, height: kHeight - kNavigationHeight - cell_height_58 * 3 - bottomMargin()))
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
        
        if userModel?.buildingName == nil || userModel?.buildingName?.isBlankString == true{
            AppUtilities.makeToast("请输入楼盘/网点")
            return
        }
        
        if userModel?.btype == nil || userModel?.btype?.isBlankString == true{
            AppUtilities.makeToast("请选择类型")
            return
        }
        
        
        if areaModelCount?.isFirstSelectedModel?.districtID == nil || areaModelCount?.isFirstSelectedModel?.districtID?.isBlankString == true{
            AppUtilities.makeToast("请选择所在区域")
            return
        }
        
        if userModel?.address == nil || userModel?.address?.isBlankString == true{
            AppUtilities.makeToast("请输入详细地址")
            return
        }
        if userModel?.mainPicBannermodel?.imgUrl == nil || userModel?.mainPicBannermodel?.imgUrl?.isBlankString == true{
            AppUtilities.makeToast("请上传封面图")
            return
        }
        
        addNotify()
    }
}


extension OwnerCreateBuildingViewController {
    
    func setUpView() {
        
        titleview = ThorNavigationView.init(type: .backTitleRight)
        titleview?.titleLabel.text = "创建楼盘/网点"
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
        
        self.tableView.register(OwnerCreateBuildingCell.self, forCellReuseIdentifier: OwnerCreateBuildingCell.reuseIdentifierStr)
        self.tableView.register(OwnerCreateBuildTypeSelectCell.self, forCellReuseIdentifier: OwnerCreateBuildTypeSelectCell.reuseIdentifierStr)
        
        self.view.addSubview(bottomBtnView)
        
        bottomBtnView.rightBtnClickBlock = { [weak self] in
            self?.requestCreateCompany()
        }
        bottomBtnView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-bottomMargin())
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        
        let footerview = UIView(frame: CGRect(x: 0, y: 0, width: kWidth, height: (kWidth - left_pending_space_17 * 4) / 3.0 - 1 + 20))
        footerview.addSubview(descLabel)
        footerview.addSubview(mainPicPhoto)
        
        self.tableView.tableFooterView = footerview
    }
    
    @objc func pickerSelect() {
        imagePickTool.cl_setupImagePickerWith(MaxImagesCount: 2, superVC: self) {[weak self] (asset,cutImage) in
            SSLog("返回的asset数组是\(asset)")
            
            var index = asset.count // 标记失败的次数
            
            // 获取原图，异步
            // scale 指定压缩比
            // 内部提供的方法可以异步获取图片，同步获取的话时间比较长，不建议！，如果是iCloud中的照片就直接从icloud中下载，下载完成后返回图片,同时也提供了下载失败的方法
            CLImagePickerTool.convertAssetArrToOriginImage(assetArr: asset, scale: 0.1, successClouse: {[weak self] (image,assetItem) in
                let img = image.resizeMax1500Image()

                self?.userModel?.mainPicBannermodel?.isLocal = true
                self?.userModel?.mainPicBannermodel?.image = img
                self?.mainPicPhoto.image = image
                self?.uploadImg(img: img ?? UIImage())
                }, failedClouse: {[weak self] () in
                    self?.userModel?.mainPicBannermodel?.isLocal = true
                    index = index - 1
            })
        }
    }

    func uploadImg(img: UIImage) {
        
        var params = [String:AnyObject]()
        params["token"] = UserTool.shared.user_token as AnyObject?
        
        ///1楼图片2视频3房源图片
        params["filedirType"] = UploadImgOrVideoEnum.buildingImage.rawValue as AnyObject?

        
        SSNetworkTool.SSFYManager.request_uploadResourcesUrl(params: params, imagesArray: [img], success: {[weak self] (response) in
            guard let weakSelf = self else {return}
            if let decoratedArray = JSONDeserializer<BannerModel>.deserializeModelArrayFrom(json: JSON(response["data"] ?? "").rawString() ?? "", designatedPath: "urls") {
                
                if decoratedArray.count >= 1 {
                    weakSelf.userModel?.mainPicBannermodel?.isLocal = false
                    weakSelf.userModel?.mainPicBannermodel?.imgUrl = decoratedArray[0]?.url
                }
            }
            }, failure: { (error) in
                
        }) { (code, message) in

            
            //只有5000 提示给用户
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" {
                AppUtilities.makeToast(message)
            }
        }
    }
    func setUpData() {
        
        typeSourceArray.append(OwnerCreatBuildingConfigureModel.init(types: .OwnerCreteBuildingTypeBranchName))
        typeSourceArray.append(OwnerCreatBuildingConfigureModel.init(types: .OwnerCreteBuildingTypeBuildOrJint))
        typeSourceArray.append(OwnerCreatBuildingConfigureModel.init(types: .OwnerCreteBuildingTypeBranchDistrictArea))
        typeSourceArray.append(OwnerCreatBuildingConfigureModel.init(types: .OwnerCreteBuildingTypeBranchAddress))
        typeSourceArray.append(OwnerCreatBuildingConfigureModel.init(types: .OwnerCreteBuildingTypeUploadYingyePhoto))
        
        setData()
        loadTableview()
    }
    
    func setData() {
        if userModel != nil {
            if userModel?.mainPicBannermodel != nil {
                if userModel?.mainPicBannermodel?.imgUrl?.count ?? 0 > 0 {
                    mainPicPhoto.setImage(with: userModel?.mainPicBannermodel?.imgUrl ?? "", placeholder: UIImage.init(named: Default_4x3_large))
                }
            }else {
                userModel?.mainPicBannermodel = BannerModel()
            }
            
        }else {
            userModel = OwnerIdentifyUserModel()
            userModel?.mainPicBannermodel = BannerModel()
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
        NotificationCenter.default.post(name: NSNotification.Name.OwnerCreateBuilding, object: userModel)
        self.leftBtnClick()
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
                model.name = "上海市"
                self?.areaModelCount = model
                self?.getSelectedDistrictBusiness()
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
            if model.districtID == userModel?.districtId
            {
                areaModelCount?.isFirstSelectedModel = model
                userModel?.districtIdName = "\(areaModelCount?.name ?? "上海市")\(model.district ?? "")"
                areaModelCount?.isFirstSelectedModel?.list.forEach({ (areaModel) in
                    if areaModel.id == userModel?.businessDistrict {
                        areaModelCount?.isFirstSelectedModel?.isSencondSelectedModel = areaModel
                        userModel?.businessDistrictName = areaModel.area
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
                self?.userModel?.districtId = selectModel.isFirstSelectedModel?.districtID
                self?.userModel?.businessDistrict = selectModel.isFirstSelectedModel?.isSencondSelectedModel?.id
                self?.userModel?.districtIdName = "\(selectModel.name ?? "上海市")\(selectModel.isFirstSelectedModel?.district ?? "")"
                self?.userModel?.businessDistrictName = "\(selectModel.isFirstSelectedModel?.isSencondSelectedModel?.area ?? "")"
                self?.tableView.reloadData()
                
        })
    }
    
    
}

extension OwnerCreateBuildingViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if typeSourceArray[indexPath.row].type == .OwnerCreteBuildingTypeBuildOrJint {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: OwnerCreateBuildTypeSelectCell.reuseIdentifierStr) as? OwnerCreateBuildTypeSelectCell
            cell?.selectionStyle = .none
            cell?.userModel = userModel
            cell?.model = typeSourceArray[indexPath.row]
//            cell?.editClickBack = { [weak self] (userModel) in
//                self?.userModel = userModel
//            }
            return cell ?? OwnerCreateBuildTypeSelectCell.init(frame: .zero)
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: OwnerCreateBuildingCell.reuseIdentifierStr) as? OwnerCreateBuildingCell
            cell?.selectionStyle = .none
            cell?.userModel = userModel
            cell?.model = typeSourceArray[indexPath.row]
            cell?.endEditingMessageCell = { [weak self] (userModel) in
                self?.userModel = userModel
            }
            return cell ?? OwnerCreateBuildingCell.init(frame: .zero)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return typeSourceArray.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return OwnerCreateBuildingCell.rowHeight()
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if typeSourceArray[indexPath.row].type == .OwnerCreteBuildingTypeBranchDistrictArea{
            if userModel?.buildingId != nil {
                endEdting()
                ///区域商圈选择
                judgeHasData()
            }else {

                endEdting()
                ///区域商圈选择
                judgeHasData()
            }
        }
    }
}

class OwnerCreateBuildingCell: BaseEditCell {
    
    var userModel: OwnerIdentifyUserModel?
    
    var endEditingMessageCell:((OwnerIdentifyUserModel) -> Void)?
    
    override func setDelegate() {
        editLabel.delegate = self
        editLabel.addTarget(self, action: #selector(valueDidChange), for: .editingChanged)
    }
    @objc func valueDidChange() {
        let textNum = editLabel.text?.count
        if model.type == .OwnerCreteBuildingTypeBranchName{
            //截取
            if textNum! > ownerMaxBuildingnameNumber_20 {
                let index = editLabel.text?.index((editLabel.text?.startIndex)!, offsetBy: ownerMaxBuildingnameNumber_20)
                let str = editLabel.text?.substring(to: index!)
                editLabel.text = str
            }
        }else if model.type == .OwnerCreteBuildingTypeBranchAddress{
            //截取
            if textNum! > ownerMaxAddressDetailNumber_30 {
                let index = editLabel.text?.index((editLabel.text?.startIndex)!, offsetBy: ownerMaxAddressDetailNumber_30)
                let str = editLabel.text?.substring(to: index!)
                editLabel.text = str
            }
        }
    }
    
    var model: OwnerCreatBuildingConfigureModel = OwnerCreatBuildingConfigureModel(types: OwnerCreteBuildingType.OwnerCreteBuildingTypeBranchName) {
        didSet {
            
            titleLabel.attributedText = model.getNameFormType(type: model.type ?? OwnerCreteBuildingType.OwnerCreteBuildingTypeBranchName)
            editLabel.placeholder = model.getDescFormType(type: model.type ?? OwnerCreteBuildingType.OwnerCreteBuildingTypeBranchName)
            
            detailIcon.isHidden = true
            
            if model.type == .OwnerCreteBuildingTypeBranchName{
                editLabel.isUserInteractionEnabled = true
                lineView.isHidden = false
                editLabel.text = userModel?.buildingName
            }else if model.type == .OwnerCreteBuildingTypeBranchDistrictArea{
                editLabel.isUserInteractionEnabled = false
                lineView.isHidden = false
                detailIcon.isHidden = false
                editLabel.text = "\(userModel?.districtIdName ?? "")\(userModel?.businessDistrictName ?? "")"
            }else if model.type == .OwnerCreteBuildingTypeBranchAddress{
                editLabel.isUserInteractionEnabled = true
                lineView.isHidden = false
                editLabel.text = userModel?.address
            }else if model.type == .OwnerCreteBuildingTypeUploadYingyePhoto{
                editLabel.isUserInteractionEnabled = false
                lineView.isHidden = true
                editLabel.text = ""
            }
        }
    }
    
    ///房源管理 -
    var FYBuildingCreatAddmodel: OwnerBuildingJointCreatAddConfigureModel = OwnerBuildingJointCreatAddConfigureModel(types: OwnerBuildingCreteAddType.OwnerBuildingCreteAddTypeBuildingName) {
        didSet {
            
            
            titleLabel.attributedText = FYBuildingCreatAddmodel.getNameFormType(type: FYBuildingCreatAddmodel.type ?? OwnerBuildingCreteAddType.OwnerBuildingCreteAddTypeBuildingName)
            
            detailIcon.isHidden = true
            
            if FYBuildingCreatAddmodel.type == .OwnerBuildingCreteAddTypeBuildingName{
                editLabel.isUserInteractionEnabled = true
                lineView.isHidden = false
                editLabel.text = userModel?.buildingName
            }else if FYBuildingCreatAddmodel.type == .OwnerBuildingCreteAddTypeBuildingDistrictArea{
                editLabel.isUserInteractionEnabled = false
                lineView.isHidden = false
                detailIcon.isHidden = false
                editLabel.text = "\(userModel?.districtIdName ?? "")\(userModel?.businessDistrictName ?? "")"
            }else if FYBuildingCreatAddmodel.type == .OwnerBuildingCreteAddTypeBuildingAddress{
                
                if userModel?.buildingId != nil {

                    editLabel.isUserInteractionEnabled = false
                    lineView.isHidden = false
                    editLabel.text = userModel?.address
                }else {

                    editLabel.isUserInteractionEnabled = true
                    lineView.isHidden = false
                    editLabel.text = userModel?.address
                }
            }else {
                editLabel.isUserInteractionEnabled = false
                lineView.isHidden = true
                editLabel.text = ""
            }
        }
    }
}

extension OwnerCreateBuildingCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if model.type == .OwnerCreteBuildingTypeBranchName{
            userModel?.buildingName = textField.text
        }else if model.type == .OwnerCreteBuildingTypeBranchAddress{
            userModel?.address = textField.text
        }
        
        guard let blockk = self.endEditingMessageCell else {
            return
        }
        blockk(userModel ?? OwnerIdentifyUserModel())
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
}


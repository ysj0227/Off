//
//  OwnerEnterCreatedCompanyViewController.swift
//  OfficeGo
//
//  Created by mac on 2020/8/5.
//  Copyright © 2020 Senwei. All rights reserved.
//

import CLImagePickerTool
import Alamofire

class OwnerEnterCreatedCompanyViewController: BaseTableViewController {
    
    var yingYeZhiZhaoPhoto: BaseImageView = {
        
        let view = BaseImageView.init(frame: CGRect(x: left_pending_space_17, y: 73, width: kWidth - left_pending_space_17 * 2, height: (kWidth - left_pending_space_17 * 2) * 3 / 4.0))
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.isUserInteractionEnabled = true
        return view
    }()
    let bgimage: UIImageView = {
        let view = BaseImageView.init(frame: CGRect(x: left_pending_space_17, y: 73, width: kWidth - left_pending_space_17 * 2, height: (kWidth - left_pending_space_17 * 2) * 3 / 4.0))
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
        view.rightSelectBtn.setTitle("确认加入", for: .normal)
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


extension OwnerEnterCreatedCompanyViewController {
    
    func setUpView() {
        
        titleview = ThorNavigationView.init(type: .backTitleRight)
        titleview?.titleLabel.text = "加入公司"
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
        
        self.tableView.register(OwnerEnterCreateCompanyCell.self, forCellReuseIdentifier: OwnerEnterCreateCompanyCell.reuseIdentifierStr)
        
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
        
        
        let view = UILabel(frame: CGRect(x: left_pending_space_17, y: 5, width: kWidth - left_pending_space_17 * 2, height: 34))
        view.textAlignment = .left
        view.font = FONT_15
        view.setContentCompressionResistancePriority(.required, for: .horizontal)
        view.textColor = kAppColor_999999
        view.attributedText = FuWenBen(name: "上传营业执照", centerStr: " * ", last: "")

        
        let descview = UILabel(frame: CGRect(x: left_pending_space_17, y: 34, width: kWidth - left_pending_space_17 * 2, height: 20))
        descview.font = FONT_12
        descview.textColor = kAppColor_999999
        descview.text = "请确保所上传的营业执照与公司信息一致"
        
        let footerview = UIView(frame: CGRect(x: 0, y: 0, width: kWidth, height: 73 + (kWidth - left_pending_space_17 * 2) * 3 / 4.0))
        footerview.addSubview(bgimage)
        footerview.addSubview(view)
        footerview.addSubview(descview)
        footerview.addSubview(yingYeZhiZhaoPhoto)

        self.tableView.tableFooterView = footerview
    }
    
    
    //centerStr *
    func FuWenBen(name: String, centerStr: String, last: String) -> NSMutableAttributedString {
        
        //定义富文本即有格式的字符串
        let attributedStrM : NSMutableAttributedString = NSMutableAttributedString()
        
        if name.count > 0 {
            let nameAtt = NSAttributedString.init(string: name, attributes: [NSAttributedString.Key.backgroundColor : kAppWhiteColor , NSAttributedString.Key.foregroundColor : kAppColor_999999 , NSAttributedString.Key.font : FONT_14])
            attributedStrM.append(nameAtt)
            
        }
        
        if centerStr.count > 0 {
            //*
            let xingxing = NSAttributedString.init(string: centerStr, attributes: [NSAttributedString.Key.backgroundColor : kAppWhiteColor , NSAttributedString.Key.foregroundColor : kAppRedColor , NSAttributedString.Key.font : FONT_18])
            
            attributedStrM.append(xingxing)
            
        }
        
        if last.count > 0 {
            let lastAtt = NSAttributedString.init(string: last, attributes: [NSAttributedString.Key.backgroundColor : kAppWhiteColor , NSAttributedString.Key.foregroundColor : kAppColor_999999 , NSAttributedString.Key.font : FONT_14])
            attributedStrM.append(lastAtt)
            
        }
        
        return attributedStrM
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
                self?.yingYeZhiZhaoPhoto.image = img
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
        
        if companyModel != nil {
//            companyModel?.creditNo = "1234 5678 97654 32XX1 2345 wewewewew 234567"
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
            NotificationCenter.default.post(name: NSNotification.Name.OwnerCreateCompany, object: nil)
            leftBtnClick()
        }else if UserTool.shared.user_owner_identifytype == 2 {
            
            //联合 - 公司名称
            NotificationCenter.default.post(name: NSNotification.Name.OwnerCreateCompany, object: nil)
            leftBtnClick()
        }
    }
    
    ///创建公司接口 -
    func requestCreateCompany() {
  
        if mainPicBannermodel?.isLocal == true {
            if mainPicBannermodel?.image == nil {
                AppUtilities.makeToast("请上传营业执照")
                return
            }
        }
        
        ///提交
        detailCommitDetailData()
    }
        
    func detailCommitDetailData() {
                
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
        
        if mainPicBannermodel?.isLocal == true {
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

extension OwnerEnterCreatedCompanyViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OwnerEnterCreateCompanyCell.reuseIdentifierStr) as? OwnerEnterCreateCompanyCell
        cell?.selectionStyle = .none
        cell?.companyModel = companyModel
        cell?.model = typeSourceArray[indexPath.row]
        
        return cell ?? OwnerEnterCreateCompanyCell.init(frame: .zero)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return typeSourceArray.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if typeSourceArray[indexPath.row].type == .OwnerCreteCompanyTypeCompanyName{
            return 48
        }else if typeSourceArray[indexPath.row].type == .OwnerCreteCompanyTypeCompanyAddress{
            if companyModel?.address?.count ?? 0 > 0 {
                return 48
            }else {
                return 0
            }
        }else if typeSourceArray[indexPath.row].type == .OwnerCreteCompanyTypeYingyeCode {
            if companyModel?.creditNo?.count ?? 0 > 0 {
                return 48
            }else {
                return 1
            }
        }
        return OwnerEnterCreateCompanyCell.rowHeight()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

class OwnerEnterCreateCompanyCell : BaseTableViewCell {
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_15
        view.setContentCompressionResistancePriority(.required, for: .horizontal)
        view.textColor = kAppColor_999999
        return view
    }()
    
    lazy var editLabel: UITextField = {
        let view = UITextField()
        view.textAlignment = .left
        view.font = FONT_15
        view.textColor = kAppColor_333333
        view.clearButtonMode = .whileEditing
        return view
    }()
    
    lazy var detailIcon: BaseImageView = {
        let view = BaseImageView.init()
        view.image = UIImage.init(named: "moreDetail")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = kAppColor_line_EEEEEE
        return view
    }()
       
    lazy var addressIcon: BaseImageView = {
        let view = BaseImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage.init(named:"locationGray")
        return view
    }()
    
    var companyModel: OwnerIdentifyUserModel?

    var model: OwnerCreatCompanyConfigureModel = OwnerCreatCompanyConfigureModel(types: OwnerCreteCompanyType.OwnerCreteCompanyTypeIedntify) {
        didSet {
            detailIcon.isHidden = true
            titleLabel.isHidden = true
            editLabel.isUserInteractionEnabled = false
            if model.type == .OwnerCreteCompanyTypeCompanyName{
                addressIcon.image = UIImage.init(named:"")
                addressIcon.isHidden = true
                addressIcon.snp.remakeConstraints { (make) in
                    make.centerY.equalToSuperview()
                    make.height.equalTo(20)
                    make.leading.equalTo(left_pending_space_17)
                    make.width.equalTo(0)
                }
                
                lineView.isHidden = true
                editLabel.font = FONT_15
                editLabel.textColor = kAppColor_333333
                editLabel.text = companyModel?.company
            }else if model.type == .OwnerCreteCompanyTypeCompanyAddress{
                addressIcon.image = UIImage.init(named:"locationGray")
                addressIcon.snp.remakeConstraints { (make) in
                    make.centerY.equalToSuperview()
                    make.height.equalTo(20)
                    make.leading.equalTo(left_pending_space_17)
                    make.width.equalTo(15)
                }
                if companyModel?.address?.count ?? 0 > 0 {
                    addressIcon.isHidden = false
                }else {
                    addressIcon.isHidden = true
                }
                
                lineView.isHidden = true
                editLabel.font = FONT_LIGHT_13
                editLabel.textColor = kAppColor_333333
                editLabel.text = companyModel?.address
            }else if model.type == .OwnerCreteCompanyTypeYingyeCode {
                addressIcon.image = UIImage.init(named:"")
                addressIcon.isHidden = true
                addressIcon.snp.remakeConstraints { (make) in
                    make.centerY.equalToSuperview()
                    make.height.equalTo(20)
                    make.leading.equalTo(left_pending_space_17)
                    make.width.equalTo(0)
                }
                
                lineView.isHidden = false
                editLabel.font = FONT_LIGHT_13
                editLabel.textColor = kAppColor_333333
                if let creditNo = companyModel?.creditNo {
                    if creditNo.count > 0 {
                        editLabel.text = "统一社会信用代码：" + creditNo
                    }else {
                        editLabel.text = ""
                    }
                }else {
                    editLabel.text = ""
                }
            }else if model.type == .OwnerCreteCompanyTypeUploadYingyePhoto{
                editLabel.text = ""
            }
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    class func rowHeight() -> CGFloat {
        return cell_height_58
    }
    
    func setDelegate() {
        
    }
    
    func setupViews() {
        
        setDelegate()
        
        addSubview(addressIcon)
        addSubview(titleLabel)
        addSubview(editLabel)
        addSubview(detailIcon)
        addSubview(lineView)
        
        addressIcon.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.height.equalTo(20)
            make.leading.equalTo(left_pending_space_17)
            make.width.equalTo(0)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(addressIcon.snp.trailing)
            make.centerY.equalToSuperview()
        }
        
        editLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(-(left_pending_space_17 + 10))
            make.leading.equalTo(titleLabel.snp.trailing)
            make.top.bottom.equalToSuperview()
        }
        
        detailIcon.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-left_pending_space_17)
            make.centerY.equalToSuperview()
            make.width.equalTo(10)
        }
        lineView.snp.makeConstraints { (make) in
            make.leading.equalTo(left_pending_space_17)
            make.trailing.equalTo(-left_pending_space_17)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}


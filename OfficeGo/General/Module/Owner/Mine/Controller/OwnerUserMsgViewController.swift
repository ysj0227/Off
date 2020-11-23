//
//  OwnerUserMsgViewController.swift
//  OfficeGo
//
//  Created by mac on 2020/6/19.
//  Copyright © 2020 Senwei. All rights reserved.
//

import CLImagePickerTool
import Alamofire

class OwnerUserMsgViewController: BaseTableViewController {
    
    var selectedAvatarData: NSData?
    
    var userModel: LoginUserModel? {
        didSet {
            
            ///设置下面的按钮的状态
            if userModel?.nickname?.isBlankString == true || userModel?.sex?.isBlankString == true || userModel?.phone?.isBlankString == true  {
                bottomBtnView.rightSelectBtn.isUserInteractionEnabled = false
                bottomBtnView.rightSelectBtn.backgroundColor = kAppColor_btnGray_BEBEBE
            }else {
                bottomBtnView.rightSelectBtn.isUserInteractionEnabled = true
                bottomBtnView.rightSelectBtn.backgroundColor = kAppBlueColor
            }
        }
    }
    
    lazy var bottomBtnView: BottomBtnView = {
        let view = BottomBtnView.init(frame: CGRect(x: 0, y: 0, width: kWidth, height: 50))
        view.bottomType = BottomBtnViewType.BottomBtnViewTypeIwantToFind
        view.rightSelectBtn.setTitle("保存", for: .normal)
        view.backgroundColor = kAppWhiteColor
        view.rightSelectBtn.isUserInteractionEnabled = false
        view.rightSelectBtn.backgroundColor = kAppColor_btnGray_BEBEBE
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
    
    var headerView: RenterAvatarUploadHeaderView = {
        let view = RenterAvatarUploadHeaderView.init(frame: CGRect(x: 0, y: 0, width: kWidth, height: 80))
        return view
    }()
    
    var typeSourceArray:[UserMsgConfigureModel] = [UserMsgConfigureModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        
        setUpData()
    }
    
}


extension OwnerUserMsgViewController {
    
    func setUpView() {
        
        titleview = ThorNavigationView.init(type: .backTitleRight)
        titleview?.titleLabel.text = "基本信息"
        titleview?.rightButton.isHidden = true
        titleview?.leftButtonCallBack = { [weak self] in
            self?.leftBtnClick()
        }
        
        self.view.addSubview(titleview ?? ThorNavigationView.init(type: .backTitleRight))
        
        self.tableView.snp.remakeConstraints { (make) in
            make.top.equalTo(kNavigationHeight)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-kStatusBarHeight)
        }
        
        self.tableView.tableHeaderView = headerView
        
        //头像点击按钮-选择图片
        headerView.headerBtnClickBlock = { [weak self] in
            self?.pickerSelect()
        }
        
        self.tableView.register(OwnerMineUserMsgCell.self, forCellReuseIdentifier: OwnerMineUserMsgCell.reuseIdentifierStr)
        
        self.view.addSubview(bottomBtnView)
        bottomBtnView.rightBtnClickBlock = { [weak self] in
            self?.requestEditUserMessage()
            
        }
        bottomBtnView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-bottomMargin())
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
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
                imageArr.append(image)
                self?.dealImage(imageArr: imageArr, index: index)
                }, failedClouse: { () in
                    index = index - 1
                    //                    self?.dealImage(imageArr: imageArr, index: index)
            })
        }
    }
    @objc func dealImage(imageArr:[UIImage],index:Int) {
        
        if imageArr.count == index {
            //              PopViewUtil.share.stopLoading()
            
        }
        let image = imageArr.count > 0 ? imageArr[0] : UIImage.init(named: "avatar")
        let image2 = image?.crop(ratio: 1)
        
        self.headerView.headerImg.image = image2
        self.upload(uploadImage: image2 ?? UIImage.init())
    }
    func setUpData() {
        
        //设置头像
        headerView.userModel = userModel
        
        typeSourceArray.append(UserMsgConfigureModel.init(types: .RenterUserMsgTypeNick))
        typeSourceArray.append(UserMsgConfigureModel.init(types: .RenterUserMsgTypeSex))
        typeSourceArray.append(UserMsgConfigureModel.init(types: .RenterUserMsgTypeCompany))
        typeSourceArray.append(UserMsgConfigureModel.init(types: .RenterUserMsgTypeJob))
        typeSourceArray.append(UserMsgConfigureModel.init(types: .RenterUserMsgTypeWechat))
        
        self.tableView.reloadData()
    }
    
    private func upload(uploadImage:UIImage) {
        
        SSNetworkTool.SSMine.request_uploadAvatar(image: uploadImage, success: {[weak self] (response) in
            
            if let model = LoginModel.deserialize(from: response, designatedPath: "data") {
                UserTool.shared.user_avatars = model.avatar
                AppUtilities.makeToast("头像已修改")
            }
            }, failure: { (error) in
                
        }) { (code, message) in
            
            //只有5000 提示给用户
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" {
                AppUtilities.makeToast(message)
            }
        }
        
    }
    
    func setSureBtnEnable(can: Bool) {
        self.bottomBtnView.rightSelectBtn.isUserInteractionEnabled = can
    }
    
    func updateSuccess() {
        
        AppUtilities.makeToast("个人信息已更新")
        
        SSTool.delay(time: 2) {[weak self] in
            
            self?.leftBtnClick()
            
            self?.setSureBtnEnable(can: true)
            
        }
    }
    
    func requestEditUserMessage() {
        
        self.tableView.endEditing(true)
        
        if userModel?.nickname?.isBlankString == true {
            AppUtilities.makeToast("请输入姓名")
            return
        }
        
        if userModel?.sex == "1" || userModel?.sex == "0" {
            
        }else {
            AppUtilities.makeToast("请选择性别")
            return
        }
        
        setSureBtnEnable(can: false)
        
        var params = [String:AnyObject]()
        params["nickname"] = userModel?.nickname as AnyObject?
        params["sex"] = userModel?.sex as AnyObject?
        params["token"] = UserTool.shared.user_token as AnyObject?
        
        /*
         if let wxid = userModel?.wxId {
         if wxid.isBlankString != true {
         params["WX"] = wxid as AnyObject?
         }
         }
         
         if let wxid = userModel?.company {
         if wxid.isBlankString != true {
         params["company"] = wxid as AnyObject?
         }
         }
         if let wxid = userModel?.job {
         if wxid.isBlankString != true {
         params["job"] = wxid as AnyObject?
         }
         }*/
        
        params["wxId"] = userModel?.wxId as AnyObject?
        params["company"] = userModel?.company as AnyObject?
        params["job"] = userModel?.job as AnyObject?
        
        SSNetworkTool.SSMine.request_updateUserMessage(params: params, success: {[weak self] (response) in
            
            self?.updateSuccess()
            
            }, failure: {[weak self] (error) in
                self?.setSureBtnEnable(can: true)
                
        }) {[weak self] (code, message) in
            
            //只有5000 提示给用户
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" {
                AppUtilities.makeToast(message)
            }
            self?.setSureBtnEnable(can: true)
            
        }
    }
    
    
}

extension OwnerUserMsgViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OwnerMineUserMsgCell.reuseIdentifierStr) as? OwnerMineUserMsgCell
        cell?.selectionStyle = .none
        cell?.userModel = userModel
        cell?.model = typeSourceArray[indexPath.row]
        cell?.endEditingMessageCell = { [weak self] (userModel) in
            self?.userModel = userModel
        }
        return cell ?? OwnerMineUserMsgCell.init(frame: .zero)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return typeSourceArray.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return OwnerMineUserMsgCell.rowHeight()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if typeSourceArray[indexPath.row].type == RenterUserMsgType.RenterUserMsgTypeSex {
            
            let alertController = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
            let refreshAction = UIAlertAction.init(title: "男", style: .default) {[weak self] (action: UIAlertAction) in
                self?.userModel?.sex = "1"
                self?.tableView.reloadData()
            }
            let copyAction = UIAlertAction.init(title: "女", style: .default) {[weak self] (action: UIAlertAction) in
                self?.userModel?.sex = "0"
                self?.tableView.reloadData()
            }
            let cancelAction = UIAlertAction.init(title: "取消", style: .cancel) { (action: UIAlertAction) in
                
            }
            alertController.addAction(refreshAction)
            alertController.addAction(copyAction)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
        }
    }
}

class OwnerMineUserMsgCell: BaseTableViewCell {
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_15
        view.textColor = kAppColor_333333
        return view
    }()
    
    
    lazy var editLabel: UITextField = {
        let view = UITextField()
        view.textAlignment = .left
        view.font = FONT_15
        view.delegate = self
        view.textColor = kAppColor_333333
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
    //判断是否显示显示员工管理
    var userModel: LoginUserModel?
    
    var endEditingMessageCell:((LoginUserModel) -> Void)?
    
    var model: UserMsgConfigureModel = UserMsgConfigureModel(types: RenterUserMsgType.RenterUserMsgTypeAvatar) {
        didSet {
            titleLabel.attributedText = model.getNameFormType(type: model.type ?? RenterUserMsgType.RenterUserMsgTypeAvatar)
            if model.type == RenterUserMsgType.RenterUserMsgTypeSex {
                self.detailIcon.isHidden = false
                self.editLabel.isUserInteractionEnabled = false
                self.editLabel.textColor = kAppColor_333333
                if userModel?.sex == "1" {
                    self.editLabel.text = "男"
                }else if userModel?.sex == "0" {
                    self.editLabel.text = "女"
                }else {
                    self.editLabel.text = ""
                }
            }else if model.type == RenterUserMsgType.RenterUserMsgTypeTele {
                self.detailIcon.isHidden = true
                self.editLabel.isUserInteractionEnabled = false
                self.editLabel.textColor = kAppColor_999999
                self.editLabel.text = userModel?.phone
                
            }else {
                self.detailIcon.isHidden = true
                self.editLabel.isUserInteractionEnabled = true
                self.editLabel.textColor = kAppColor_333333
                
                if model.type == RenterUserMsgType.RenterUserMsgTypeNick {
                    self.editLabel.text = userModel?.nickname
                }else if model.type == RenterUserMsgType.RenterUserMsgTypeWechat {
                    self.editLabel.text = userModel?.wxId
                }else if model.type == RenterUserMsgType.RenterUserMsgTypeCompany {
                    self.editLabel.isUserInteractionEnabled = false
                    self.editLabel.textColor = kAppColor_999999
                    self.editLabel.text = userModel?.company
                }else if model.type == RenterUserMsgType.RenterUserMsgTypeJob {
                    self.editLabel.text = userModel?.job
                }
            }
        }
    }
    func setupViews() {

        self.backgroundColor = kAppWhiteColor
  
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(editLabel)
        self.contentView.addSubview(detailIcon)
        self.contentView.addSubview(lineView)
        
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(left_pending_space_17)
            make.top.bottom.equalToSuperview()
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

extension OwnerMineUserMsgCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if model.type == RenterUserMsgType.RenterUserMsgTypeNick {
            userModel?.nickname = textField.text
        }else if model.type == RenterUserMsgType.RenterUserMsgTypeTele {
            userModel?.phone = textField.text
        }else if model.type == RenterUserMsgType.RenterUserMsgTypeWechat {
            userModel?.wxId = textField.text
        }else if model.type == RenterUserMsgType.RenterUserMsgTypeCompany {
            userModel?.company = textField.text
        }else if model.type == RenterUserMsgType.RenterUserMsgTypeJob {
            userModel?.job = textField.text
        }
        guard let blockk = self.endEditingMessageCell else {
            return
        }
        blockk(userModel ?? LoginUserModel())
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
}



//
//  RenterUserMsgViewController.swift
//  OfficeGo
//
//  Created by mac on 2020/5/18.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit
import CLImagePickerTool
import Alamofire

class RenterUserMsgViewController: BaseTableViewController {
    
    var selectedAvatarData: NSData?
    
    var userModel: LoginUserModel? {
        didSet {
            setUpData()
            
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
        let view = RenterAvatarUploadHeaderView.init(frame: CGRect(x: 0, y: 0, width: kWidth, height: 68))
        return view
    }()
    
    var typeSourceArray:[UserMsgConfigureModel] = {
        var arr = [UserMsgConfigureModel]()
        arr.append(UserMsgConfigureModel.init(types: .RenterUserMsgTypeNick))
        arr.append(UserMsgConfigureModel.init(types: .RenterUserMsgTypeSex))
        arr.append(UserMsgConfigureModel.init(types: .RenterUserMsgTypeTele))
        arr.append(UserMsgConfigureModel.init(types: .RenterUserMsgTypeWechat))
        return arr
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        
    }
    
}


extension RenterUserMsgViewController {
    
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
        
        self.tableView.register(RenterMineUserMsgCell.self, forCellReuseIdentifier: RenterMineUserMsgCell.reuseIdentifierStr)
        
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
        
        setSureBtnEnable(can: false)

        var params = [String:AnyObject]()
        params["realname"] = userModel?.realname as AnyObject?
        params["sex"] = userModel?.sex as AnyObject?
        params["token"] = UserTool.shared.user_token as AnyObject?
        
        
        params["WX"] = userModel?.wxId as AnyObject?
        
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
extension UIImage {
     
    //将图片裁剪成指定比例（多余部分自动删除）
    func crop(ratio: CGFloat) -> UIImage {
        //计算最终尺寸
        var newSize:CGSize!
        if size.width/size.height > ratio {
            newSize = CGSize(width: size.height * ratio, height: size.height)
        }else{
            newSize = CGSize(width: size.width, height: size.width / ratio)
        }
     
        ////图片绘制区域
        var rect = CGRect.zero
        rect.size.width  = size.width
        rect.size.height = size.height
        rect.origin.x    = (newSize.width - size.width ) / 2.0
        rect.origin.y    = (newSize.height - size.height ) / 2.0
         
        //绘制并获取最终图片
        UIGraphicsBeginImageContext(newSize)
        draw(in: rect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
         
        return scaledImage!
    }
    
    /**
     *  等比率缩放
     */
    func scaleImage(scaleSize:CGFloat) -> UIImage {
        let reSize = CGSize(width:self.size.width * scaleSize,height:self.size.height * scaleSize)
        return reSizeImage(reSize: reSize)
    }
    
    /**
     *  重设图片大小
     */
    func reSizeImage(reSize:CGSize) -> UIImage {
        //UIGraphicsBeginImageContext(reSize);
        UIGraphicsBeginImageContextWithOptions(reSize,false,UIScreen.main.scale)
        self.draw(in: CGRect(x:0,y:0,width:reSize.width,height:reSize.height))
        let reSizeImage:UIImage = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return reSizeImage
    }
    
}
extension RenterUserMsgViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RenterMineUserMsgCell.reuseIdentifierStr) as? RenterMineUserMsgCell
        cell?.selectionStyle = .none
        cell?.userModel = userModel
        cell?.model = typeSourceArray[indexPath.row]
        cell?.endEditingMessageCell = { [weak self] (userModel) in
            self?.userModel = userModel
        }
        return cell ?? RenterMineUserMsgCell.init(frame: .zero)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return typeSourceArray.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return RenterMineUserMsgCell.rowHeight()
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

class RenterMineUserMsgCell: BaseTableViewCell {
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_14
        view.textColor = kAppColor_333333
        return view
    }()
    
    
    lazy var editLabel: UITextField = {
        let view = UITextField()
        view.textAlignment = .left
        view.font = FONT_14
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
        return 49
    }
    var userModel: LoginUserModel?
    
    var endEditingMessageCell:((LoginUserModel) -> Void)?
    
    var model: UserMsgConfigureModel = UserMsgConfigureModel(types: RenterUserMsgType.RenterUserMsgTypeAvatar) {
        didSet {
            titleLabel.attributedText = model.getNameFormType(type: model.type ?? RenterUserMsgType.RenterUserMsgTypeAvatar)
            if model.type == RenterUserMsgType.RenterUserMsgTypeSex {
                self.detailIcon.isHidden = false
                self.editLabel.isUserInteractionEnabled = false
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
                self.editLabel.text = userModel?.phone
                
            }else {
                self.detailIcon.isHidden = true
                self.editLabel.isUserInteractionEnabled = true
                
                if model.type == RenterUserMsgType.RenterUserMsgTypeNick {
                    self.editLabel.text = userModel?.realname
                }else if model.type == RenterUserMsgType.RenterUserMsgTypeWechat {
                    self.editLabel.text = userModel?.wxId
                }
            }
        }
    }
    func setupViews() {
        
        addSubview(titleLabel)
        addSubview(editLabel)
        addSubview(detailIcon)
        addSubview(lineView)
        
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(left_pending_space_17)
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

extension RenterMineUserMsgCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if model.type == RenterUserMsgType.RenterUserMsgTypeNick {
            userModel?.realname = textField.text
        }else if model.type == RenterUserMsgType.RenterUserMsgTypeTele {
            userModel?.phone = textField.text
        }else if model.type == RenterUserMsgType.RenterUserMsgTypeWechat {
            userModel?.wxId = textField.text
        }
        guard let blockk = self.endEditingMessageCell else {
            return
        }
        blockk(userModel ?? LoginUserModel())
    }
}


class RenterAvatarUploadHeaderView: UIView { //高度69
    
    lazy var headerViewBtn: UIButton = {
        let view = UIButton.init()
        view.isUserInteractionEnabled = true
        view.addTarget(self, action: #selector(leftBtnClick), for: .touchUpInside)
        return view
    }()
    
    lazy var headerImg: BaseImageView = {
        let view = BaseImageView.init()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 19
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.font = FONT_14
        view.textColor = kAppColor_333333
        view.text = "头像"
        return view
    }()
    
    lazy var introductionLabel: UILabel = {
        let view = UILabel()
        view.font = FONT_10
        view.textColor = kAppColor_666666
        view.text = "上传真实头像有助于增加信任感"
        return view
    }()
    
    var headerBtnClickBlock: (() -> Void)?
    
    var setBtnClickBlock: (() -> Void)?
    
    var userModel: LoginUserModel? {
        didSet {
            headerImg.setImage(with: userModel?.avatar ?? "", placeholder: UIImage.init(named: "avatar"))
        }
    }
    
    @objc func leftBtnClick() {
        guard let blockk = headerBtnClickBlock else {
            return
        }
        blockk()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    private func setupView() {
        
        addSubview(headerViewBtn)
        headerViewBtn.addSubview(headerImg)
        headerViewBtn.addSubview(nameLabel)
        headerViewBtn.addSubview(introductionLabel)
        
        headerViewBtn.snp.makeConstraints { (make) in
            make.top.leading.bottom.trailing.equalToSuperview()
        }
        headerImg.snp.makeConstraints { (make) in
            make.trailing.equalTo(-left_pending_space_17)
            make.centerY.equalToSuperview()
            make.size.equalTo(38)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(14)
            make.leading.equalTo(left_pending_space_17)
            make.height.equalTo(23)
        }
        introductionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(2)
            make.leading.equalTo(nameLabel)
            make.height.equalTo(introductionLabel)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

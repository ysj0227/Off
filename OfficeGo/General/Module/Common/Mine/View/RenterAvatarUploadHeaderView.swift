//
//  RenterAvatarUploadHeaderView.swift
//  OfficeGo
//
//  Created by mac on 2020/6/19.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import CLImagePickerTool
import SwiftyJSON
import HandyJSON

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
        view.layer.cornerRadius = 22
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.font = FONT_15
        view.textColor = kAppColor_333333
        view.text = "头像"
        return view
    }()
    
    lazy var introductionLabel: UILabel = {
        let view = UILabel()
        view.font = FONT_11
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
            make.size.equalTo(44)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(16)
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


///业主个人名片
class OwnerVisitingCardView: BaseViewController { //高度408
    
    lazy var blackAlphabgView: UIButton = {
        let button = UIButton.init()
        button.backgroundColor = kAppAlphaWhite0_alpha_7
//        button.addTarget(self, action: #selector(clickRemoveFromSuperview), for: .touchUpInside)
        return button
    }()
    
    lazy var whiteView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        view.backgroundColor = kAppWhiteColor
        return view
    }()
    
    lazy var closeBtn: UIButton = {
        let btn = UIButton()
        //        let button = UIButton(frame: CGRect(x: kWidth - left_pending_space_17 * 3, y: 0, width: left_pending_space_17 * 3, height: 53))
        btn.setImage(UIImage.init(named: "closeGray"), for: .normal)
        btn.addTarget(self, action: #selector(clickRemoveFromSuperview), for: .touchUpInside)
        return btn
    }()
    
    lazy var titleLabel : UILabel = {
        let view = UILabel()
        view.font = FONT_SEMBLOD_23
        view.textColor = kAppColor_666666
        view.text = "请完善个人名片"
        view.textAlignment = .center
        return view
    }()
    
    lazy var headerViewBtn: UIButton = {
        let view = UIButton.init()
        view.isUserInteractionEnabled = true
        view.addTarget(self, action: #selector(cameraBtnClick), for: .touchUpInside)
        return view
    }()
    
    lazy var headerImg: BaseImageView = {
        let view = BaseImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 40
        return view
    }()
    
    lazy var cameraImage: BaseImageView = {
        let view = BaseImageView()
        view.image = UIImage.init(named: "camera_blue")
        return view
    }()
    
    lazy var nickLabel: UILabel = {
        let view = UILabel()
        view.font = FONT_13
        view.textColor = kAppColor_333333
        view.text = "  称呼："
        return view
    }()
    
    lazy var nickTF: UITextField = {
        let view = UITextField()
        view.font = FONT_13
        view.textColor = kAppColor_333333
        view.clearButtonMode = .whileEditing
        view.placeholder = "输入称呼"
        return view
    }()

    lazy var jobLabel: UILabel = {
        let view = UILabel()
        view.font = FONT_13
        view.textColor = kAppColor_333333
        view.text = "  职位："
        return view
    }()
    
    lazy var jobTF: UITextField = {
        let view = UITextField()
        view.font = FONT_13
        view.textColor = kAppColor_333333
        view.clearButtonMode = .whileEditing
        view.placeholder = "输入职位"
        return view
    }()
    
    lazy var commitBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = kAppBlueColor
        btn.clipsToBounds = true
        btn.layer.cornerRadius = button_cordious_2
        btn.setTitle("确认保存", for: .normal)
        btn.setTitleColor(kAppWhiteColor, for: .normal)
        btn.titleLabel?.font = FONT_MEDIUM_14
        btn.addTarget(self, action: #selector(commitBtnClick), for: .touchUpInside)
        return btn
    }()
    
    lazy var moreBtn: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(kAppBlueColor, for: .normal)
        btn.titleLabel?.font = FONT_12
        btn.setTitle("更多>", for: .normal)
        btn.addTarget(self, action: #selector(moreBtnClick), for: .touchUpInside)
        return btn
    }()
    
    lazy var imagePickTool: CLImagePickerTool = {
        let picker = CLImagePickerTool()
        picker.cameraOut = true
        picker.isHiddenVideo = true
        picker.singleImageChooseType = .singlePicture   //设置单选
        picker.singleModelImageCanEditor = false        //单选不可编辑
        return picker
    }()
    
    func selfRemove() {
        self.view.removeFromSuperview()
    }
        
    ///commit提交
    var commitClickBlock: ((_ usermodel: LoginUserModel) -> Void)?

    var moreClickBlock: (() -> Void)?
    
    @objc func clickRemoveFromSuperview() {
        selfRemove()
    }
    
    @objc func cameraBtnClick() {
        pickerSelect()
    }
    
    var userModel: LoginUserModel? {
        didSet {
            
            if userModel?.isNickname == true {
                userModel?.tempNickName = userModel?.nickname
            }else {
                userModel?.tempNickName = nil
            }
            
            headerImg.setImage(with: userModel?.avatar ?? "", placeholder: UIImage.init(named: "newAvatar"))

            nickTF.text = userModel?.tempNickName
            
            jobTF.text = UserTool.shared.user_job
        }
    }
    
    func pickerSelect() {

        imagePickTool.cl_setupImagePickerWith(MaxImagesCount: 2, superVC: self) {[weak self] (asset,cutImage) in
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
        
        self.headerImg.image = image2
        self.upload(uploadImage: image2 ?? UIImage.init())
    }
    
    private func upload(uploadImage:UIImage) {
        
        var params = [String:AnyObject]()
        params["token"] = UserTool.shared.user_token as AnyObject?
        
        ///1楼图片2视频3房源图片4认证5个人中心
        params["filedirType"] = UploadImgOrVideoEnum.avatar.rawValue as AnyObject?

        
        SSNetworkTool.SSFYManager.request_uploadResourcesUrl(params: params, imagesArray: [uploadImage], success: {[weak self] (response) in
            if let decoratedArray = JSONDeserializer<BannerModel>.deserializeModelArrayFrom(json: JSON(response["data"] ?? "").rawString() ?? "", designatedPath: "urls") {
                
                if decoratedArray.count >= 1 {
                    self?.userModel?.avatar = decoratedArray[0]?.url
//                    UserTool.shared.user_avatars = decoratedArray[0]?.url
//                    self?.requestEditUserAvatarMessage()
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
    
    func requestEditUserAvatarMessage() {

        var params = [String:AnyObject]()
        params["token"] = UserTool.shared.user_token as AnyObject?
        params["avatar"] = userModel?.avatar as AnyObject?
        params["nickname"] = userModel?.tempNickName as AnyObject?
        params["job"] = userModel?.job as AnyObject?
        params["sex"] = UserTool.shared.user_sex as AnyObject?
        params["wxId"] = UserTool.shared.user_wechat as AnyObject?
        SSNetworkTool.SSMine.request_updateUserMessage(params: params, success: { (response) in
            AppUtilities.makeToast("头像已修改")
            }, failure: { (error) in

        }) { (code, message) in
        }
    }
    
    
    @objc func commitBtnClick() {
        
        self.view.endEditing(true)
        
        if userModel?.avatar?.count ?? 0 <= 0 {
            AppUtilities.makeToast("请上传头像")
            return
        }
        
        if nickTF.text?.isBlankString == true {
            AppUtilities.makeToast("请输入称呼")
            return
        }
        
        if jobTF.text?.isBlankString == true {
            AppUtilities.makeToast("请输入职位")
            return
        }
        userModel?.nickname = nickTF.text
        userModel?.job = jobTF.text
        guard let blockk = commitClickBlock else {
            return
        }
        ///调用更新个人中心接口
        blockk(userModel ?? LoginUserModel())
        selfRemove()
    }
    
    @objc func moreBtnClick() {
        guard let blockk = moreClickBlock else {
            return
        }
        blockk()
        selfRemove()
    }
    
    
    // MARK: - 弹出view显示 - 名片独有
    func ShowOwnerVisitingCardView(moreClickBlock: @escaping (() -> Void), commitClickBlock: @escaping ((LoginUserModel) -> Void)) -> Void {
        UIApplication.shared.keyWindow?.subviews.forEach({ (view) in
            if view.isKind(of: OwnerVisitingCardView.self) {
                view.removeFromSuperview()
            }
        })
        
        self.view.frame = CGRect(x: 0, y: 0, width: kWidth, height: kHeight)
        self.moreClickBlock = moreClickBlock
        self.commitClickBlock = commitClickBlock
        UIApplication.shared.keyWindow?.addSubview(self.view)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        
        IQKeyboardManager.shared.enable = true
        
        self.view.backgroundColor = kAppClearColor
        self.view.addSubview(blackAlphabgView)
        self.view.addSubview(whiteView)
        whiteView.addSubview(closeBtn)
        whiteView.addSubview(titleLabel)
        whiteView.addSubview(headerViewBtn)
        headerViewBtn.addSubview(headerImg)
        headerViewBtn.addSubview(cameraImage)
        whiteView.addSubview(nickLabel)
        whiteView.addSubview(nickTF)
        whiteView.addSubview(jobLabel)
        whiteView.addSubview(jobTF)
        whiteView.addSubview(commitBtn)
        whiteView.addSubview(moreBtn)
        
        blackAlphabgView.snp.makeConstraints { (make) in
            make.top.leading.bottom.trailing.equalToSuperview()
        }
        whiteView.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 299, height: 408))
        }
        closeBtn.snp.makeConstraints { (make) in
            make.top.trailing.equalToSuperview().inset(0)
            make.size.equalTo(36)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(32)
            make.leading.trailing.equalToSuperview()
        }
        headerViewBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(21)
            make.size.equalTo(80)
        }
        headerImg.snp.makeConstraints { (make) in
            make.leading.bottom.trailing.top.equalToSuperview()
        }
        cameraImage.snp.makeConstraints { (make) in
            make.bottom.trailing.equalToSuperview().inset(3)
            make.size.equalTo(22)
        }

        nickLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(headerViewBtn.snp.bottom).offset(20)
            make.height.equalTo(40)
        }
        nickTF.snp.makeConstraints { (make) in
            make.leading.equalTo(nickLabel).offset(55)
            make.centerY.equalTo(nickLabel)
            make.trailing.equalTo(nickLabel)
        }
        jobLabel.snp.makeConstraints { (make) in
            make.leading.trailing.height.equalTo(nickLabel)
            make.top.equalTo(nickLabel.snp.bottom).offset(17)
        }
        jobTF.snp.makeConstraints { (make) in
            make.leading.equalTo(jobLabel).offset(55)
            make.centerY.equalTo(jobLabel)
            make.trailing.equalTo(jobLabel)
        }
        commitBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 128, height: 30))
            make.top.equalTo(jobLabel.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
        moreBtn.snp.makeConstraints { (make) in
            make.top.equalTo(commitBtn.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        commitBtn.clipsToBounds = true
        commitBtn.layer.cornerRadius = 15
        
        nickLabel.clipsToBounds = true
        nickLabel.layer.borderWidth = 1.0
        nickLabel.layer.borderColor = kAppColor_line_EEEEEE.cgColor
        
        jobLabel.clipsToBounds = true
        jobLabel.layer.borderWidth = 1.0
        jobLabel.layer.borderColor = kAppColor_line_EEEEEE.cgColor
    }
}

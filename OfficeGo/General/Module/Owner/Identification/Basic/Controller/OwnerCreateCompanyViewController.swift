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
    
    var yingYeZhiZhaoPhoto: UIImageView = {
        
        let view = UIImageView.init(frame: CGRect(x: left_pending_space_17, y: 0, width: kWidth - left_pending_space_17 * 2, height: 158))
        view.backgroundColor = kAppLightBlueColor
        view.isUserInteractionEnabled = true
        return view
    }()
    
    var selectedAvatarData: NSData?
    
    var userModel: OwnerIdentifyUserModel? {
        didSet {
            
            ///设置下面的按钮的状态
            if userModel?.company?.isBlankString == true || userModel?.address?.isBlankString == true  {
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
        view.rightSelectBtn.setTitle("确认创建", for: .normal)
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
    
    var typeSourceArray:[OwnerCreatCompanyConfigureModel] = [OwnerCreatCompanyConfigureModel]()
    
    var companyModel: OwnerESCompanySearchViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        
        setUpData()
    }
    
}


extension OwnerCreateCompanyViewController {
    
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
        yingYeZhiZhaoPhoto.image = image
        
        /*
        let image2 = image?.crop(ratio: 1)
        
        self.upload(uploadImage: image2 ?? UIImage.init())
 */
    }
    func setUpData() {
        
        typeSourceArray.append(OwnerCreatCompanyConfigureModel.init(types: .OwnerCreteCompanyTypeIedntify))
        typeSourceArray.append(OwnerCreatCompanyConfigureModel.init(types: .OwnerCreteCompanyTypeCompanyName))
        typeSourceArray.append(OwnerCreatCompanyConfigureModel.init(types: .OwnerCreteCompanyTypeCompanyAddress))
        typeSourceArray.append(OwnerCreatCompanyConfigureModel.init(types: .OwnerCreteCompanyTypeYingyeCode))
        typeSourceArray.append(OwnerCreatCompanyConfigureModel.init(types: .OwnerCreteCompanyTypeUploadYingyePhoto))
        
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
       }else if UserTool.shared.user_owner_identifytype == 2 {
           NotificationCenter.default.post(name: NSNotification.Name.OwnerCreateCompanyJoint, object: companyModel)
       }
   }
    
    ///创建公司接口 -
    func requestCreateCompany() {
        
        addNotify()
    }
    
    
}

extension OwnerCreateCompanyViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OwnerCreateCompanyCell.reuseIdentifierStr) as? OwnerCreateCompanyCell
        cell?.selectionStyle = .none
        cell?.userModel = userModel
        cell?.model = typeSourceArray[indexPath.row]
        cell?.endEditingMessageCell = { [weak self] (userModel) in
            self?.userModel = userModel
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
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.addSubview(yingYeZhiZhaoPhoto)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 252 - 58
    }
}


class OwnerCreateCompanyCell: BaseEditCell {
    
    var userModel: OwnerIdentifyUserModel?
    
    var endEditingMessageCell:((OwnerIdentifyUserModel) -> Void)?
    
    var model: OwnerCreatCompanyConfigureModel = OwnerCreatCompanyConfigureModel(types: OwnerCreteCompanyType.OwnerCreteCompanyTypeIedntify) {
        didSet {
            
            titleLabel.attributedText = model.getNameFormType(type: model.type ?? OwnerCreteCompanyType.OwnerCreteCompanyTypeIedntify)
            
            detailIcon.isHidden = true
            
            if model.type == .OwnerCreteCompanyTypeIedntify {
                editLabel.isUserInteractionEnabled = false
                lineView.isHidden = false
                editLabel.text = "公司"
            }else if model.type == .OwnerCreteCompanyTypeCompanyName{
                editLabel.isUserInteractionEnabled = true
                lineView.isHidden = false
                editLabel.text = userModel?.company
            }else if model.type == .OwnerCreteCompanyTypeCompanyAddress{
                editLabel.isUserInteractionEnabled = true
                lineView.isHidden = false
                editLabel.text = userModel?.address
            }else if model.type == .OwnerCreteCompanyTypeYingyeCode {
                editLabel.isUserInteractionEnabled = true
                lineView.isHidden = false
                editLabel.text = ""
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
        
        guard let blockk = self.endEditingMessageCell else {
            return
        }
        blockk(userModel ?? OwnerIdentifyUserModel())
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
}



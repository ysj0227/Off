//
//  OwnerCreateBuildingViewController.swift
//  OfficeGo
//
//  Created by mac on 2020/7/17.
//  Copyright © 2020 Senwei. All rights reserved.
//

import CLImagePickerTool
import Alamofire
class OwnerCreateBuildingViewController: BaseTableViewController {
    
    var mainPicPhoto: UIImageView = {
           
           let view = UIImageView.init(frame: CGRect(x: left_pending_space_17, y: 0, width: (kWidth - left_pending_space_17 * 4) / 3.0 - 1, height: (kWidth - left_pending_space_17 * 4) / 3.0 - 1))
           view.image = UIImage.init(named: "addImgBg")
           view.isUserInteractionEnabled = true
           return view
       }()
       
       var selectedAvatarData: NSData?
    
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
    
    var typeSourceArray:[OwnerCreatBuildingConfigureModel] = [OwnerCreatBuildingConfigureModel]()
    
    var buildingModel: OwnerESBuildingSearchModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        
        setUpData()
    }
    
}


extension OwnerCreateBuildingViewController {
    
    func setUpView() {
        
        titleview = ThorNavigationView.init(type: .backTitleRight)
        titleview?.titleLabel.text = "创建写字楼"
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
        
        self.tableView.register(OwnerCreateBuildingCell.self, forCellReuseIdentifier: OwnerCreateBuildingCell.reuseIdentifierStr)
        
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
           mainPicPhoto.image = image
           
           /*
            let image2 = image?.crop(ratio: 1)
            
            self.upload(uploadImage: image2 ?? UIImage.init())
            */
       }
    func setUpData() {
        
        typeSourceArray.append(OwnerCreatBuildingConfigureModel.init(types: .OwnerCreteBuildingTypeBranchName))
        typeSourceArray.append(OwnerCreatBuildingConfigureModel.init(types: .OwnerCreteBuildingTypeBranchDistrictArea))
        typeSourceArray.append(OwnerCreatBuildingConfigureModel.init(types: .OwnerCreteBuildingTypeBranchAddress))
        typeSourceArray.append(OwnerCreatBuildingConfigureModel.init(types: .OwnerCreteBuildingTypeUploadYingyePhoto))
        
        if buildingModel != nil {
            
        }else {
            buildingModel = OwnerESBuildingSearchModel()
        }
        
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
        NotificationCenter.default.post(name: NSNotification.Name.OwnerCreateBuilding, object: buildingModel)
        leftBtnClick()
    }
    
    ///创建公司接口 -
    func requestCreateCompany() {
        
        addNotify()
    }
    
    
}

extension OwnerCreateBuildingViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OwnerCreateBuildingCell.reuseIdentifierStr) as? OwnerCreateBuildingCell
        cell?.selectionStyle = .none
        cell?.buildingModel = buildingModel
        cell?.model = typeSourceArray[indexPath.row]
        cell?.endEditingMessageCell = { [weak self] (buildingModel) in
            self?.buildingModel = buildingModel
        }
        return cell ?? OwnerCreateBuildingCell.init(frame: .zero)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return typeSourceArray.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return OwnerCreateBuildingCell.rowHeight()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if typeSourceArray[indexPath.row].type == .OwnerCreteBuildingTypeBranchDistrictArea{
            ///区域商圈选择
            
        }
    }
}

class OwnerCreateBuildingCell: BaseEditCell {
    
    var buildingModel: OwnerESBuildingSearchModel?

    var endEditingMessageCell:((OwnerESBuildingSearchModel) -> Void)?
    
    override func setDelegate() {
        editLabel.delegate = self
    }
    
    var model: OwnerCreatBuildingConfigureModel = OwnerCreatBuildingConfigureModel(types: OwnerCreteBuildingType.OwnerCreteBuildingTypeBranchName) {
        didSet {
            
            titleLabel.attributedText = model.getNameFormType(type: model.type ?? OwnerCreteBuildingType.OwnerCreteBuildingTypeBranchName)
            
            detailIcon.isHidden = true
            
            if model.type == .OwnerCreteBuildingTypeBranchName{
                editLabel.isUserInteractionEnabled = true
                lineView.isHidden = false
                editLabel.text = buildingModel?.buildingName
            }else if model.type == .OwnerCreteBuildingTypeBranchDistrictArea{
                editLabel.isUserInteractionEnabled = false
                lineView.isHidden = false
                detailIcon.isHidden = false
                editLabel.text = buildingModel?.address
            }else if model.type == .OwnerCreteBuildingTypeBranchAddress{
                editLabel.isUserInteractionEnabled = true
                lineView.isHidden = false
                editLabel.text = buildingModel?.address
            }else if model.type == .OwnerCreteBuildingTypeUploadYingyePhoto{
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
            buildingModel?.buildingName = textField.text
        }else if model.type == .OwnerCreteBuildingTypeBranchAddress{
            buildingModel?.address = textField.text
        }
        
        guard let blockk = self.endEditingMessageCell else {
            return
        }
        blockk(buildingModel ?? OwnerESBuildingSearchModel())
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
}

//
//  RenterUserMsgViewController.swift
//  OfficeGo
//
//  Created by mac on 2020/5/18.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit
import CLImagePickerTool

class RenterUserMsgViewController: BaseTableViewController {
    
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
        
        setUpData()
        
    }
    
}


extension RenterUserMsgViewController {
    /*
    * 强制刷新用户信息
    * SDK 缓存操作
    * 1、刷新 SDK 缓存
 */
    func reloadRCUserInfo() {
        let info = RCUserInfo.init(userId: "11", name: "修改了名字", portrait: "https://img.officego.com.cn/report/1589888998797.jpg")
        RCIM.shared()?.refreshUserInfoCache(info, withUserId: "11")
    }
    
    
    func setUpView() {
        
        titleview = ThorNavigationView.init(type: .backTitleRight)
        titleview?.titleLabel.text = "基本信息"
        titleview?.rightButton.isHidden = true
        titleview?.leftButtonCallBack = { [weak self] in
            self?.leftBtnClick()
            self?.reloadRCUserInfo()
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
    }
    
    func pickerSelect() {
        imagePickTool.cl_setupImagePickerWith(MaxImagesCount: 2) {[weak self] (asset,cutImage) in
            print("返回的asset数组是\(asset)")
            
            //获取缩略图，耗时较短
            let imageArr = CLImagePickerTool.convertAssetArrToThumbnailImage(assetArr: asset, targetSize: CGSize(width: 80, height: 80))
            print(imageArr)
            self?.headerView.headerImg.image = imageArr.count > 0 ? imageArr[0] : UIImage.init(named: "avatar")
        }
    }
    
    func setUpData() {
        
        //设置头像
        headerView.userModel = ""
        
        self.tableView.reloadData()
    }
    
}

extension RenterUserMsgViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RenterMineUserMsgCell.reuseIdentifierStr) as? RenterMineUserMsgCell
        cell?.selectionStyle = .none
        cell?.model = typeSourceArray[indexPath.row]
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
            let refreshAction = UIAlertAction.init(title: "男", style: .default) { (action: UIAlertAction) in
                
            }
            let copyAction = UIAlertAction.init(title: "女", style: .default) { (action: UIAlertAction) in
                
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
    var model: UserMsgConfigureModel = UserMsgConfigureModel(types: RenterUserMsgType.RenterUserMsgTypeAvatar) {
        didSet {
            titleLabel.attributedText = model.getNameFormType(type: model.type ?? RenterUserMsgType.RenterUserMsgTypeAvatar)
            if model.type == RenterUserMsgType.RenterUserMsgTypeSex {
                self.detailIcon.isHidden = false
                self.editLabel.isUserInteractionEnabled = false
            }else {
                self.detailIcon.isHidden = true
                self.editLabel.isUserInteractionEnabled = true
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
    
    var userModel: String = "" {
        didSet {
            headerImg.setImage(with: "", placeholder: UIImage.init(named: "avatar"))
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

//
//  RenterMineViewController.swift
//  OfficeGo
//
//  Created by mac on 2020/5/18.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit
import HandyJSON
import SwiftyJSON

class RenterMineViewController: BaseTableViewController {
    
    var userModel: LoginUserModel?
    
    var typeSourceArray:[MineConfigureModel] = {
        var arr = [MineConfigureModel]()
//        arr.append(MineConfigureModel.init(types: .RenterMineTypeIWanttoFind))
        arr.append(MineConfigureModel.init(types: .RenterMineTypeHouseSchedule))
        arr.append(MineConfigureModel.init(types: .RenterMineTypeHelpAndFeedback))
        arr.append(MineConfigureModel.init(types: .RenterMineTypeCusomers))
        arr.append(MineConfigureModel.init(types: .RenterMineTypeRegisterAgent))
        arr.append(MineConfigureModel.init(types: .RenterMineTypeAboutus))
        return arr
    }()
    
    var headerView: RenterUserHeaderView = {
        let view = RenterUserHeaderView.init(frame: CGRect(x: 0, y: 0, width: kWidth, height: kStatusBarHeight + 20 + 20 + 114))
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        
        setUpData()
        
    }
 
    override func viewWillDisappear(_ animated: Bool) {
         super.viewWillDisappear(animated)
         let tab = self.navigationController?.tabBarController as? MainTabBarController
         tab?.customTabBar.isHidden = true
     }
     override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         let tab = self.navigationController?.tabBarController as? MainTabBarController
         tab?.customTabBar.isHidden = false
        
        if userModel == nil {
            requestUserMessage()
        }
     }
     
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}


extension RenterMineViewController {
    
    func setUpView() {
        
        self.navigationController?.navigationBar.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(requestUserMessage), name: Notification.Name.userChanged, object: nil)
        
        self.view.backgroundColor = kAppBlueColor
        
        self.view.addSubview(headerView)
        
        headerView.headerBtnClickBlock = { [weak self] in
            let vc = RenterUserMsgViewController()
            vc.userModel = self?.userModel
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        headerView.setBtnClickBlock = { [weak self] in
            let vc = RenterMineSettingViewController()
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        self.tableView.clipsToBounds = true
        self.tableView.layer.cornerRadius = 13
        self.tableView.snp.remakeConstraints { (make) in
            make.top.equalTo(kStatusBarHeight + 20 + 20 + 114)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        self.tableView.register(RenterMineCell.self, forCellReuseIdentifier: RenterMineCell.reuseIdentifierStr)
    }
    
    func setUpData() {
        
        requestUserMessage()
                
        self.tableView.reloadData()
    }
    
}

extension RenterMineViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RenterMineCell.reuseIdentifierStr) as? RenterMineCell
        cell?.selectionStyle = .none
        cell?.model = typeSourceArray[indexPath.row]
        return cell ?? HouseListTableViewCell.init(frame: .zero)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return typeSourceArray.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return RenterMineCell.rowHeight()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch typeSourceArray[indexPath.row].type {
        case .RenterMineTypeIWanttoFind:
            print(typeSourceArray[indexPath.row].type)
        case .RenterMineTypeHouseSchedule:
            let vc = RenterHouseScheduleViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case .RenterMineTypeHelpAndFeedback:
            print(typeSourceArray[indexPath.row].type)
        case .RenterMineTypeCusomers:
            print(typeSourceArray[indexPath.row].type)
        case .RenterMineTypeRegisterAgent:
//            let url = "\(SSAPI.SSApiHost)\(SSMineURL.registerProtocol)"
            let url = "http://test.officego.com.cn/lessee/registerProtocol.html"
            let vc = JHWebViewController.init(url: url)
            vc.title = typeSourceArray[indexPath.row].getNameFormType(type: typeSourceArray[indexPath.row].type ?? RenterMineType.RenterMineTypeRegisterAgent)
//            vc.titleString = typeSourceArray[indexPath.row].getNameFormType(type: typeSourceArray[indexPath.row].type ?? RenterMineType.RenterMineTypeRegisterAgent)
            self.navigationController?.pushViewController(vc, animated: true)
        case .RenterMineTypeAboutus:
//            let url = "\(SSAPI.SSApiHost)\(SSMineURL.aboutUs)"
            let url = "http://test.officego.com.cn/lessee/aboutUs.html"
            let vc = BaseWebViewController.init(url: url)
            vc.titleString = typeSourceArray[indexPath.row].getNameFormType(type: typeSourceArray[indexPath.row].type ?? RenterMineType.RenterMineTypeAboutus)
            self.navigationController?.pushViewController(vc, animated: true)

        case .none:
            print(typeSourceArray[indexPath.row].type)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 70
    }
}
class RenterUserHeaderView: UIView {
    
    lazy var headerViewBtn: UIButton = {
        let view = UIButton.init()
        view.isUserInteractionEnabled = true
        view.addTarget(self, action: #selector(leftBtnClick), for: .touchUpInside)
        return view
    }()
    
    lazy var settingBtn: UIButton = {
        let view = UIButton.init()
        view.setImage(UIImage.init(named: "setting"), for: .normal)
        view.addTarget(self, action: #selector(sureSelectClick), for: .touchUpInside)
        return view
    }()
    
    lazy var headerImg: BaseImageView = {
        let view = BaseImageView.init()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.image = UIImage.init(named: "avatar")
        view.layer.cornerRadius = heder_cordious_32
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.font = FONT_MEDIUM_17
        view.textColor = kAppWhiteColor
        return view
    }()
    
    lazy var introductionLabel: UILabel = {
        let view = UILabel()
        view.font = FONT_12
        view.textColor = kAppWhiteColor
        return view
    }()
    
    var headerBtnClickBlock: (() -> Void)?
    
    var setBtnClickBlock: (() -> Void)?
    
    var userModel: LoginUserModel = LoginUserModel() {
        didSet {
//            headerImg.setImage(with: userModel.avatar ?? "", placeholder: UIImage.init(named: "avatar"))
            headerImg.kf.setImage(with: URL(string: userModel.avatar ?? ""), placeholder: UIImage.init(named: "avatar"), options: nil, progressBlock: { (receivedSize, totalSize) in
            })
            nameLabel.text = userModel.realname ?? userModel.nickname ?? "名字"
            introductionLabel.text = "\(userModel.company ?? "公司") - \(userModel.job ?? "职位")"
        }
    }
    
    @objc func leftBtnClick() {
        guard let blockk = headerBtnClickBlock else {
            return
        }
        blockk()
    }
    
    @objc func sureSelectClick() {
        guard let blockk = setBtnClickBlock else {
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
        addSubview(settingBtn)
        headerViewBtn.addSubview(headerImg)
        headerViewBtn.addSubview(nameLabel)
        headerViewBtn.addSubview(introductionLabel)
        
        settingBtn.snp.makeConstraints { (make) in
            make.top.equalTo(kStatusBarHeight + 20)
            make.trailing.equalTo(-left_pending_space_17)
            make.size.equalTo(20)
        }
        headerViewBtn.snp.makeConstraints { (make) in
            make.top.equalTo(settingBtn.snp.bottom)
            make.leading.bottom.trailing.equalToSuperview()
        }
        headerImg.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.leading.equalTo(left_pending_space_17)
            make.size.equalTo(64)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(headerImg)
            make.leading.equalTo(headerImg.snp.trailing).offset(10)
            make.height.equalTo(32)
        }
        introductionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom)
            make.leading.equalTo(nameLabel)
            make.height.equalTo(introductionLabel)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class RenterMineCell: BaseTableViewCell {
    
    lazy var itemIcon: BaseImageView = {
        let view = BaseImageView.init()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_14
        view.textColor = kAppColor_333333
        return view
    }()
    
    lazy var numDescLabel: UILabel = {
        let view = UILabel()
        view.isHidden = true
        view.textAlignment = .right
        view.font = FONT_10
        view.textColor = kAppColor_666666
        return view
    }()
    lazy var detailIcon: BaseImageView = {
        let view = BaseImageView.init()
        view.contentMode = .scaleAspectFit
        view.image = UIImage.init(named: "moreDetail")
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
    
    var model: MineConfigureModel = MineConfigureModel(types: RenterMineType.RenterMineTypeAboutus) {
        didSet {
            itemIcon.image = UIImage.init(named: model.getIconFormType(type: model.type ?? RenterMineType.RenterMineTypeAboutus))
            titleLabel.text = model.getNameFormType(type: model.type ?? RenterMineType.RenterMineTypeAboutus)
            numDescLabel.text = "12"
        }
    }
    
    func setupViews() {
        
        addSubview(itemIcon)
        addSubview(titleLabel)
        addSubview(numDescLabel)
        addSubview(detailIcon)
        addSubview(lineView)
        
        itemIcon.snp.makeConstraints { (make) in
            make.leading.equalTo(left_pending_space_17)
            make.centerY.equalToSuperview()
            make.size.equalTo(19)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(itemIcon.snp.trailing).offset(15)
            make.centerY.equalTo(itemIcon)
            make.trailing.equalTo(-100)
        }
        
        detailIcon.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-left_pending_space_17)
            make.centerY.equalTo(itemIcon)
            make.width.equalTo(10)
        }
        
        numDescLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(detailIcon.snp.leading).offset(9)
            make.centerY.equalTo(itemIcon)
            make.leading.equalTo(titleLabel.snp.trailing)
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


extension RenterMineViewController {
    @objc func requestUserMessage() {
        var params = [String:AnyObject]()
        params["token"] = UserTool.shared.user_token as AnyObject?
        
        SSNetworkTool.SSMine.request_getUserMsg(params: params, success: {[weak self] (response) in

            guard let weakSelf = self else {return}

            if let model = LoginUserModel.deserialize(from: response, designatedPath: "data") {
                
                weakSelf.userModel = model
                
                UserTool.shared.user_uid = model.userId
                UserTool.shared.user_name = model.realname
                UserTool.shared.user_nickname = model.nickname
                UserTool.shared.user_avatars = model.avatar
                UserTool.shared.user_company = model.company
                UserTool.shared.user_job = model.job
                UserTool.shared.user_sex = model.sex
                UserTool.shared.user_phone = model.phone
                UserTool.shared.user_wechat = model.wxId
                
                SSTool.invokeInMainThread {
                    weakSelf.headerView.userModel = model
                    weakSelf.reloadRCUserInfo()
                }

            }
            
            }, failure: {[weak self] (error) in
                
        }) {[weak self] (code, message) in
            
            //只有5000 提示给用户
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" {
                AppUtilities.makeToast(message)
            }
        }
    }
    
       /*
       * 强制刷新用户信息
       * SDK 缓存操作
       * 1、刷新 SDK 缓存
    */
       func reloadRCUserInfo() {
           let info = RCUserInfo.init(userId: "\(UserTool.shared.user_uid ?? 0)", name: UserTool.shared.user_name ?? "", portrait: UserTool.shared.user_avatars ?? "")
           RCIM.shared()?.refreshUserInfoCache(info, withUserId: "\(UserTool.shared.user_uid ?? 0)")
       }
       
}

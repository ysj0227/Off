//
//  RenterMineSettingViewController.swift
//  OfficeGo
//
//  Created by mac on 2020/5/18.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class RenterMineSettingViewController: BaseTableViewController {
    
    var typeSourceArray:[SettingConfigureModel] = {
        var arr = [SettingConfigureModel]()
//        arr.append(SettingConfigureModel.init(types: .RenterSettingTypeAccountAndBind))
//        arr.append(SettingConfigureModel.init(types: .RenterSettingTypeNoticifyAndAlert))
//        arr.append(SettingConfigureModel.init(types: .RenterSettingTypePrivacySetting))
//        arr.append(SettingConfigureModel.init(types: .RenterSettingTypeHello))
        arr.append(SettingConfigureModel.init(types: .RenterSettingTypeVersionUpdate))
        arr.append(SettingConfigureModel.init(types: .RenterSettingTypeRoleChange))
        return arr
    }()
    
    
    var LogotView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: kWidth, height: 84))
        let btn = UIButton.init(frame: CGRect(x: left_pending_space_17, y: 40, width: kWidth - left_pending_space_17 * 2, height: btnHeight_44))
        btn.backgroundColor = kAppWhiteColor
        btn.clipsToBounds = true
        btn.layer.cornerRadius = button_cordious_2
        btn.setTitle("退出登录", for: .normal)
        btn.setTitleColor(kAppColor_333333, for: .normal)
        btn.titleLabel?.font = FONT_15
        btn.addTarget(self, action: #selector(logotClick), for: .touchUpInside)
        view.addSubview(btn)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        
        setUpData()
        
    }
    
}


extension RenterMineSettingViewController {
    
    @objc func logotClick() {
        
        showLogotAlertview()
    }
    
    func setUpView() {
        
        self.tableView.backgroundColor = kAppColor_line_EEEEEE
        
        titleview = ThorNavigationView.init(type: .backTitleRight)
        titleview?.titleLabel.text = "设置"
        titleview?.rightButton.isHidden = true
        titleview?.leftButtonCallBack = { [weak self] in
            self?.leftBtnClick()
        }
        self.view.addSubview(titleview ?? ThorNavigationView.init(type: .backTitleRight))
        
        self.tableView.snp.remakeConstraints { (make) in
            make.top.equalTo(kNavigationHeight)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        self.tableView.tableFooterView = LogotView
        
        self.tableView.register(RenterSettingCell.self, forCellReuseIdentifier: RenterSettingCell.reuseIdentifierStr)
    }
    
    func setUpData() {
        self.tableView.reloadData()
    }
    
    
    func requestVersionUpdate() {
        
       SSNetworkTool.SSVersion.request_version(success: { [weak self] (response) in

           if let model = VersionModel.deserialize(from: response, designatedPath: "data") {
            self?.showUpdateAlertview(versionModel: model)
           }
           }, failure: { (error) in
            
       }) {(code, message) in
           //只有5000 提示给用户
           if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" {
               AppUtilities.makeToast(message)
           }

        }
               
    }
    
    //弹出版本更新弹框
    func showUpdateAlertview(versionModel: VersionModel) {
        let alert = SureAlertView(frame: self.view.frame)
        alert.inputTFView.text = versionModel.desc ?? ""
        alert.isHiddenVersionCancel = versionModel.force ?? false
        alert.ShowAlertView(withalertType: AlertType.AlertTypeVersionUpdate, message: "版本更新", cancelButtonCallClick: {
            
        }) {
            if let url = URL(string: versionModel.uploadUrl ?? "") {
                if UIApplication.shared.canOpenURL(url) {
                    if #available(iOS 10, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler:nil)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            }
        }
    }
    
    func showLogotAlertview() {
        let alert = SureAlertView(frame: self.view.frame)
        alert.inputTFView.text = "您是否要退出登录？"
        alert.ShowAlertView(withalertType: AlertType.AlertTypeVersionUpdate, message: "温馨提示", cancelButtonCallClick: {
            
        }) {
            
            //退出登录 - 判断是业主还是租户
            //业主- 直接退出登录 -
            //租户- 返回个人中心 - 个人中心状态刷新为未登录
            /// role 角色 用户身份类型,,0:租户,1:业主,9:其他
            if UserTool.shared.user_id_type == 0 {
                //不清空身份类型
                UserTool.shared.removeAll()
                self.leftBtnClick()

            }else if UserTool.shared.user_id_type == 1 {
                NotificationCenter.default.post(name: NSNotification.Name.UserLogout, object: nil)
            }
        }
    }
}

extension RenterMineSettingViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RenterSettingCell.reuseIdentifierStr) as? RenterSettingCell
        cell?.selectionStyle = .none
        cell?.model = typeSourceArray[indexPath.row]
        return cell ?? RenterSettingCell.init(frame: .zero)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return typeSourceArray.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return RenterSettingCell.rowHeight()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let type = typeSourceArray[indexPath.row].type {
            switch type {
            case .RenterSettingTypeAccountAndBind:
                break
            case .RenterSettingTypeNoticifyAndAlert:
                break
            case .RenterSettingTypePrivacySetting:
                break
            case .RenterSettingTypeHello:
                break
            case .RenterSettingTypeVersionUpdate:
                requestVersionUpdate()
            case .RenterSettingTypeRoleChange:
                break
            }
        }
    }
}

class RenterSettingCell: BaseTableViewCell {
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_14
        view.textColor = kAppColor_333333
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
    
    var model: SettingConfigureModel = SettingConfigureModel(types: RenterSettingType.RenterSettingTypeRoleChange) {
        didSet {
            titleLabel.text = model.getNameFormType(type: model.type ?? RenterSettingType.RenterSettingTypeRoleChange)
            if model.type == RenterSettingType.RenterSettingTypeRoleChange {
                lineView.isHidden = true
            }else {
                lineView.isHidden = false
            }
        }
    }
    
    func setupViews() {
        
        addSubview(titleLabel)
        addSubview(detailIcon)
        addSubview(lineView)
        
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(left_pending_space_17)
            make.centerY.equalToSuperview()
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

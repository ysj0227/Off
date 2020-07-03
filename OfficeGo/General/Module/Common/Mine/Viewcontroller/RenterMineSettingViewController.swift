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
        arr.append(SettingConfigureModel.init(types: .RenterSettingTypeChangePhone))
        //目前隐藏微信授权
        //arr.append(SettingConfigureModel.init(types: .RenterSettingTypeChangeWechat))
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
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
    
    func showLogotAlertview() {
        let alert = SureAlertView(frame: self.view.frame)
        alert.ShowAlertView(withalertType: AlertType.AlertTypeMessageAlert, title: "温馨提示", descMsg: "是否确定退出？", cancelButtonCallClick: {
            
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
                NotificationCenter.default.post(name: NSNotification.Name.OwnerUserLogout, object: nil)
            }
        }
    }
    
    ///切换身份ui
    func roleChangeClick() {
        
        let alert = SureAlertView(frame: self.view.frame)
        var aelrtMsg: String = ""
        if UserTool.shared.user_id_type == 0 {
            aelrtMsg = "是否确认切换为业主？"

        }else if UserTool.shared.user_id_type == 1 {
            aelrtMsg = "是否确认切换为租户？"
        }
        alert.ShowAlertView(withalertType: AlertType.AlertTypeMessageAlert, title: "温馨提示", descMsg: aelrtMsg, cancelButtonCallClick: {
            
        }) { [weak self] in
            
            self?.requestRoleChange()
        }
    }
    
    ///切换身份接口
    func requestRoleChange() {
        var params = [String:AnyObject]()
        if UserTool.shared.user_id_type == 0 {
            params["roleType"] = "1" as AnyObject?
        }else if UserTool.shared.user_id_type == 1 {
            params["roleType"] = "0" as AnyObject?
        }
        params["token"] = UserTool.shared.user_token as AnyObject?

        SSNetworkTool.SSMine.request_roleChange(params: params, success: { (response) in
            if let model = LoginModel.deserialize(from: response, designatedPath: "data") {
                UserTool.shared.user_id_type = model.rid
                UserTool.shared.user_rongyuntoken = model.rongyuntoken
                UserTool.shared.user_uid = model.uid
                UserTool.shared.user_token = model.token
                UserTool.shared.user_avatars = model.avatar
                UserTool.shared.user_name = model.nickName
                NotificationCenter.default.post(name: NSNotification.Name.UserRoleChange, object: nil)
            }
        }, failure: {[weak self] (error) in
                

        }) {[weak self] (code, message) in
            //只有5000 提示给用户
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" {
                AppUtilities.makeToast(message)
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
            case .RenterSettingTypeNoticifyAndAlert:
                break
            case .RenterSettingTypePrivacySetting:
                break
            case .RenterSettingTypeHello:
                break
            case .RenterSettingTypeVersionUpdate:
                requestVersionUpdate()
            case .RenterSettingTypeRoleChange:
                roleChangeClick()
            case .RenterSettingTypeChangePhone:
                let vc = RenterChangePhoneViewController()
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case .RenterSettingTypeChangeWechat:
                let vc = RenterChangeWechatViewController()
                self.navigationController?.pushViewController(vc, animated: true)
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
    lazy var numDescLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .right
        view.font = FONT_12
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
    
    var model: SettingConfigureModel = SettingConfigureModel(types: RenterSettingType.RenterSettingTypeRoleChange) {
        didSet {
            titleLabel.text = model.getNameFormType(type: model.type ?? RenterSettingType.RenterSettingTypeRoleChange)
            
            if model.type == RenterSettingType.RenterSettingTypeRoleChange {
                lineView.isHidden = true
                if UserTool.shared.user_id_type == 0 {
                    numDescLabel.text = "切换为业主"
                }else if UserTool.shared.user_id_type == 1 {
                    numDescLabel.text = "切换为租户"
                }
            }else {
                lineView.isHidden = false
                if model.type == RenterSettingType.RenterSettingTypeChangePhone {
                    numDescLabel.text = UserTool.shared.user_phone?.getSecretPhoneString()
                }else if model.type == RenterSettingType.RenterSettingTypeChangeWechat {
                    numDescLabel.text = UserTool.shared.user_wechat
                }else if model.type == RenterSettingType.RenterSettingTypeVersionUpdate {
                    numDescLabel.text = "v" + SSTool.getVersion()
                }
            }
        }
    }
    
    func setupViews() {
        
        addSubview(titleLabel)
        addSubview(numDescLabel)
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
        
        numDescLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(detailIcon.snp.leading).offset(-9)
            make.centerY.equalToSuperview()
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

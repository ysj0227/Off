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
        arr.append(SettingConfigureModel.init(types: .RenterSettingTypeAccountAndBind))
        arr.append(SettingConfigureModel.init(types: .RenterSettingTypeNoticifyAndAlert))
        arr.append(SettingConfigureModel.init(types: .RenterSettingTypePrivacySetting))
        arr.append(SettingConfigureModel.init(types: .RenterSettingTypeHello))
        arr.append(SettingConfigureModel.init(types: .RenterSettingTypeVersionUpdate))
        arr.append(SettingConfigureModel.init(types: .RenterSettingTypeRoleChange))
        return arr
    }()
    
    
    var LogotView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: kWidth, height: 84))
        let btn = UIButton.init(frame: CGRect(x: left_pending_space_17, y: 40, width: kWidth - left_pending_space_17 * 2, height: btnHeight_44))
        btn.backgroundColor = kAppWhiteColor
        btn.clipsToBounds = true
        btn.layer.cornerRadius = button_cordious
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
        //退出登录
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
            make.bottom.equalToSuperview().offset(-kStatusBarHeight)
        }
        self.tableView.tableFooterView = LogotView
        
        self.tableView.register(RenterSettingCell.self, forCellReuseIdentifier: RenterSettingCell.reuseIdentifierStr)
    }
    
    func setUpData() {
        self.tableView.reloadData()
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

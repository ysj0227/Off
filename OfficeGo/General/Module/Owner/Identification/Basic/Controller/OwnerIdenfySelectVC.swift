//
//  OwnerIdenfySelectVC.swift
//  OfficeGo
//
//  Created by mac on 2020/7/10.
//  Copyright © 2020 Senwei. All rights reserved.
//

class OwnerIdenfySelectVC: BaseTableViewController {
    //身份类型0个人1企业2联合
    var selectedIndex: Int = 999 {
        didSet {
            if selectedIndex == 0 {
                UserTool.shared.user_owner_identifytype = 1
            }else if selectedIndex == 1 {
                UserTool.shared.user_owner_identifytype = 2
            }else if selectedIndex == 2 {
                UserTool.shared.user_owner_identifytype = 0
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        
        titleview = ThorNavigationView.init(type: .messageTitleSearchBarSearchBtn)
        titleview?.titleLabel.snp.remakeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.equalTo(80)
            make.leading.equalToSuperview().inset(17)
        }
        titleview?.rightButton.isHidden = true
        titleview?.searchBarView.isHidden = true
        titleview?.leftButton.isHidden = true
        titleview?.titleLabel.text = "业主认证"
        self.view.addSubview(titleview ?? ThorNavigationView.init(type: .backTitleRight))
        
        
        let backBtn = UIButton()
        backBtn.titleLabel?.font = FONT_16
        backBtn.setTitle("返回租户", for: .normal)
        backBtn.setImage(UIImage.init(named: "backRenter"), for: .normal)
        backBtn.setTitleColor(kAppBlueColor, for: .normal)
        self.view.addSubview(backBtn)
        backBtn.layoutButton(.imagePositionLeft, margin: 4)

        backBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(29+14)
            make.width.equalTo(85+29)
            make.height.equalTo(30)
            make.bottom.equalToSuperview().offset(-bottomMargin() - 34)
        }
        
        let bgView = UIView(frame: CGRect(x: 0, y: 0, width: kWidth, height: 64))
        let view = UILabel(frame: CGRect(x: 0, y: 20, width: kWidth, height: 44))
        view.textAlignment = .center
        view.font = FONT_16
        view.textColor = kAppColor_333333
        view.text = "请选择您的身份"
        bgView.addSubview(view)
        self.tableView.tableHeaderView = bgView
        
        self.tableView.snp.remakeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(kNavigationHeight)
            make.bottom.equalTo(backBtn.snp.top)
        }
        self.tableView.register(OwnerIdentifySelectCell.self, forCellReuseIdentifier: OwnerIdentifySelectCell.reuseIdentifierStr)
    }
    
}
extension OwnerIdenfySelectVC {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OwnerIdentifySelectCell.reuseIdentifierStr) as? OwnerIdentifySelectCell
        cell?.selectionStyle = .none
        var img: String = ""
        if indexPath.row == 0 {
            cell?.typeLabel.text = "我是公司业主"
            if selectedIndex == indexPath.row {
                img = "companyIdentify"
            }else {
                img = "companyIdentify"
            }
            cell?.typeImg.image = UIImage(named: img)
        }else if indexPath.row == 1 {
            cell?.typeLabel.text = "我是联合办公业主"
            if selectedIndex == indexPath.row {
                img = "jointIdentify"
            }else {
                img = "jointIdentify"
            }
            cell?.typeImg.image = UIImage(named: img)
        }else if indexPath.row == 2 {
            cell?.typeLabel.text = "我是个人业主"
            if selectedIndex == indexPath.row {
                img = "personalIedntify"
            }else {
                img = "personalIedntify"
            }
            cell?.typeImg.image = UIImage(named: img)
        }
        
        return cell ?? RoleSelectTableViewCell.init(frame: .zero)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (kWidth - 29 * 2) * 156 / 317.0 + 29
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedIndex = indexPath.row
        
        if indexPath.row == 0 {
            let vc = OwnerCompanyIeditnfyVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 1 {
            let vc = OwnerJointIeditnfyVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 2 {
            let vc = OwnerPersonalIeditnfyVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }

    }
}
class OwnerIdentifySelectCell: BaseTableViewCell {
    
    lazy var typeImg: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var typeLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_14
        view.textColor = kAppColor_333333
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
           super.init(style: style, reuseIdentifier: reuseIdentifier)
           setupViews()
       }
       
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        addSubview(typeImg)
//        addSubview(typeLabel)
        
        typeImg.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: kWidth - 29 * 2, height: (kWidth - 29 * 2) * 156 / 317.0))
        }
        
//        typeLabel.snp.makeConstraints { (make) in
//            make.bottom.equalTo(typeImg.snp.bottom).offset(-15)
//            make.centerX.equalToSuperview()
//        }
    }
    

}
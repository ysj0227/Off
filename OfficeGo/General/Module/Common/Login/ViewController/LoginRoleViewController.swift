//
//  LoginRoleViewController.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/4/27.
//  Copyright © 2020 Senwei. All rights reserved.
//

class LoginRoleViewController: BaseTableViewController {
    
    //0:租户,1:业主,9:其他
    var selectedIndex: Int = 999 {
        didSet {
            UserTool.shared.user_id_type = selectedIndex
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
        
        titleview = ThorNavigationView.init(type: .backTitleRight)
        titleview?.leftButton.isHidden = true
        titleview?.titleLabel.text = "选择身份"
        titleview?.backgroundColor = kAppWhiteColor
        self.view.addSubview(titleview ?? ThorNavigationView.init(type: .backTitleRight))
        
        self.tableView.snp.updateConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(kNavigationHeight)
        }
        self.tableView.register(UINib.init(nibName: RoleSelectTableViewCell.reuseIdentifierStr, bundle: nil), forCellReuseIdentifier: RoleSelectTableViewCell.reuseIdentifierStr)
    }
    
}
extension LoginRoleViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RoleSelectTableViewCell.reuseIdentifierStr) as? RoleSelectTableViewCell
        cell?.selectionStyle = .none
        var img: String = ""
        if indexPath.row == 0 {
            //            cell?.titleLab.text = "我要租房"
            //            if cell?.isSelected ?? false {
            //                img = "IAmRenterSel"
            //            }else {
            //                img = "IAmRenter"
            //            }
            if selectedIndex == indexPath.row {
                img = "IAmRenterSel"
            }else {
                img = "IAmRenter"
            }
            cell?.bgImg.image = UIImage(named: img)
        }else {
            cell?.titleLab.text = "我是房东"
            if selectedIndex == indexPath.row {
                img = "IAmYezhuSel"
            }else {
                img = "IAmYezhu"
            }
            cell?.bgImg.image = UIImage(named: img)
        }
        
        return cell ?? RoleSelectTableViewCell.init(frame: .zero)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return (kWidth - 18)*250 / 302.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedIndex = indexPath.row
        
        SSTool.invokeInMainThread { [weak self] in
            
            self?.tableView.reloadData()
            
            let login = RenterLoginViewController()
            self?.navigationController?.pushViewController(login, animated: true)
        }
        
        
    }
}

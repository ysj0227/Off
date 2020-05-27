//
//  LoginRoleViewController.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/4/27.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class LoginRoleViewController: BaseTableViewController {

    var selectedIndex: Int?
    
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
            cell?.titleLab.text = "我要租房"
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
        
        self.tableView.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { [weak self] in
            if indexPath.row == 1 {
                
            }else {
                let login = ReviewLoginViewController()
                self?.navigationController?.pushViewController(login, animated: true)
            }
        })
        
    }
}

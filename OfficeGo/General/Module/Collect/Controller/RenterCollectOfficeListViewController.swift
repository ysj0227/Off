//
//  RenterCollectOfficeListViewController.swift
//  OfficeGo
//
//  Created by mac on 2020/5/14.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class RenterCollectOfficeListViewController: BaseTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        requestSet()
    }
    override func refreshData() {
        self.dataSource.removeAll()
        
        self.dataSource.append("one")
        self.dataSource.append("one")
        self.dataSource.append("one")
        self.dataSource.append("one")
        headerEndRefreshing()
        isShowRefreshFooter = false
        self.tableView.reloadData()
    }
    
}

extension RenterCollectOfficeListViewController {
    func setupView() {
        self.tableView.register(RenterCollectOfficeCell.self, forCellReuseIdentifier: RenterCollectOfficeCell.reuseIdentifierStr)
    }
}

extension RenterCollectOfficeListViewController {
    
    func requestSet() {
        
        isShowRefreshHeader = false
        
        refreshData()
    }
}

extension RenterCollectOfficeListViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RenterCollectOfficeCell.reuseIdentifierStr) as? RenterCollectOfficeCell
        cell?.selectionStyle = .none
        cell?.itemModel = ""
        if indexPath.row % 2 == 0 {
            cell?.isDuliOffice = true
        }else {
            cell?.isDuliOffice = false
        }
        return cell ?? HouseListTableViewCell.init(frame: .zero)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return RenterCollectOfficeCell.rowHeight()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = FangYuanListModel()
        let vc = RenterOfficebuildingJointDetailVC()
        if indexPath.row == 0  {
            model.btype = 1
        }else if indexPath.row == 1  {
            model.btype = 2
        }
        vc.model = model
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

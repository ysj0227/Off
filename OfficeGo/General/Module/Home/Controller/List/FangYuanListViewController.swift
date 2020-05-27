//
//  FangYuanListViewController.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/5/8.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class FangYuanListViewController: BaseTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //接收筛选条件
//        NotificationCenter.default.addObserver(forName: NSNotification.Name.HomeBtnLocked, object: nil, queue: OperationQueue.main) { [weak self] (noti) in
//            
//            let lock = noti.object as! Bool
//            if lock == true {
//                
//            }else {
//                
//            }
//        }
        
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
    
    override func loadMoreData() {
        self.dataSource.append("one")
        self.dataSource.append("one")
        self.dataSource.append("one")
        self.dataSource.append("one")
        self.dataSource.append("one")
        self.dataSource.append("one")
        self.dataSource.append("one")
        self.dataSource.append("one")
        self.dataSource.append("one")
        self.dataSource.append("one")
        self.dataSource.append("one")
        self.dataSource.append("one")
        footerEndRefreshing()
        isShowRefreshFooter = true
        self.tableView.reloadData()
    }
    
}

extension FangYuanListViewController {
    
    func requestSet() {
        
        isShowRefreshHeader = false
        
        refreshData()
        
        self.tableView.register(UINib.init(nibName: HouseListTableViewCell.reuseIdentifierStr, bundle: nil), forCellReuseIdentifier: HouseListTableViewCell.reuseIdentifierStr)
    }
    
    
}

extension FangYuanListViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HouseListTableViewCell.reuseIdentifierStr) as? HouseListTableViewCell
        cell?.selectionStyle = .none
        let model = FangYuanListModel()
        if indexPath.row == 0 {
            model.houseType = 1
        }else if indexPath.row == 1 {
            model.houseType = 2
        }
        
        cell?.model = model
        return cell ?? HouseListTableViewCell.init(frame: .zero)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return HouseListTableViewCell.rowHeight()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = FangYuanListModel()
        let vc = RenterOfficebuildingJointDetailVC()
        if indexPath.row == 0  {
            model.houseType = 1
        }else if indexPath.row == 1  {
            model.houseType = 2
        }
        vc.model = model
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


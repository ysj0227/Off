//
//  BaseTableViewController.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/4/27.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit
import MJRefresh

class BaseTableViewController: BaseViewController {
    
    var dataSource: [Any?] = []
//    {
//           didSet {
//            self.tableView.reloadData()
//           }
//       }
    let tableView: UITableView = {
           let view = UITableView.init(frame: .zero, style: .plain)
        view.backgroundColor = kAppWhiteColor
           view.separatorStyle = .none
           view.estimatedRowHeight = 0
           return view
       }()
    
    var isShowRefreshHeader: Bool = true {
        didSet {
            if isShowRefreshHeader == true {
                tableView.mj_header?.isHidden = true
            }else {
                tableView.mj_header?.isHidden = false
            }
        }
    }
    
    var isShowRefreshFooter: Bool = true {
        didSet {
            if isShowRefreshFooter == true {
                tableView.mj_footer?.isHidden = true
            }else {
                tableView.mj_footer?.isHidden = false
            }
        }
    }
    
    func reloadTableview() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(headRefreshAction))
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(footerRefreshAction))
        
        isShowRefreshHeader = true
        
        isShowRefreshFooter = true

        
        tableView.snp.makeConstraints { (make) in
            make.top.leading.bottom.trailing.equalToSuperview()
        }
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
    }
    
    @objc func headRefreshAction(){
           if tableView.mj_header?.isRefreshing == true {
//               DispatchQueue.main.asyncAfter(deadline: .now()+1.5, execute:{ [weak self] in
//                   self?.tableView.mj_header?.endRefreshing()
//               })
            AppUtilities.makeToast("加载中")

            refreshData()
           }
       }
       
       @objc func footerRefreshAction(){
           if tableView.mj_footer?.isRefreshing == true {
//               DispatchQueue.main.asyncAfter(deadline: .now()+1.5, execute:{ [weak self] in
//                   self?.tableView.mj_footer?.endRefreshing()
//               })
            AppUtilities.makeToast("加载中")

            loadMoreData()
           }
       }
    
    @objc func headerEndRefreshing() {
        self.tableView.mj_header?.endRefreshing()

    }
    
    @objc func footerEndRefreshing() {
        self.tableView.mj_footer?.endRefreshing()
    }

    @objc func refreshData() {
        
    }
    
    @objc func loadMoreData() {
          
    }
}
extension BaseTableViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell.init(frame: .zero)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

}

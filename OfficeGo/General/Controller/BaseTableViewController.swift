//
//  BaseTableViewController.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/4/27.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit
import MJRefresh
//import DZNEmptyDataSet

class BaseTableViewController: BaseViewController {
    
    var dataSource: [Any?] = []
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
    
    // 页码
    public var pageNo: Int = 1
    
    /// 每页加载数
    public var pageSize: Int = 10
    
    /// 是否自动刷新
    public var refreshWhenLoad:Bool = true
    
    // 是否显示空数据页面
    public var haveData:Bool = true
    
    func reloadTableview() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(loadNewData))
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadNextPage))
        
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
        
        self.view.addSubview(noDataView)
        noDataView.isHidden = true
        noDataView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 100, height: 100))
        }
        noDataImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-30)
            make.size.equalTo(CGSize(width: 100, height: 100))
        }
        noDataLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.size.equalTo(CGSize(width: 100, height: 30))
        }
        
    }
    
    @objc func loadNewData(){
            
        pageNo = 1
        
        if self.dataSource.count > 0 {
            self.dataSource.removeAll()
        }
        
        AppUtilities.makeToast("加载中")
        
        refreshData()
    }
    
    @objc func headerEndRefreshing() {
        self.tableView.mj_header?.endRefreshing()
        
    }
    
    /// 结束刷新
    public func endRefreshAnimation() {
        endRefreshWithCount(0)
    }
    
    func noDataViewSet() {
        if self.dataSource.count > 0 {
            noDataView.isHidden = true
        }else {
            noDataView.isHidden = false
        }
    }
    
    public func endRefreshWithCount(_ count: Int) {
        
        noDataViewSet()
        
        haveData = self.dataSource.count > 0 ? true : false
        reloadData()
        
        guard let header = tableView.mj_header else {
            return
        }
        if (header.isRefreshing) {
            tableView.mj_header?.endRefreshing()
        }
        guard let footer = tableView.mj_footer else {
            return
        }
        if (footer.isRefreshing) {
            tableView.mj_footer?.endRefreshing()
        }
        
        let isNoMoreData = count < pageSize || count == 0
        tableView.mj_footer?.isHidden = isNoMoreData
        
    }
    /// MARK: 刷新事件
    private func reloadData() {
        tableView.reloadData()
        //            tableView.reloadEmptyDataSet()
    }
    
    @objc func footerEndRefreshing() {
        self.tableView.mj_footer?.endRefreshing()
    }
    
    /// 刷新数据
    @objc func refreshData() {
        
    }
    
    @objc func loadNextPage() {
        AppUtilities.makeToast("加载中")
        pageNo += 1
        refreshData()
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
//extension  BaseTableViewController : DZNEmptyDataSetSource,DZNEmptyDataSetDelegate {
//    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
//        return UIImage.init(named: "empty_placeholde_happy_image")
//    }
//
//    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
//        let text = "暂无数据"
//        let attributes:[NSAttributedStringKey:AnyObject] = [NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): UIFont.systemFont(ofSize: 14),NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.init(hexString: "3c3e42")!]
//        return NSAttributedString.init(string: text, attributes: attributes)
//
//    }
//
//    func buttonImage(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> UIImage! {
//        return UIImage(named: "")
//    }
//
//    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
//
//    }
//
//    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
//         return !haveData
//    }
//
//    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
//        return true
//    }
//
//}

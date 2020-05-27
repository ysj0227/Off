//
//  JHBaseTableViewController.swift
//  JHToolsModule_Swift
//
//  Created by DENGFei on 2020/4/26.
//  Copyright © 2020 dengfei. All rights reserved.
//

import UIKit
import SnapKit
open class JHTableViewController: JHViewController ,UITableViewDelegate,UITableViewDataSource{
    // MARK: - 参数变量
    public enum TableViewStyleType {
        case StylePlain
        case StyleGrouped
        @available(iOS 13.0, *)
        case StyleInsetGrouped
    }
    
    public var tableView : UITableView?
    public var mainDatas : Array<Any> = []
    public var tableViewStyleType : TableViewStyleType = .StylePlain

    // MARK: - 初始化
    public convenience init(tableViewStyle: TableViewStyleType = .StylePlain) {
        self.init()
        self.tableViewStyleType = tableViewStyle
    }
    
    /// 子类继承时重写此方法可设置Table样式：self.tableViewStyleType =  .StyleGrouped，或者Init时候设置
    open func configTableViewStyleType(){
//        self.tableViewStyleType = tableViewStyleType
    }
    
    // MARK: - 布局
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        configTableViewStyleType()
        
        switch self.tableViewStyleType {
        case .StyleInsetGrouped:
            if #available(iOS 13.0, *) {
                self.tableView = UITableView.init(frame: .zero, style: .insetGrouped)
            }else{
                self.tableView = UITableView.init(frame: .zero, style: .grouped)
            }
            
        case .StyleGrouped:
            self.tableView = UITableView.init(frame: .zero, style: .grouped)
            
        case .StylePlain:
            self.tableView = UITableView.init(frame: .zero, style: .plain)
            
        }

        self.tableView?.backgroundColor = .clear
        self.tableView?.delegate = self
        self.tableView?.dataSource = self

        self.tableView?.separatorStyle = .none
//        self.tableView?.separatorColor = .lightGray
        self.tableView?.showsVerticalScrollIndicator = false
        self.tableView?.showsHorizontalScrollIndicator = false
        self.tableView?.estimatedRowHeight = 100
        self.tableView?.rowHeight = UITableView.automaticDimension
        self.tableView?.estimatedSectionHeaderHeight = CGFloat.leastNormalMagnitude
        self.tableView?.estimatedSectionFooterHeight = CGFloat.leastNormalMagnitude
            //头角需要自适应高度的话请设置
        //    self.tableView.estimatedSectionHeaderHeight = 200;
        //    self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
        //    self.tableView.estimatedSectionFooterHeight = 200;
        //    self.tableView.sectionFooterHeight = UITableViewAutomaticDimension;
        self.tableView?.delaysContentTouches = true
        // Do any additional setup after loading the view.
        self.view.addSubview(self.tableView!)

        if #available(iOS 11.0, *) {
            self.tableView?.snp.makeConstraints({ (make) in
                make.top.equalTo(self.view.safeAreaInsets.top );
                make.left.equalTo(self.view.safeAreaInsets.left);
                make.right.equalTo(self.view.safeAreaInsets.right);
                make.bottom.equalTo(self.view.safeAreaInsets.bottom);
            })
        }else {
            self.tableView?.snp.makeConstraints({ (make) in
                make.top.equalToSuperview()
                make.left.equalToSuperview()
                make.right.equalToSuperview()
                make.bottom.equalToSuperview()
            })
        }
        
        
        self.extendedLayoutIncludesOpaqueBars = true
        if #available(iOS 11.0, *) {
            self.tableView?.contentInsetAdjustmentBehavior = .automatic
        } else {
            // Fallback on earlier versions
        }

        let gestureArray : [UIGestureRecognizer]? = self.navigationController?.view.gestureRecognizers
        
        gestureArray?.forEach({ (gesture) in
            if gesture.isEqual(UIScreenEdgePanGestureRecognizer.self) {
                self.tableView?.panGestureRecognizer.require(toFail: gesture)
            }
        })
        
        JHTableViewCell.registerCell(tableView: self.tableView!)
        
    }
    // MARK: - 数据源判断
    func isMultiDatas() -> Bool {
        let data = self.mainDatas.first
        if data is Array<Any> && self.mainDatas.count > 0{
            return true
        }else{
            return false
        }
    }
    
     // MARK: - tableView代理
    open func numberOfSections(in tableView: UITableView) -> Int {
        return self.isMultiDatas() ? self.mainDatas.count : 1
    }
    
    open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView.init()
    }
    open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView.init()
    }
    
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.isMultiDatas() {
            let data  = self.mainDatas[section] as! Array<Any>
            return data.count
        }else{
          return self.mainDatas.count
        }
     }
     
     open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = JHTableViewCell.dequeueReusableCell(tableView: tableView) ?? JHTableViewCell.init(style: .default)
        cell.textLabel?.text = String.init(describing: indexPath.row)
        return cell
     }
}

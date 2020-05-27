//
//  UITableViewSnapEx.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/4/26.
//  Copyright © 2020 dengfei. All rights reserved.
//

import UIKit

public extension UITableView {
    
    /// 快速初始化UITableView 包含默认参数,初始化过程可以删除部分默认参数简化方法
    /// - Parameters:
    ///   - supView: 被添加的位置 有默认参数
    ///   - snapKitMaker: SnapKit 有默认参数
    ///   - style: 列表样式 有默认参数
    ///   - delegate: delegate 
    ///   - dataSource: dataSource
    ///   - backColor: 背景色
    @discardableResult
    class func snpTableView(supView: UIView? = nil,
                            snapKitMaker : JHSnapKitTool.JHSnapMaker? = nil,
                            style: UITableView.Style = .plain,
                            delegate: UITableViewDelegate,
                            dataSource: UITableViewDataSource,
                            backColor: UIColor) -> UITableView{
        
        let tableView = UITableView.init(frame: .zero, style: style)
        tableView.delegate = delegate
        tableView.dataSource = dataSource
        tableView.backgroundColor = backColor
        
        tableView.separatorStyle = .none
        //        self.tableView?.separatorColor = .lightGray
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        
        tableView.delaysContentTouches = true
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .automatic
        } else {
            // Fallback on earlier versions
        }
        
        guard let sv = supView, let maker = snapKitMaker else {
            return tableView
        }
        
        sv.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            maker(make)
        }
        
        return tableView
    }
    
}

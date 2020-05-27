//
//  JHTableViewHeaderFooterView.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/4/26.
//  Copyright © 2020 dengfei. All rights reserved.
//

import UIKit

open class JHTableViewHeaderFooterView: UITableViewHeaderFooterView {

    public var backColor : UIColor? {
        didSet{
            self.backgroundView?.backgroundColor = backColor
        }
    }
    
    public override init(reuseIdentifier: String? = String.init(describing: self)) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.backgroundView = UIView(frame: self.bounds)
        self.backgroundView?.backgroundColor = .clear
        self.configCellViews()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - 继承 在内部实现布局
    open func configCellViews() {
        
    }
    // MARK: - cell赋值
    open func setCellModel(model: Any) {
        
    }
    // MARK: - 获取高度
    public func getCellHeightWithModel(model: Any) -> CGFloat {
        self.setCellModel(model: model)
        self.layoutIfNeeded()
        self.updateConstraintsIfNeeded()
        let height = self.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        return height
    }
    
    // MARK: - 注册
    public class func registerHeaderFooterView(tableView: UITableView, reuseIdentifier: String = String.init(describing: self)) {
        tableView.register(self, forHeaderFooterViewReuseIdentifier: reuseIdentifier)
    }
    // MARK: - 复用取值
    public class func dequeueReusableHeaderFooterView(tableView: UITableView, reuseIdentifier: String = String.init(describing: self)) ->UITableViewHeaderFooterView?{
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: reuseIdentifier)
    }
}

//
//  UIScrollViewExtension.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/4/26.
//  Copyright © 2020 Senwei. All rights reserved.
//

import Foundation
import UIKit

extension UIScrollView {
    
    static let kEmptyContentViewKey = UnsafeRawPointer.init(bitPattern: "EmptyContentViewKey".hashValue)!
    
    var emptyContentView: EmptyContentView? {
        get {
            return objc_getAssociatedObject(self, UIScrollView.kEmptyContentViewKey) as? EmptyContentView
        }
        set {
            objc_setAssociatedObject(self, UIScrollView.kEmptyContentViewKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func showEmptyContentView(type: EmptyContentView.ViewType, topAdditional: CGFloat = 0) {
        emptyContentView?.isHidden = false
        let top = topAdditional;
        if emptyContentView == nil || emptyContentView?.viewType != type {
            emptyContentView?.removeFromSuperview()
            let view = EmptyContentView(type: type)
            emptyContentView = view
            addSubview(view)
            view.snp.makeConstraints { (make) in
                make.leading.equalToSuperview()
                make.top.greaterThanOrEqualTo(top)
                make.centerY.greaterThanOrEqualTo(top + (self.frame.height - top) / 10 * 3)
                make.width.equalToSuperview()
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            if let view = self.emptyContentView {
                if self.contentSize.height < top + view.displaySize().height {
                    self.contentSize = CGSize(width: self.frame.width, height: top + view.displaySize().height)
                }
            }
        }
    }
    
    public func hideEmptyContent() {
        emptyContentView?.isHidden = true
    }
}

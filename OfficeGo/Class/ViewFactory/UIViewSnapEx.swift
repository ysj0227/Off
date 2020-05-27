//
//  UIViewSnapExtension.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/4/26.
//  Copyright © 2020 dengfei. All rights reserved.
//

import UIKit

public extension UIView {
    
    @objc internal var snpTapGesture: JHSnapKitTool.JHTapGestureBlock? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.TapGestureKey) as? JHSnapKitTool.JHTapGestureBlock
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.TapGestureKey, newValue, .OBJC_ASSOCIATION_COPY)
        }
    }
    
    /// 快速初始化UIView 包含默认参数,初始化过程可以删除部分默认参数简化方法
    /// - Parameters:
    ///   - supView: 被添加的位置 有默认参数
    ///   - snapKitMaker: SnapKit 有默认参数
    ///   - snpTapGesture: 点击Block 有默认参数
    ///   - backColor: 背景色
    @discardableResult
    class func snpView(supView : UIView? = nil,
                       snapKitMaker : JHSnapKitTool.JHSnapMaker? = nil,
                       snpTapGesture : JHSnapKitTool.JHTapGestureBlock? = nil,
                       backColor: UIColor) -> UIView{
        
        let view = UIView.init()
        view.backgroundColor = backColor
        
        guard let sv = supView, let maker = snapKitMaker else {
            return view
        }
        
        sv.addSubview(view)
        view.snp.makeConstraints { (make) in
            maker(make)
        }
        
        guard let ges = snpTapGesture else {
            return view
        }
        view.snpAddTapGestureWithCallback(snpTapGesture: ges)

        
        return view
    }
    
    @objc func snpAddTapGestureWithCallback(snpTapGesture : JHSnapKitTool.JHTapGestureBlock?){
        self.snpTapGesture = snpTapGesture
        self.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(handleTapGesture))
        self.addGestureRecognizer(tap)
    }
    
    
    @objc func handleTapGesture() {
        if let snpTapGesture =  self.snpTapGesture{
            snpTapGesture(self)
        }
        
    }
    
}

// MARK: - 命名空间方案,废弃,没减少一行代码
//extension UIView: ViewMaker { }
//extension Maker where T: UIView {
//    public func adhere(toSuperView: UIView) -> T {
//        toSuperView.addSubview(makerValue)
//        return makerValue
//    }
//
//    @discardableResult
//    public func layout(snapKitMaker: (ConstraintMaker) -> Void) -> T {
//        makerValue.snp.makeConstraints { (make) in
//            snapKitMaker(make)
//        }
//        return makerValue
//    }
//
//    @discardableResult
//    public func config(_ config: (T) -> Void) -> T {
//        config(makerValue)
//        return makerValue
//    }
//}

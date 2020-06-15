//
//  UIView+Extension.swift
//  MSStudent
//
//  Created by Dengfei on 2018/12/14.
//  Copyright © 2018年 mgss. All rights reserved.
//

import UIKit

extension UIView {
    
    /// 添加阴影
    ///
    /// - Parameters:
    ///   - shadowColor: 阴影颜色
    ///   - offset: 阴影偏移量
    ///   - shadowRadius: 阴影扩散范围
    ///   - opacity: 阴影的透明度
    func shadow(shadowColor: CGColor = kAppColor_999999.cgColor, offset: CGSize = CGSize(width: 5, height: 5), shadowRadius: CGFloat = 5, opacity: Float = 1) {
        self.layer.shadowColor = shadowColor
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = opacity
        self.layer.masksToBounds = false
    }
    func setCornerRadius(cornerRadius:CGFloat, masksToBounds:Bool = true){
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = masksToBounds
    }
    
    /// 添加部分圆角
    func corner(byRoundingCorners corners: UIRectCorner, radii: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radii, height: radii))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
    
    ///
    func currentViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        }else if let nextResponder = self.next as? UIView {
            return nextResponder.currentViewController()
        }else{
            return nil
        }
    }
    
    static func createViewFromNib() -> UIView{
        return self.createViewFromNib(self.className)
    }
    
    static func createViewFromNib(_ name: String) -> UIView {
        let nibs = Bundle.main.loadNibNamed(name, owner: self, options: nil)
        return nibs?.first as! UIView
    }
}

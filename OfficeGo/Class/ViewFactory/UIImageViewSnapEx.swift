//
//  UIImageViewSnapEx.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/4/26.
//  Copyright © 2020 dengfei. All rights reserved.
//

import UIKit

public extension UIImageView {
    
    
    /// 快速初始化UIImageView 包含默认参数,初始化过程可以删除部分默认参数简化方法
    /// - Parameters:
    ///   - supView: 被添加的位置 有默认参数
    ///   - image: 图片对象 有默认参数
    ///   - isClip: 是否裁剪超出视图部分 有默认参数
    ///   - contentMode: contentMode 有默认参数
    ///   - snapKitMaker: SnapKit 有默认参数
    ///   - snpTapGesture: 点击Block 有默认参数
    ///   - backColor: 背景色
    @discardableResult
    class func snpImageView(supView : UIView? = nil,
                            image : UIImage? = nil,
                            isClip : Bool = false,
                            contentMode : UIView.ContentMode  = .scaleAspectFill,
                            snapKitMaker : JHSnapKitTool.JHSnapMaker? = nil,
                            snpTapGesture : JHSnapKitTool.JHTapGestureBlock? = nil,
                            backColor: UIColor) -> UIImageView{
        
        let imageView = UIImageView.init()
        imageView.backgroundColor = backColor
        
        imageView.clipsToBounds = isClip
        imageView.contentMode = contentMode
        
        imageView.image = image
        
        guard let sv = supView, let maker = snapKitMaker else {
            return imageView
        }
        sv.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            maker(make)
        }
        
        guard let ges = snpTapGesture else {
            return imageView
        }
        imageView.snpAddTapGestureWithCallback(snpTapGesture: ges)
        
        
        return imageView
    }
    
}

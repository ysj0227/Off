//
//  UILabelSnapEx.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/4/26.
//  Copyright © 2020 dengfei. All rights reserved.
//

import UIKit

public extension UILabel {
    
    /// 快速初始化UILabel 包含默认参数,初始化过程可以删除部分默认参数简化方法
    /// - Parameters:
    ///   - font: 字体 有默认参数
    ///   - lines: 行数 有默认参数
    ///   - text: 内容 有默认参数
    ///   - textColor: 字体颜色 有默认参数
    ///   - supView: 被添加的位置 有默认参数
    ///   - textAlignment: textAlignment 有默认参数
    ///   - snapKitMaker: SnapKit 有默认参数
    ///   - backColor: 背景色
    @discardableResult
    class func snpLabel(font: UIFont = UIFont.systemFont(ofSize: 14),
                        lines: Int = 0,
                        text: String = "",
                        textColor: UIColor = .black,
                        supView: UIView? = nil,
                        textAlignment: NSTextAlignment = .left,
                        snapKitMaker : JHSnapKitTool.JHSnapMaker? = nil,
                        backColor: UIColor) -> UILabel{
        
        let label = UILabel.init()
        label.text = text
        label.font = font
        label.textAlignment = textAlignment
        label.backgroundColor = backColor
        label.textColor = textColor
        label.numberOfLines = lines
        if lines != 0 {
            label.lineBreakMode = .byTruncatingTail
        }else{
            label.lineBreakMode = .byWordWrapping
        }
        guard let sv = supView, let maker = snapKitMaker else {
            return label
        }
        
        sv.addSubview(label)
        label.snp.makeConstraints { (make) in
            maker(make)
        }
        
        return label
    }
}

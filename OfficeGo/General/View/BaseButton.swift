//
//  BaseButton.swift
//  OfficeGo
//
//  Created by renrenshipin on 2018/9/12.
//  Copyright © 2018年 RRTV. All rights reserved.
//

import UIKit

struct ThorButtonTextColor {
    var normalColor: UIColor?
    var selectedColor: UIColor?
    var disableColor: UIColor?
}

struct ThorButtonText {
    var normalText: String?
    var selectedText: String?
    var disableText: String?
}

struct ThorButtonImageName {
    var normalImageName: String?
    var selectedImageName: String?
    var disableImageName: String?
}

class BaseButton: UIButton {
    
    var b_textColors: ThorButtonTextColor? {
        didSet {
            self.loadTextColor()
        }
    }
    var b_imageNames: ThorButtonImageName? {
        didSet {
            self.loadImageName()
        }
    }
    var b_texts: ThorButtonText? {
        didSet {
            self.loadText()
        }
    }
    
    convenience init (textColors: ThorButtonTextColor? = nil,
                      imageNames: ThorButtonImageName? = nil,
                      texts: ThorButtonText? = nil) {
        self.init(type: .custom)
        self.b_textColors = textColors
        self.b_imageNames = imageNames
        self.b_texts = texts
        self.loadContent()
    }
    
    func loadContent() {
        self.loadText()
        self.loadTextColor()
        self.loadImageName()
    }
    func loadText() {
        if let t_normal = self.b_texts?.normalText {
            self.setTitle(NSLocalizedString(t_normal, comment: ""), for: .normal)
        }
        if let t_select = self.b_texts?.selectedText {
            self.setTitle(NSLocalizedString(t_select, comment: ""), for: .selected)
        }
        if let t_disable = self.b_texts?.disableText {
            self.setTitle(NSLocalizedString(t_disable, comment: ""), for: .disabled)
        }
    }
    
    func loadTextColor() {
        if let c_normal = self.b_textColors?.normalColor {
            self.setTitleColor(c_normal, for: .normal)
        }
        if let c_select = self.b_textColors?.selectedColor {
            self.setTitleColor(c_select, for: .selected)
        }
        if let c_disable = self.b_textColors?.disableColor {
            self.setTitleColor(c_disable, for: .disabled)
        }
    }
    
    func loadImageName() {
        if let i_normal = self.b_imageNames?.normalImageName {
            self.setImage(UIImage.init(named: i_normal), for: .normal)
        }
        if let i_select = self.b_imageNames?.selectedImageName {
            self.setImage(UIImage.init(named: i_select), for: .selected)
        }
        if let i_disable = self.b_imageNames?.disableImageName {
            self.setImage(UIImage.init(named: i_disable), for: .disabled)
        }
    }
}

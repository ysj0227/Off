//
//  BaseLabel.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/4/26.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class BaseLabel: UILabel {
    /// 国际化的string
    var localTitle: String? {
        didSet {
            if let text = localTitle {
                self.text = NSLocalizedString(text, comment: "")
            }
        }
    }
    
    convenience init (localTitle: String? = nil, textColor: UIColor? = nil, textFont: UIFont? = nil) {
        self.init()
        self.localTitle = localTitle
        if let local = localTitle {
            self.text = NSLocalizedString(local, comment: "")
        }
        if let color = textColor {
            self.textColor = color
        }
        if let font  = textFont {
            self.font = font
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

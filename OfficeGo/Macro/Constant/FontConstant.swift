//
//  FontConstant.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/5/8.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

// MARK:- 字体
public let FONT_LIGHT_9 = UIFont.appLight(9)
public let FONT_LIGHT_10 = UIFont.appLight(10)
public let FONT_LIGHT_11 = UIFont.appLight(11)
public let FONT_LIGHT_12 = UIFont.appLight(12)
public let FONT_LIGHT_13 = UIFont.appLight(13)
public let FONT_LIGHT_14 = UIFont.appLight(14)
public let FONT_LIGHT_15 = UIFont.appLight(15)
public let FONT_9 = UIFont.appRegular(9)
public let FONT_10 = UIFont.appRegular(10)
public let FONT_11 = UIFont.appRegular(11)
public let FONT_12 = UIFont.appRegular(12)
public let FONT_13 = UIFont.appRegular(13)
public let FONT_14 = UIFont.appRegular(14)
public let FONT_15 = UIFont.appRegular(15)
public let FONT_16 = UIFont.appRegular(16)
public let FONT_17 = UIFont.appRegular(17)
public let FONT_18 = UIFont.appRegular(18)
public let FONT_19 = UIFont.appRegular(19)
public let FONT_MEDIUM_9 = UIFont.appMeduim(9)
public let FONT_MEDIUM_10 = UIFont.appMeduim(10)
public let FONT_MEDIUM_11 = UIFont.appMeduim(11)
public let FONT_MEDIUM_12 = UIFont.appMeduim(12)
public let FONT_MEDIUM_13 = UIFont.appMeduim(13)
public let FONT_MEDIUM_14 = UIFont.appMeduim(14)
public let FONT_MEDIUM_15 = UIFont.appMeduim(15)
public let FONT_MEDIUM_16 = UIFont.appMeduim(16)
public let FONT_MEDIUM_17 = UIFont.appMeduim(17)
public let FONT_MEDIUM_18 = UIFont.appMeduim(18)
public let FONT_SEMBLOD_11 = UIFont.appSemibold(11)
public let FONT_SEMBLOD_13 = UIFont.appSemibold(13)
public let FONT_SEMBLOD_14 = UIFont.appSemibold(14)
public let FONT_SEMBLOD_16 = UIFont.appSemibold(16)
public let FONT_BOLD_11 = UIFont.appBold(11)

public var SystemMediumFont : (CGFloat) -> UIFont = {size in
    return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.medium)
}
public var SystemFont : (CGFloat) -> UIFont = {size in
    return UIFont.systemFont(ofSize: size)
}

public let textMessageFontSize: CGFloat = 16.0


extension UIFont {
    static func appLight(_ size: CGFloat) -> UIFont {
        return UIFont.init(name: "PingFangSC-Light", size: size) ?? UIFont.systemFont(ofSize: size * 1.3)
    }
    static func appRegular(_ size: CGFloat) -> UIFont {
        return UIFont.init(name: "PingFangSC-Regular", size: size) ?? UIFont.systemFont(ofSize: size * 1.3)
    }
    static func appMeduim(_ size: CGFloat) -> UIFont {
        return UIFont.init(name: "PingFangSC-Medium", size: size) ?? UIFont.systemFont(ofSize: size * 1.3)
    }
    static func appSemibold(_ size: CGFloat) -> UIFont {
        return UIFont.init(name: "PingFangSC-Semibold", size: size) ?? UIFont.systemFont(ofSize: size * 1.3)
    }
    static func appBold(_ size: CGFloat) -> UIFont {
        return UIFont.init(name: "PingFangSC-Bold", size: size) ?? UIFont.systemFont(ofSize: size * 1.3)
    }
}


func FPFont(ofSize fontSize: CGFloat) -> UIFont {
    if #available(iOS 8.2, *) {
        return UIFont.systemFont(ofSize: fontSize, weight: UIFont.Weight.semibold)
    } else {
        return UIFont.systemFont(ofSize: fontSize)
    }
}

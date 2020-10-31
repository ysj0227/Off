//
//  Theam.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/5/8.
//  Copyright © 2020 Senwei. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UIColor

//透明蓝色
let kAppBlueAlphaColor               = UIColorFromRGBA(0x46C3C2, 0.8)


//主色调蓝色
let kAppBlueColor               = UIColorFromRGB(0x46C3C2)
let kAppDarkBlueColor               = UIColorFromRGB(0x2687D3)

let kAppLightBlueColor               = UIColorFromRGB(0xDAF3F3)
let kAppLightLightBlueColor               = UIColorFromRGB(0xECFDFD)

let kAppAlphaWhite0_alpha_7          = UIColor.init(white: 0, alpha: 0.7)

//黑色-灰色
let kAppBlackColor              = UIColorFromRGB(0x000000)
let kAppColor_333333            = UIColorFromRGB(0x333333)
let kAppColor_666666            = UIColorFromRGB(0x666666)
let kAppColor_999999            = UIColorFromRGB(0x999999)
let kAppColor_757575            = UIColorFromRGB(0x757575)
//登录按钮灰色状态
let kAppColor_btnGray_BEBEBE            = UIColorFromRGB(0xBEBEBE)
//背景灰色
let kAppColor_bgcolor_F7F7F7          = UIColorFromRGB(0xF7F7F7)
//线条灰色
let kAppColor_line_EEEEEE            = UIColorFromRGB(0xEEEEEE)
let kAppColor_line_D8D8D8            = UIColorFromRGB(0xD8D8D8)
//白色
let kAppWhiteColor              = UIColorFromRGB(0xFFFFFF)
let kAppTabbarGrayColor              = UIColorFromRGB(0x8E8E93)
let kAppClearColor                = UIColor.clear

let kAppBackgroundColor         = UIColorFromRGB(0xF5F6FF)
let kAppGreenColor              = UIColorFromRGB(0x92E439)
let kAppOrangeColor             = UIColorFromRGB(0xFF8F49)
let kAppRedColor                = UIColorFromRGB(0xFF6B71)
let kAppGrayColor               = UIColorFromRGB(0xAAAAAA)
let kAppColor_9B9B9B            = UIColorFromRGB(0x9B9B9B)
let kAppColor_4B4B4B            = UIColorFromRGB(0x4B4B4B)
let kAppColor_3E3E3E            = UIColorFromRGB(0x3E3E3E)
let kAppColor_777777            = UIColorFromRGB(0x777777)
let kAppColor_222222            = UIColorFromRGB(0x222222)
let kAppColor_555555            = UIColorFromRGB(0x555555)
let kAppColor_E7E7E7            = UIColorFromRGB(0xE7E7E7)
let kAppColor_F6F6F6            = UIColorFromRGB(0xF6F6F6)
let kAppColor_F9AB10            = UIColorFromRGB(0xF9AB10)
let kAppColor_FF9600            = UIColorFromRGB(0xFF9600)
let kAppColor_F0534F            = UIColorFromRGB(0xF0534F)
let kAppColor_F79100            = UIColorFromRGB(0xF79100)
let kAppColor_FE6F01            = UIColorFromRGB(0xFE6F01)
let kAppColor_AAAAAA            = UIColorFromRGB(0xAAAAAA)
let kAppColor_C8C8C8            = UIColorFromRGB(0xC8C8C8)
let kAppColor_CACACA            = UIColorFromRGB(0xCACACA)
let kAppColor_EB5E47            = UIColorFromRGB(0xEB5E47)
let kAppColor_C76716            = UIColorFromRGB(0xC76716)
let kAppColor_FEDCC7            = UIColorFromRGB(0xFEDCC7)
let kAppColor_D0021B            = UIColorFromRGB(0xD0021B)
let kAppColor_FAFBFC            = UIColorFromRGB(0xFAFBFC)


func UIColorFromRGB(_ rgbValue:Int) -> UIColor {
    
    return UIColor(red: CGFloat((rgbValue & 0xFF0000) >> 16)/255.0, green: CGFloat((rgbValue & 0x00FF00) >> 8)/255.0, blue: CGFloat((rgbValue & 0x0000FF))/255.0, alpha: 1.0)
}

func UIColorFromRGBA(_ rgbValue:Int, _ alpha: CGFloat) -> UIColor {
    
    return UIColor(red: CGFloat((rgbValue & 0xFF0000) >> 16)/255.0, green: CGFloat((rgbValue & 0x00FF00) >> 8)/255.0, blue: CGFloat((rgbValue & 0x0000FF))/255.0, alpha: alpha)
}




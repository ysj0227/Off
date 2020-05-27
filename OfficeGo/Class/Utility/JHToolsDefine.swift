//
//  JHToolsDefine.swift
//  JHToolsModule_Swift
//
//  Created by DENGFei on 2020/4/26.
//  Copyright © 2020 dengfei. All rights reserved.
//

import UIKit
import Foundation
// MARK: ===================================变量宏定义=========================================

// MARK:- 屏幕
public let SCREEN_HEIGHT = UIScreen.main.bounds.height
public let SCREEN_WIDTH = UIScreen.main.bounds.width
public let FIT_WIDTH = UIScreen.main.bounds.size.width / 375
public let FIT_HEIGHT = UIScreen.main.bounds.size.height / 667

public func StatusBarHeight() ->CGFloat {
    if #available(iOS 13.0, *){
        let window = UIApplication.shared.windows.first
        return window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    }else{
        return UIApplication.shared.statusBarFrame.height
    }
}
//导航栏高度:通用
public let NAVBAR_HEIGHT = UINavigationController().navigationBar.frame.size.height
//判断是否iphoneX
public func ISIPHONEX() -> Bool {
    guard #available(iOS 11.0, *) else {
        return false
    }
    
    let isX = UIApplication.shared.windows[0].safeAreaInsets.bottom > 0
    return isX
}

public let NAVBARHEIGHT = ISIPHONEX() ? Double(88.0) : Double(64.0)
public let TABBARHEIGHT = ISIPHONEX() ? Double(49.0+34.0) : Double(49.0)
public let STATUSBARHEIGHT = ISIPHONEX() ? Double(44.0) : Double(20.0)
// MARK:- 画线宽度
let Scare = UIScreen.main.scale
public let LineHeight = (Scare >= 1 ? 1/Scare : 1)


// MARK:- 系统版本
public let IOS11 = (UIDevice.current.systemVersion as NSString).doubleValue >= 11.0
public let IOS12 = (UIDevice.current.systemVersion as NSString).doubleValue >= 12.0
public let IOS13 = (UIDevice.current.systemVersion as NSString).doubleValue >= 13.0

public func IS_IOS11() -> Bool { return (UIDevice.current.systemVersion as NSString).doubleValue >= 11.0 }
public func IS_IOS12() -> Bool { return (UIDevice.current.systemVersion as NSString).doubleValue >= 12.0 }
public func IS_IOS13() -> Bool { return (UIDevice.current.systemVersion as NSString).doubleValue >= 13.0 }
public let systemVersion = (UIDevice.current.systemVersion as String)


// MARK:- 打印输出
//public func SLog<T>(_ message : T, file : String = #file, funcName : String = #function, lineNum : Int = #line) {
//    #if DEBUG
//        let fileName = (file as NSString).lastPathComponent
//        print("\n\n<><><><><>-「LOG」-<><><><><>\n\n>>>>>>>>>>>>>>>所在类:>>>>>>>>>>>>>>>\n\n\(fileName)\n\n>>>>>>>>>>>>>>>所在行:>>>>>>>>>>>>>>>\n\n\(lineNum)\n\n>>>>>>>>>>>>>>>信 息:>>>>>>>>>>>>>>>\n\n\(message)\n\n<><><><><>-「END」-<><><><><>\n\n")
//    #endif
//}

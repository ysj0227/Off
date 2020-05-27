//
//  Device.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/5/8.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

typealias Dic               = [String: AnyObject]?
typealias Eic               = [String: AnyObject]


typealias VoidClosure       = (() -> ())
typealias StringVoidClosure = (String) -> Void

struct Device {
    
    /// 获取设备名称 例如：梓辰的手机
    static let deviceName = UIDevice.current.name
    /// 获取系统名称 例如：iPhone OS
    static let sysName = UIDevice.current.systemName
    /// 获取系统版本 例如：9.2
    static let sysVersion = UIDevice.current.systemVersion
    /// 获取设备唯一标识符 例如：FBF2306E-A0D8-4F4B-BDED-9333B627D3E6
    static let deviceUUID = UIDevice.current.identifierForVendor?.uuidString
    /// 获取设备的型号 例如：iPhone
    static let deviceModel = UIDevice.current.model
    /// 获取App的版本
    static let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"]
    /// 获取App的build版本
    static let appBuildVersion = Bundle.main.infoDictionary?["CFBundleVersion"]
    /// 获取App的名称
    static let appName = Bundle.main.infoDictionary?["CFBundleDisplayName"]
    /// 获取具体的设备型号
    static let modelName = UIDevice.current.modelName
}


//打印信息
func SSLog<T>(_ message: T, method: String = #function, line: Int = #line,fileName:String = #file)
{
    let timeInterval: TimeInterval = Date().timeIntervalSince1970

    #if DEBUG
        print("[\(timeInterval)|\((fileName as NSString).lastPathComponent)|\(method)|\(line)]:\(message)")
    #endif
}

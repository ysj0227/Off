//
//  PrintDefine.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/5/8.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

func THPrint<N>(_ message: N, fileName: String = #file, methodName: String = #function, lineNumber: Int = #line){
    #if DEBUG
    print("\(Date().description)\t\(message)\n文件:\(fileName)\t行号:\(lineNumber)\t方法:\(methodName)\n");
    #endif
}

func NSLocalizedString(_ key: String, comment: String = "") -> String {
    return key
//    if UserInfo.shared().isPassed {
//        return Bundle(path: Bundle.main.path(forResource: UserInfo.shared().perferLanguage().rawValue, ofType: "lproj") ?? "")?.localizedString(forKey: key, value: "", table: nil) ?? key
//    } else {
//        return Bundle(path: Bundle.main.path(forResource: "en", ofType: "lproj") ?? "")?.localizedString(forKey: key, value: "", table: nil) ?? key
//    }
}

func MissionsLocalizedString(_ key: String, comment: String? = nil) -> String {
    return NSLocalizedString(key, tableName: "Missions")
}

func NSLocalizedString(_ key: String, tableName: String?) -> String {
//    return NSLocalizedString(key, tableName: tableName, bundle: Bundle(path: Bundle.main.path(forResource: UserInfo.shared().perferLanguage().rawValue, ofType: "lproj") ?? "") ?? Bundle.main, value: "", comment: "")
    return key
}

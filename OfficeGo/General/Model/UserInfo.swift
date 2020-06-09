//
//  UserInfo.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/4/26.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit
import HandyJSON

class UserInfo: NSObject, HandyJSON {
    var shouldDisplayCoinTip = true
    @objc var token: String?
    var verifyCodeSendTime: TimeInterval = 0
    var verifyMobile: String?
    var verifyAreaCode: String?
    private var serverTimeOffset: TimeInterval?
    var serverTime: Date {
        get {
            if let offset = serverTimeOffset {
                return Date().addingTimeInterval(offset)
            } else {
                return Date()
            }
        }
        set {
            serverTimeOffset = newValue.timeIntervalSince(Date())
        }
    }
    
    @objc var user: User? {
        didSet {
//            NotificationCenter.default.post(name: Notification.Name.userChanged, object: nil)
        }
    }
    
    // 受限模式，特殊视频画不显示
    var restrictedMode = false {
        didSet {
            saveToLocalFile()
        }
    }
    
    var downloadInWifi = true {
        didSet {
            saveToLocalFile()
        }
    }
    
    var blockedVideos = [String]()
    
    var youtubeCookies: String?
    var idToken: String?
    var sessionToken: String?
    var pageCL: String?
    var pageBuildLabel: String?
    var variantsCheckSum: String?
    var idTokenLoading: Bool = false
    func mapping(mapper: HelpingMapper) {
//        mapper >>> self.api
    }
    
    private static var userInfo: UserInfo?
    static func shared() -> UserInfo {
        DispatchQueue.once(token: "UserInfo") {
            userInfo = UserInfo.readFromLocalFile()
        }
        return userInfo!
    }
    
    public func reloadYouTubeCookies(_ callBack: @escaping(Bool) -> Void) {
    
    }
    
    required override init() {}
    
    public func isLogin() -> Bool {
        return (user?.id ?? 0) != 0
        return true
    }
    
    public func resetCookie() {
        if isLogin() == false {
            cleanCookie()
        }
    }
    
    public func logout() {
        cleanCookie()
        user = nil
        token = nil
        saveToLocalFile()
        removeUserDefaultInfo()
    }
    
    private func cleanCookie() {
    
    }
    
    func removeUserDefaultInfo() {
//        UserDefaults.standard.synchronize()
    }
    
    func saveToLocalFile() {
        shouldDisplayCoinTip = true
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first! + "/user.data"
        NSKeyedArchiver.archiveRootObject(self.toJSONString() ?? "", toFile: path)
    }
    
    class private func readFromLocalFile() -> UserInfo {
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first! + "/user.data"
        let string = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? String
        return UserInfo.deserialize(from: string) ?? UserInfo()
    }
    
}

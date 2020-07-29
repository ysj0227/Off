//
//  SSTool.swift
//  UUEnglish
//
//  Created by Aibo on 2018/3/27.
//  Copyright © 2018年 uuabc. All rights reserved.
//

import UIKit
import AVFoundation
import Lottie
import SnapKit

@objcMembers class SSTool: NSObject {
    
    ///提示
    static func callPhoneTelpro(phone : String){
        let  phoneUrlStr = "telprompt://" + phone
        
        if let url = URL(string: phoneUrlStr) {
            if UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler:nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }

    ///验证邮箱
    class func validateEmail(email: String) -> Bool {
        if email.count == 0 {
            return false
        }
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest:NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
    
    ///验证手机号
    class func isPhoneNumber(phoneNumber:String) -> Bool {
        if phoneNumber.count == 0 {
            return false
        }
        let mobile = "^1([358][0-9]|4[579]|66|7[0135678]|9[89])[0-9]{8}$"
        let regexMobile = NSPredicate(format: "SELF MATCHES %@",mobile)
        if regexMobile.evaluate(with: phoneNumber) == true {
            return true
        }else
        {
            return false
        }
    }
    
    ///密码正则  6-8位字母和数字组合
    class func isPasswordRuler(password:String) -> Bool {
        let passwordRule = "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,8}$"
        let regexPassword = NSPredicate(format: "SELF MATCHES %@",passwordRule)
        if regexPassword.evaluate(with: password) == true {
            return true
        }else
        {
            return false
        }
    }
    
    ///验证是否是数字和字符串
    class func isPureStrOrNumNumber(text:String) -> Bool{
        let passwordRule = "^[a-zA-Z0-9]+$"
        let regexPassword = NSPredicate(format: "SELF MATCHES %@",passwordRule)
        if regexPassword.evaluate(with: text) == true {
            return true
        }else
        {
            return false
        }
    }
    func getStringByRangeIntValue(Str : NSString,location : Int, length : Int) -> Int{
        
        let a = Str.substring(with: NSRange(location: location, length: length))
        
        let intValue = (a as NSString).integerValue
        
        return intValue
    }
    static func dispatchBlock(block: @escaping VoidClosure,complete:VoidClosure?){
        DispatchQueue.global(qos: .userInitiated).async {
            autoreleasepool(invoking:{
                block()
                if let temp = complete {
                    temp()
                }
            })
        }
    }

    //时间戳转成字符串 - 10位
    static func timeIntervalChangeToTimeStr(timeInterval:TimeInterval, dateFormat:String?) -> String {
        let date:NSDate = NSDate.init(timeIntervalSince1970: timeInterval)
        let formatter = DateFormatter.init()
        if dateFormat == nil {
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        }else{
            formatter.dateFormat = dateFormat
        }
        return formatter.string(from: date as Date)
    }
    ///时间戳转成字符串 - MM月dd日
   static func timeIntervalChangeToYYMMHHMMTimeStr(timeInterval:TimeInterval) -> String {
       let date:NSDate = NSDate.init(timeIntervalSince1970: timeInterval)
       let formatter = DateFormatter.init()
       formatter.dateFormat = "MM月dd日HH:mm"
       return formatter.string(from: date as Date)
   }
    ///时间戳转成字符串 - MM月dd日
    static func timeIntervalChangeToYYMMTimeStr(timeInterval:TimeInterval) -> String {
        let date:NSDate = NSDate.init(timeIntervalSince1970: timeInterval)
        let formatter = DateFormatter.init()
        formatter.dateFormat = "MM月dd日"
        return formatter.string(from: date as Date)
    }
    ///时间戳转成字符串 - mm:ss
    static func timeIntervalChangeToHHMMTimeStr(timeInterval:TimeInterval) -> String {
        let date:NSDate = NSDate.init(timeIntervalSince1970: timeInterval)
        let formatter = DateFormatter.init()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date as Date)
    }
    
    static func invokeInDebug(closure: VoidClosure) {
        #if DEBUG
        closure()
        #endif
    }
    
     //字符串转时间戳
    static func timeStrChangeTotimeInterval(timeStr: String?, dateFormat:String?) -> String {
        if timeStr?.count ?? 0 > 0 {
            return ""
        }
        let format = DateFormatter.init()
        format.dateStyle = .medium
        format.timeStyle = .short
        if dateFormat == nil {
            format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        }else{
            format.dateFormat = dateFormat
        }
        let date = format.date(from: timeStr!)
        return String(date!.timeIntervalSince1970)
    }
    
    //字符串转时间戳
    static func timeStrChangeToDateYYYYMMdd(timeStr: String?) -> Date {
        
        let format = DateFormatter.init()
        format.dateStyle = .medium
        format.timeStyle = .short
        format.dateFormat = "yyyy-MM-dd"

        let date = format.date(from: timeStr!) ?? Date()
        return date
    }
    
    static func invokeInMainThread(closure: @escaping VoidClosure) {
        DispatchQueue.main.async {
            closure()
        }
    }
    
    static func invokeInGlobalThread(closure: @escaping VoidClosure) {
        DispatchQueue.global(qos: .default).async {
            closure()
        }
    }
    
    static func delay(time: TimeInterval, Block block: @escaping (() -> Void)){
        DispatchQueue.main.asyncAfter(deadline: .now() + time) {
            block()
        }
    }
    
    static func dateFrom(seconds:Int) -> NSDate {
        
        let currDate  = NSDate.init(timeIntervalSince1970: TimeInterval.init(seconds))
        let timeZone = NSTimeZone.system
        let interval = timeZone.secondsFromGMT(for: currDate as Date)
        let date = currDate.addingTimeInterval(TimeInterval.init(interval))
        return date
    }
    
    static func secondsDifferenceToCurrentDate(seconds:Int) -> TimeInterval {
        let date = dateFrom(seconds: seconds)
        let offset = date.timeIntervalSince1970 - getCurrentDate(interval: 0).timeIntervalSince1970
        return offset
    }
    
    static func differenceDates(startDate:NSDate,endDate:NSDate) -> TimeInterval{
        let offset = startDate.timeIntervalSince1970 - endDate.timeIntervalSince1970
        return offset
    }
    
    static func timeFormatted(totalSeconds:TimeInterval) -> String{
        let seconds = totalSeconds.truncatingRemainder(dividingBy: 60)
        let minutes = (totalSeconds / 60).truncatingRemainder(dividingBy: 60)
        let hours = totalSeconds / 3600
        
        return "\(Int.init(hours) == 0 ? "" : "\(Int.init(hours))时")\(Int.init(minutes) == 0 ? "" : "\(Int.init(minutes))分")\(Int.init(seconds) == 0 ? "" : "\(Int.init(seconds))秒")"
    }
    
    static func timeFormatted1(totalSeconds:TimeInterval) -> String{
        let seconds = totalSeconds.truncatingRemainder(dividingBy: 60)
        let minutes = (totalSeconds / 60).truncatingRemainder(dividingBy: 60)
        let hours = totalSeconds / 3600
        return "\(Int.init(hours) == 0 ? "" : "\(Int.init(hours))时")\(Int.init(minutes))分\(Int.init(seconds))秒"
    }
    
    static func timeFormattedHour(totalSeconds:TimeInterval) -> String{
        let seconds = totalSeconds.truncatingRemainder(dividingBy: 60)
        let minutes = (totalSeconds / 60).truncatingRemainder(dividingBy: 60)
        let hours = totalSeconds / 3600
        let remainHours = Int(hours) % 24
        //当小时数超过24小时后，显示减去整天之后的小时数
        if remainHours > 0 {
            return "\(Int.init(hours) == 0 ? "" : "\(Int.init(remainHours)):")\(Int.init(minutes)):\(Int.init(seconds))"
        }else {
            return "\(Int.init(hours) == 0 ? "" : "\(Int.init(hours)):")\(Int.init(minutes)):\(Int.init(seconds))"
        }
        
    }
    
    static func getCurrentDate(interval:TimeInterval) -> NSDate {
        
        let currDate  = NSDate.init()
        let timeZone = NSTimeZone.system
        let zoneInter = timeZone.secondsFromGMT(for: currDate as Date)
        let date = currDate.addingTimeInterval(interval + TimeInterval.init(zoneInter))
        return date
    }
    
    static func getMinutesAndHours(seconds:Int) ->String{
        let date = dateFrom(seconds: seconds)
        let formatter = DateFormatter.init()
        formatter.dateFormat = "HH:mm"
        let str = formatter.string(from: date as Date)
        return str
    }
    
    static func getMinutesAndHours()->String{
        let date = NSDate()
        let formatter = DateFormatter.init()
        formatter.dateFormat = "HH:mm"
        let str = formatter.string(from: date as Date as Date)
        return str
    }
    static func saveDataWithUserDefault(key:String,value:AnyObject){
        let userDefault = UserDefaults.standard
        userDefault.set(value, forKey: key)
        userDefault.synchronize()
    }
    
    static func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    
    static func removeUserDefault(key:String){
        let userDefault = UserDefaults.standard
        userDefault.removeObject(forKey: key)
        userDefault.synchronize()
    }

    // 相机权限
    static func isRightCamera() -> Bool {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        return authStatus != .restricted && authStatus != .denied
    }
    
    //  MARK:   --获取版本
    static func getVersion() -> String {
        
        let infoDictionary = Bundle.main.infoDictionary
        let appVersion = infoDictionary!["CFBundleShortVersionString"] as! String
        let appBuild = infoDictionary!["CFBundleVersion"] as! String
        var version = ""
        
        #if DEBUG
        version = appVersion + "." + appBuild
        #else
        version = appVersion
        #endif
        
        return version
    }
    
    //  MARK:   --缓存占用
    static func fileSizeOfCache()-> Int {
        
        // 取出cache文件夹目录 缓存文件都在这个目录下
        let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, .userDomainMask, true).first
        // 取出文件夹下所有文件数组
        let fileArr = FileManager.default.subpaths(atPath: cachePath!)
        
        //快速枚举出所有文件名 计算文件大小
        var size = 0
        for file in fileArr! {
            
            // 把文件名拼接到路径中
            let path = cachePath?.appendingFormat("/\(file)")
            // 取出文件属性
            let floder = try! FileManager.default.attributesOfItem(atPath: path!)
            
            if FileManager.default.fileExists(atPath: path!) {
                // 用元组取出文件大小属性
                for (abc, bcd) in floder {
                    // 累加文件大小
                    if abc == FileAttributeKey.size {
                        size += (bcd as AnyObject).integerValue
                    }
                }
            }
        }
        
        let mm = size / 1024 / 1024
        
        return mm
    }
    
    //MARK: - 清除本地缓存
    static func  clearCache()  {
        let basePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, .userDomainMask, true).first
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: basePath!)
        {
            let childrenPath = fileManager.subpaths(atPath: basePath!)
            for childPath in childrenPath! {
                let cachePath = ((basePath)! + "/") + childPath
                do {
                    try fileManager.removeItem(atPath: cachePath)
                    
                } catch  {
                    
                }
            }
        }
    }
    
    
    /// 可用磁盘容量
    ///
    /// - Returns: Float
        func availableDiskSize() -> Float {
        var availableSize: Float  = 0
        let manager = FileManager.default
        let home = NSHomeDirectory() as NSString
        do {
            let attribute = try manager.attributesOfFileSystem(forPath: home as String)
            availableSize = (attribute[FileAttributeKey.systemFreeSize] as! NSNumber).floatValue / 1024 / 1024 / 1024
        } catch  {
            availableSize = 0
        }
        return availableSize
    }
    
    /// 总磁盘容量
    ///
    /// - Returns: Float
        func totalDiskSize() -> Float {
        var totalSize: Float  = 0
        let manager = FileManager.default
        let home = NSHomeDirectory() as NSString
        do {
            let attribute = try manager.attributesOfFileSystem(forPath: home as String)
            totalSize = (attribute[FileAttributeKey.systemFreeSize] as! NSNumber).floatValue / 1024 / 1024 / 1024
        } catch  {
            totalSize = 0
        }
        return totalSize
    }
    //总内存大小
        func totalMemorySize() -> UInt64 {
        return ProcessInfo.processInfo.physicalMemory
    }
    //获取今天日期
        func getTodayTime() -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy.MM.dd"
        return dateFormat.string(from: Date())
    }
    
    //返回是否可以弹出
        func getRepayNoticeCanShow() -> Bool {
        let defaults = UserDefaults()
        let dateStr = defaults.object(forKey: "popWindowOnceADay") as? String
        return dateStr == getTodayTime() ? false : true //判断时间是否相同
    }
    
    //窗口弹出后保存日期
        func setRepayNoticeTime() {
        let defaults = UserDefaults()
        defaults.set(getTodayTime(), forKey: "popWindowOnceADay")
        defaults.synchronize()
    }
    
    //  MARK:   --播放Mp3
        func playMp3() {
        var player = AVAudioPlayer()
        let mp3Url = Bundle.main.url(forResource: "ClickSing", withExtension: "mp3")
        player = try! AVAudioPlayer(contentsOf: mp3Url!)
        player.numberOfLoops = 0
        player.volume = 1.0
        player.prepareToPlay()
        player.play()
    }
    //   弹出内存提示窗
        func showTipAlert(judgeStr:String, titleStr:String) {
//        let alert = TipAlertView()
//        alert.setupDiskAlert(judgeStr: judgeStr, titleStr: titleStr)
//        alert.show()
    }
}

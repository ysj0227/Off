//
//  AppUtilities.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/4/26.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit
//import KeychainSwift
import Photos

class AppUtilities: NSObject {
    
    static var navigationController = (UIApplication.shared.delegate as? AppDelegate)?.navigationController
    
    static func makeToast(_ string: String, image: UIImage? = nil) {
        if let presentedVC = navigationController?.presentedViewController {
            presentedVC.view.makeToast(string, image: image)
        } else {
            navigationController?.view.makeToast(string, image: image)
        }
    }
    
    static func makeToast(_ view: UIView) {
        if let presentedVC = navigationController?.presentedViewController {
            presentedVC.view.showToast(view)
        } else {
            navigationController?.view.showToast(view)
        }
    }
    
    static func showAlert(alertController: UIAlertController) {
        navigationController?.present(alertController, animated: true, completion: nil)
    }
    
    static func showSimpleAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("知道了", comment: ""), style: .cancel, handler: nil))
        navigationController?.present(alert, animated: true, completion: nil)
    }
    
//    static func deviceID() -> String {
//        let keychain = KeychainSwift()
//        guard let savedID = keychain.get("deviceID") else {
//            if let idfv = UIDevice.current.identifierForVendor?.uuidString {
//                keychain.set(idfv, forKey: "deviceID")
//                return idfv
//            } else {
//                let uuidRef = CFUUIDCreate(kCFAllocatorDefault)
//                let strRef = CFUUIDCreateString(kCFAllocatorDefault, uuidRef)
//                let uuidString = (strRef! as String)
//                keychain.set(uuidString, forKey: "deviceID")
//                return uuidString
//            }
//        }
//        return savedID
//    }
    
    static func formatDuration(_ duration: Float) -> String {
        var seconds = Int(roundf(duration))
        if seconds <= 0 {
            return "00:00"
        }
        let hours = seconds / 3600
        seconds -= hours * 3600
        let minutes = seconds / 60
        seconds -= minutes * 60
        if hours > 0 {
            return String(format: "%ld:%02ld:%02ld", hours, minutes, seconds)
        } else {
            return String(format: "%ld:%02ld", minutes, seconds)
        }
    }
    
    static func dollarCountString(cent:Int64?) -> String? {
        guard let cent = cent else {
            return nil
        }
        let dollars = Double(cent) / 100.0
        return String(format: "%.2f", dollars)
    }
    
    static func fileSizeString(from bytes: Int64) -> String {
        switch fabs(Double(bytes)) {
        case 0..<1000:
            return "\(bytes)B"
        case 1000..<1024 * 1024://KB
            return String.init(format: "%.0fKB", Double(bytes) / (1024))
        case 1024 * 1024..<1024 * 1024 * 1024://MB
            return String.init(format: "%.0fMB", Double(bytes) / (1024 * 1024))
        default://GB
            return String.init(format: "%.0fGB", Double(bytes) / (1024 * 1024 * 1024))
        }
    }
    
    static func speedString(from bytes: Int64) -> String {
        let speed = bytes * 8
        switch fabs(Double(speed)) {
        case 0..<1000:
            return "\(speed)b/s"
        case 1000..<1024 * 1024://KB
            return String.init(format: "%.0fKb/s", Double(speed) / (1024))
        case 1024 * 1024..<1024 * 1024 * 1024://MB
            return String.init(format: "%.0fMb/s", Double(speed) / (1024 * 1024))
        default://GB
            return String.init(format: "%.0fGb/s", Double(speed) / (1024 * 1024 * 1024))
        }
    }
    
    static func getDiskSpaceInfo() -> (Int64, Int64) {
        var totalsize: Int64 = 0
        var freesize: Int64 = 0
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        do {
            var dictionary = try FileManager.default.attributesOfFileSystem(forPath: paths.last ?? "")
            freesize = dictionary[.systemFreeSize] as? Int64 ?? 0
            totalsize = dictionary[.systemSize] as? Int64 ?? 0
        } catch {
            THPrint(String(format: "Error Obtaining System Memory Info: Domain = %@, Code = %ld", (error as NSError).domain, Int((error as NSError).code)))
        }
        return (freesize, totalsize)
    }
    
    static func requestLibraryAuthortication(callBack:@escaping (Bool) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .denied || status == .restricted {
            callBack(false)
        } else {
            PHPhotoLibrary.requestAuthorization { (status) in
                switch status {
                case .authorized:
                    callBack(true)
                default:
                    callBack(false)
                    break
                }
            }
        }
    }
}

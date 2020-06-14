//
//  NetAlamofireReachability.swift
//  MSStudent
//
//  Created by DENGFei on 2020/6/13.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit
import Alamofire
@objc public enum NetStatus:Int {
    case WiFi = 0
    case Wwan = 1
    case NotReachable = 2
    case Unknown = 3
}

class NetAlamofireReachability: NSObject {
    static let shared = NetAlamofireReachability()
    var status:NetStatus = .Unknown
    var manager: NetworkReachabilityManager?
    /// 开启网络实时监听
    @objc func start() {
        self.manager = NetworkReachabilityManager(host: "www.baidu.com")
        manager?.listener = {status in
        
            if status == .notReachable {
                self.status = .NotReachable
            }else if status == .unknown {
                self.status = .Unknown
            }else if status == .reachable(.ethernetOrWiFi) {
                self.status = .WiFi
            }else if status == .reachable(.wwan) {
                self.status = .Wwan
            }
        }
        manager?.startListening()
    }
}

//
//  UserService.swift
//  RCDemo_Swift
//
//  Created by 孙浩 on 2019/3/11.
//  Copyright © 2019 RongCloud. All rights reserved.
//

import UIKit

class RCDUserService: NSObject {
    
    static let shared = RCDUserService()
  
}

extension RCDUserService: RCIMUserInfoDataSource {
    // 需返回正确的用户信息
    func getUserInfo(withUserId userId: String!, completion: ((RCUserInfo?) -> Void)!) {
        
        //这边需要一个接口，把用户信息返回给我
//        let model = RCIM.shared()?.getUserInfoCache(userId);
        /*
        if userId == "11" {
            let model = RCUserInfo.init(userId: "11", name: "967/NX5LAZieYyTUV64E93kXj1D6gbjE@7mb1.cn.rongnav.com;7mb1.cn.rongcfg.com", portrait: "https://img.officego.com.cn/building/1589275141007.jpg")
            completion(model)
            return
        }
        let model = RCUserInfo.init(userId: "200", name: "安卓", portrait: "https://img.officego.com.cn/report/1590121741001.jpg")
        completion(model)
 */
    }
}

extension RCDUserService: RCIMGroupInfoDataSource {
    // 需返回正确的群组信息
    func getGroupInfo(withGroupId groupId: String!, completion: ((RCGroup?) -> Void)!) {
        
    }
}

extension RCDUserService: RCIMGroupMemberDataSource {
    func getAllMembers(ofGroup groupId: String!, result resultBlock: (([String]?) -> Void)!) {
        let array = ["test1", "test2", "test3"]
        resultBlock(array)
    }
}


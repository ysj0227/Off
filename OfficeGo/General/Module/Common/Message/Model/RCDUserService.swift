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


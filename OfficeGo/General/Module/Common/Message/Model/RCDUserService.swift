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
        
        
        ///实现用户信息提供者 - 实现本地推送
        SSNetworkTool.SSChat.request_getUserChatInfoApp(params: ["targetid": userId as AnyObject], success: { (response) in
                        
            if let model = ChatTargetUserInfoModel.deserialize(from: response, designatedPath: "data") {
                
                SSTool.invokeInMainThread {
                    let info = RCUserInfo.init(userId: userId, name: model.name, portrait: model.avatar)
                    RCIM.shared()?.refreshUserInfoCache(info, withUserId: userId)
                }
            }
                        
            }, failure: { (error) in
                
                
        }) { (code, message) in
            
        }
//        if userId == "03" {
//            let info = RCUserInfo.init(userId: userId, name: "系统消息", portrait: "https://img.officego.com/test/1597029569868.png")
//            RCIM.shared()?.refreshUserInfoCache(info, withUserId: userId)
//        }
//        if userId == "2701" {
//            let info = RCUserInfo.init(userId: userId, name: "2701", portrait: "https://img.officego.com/test/1597029569868.png")
//            RCIM.shared()?.refreshUserInfoCache(info, withUserId: userId)
//        }
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


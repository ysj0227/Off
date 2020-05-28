//
//  UserTool.swift
//  MSStudent
//
//  Created by Derrick on 2018/12/17.
//  Copyright © 2018年 mgss. All rights reserved.
//

import UIKit

class UserTool: NSObject {
    
    static let shared = UserTool()
    
    let userDefault: UserDefaults
    
    fileprivate override init(){
        userDefault = UserDefaults.standard
    }
    
    func isLogin() -> Bool {
        if let usertoken = self.user_token {
            if usertoken.isBlankString == true {
                return false
            }else{
                return true
            }
        }else {
            return false
        }
    }
    
    func isHasWX() -> Bool {
        if let userwechat = self.user_wechat {
            if userwechat.isBlankString == true {
                return false
            }else{
                return true
            }
        }else {
            return false
        }
        
    }
    
    //终端渠道,1:IOS,2:安卓,3:H5
    var user_channel: Int = 1
    
    
    /// 融云token
    var user_rongyuntoken: String?{
        get{
            return userDefault.value(forKey: "user_rongyuntoken") as? String
        }
        set(newValue){
            return userDefault.set(newValue, forKey: "user_rongyuntoken")
        }
    }
    
    /// 用户token
    var user_token: String?{
        get{
            return userDefault.value(forKey: "user_token") as? String
        }
        set(newValue){
            return userDefault.set(newValue, forKey: "user_token")
        }
    }
    
    /// 用户id uid
    var user_uid: Int?{
        get{
            return userDefault.value(forKey: "user_uid") as? Int
        }
        set(newValue){
            return userDefault.set(newValue, forKey: "user_uid")
        }
    }
    
    /// 手机号
    var user_phone: String?{
        get{
            return userDefault.value(forKey: "user_phone") as? String
        }
        set(newValue){
            return userDefault.set(newValue, forKey: "user_phone")
        }
    }
    
    
    /// 用户微信
    var user_wechat: String?{
        get{
            return userDefault.value(forKey: "user_wechat") as? String
        }
        set(newValue){
            return userDefault.set(newValue, forKey: "user_wechat")
        }
    }
    /// role 角色 用户身份类型,,0:租户,1:业主,9:其他
    var  user_id_type: Int?{
        get{
            return userDefault.value(forKey: " user_id_type") as? Int
        }
        set(newValue){
            return userDefault.set(newValue, forKey: " user_id_type")
        }
    }
    
    /// 头像
    var user_avatars:String?{
        get{
            return userDefault.value(forKey: "user_avatars") as? String
        }
        set(newValue){
            return userDefault.set(newValue, forKey: "user_avatars")
        }
    }
    
    /// 性别
    var user_sex:String?{
        get{
            return userDefault.value(forKey: "user_sex") as? String
        }
        set(newValue){
            return userDefault.set(newValue, forKey: "user_sex")
        }
    }
    
    /// 是否是老系统
    var isOldSystem:Bool? {
        get{
            return userDefault.value(forKey: "isOldSystem") as? Bool
        }
        set(newValue){
            return userDefault.set(newValue, forKey: "isOldSystem")
        }
    }
    
    func forwardLogin() {
        UserTool.shared.removeAll()
        
    }
    
    func synchronize() {
        userDefault.synchronize()
    }
    
    
    
    func removeAll() {
        userDefault.setValue(false, forKey: "isOldSystem")
        userDefault.set("", forKey: "user_rongyuntoken")
        userDefault.set("", forKey: "user_token")
        userDefault.set("", forKey: "user_phone")
        userDefault.set("", forKey: "user_sex")
        userDefault.set("", forKey: "user_avatars")
        userDefault.set("", forKey: "user_uid")
//        userDefault.set("", forKey: " user_id_type")
        userDefault.set(false, forKey: "isOldSystem")
    }
}

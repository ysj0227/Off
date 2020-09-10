//
//  UserTool.swift
//  MSStudent
//
//  Created by Derrick on 2018/12/17.
//  Copyright © 2018年 mgss. All rights reserved.
//

import UIKit

///融云用户身份类型 - 租户
let ChatType_Renter_0: String = "0"
///融云用户身份类型 - 房东
let ChatType_Owner_1: String = "1"
///融云用户身份类型 - 系统
let ChatType_System_3: String = "3"


class UserTool: NSObject {
    
    static let shared = UserTool()
    
    let userDefault: UserDefaults
    
    fileprivate override init(){
        userDefault = UserDefaults.standard
    }
    
    func isLogin() -> Bool {
        if let usertoken = self.user_token{
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
    
    /// 是否已经显示过引导图
    var isShowGuide: Bool?{
        get{
            return userDefault.value(forKey: "guide_isShowGuide") as? Bool
        }
        set(newValue){
            return userDefault.set(newValue, forKey: "guide_isShowGuide")
        }
    }
    
    /// 是否已经显示过业主pc扫码登录
    var isShowPCScanLogin: Bool?{
        get{
            return userDefault.value(forKey: "isShowPCScanLogin") as? Bool
        }
        set(newValue){
            return userDefault.set(newValue, forKey: "isShowPCScanLogin")
        }
    }
    
    ///终端渠道,1:IOS,2:安卓,3:H5
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
    
    /// 租户用户是否已经跳过了登录 - 如果跳过了登录就直接显示tabar 0没有跳过 1跳过
    var user_renter_clickTap: Int?{
        get{
            return userDefault.value(forKey: "user_renter_clickTap") as? Int
        }
        set(newValue){
            return userDefault.set(newValue, forKey: "user_renter_clickTap")
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
    /// role 角色 用户身份类型,,0:租户,1:房东,9:其他 2 客服 3 系统
    var  user_id_type: Int?{
        get{
            return userDefault.value(forKey: " user_id_type") as? Int
        }
        set(newValue){
            return userDefault.set(newValue, forKey: " user_id_type")
        }
    }
    
    /// 名字 - 租户realname
       var user_name:String?{
           get{
               return userDefault.value(forKey: "user_name") as? String
           }
           set(newValue){
               return userDefault.set(newValue, forKey: "user_name")
           }
       }
   
    /// 名字 - 租户realname
    var user_nickname:String?{
        get{
            return userDefault.value(forKey: "user_nickname") as? String
        }
        set(newValue){
            return userDefault.set(newValue, forKey: "user_nickname")
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
    var isCloseCancelVersionUpdate:Bool? {
        get{
            return userDefault.value(forKey: "isCloseCancelVersionUpdate") as? Bool
        }
        set(newValue){
            return userDefault.set(newValue, forKey: "isCloseCancelVersionUpdate")
        }
    }
    
    /// 公司
    var user_company:String?{
        get{
            return userDefault.value(forKey: "user_company") as? String
        }
        set(newValue){
            return userDefault.set(newValue, forKey: "user_company")
        }
    }
    
    /// 岗位
    var user_job:String?{
        get{
            return userDefault.value(forKey: "user_job") as? String
        }
        set(newValue){
            return userDefault.set(newValue, forKey: "user_job")
        }
    }
    
    
    
    
    ///身份类型0个人1企业2联合
    var user_owner_identifytype: Int?{
        get{
            return userDefault.value(forKey: "user_owner_identifytype") as? Int
        }
        set(newValue){
            return userDefault.set(newValue, forKey: "user_owner_identifytype")
        }
    }
    
    func forwardLogin() {
        UserTool.shared.removeAll()
    }
    
    func synchronize() {
        userDefault.synchronize()
    }
    
    
    ///不需要移除角色。和 版本更新是否展示过
    func removeAll() {
        userDefault.removeObject(forKey: "user_rongyuntoken")
        userDefault.removeObject(forKey: "user_token")
        userDefault.removeObject(forKey: "user_uid")
        userDefault.removeObject(forKey: "user_renter_clickTap")
        userDefault.removeObject(forKey: "user_phone")
        userDefault.removeObject(forKey: "user_wechat")
        userDefault.removeObject(forKey: "user_name")
        userDefault.removeObject(forKey: "user_nickname")
        userDefault.removeObject(forKey: "user_avatars")
        userDefault.removeObject(forKey: "user_sex")
        userDefault.removeObject(forKey: "user_company")
        userDefault.removeObject(forKey: "user_job")
        
        /*
        userDefault.setValue(false, forKey: "isCloseCancelVersionUpdate")
        userDefault.set("", forKey: "user_rongyuntoken")
        userDefault.set("", forKey: "user_token")
        userDefault.set("", forKey: "user_phone")
        userDefault.set("", forKey: "user_sex")
        userDefault.set("", forKey: "user_avatars")
        userDefault.set("", forKey: "user_uid")
//        userDefault.set("", forKey: " user_id_type")
        userDefault.set(false, forKey: "isCloseCancelVersionUpdate")
        */
    }
}

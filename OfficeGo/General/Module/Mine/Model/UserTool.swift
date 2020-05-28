//
//  UserTool.swift
//  MSStudent
//
//  Created by Derrick on 2018/12/17.
//  Copyright © 2018年 mgss. All rights reserved.
//

import UIKit

class UserTool: NSObject {

    @objc static let shared = UserTool()
    let userDefault: UserDefaults
    
    fileprivate override init(){
        userDefault = UserDefaults.standard
    }
    
    @objc func isLogin() -> Bool {
        if self.af_token == nil || self.af_token == "" {
            return false
        }else{
            return true
        }
    }
    
    /// 是否开启内购
    @objc var openPurchase:String? {
        get{
            return userDefault.value(forKey: "openPurchase") as? String
        }
        set(newValue){
            return userDefault.set(newValue, forKey: "openPurchase")
        }
    }
    
    /// 用户令牌
    @objc var af_token:String?{
        get{
            return userDefault.value(forKey: "af_token") as? String
        }
        set(newValue){
            return userDefault.set(newValue, forKey: "af_token")
        }
    }
    
    /// u直播专用的token
    @objc var gql_token:String?{
        get{
            return userDefault.value(forKey: "gql_token") as? String
        }
        set(newValue){
            return userDefault.set(newValue, forKey: "gql_token")
        }
    }
    
    
    /// 绘本令牌
    @objc var mini_token:String?{
        get{
            return userDefault.value(forKey: "mini_token") as? String
        }
        set(newValue){
            return userDefault.set(newValue, forKey: "mini_token")
        }
    }
    
    /// 绘本令牌
    @objc var token:String?{
        get{
            return userDefault.value(forKey: "token") as? String
        }
        set(newValue){
            return userDefault.set(newValue, forKey: "token")
        }
    }
    
    /// 账号
    @objc var username:String?{
        get{
            return userDefault.value(forKey: "username") as? String
        }
        set(newValue){
            return userDefault.set(newValue, forKey: "username")
        }
    }
    
    /// englishName
    @objc var englishName:String?{
        get{
            return userDefault.value(forKey: "englishName") as? String
        }
        set(newValue){
            return userDefault.set(newValue, forKey: "englishName")
        }
    }
    
    /// 头像
    @objc var avatars:String?{
        get{
            return userDefault.value(forKey: "avatars") as? String
        }
        set(newValue){
            return userDefault.set(newValue, forKey: "avatars")
        }
    }
    
    /// 姓名中文
    @objc var nickname:String?{
        get{
            return userDefault.value(forKey: "nickname") as? String
        }
        set(newValue){
            return userDefault.set(newValue, forKey: "nickname")
        }
    }
    /// 性别
    @objc var sex:String?{
        get{
            return userDefault.value(forKey: "sex") as? String
        }
        set(newValue){
            return userDefault.set(newValue, forKey: "sex")
        }
    }
    /// 年龄
    @objc var birthday:String?{
        get{
            return userDefault.value(forKey: "birthday") as? String
        }
        set(newValue){
            return userDefault.set(newValue, forKey: "birthday")
        }
    }
    
    
    /// 密码
    @objc var password:String?{
        get{
            return userDefault.value(forKey: "password") as? String
        }
        set(newValue){
            return userDefault.set(newValue, forKey: "password")
        }
    }
    
    /// 是否记住密码
    var rememberPwd:Bool? {
        get{
            return userDefault.value(forKey: "rememberPwd") as? Bool
        }
        set(newValue){
            return userDefault.set(newValue, forKey: "rememberPwd")
        }
    }
    
    /// 用户uuid
    var uuid:Int?{
        get{
            return userDefault.value(forKey: "uuid") as? Int
        }
        set(newValue){
            return userDefault.set(newValue, forKey: "uuid")
        }
    }
    
    /// 用户uid
    var uid:String?{
        get{
            return userDefault.value(forKey: "uid") as? String
        }
        set(newValue){
            return userDefault.set(newValue, forKey: "uid")
        }
    }
    
    @objc var  uuidString: String {
        get {
            return String(format: "%ld",self.uuid ?? 0)
        }
    }
    
    
   
    
    /// ssStudentId
    @objc var ssStudentId:String?{
        get{
            return userDefault.value(forKey: "uid") as? String
        }
        set(newValue){
            return userDefault.set(newValue, forKey: "uid")
        }
    }
    
    /// ssStudentSSOId
    var ssStudentSSOId:Int?{
        get{
            return userDefault.value(forKey: "uuid") as? Int
        }
        set(newValue){
            return userDefault.set(newValue, forKey: "uuid")
        }
    }
    
    /// ULiveName
    @objc var ULiveName:String?{
        get{
            return userDefault.value(forKey: "ULiveName") as? String
        }
        set(newValue){
            return userDefault.set(newValue, forKey: "ULiveName")
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
    
    var adUrl: String? {
        get{
            return userDefault.value(forKey: "adUrl") as? String
        }
        set(newValue){
            return userDefault.set(newValue, forKey: "adUrl")
        }
    }
    /// 是否完成水平测试
    var hasTest:Bool? {
        get{
            return userDefault.value(forKey: "hasTest") as? Bool
        }
        set(newValue){
            return userDefault.set(newValue, forKey: "hasTest")
        }
    }
    
    /// 是否完成完善信息
    var hasFinishInfo:Bool? {
        get{
            return userDefault.value(forKey: "hasFinishInfo") as? Bool
        }
        set(newValue){
            return userDefault.set(newValue, forKey: "hasFinishInfo")
        }
    }
    
    /// 注册成功的token
    var registToken:String? {
        get{
            return userDefault.value(forKey: "registToken") as? String
        }
        set(newValue){
            return userDefault.set(newValue, forKey: "registToken")
        }
    }
    /// 小米登录的openID
    var openId:String? {
        get{
            return userDefault.value(forKey: "openId") as? String
        }
        set(newValue){
            return userDefault.set(newValue, forKey: "openId")
        }
    }
    
    /// 小米授权的access_token
    var access_token:String? {
        get{
            return userDefault.value(forKey: "accessToken") as? String
        }
        set(newValue){
            return userDefault.set(newValue, forKey: "accessToken")
        }
    }
    
    
    func forwardLogin() {
        UserTool.shared.removeAll()
        let vc = UIApplication.shared.keyWindow?.rootViewController
        if UserTool.shared.isOldSystem ?? false {
            let controller = OldSystemController()
            let nav = UINavigationController.init(rootViewController: controller)
            vc?.present(nav, animated: true, completion: nil)
            return
        }
        
        let controller = UULoginController()
        let nav = UINavigationController.init(rootViewController: controller)
        vc?.present(nav, animated: true, completion:nil)
    }

    func synchronize() {
        userDefault.synchronize()
    }
    
    

    @objc func removeAll() {
        JPushManager.clearPushSettings(token: UserTool.shared.gql_token ?? "")
        SSuserDefault.sharedInstance.loginEntrance = "outulive"
        UserDefaults.standard.set(false, forKey: "ListenTestLogin")
        UserDefaults.standard.synchronize()
        userDefault.setValue(false, forKey: "isOldSystem")
        userDefault.set("", forKey: "af_token")
        userDefault.set("", forKey: "gql_token")
        userDefault.set("", forKey: "uid")
        userDefault.set("", forKey: "userId")
        userDefault.set("", forKey: "uuid")
        userDefault.set("", forKey: "token")
        userDefault.set("", forKey: "ULiveName")
        userDefault.set("", forKey: "onceFindLogin")
        userDefault.set(true, forKey: "hasTest")
        userDefault.set(true, forKey: "hasFinishInfo")
        userDefault.set("", forKey: "registToken")
        userDefault.setValue(false, forKey: "isSetPushSetting")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hideListenTestCenterView"), object: Int(0))
        RJBadgeController.clearBadge(forKeyPath: Badge.Personal.message)
    }
}

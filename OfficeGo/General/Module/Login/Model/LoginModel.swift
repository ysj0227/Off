//
//  RegistModel.swift
//  UUStudent
//
//  Created by mac on 2019/5/21.
//  Copyright © 2019 bike. All rights reserved.
//

import UIKit

class LoginModel: BaseModel {

    var rid: Int?
    var rongyuntoken: String?
    var token: String?
    var uid: Int?
}

class LoginUserModel: BaseModel {

    var address : String?
    var avatar : String?
    var birthday : String?
    var businessCard : String?
    var businessLicense : String?
    var channel : Int?
    var company : String?
    var companyVerify : String?
    var createTime : Int?
    var createUser : String?
    var creditNo : String?
    var idBack : String?
    var idCard : String?
    var idFront : String?
    var imei : String?
    var isVip : String?
    var job : String?
    var nickname : String?
    var openId : String?
    var password : String?
    var personalType : String?
    var personalVerify : String?
    var phone : String?
    var proprietorCompany : String?
    var proprietorJob : String?
    var proprietorRealname : String?
    var realname : String?
    var roleType : Int?
    var secret : String?
    ///性别1男性 0女性
    var sex : String?
    var source : Int?
    var status : Int?
    var unionId : String?
    var updateTime : Int?
    var updateUser : String?
    var userId : Int?
    var watchHistory : String?
    var watchSchedule : String?
    var workCard : String?
    var wxId : String?
}

class VersionModel: BaseModel {
    ///提示语
    var desc : String?
    ///是否强制更新
    var force : Bool?
    var updateTime : Int?
    ///更新地址
    var uploadUrl : String?
    ///最新版本号
    var ver : String?
}

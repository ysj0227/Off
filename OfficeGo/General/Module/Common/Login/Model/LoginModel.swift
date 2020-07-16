//
//  RegistModel.swift
//  UUStudent
//
//  Created by mac on 2019/5/21.
//  Copyright © 2019 bike. All rights reserved.
//

import UIKit

class LoginModel: BaseModel {

    ///-1：未选择角色 0：租户，1：业主
    var rid: Int?
    var rongyuntoken: String?
    var token: String?
    var uid: Int?
    var avatar : String?
    var nickName : String?
}

class LoginUserModel: BaseModel {
    
    var avatar : String?
    var phone : String?
    ///性别1男性 0女性
    var sex : String?
    var wxId : String?
    
    var accountStatus : Int?
    var address : String?
    
    ///审核状态0待审核1审核通过2审核未通过 - 没有提交过为-1
    var auditStatus : Int?
    
    ///身份类型0个人1企业2联和办公
    var identityType : Int?
    
    //0员工 1是管理员
    var authority : Int?
    var channel : Int?
    
    ///租户公司 职位 姓名
    var company : String?
    var job : String?
    var realname : String?
    var nickname : String?

    var companyVerify : String?
    var createTime : Int?
    var createUser : String?
    

    
    
    ///1已认证 0未认证 2待认证 3驳回
    var isEnterprise : Int?
    ///1已认证 0未认证 2待认证 3驳回
    var isPersonal : Int?
    
    
    ///租赁类型0直租1转租 - 默认转租
    var leaseType : Int?
    
    
    ///业主公司
    var proprietorCompany : String?
    ///业主职位
    var proprietorJob : String?
    ///业主姓名
    var proprietorRealname : String?
    var remark : String?

    
    ///行程条数
    var trip : Int?
    
    ///收藏数
    var favorite : Int?

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


class OwnerIdentifyUserModel: BaseModel {
    
    var buildingName: String?
    
    var branchName: String?
    
    var idCard : String?

    
    var avatar : String?
    var phone : String?
    ///性别1男性 0女性
    var sex : String?
    var wxId : String?
    
    var accountStatus : Int?
    var address : String?
    
    ///审核状态0待审核1审核通过2审核未通过 - 没有提交过为-1
    var auditStatus : Int?
    
    ///身份类型0个人1企业2联和办公
    var identityType : Int?
    
    //0员工 1是管理员
    var authority : Int?
    var channel : Int?
    
    ///租户公司 职位 姓名
    var company : String?
    var job : String?
    var realname : String?
    var nickname : String?

    var companyVerify : String?
    var createTime : Int?
    var createUser : String?
    

    
    
    ///1已认证 0未认证 2待认证 3驳回
    var isEnterprise : Int?
    ///1已认证 0未认证 2待认证 3驳回
    var isPersonal : Int?
    
    
    ///租赁类型0直租1转租 - 默认转租
    var leaseType : Int?
    
    
    ///业主公司
    var proprietorCompany : String?
    ///业主职位
    var proprietorJob : String?
    ///业主姓名
    var proprietorRealname : String?
    var remark : String?

    
    ///行程条数
    var trip : Int?
    
    ///收藏数
    var favorite : Int?

}

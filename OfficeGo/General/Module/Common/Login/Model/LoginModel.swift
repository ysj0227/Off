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
    
    ///审核状态0待审核1审核通过2审核未通过 3过期，当驳回2处理 - 没有提交过为-1
    var auditStatus : Int?
    
    ///身份类型0个人1企业2联和办公
    var identityType : Int?
    
    ///0员工 1是管理员
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
    
    //企业地址
    var address : String?
    
    ///审核状态0待审核1审核通过2审核未通过 3过期，当驳回2处理 - 4待完善 没有提交过为-1
    var auditStatus : Int?
    
    ///权职0普通员工1管理员
    ///0 就是关联的公司 1的就是自己创建
    var authority : Int?
    
    ///网点名称
    var branchesName : String?
    
    ///楼盘网点标识1楼2网点
    var btype : Int?
    
    ///楼地址
    var buildingAddress : String?
    
    ///楼id - 返回的
    ///有值就是关联的 为空就是自己创建的   楼盘和网点
    ///联办 - 楼盘没有id，只显示名字
    ///管理楼id
    var buildingId : Int?
    
    var buildingManagersId : Int?
    
    ///楼名称
    var buildingName : String?
    
    var buildingStatus : Int?
    
    ///营业执照图片
    var businessLicense : String?
    
    ///公司名称
    var company : String?
    
    ///合同
    var contract : [BannerModel]?
    
    ///营业执照信用码
    var creditNo : String?
    
    ///身份类型0个人1企业2联合
    var identityType : Int?
    
    ///租赁类型0直租1转租
    var leaseType : Int?
    var licenceId : Int?
    var licenceStatus : Int?
    
    ///房产证
    var premisesPermit : [BannerModel]?
    
    ///驳回理由
    var remark : String?
    
    ///用户id
    var userId : Int?
    
    ///申请id
    var userLicenceId : Int?
    
    ///userLicenceStatus
    var userLicenceStatus : Int?
    
    
    ///身份证姓名
    var proprietorRealname : String?
    
    ///身份证
    var idCard : String?
   
    ///身份证正面
    var idFront : String?
    
    ///身份证反面
    var idBack : String?
    ///职位
    var proprietorJob : String?
    
    
    
    ///1提交认证2企业确认3网点确认
    var createCompany : Int?
    
    ///楼id 认证的时候传的字段 - 自己创建的楼的id - 关联
    ///楼名称传过 就会有这个id
    var buildingTempId : Int?
 
    ///营业执照
    var fileBusinessLicense : String?
    
    ///封面图
    var fileMainPic : String?
    
    ///房产证
    var filePremisesPermit : String?
    
    ///合同
    var fileContract : String?
    
    ///用户名
    var userName : String?
    
//    ///身份证正面
//    var fileIdFront : String?
//
//    ///身份证反面面
//    var fileIdBack : String?
    
    ///大区id
    var district : String?
    
    ///商圈id
    var business : String?
    
    
    
    
    ///租赁类型0直租1转租
    var leaseTypeTemp : Int?
    
    ///公司名字 自己选择的 - 可能是接口返回的
    var companyNameTemp: String?
    
    ///自己添加的显示的参数
    ///大区id
    var districtString : String?
    
    ///商圈id
    var businessString : String?
    
    ///楼盘id 自己选择关联之后用自己的 - 没有选择可能是接口返回的
    var buildingTempSelfId: Int?
    
    ///楼盘名字 自己选择的 - 可能是接口返回的
    var buildingNameTemp: String?
    
    ///楼地址
    var buildingAddressTemp : String?
    
    ///网点名字 自己选择的 - 可能是接口返回的
    var branchNameTemp: String?
    
    var userNameTemp: String?
    
    var userIdCardTemp: String?
    
}

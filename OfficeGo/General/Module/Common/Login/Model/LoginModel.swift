//
//  RegistModel.swift
//  UUStudent
//
//  Created by mac on 2019/5/21.
//  Copyright © 2019 bike. All rights reserved.
//

import UIKit

class LoginModel: BaseModel {
    
    ///-1：未选择角色 0：租户，1：房东
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
    
    ///审核状态 0待审核1审核通过2审核未通过5在其他端产生过临时数据（提示去app认证） - 没有提交过为-1
    var auditStatus : Int?
    
    ///租户公司 职位 姓名
    var company : String?
    var job : String?
    //var nickname : String?
    var nickname : String?
    
    ///行程条数
    var trip : Int?
    
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
    
    ///认证状态审核状态0待审核1审核通过2审核未通过 没有提交过为-1
    var auditStatus : String?
    
     ///驳回理由
     var remark : [DictionaryModel]?
    
    ///楼盘网点标识1楼2网点
    var btype : String?
    
    ///楼地址
    var address : String?
        
    ///楼盘网点驳回 - 管理id
    var buildId : String?
    
    ///楼id - 返回的
    ///有值就是关联的 为空就是自己创建的   楼盘和网点
    ///联办 - 楼盘没有id，只显示名字
    ///管理楼id
    var buildingId : String?
        
    ///楼名称
    var buildingName : String?
    
    ///大区id
    var districtId : String?
    
    ///商圈id
    var businessDistrict : String?
    
    ///营业执照图片
    var businessLicense : [String]?
    
    ///身份证正面
    var idFront : String?
    
    ///身份证反面
    var idBack : String?
    
    ///权利人类型1个人2企业
    var isHolder: Int?
    
    ///封面图
    var mainPic : String?
    
    ///公司名称
    var company : String?
    
    ///补充材料
    var materials : [String]?
    
    ///房产证
    var premisesPermit: [String]?
    
    ///用户id
    var userId : String?
    

    
    
    ///驳回原因字符串
    var remarkString : String?
    
    ///楼盘地址 名称不对
    var buildingAddRemark: Bool?
    
    ///房产证不对
    var fczRemark: Bool?
    
    ///营业执照不对
    var businessRemark: Bool?
    
    ///身份证不对
    var idCardRemark: Bool?
    
    ///无补充材料不对
    var addtionalRemark: Bool?
    
    ///房产证图片数组
    var fczLocalLocalImgArr = [BannerModel]()  // 在实际的项目中可能用于存储图片的url
    
    ///补充材料图片数组
    var addtionalLocalImgArr = [BannerModel]()  // 在实际的项目中可能用于存储图片的url
    
    ///营业执照图片数组
    var businessLicenseLocalImgArr = [BannerModel]()  // 在实际的项目中可能用于存储图片的url
    
    //判断身份证照片是否是第一次调取接口
    var isFirst: Bool = false
    
    ///是否是身份证正面
    var isFront: Bool? = true
    
    //身份证 - 正
    var frontBannerModel: BannerModel?
    
    //身份证 - 反
    var reverseBannerModel: BannerModel?
    
    //封面图楼盘
    var mainPicBannermodel: BannerModel?
    
    
    ///自己添加的显示的参数
    
    var provincetName : String?

    ///大区id
    var districtIdName : String?
    
    ///商圈id
    var businessDistrictName : String?
    
    ///0 空   无定义     1创建  2关联吗
    var isCreateBuilding: String?
    
    
}

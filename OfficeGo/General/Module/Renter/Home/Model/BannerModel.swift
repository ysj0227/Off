//
//  BannerModel.swift
//  OfficeGo
//
//  Created by mac on 2020/5/29.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit
import Photos

class BannerModel: BaseModel {
    var bannerName : String?
    var content : String?
    var createTime : Int?
    var createUser : AnyObject?
    ///图片播放时长秒
    var duration : Int?
    var id : Int?
    ///轮播图片
    var img : String?
    ///下架时间
    var offline : Int?
    ///上架时间
    var online : Int?
    var ordernum : Int?
    ///内链类型的id
    var pageId : Int?
    ///内链类型，1：楼盘详情，2:网点详情 3:楼盘房源详情,4:网点房源详情
    var pageType : Int?
    var position : Int?
    ///图片所属端，1：H5，2：IOS，3：安卓,4:web
    var positionDuan : Int?
    var remark : String?
    var status : Int?
    ///类型:0不可跳转,1内链 2:富文本 3外链
    var type : Int?
    var updateTime : Int?
    var updateUser : AnyObject?
    var wurl : String?
    
    var image : UIImage?
    ///默认是网络图片- 为true表示是本地选择上传的图片
    var isLocal: Bool = false
    var imgUrl : String?
    var videoAsset: PHAsset?
}


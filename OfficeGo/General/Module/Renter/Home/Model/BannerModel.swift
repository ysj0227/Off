//
//  BannerModel.swift
//  OfficeGo
//
//  Created by mac on 2020/5/29.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class BannerModel: BaseModel {
    var img: String?      //轮播图片
    var createTime : Int?
    var createUser : String?
    var id : Int?
    var imgType : Int?
    var imgUrl : String?
    var remark : AnyObject?
    var status : Int?
    var typeId : Int?
    var updateTime : Int?
    var updateUser : String?
    var image : UIImage?
    ///默认是网络图片- 为true表示是本地选择上传的图片
    var isLocal: Bool = false
}


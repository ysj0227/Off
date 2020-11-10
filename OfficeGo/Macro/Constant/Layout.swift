//
//  Layout.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/5/8.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

let kHeight:CGFloat = UIScreen.main.bounds.size.height

let kWidth:CGFloat = UIScreen.main.bounds.size.width

///计算最小工位的时候除以的分母 面积/minSeatsFM_5
let minSeatsFM_5 : Float = 5

///计算最大工位的时候除以的分母 面积/maxSeatsFM_5
let maxSeatsFM_3 : Float = 3

//图片压缩的时候，最大的尺寸
let maxImgWidthOrHeight_1500: CGFloat = 1000.0

//图片最大体积数
let maxImgSize_20480: CGFloat = 20480.0 * 1000

let maxImgSize_20: CGFloat = 20.0 * 1000

//房产证最多图片数
let ownerMaxFCZNumber_4 = 4

//租赁协议最多图片数
let ownerMaxZLAgentNumber_5 = 5

///创建楼盘上传的楼盘图片
let ownerBuildingImageNumber_9 = 9


//房东 - 认证 -公司名称最大数
let ownerMaxCompanynameNumber_20 = 20

//房东 - 认证 -写字楼名称，20个字
let ownerMaxBuildingnameNumber_20 = 20

//房东 - 认证 -详细地址，30字
let ownerMaxAddressDetailNumber_30 = 30

//房东 - 认证 -网点名称，20字
let ownerMaxBranchnameNumber_20 = 20

//房东 - 认证 -营业执照注册号，20数字
let ownerMaxCompanyYingyezhizhaoNumber_20 = 20

//房东 - 认证 -姓名，10字
let ownerMaxUsernameNumber_10 = 10

//房东 - 认证 -身份证号 18字
let ownerMaxIDCardNumber_18 = 18




let imgScale: CGFloat = 3 / 4.0

let login_left_pending_space_30 = 30

let left_pending_space_17: CGFloat = 17

let btnHeight = 52

let btnHeight_44: CGFloat = 44

let btnHeight_50: CGFloat = 50

let cell_height_53: CGFloat = 53

let cell_height_58: CGFloat = 58

let cell_height_30: CGFloat = 30


//按钮的圆角
let button_cordious_2: CGFloat = 2

let button_cordious_8: CGFloat = 8

let button_cordious_12: CGFloat = 12

//头像的圆角
let heder_cordious_36: CGFloat = 36

let button_cordious_15: CGFloat = 15

let btnMargin_15: CGFloat = 15

let btnWidth: CGFloat = (kWidth - 90) / 3.0

let kStatusBarHeight = UIApplication.shared.statusBarFrame.height

let kNavigationHeight = kStatusBarHeight + 44

let kNavigationHeight_Higher = kStatusBarHeight + 100

let kMessageAlertWidth_266: CGFloat = 266

let kMessageLayoutAlertHeight_50: CGFloat = 50

let kMessageAlertHeight_120: CGFloat = 120

let kMessageInputAlertHeight_158: CGFloat = 158

let kIsiPhoneX = kStatusBarHeight == 44 ? true : false

let noLimitMaxNum_999999999: Double  = 999999999

let enterCompanyMaxNum_5: Int = 5


///开发debug
let API_Debug: String = "debug"

///预发test
let API_Test: String = "test"

///正式release
let API_Release: String = "release"

func bottomMargin() -> CGFloat {
    if #available(iOS 11.0, *) {
        return UIApplication.shared.delegate?.window??.safeAreaInsets.bottom ?? 0
    } else {
        return 0
    }
}

let kTimeOutNumber:Int = 60
let kTabBarHeight = 49 + bottomMargin()


extension UIView {
    var width: CGFloat {
        get {
            return self.frame.width
        }
        set {
            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: newValue, height: self.frame.height)
        }
    }
    var height: CGFloat {
        get {
            return self.frame.height
        }
        set {
            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width, height: newValue)
        }
    }
    var top: CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            self.frame = CGRect(x: self.frame.origin.x, y: newValue, width: self.frame.width, height: self.frame.height)
        }
    }
    var bottom: CGFloat {
        get {
            return self.frame.origin.y + height
        }
        set {
            self.frame = CGRect(x: self.frame.origin.x, y: newValue - height, width: self.frame.width, height: self.frame.height)
        }
    }
    var left: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            self.frame = CGRect(x: newValue, y: self.frame.origin.y, width: self.frame.width, height: self.frame.height)
        }
    }
    var right: CGFloat {
        get {
            return self.frame.origin.x + width
        }
        set {
            self.frame = CGRect(x: newValue - width, y: self.frame.origin.y, width: self.frame.width, height: self.frame.height)
        }
    }
}




extension NSObject {
    // MARK:返回className
    var className:String{
        get{
            let name =  type(of: self).description()
            if(name.contains(".")){
                return name.components(separatedBy: ".")[1];
            }else{
                return name;
            }
            
        }
    }
    
}

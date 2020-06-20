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

let imgScale: CGFloat = 3 / 4.0

let login_left_pending_space_30 = 30

let left_pending_space_17: CGFloat = 17

let btnHeight = 52

let btnHeight_44: CGFloat = 44

let btnHeight_50: CGFloat = 50

//按钮的圆角
let button_cordious_2: CGFloat = 2

//头像的圆角
let heder_cordious_32: CGFloat = 32

let button_cordious_15: CGFloat = 15

let btnMargin: CGFloat = 15

let btnWidth: CGFloat = (kWidth - 90) / 3.0

let kStatusBarHeight = UIApplication.shared.statusBarFrame.height

let kNavigationHeight = kStatusBarHeight + 44

let kNavigationHeight_Higher = kStatusBarHeight + 100

let kMessageAlertWidth: CGFloat = 266

let kMessageAlertHeight: CGFloat = 120

let kMessageInputAlertHeight: CGFloat = 158

let kIsiPhoneX = kStatusBarHeight == 44 ? true : false

func bottomMargin() -> CGFloat {
    if #available(iOS 11.0, *) {
        return UIApplication.shared.delegate?.window??.safeAreaInsets.bottom ?? 0
    } else {
        return 0
    }
}

let kTimeOutNumber:Int = 60
let kTabBarHeight = 49 + bottomMargin()

struct DefaultImg {

    static let Default_4x3 = "default4*3"

    static let Default_1x1 = "default4*3"
}

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

//
//  ShareViewController.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/5/8.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class ShareViewController: UIViewController {
    
    
    @IBOutlet weak var platformView: UIView!
    @IBOutlet weak var wechatButton: UIButton!
    @IBOutlet weak var wechatFriendButton: UIButton!
    @IBOutlet weak var sinaButton: UIButton!
    @IBOutlet weak var isShareLabel: UILabel!
    
    
    var isPosterShare: Bool = false
    var imggg: UIImage?
    
    var liveid = "0"
    var classid = "0"
    var teacehrid = "0"
    var shareType = ""
    var teacherName = ""
    var courseName = ""
    var courseIntro = ""
    var courseImage = ""
    var shareStatus = "live"
    
    
    class func initialization() -> ShareViewController {
        
        let view = ShareViewController(nibName: "ShareViewController", bundle: nil)
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        platformView.clipsToBounds = true
        platformView.layer.cornerRadius = 15
        handlePlatformInstalled()
  
    }
    
    /*/
     #import <UShareUI/UShareUI.h>
      [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_Sina),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_WechatSession)]];
      [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
         // 根据获取的platformType确定所选平台进行下一步操作
     }];
     */

    func handlePlatformInstalled() {

        let isWXAppInstalled = UIApplication.shared.canOpenURL(URL(string: "wechat://")!)

        let isSinaAppInstalled = UIApplication.shared.canOpenURL(URL(string: "weibo://")!)

        //判断微信有没有安装
        if isWXAppInstalled == false && isSinaAppInstalled == false {
            wechatButton.isHidden = true
            wechatFriendButton.isHidden = true
            sinaButton.isHidden = true
            isShareLabel.isHidden = false
        }else {
            isShareLabel.isHidden = true
            if isWXAppInstalled == true && isSinaAppInstalled == false {
                wechatButton.isHidden = false
                wechatFriendButton.isHidden = false

            }else if isWXAppInstalled == false && isSinaAppInstalled == true {
                wechatButton.isHidden = true
                wechatFriendButton.isHidden = true
                sinaButton.isHidden = false
            }else {
                wechatButton.isHidden = false
                wechatFriendButton.isHidden = false
                sinaButton.isHidden = false

            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

  
  @IBAction func shareToSina(_ sender: Any) {
      shareType = "新浪"
      if isPosterShare {
          shareImageToPlatform(platformType: .QQ)
      }else {
          shareToPlatform(platformType: .QQ)
      }
  }
     
  @IBAction func shareToWechat(_ sender: Any) {
       shareType = "微信好友"
       if isPosterShare {
           shareImageToPlatform(platformType: .wechatSession)
       }else {
           shareToPlatform(platformType: .wechatSession)
       }
   }
  @IBAction func shareToWeChatFriend(_ sender: Any) {
      shareType = "朋友圈"
      if isPosterShare {
          shareImageToPlatform(platformType: .wechatTimeLine)
      }else {
          shareToPlatform(platformType: .wechatTimeLine)
      }
  }

  @IBAction func shareToQQZone(_ sender: Any) {
      shareType = "QQ空间"
      if isPosterShare {
          shareImageToPlatform(platformType: .qzone)
      }else {
          shareToPlatform(platformType: .qzone)
      }
  }
  
  
  @IBAction func cancelShare(_ sender: Any) {
      dismiss(animated: true, completion: nil)
  }
    
    func shareToPlatform(platformType: UMSocialPlatformType) {
//        let userModel = UserTool.shared
//        let userId = userModel.uid
//        var title = ""
        var content = "分享"
        var image: AnyObject = UIImage(imageLiteralResourceName: "share_icon")
        var webpageUrl = ""
//
//        if shareStatus == "live" {
//            title = "有趣有料的外教老师喊你来上课啦"
//            content = "专业外教，懂教育，更懂小朋友，赶快加入体验一下吧！"
//            webpageUrl = SSAPI.ShareHost + "share?userid=\(userId ?? "")&classid=\(classid)"
//        }else {
//            title = "快来看\(teacherName)老师讲\(courseName)"
//            content = courseIntro.count == 0 ? "专业外教，懂教育，更懂小朋友，赶快加入体验一下吧！":courseIntro
//            image = courseImage as AnyObject
//            webpageUrl = SSAPI.ShareHost + "share/\(liveid)?userid=\(userId ?? "")&classid=\(classid)"
//        }
        webpageUrl = "https://baidu.com"
        let message = UMSocialMessageObject()
        let object = UMShareWebpageObject.shareObject(withTitle: title, descr: content, thumImage: image)
        object?.webpageUrl = webpageUrl
        message.shareObject = object!
        UMSocialManager.default().share(to: platformType, messageObject: message, currentViewController: self, completion: { (data, error) in
            if error == nil {
                if let respose = data as? UMSocialShareResponse {
                    print(respose.message)
                }
            }else {
                let err = error! as NSError
                if err.code == 2009 {
                    print("分享已取消")
                }else {
                    print(err.userInfo["message"] as? String ?? "")
                }
            }
        })

    }
    
    func shareImageToPlatform(platformType: UMSocialPlatformType) {
        //创建分享消息对象
        let messageObject = UMSocialMessageObject()
        //创建图片内容对象
        let shareObject = UMShareImageObject()

        if let img = imggg {
            //图片缩略图
            shareObject.thumbImage = img
            //图片地址
            shareObject.shareImage = img
        }
        messageObject.shareObject = shareObject
        UMSocialManager.default().share(to: platformType, messageObject: messageObject, currentViewController: self, completion: { (data, error) in
            if error == nil {
                if let respose = data as? UMSocialShareResponse {
                    print(respose.message)
                }
            }else {
                let err = error! as NSError
                if err.code == 2009 {
                    print("分享已取消")
                }else {
                    print(err.userInfo["message"] as? String ?? "")
                }
            }
        })
    }
    
    
    
}

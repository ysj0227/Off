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

            
        
//        let isWXAppInstalled = UMSocialManager.isInstall(UMSPlatformNameWhatsapp)
//
//        let isSinaAppInstalled = UIApplication.shared.canOpenURL(URL(string: "weibo://")!)

        let isWXAppInstalled = true
        sinaButton.isHidden = true

        //判断微信有没有安装
        if isWXAppInstalled == false {
            wechatButton.isHidden = true
            wechatFriendButton.isHidden = true
            isShareLabel.isHidden = false
            
        }else {
            isShareLabel.isHidden = true
            wechatButton.isHidden = false
            wechatFriendButton.isHidden = false
            self.wechatButton.snp.makeConstraints { (make) in
                make.left.equalTo((kWidth - 140)/3)
                make.top.equalTo(20)
                make.size.equalTo(CGSize(width: 70, height: 90))
            }
            self.wechatFriendButton.snp.makeConstraints { (make) in
                make.right.equalTo(-(kWidth - 140)/3)
                make.top.equalTo(20)
                make.size.equalTo(CGSize(width: 70, height: 90))
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
//          shareImageToPlatform(platformType: .QQ)
      }else {
//          shareToPlatform(platformType: .QQ)
      }
  }
     
  @IBAction func shareToWechat(_ sender: Any) {
       shareType = "微信好友"
//      shareToPlatform(platformType: .wechatSession)
   }
  @IBAction func shareToWeChatFriend(_ sender: Any) {
      shareType = "朋友圈"
//     shareImageToPlatform(platformType: .wechatSession)
  }

  @IBAction func shareToQQZone(_ sender: Any) {
      shareType = "QQ空间"
      if isPosterShare {
//          shareImageToPlatform(platformType: .qzone)
      }else {
//          shareToPlatform(platformType: .qzone)
      }
  }
  
  
  @IBAction func cancelShare(_ sender: Any) {
      dismiss(animated: true, completion: nil)
  }
    /*
    func shareToPlatform(platformType: UMSocialPlatformType) {
        var content = "分享"
        var image = "https://img.officego.com/head.png"

        var webpageUrl = ""
        title = "分享"
        content = "房源详情"
        webpageUrl = "http://test.officego.com.cn/lessee/housesDetail.html?buildingId=256"
        let message = UMSocialMessageObject()
        let object = UMShareWebpageObject.shareObject(withTitle: title, descr: content, thumImage: image)
        object?.webpageUrl = webpageUrl
        message.shareObject = object!
        UMSocialManager.default().share(to: platformType, messageObject: message, currentViewController: self, completion: { (data, error) in
            if error == nil {
                if let respose = data as? UMSocialShareResponse {
                    SSLog(respose.message ?? "")
                }
            }else {
                let err = error! as NSError
                if err.code == 2009 {
                    SSLog("分享已取消")
                }else {
                    SSLog(err.userInfo["message"] as? String ?? "")
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
            shareObject.thumbImage = "https://img.officego.com/head.png"
            //图片地址
            shareObject.shareImage = "https://img.officego.com/head.png"
        }
        shareObject.shareImage = "https://img.officego.com/head.png"
        messageObject.shareObject = shareObject
        UMSocialManager.default().share(to: platformType, messageObject: messageObject, currentViewController: self, completion: { (data, error) in
            if error == nil {
                if let respose = data as? UMSocialShareResponse {
                    SSLog(respose.message)
                }
            }else {
                let err = error! as NSError
                if err.code == 2009 {
                    SSLog("分享已取消")
                }else {
                    SSLog(err.userInfo["message"] as? String ?? "")
                }
            }
        })
    }
    
    */
    
}

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
        
    var buildingName: String = ""
    var descriptionString: String = ""
    var shareUrl: String = ""
    var thumbImage: String?
    
    
    class func initialization() -> ShareViewController {
        
        let view = ShareViewController(nibName: "ShareViewController", bundle: nil)
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        platformView.clipsToBounds = true
        platformView.layer.cornerRadius = button_cordious_2
        handlePlatformInstalled()
        
    }
    
    func handlePlatformInstalled() {
        
        
        let isWXAppInstalled = WXApi.isWXAppInstalled()
        
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
        
    }
    
    @IBAction func shareToWechat(_ sender: Any) {
        shareToPlatform(platformType: 0, sender)
    }
    @IBAction func shareToWeChatFriend(_ sender: Any) {
        shareToPlatform(platformType: 1, sender)
    }
    
    @IBAction func shareToQQZone(_ sender: Any) {
        
    }
    
    
    @IBAction func cancelShare(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func shareToPlatform(platformType: Int, _ sender: Any) {
        let webpageObject = WXWebpageObject()
        webpageObject.webpageUrl = shareUrl
        let message = WXMediaMessage()
        message.title = buildingName
        message.description = descriptionString
        if let url = thumbImage {
            let imageview = BaseImageView()
            imageview.setImage(with: url, placeholder: UIImage(named: Default_1x1))
            if let image = imageview.image {
                message.setThumbImage(image.scaleImage(scaleSize: 200))
            }
        }
        message.mediaObject = webpageObject
        
        let req = SendMessageToWXReq()
        req.bText = false;
        req.message = message;
        req.scene = Int32(platformType);
        WXApi.send(req, completion: nil)
        
        cancelShare(sender)
    }
    
}

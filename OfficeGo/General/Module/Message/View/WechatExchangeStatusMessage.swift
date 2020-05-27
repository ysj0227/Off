//
//  WechatExchangeStatusMessage.swift
//  OfficeGo
//
//  Created by mac on 2020/5/26.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class WechatExchangeStatusMessage: RCMessageContent, NSCoding {
    
    // 测试消息的内容
    var content: String = ""
    
    // 测试消息的附加信息
    var extraMessage: String? = ""
    
    var isAgree: Bool = false
    
    // 根据参数创建消息对象
    class func messageWithContent(content: String, isAgree: Bool) -> WechatExchangeStatusMessage {
        let testMessage = WechatExchangeStatusMessage()
        testMessage.content = content
        testMessage.isAgree = isAgree
        return testMessage
    }
    
    // 返回消息的存储策略
    override class func persistentFlag() -> RCMessagePersistent {
        return RCMessagePersistent(rawValue: RCMessagePersistent.MessagePersistent_ISPERSISTED.rawValue | RCMessagePersistent.MessagePersistent_ISCOUNTED.rawValue) ?? RCMessagePersistent.MessagePersistent_ISCOUNTED
    }
    
    override init() {
        super.init()
    }
    
    // NSCoding
    required init(coder aDecoder: NSCoder) {
        super.init()
        content = aDecoder.decodeObject(forKey: "content") as? String ?? ""
        extraMessage = aDecoder.decodeObject(forKey: "extraMessage") as? String ?? ""
        isAgree = aDecoder.decodeObject(forKey: "isAgree") as? Bool ?? false
    }
    
    // NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(content, forKey: "content")
        aCoder.encode(extraMessage, forKey: "extraMessage")
        aCoder.encode(isAgree, forKey: "isAgree")
        
    }
    
    // 序列化，将消息内容编码成 json
    override func encode() -> Data! {
        var dataDict: [String : Any] = [:]
        
        dataDict["content"] = content
        if let extraMessage = extraMessage {
            dataDict["extraMessage"] = extraMessage
        }
        dataDict["isAgree"] = isAgree
        
        if let senderUserInfo = senderUserInfo {
            dataDict["user"] = self.encode(senderUserInfo)
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: dataDict, options: .prettyPrinted)
            return data
        } catch {
            print(error)
            return Data()
        }
    }
    
    // 反序列化，解码生成可用的消息内容
    override func decode(with data: Data!) {
        do {
            let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String : Any]
            content = dictionary["content"] as? String ?? ""
            extraMessage = dictionary["extraMessage"] as? String ?? ""
            isAgree = dictionary["isAgree"] as? Bool ?? false
            let userInfoDict = dictionary["user"] as? [String : Any] ?? [:]
            decodeUserInfo(userInfoDict)
        } catch {
            print(error)
        }
    }
    
    // 显示的消息内容摘要
    override func conversationDigest() -> String! {
        return content
    }
    
    // 返回消息的类型名
    override class func getObjectName() -> String! {
        return AppKey.ExchangePhoneStatusMessageTypeIdentifier
    }
}


class WechatExchangeStatusMessageCell: RCMessageCell {
    
    // 消息显示的 label
    lazy var textLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.font = UIFont.systemFont(ofSize: textMessageFontSize)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .left
        label.textColor = .black
        label.isUserInteractionEnabled = true
        return label
    }()
    
    // 消息显示的 label
    lazy var lookupBtn: UIButton = {
        let view = UIButton()
        view.setTitleColor(kAppBlueColor, for: .normal)
        view.titleLabel?.font = FONT_13
        view.setTitle("复制微信", for: .normal)
        return view
    }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = kAppColor_line_EEEEEE
        return view
    }()
    
    // 消息背景
    lazy var bubbleBackgroundView: UIImageView = {
        let imageView = UIImageView(frame: CGRect.zero)
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    // 自定义消息 Cell 的 Size
    override class func size(for model: RCMessageModel!, withCollectionViewWidth collectionViewWidth: CGFloat, referenceExtraHeight extraHeight: CGFloat) -> CGSize {
        
        let message = model.content as? WechatExchangeStatusMessage
        let size = getBubbleBackgroundViewSize(message ?? WechatExchangeStatusMessage.messageWithContent(content: "", isAgree: false), messageDirection: model.messageDirection)
        
        var messagecontentviewHeight = size.height;
        messagecontentviewHeight = messagecontentviewHeight + extraHeight;
        return CGSize(width: collectionViewWidth, height: messagecontentviewHeight)
    }
    
    override init!(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    func initialize() {
        messageContentView.addSubview(bubbleBackgroundView)
        bubbleBackgroundView.addSubview(textLabel)
        bubbleBackgroundView.addSubview(lookupBtn)
        bubbleBackgroundView.addSubview(lineView)
        
        
        // (UIApplication.registerUserNotificationSettings(_:))
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(_:)))
        bubbleBackgroundView.addGestureRecognizer(longPress)
        
        let textMessageTap = UITapGestureRecognizer(target: self, action: #selector(tapTextMessage(_:)))
        textMessageTap.numberOfTapsRequired = 1
        textMessageTap.numberOfTouchesRequired = 1
        textLabel.addGestureRecognizer(textMessageTap)
    }
    
    @objc private func longPressed(_ sender: UILongPressGestureRecognizer) {
        
    }
    
    @objc private func tapTextMessage(_ tap: UITapGestureRecognizer) {
        
        if let delegate = delegate {
            delegate.didTapMessageCell!(model)
        }
    }
    
    override func setDataModel(_ model: RCMessageModel!) {
        super.setDataModel(model)
        
        setContent(model)
        setAutoLayout()
    }
    
    private func setContent(_ model: RCMessageModel!) {
        //接收 -
        if RCMessageDirection.MessageDirection_RECEIVE == messageDirection {
            let testMessage = model.content as? WechatExchangeStatusMessage
            if testMessage?.isAgree == true {
//                testMessage?.content = "18516765366"
            }else {
                testMessage?.content = "对方拒绝交换微信"
            }
        }else {
            let testMessage = model.content as? WechatExchangeStatusMessage
            if testMessage?.isAgree == true {
                testMessage?.content = "你的微信已经发送给对象～"
            }else {
                testMessage?.content = "您已拒绝对方获取微信的请求～"
            }
        }
    }
    
    private func setAutoLayout() {
        
        let testMessage = model.content as? WechatExchangeStatusMessage
        
        textLabel.text = testMessage?.content
        
        let textLabelSize = WechatExchangeStatusMessageCell.getTextLabelSize(testMessage ?? WechatExchangeStatusMessage.messageWithContent(content: "", isAgree: testMessage?.isAgree ?? false), messageDirection: messageDirection)
        
        let bubbleBackgroundViewSize = WechatExchangeStatusMessageCell.getBubbleSize(textLabelSize)
        var messageContentViewRect = messageContentView.frame
        
        //接收 -
        if RCMessageDirection.MessageDirection_RECEIVE == messageDirection {
            
            if testMessage?.isAgree == true {
                lineView.isHidden = false
                lookupBtn.isHidden = false
                textLabel.frame = CGRect(x: 20, y: 7, width: textLabelSize.width, height: textLabelSize.height - 45)
                lineView.frame = CGRect(x: 6, y: textLabel.bottom + 14, width: bubbleBackgroundViewSize.width - 12, height: 1)
                lookupBtn.frame = CGRect(x: 6, y: lineView.bottom, width: bubbleBackgroundViewSize.width - 6, height: 45)
                messageContentViewRect.size.width = bubbleBackgroundViewSize.width
                messageContentView.frame = messageContentViewRect
                
                bubbleBackgroundView.frame = CGRect(x: 0, y: 0, width: bubbleBackgroundViewSize.width, height: bubbleBackgroundViewSize.height)
                let image = UIImage.create(with: kAppWhiteColor)
                let imageHeigth = image?.size.height ?? 0
                let imageWidth = image?.size.width ?? 0
                bubbleBackgroundView.image = image?.resizableImage(withCapInsets: UIEdgeInsets(top: imageHeigth * 0.8, left: imageWidth * 0.8, bottom: imageHeigth * 0.2, right: imageWidth * 0.2))
            }else {
                lineView.isHidden = true
                lookupBtn.isHidden = true
                textLabel.frame = CGRect(x: 20, y: 7, width: textLabelSize.width, height: textLabelSize.height)
                
                messageContentViewRect.size.width = bubbleBackgroundViewSize.width
                messageContentView.frame = messageContentViewRect
                
                bubbleBackgroundView.frame = CGRect(x: 0, y: 0, width: bubbleBackgroundViewSize.width, height: bubbleBackgroundViewSize.height)
                let image = UIImage.create(with: kAppWhiteColor)
                let imageHeigth = image?.size.height ?? 0
                let imageWidth = image?.size.width ?? 0
                bubbleBackgroundView.image = image?.resizableImage(withCapInsets: UIEdgeInsets(top: imageHeigth * 0.8, left: imageWidth * 0.8, bottom: imageHeigth * 0.2, right: imageWidth * 0.2))
            }
        }
            //发送方
        else {
            lineView.isHidden = true
            lookupBtn.isHidden = true
            
            textLabel.frame = CGRect(x: 12, y: 7, width: textLabelSize.width, height: textLabelSize.height)
            
            messageContentViewRect.size.width = bubbleBackgroundViewSize.width
            messageContentViewRect.size.height = bubbleBackgroundViewSize.height
            
            let portraitWidht = RCIM.shared().globalMessagePortraitSize.width
            messageContentViewRect.origin.x = baseContentView.bounds.size.width - (messageContentViewRect.size.width + CGFloat(HeadAndContentSpacing) + portraitWidht + 10)
            
            messageContentView.frame = messageContentViewRect
            
            bubbleBackgroundView.frame = CGRect(x: 0, y: 0, width: bubbleBackgroundViewSize.width, height: bubbleBackgroundViewSize.height)
            //            let image = RCKitUtility.imageNamed("chat_to_bg_normal", ofBundle: "RongCloud.bundle")
            let image = UIImage.create(with: kAppWhiteColor)
            
            let imageHeigth = image?.size.height ?? 0
            let imageWidth = image?.size.width ?? 0
            bubbleBackgroundView.image = image?.resizableImage(withCapInsets: UIEdgeInsets(top: imageHeigth * 0.8, left: imageWidth * 0.2, bottom: imageHeigth * 0.2, right: imageWidth * 0.8))
        }        
    }
    
    private class func getTextLabelSize(_ message: WechatExchangeStatusMessage, messageDirection: RCMessageDirection) -> CGSize {
        
        if !message.content.isEmpty {
            let screenWidth = UIScreen.main.bounds.size.width
            let portraitWidth = RCIM.shared()?.globalMessagePortraitSize.width
            let portrait = (10 + (portraitWidth ?? 0.0) + 10) * 2
            let maxWidth = screenWidth - portrait - 5 - 35
            
            var textRect = (message.content).boundingRect(with: CGSize(width: maxWidth, height: 8000), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: textMessageFontSize)], context: nil)
            textRect.size.height = CGFloat(ceilf(Float(textRect.size.height)))
            textRect.size.width = CGFloat(ceilf(Float(textRect.size.width)))
            
            if messageDirection == RCMessageDirection.MessageDirection_RECEIVE {
                
                if message.isAgree == true {
                    return CGSize(width: textRect.size.width + 5, height: textRect.size.height + 45)
                    
                }else {
                    return CGSize(width: textRect.size.width + 5, height: textRect.size.height)
                }
            }else {
                if message.isAgree == true {
                    return CGSize(width: textRect.size.width + 5, height: textRect.size.height)
                    
                }else {
                    return CGSize(width: textRect.size.width + 5, height: textRect.size.height)
                }
            }
            
        } else {
            return CGSize.zero
        }
    }
    
    private class func getBubbleSize(_ textLabelSize: CGSize) -> CGSize {
        var bubbleSize = CGSize(width: textLabelSize.width, height: textLabelSize.height)
        
        if bubbleSize.width + 12 + 20 > 50 {
            bubbleSize.width = bubbleSize.width + 12 + 20
        } else {
            bubbleSize.width = 50
        }
        
        if bubbleSize.height + 7 + 7 > 40 {
            bubbleSize.height = bubbleSize.height + 7 + 7
        } else {
            bubbleSize.height = 40
        }
        
        return bubbleSize
    }
    
    public class func getBubbleBackgroundViewSize(_ message: WechatExchangeStatusMessage, messageDirection: RCMessageDirection) -> CGSize {
        
        let textLabelSize = WechatExchangeStatusMessageCell.getTextLabelSize(message, messageDirection: messageDirection)
        return WechatExchangeStatusMessageCell.getBubbleSize(textLabelSize)
        
    }
    
}

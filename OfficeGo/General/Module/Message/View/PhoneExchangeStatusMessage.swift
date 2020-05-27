//
//  PhoneExchangeStatusMessage.swift
//  OfficeGo
//
//  Created by mac on 2020/5/26.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class PhoneExchangeStatusMessage: RCMessageContent, NSCoding {
    
    // 测试消息的内容
    var content: String = ""
    
    // 测试消息的附加信息
    var extraMessage: String? = ""
    
    var isAgree: Bool = false
    
    // 根据参数创建消息对象
    class func messageWithContent(content: String, isAgree: Bool) -> PhoneExchangeStatusMessage {
        let testMessage = PhoneExchangeStatusMessage()
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


class PhoneExchangeStatusMessageCell: RCMessageBaseCell {
    
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
    
    //复制按钮
    lazy var copyBtn: UIButton = {
        let view = UIButton()
        view.setTitleColor(kAppBlueColor, for: .normal)
        view.titleLabel?.font = FONT_13
        view.setTitle("复制号码", for: .normal)
        return view
    }()
    
    //复制按钮
    lazy var dailBtn: UIButton = {
        let view = UIButton()
        view.setTitleColor(kAppBlueColor, for: .normal)
        view.titleLabel?.font = FONT_13
        view.setTitle("立即拨打", for: .normal)
        return view
    }()
    lazy var btnlineView: UIView = {
           let view = UIView()
           view.backgroundColor = kAppColor_line_EEEEEE
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
        imageView.backgroundColor = kAppColor_bgcolor_F7F7F7
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    // 自定义消息 Cell 的 Size
    override class func size(for model: RCMessageModel!, withCollectionViewWidth collectionViewWidth: CGFloat, referenceExtraHeight extraHeight: CGFloat) -> CGSize {
        
        let message = model.content as? PhoneExchangeStatusMessage ?? PhoneExchangeStatusMessage.messageWithContent(content: "", isAgree: false)
        let size = PhoneExchangeStatusMessageCell.getTextLabelSize(message, messageDirection: model.messageDirection)
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
        
        baseContentView.addSubview(bubbleBackgroundView)
        bubbleBackgroundView.addSubview(textLabel)
        bubbleBackgroundView.addSubview(copyBtn)
        bubbleBackgroundView.addSubview(lineView)
        
        
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
        let testMessage = model.content as? PhoneExchangeStatusMessage
        //接收 -
        if RCMessageDirection.MessageDirection_RECEIVE == messageDirection {
            if testMessage?.isAgree == true {
                testMessage?.content = "电话已交换！\n 对方电话：1234567890"
            }else {
                testMessage?.content = "对方拒绝交换手机号"
            }
        }else {
            if testMessage?.isAgree == true {
                testMessage?.content = "手机号已经发送给对方"
            }else {
                testMessage?.content = "已拒绝"
            }
        }
    }
    
    private func setAutoLayout() {
        
        let testMessage = model.content as? PhoneExchangeStatusMessage
        
        textLabel.text = testMessage?.content
        
        let textLabelSize = PhoneExchangeStatusMessageCell.getTextLabelSize(testMessage ?? PhoneExchangeStatusMessage.messageWithContent(content: "", isAgree: testMessage?.isAgree ?? false), messageDirection: messageDirection)
        baseContentView.frame = CGRect(x: (UIScreen.main.bounds.size.width - 112) / 2.0, y:0, width: 112, height: textLabelSize.height)
        bubbleBackgroundView.frame = CGRect(x: 0, y:0, width: 112, height: textLabelSize.height)
        
        //接收 -
        if RCMessageDirection.MessageDirection_RECEIVE == messageDirection {
            
            if testMessage?.isAgree == true {
                
                lineView.isHidden = false
                copyBtn.isHidden = false
                dailBtn.isHidden = false
                btnlineView.isHidden = false
                
                textLabel.frame = CGRect(x: 0, y:0, width: bubbleBackgroundView.width, height: 32)
                lineView.frame = CGRect(x: 3.5, y: textLabel.bottom, width: bubbleBackgroundView.width - 7, height: 1)
                copyBtn.frame = CGRect(x: 0, y: lineView.bottom, width: bubbleBackgroundView.width / 2.0, height: 32)
                btnlineView.frame = CGRect(x: copyBtn.right, y: copyBtn.top, width: 1.0, height: copyBtn.height)
                dailBtn.frame = CGRect(x: bubbleBackgroundView.width / 2.0, y: lineView.bottom, width: bubbleBackgroundView.width / 2.0, height: 45)
            }else {
                
                lineView.isHidden = true
                copyBtn.isHidden = true
                dailBtn.isHidden = true
                btnlineView.isHidden = true
                textLabel.frame = CGRect(x: 0, y:0, width: bubbleBackgroundView.width, height: 32)
            }
        }
            //发送方
        else {
            
            lineView.isHidden = true
            copyBtn.isHidden = true
            dailBtn.isHidden = true
            btnlineView.isHidden = true
            textLabel.frame = CGRect(x: 0, y:0, width: bubbleBackgroundView.width, height: 32)
        }
    }
    
    private class func getTextLabelSize(_ message: PhoneExchangeStatusMessage, messageDirection: RCMessageDirection) -> CGSize {
        if RCMessageDirection.MessageDirection_RECEIVE == messageDirection {
            if message.isAgree == true {
                message.content = "电话已交换！\n 对方电话：1234567890"
            }else {
                message.content = "对方拒绝交换手机号"
            }
        }else {
            if message.isAgree == true {
                message.content = "手机号已经发送给对方"
            }else {
                message.content = "已拒绝"
            }
        }
        
        if !message.content.isEmpty {
            
            if messageDirection == RCMessageDirection.MessageDirection_RECEIVE {
                
                if message.isAgree == true {
                    
                    return CGSize(width: 112, height: 58)
                    
                }else {
                    return CGSize(width: 112, height: 32)
                }
            }else {
                if message.isAgree == true {
                    return CGSize(width: 112, height: 32)
                    
                }else {
                    return CGSize(width: 112, height: 32)
                }
            }
            
        } else {
            return CGSize.zero
        }
    }
    
}

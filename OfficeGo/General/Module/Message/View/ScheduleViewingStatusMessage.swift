//
//  ScheduleViewingStatusMessage.swift
//  OfficeGo
//
//  Created by mac on 2020/5/45.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class ScheduleViewingStatusMessage: RCMessageContent, NSCoding {
    
    // 测试消息的内容
    var content: String = ""
    
    // 测试消息的附加信息
    var extraMessage: String? = ""
    
    var isAgree: Bool = false
    
    // 根据参数创建消息对象
    class func messageWithContent(content: String, isAgree: Bool) -> ScheduleViewingStatusMessage {
        let testMessage = ScheduleViewingStatusMessage()
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
        return AppKey.ExchangeViewingDateStatusMessageTypeIdentifier
    }
}


class ScheduleViewingStatusMessageCell: RCMessageBaseCell {
    
    // 消息显示的 label
    lazy var textLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.font = UIFont.systemFont(ofSize: textMessageFontSize)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
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
        imageView.backgroundColor = kAppWhiteColor
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    // 自定义消息 Cell 的 Size
    override class func size(for model: RCMessageModel!, withCollectionViewWidth collectionViewWidth: CGFloat, referenceExtraHeight extraHeight: CGFloat) -> CGSize {
        
        let message = model.content as? ScheduleViewingStatusMessage ?? ScheduleViewingStatusMessage.messageWithContent(content: "", isAgree: false)
        let size = ScheduleViewingStatusMessageCell.getTextLabelSize(message, messageDirection: model.messageDirection)
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
        bubbleBackgroundView.addSubview(dailBtn)
        bubbleBackgroundView.addSubview(btnlineView)
        
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
        let testMessage = model.content as? ScheduleViewingStatusMessage
        //接收 -
        if RCMessageDirection.MessageDirection_RECEIVE == messageDirection {
            if testMessage?.isAgree == true {
                testMessage?.content = "已同意看房邀约"
            }else {
                testMessage?.content = "已拒绝看房邀约"
            }
        }else {
            if testMessage?.isAgree == true {
                testMessage?.content = "看房邀约已经发送给对方"
            }else {
                testMessage?.content = "已拒绝"
            }
        }
    }
    
    private func setAutoLayout() {
        
        let testMessage = model.content as? ScheduleViewingStatusMessage
        
        textLabel.text = testMessage?.content
        
        let textLabelSize = ScheduleViewingStatusMessageCell.getTextLabelSize(testMessage ?? ScheduleViewingStatusMessage.messageWithContent(content: "", isAgree: testMessage?.isAgree ?? false), messageDirection: messageDirection)
        var messageContentViewRect = baseContentView.frame
        //        messageContentViewRect.size.width = textLabelSize.width
        messageContentViewRect.size.width = kWidth
        
        baseContentView.frame = messageContentViewRect
        bubbleBackgroundView.frame = CGRect(x: (baseContentView.width - textLabelSize.width) / 2.0, y:0, width: textLabelSize.width, height: textLabelSize.height)
        
        //接收 -
        if RCMessageDirection.MessageDirection_RECEIVE == messageDirection {
            
            if testMessage?.isAgree == true {
                
                //                lineView.isHidden = false
                //                copyBtn.isHidden = false
                //                dailBtn.isHidden = false
                //                btnlineView.isHidden = false
                //
                //                textLabel.frame = CGRect(x: 0, y:0, width: bubbleBackgroundView.width, height: textLabelSize.height - 45)
                //                lineView.frame = CGRect(x: 3.5, y: textLabel.bottom, width: bubbleBackgroundView.width - 7, height: 1)
                //                copyBtn.frame = CGRect(x: 0, y: lineView.bottom, width: bubbleBackgroundView.width / 2.0, height: 45)
                //                btnlineView.frame = CGRect(x: copyBtn.right, y: copyBtn.top, width: 1.0, height: copyBtn.height)
                //                dailBtn.frame = CGRect(x: bubbleBackgroundView.width / 2.0, y: lineView.bottom, width: bubbleBackgroundView.width / 2.0, height: 45)
                lineView.isHidden = true
                copyBtn.isHidden = true
                dailBtn.isHidden = true
                btnlineView.isHidden = true
                textLabel.frame = CGRect(x: 0, y:0, width: bubbleBackgroundView.width, height: textLabelSize.height)
            }else {
                
                lineView.isHidden = true
                copyBtn.isHidden = true
                dailBtn.isHidden = true
                btnlineView.isHidden = true
                textLabel.frame = CGRect(x: 0, y:0, width: bubbleBackgroundView.width, height: textLabelSize.height)
                
            }
        }
            //发送方
        else {
            
            lineView.isHidden = true
            copyBtn.isHidden = true
            dailBtn.isHidden = true
            btnlineView.isHidden = true
            textLabel.frame = CGRect(x: 0, y:0, width: bubbleBackgroundView.width, height: textLabelSize.height)
        }
    }
    
    private class func getTextLabelSize(_ message: ScheduleViewingStatusMessage, messageDirection: RCMessageDirection) -> CGSize {
        if RCMessageDirection.MessageDirection_RECEIVE == messageDirection {
            if message.isAgree == true {
                message.content = "已同意看房邀约"
            }else {
                message.content = "已拒绝看房邀约"
            }
        }else {
            if message.isAgree == true {
                message.content = "看房邀约已经发送给对方"
            }else {
                message.content = "已拒绝"
            }
        }
        
        if !message.content.isEmpty {
            
            let screenWidth = UIScreen.main.bounds.size.width
            let portraitWidth = RCIM.shared()?.globalMessagePortraitSize.width
            let portrait = (10 + (portraitWidth ?? 0.0) + 10) * 2
            let maxWidth = screenWidth - portrait - 5 - 35
            let textRect = (message.content).boundingRect(with: CGSize(width: maxWidth, height: 8000), options: [.usesLineFragmentOrigin, .usesDeviceMetrics, .usesFontLeading], attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: textMessageFontSize)], context: nil)
            
            var width = textRect.width
            width += 20
            var heght = textRect.height
            
            heght += 20
            if heght < 40 {
                heght = 40
            }
            
            if messageDirection == RCMessageDirection.MessageDirection_RECEIVE {
                
                if message.isAgree == true {
                    
                    return CGSize(width: width, height: heght)
                    
                    //                    return CGSize(width: width, height: heght + 45)
                    //
                    //                    return CGSize(width: textRect.size.width, height: textRect.size.height + 45)
                    
                }else {
                    
                    return CGSize(width: width, height: heght)
                }
            }else {
                if message.isAgree == true {
                    
                    return CGSize(width: width, height: heght)
                    
                }else {
                    return CGSize(width: width, height: heght)
                }
            }
            
        } else {
            return CGSize.zero
        }
    }
    
}


//
//  ScheduleViewingMessage.swift
//  OfficeGo
//
//  Created by mac on 2020/5/26.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class ScheduleViewingMessage: RCMessageContent, NSCoding {
    
    // 测试消息的内容
    var content: String = ""
    
    // 测试消息的附加信息
    var extraMessage: String? = ""
    
    // (预约成功的id)
    var fyId: String? = ""
    
    var time: String? = ""
    
    //楼盘名字
    var buildingName: String? = ""

    //楼盘地址
    var buildingAddress: String? = ""

    // 根据参数创建消息对象
    class func messageWithContent(content: String, fyId: String, time: String, buildingName: String, buildingAddress: String) -> ScheduleViewingMessage {
        let testMessage = ScheduleViewingMessage()
        testMessage.content = content
        testMessage.fyId = fyId
        testMessage.time = time
        testMessage.buildingName = buildingName
        testMessage.buildingAddress = buildingAddress
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
        time = aDecoder.decodeObject(forKey: "time") as? String ?? ""
        fyId = aDecoder.decodeObject(forKey: "fyId") as? String ?? ""
        buildingName = aDecoder.decodeObject(forKey: "buildingName") as? String ?? ""
        buildingAddress = aDecoder.decodeObject(forKey: "buildingAddress") as? String ?? ""

    }
    
    // NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(content, forKey: "content")
        aCoder.encode(extraMessage, forKey: "extraMessage")
        aCoder.encode(time, forKey: "time")
        aCoder.encode(fyId, forKey: "fyId")
        aCoder.encode(buildingName, forKey: "buildingName")
        aCoder.encode(buildingAddress, forKey: "buildingAddress")

    }
    
    // 序列化，将消息内容编码成 json
    override func encode() -> Data! {
        var dataDict: [String : Any] = [:]
        
        dataDict["content"] = content
        if let extraMessage = extraMessage {
            dataDict["extraMessage"] = extraMessage
        }
        if let fyId = fyId {
            dataDict["fyId"] = fyId
        }
        if let time = time {
            dataDict["time"] = time
        }
        if let buildingName = buildingName {
            dataDict["buildingName"] = buildingName
        }
        if let buildingAddress = buildingAddress {
            dataDict["buildingAddress"] = buildingAddress
        }
        if let senderUserInfo = senderUserInfo {
            dataDict["user"] = self.encode(senderUserInfo)
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: dataDict, options: .prettyPrinted)
            return data
        } catch {
            SSLog(error)
            return Data()
        }
    }
    
    // 反序列化，解码生成可用的消息内容
    override func decode(with data: Data!) {
        do {
            let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String : Any]
            content = dictionary["content"] as? String ?? ""
            extraMessage = dictionary["extraMessage"] as? String ?? ""
            time = dictionary["time"] as? String ?? ""
            fyId = dictionary["fyId"] as? String ?? ""
            buildingName = dictionary["buildingName"] as? String ?? ""
            buildingAddress = dictionary["buildingAddress"] as? String ?? ""
            let userInfoDict = dictionary["user"] as? [String : Any] ?? [:]
            decodeUserInfo(userInfoDict)
        } catch {
            SSLog(error)
        }
    }
    
    // 显示的消息内容摘要
    override func conversationDigest() -> String! {
        return content
    }
    
    // 返回消息的类型名
    override class func getObjectName() -> String! {
        return AppKey.ViewingDateExchangeMessageTypeIdentifier
    }
}

class ScheduleViewingMessageCell: RCMessageCell {
    
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
    
    // 大楼名字
    lazy var buildingNameLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.font = FONT_13
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = kAppColor_333333
        return label
    }()
    
    // 大楼地址
    lazy var buildingAddressLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.font = FONT_13
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = kAppColor_333333
        return label
    }()
    
    // 时间
    lazy var timeLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.font = FONT_13
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = kAppBlueColor
        return label
    }()
    
    // 消息背景
    lazy var iconimg: UIImageView = {
        let imageView = UIImageView(frame: CGRect.zero)
        imageView.image = UIImage.init(named: "scheduleBlueM")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    //拒绝
    lazy var rejectBtn: UIButton = {
        let view = UIButton()
        view.setTitleColor(kAppBlueColor, for: .normal)
        view.titleLabel?.font = FONT_13
        view.setTitle("拒绝", for: .normal)
        view.setTitleColor(kAppColor_666666, for: .normal)
        view.addTarget(self, action: #selector(rejectClick), for: .touchUpInside)
        return view
    }()
    
    //同意
    lazy var lookupBtn: UIButton = {
        let view = UIButton()
        view.setTitleColor(kAppBlueColor, for: .normal)
        view.titleLabel?.font = FONT_13
        view.setTitle("同意", for: .normal)
        view.setTitleColor(kAppBlueColor, for: .normal)
        view.addTarget(self, action: #selector(agreeClick), for: .touchUpInside)
        return view
    }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = kAppColor_line_EEEEEE
        return view
    }()
    
    lazy var btnlineView: UIView = {
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
        
        let message = model.content as? ScheduleViewingMessage
        
        let size = getBubbleBackgroundViewSize(message ?? ScheduleViewingMessage.messageWithContent(content: "", fyId: "0", time: "0", buildingName: "", buildingAddress: ""), messageDirection: model.messageDirection)
        
        var messagecontentviewHeight = size.height;
        messagecontentviewHeight = messagecontentviewHeight + extraHeight;
        return CGSize(width: collectionViewWidth, height: messagecontentviewHeight)
    }
    
    override init!(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    @objc func agreeClick() {
        let message = model.content as? ScheduleViewingMessage
        
        NotificationCenter.default.post(name: NSNotification.Name.MsgViewingScheduleStatusBtnLocked, object: ["isAgree": true, "fyid": Int(message?.fyId ?? "0") ?? 0])
    }
    
    @objc func rejectClick() {
        let message = model.content as? ScheduleViewingMessage
        
        NotificationCenter.default.post(name: NSNotification.Name.MsgViewingScheduleStatusBtnLocked, object: ["isAgree": false, "fyid": Int(message?.fyId ?? "0") ?? 0])
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    func initialize() {
        messageContentView.addSubview(bubbleBackgroundView)
        bubbleBackgroundView.addSubview(iconimg)
        bubbleBackgroundView.addSubview(textLabel)
        bubbleBackgroundView.addSubview(timeLabel)
        bubbleBackgroundView.addSubview(rejectBtn)
        bubbleBackgroundView.addSubview(lookupBtn)
        bubbleBackgroundView.addSubview(lineView)
        bubbleBackgroundView.addSubview(btnlineView)
        
        bubbleBackgroundView.addSubview(buildingNameLabel)
        bubbleBackgroundView.addSubview(buildingAddressLabel)

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
        
        let testMessage = model.content as? ScheduleViewingMessage
        
        if messageDirection == RCMessageDirection.MessageDirection_RECEIVE {
            if UserTool.shared.user_id_type == 0 {
                testMessage?.content = "我想邀请你到现场看房，是否同意？"
            }else if UserTool.shared.user_id_type == 1 {
                testMessage?.content = "我想到现场看房，是否同意？"
            }
        }else {
            testMessage?.content = "你发起了一个看房邀约，等待对方接受"
        }
        setAutoLayout()
    }
    
    private func setAutoLayout() {
        let testMessage = model.content as? ScheduleViewingMessage
        textLabel.text = testMessage?.content
        
        let intervalString = testMessage?.time ?? ""
        let date = Date.init(timeIntervalSince1970: TimeInterval.init((Int(intervalString) ?? 0) / 1000))
        let dateStr = date.localDateString()
        timeLabel.text = "约看时间：\(dateStr)"
        buildingNameLabel.text = "名字：\(testMessage?.buildingName ?? "")"
        buildingAddressLabel.text = "地址：\(testMessage?.buildingAddress ?? "")"

        let contentSize = ScheduleViewingMessageCell.getContentSize(testMessage ?? ScheduleViewingMessage.messageWithContent(content: "", fyId: "0", time: "0", buildingName: "", buildingAddress: ""), messageDirection: messageDirection)
        
        let addresSize = ScheduleViewingMessageCell.getAddressSize(testMessage ?? ScheduleViewingMessage.messageWithContent(content: "", fyId: "0", time: "0", buildingName: "", buildingAddress: ""), messageDirection: messageDirection)
        
        let messageSize = ScheduleViewingMessageCell.getMessageContentSize(contentSize: contentSize, addressSize: addresSize, messageDirection: messageDirection)
                
        let bubbleBackgroundViewSize = ScheduleViewingMessageCell.getBubbleSize(messageSize)
        
        var messageContentViewRect = messageContentView.frame
        
        
        //接收
        if RCMessageDirection.MessageDirection_RECEIVE == messageDirection {
            iconimg.isHidden = false
            rejectBtn.isHidden = false
            lookupBtn.isHidden = false
            lineView.isHidden = false
            btnlineView.isHidden = false
            iconimg.frame = CGRect(x: 12, y: 7, width: 23, height: 23)
            textLabel.frame = CGRect(x: iconimg.right + 10, y: 7, width: contentSize.width, height: contentSize.height)

            buildingNameLabel.frame = CGRect(x: textLabel.left, y: textLabel.bottom + 3, width: contentSize.width, height: 30)
            buildingAddressLabel.frame = CGRect(x: textLabel.left, y: buildingNameLabel.bottom, width: addresSize.width + 12, height: addresSize.height)
            
            timeLabel.frame = CGRect(x: textLabel.left, y: buildingAddressLabel.bottom, width: contentSize.width, height: 30)
            lineView.frame = CGRect(x: 6, y: timeLabel.bottom + 7, width: bubbleBackgroundViewSize.width - 12, height: 1)
            rejectBtn.frame = CGRect(x: 0, y: lineView.bottom, width: bubbleBackgroundViewSize.width / 2.0, height: 45)
            btnlineView.frame = CGRect(x: rejectBtn.right, y: rejectBtn.top, width: 1.0, height: rejectBtn.height)
            lookupBtn.frame = CGRect(x: bubbleBackgroundViewSize.width / 2.0, y: lineView.bottom, width: bubbleBackgroundViewSize.width / 2.0, height: 45)
            messageContentViewRect.size.width = bubbleBackgroundViewSize.width
            messageContentView.frame = messageContentViewRect
            
            bubbleBackgroundView.frame = CGRect(x: 0, y: 0, width: bubbleBackgroundViewSize.width, height: bubbleBackgroundViewSize.height)
        }
            //
        else {
            iconimg.isHidden = true
            rejectBtn.isHidden = true
            lookupBtn.isHidden = true
            lineView.isHidden = true
            btnlineView.isHidden = true
            textLabel.frame = CGRect(x: 18, y: 7, width: contentSize.width, height: contentSize.height)

            buildingNameLabel.frame = CGRect(x: textLabel.left, y: textLabel.bottom + 3, width: contentSize.width, height: 30)
            buildingAddressLabel.frame = CGRect(x: textLabel.left, y: buildingNameLabel.bottom, width: addresSize.width + 12, height: addresSize.height)

            timeLabel.frame = CGRect(x: textLabel.left, y: buildingAddressLabel.bottom, width: contentSize.width, height: 30)
            
            messageContentViewRect.size.width = bubbleBackgroundViewSize.width
            messageContentViewRect.size.height = bubbleBackgroundViewSize.height
            
            let portraitWidht = RCIM.shared().globalMessagePortraitSize.width
            messageContentViewRect.origin.x = baseContentView.bounds.size.width - (messageContentViewRect.size.width + CGFloat(HeadAndContentSpacing) + portraitWidht + 10)
            
            messageContentView.frame = messageContentViewRect
            
            bubbleBackgroundView.frame = CGRect(x: 0, y: 0, width: bubbleBackgroundViewSize.width, height: bubbleBackgroundViewSize.height)
        }
        
    }
    
    private class func getAddressSize(_ message: ScheduleViewingMessage, messageDirection: RCMessageDirection) -> CGSize {
        
        if let buildingAddress = message.buildingAddress {
            if buildingAddress.isBlankString != true {
                let screenWidth = UIScreen.main.bounds.size.width
                let portraitWidth = RCIM.shared()?.globalMessagePortraitSize.width
                let portrait = (10 + (portraitWidth ?? 0.0) + 10) * 2
                let maxWidth = screenWidth - portrait - 5 - 35
                
                var addressRect = ("地址：\(buildingAddress)").boundingRect(with: CGSize(width: maxWidth, height: 8000), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : FONT_13], context: nil)
                addressRect.size.height = CGFloat(ceilf(Float(addressRect.size.height))) + 2
                if addressRect.size.height < 30 {
                    addressRect.size.height = 30
                }
                return addressRect.size
            }
        }
        
        return CGSize.zero
    }
    
    private class func getContentSize(_ message: ScheduleViewingMessage, messageDirection: RCMessageDirection) -> CGSize {
        
        if messageDirection == RCMessageDirection.MessageDirection_RECEIVE {
            if UserTool.shared.user_id_type == 0 {
                message.content = "我想邀请你到现场看房，是否同意？"
            }else if UserTool.shared.user_id_type == 1 {
                message.content = "我想到现场看房，是否同意？"
            }
        }else {
            message.content = "你发起的看房邀约，等待对方接受"
        }
        
        if !message.content.isEmpty {
            let screenWidth = UIScreen.main.bounds.size.width
            let portraitWidth = RCIM.shared()?.globalMessagePortraitSize.width
            let portrait = (10 + (portraitWidth ?? 0.0) + 10) * 2
            let maxWidth = screenWidth - portrait - 5 - 35
            
            var textRect = (message.content).boundingRect(with: CGSize(width: maxWidth, height: 8000), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: textMessageFontSize)], context: nil)
            textRect.size.height = CGFloat(ceilf(Float(textRect.size.height))) + 2
            textRect.size.width = CGFloat(ceilf(Float(textRect.size.width)))
            
            return CGSize(width: textRect.size.width + 5 + 30, height: textRect.size.height)

        } else {
            return CGSize.zero
        }
    }
    
    private class func getMessageContentSize(contentSize: CGSize, addressSize: CGSize, messageDirection: RCMessageDirection) -> CGSize {
        
        if messageDirection == RCMessageDirection.MessageDirection_RECEIVE {
            return CGSize(width: contentSize.width + 5 + 30, height: contentSize.height + 45 + 30 + 30 + addressSize.height)
        }else {
            return CGSize(width: contentSize.width, height: contentSize.height + 30 + 30 + addressSize.height)
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
    
    public class func getBubbleBackgroundViewSize(_ message: ScheduleViewingMessage, messageDirection: RCMessageDirection) -> CGSize {
        
        let contentSize = ScheduleViewingMessageCell.getContentSize(message, messageDirection: messageDirection)
        
        let addresSize = ScheduleViewingMessageCell.getAddressSize(message, messageDirection: messageDirection)
        
        let messageSize = ScheduleViewingMessageCell.getMessageContentSize(contentSize: contentSize, addressSize: addresSize, messageDirection: messageDirection)
        
        return ScheduleViewingMessageCell.getBubbleSize(messageSize)
        
    }
    
}

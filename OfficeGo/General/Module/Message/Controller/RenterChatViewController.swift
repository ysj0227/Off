//
//  RenterChatViewController.swift
//  OfficeGo
//
//  Created by mac on 2020/5/21.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class RenterChatViewController: RCConversationViewController {
    //上面四个按钮view
    var buttonView:RenterMsgBtnView = {
        let view = RenterMsgBtnView.init(frame: CGRect(x: 0, y: kNavigationHeight, width: kWidth, height: 60))
        return view
    }()
    
    //预约查看view
    var scheduleView: RenterMsgScheduleAlertView?
    
    var isHasSchedule: Bool = false {
        didSet {
            if isHasSchedule == true {
                scheduleView?.isHidden = false
                self.conversationMessageCollectionView.frame = CGRect(x: 0, y: kNavigationHeight + 60 + 43, width: kWidth, height: self.view.height - (kNavigationHeight + 60 + 43))
            }else {
                scheduleView?.isHidden = true
                self.conversationMessageCollectionView.frame = CGRect(x: 0, y: kNavigationHeight + 60, width: kWidth, height: self.view.height - (kNavigationHeight + 60))
            }
        }
    }
    
    var titleview: ThorNavigationView?
    
    var needPopToRootView: Bool?
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        addNotify()
        
        reloadRCCompanyUserInfo()
    }
    
}


extension RenterChatViewController {
    
    func setupData() {
        
        //模拟没有预约看房
        isHasSchedule = false
        
        insertMessage()
    }
    
    func setupView() {
        
        titleview = ThorNavigationView.init(type: .backTitleRightBlueBgclolor)
        titleview?.titleLabel.text = self.title
        titleview?.rightButton.isHidden = true
        titleview?.rightButton.setImage(UIImage.init(named: "setting"), for: .normal)
        titleview?.leftButtonCallBack = { [weak self] in
            self?.leftBtnClick()
        }
        titleview?.rightBtnClickBlock = { [weak self] in
            if self?.conversationType == .ConversationType_PRIVATE {
                self?.pushFriendVC(user: "")
            }
        }
        self.view.addSubview(titleview!)
        
        self.view.addSubview(buttonView)
        
        buttonView.itemSelectCallBack = {[weak self] (index) in
            self?.clicktoBtn(index: index)
        }
        
        scheduleView = RenterMsgScheduleAlertView.init(frame: CGRect(x: 0, y: kNavigationHeight + 60, width: kWidth, height: 43))
        scheduleView?.addTarget(self, action: #selector(clickToScheduleDetailVC), for: .touchUpInside)
        self.view.addSubview(scheduleView ?? RenterMsgScheduleAlertView())
        scheduleView?.isHidden = true
        
        self.conversationMessageCollectionView.frame = CGRect(x: 0, y: kNavigationHeight + 60, width: kWidth, height: self.view.height - (kNavigationHeight + 60))
        
        // 注册自定义消息的Cell
        //交换手机
        register(PhoneExchangeMessageCell.self, forMessageClass: PhoneExchangeMessage.self)
        
        //交换微信
        register(WechatExchangeMessageCell.self, forMessageClass: WechatExchangeMessage.self)
        
        //交换手机状态
        register(PhoneExchangeStatusMessageCell.self, forMessageClass: PhoneExchangeStatusMessage.self)
        
        //交换微信状态
        register(WechatExchangeStatusMessageCell.self, forMessageClass: WechatExchangeStatusMessage.self)
        
        //约看房源
        register(ScheduleViewingMessageCell.self, forMessageClass: ScheduleViewingMessage.self)
        
        //房源信息
        register(FangyuanInsertFYMessageCell.self, forMessageClass: FangyuanInsertFYMessage.self)
        
        
        setupData()
    }
    
    func addNotify() {
        
        //预约成功
        NotificationCenter.default.addObserver(forName: NSNotification.Name.MsgScheduleSuccess, object: nil, queue: OperationQueue.main) { [weak self] (noti) in
            self?.sendScheduleFY()
        }
        
        //收藏
        NotificationCenter.default.addObserver(forName: NSNotification.Name.MsgCollectBtnLocked, object: nil, queue: OperationQueue.main) { [weak self] (noti) in
            
            
        }
        
        //微信拒绝同意
        NotificationCenter.default.addObserver(forName: NSNotification.Name.MsgExchangeWechatStatusBtnLocked, object: nil, queue: OperationQueue.main) { [weak self] (noti) in
            if let type = noti.object as? Bool {
                
                self?.sendExchangeWechatAgreeOrReject(agree: type)
            }
        }
        
        //手机拒绝同意
        NotificationCenter.default.addObserver(forName: NSNotification.Name.MsgExchangePhoneStatusBtnLocked, object: nil, queue: OperationQueue.main) { [weak self] (noti) in
            if let type = noti.object as? Bool {
                
                self?.sendExchangePhoneAgreeOrReject(agree: type)
            }
        }
        
        //点击邀约自定义详情
       NotificationCenter.default.addObserver(forName: NSNotification.Name.MsgScheduleDetail, object: nil, queue: OperationQueue.main) { [weak self] (noti) in
           
           self?.clickToScheduleDetailVC()
       }
        
        
        
    }
}

//自定义cell点击操作
extension RenterChatViewController {
    func fyCollectBtnClick() {
        
    }
    
    func exchangeWechatBtnClick() {
        
    }
    
    func exchangePhoneBtnClick() {
        
    }
}

extension RenterChatViewController {
    //点击查看用户信息
    func pushFriendVC(user: String) {
        
    }
    
    //点击去预约看房页面
    func clickToScheduleVC() {
        let vc = RenterScheduleFYViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //点击查看预约详情
    @objc func clickToScheduleDetailVC() {
        let vc = RenterHouseScheduleDetailViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func leftBtnClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //四个按钮点击方法
    func clicktoBtn(index: Int) {
        if index == 1 {
            
            sendExchangePhone()
            
        }else if index == 2 {
            
            sendExchangeWechat()
            
        }else if index == 3 {
            
            clickToScheduleVC()
            
        }else if index == 4 {
            
            let model = RCTextMessage(content: "hello啊")
            self.sendMessage(model, pushContent: "TEST")
        }
    }
}

extension RenterChatViewController {
    
    //预约房源
    func sendScheduleFY() {
        let messageContent = ScheduleViewingMessage.messageWithContent(content: "预约房源预约房源预约房源预约房源预约房源预约房源预约房源预约房源预约房源预约房源预约房源预约房源预约房源")
        sendMessage(messageContent, pushContent: "预约房源")
    }
    
    //添加插入房源消息
    func insertMessage() {
        let messageContent = FangyuanInsertFYMessage.messageWithContent(content: "测试插入消息")
        let message = RCIMClient.shared()?.insertOutgoingMessage(.ConversationType_PRIVATE, targetId: AppKey.rcTargetid, sentStatus: RCSentStatus.SentStatus_SENT, content: messageContent)
        self.appendAndDisplay(message)
    }
    
    //发送交换手机号自定义消息
    func sendExchangePhone() {
        let messageContent = PhoneExchangeMessage.messageWithContent(content: "我想和您交换手机号")
        sendMessage(messageContent, pushContent: "我想和您交换手机号")
    }
    
    //发送交换微信自定义消息
    func sendExchangeWechat() {
        let messageContent = WechatExchangeMessage.messageWithContent(content: "我想和您交换微信号")
        sendMessage(messageContent, pushContent: "我想和您交换微信号")
    }
    
    //交换微信同意拒绝消息
    func sendExchangeWechatAgreeOrReject(agree: Bool) {
        
        let messageContent = WechatExchangeStatusMessage.messageWithContent(content: agree ? "我同意和您交换微信": "我拒绝和您交换微信", isAgree: agree)
        sendMessage(messageContent, pushContent: "交换信成功失败")
    }
    
    //交换手机号同意拒绝消息
    func sendExchangePhoneAgreeOrReject(agree: Bool) {
        let messageContent = PhoneExchangeStatusMessage.messageWithContent(content: agree ? "我同意和您交换手机号" : "我拒绝和您交换手机号", isAgree: agree)
        sendMessage(messageContent, pushContent: "交换手机号成功失败")
    }
    
    //每次进来强制刷新好友用户信息
    func reloadRCCompanyUserInfo() {
        //        let info = RCUserInfo.init(userId: "200", name: "修改了名字", portrait: "https://img.officego.com.cn/house/1589973533713.png")
        //        RCIM.shared()?.refreshUserInfoCache(info, withUserId: "200")
    }
    
    
    // 添加附加信息
    //       override func willSendMessage(_ messageContent: RCMessageContent!) -> RCMessageContent! {
    //
    //           if messageContent.isKind(of: PhoneExchangeMessage.self) {
    //               let testMessage = messageContent as? PhoneExchangeMessage
    //               testMessage?.phoneNum = "附加信息"
    //               return testMessage
    //           }
    //           return messageContent
    //       }
    
    //    override func didTapMessageCell(_ model: RCMessageModel!) {
    //           super.didTapMessageCell(model)
    //
    //           if let content = model.content {
    //               if content.isKind(of: PhoneExchangeMessage.self) {
    //                   guard let testMsg = content as? PhoneExchangeMessage else {
    //                       return
    //                   }
    //                   let alertView = UIAlertView(title: "PhoneExchangeMessage", message: "content:\(testMsg.userName), extra: \(String(describing: testMsg.phoneNum))", delegate: self, cancelButtonTitle: "OK")
    //                   alertView.show()
    //               }
    //           }
    //       }
    
    
    
}



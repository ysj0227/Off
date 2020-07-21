//
//  OwnerChatViewController.swift
//  OfficeGo
//
//  Created by mac on 2020/7/21.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class OwnerChatViewController: RCConversationViewController {
    
    ///对方用户id
    var chatUserId: String?
    
    ///聊天详情
    var messageFYModel: MessageFYModel?
    
    //预约查看view
    var scheduleView: RenterMsgScheduleAlertView?
    
    var titleview: ThorNavigationView?
    
    var needPopToRootView: Bool?
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        requestChatDetail()
        
        addNotify()
        
    }
    
    func setViewShow() {
        
        SSTool.invokeInMainThread { [weak self] in
            
            guard let weakSelf = self else {return}
            
            weakSelf.titleview?.titleLabel.text = weakSelf.messageFYModel?.chatted?.nickname
            ///强制刷新好友信息
            weakSelf.reloadRCCompanyUserInfo()
            
        }
        
    }
    
    ///第一次发送调用
    func request_addChatApp() {
        
        ///isChat":0//0 :点击发送按钮的时候需要调用addChat接口，1:不需要
        if messageFYModel?.isChat == 1 {
            return
        }
        
        var params = [String:AnyObject]()
        
        params["token"] = UserTool.shared.user_token as AnyObject?
        
        
        //MARK: targetid - 只有获取详情的时候 - 需要截取一下最后一位身份标识
        params["uid"] = String(targetId.prefix(targetId.count - 1)) as AnyObject?
        
        SSNetworkTool.SSChat.request_addChatApp(params: params, success: {[weak self] (response) in
            
            guard let weakSelf = self else {return}
            
            if let model = MessageFYModel.deserialize(from: response, designatedPath: "data") {
                
                weakSelf.messageFYModel?.isChat = model.isChat
            }
            
            }, failure: { (error) in
                
                
        }) { (code, message) in

        }
    }
    
    ///获取详情
    func requestChatDetail() {
        
        if needPopToRootView != true {
            return
        }
        var params = [String:AnyObject]()
        
        params["token"] = UserTool.shared.user_token as AnyObject?
        
        
        //MARK: targetid - 只有获取详情的时候 - 需要截取一下最后一位身份标识
        params["uid"] = String(targetId.prefix(targetId.count - 1)) as AnyObject?
        
        
        SSNetworkTool.SSChat.request_getChatFYDetailApp(params: params, success: {[weak self] (response) in
            
            guard let weakSelf = self else {return}
            
            if let model = MessageFYModel.deserialize(from: response, designatedPath: "data") {
                
                weakSelf.messageFYModel = model
                                                
                weakSelf.setViewShow()
                
                weakSelf.sengSayHelloMessage()
            }
                        
            }, failure: {[weak self] (error) in
                
                
        }) {[weak self] (code, message) in
                        
            //只有5000 提示给用户 - 失效原因
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" || code == "\(SSCode.ERROR_CODE_7016.code)" {
                AppUtilities.makeToast(message)
            }
        }
    }
    
    override func didSendMessage(_ status: Int, content messageContent: RCMessageContent!) {
        SSLog("---*****---\(messageContent.className)")
        
        if messageContent.isKind(of: RCTextMessage.self) {
            
            SSTool.invokeInDebug { [weak self] in
                self?.request_addChatApp()
            }
            
        }
        
    }
}


extension OwnerChatViewController {
    
    func setupData() {
        
        
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
        
       
        
        scheduleView = RenterMsgScheduleAlertView.init(frame: CGRect(x: 0, y: kNavigationHeight + 60, width: kWidth, height: 43))
        scheduleView?.addTarget(self, action: #selector(clickToScheduleDetailVC), for: .touchUpInside)
        self.view.addSubview(scheduleView ?? RenterMsgScheduleAlertView())
        scheduleView?.isHidden = true
        
        self.conversationMessageCollectionView.frame = CGRect(x: 0, y: kNavigationHeight, width: kWidth, height: self.view.height - kNavigationHeight)
        
        if Device.isIPad == true {
            self.conversationMessageCollectionView.contentInset = UIEdgeInsets(top: kNavigationHeight + 4, left: 0, bottom: 0, right: 0)
        }
        // 注册自定义消息的Cell
        //交换手机
        register(PhoneExchangeMessageCell.self, forMessageClass: PhoneExchangeMessage.self)
        
        //交换手机状态
        register(PhoneExchangeStatusMessageCell.self, forMessageClass: PhoneExchangeStatusMessage.self)
        
        
        //删除 发送位置功能
        //https://support.rongcloud.cn/ks/MzAy
        self.chatSessionInputBarControl.pluginBoardView.removeItem(withTag: Int(PLUGIN_BOARD_ITEM_LOCATION_TAG))
        
        setupData()
    }
    
    func addNotify() {
        
        //手机拒绝同意
        NotificationCenter.default.addObserver(forName: NSNotification.Name.MsgExchangePhoneStatusBtnLocked, object: nil, queue: OperationQueue.main) { [weak self] (noti) in
            if let type = noti.object as? [String: Any] {
                let agress = type["agress"] as? Bool
                let phone = type["phone"] as? String
                self?.sendExchangePhoneAgreeOrReject(agree: agress ?? false, otherPhone: phone ?? "")
            }
        }
    }
}

//自定义cell点击操作
extension OwnerChatViewController {
    func fyCollectBtnClick() {
        
    }
    
    func exchangeWechatBtnClick() {
        
    }
    
    func exchangePhoneBtnClick() {
        
    }
}

extension OwnerChatViewController {
    //点击查看用户信息
    func pushFriendVC(user: String) {
        
    }
    
    //点击查看预约详情
    @objc func clickToScheduleDetailVC() {
        
    }
    
    @objc func leftBtnClick() {
        if needPopToRootView == true {
            self.navigationController?.popToRootViewController(animated: true)
        }else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    //弹出发送手机号确认框弹框
    func showPhoneSureAlertview() {
        
        self.sendExchangePhone()
    }
     
}

extension OwnerChatViewController {
    
    //发送打招呼语第一次创建聊天 - 租户给业主发送一个默认消息（我对你发布的房源有兴趣，能聊聊吗？）
    func sengSayHelloMessage() {
        
        ///isChat":0//0 :点击发送按钮的时候需要调用addChat接口，1:不需要
        if messageFYModel?.isChat == 1 {
            return
        }
        
        //只有租户才会发这个消息
        if UserTool.shared.user_id_type == 0 {
            let message = RCTextMessage(content: "我对你发布的房源有兴趣，能聊聊吗？")
            sendMessage(message, pushContent: "打招呼")
        }
    }
    
    //发送交换手机号自定义消息
    func sendExchangePhone() {
        let messageContent = PhoneExchangeMessage.messageWithContent(content: "我想和您交换手机号", number: UserTool.shared.user_phone ?? "")
        sendMessage(messageContent, pushContent: "我想和您交换手机号")
    }
    
    //交换手机号同意拒绝消息
    func sendExchangePhoneAgreeOrReject(agree: Bool, otherPhone: String) {
        let messageContent = PhoneExchangeStatusMessage.messageWithContent(content: agree ? "我同意和您交换手机号" : "我拒绝和您交换手机号", isAgree: agree, sendNumber: otherPhone, receiveNumber: UserTool.shared.user_phone ?? "")
        sendMessage(messageContent, pushContent: "交换手机号回复")
    }
    
    //每次进来强制刷新好友用户信息
    func reloadRCCompanyUserInfo() {
        let info = RCUserInfo.init(userId: messageFYModel?.chatted?.targetId, name: messageFYModel?.chatted?.nickname, portrait: messageFYModel?.chatted?.avatar)
        RCIM.shared()?.refreshUserInfoCache(info, withUserId: messageFYModel?.chatted?.targetId)
    }
    
}



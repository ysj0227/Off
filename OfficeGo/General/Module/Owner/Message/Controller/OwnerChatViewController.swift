//
//  OwnerChatViewController.swift
//  OfficeGo
//
//  Created by mac on 2020/7/21.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class OwnerChatViewController: RCConversationViewController {
    
    var content: String?
    
    var applyJoinId: Int?
    
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
        
        ///获取用户信息 - 更新对方头像和昵称
        requestChatDetail()

        if needPopToRootView == true {
            
            
            ApplyJoinCompanyOrBranch()
        }
        
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
    
    
    ///获取详情
    func requestChatDetail() {
                
        var params = [String:AnyObject]()
        
        params["token"] = UserTool.shared.user_token as AnyObject?
        
        
        //MARK: targetid - 只有获取详情的时候 - 需要截取一下最后一位身份标识
        params["uid"] = String(targetId.prefix(targetId.count - 1)) as AnyObject?
        
        
        SSNetworkTool.SSChat.request_getChatFYDetailApp(params: params, success: {[weak self] (response) in
            
            guard let weakSelf = self else {return}
            
            if let model = MessageFYModel.deserialize(from: response, designatedPath: "data") {
                
                //刷新对方融云信息
                weakSelf.reloadRCCompanyUserInfo()
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
        register(ApplyEnterCompanyOrBranchMessageCell.self, forMessageClass: ApplyEnterCompanyOrBranchMessage.self)
        
        //交换手机状态
        register(ApplyEnterCompanyOrBranchStatusMessageCell.self, forMessageClass: ApplyEnterCompanyOrBranchStatusMessage.self)
        
        
        //删除 发送位置功能
        //https://support.rongcloud.cn/ks/MzAy
        self.chatSessionInputBarControl.pluginBoardView.removeItem(withTag: Int(PLUGIN_BOARD_ITEM_LOCATION_TAG))
        
        setupData()
    }
    
    func addNotify() {
        
        //手机拒绝同意
        NotificationCenter.default.addObserver(forName: NSNotification.Name.MsgApplyJoinStatusBtnLocked, object: nil, queue: OperationQueue.main) { [weak self] (noti) in
            if let type = noti.object as? [String: Any] {
                let agress = type["agress"] as? Bool
                let phone = type["id"] as? Int
                self?.ApplyJoinCompanyOrBranchAgreeOrReject(agree: agress ?? false, id: phone ?? 0)
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
        
        self.ApplyJoinCompanyOrBranch()
    }
     
}

extension OwnerChatViewController {
    
    //发送打招呼语第一次创建聊天 - 租户给业主发送一个默认消息（我对你发布的房源有兴趣，能聊聊吗？）
    func sengSayHelloMessage() {
        
        let message = RCTextMessage(content: "我发送了加入公司的申请，请通过")
        sendMessage(message, pushContent: "申请")
    }
    
    //发送交换手机号自定义消息
    func ApplyJoinCompanyOrBranch() {
        let messageContent = ApplyEnterCompanyOrBranchMessage.messageWithContent(content: content ?? "我是用户，希望加入公司，请通过", id: applyJoinId ?? -1)
        sendMessage(messageContent, pushContent: content ?? "我是用户，希望加入公司，请通过")
        
        //发送之后，发送一条打招呼语
        sengSayHelloMessage()

    }
    
    //交换手机号同意拒绝消息
    func ApplyJoinCompanyOrBranchAgreeOrReject(agree: Bool, id: Int) {
        //        sendScheduleMessage(agree: agree)
        
        var params = [String:AnyObject]()
        
        params["token"] = UserTool.shared.user_token as AnyObject?
        params["id"] = id as AnyObject?
        if agree == true {
            params["auditStatus"] = 1 as AnyObject?
        }else {
            params["auditStatus"] = 2 as AnyObject?
        }
        
        //身份类型0个人认证1企业认证2网点认证
        params["identityType"] = UserTool.shared.user_owner_identifytype as AnyObject?
        SSNetworkTool.SSOwnerIdentify.request_getUpdateAuditStatus(params: params, success: {[weak self] (response) in
            
            self?.sendScheduleMessage(agree: agree)
            
            }, failure: { (error) in
                
        }) { (code, message) in
            
            //只有5000 提示给用户 - 失效原因
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" || code == "\(SSCode.ERROR_CODE_7016.code)" {
                AppUtilities.makeToast(message)
            }
        }
        
    }

    func sendScheduleMessage(agree: Bool) {
        let messageContent = ApplyEnterCompanyOrBranchStatusMessage.messageWithContent(content: agree ? "我同意你加入公司" : "我拒绝你加入公司", isAgree: agree)
        sendMessage(messageContent, pushContent: "加入公司状态")
        
        if agree == true {
            let message = RCTextMessage(content: "我已同意你加入公司，欢迎")
            sendMessage(message, pushContent: "我已同意你加入公司，欢迎")
        }
    }
    //每次进来强制刷新好友用户信息
    func reloadRCCompanyUserInfo() {
        let info = RCUserInfo.init(userId: messageFYModel?.chatted?.targetId, name: messageFYModel?.chatted?.nickname, portrait: messageFYModel?.chatted?.avatar)
        RCIM.shared()?.refreshUserInfoCache(info, withUserId: messageFYModel?.chatted?.targetId)
    }
    
}



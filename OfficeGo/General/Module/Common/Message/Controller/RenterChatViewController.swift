//
//  RenterChatViewController.swift
//  OfficeGo
//
//  Created by mac on 2020/5/21.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class RenterChatViewController: RCConversationViewController {
    
    ///楼盘id
    var buildingId: Int?
    
    ///房源id 英文逗号分隔
    var houseIds: String?
    
    ///对方用户id
    var chatUserId: String?
    
    ///聊天详情
    var messageFYModel: MessageFYModel?
    
    var messageFYViewModel: MessageFYViewModel?
    
    //获取房源详情接口成功 - 只有成功 - 才能跳转到预约房源页面
    var isGetFYSuccess: Bool?
    
    //上面四个按钮view
    var buttonView:RenterMsgBtnView = {
        let view = RenterMsgBtnView.init(frame: CGRect(x: 0, y: kNavigationHeight, width: kWidth, height: 70))
        view.phoneChangeBtn.isSelected = true
        view.wechatChangeBtn.isSelected = true
        return view
    }()
    
    //预约查看view
    var scheduleView: RenterMsgScheduleAlertView?
    
    var isHasSchedule: Bool = false {
        didSet {
            if isHasSchedule == true {
                scheduleView?.isHidden = false
                self.conversationMessageCollectionView.frame = CGRect(x: 0, y: kNavigationHeight + 70 + 43, width: kWidth, height: self.view.height - (kNavigationHeight + 70 + 43))
            }else {
                scheduleView?.isHidden = true
                self.conversationMessageCollectionView.frame = CGRect(x: 0, y: kNavigationHeight + 70, width: kWidth, height: self.view.height - (kNavigationHeight + 70))
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
        
        requestChatDetail()
        
        addNotify()
        
    }
    
    func setViewShow() {
        
        SSTool.invokeInMainThread { [weak self] in
            
            guard let weakSelf = self else {return}
            
            weakSelf.titleview?.titleLabel.text = weakSelf.messageFYModel?.chatted?.nickname
            ///强制刷新好友信息
            weakSelf.reloadRCCompanyUserInfo()
            
            ///插入聊天信息 - 判断之前有没有插入过
            weakSelf.insertMessage()
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
                
                weakSelf.messageFYModel = model
                
                weakSelf.messageFYViewModel = MessageFYViewModel.init(model: model)
                                
                weakSelf.setViewShow()
            }
            
            weakSelf.isGetFYSuccess = true
            
            }, failure: {[weak self] (error) in
                
                self?.isGetFYSuccess = false
                
        }) {[weak self] (code, message) in
            
            self?.isGetFYSuccess = false
            
            //只有5000 提示给用户 - 失效原因
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" || code == "\(SSCode.ERROR_CODE_7016.code)" {
                AppUtilities.makeToast(message)
            }
        }
    }
}


extension RenterChatViewController {
    
    func setupData() {
        
        //模拟没有预约看房
        isHasSchedule = false
        
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
        
        //约看房源
        register(ScheduleViewingMessageCell.self, forMessageClass: ScheduleViewingMessage.self)
        
        //交换手机状态
        register(PhoneExchangeStatusMessageCell.self, forMessageClass: PhoneExchangeStatusMessage.self)
        
        //交换微信状态
        register(WechatExchangeStatusMessageCell.self, forMessageClass: WechatExchangeStatusMessage.self)
        
        //约看房源状态
        register(ScheduleViewingStatusMessageCell.self, forMessageClass: ScheduleViewingStatusMessage.self)
        
        //房源信息
        register(FangyuanInsertFYMessageCell.self, forMessageClass: FangyuanInsertFYMessage.self)
        
        
        //删除 发送位置功能
        //https://support.rongcloud.cn/ks/MzAy
        self.chatSessionInputBarControl.pluginBoardView.removeItem(withTag: Int(PLUGIN_BOARD_ITEM_LOCATION_TAG))
        
        setupData()
    }
    
    func addNotify() {
        
        //预约成功
        NotificationCenter.default.addObserver(forName: NSNotification.Name.MsgScheduleSuccess, object: nil, queue: OperationQueue.main) { [weak self] (noti) in
            let dic = noti.object as? [String: Any]
            if let fyid = dic?["fyid"] as? Int, let interval = dic?["interval"] as? Int{
                self?.sendScheduleFY(interval: interval, fyid: fyid)
            }
        }
        
        //收藏
        NotificationCenter.default.addObserver(forName: NSNotification.Name.MsgCollectBtnLocked, object: nil, queue: OperationQueue.main) { [weak self] (noti) in
            
            
        }
        
        
        //手机拒绝同意
        NotificationCenter.default.addObserver(forName: NSNotification.Name.MsgExchangePhoneStatusBtnLocked, object: nil, queue: OperationQueue.main) { [weak self] (noti) in
            if let type = noti.object as? [String: Any] {
                let agress = type["agress"] as? Bool
                let phone = type["phone"] as? String
                self?.sendExchangePhoneAgreeOrReject(agree: agress ?? false, otherPhone: phone ?? "")
            }
        }
        
        //微信拒绝同意
        NotificationCenter.default.addObserver(forName: NSNotification.Name.MsgExchangeWechatStatusBtnLocked, object: nil, queue: OperationQueue.main) { [weak self] (noti) in
            if let type = noti.object as? [String: Any] {
                let agress = type["agress"] as? Bool
                let phone = type["phone"] as? String
                self?.sendExchangeWechatAgreeOrReject(agree: agress ?? false, otherWechat: phone ?? "")
            }
        }
        
        //约看房源拒绝同意
        NotificationCenter.default.addObserver(forName: NSNotification.Name.MsgViewingScheduleStatusBtnLocked, object: nil, queue: OperationQueue.main) { [weak self] (noti) in
            if let type = noti.object as? [String: Any] {
                let agress = type["isAgree"] as? Bool
                let fyid = type["fyid"] as? Int
                self?.sendScheduleViewingAgreeOrReject(agree: agress ?? false, fyid: fyid ?? 0)
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
        
        //如果之前掉接口成功了-判断
        //没有请求接口
        if let isgetFYSuccess = isGetFYSuccess {
            if isgetFYSuccess == true {
                guard messageFYViewModel != nil else {
                    AppUtilities.makeToast("暂无楼盘信息，没法预约")
                    return
                }
                
                let vc = RenterScheduleFYViewController()
                vc.messageFYViewModel = messageFYViewModel
                self.navigationController?.pushViewController(vc, animated: true)
            }else {
                requestChatDetail()
            }
        }else {
            requestChatDetail()
        }
        
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
            
            if UserTool.shared.isHasWX() == true {
                showSureAlertview()
            }else{
                showWXInputAlertview()
            }
            
            
        }else if index == 3 {
            
            clickToScheduleVC()
            
        }else if index == 4 {
            AppUtilities.makeToast("正在开发中～")
        }
    }
    
    //弹出发送确认框弹框
    func showSureAlertview() {
        
        let alert = SureAlertView(frame: self.view.frame)
        alert.ShowSureAlertView(superview: self.view, message: "确认与对方交换微信吗？", cancelButtonCallClick: {
            
        }) { [weak self] in
            self?.sendExchangeWechat()
        }
    }
    
    //弹出输入微信弹框
    func showWXInputAlertview() {
        let alert = SureAlertView(frame: self.view.frame)
        alert.inputTFView.placeholder = "请输入您的微信号"
        alert.ShowInputAlertView(message: "当前未绑定微信", cancelButtonCallClick: {
            
        }) { [weak self] (str) in
            self?.requestSaveWX(wx: str)
        }
    }
    
    //点击确认发送
    //弹出发送确认框弹框
    func showBtnSureAlertview() {
        
        let alert = SureAlertView(frame: self.view.frame)
        alert.ShowSureAlertView(superview: self.view, message: "确认与对方交换微信吗？", cancelButtonCallClick: {
            
        }) { [weak self] in
            self?.sendExchangeWechat()
        }
    }
    
    //输入微信弹框
    func showBtnWXInputAlertview(otherWechat: String) {
        let alert = SureAlertView(frame: self.view.frame)
        alert.inputTFView.placeholder = "请输入您的微信号"
        alert.ShowInputAlertView(message: "当前未绑定微信", cancelButtonCallClick: {
            
        }) { [weak self] (str) in
            self?.requestSaveWX(wx: str)
            self?.sendMesExchangeWechatAgreeOrReject(agree: true, otherWechat: otherWechat)
        }
    }
    
    //保存微信接口
    func requestSaveWX(wx: String) {
        UserTool.shared.user_wechat = wx
        addWechatId(wxid: wx)
        self.sendExchangeWechat()
    }
    
    func addWechatId(wxid: String) {
        
        var params = [String:AnyObject]()
        
        params["token"] = UserTool.shared.user_token as AnyObject?
        params["wxId"] = wxid as AnyObject?
        params["channel"] = UserTool.shared.user_channel as AnyObject
        
        SSNetworkTool.SSChat.request_getAddWxID(params: params, success: { (response) in
            
            
            }, failure: { (error) in
                
        }) { (code, message) in
            
            //只有5000 提示给用户 - 失效原因
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" || code == "\(SSCode.ERROR_CODE_7016.code)" {
                AppUtilities.makeToast(message)
            }
        }
    }
}

extension RenterChatViewController {
    
    //添加插入房源消息
    func insertMessage() {
        
        let str = "\(UserTool.shared.user_uid ?? 0)-\(targetId ?? "")-\(messageFYModel?.house?.buildingId ?? 0)-\(messageFYModel?.house?.houseId ?? 0)"
        let isExisted = SSTool.isKeyPresentInUserDefaults(key: str)
        if isExisted {
            
        }else {
            let messageContent = FangyuanInsertFYMessage.messageWithContent(content: "测试插入消息")
            messageContent.mainPic = messageFYViewModel?.mainPic
            messageContent.createTimeAndByWho = messageFYViewModel?.createTimeAndByWho
            messageContent.isFavorite = messageFYViewModel?.IsFavorite ?? false
            messageContent.buildingName = messageFYViewModel?.buildingName
            messageContent.houseName = messageFYViewModel?.houseName
            messageContent.distanceDistrictString = messageFYViewModel?.distanceDistrictString
            messageContent.walkTimesubwayAndStationString = messageFYViewModel?.walkTimesubwayAndStationString
            messageContent.dayPriceString = messageFYViewModel?.dayPriceString
            messageContent.tagsString = messageFYViewModel?.tagsString
            
            let message = RCIMClient.shared()?.insertOutgoingMessage(.ConversationType_PRIVATE, targetId: messageFYModel?.chatted?.targetId, sentStatus: RCSentStatus.SentStatus_SENT, content: messageContent)
            self.appendAndDisplay(message)
            
            SSTool.saveDataWithUserDefault(key: str, value: "TRUE" as AnyObject)
        }
    }
    
    //发送交换手机号自定义消息
    func sendExchangePhone() {
        let messageContent = PhoneExchangeMessage.messageWithContent(content: "我想和您交换手机号", number: UserTool.shared.user_phone ?? "")
        sendMessage(messageContent, pushContent: "我想和您交换手机号")
    }
    
    //发送交换微信自定义消息
    func sendExchangeWechat() {
        let messageContent = WechatExchangeMessage.messageWithContent(content: "我想和您交换微信号", number: UserTool.shared.user_wechat ?? "")
        sendMessage(messageContent, pushContent: "我想和您交换微信号")
    }
    
    //预约房源
    func sendScheduleFY(interval: Int, fyid: Int) {
        let messageContent = ScheduleViewingMessage.messageWithContent(content: "我发送了一个看房邀请", fyId: "\(fyid)", time: "\(interval)", buildingName: messageFYViewModel?.buildingName ?? "", buildingAddress: messageFYViewModel?.address ?? "")
        sendMessage(messageContent, pushContent: "我发送了一个看房邀请")
    }
    
    //交换手机号同意拒绝消息
    func sendExchangePhoneAgreeOrReject(agree: Bool, otherPhone: String) {
        let messageContent = PhoneExchangeStatusMessage.messageWithContent(content: agree ? "我同意和您交换手机号" : "我拒绝和您交换手机号", isAgree: agree, sendNumber: otherPhone, receiveNumber: UserTool.shared.user_phone ?? "")
        sendMessage(messageContent, pushContent: "交换手机号回复")
    }
    
    //交换微信同意拒绝消息 - 点击确定需要判断有没有微信
    func sendExchangeWechatAgreeOrReject(agree: Bool, otherWechat: String) {
        
        if agree {
            if UserTool.shared.isHasWX() == true {
                
            }else{
                showBtnWXInputAlertview(otherWechat: otherWechat)
            }
        }else {
            sendMesExchangeWechatAgreeOrReject(agree: false, otherWechat: otherWechat)
        }
        
        
    }
    
    func sendMesExchangeWechatAgreeOrReject(agree: Bool, otherWechat: String) {
        let messageContent = WechatExchangeStatusMessage.messageWithContent(content: agree ? "我同意和您交换微信": "我拒绝和您交换微信", isAgree: agree, sendNumber: otherWechat, receiveNumber: UserTool.shared.user_wechat ?? "")
        sendMessage(messageContent, pushContent: "交换信成功回复")
    }
    
    //看房邀约同意拒绝消息
    func sendScheduleViewingAgreeOrReject(agree: Bool, fyid: Int) {
        //        sendScheduleMessage(agree: agree)
        
        var params = [String:AnyObject]()
        
        params["token"] = UserTool.shared.user_token as AnyObject?
        params["id"] = fyid as AnyObject?
        if agree == true {
            params["auditStatus"] = 1 as AnyObject?
        }else {
            params["auditStatus"] = 2 as AnyObject?
        }
        
        SSNetworkTool.SSSchedule.request_updateAuditStatusApp(params: params, success: {[weak self] (response) in
            
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
        let messageContent = ScheduleViewingStatusMessage.messageWithContent(content: agree ? "我同意您发送的看房邀请" : "我拒绝您发送的看房邀请", isAgree: agree)
        sendMessage(messageContent, pushContent: "看房邀请回复")
    }
    
    //每次进来强制刷新好友用户信息
    func reloadRCCompanyUserInfo() {
        let info = RCUserInfo.init(userId: messageFYModel?.chatted?.targetId, name: messageFYModel?.chatted?.nickname, portrait: messageFYModel?.chatted?.avatar)
        RCIM.shared()?.refreshUserInfoCache(info, withUserId: messageFYModel?.chatted?.targetId)
    }
    
}



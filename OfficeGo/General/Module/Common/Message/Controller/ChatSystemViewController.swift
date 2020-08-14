//
//  ChatSystemViewController.swift
//  OfficeGo
//
//  Created by mac on 2020/8/10.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class ChatSystemViewController: RCConversationViewController {
    
    var titleview: ThorNavigationView?
        
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        requestUserInfo()
    }
    
    ///获取用户详情
    func requestUserInfo() {
        
        ///实现刷新用户信息
        SSNetworkTool.SSChat.request_getUserChatInfoApp(params: ["targetId": targetId as AnyObject], success: {[weak self] (response) in
            
            guard let weakSelf = self else {return}
            
            if let model = ChatTargetUserInfoModel.deserialize(from: response, designatedPath: "data") {
                
                weakSelf.setViewShow(model: model)
            }
            
            }, failure: { (error) in
                
                
        }) { (code, message) in
            
        }
    }
    
    func setViewShow(model: ChatTargetUserInfoModel) {
        
        SSTool.invokeInMainThread { [weak self] in
            
            guard let weakSelf = self else {return}
            
            weakSelf.titleview?.titleLabel.text = model.name
            ///强制刷新好友信息
            let info = RCUserInfo.init(userId: model.id, name: model.name, portrait: model.avatar)
            RCIM.shared()?.refreshUserInfoCache(info, withUserId: model.id)
        }
        
    }
    
    
}


extension ChatSystemViewController {
    
    func setupView() {
        
        titleview = ThorNavigationView.init(type: .backTitleRightBlueBgclolor)
        titleview?.titleLabel.text = self.title
        titleview?.rightButton.isHidden = true
        titleview?.rightButton.setImage(UIImage.init(named: "setting"), for: .normal)
        titleview?.leftButtonCallBack = { [weak self] in
            self?.leftBtnClick()
        }
        self.view.addSubview(titleview!)
        
        /*!
        开启已读回执功能的会话类型，默认为空

        @discussion 这些会话类型的消息在会话页面显示了之后会发送已读回执。目前仅支持单聊、群聊和讨论组。
        */
        //RCIM.shared().enabledReadReceiptConversationTypeList = [RCConversationType.ConversationType_SYSTEM]
        
        //隐藏下面的输入框
        self.chatSessionInputBarControl.isHidden = true

        self.conversationMessageCollectionView.frame = CGRect(x: 0, y: kNavigationHeight, width: kWidth, height: self.view.height - kNavigationHeight)

    }
    
}


extension ChatSystemViewController {
    
    @objc func leftBtnClick() {
        self.navigationController?.popViewController(animated: true)
    }

    
}




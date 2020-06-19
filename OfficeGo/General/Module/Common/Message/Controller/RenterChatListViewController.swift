//
//  RenterChatListViewController.swift
//  OfficeGo
//
//  Created by mac on 2020/5/20.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class RenterChatListViewController: RCConversationListViewController {
    
    var titleview: ThorNavigationView?
    
    var index: Int?
    
    var isClick: Bool?
    
    //无数据view
    var nologindataView :NoDataShowView?

    override func viewWillDisappear(_ animated: Bool) {
         super.viewWillDisappear(animated)
         let tab = self.navigationController?.tabBarController as? RenterMainTabBarController
         tab?.customTabBar.isHidden = true
     }
     override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         let tab = self.navigationController?.tabBarController as? RenterMainTabBarController
         tab?.customTabBar.isHidden = false
        juddgeIsLogin()
     }

    ///判断有没有登录
    func juddgeIsLogin() {
        //登录直接请求数据
        if UserTool.shared.isLogin() == true {
            
            nologindataView?.isHidden = true

            self.refreshConversationTableViewIfNeeded()
        }else {
            //没登录 - 显示登录按钮view
            nologindataView?.isHidden = false
            
            self.refreshConversationTableViewIfNeeded()
        }
    }

    
    func updateBadgeValueForTabBarItem() {
        let count: Int = Int(RCIMClient.shared()?.getUnreadCount([RCConversationType.ConversationType_PRIVATE]) ?? 0)
        let tab = self.navigationController?.tabBarController as? RenterMainTabBarController
        tab?.setbadge(num: count)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initSubviews()
        
        setupView()
        
        setConversationType()
    }
    
    func setConversationType() {
        self.setDisplayConversationTypes([RCConversationType.ConversationType_PRIVATE.rawValue])
//        self.setDisplayConversationTypes([RCConversationType.ConversationType_PRIVATE.rawValue, RCConversationType.ConversationType_GROUP.rawValue, RCConversationType.ConversationType_SYSTEM.rawValue])
//        self.setCollectionConversationType([RCConversationType.ConversationType_GROUP.rawValue, RCConversationType.ConversationType_SYSTEM.rawValue])
    }
    
}

extension RenterChatListViewController {
    
    func initSubviews() {
        self.conversationListTableView.separatorColor = kAppClearColor
        self.index = 0
        self.showConnectingStatusOnNavigatorBar = true
    }
    
    
    func setupView() {
                
        titleview = ThorNavigationView.init(type: .messageTitleSearchBarSearchBtn)
        titleview?.rightButton.isHidden = true
        titleview?.searchBarView.isHidden = true
        titleview?.rightBtnClickBlock = { [weak self] in
            self?.titleview?.rightButton.isHidden = true
            self?.titleview?.searchBarView.isHidden = false
        }
        titleview?.searchBarView.searchTextfiled.delegate = self
        titleview?.searchBarView.searchTextfiled.clearButtonMode = .always
        self.view.addSubview(titleview!)
        
        self.conversationListTableView.snp.remakeConstraints { (make) in
            make.top.equalTo(kNavigationHeight)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        nologindataView = NoDataShowView.init(frame: CGRect(x: 0, y: kNavigationHeight, width: self.view.width, height: self.view.height - kNavigationHeight))
        nologindataView?.isHidden = true
        self.view.addSubview(nologindataView ?? NoDataShowView(frame: CGRect(x: 0, y: kNavigationHeight, width: self.view.width, height: self.conversationListTableView.height - kTabBarHeight - kTabBarHeight)))
        
        nologindataView?.loginCallBack = {[weak self] in
            
            guard let weakSelf = self else {return}
            
            weakSelf.showLoginVC()
        }

    }
    func showLoginVC() {
        let vc = RenterLoginViewController()
        vc.isFromOtherVC = true
        vc.closeViewBack = {[weak self] (isClose) in
            guard let weakSelf = self else {return}
            weakSelf.juddgeIsLogin()
        }
        let loginNav = BaseNavigationViewController.init(rootViewController: vc)
        loginNav.modalPresentationStyle = .overFullScreen
        //TODO: 这块弹出要设置
        self.present(loginNav, animated: true, completion: nil)

    }
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        var mActionArray = [UITableViewRowAction]()
        let deleteAction = UITableViewRowAction(style: UITableViewRowAction.Style.destructive, title: "删除") {[weak self] (deleteAction: UITableViewRowAction, indexPath: IndexPath) in
            
            SSLog("\(indexPath.row) == 删除")
            if let model: RCConversationModel = self?.conversationListDataSource[indexPath.row] as? RCConversationModel {
                RCIMClient.shared()?.remove(.ConversationType_PRIVATE, targetId: model.targetId)
                self?.conversationListDataSource.remove(model)
                self?.refreshConversationTableViewIfNeeded()
            }
        }
        deleteAction.backgroundColor = .red
        mActionArray.append(deleteAction)
        
        if let model: RCConversationModel = self.conversationListDataSource[indexPath.row] as? RCConversationModel {
            
            if model.isTop == true {
                let setupAction = UITableViewRowAction(style: UITableViewRowAction.Style.destructive, title: "取消置顶") {[weak self] (deleteAction: UITableViewRowAction, indexPath: IndexPath) in
                          RCIMClient.shared()?.setConversationToTop(.ConversationType_PRIVATE, targetId: model.targetId, isTop: false)
                    self?.refreshConversationTableViewIfNeeded()
                    SSLog("\(indexPath.row) == 取消置顶")
                }
                setupAction.backgroundColor = kAppBlueColor
                mActionArray.append(setupAction)
            }else {
                let setupAction = UITableViewRowAction(style: UITableViewRowAction.Style.destructive, title: "置顶") {[weak self] (deleteAction: UITableViewRowAction, indexPath: IndexPath) in
                          RCIMClient.shared()?.setConversationToTop(.ConversationType_PRIVATE, targetId: model.targetId, isTop: true)
                    self?.refreshConversationTableViewIfNeeded()
                    SSLog("\(indexPath.row) == 置顶")
                }
                setupAction.backgroundColor = kAppBlueColor
                mActionArray.append(setupAction)
            }
        }
        
        
        return mActionArray
    }
    
    override func onSelectedTableRow(_ conversationModelType: RCConversationModelType, conversationModel model: RCConversationModel!, at indexPath: IndexPath!) {
        
        
        if model.conversationModelType == .CONVERSATION_MODEL_TYPE_NORMAL {
            if conversationModelType == .CONVERSATION_MODEL_TYPE_COLLECTION {
                
            }else {
                let vc = RenterChatViewController()
                vc.conversationType = .ConversationType_PRIVATE
                vc.targetId = model.targetId
                vc.title = model.conversationTitle
                vc.unReadMessage = model.unreadMessageCount
                vc.enableNewComingMessageIcon = true  //开启消息提醒
                if model.conversationType == .ConversationType_SYSTEM {
                }else {
                    vc.displayUserNameInCell = false
                }
                self.navigationController?.pushViewController(vc, animated: true)

            }
        }
        
        self.updateBadgeValueForTabBarItem()
    }
    
    
    override func rcConversationListTableView(_ tableView: UITableView!, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath!) {
        
    }
    
//    override func willDisplayConversationTableCell(_ cell: RCConversationBaseCell!, at indexPath: IndexPath!) {
//        if let model = self.conversationListDataSource[indexPath.row] as? RCConversationModel {
//            weak var weakSelf = self
//            RCDUserService.shared.getUserInfo(withUserId:model.targetId) { (userInfo) in
//                weakSelf?.updateCell(at: indexPath)
//            }
//        }
//    }

}

extension RenterChatListViewController :UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        titleview?.rightButton.isHidden = false
        titleview?.searchBarView.isHidden = true
        titleview?.searchBarView.searchTextfiled.resignFirstResponder()
        return true
    }
}

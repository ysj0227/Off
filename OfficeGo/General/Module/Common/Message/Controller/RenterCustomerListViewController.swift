//
//  RenterCustomerListViewController.swift
//  OfficeGo
//
//  Created by mac on 2020/9/17.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit
import HandyJSON
import SwiftyJSON
class ChatListModel: BaseModel {
    
    var isDepartureStatus : Bool?
    ///true为拉黑，false为没有拉黑
    var isblock : Bool?
    ///头像路径
    var avatar : String?
    ///大厦名称
    var buildingName : String?
    ///业主id加身份标识
    var chattedId : String?
    ///业主昵称
    var nickname : String?
    ///置顶字段，0时为列表默认，依次往上递增，最大的在最上面
    var sort : Int?
    ///当前聊天是楼盘还是房源0为楼盘1为房源
    var typeId : Int?
    ///未读消息数
    var noReadCount : Int?
}
class RenterCustomerListViewController: BaseTableViewController {
    
    //无数据view
    var nologindataView :NoDataShowView?
    
    ///判断有没有登录
    func juddgeIsLogin() {
                    
        nologindataView?.isHidden = true
        
        self.refreshData()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleview = ThorNavigationView.init(type: .backTitleRight)
        titleview?.backgroundColor = kAppWhiteColor
        titleview?.leftButtonCallBack = { [weak self] in
            self?.leftBtnClick()
        }
        
        view.addSubview(titleview ?? ThorNavigationView.init(type: .backTitleRight))
        
        titleview?.titleLabel.text = "历史联系人"
        
        isShowRefreshHeader = false

        self.tableView.snp.remakeConstraints { (make) in
            make.top.equalTo(kNavigationHeight)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-bottomMargin())
        }

        
        tableView.register(RenterCustomerListCell.self, forCellReuseIdentifier: RenterCustomerListCell.reuseIdentifierStr)
        
        
        nologindataView = NoDataShowView.init(frame: CGRect(x: 0, y: kNavigationHeight, width: self.view.width, height: self.view.height - kNavigationHeight))
        nologindataView?.isHidden = true
        self.view.addSubview(nologindataView ?? NoDataShowView(frame: CGRect(x: 0, y: kNavigationHeight, width: self.view.width, height: self.view.height - kTabBarHeight - kTabBarHeight)))
        
        juddgeIsLogin()
        
    }
    
    
    //MARK: 获取首页列表数据
    override func refreshData() {
        
        if pageNo == 1 {
            if self.dataSource.count > 0 {
                self.dataSource.removeAll()
            }
        }
        
        var params = [String:AnyObject]()
        
        params["token"] = UserTool.shared.user_token as AnyObject?
        
        SSNetworkTool.SSChat.request_getChatList(params: params, success: { [weak self] (response) in
            guard let weakSelf = self else {return}
            if let decoratedArray = JSONDeserializer<ChatListModel>.deserializeModelArrayFrom(json: JSON(response["data"] ?? "").rawString() ?? "", designatedPath: "list") {
                weakSelf.dataSource.append(contentsOf: decoratedArray)
                weakSelf.endRefreshWithCount(0)
            }
            
            }, failure: {[weak self] (error) in
                guard let weakSelf = self else {return}
                
                weakSelf.endRefreshAnimation()
                
        }) {[weak self] (code, message) in
            
            guard let weakSelf = self else {return}
            
            weakSelf.endRefreshAnimation()
            
            //只有5000 提示给用户
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" {
                AppUtilities.makeToast(message)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RenterCustomerListCell.reuseIdentifierStr) as? RenterCustomerListCell
        cell?.selectionStyle = .none
        cell?.setChatListDataModel(dataSource[indexPath.row] as? ChatListModel)
        return cell ?? RenterCustomerListCell.init(frame: .zero)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64.0
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataSource[indexPath.row] as? ChatListModel
        if model?.chattedId?.count ?? 0 > 0 {
            let subStr = model?.chattedId?.suffix(1)
            //自己是房东 并且对方也是房东
            if UserTool.shared.user_id_type == 1 && subStr! == ChatType_Owner_1 {
                let vc = OwnerChatViewController()
                vc.conversationType = .ConversationType_PRIVATE
                vc.targetId = model?.chattedId
                vc.title = model?.nickname
                vc.enableNewComingMessageIcon = true  //开启消息提醒
                vc.displayUserNameInCell = false
                self.navigationController?.pushViewController(vc, animated: true)
            }else {
                let vc = RenterChatViewController()
                vc.conversationType = .ConversationType_PRIVATE
                vc.targetId = model?.chattedId
                vc.title = model?.nickname
                vc.enableNewComingMessageIcon = true  //开启消息提醒
                vc.displayUserNameInCell = false
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

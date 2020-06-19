//
//  RenterChangeWechatViewController.swift
//  OfficeGo
//
//  Created by mac on 2020/6/19.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class RenterChangeWechatViewController: BaseViewController {
    
    var timer: Timer?
    
    var countSeconds = kTimeOutNumber
    
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = kAppColor_bgcolor_F7F7F7
        return view
    }()
    lazy var phoneCurrentDescLabel: UILabel = {
        let view = UILabel()
        view.textColor = kAppColor_333333
        view.textAlignment = .left
        view.text = "微信号："
        view.font = FONT_14
        return view
    }()
    lazy var phoneCurrentField: UITextField = {
        let view = UITextField()
        view.keyboardType = .phonePad
        view.isUserInteractionEnabled = true
        view.textColor = kAppColor_333333
        view.font = FONT_14
        view.placeholder = "请输入新微信号"
        return view
    }()
    
    lazy var bottomBtnView: UIButton = {
        let view = UIButton()
        view.setTitle("确认修改", for: .normal)
        view.backgroundColor = kAppBlueColor
        view.setTitleColor(kAppWhiteColor, for: .normal)
        view.titleLabel?.font = FONT_14
        view.clipsToBounds = true
        view.layer.cornerRadius = button_cordious_2
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
    }
    
    func setUpView() {
        
        titleview = ThorNavigationView.init(type: .backTitleRight)
        titleview?.titleLabel.text = "修改微信号码"
        titleview?.rightButton.isHidden = true
        titleview?.leftButtonCallBack = { [weak self] in
            self?.leftBtnClick()
        }
        
        self.view.addSubview(titleview ?? ThorNavigationView.init(type: .backTitleRight))
        
        self.view.addSubview(phoneCurrentDescLabel)
        self.view.addSubview(phoneCurrentField)
        
        self.view.addSubview(bgView)
        bgView.addSubview(bottomBtnView)
        
        phoneCurrentDescLabel.snp.makeConstraints { (make) in
            make.top.equalTo(kNavigationHeight)
            make.leading.equalTo(left_pending_space_17)
            make.height.equalTo(64)
        }
        phoneCurrentField.snp.makeConstraints { (make) in
            make.top.height.equalTo(phoneCurrentDescLabel)
            make.trailing.equalToSuperview()
            make.leading.equalTo(phoneCurrentDescLabel.snp.trailing)
        }
        
        bgView.snp.makeConstraints { (make) in
            make.top.equalTo(phoneCurrentDescLabel.snp.bottom)
            make.bottom.leading.trailing.equalToSuperview()
        }
        bottomBtnView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(30)
            make.leading.trailing.equalToSuperview().inset(left_pending_space_17 * 2)
            make.height.equalTo(50)
        }
        
        bottomBtnView.addTarget(self, action: #selector(requestChangeWechat), for: .touchUpInside)
    }
    
}

extension RenterChangeWechatViewController {
    ///修改wx
    @objc func requestChangeWechat() {
        
        if phoneCurrentField.text?.isBlankString ?? false {
            AppUtilities.makeToast("请输入微信号")
            return
        }
        
        var params = [String:AnyObject]()
        params["newWX"] = phoneCurrentField.text as AnyObject?
        params["channel"] = UserTool.shared.user_channel as AnyObject
        params["token"] = UserTool.shared.user_token as AnyObject?
        
        SSNetworkTool.SSMine.request_changeWechat(params: params, success: {[weak self] (response) in
            
            UserTool.shared.user_wechat = self?.phoneCurrentField.text
            self?.leftBtnClick()
            
            }, failure: { (error) in
                AppUtilities.makeToast("修改失败")
        }) { (code, message) in
            
            //只有5000 提示给用户
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" {
                AppUtilities.makeToast(message)
            }else {
                AppUtilities.makeToast("修改失败")
            }
        }
    }
    
}

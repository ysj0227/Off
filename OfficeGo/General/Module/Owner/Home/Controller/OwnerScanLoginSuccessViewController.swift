//
//  OwnerScanLoginSuccessViewController.swift
//  OfficeGo
//
//  Created by mac on 2020/8/25.
//  Copyright © 2020 Senwei. All rights reserved.
//

class OwnerScanLoginSuccessViewController: BaseViewController {

    lazy var img: UIImageView = {
        let view = UIImageView.init()
        view.contentMode = .scaleAspectFit
        view.image = UIImage.init(named: "pcLogin")
        return view
    }()
    
    // 消息显示的 label
    lazy var titleLabel: UILabel = {
        let view = UILabel(frame: CGRect.zero)
        view.clipsToBounds = true
        view.font = FONT_16
        view.text = "登录确认"
        view.textAlignment = .center
        view.textColor = kAppBlackColor
        return view
    }()
    
    lazy var descLabel: UILabel = {
        let view = UILabel(frame: CGRect.zero)
        view.clipsToBounds = true
        view.font = FONT_13
        view.text = "消息将会同步到本地"
        view.textAlignment = .center
        view.textColor = kAppColor_999999
        return view
    }()
    
    
    lazy var loginBtn: UIButton = {
        let button = UIButton.init()
        button.setTitle("登录", for: .normal)
        button.setTitleColor(kAppWhiteColor, for: .normal)
        button.titleLabel?.font = FONT_MEDIUM_15
        button.layer.cornerRadius = button_cordious_2
        button.backgroundColor = kAppBlueColor
        button.addTarget(self, action: #selector(login), for: .touchUpInside)
        return button
    }()
    
    
    lazy var cancelBtn: UIButton = {
        let button = UIButton.init()
        button.setTitle("取消登录", for: .normal)
        button.setTitleColor(kAppColor_999999, for: .normal)
        button.titleLabel?.font = FONT_15
        button.backgroundColor = kAppWhiteColor
        button.addTarget(self, action: #selector(cancelLogin), for: .touchUpInside)
        return button
    }()
    
    var scanToken: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleview = ThorNavigationView.init(type: .backTitleRight)
        titleview?.backgroundColor = kAppWhiteColor
        titleview?.leftButtonCallBack = { [weak self] in
            self?.leftBtnClick()
        }
        titleview?.titleLabel.text = Device.appName
        view.addSubview(titleview ?? ThorNavigationView.init(type: .backTitleRight))
        
        setUpView()
    }
    
    func requestWebLogin() {
        
        var params = [String:AnyObject]()
        params["uid"] = UserTool.shared.user_uid as AnyObject?
        params["token"] = scanToken as AnyObject
        SSNetworkTool.SSWebLogin.request_webloign(params: params, success: { [weak self] (response) in
            
            self?.dismissVc()

            }, failure: { (error) in
                
        }) { (code, message) in
            //只有5000 提示给用户
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" {
                AppUtilities.makeToast(message)
            }
        }
    }
    
    func dismissVc() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func login() {
        requestWebLogin()
    }
    
    @objc func cancelLogin() {
        dismissVc()
    }
    
    func setUpView() {
        view.addSubview(img)
        view.addSubview(titleLabel)
        view.addSubview(descLabel)
        view.addSubview(loginBtn)
        view.addSubview(cancelBtn)
        
        img.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(kNavigationHeight + 96)
            make.size.equalTo(88)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(img.snp.bottom).offset(22)
            make.leading.trailing.equalToSuperview().inset(left_pending_space_17)
        }
        descLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(left_pending_space_17)
        }
        loginBtn.snp.makeConstraints { (make) in
            make.top.equalTo(descLabel.snp.bottom).offset(40)
            make.size.equalTo(CGSize(width: 136, height: 44))
            make.centerX.equalToSuperview()
        }
        cancelBtn.snp.makeConstraints { (make) in
            make.top.equalTo(loginBtn.snp.bottom).offset(10)
            make.size.equalTo(CGSize(width: 136, height: 44))
            make.centerX.equalToSuperview()
        }
        
    }
    

}

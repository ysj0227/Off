//
//  RenterChangePhoneViewController.swift
//  OfficeGo
//
//  Created by mac on 2020/6/18.
//  Copyright © 2020 Senwei. All rights reserved.
//

class RenterChangePhoneViewController: BaseViewController {
    
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
        view.text = "当前手机号："
        view.font = FONT_14
        return view
    }()
    lazy var phoneCurrentField: UITextField = {
        let view = UITextField()
        view.keyboardType = .phonePad
        view.isUserInteractionEnabled = false
        view.textColor = kAppColor_333333
        view.font = FONT_14
        view.text = UserTool.shared.user_phone
        return view
    }()
    lazy var phoneCurrentLineView: UIView = {
        let view = UIView()
        view.backgroundColor = kAppColor_line_EEEEEE
        return view
    }()
    lazy var phoneNewDescLabel: UILabel = {
        let view = UILabel()
        view.textColor = kAppColor_333333
        view.textAlignment = .left
        view.text = "新手机号："
        view.font = FONT_14
        return view
    }()
    lazy var phoneNewField: UITextField = {
        let view = UITextField()
        view.placeholder = "请输入新手机号"
        view.keyboardType = .phonePad
        view.clearsOnBeginEditing = false
        view.textColor = kAppColor_333333
        view.font = FONT_14
        return view
    }()
    lazy var phoneBtnLineView: UIView = {
        let view = UIView()
        view.backgroundColor = kAppColor_line_EEEEEE
        return view
    }()
    lazy var verifyBtn: UIButton = {
        let view = UIButton()
        view.setTitle("发送验证码", for: .normal)
        view.setTitleColor(kAppBlueColor, for: .normal)
        view.titleLabel?.font = FONT_14
        return view
    }()
    lazy var phoneNewLineView: UIView = {
        let view = UIView()
        view.backgroundColor = kAppColor_line_EEEEEE
        return view
    }()
    lazy var verifyCodeField: UITextField = {
        let view = UITextField()
        view.placeholder = "请输入验证码"
        view.keyboardType = .phonePad
        view.clearsOnBeginEditing = false
        view.textColor = kAppColor_333333
        view.font = FONT_14
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
    lazy var descLabel: UILabel = {
        let view = UILabel()
        view.textColor = kAppColor_666666
        view.textAlignment = .center
        view.font = FONT_10
        view.text = "修改成功需要重新登录"
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
    }
    
    func setUpView() {
        
        titleview = ThorNavigationView.init(type: .backTitleRight)
        titleview?.titleLabel.text = "修改手机号"
        titleview?.rightButton.isHidden = true
        titleview?.leftButtonCallBack = { [weak self] in
            self?.leftBtnClick()
        }
        
        self.view.addSubview(titleview ?? ThorNavigationView.init(type: .backTitleRight))
        
        self.view.addSubview(phoneCurrentDescLabel)
        self.view.addSubview(phoneCurrentField)
        self.view.addSubview(phoneCurrentLineView)
        self.view.addSubview(phoneNewDescLabel)
        self.view.addSubview(phoneNewField)
        self.view.addSubview(verifyBtn)
        self.view.addSubview(phoneBtnLineView)
        self.view.addSubview(phoneNewLineView)
        self.view.addSubview(verifyCodeField)
        
        self.view.addSubview(bgView)
        bgView.addSubview(bottomBtnView)
        bgView.addSubview(descLabel)
        
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
        phoneCurrentLineView.snp.makeConstraints { (make) in
            make.top.equalTo(phoneCurrentDescLabel.snp.bottom).offset(-1)
            make.leading.equalTo(phoneCurrentDescLabel)
            make.trailing.equalTo(phoneCurrentField)
            make.height.equalTo(1)
        }
        
        phoneNewDescLabel.snp.makeConstraints { (make) in
            make.top.equalTo(phoneCurrentDescLabel.snp.bottom)
            make.leading.equalTo(left_pending_space_17)
            make.height.equalTo(64)
            //            make.width.equalTo(80)
        }
        verifyBtn.snp.makeConstraints { (make) in
            make.top.height.equalTo(phoneNewDescLabel)
            make.trailing.equalTo(phoneCurrentField)
            make.width.equalTo(100)
        }
        phoneBtnLineView.snp.makeConstraints { (make) in
            make.trailing.equalTo(verifyBtn.snp.leading).offset(1)
            make.centerY.equalTo(verifyBtn)
            make.width.equalTo(1)
            make.height.equalTo(50)
        }
        phoneNewField.snp.makeConstraints { (make) in
            make.top.height.equalTo(phoneNewDescLabel)
            make.trailing.equalTo(verifyBtn.snp.leading)
            make.leading.equalTo(phoneNewDescLabel.snp.trailing)
        }
        phoneNewLineView.snp.makeConstraints { (make) in
            make.top.equalTo(phoneNewDescLabel.snp.bottom).offset(-1)
            make.leading.equalTo(phoneNewDescLabel)
            make.trailing.equalTo(phoneCurrentField)
            make.height.equalTo(1)
        }
        verifyCodeField.snp.makeConstraints { (make) in
            make.top.equalTo(phoneNewDescLabel.snp.bottom)
            make.leading.height.equalTo(phoneNewDescLabel)
            make.trailing.equalTo(phoneCurrentField)
        }
        
        bgView.snp.makeConstraints { (make) in
            make.top.equalTo(verifyCodeField.snp.bottom)
            make.bottom.leading.trailing.equalToSuperview()
        }
        bottomBtnView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(30)
            make.leading.trailing.equalToSuperview().inset(left_pending_space_17 * 2)
            make.height.equalTo(50)
        }
        descLabel.snp.makeConstraints { (make) in
            make.top.equalTo(bottomBtnView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        
        bottomBtnView.addTarget(self, action: #selector(requestChangePhone), for: .touchUpInside)
        
        verifyBtn.addTarget(self, action: #selector(codeResponseEvent), for: .touchUpInside)
    }
    
}

extension RenterChangePhoneViewController {
    
    //MARK: 获取验证码接口
    func getSmsCode() {
        //调用登录接口 - 成功跳转下个页面-
        var params = [String:AnyObject]()
        params["phone"] = self.phoneNewField.text as AnyObject?
        SSNetworkTool.SSLogin.request_getSmsCode(params: params, success: {  (response) in
            
        }, failure: { (error) in
            
        }) { (code, message) in
            //只有5000 提示给用户
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" {
                AppUtilities.makeToast(message)
            }
        }
        
    }
    
    ///设置修改之后的操作
    func setNewPhone() {
        
        SSTool.invokeInDebug { [weak self] in
            UserTool.shared.user_phone = phoneNewField.text
            if UserTool.shared.user_id_type == 0 {
                //不清空身份类型
                UserTool.shared.removeAll()
                self?.navigationController?.popToRootViewController(animated: false)
                
            }else if UserTool.shared.user_id_type == 1 {
                NotificationCenter.default.post(name: NSNotification.Name.OwnerUserLogout, object: nil)
            }
        }
        
    }
    
    ///修改手机号 - 成功 -
    ///业主 - 直接退出到登录页面
    ///租户 - 跳转到个人中心
    @objc func requestChangePhone() {
        
        if phoneNewField.text?.isBlankString ?? false {
            AppUtilities.makeToast("请输入手机号")
            return
        }
        
        if verifyCodeField.text?.isBlankString ?? false {
            AppUtilities.makeToast("请输入验证码")
            return
        }
        
        var params = [String:AnyObject]()
        params["newPhone"] = phoneNewField.text as AnyObject?
        params["code"] = verifyCodeField.text as AnyObject?
        params["channel"] = UserTool.shared.user_channel as AnyObject
        params["token"] = UserTool.shared.user_token as AnyObject?
        
        SSNetworkTool.SSMine.request_changePhone(params: params, success: {[weak self] (response) in
            
            self?.setNewPhone()
            
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
    
    @objc func codeResponseEvent() {
        if phoneNewField.text?.isBlankString ?? false {
            AppUtilities.makeToast("请输入手机号")
            return
        }
        
        if self.timer == nil {
            
            //发送验证码
            getSmsCode()
            
            //倒计时
            
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDownButtonTimer), userInfo: self, repeats: true)
        }
    }
    
    @objc func countDownButtonTimer() {
        if countSeconds <= 1 {
            timer?.invalidate()
            timer = nil
            self.verifyBtn.setTitle("发送验证码", for: .normal)
            self.verifyBtn.setTitleColor(kAppBlueColor, for: .normal)
            self.verifyBtn.isUserInteractionEnabled = true
            countSeconds = kTimeOutNumber
            return
        }
        countSeconds -= 1
        self.verifyBtn.setTitle("重新获取(\(countSeconds)s)", for: .normal)
        self.verifyBtn.setTitleColor(kAppColor_999999, for: .normal)
        self.verifyBtn.isUserInteractionEnabled = false
    }
}

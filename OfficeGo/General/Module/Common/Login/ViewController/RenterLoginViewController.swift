//
//  RenterLoginViewController.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/4/28.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import HandyJSON
import SwiftyJSON

class RenterLoginViewController: BaseViewController {
    
    var isHiddenBack: Bool = false {
        didSet {
            titleview?.leftButton.isHidden = isHiddenBack
        }
    }
    
    ///0 是退出登录。1是登录完成
    public var closeViewBack:((Int) -> Void) = {_ in }
    
    //如果从收藏 - 我的 - 聊天页面 点击 调起，点击登录成功-直接传回掉
    var isFromOtherVC: Bool = false
    
    var isClickVerify = false
    
    let disposeBag = DisposeBag()
    
    var areaCode = "86"
    
    let phoneNumber = "1234567890"
    let verifyCode = "123456"
    
    lazy var loginBgImgView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "loginBgImg")
        return view
    }()
    
    lazy var iconImg: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = kAppClearColor
        view.image = UIImage(named: "logo")
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    lazy var areaLabel: UILabel = {
        let areaLabel = UILabel()
        areaLabel.textColor = kAppColor_333333
        areaLabel.textAlignment = .center
        areaLabel.isUserInteractionEnabled = true
        areaLabel.font = FONT_16
        return areaLabel
    }()
    
    lazy var areaGesture: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer.init()
        return tap
    }()
    
    
    lazy var sepView: UIView = {
        let sepView = UIView()
        sepView.backgroundColor = kAppColor_line_D8D8D8
        return sepView
    }()
    
    lazy var phoneField: UITextField = {
        let phoneField = UITextField()
        phoneField.placeholder = NSLocalizedString("请输入手机号码", comment: "")
        phoneField.keyboardType = .phonePad
        phoneField.clearsOnBeginEditing = false
        phoneField.textColor = kAppColor_333333
        phoneField.font = FONT_16
        return phoneField
    }()
    
    lazy var sepView1: UIView = {
        let sepView = UIView()
        sepView.backgroundColor = kAppColor_line_D8D8D8
        return sepView
    }()
    
    lazy var verifyView: UIView = {
        let sepView = UIView()
        return sepView
    }()
    
    lazy var verifyCodeField: UITextField = {
        let view = UITextField()
        view.delegate = self
        view.placeholder = NSLocalizedString("请输入验证码", comment: "")
        view.keyboardType = .phonePad
        view.clearsOnBeginEditing = false
        view.textColor = kAppColor_333333
        view.font = FONT_16
        return view
    }()
    
    lazy var getCodeButton: UIButton = {
        let getCodeButton = UIButton.init(type: .custom)
        getCodeButton.setTitle(NSLocalizedString("获取验证码", comment: ""), for: .normal)
        getCodeButton.setTitleColor(kAppColor_line_D8D8D8, for: .normal)
        getCodeButton.clipsToBounds = true
        getCodeButton.layer.cornerRadius = button_cordious_2
        getCodeButton.isUserInteractionEnabled = false
        getCodeButton.titleLabel?.font = FONT_MEDIUM_15
        return getCodeButton
    }()
    
    lazy var nextButton: UIButton = {
        let nextButton = UIButton.init(type: .custom)
        nextButton.setTitle(NSLocalizedString("获取短信验证码", comment: ""), for: .normal)
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.clipsToBounds = true
        nextButton.layer.cornerRadius = button_cordious_2
        nextButton.backgroundColor = kAppColor_btnGray_BEBEBE
        nextButton.isUserInteractionEnabled = false
        nextButton.titleLabel?.font = FONT_MEDIUM_15
        return nextButton
    }()
    
    lazy var agreementLabel: UILabel = {
        let label = UILabel()
        label.text = "点击登录代表您已阅读并同意"
        label.textColor = kAppColor_666666
        label.font = FONT_12
        return label
    }()
    
    lazy var agreementButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setTitle("隐私条款", for: .normal)
        button.setTitleColor(kAppBlueColor, for: .normal)
        button.titleLabel?.font = FONT_12
        button.rx.tap.subscribe(onNext: { [weak self] in
            self?.clickToRegisterVC()
        }).disposed(by: disposeBag)
        return button
    }()
    
    lazy var wechatBtn: UIButton = {
        let button = BaseButton.init(textColors: nil, imageNames: nil, texts: nil)
        button.isHidden = true
        button.setTitle("微信登录", for: .normal)
        button.titleLabel?.font = FONT_14
        button.setTitleColor(kAppColor_666666, for: .normal)
        button.setImage(UIImage(named: "wechat"), for: .normal)
        button.layoutButton(.imagePositionTop, space: 12)
        button.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.testPhoneLogin()
            })
            .disposed(by: disposeBag)
        return button
    }()
    
    
    
    
    
    lazy var testphoneField: UITextField = {
        let phoneField = UITextField()
        phoneField.placeholder = NSLocalizedString("请输入手机号码", comment: "")
        phoneField.keyboardType = .phonePad
        phoneField.clearsOnBeginEditing = false
        phoneField.textColor = kAppColor_333333
        phoneField.font = FONT_16
        return phoneField
    }()
    
    lazy var testverifyCodeField: UITextField = {
        let view = UITextField()
        view.delegate = self
        view.placeholder = NSLocalizedString("请输入验证码", comment: "")
        view.keyboardType = .phonePad
        view.clearsOnBeginEditing = false
        view.textColor = kAppColor_333333
        view.font = FONT_16
        return view
    }()
    
    lazy var testLoginButton: UIButton = {
        let nextButton = UIButton.init(type: .custom)
        nextButton.setTitle(NSLocalizedString("登录", comment: ""), for: .normal)
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.clipsToBounds = true
        nextButton.layer.cornerRadius = button_cordious_2
        nextButton.backgroundColor = kAppBlueColor
        nextButton.titleLabel?.font = FONT_MEDIUM_15
        nextButton.addTarget(self, action: #selector(loginWith18516765366Code), for: .touchUpInside)
        return nextButton
    }()
    
    
    
    
    
    var timer: Timer?
    
    func clickToRegisterVC() {
        let vc = BaseWebViewController.init(protocalType: .ProtocalTypePrivacyProtocolUrl)
        vc.titleString = "隐私条款"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.phoneField.isEnabled = true
        self.getCodeButton.setTitle(NSLocalizedString("获取验证码", comment: ""), for: .normal)
        UserInfo.shared().verifyCodeSendTime = 0
        let phoneTextLength = self.phoneField.text?.count ?? 0
        self.areaLabel.isUserInteractionEnabled = true
        if phoneTextLength < 11 {
            self.getCodeButton.isUserInteractionEnabled = false
            self.getCodeButton.setTitleColor(kAppColor_line_D8D8D8, for: .normal)
        } else {
            self.getCodeButton.isUserInteractionEnabled = true
            self.getCodeButton.setTitleColor(kAppBlueColor, for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        setupActions()
        
        ///访问注册/登录页面
        SensorsAnalyticsFunc.visit_reg_login()
    }
    
    //登录跳过直接到tabbar - 租户设置已经点击过跳过
    override func rightBtnClick() {
        
        //TODO: 先暂时放出租户跳过功能
        loginBtnClick()
    }
    
    //登录之后 设置tabbar
    func loginBtnClick() {
        
        //租户
        if UserTool.shared.user_id_type == 0 {
            //都是跳转到tabbar
            NotificationCenter.default.post(name: NSNotification.Name.SetRenterTabbarViewController, object: nil)
            
        }else if UserTool.shared.user_id_type == 1 {
            
            //都是跳转到tabbar
            NotificationCenter.default.post(name: NSNotification.Name.SetOwnerTabbarViewController, object: nil)
        }
        
    }
    @objc override func leftBtnClick() {
        if self.navigationController?.viewControllers.count ?? 0 > 1 {
            self.navigationController?.popViewController(animated: true)
        }else {
            closeViewBack(0)
            self.dismiss(animated: true, completion: nil)
        }
    }
    func setupUI() {
        
        titleview = ThorNavigationView.init(type: .backTitleRight)
        titleview?.backTitleRightView.backgroundColor = kAppClearColor
        titleview?.rightButton.setTitle("跳过", for: .normal)
        
        
        //TODO: 模拟- 房东 - 隐藏 - 返回按钮
        //模拟 - 租户可以跳过登录
        if UserTool.shared.user_id_type == 1 {
            titleview?.leftButton.isHidden = true
            titleview?.rightButton.isHidden = true
        }else {
            titleview?.leftButton.isHidden = false
            titleview?.rightButton.isHidden = false
            if isHiddenBack == true {
                titleview?.leftButton.isHidden = true
            }
        }
        
        
        titleview?.rightButton.backgroundColor = kAppBlueColor
        titleview?.rightButton.setTitleColor(kAppWhiteColor, for: .normal)
        titleview?.leftButton.addTarget(self, action: #selector(leftBtnClick), for: .touchUpInside)
        titleview?.rightButton.addTarget(self, action: #selector(rightBtnClick), for: .touchUpInside)
        
        view.addSubview(loginBgImgView)
        view.addSubview(titleview ?? ThorNavigationView.init(type: .backTitleRight))
        view.addSubview(iconImg)
        view.addSubview(areaLabel)
        view.addSubview(sepView)
        view.addSubview(phoneField)
        view.addSubview(sepView1)
        verifyView.isHidden = true
        view.addSubview(verifyView)
        (verifyView).addSubview(verifyCodeField)
        (verifyView).addSubview(getCodeButton)
        view.addSubview(agreementLabel)
        view.addSubview(agreementButton)
        /*
        view.addSubview(wechatBtn)*/
        
        areaLabel.text = "+" + areaCode
        
        loginBgImgView.snp.makeConstraints { (make) in
            make.top.leading.bottom.trailing.equalToSuperview()
        }
        
        iconImg.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(kNavigationHeight + 14)
            make.size.equalTo(CGSize.init(width: 80, height: 80))
            make.centerX.equalToSuperview()
        }
        
        areaLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(login_left_pending_space_30)
            make.top.equalTo(iconImg.snp.bottom).offset(55)
            make.size.equalTo(CGSize.init(width: 45, height: 63))
        }
        
        sepView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 1, height: 13))
            make.centerY.equalTo(areaLabel)
            make.leading.equalTo(areaLabel.snp.trailing)
        }
        
        phoneField.snp.makeConstraints { (make) in
            make.leading.equalTo(sepView.snp.trailing).offset(13)
            make.height.centerY.equalTo(areaLabel)
            make.trailing.equalToSuperview().offset(-login_left_pending_space_30)
        }
        
        sepView1.snp.makeConstraints { (make) in
            make.leading.equalTo(areaLabel)
            make.trailing.equalTo(phoneField)
            make.height.equalTo(1)
            make.top.equalTo(phoneField.snp.bottom).offset(1)
        }
        
        verifyView.snp.makeConstraints { (make) in
            make.leading.equalTo(areaLabel)
            make.trailing.equalToSuperview().inset(login_left_pending_space_30)
            make.height.equalTo(0)
            make.top.equalTo(sepView1.snp.bottom)
        }
        
        verifyCodeField.snp.makeConstraints { (make) in
            make.leading.equalTo(areaLabel)
            make.trailing.equalToSuperview().inset(108)
            make.height.equalTo(63)
            make.top.equalToSuperview()
        }
        
        getCodeButton.snp.makeConstraints { (make) in
            make.height.centerY.equalTo(verifyCodeField)
            make.width.equalTo(108)
            make.trailing.equalToSuperview()
        }
        
        let sepView2 = UIView()
        sepView2.backgroundColor = kAppColor_line_D8D8D8
        verifyView.addSubview(sepView2)
        
        sepView2.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
        
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(login_left_pending_space_30)
            make.top.equalTo(verifyView.snp.bottom).offset(36)
            make.height.equalTo(btnHeight)
        }
        
        agreementLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nextButton.snp.bottom).offset(25)
            make.centerX.equalToSuperview().offset(-24)
            make.height.equalTo(16)
        }
        
        agreementButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(agreementLabel.snp.bottom)
            make.height.equalTo(agreementLabel.snp.height)
            make.left.equalTo(agreementLabel.snp.right)
        }
        
        /*
        wechatBtn.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-bottomMargin())
            make.width.equalTo(56)
            make.height.equalTo(60)
            make.centerX.equalToSuperview()
        }*/
        
        areaLabel.addGestureRecognizer(areaGesture)

        
        #if DEBUG
        view.addSubview(testLoginButton)
        view.addSubview(testverifyCodeField)
        view.addSubview(testphoneField)

        testLoginButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(login_left_pending_space_30)
            make.bottom.equalToSuperview().offset(-bottomMargin())
            make.height.equalTo(btnHeight)
        }
        
        testverifyCodeField.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(testLoginButton)
            make.height.equalTo(63)
            make.bottom.equalTo(testLoginButton.snp.top).offset(-10)
        }
        
        testphoneField.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(testLoginButton)
            make.height.equalTo(63)
            make.bottom.equalTo(testverifyCodeField.snp.top).offset(-10)
        }
        #else
        #endif
        
    }
    
    
    func updateFrame() {
        nextButton.setTitle(NSLocalizedString("登录", comment: ""), for: .normal)
        verifyView.isHidden = false
        verifyView.snp.updateConstraints { (make) in
            make.leading.equalTo(areaLabel)
            make.trailing.equalToSuperview().inset(login_left_pending_space_30)
            make.height.equalTo(64)
            make.top.equalTo(sepView1.snp.bottom)
        }
    }
    
    func setupActions() {
        Observable<Int>.interval(0.1, scheduler: MainScheduler.instance)
            .takeUntil(self.rx.deallocated)
            .subscribe({ [weak self] _ in
                //                guard UserInfo.shared().verifyCodeSendTime > 0 else {
                //                    return
                //                }
                let lastSeconds: Int = Int(UserInfo.shared().verifyCodeSendTime + TimeInterval(kTimeOutNumber) - NSDate().timeIntervalSince1970)
                self?.verifyDiscount(discount: lastSeconds)
            })
            .disposed(by: disposeBag)
        
        phoneField.rx.text.orEmpty.changed
            .subscribe(onNext: { [weak self] phoneText in
                let phoneTextLength = phoneText.count
                if phoneTextLength < 11 {
                    self?.nextButton.isUserInteractionEnabled = false
                    self?.nextButton.backgroundColor = kAppColor_btnGray_BEBEBE
                    self?.getCodeButton.isUserInteractionEnabled = false
                    self?.getCodeButton.setTitleColor(kAppColor_line_D8D8D8, for: .normal)
                } else {
                    self?.nextButton.isUserInteractionEnabled = true
                    self?.nextButton.backgroundColor = kAppBlueColor
                    self?.getCodeButton.isUserInteractionEnabled = true
                    self?.getCodeButton.setTitleColor(kAppBlueColor, for: .normal)
                }
            })
            .disposed(by: disposeBag)
        
        getCodeButton.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: { [weak self] in
                let mobile = self?.phoneField.text
                if SSTool.isPhoneNumber(phoneNumber: mobile ?? "") != true {
                    AppUtilities.makeToast("请输入正确的手机号")
                    return
                }
                self?.phoneField.isEnabled = false
                self?.getSmsCode()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                    UserInfo.shared().verifyCodeSendTime = NSDate().timeIntervalSince1970
                    UserInfo.shared().verifyMobile = mobile
                    UserInfo.shared().verifyAreaCode = self?.areaCode
                    self?.verifyDiscount(discount: kTimeOutNumber)
                })
            })
            .disposed(by: disposeBag)
        
        nextButton.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: { [weak self] (_) in
                if self?.isClickVerify == true {
                    self?.checkVerifyCode()
                }else {
                    if SSTool.isPhoneNumber(phoneNumber: self?.phoneField.text ?? "") != true {
                        AppUtilities.makeToast("请输入正确的手机号")
                        return
                    }
                    self?.isClickVerify = true
                    self?.updateFrame()
                    let mobile = self?.phoneField.text
                    self?.phoneField.isEnabled = false
                    self?.getSmsCode()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                        UserInfo.shared().verifyCodeSendTime = NSDate().timeIntervalSince1970
                        UserInfo.shared().verifyMobile = mobile
                        UserInfo.shared().verifyAreaCode = self?.areaCode
                        self?.verifyDiscount(discount: kTimeOutNumber)
                    })
                }
                
                
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: 获取验证码接口
    func getSmsCode() {
        
        
        ///点击获取验证码
        SensorsAnalyticsFunc.click_code()
        
        //调用登录接口 - 成功跳转下个页面-
        var params = [String:AnyObject]()
        params["phone"] = self.phoneField.text as AnyObject?
        SSNetworkTool.SSLogin.request_getSmsCode(params: params, success: {  (response) in
            
        }, failure: { (error) in
            
        }) { (code, message) in
            //只有5000 提示给用户
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" {
                AppUtilities.makeToast(message)
            }
        }
        
    }
    
    //验证码登录接口
    func loginWithCode() {
        
        //nextButton.isUserInteractionEnabled = false
        
        //调用登录接口 - 成功跳转下个页面-
        var params = [String:AnyObject]()
        params["phone"] = phoneField.text as AnyObject?
        params["code"] = verifyCodeField.text as AnyObject?
        params["channel"] = UserTool.shared.user_channel as AnyObject
        params["idType"] = UserTool.shared.user_id_type as AnyObject?
        SSNetworkTool.SSLogin.request_loginWithCode(params: params, success: { [weak self] (response) in
            
            if let model = LoginModel.deserialize(from: response, designatedPath: "data") {
                UserTool.shared.user_rongyuntoken = model.rongyuntoken
                UserTool.shared.user_uid = model.uid
                UserTool.shared.user_token = model.token
                UserTool.shared.user_avatars = model.avatar
                UserTool.shared.user_name = model.nickName
                UserTool.shared.user_phone = self?.phoneField.text
                
                ///如果当前登录的身份和接口返回的不一致，以接口返回的为准
                if UserTool.shared.user_id_type != model.rid {
                    UserTool.shared.user_id_type = model.rid
                    NotificationCenter.default.post(name: NSNotification.Name.UserRoleChange, object: nil)
                }else {
                    UserTool.shared.user_id_type = model.rid
                    if self?.isFromOtherVC == true {
                        ///发出登录成功通知 - 登录融云
                        NotificationCenter.default.post(name: NSNotification.Name.UserLogined, object: nil)
                        ///和左上角返回 - 做登录成功判断- 1为登录成功
                        self?.closeViewBack(1)
                        self?.setNextEnable()
                        self?.dismiss(animated: true, completion: nil)
                        
                    }else {
                        ///发出登录成功通知 - 登录融云
                        NotificationCenter.default.post(name: NSNotification.Name.UserLogined, object: nil)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { [weak self] in
                            self?.loginBtnClick()
                            self?.setNextEnable()
                        })
                    }
                }
            }
                        
            }, failure: {[weak self] (error) in
                self?.setNextEnable()
                
        }) {[weak self] (code, message) in
            //只有5000 提示给用户
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" {
                AppUtilities.makeToast(message)
            }
            self?.setNextEnable()
        }
    }
    
    func testPhoneLogin() {
       
    }
    
    //验证码登录接口
    @objc func loginWith18516765366Code() {
        
        //nextButton.isUserInteractionEnabled = false
        
        //调用登录接口 - 成功跳转下个页面-
        var params = [String:AnyObject]()
        params["phone"] = testphoneField.text as AnyObject?
        //            params["phone"] = "19111111111" as AnyObject?
        params["code"] = testverifyCodeField.text as AnyObject?
        params["channel"] = UserTool.shared.user_channel as AnyObject
        params["idType"] = UserTool.shared.user_id_type as AnyObject?
        SSNetworkTool.SSLogin.request_loginWithCode(params: params, success: { [weak self] (response) in
            
            if let model = LoginModel.deserialize(from: response, designatedPath: "data") {
                UserTool.shared.user_rongyuntoken = model.rongyuntoken
                UserTool.shared.user_uid = model.uid
                UserTool.shared.user_token = model.token
                UserTool.shared.user_avatars = model.avatar
                UserTool.shared.user_name = model.nickName
                UserTool.shared.user_phone = self?.phoneField.text
                
                if UserTool.shared.user_id_type != model.rid {
                    UserTool.shared.user_id_type = model.rid
                    NotificationCenter.default.post(name: NSNotification.Name.UserRoleChange, object: nil)
                }else {
                    UserTool.shared.user_id_type = model.rid
                    if self?.isFromOtherVC == true {
                        ///发出登录成功通知 - 登录融云
                        NotificationCenter.default.post(name: NSNotification.Name.UserLogined, object: nil)
                        ///和左上角返回 - 做登录成功判断- 1为登录成功
                        self?.closeViewBack(1)
                        self?.setNextEnable()
                        self?.dismiss(animated: true, completion: nil)
                        
                    }else {
                        ///发出登录成功通知 - 登录融云
                        NotificationCenter.default.post(name: NSNotification.Name.UserLogined, object: nil)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { [weak self] in
                            self?.loginBtnClick()
                            self?.setNextEnable()
                        })
                    }
                }
            }
            
            }, failure: {[weak self] (error) in
                self?.setNextEnable()
                
        }) {[weak self] (code, message) in
            //只有5000 提示给用户
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" {
                AppUtilities.makeToast(message)
            }
            self?.setNextEnable()
        }
    }
    
    func setNextEnable() {
        SSTool.invokeInMainThread { [weak self] in
            self?.nextButton.isUserInteractionEnabled = true
        }
    }
    
    func resignTF() {
        phoneField.resignFirstResponder()
        verifyCodeField.resignFirstResponder()
    }
    
    func checkVerifyCode() {
        
        resignTF()
        
        let mobile = self.phoneField.text
        let code = self.verifyCodeField.text
        
        if mobile?.isBlankString == true {
            AppUtilities.makeToast("请输入手机号")
            return
        }
        if SSTool.isPhoneNumber(phoneNumber: mobile ?? "") != true {
            AppUtilities.makeToast("请输入正确的手机号")
            return
        }
        if code?.isBlankString == true {
            AppUtilities.makeToast("请输入验证码")
            return
        }
        loginWithCode()
    }
    
    func verifyDiscount(discount :Int) {
        if discount > 0 {
            self.getCodeButton.isUserInteractionEnabled = false
            self.getCodeButton.setTitleColor(kAppColor_line_D8D8D8, for: .normal)
            self.getCodeButton.setTitle(String(format: NSLocalizedString("重新获取%ldS"), discount), for: .normal)
            self.phoneField.isEnabled = false
            self.areaLabel.isUserInteractionEnabled = false
            if let mobile = UserInfo.shared().verifyMobile {
                self.phoneField.text = mobile
            }
        } else {
            self.phoneField.isEnabled = true
            self.getCodeButton.setTitle(NSLocalizedString("重新获取", comment: ""), for: .normal)
            UserInfo.shared().verifyCodeSendTime = 0
            let phoneTextLength = self.phoneField.text?.count ?? 0
            self.areaLabel.isUserInteractionEnabled = true
            if phoneTextLength < 11 {
                self.getCodeButton.isUserInteractionEnabled = false
                self.getCodeButton.setTitleColor(kAppColor_line_D8D8D8, for: .normal)
            } else {
                self.getCodeButton.isUserInteractionEnabled = true
                self.getCodeButton.setTitleColor(kAppBlueColor, for: .normal)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

extension RenterLoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        ///点击验证码输入框
        SensorsAnalyticsFunc.click_code_input()
    }
}

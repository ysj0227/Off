//
//  SureAlertView.swift
//  OfficeGo
//
//  Created by mac on 2020/5/28.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class SureAlertView: UIView {
    
    ///弹框类型-
    var alertType: AlertType? {
        didSet {
            if let type = alertType {
                switch type {
                    
                case .AlertTypeVersionUpdate:
                    titleMessageLayoyt()
                    
                case .AlertTypeChatInput:
                    
                    inputLayoyt()
                    
                case .AlertTypeChatSure:
                    onlyBtnLayout()
                }
            }
        }
    }
    
    ///更新版本- 取消是否显示
    var isHiddenVersionCancel: Bool? {
        didSet {
            if isHiddenVersionCancel == true {
                ///隐藏取消按钮
                bottomBtnView.updateIsHiddenCancel = true
            }
        }
    }
    
    lazy var blackAlphabgView: UIButton = {
        let button = UIButton.init()
        button.backgroundColor = UIColor.init(white: 0, alpha: 0.7)
        button.addTarget(self, action: #selector(clickRemoveFromSuperview), for: .touchUpInside)
        return button
    }()
    
    // 白色背景
    lazy var bgview: UIView = {
        let view = UIView()
        view.backgroundColor = kAppWhiteColor
        view.clipsToBounds = true
        view.layer.cornerRadius = button_cordious_15
        return view
    }()
    
    // 消息显示的 label
    lazy var alertMessageLabel: UILabel = {
        let view = UILabel(frame: CGRect.zero)
        view.clipsToBounds = true
        view.font = UIFont.systemFont(ofSize: textMessageFontSize)
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        view.textAlignment = .center
        view.textColor = .black
        return view
    }()
    
    lazy var bottomBtnView: BottomBtnView = {
        let view = BottomBtnView.init(frame: CGRect(x: (kWidth - kMessageAlertWidth) / 2.0, y: 0, width: kMessageAlertWidth, height: btnHeight_50))
        view.bottomType = BottomBtnViewType.BottomBtnViewTypeChatAlertBottomView
        view.backgroundColor = kAppWhiteColor
        return view
    }()
    
    lazy var inputTFView: UITextField = {
        let view = UITextField()
        view.textAlignment = .left
        view.font = FONT_12
        view.textColor = kAppColor_333333
        return view
    }()
    
    // MARK: - block
    var cancelButtonCallClick:(() -> Void)?
    var sureButtonCallClick:(() -> Void)?
    
    var sureAreaaddressButtonCallBack:((String) -> Void)?
    
    var alertMsg = "" {
        didSet {
            alertMessageLabel.text = alertMsg
        }
    }
    
    @objc func clickRemoveFromSuperview() {
        guard let blockk = cancelButtonCallClick else {
            return
        }
        blockk()
        selfRemove()
    }
    
    func selfRemove() {
        self.removeFromSuperview()
    }
    
    // MARK: - 弹出view显示
    func ShowSureAlertView(superview: UIView, message: String, cancelButtonCallClick: @escaping (() -> Void), sureButtonCallClick: @escaping (() -> Void)) -> Void {
        selfRemove()
        alertMsg = message
        alertType = AlertType.AlertTypeChatSure
        self.cancelButtonCallClick = cancelButtonCallClick
        self.sureButtonCallClick = sureButtonCallClick
        
        superview.addSubview(self)
    }
    
    // MARK: - 弹出输入显示
    func ShowInputAlertView(superview: UIView, message: String, cancelButtonCallClick: @escaping (() -> Void), sureAreaaddressButtonCallBack: @escaping ((String) -> Void)) -> Void {
        selfRemove()
        alertMsg = message
        alertType = AlertType.AlertTypeChatInput
        self.cancelButtonCallClick = cancelButtonCallClick
        self.sureAreaaddressButtonCallBack = sureAreaaddressButtonCallBack
        superview.addSubview(self)
    }
    
    
    // MARK: - 弹出view显示 - message - 版本更新
    func ShowAlertView(withalertType: AlertType, superview: UIView, message: String, cancelButtonCallClick: @escaping (() -> Void), sureButtonCallClick: @escaping (() -> Void)) -> Void {
        selfRemove()
        alertMsg = message
        alertType = withalertType
        self.cancelButtonCallClick = cancelButtonCallClick
        self.sureButtonCallClick = sureButtonCallClick
        
        superview.addSubview(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.frame = frame
        
        setUpSubviews()
    }
    
    func setUpSubviews() {
        self.addSubview(blackAlphabgView)
        self.addSubview(bgview)
        bgview.addSubview(alertMessageLabel)
        bgview.addSubview(bottomBtnView)
        
        blackAlphabgView.snp.makeConstraints { (make) in
            make.top.leading.bottom.trailing.equalToSuperview()
        }
        
    }
    
    ///交换微信 - 只有两个按钮约束
    func onlyBtnLayout() {
        bgview.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: kMessageAlertWidth, height: kMessageAlertHeight))
        }
        alertMessageLabel.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(kMessageAlertHeight - btnHeight_50)
        }
        bottomBtnView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(btnHeight_50)
        }
        
        bottomBtnView.leftBtnClickBlock = { [weak self] in
            guard let blockk = self?.cancelButtonCallClick else {
                return
            }
            blockk()
            self?.selfRemove()
        }
        bottomBtnView.rightBtnClickBlock = { [weak self] in
            guard let blockk = self?.sureButtonCallClick else {
                return
            }
            blockk()
            self?.selfRemove()
        }
    }
    
    ///输入框约束
    func inputLayoyt() {
        
        inputTFView.clipsToBounds = true
        inputTFView.layer.cornerRadius = 4
        inputTFView.layer.borderColor = kAppColor_line_EEEEEE.cgColor
        inputTFView.layer.borderWidth = 1
        inputTFView.isUserInteractionEnabled = true
        bgview.addSubview(inputTFView)
        bgview.snp.remakeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: kMessageAlertWidth, height: kMessageInputAlertHeight))
        }
        bottomBtnView.snp.remakeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(btnHeight_50)
        }
        alertMessageLabel.snp.remakeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(btnHeight_50)
        }
        
        inputTFView.snp.makeConstraints { (make) in
            make.height.equalTo(40)
            make.top.equalTo(alertMessageLabel.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(15)
        }
        bottomBtnView.leftBtnClickBlock = { [weak self] in
            guard let blockk = self?.cancelButtonCallClick else {
                return
            }
            blockk()
            self?.selfRemove()
        }
        bottomBtnView.rightBtnClickBlock = { [weak self] in
            
            if self?.inputTFView.text?.isBlankString == true {
                AppUtilities.makeToast("微信号为空")
                return
            }
            
            guard let blockk = self?.sureAreaaddressButtonCallBack else {
                return
            }
            blockk(self?.inputTFView.text ?? "")
            self?.selfRemove()
        }
    }
    
    ///版本更新 - 有标题和文本说明
    func titleMessageLayoyt() {
        
        inputTFView.textAlignment = .center
        
        bgview.addSubview(inputTFView)
        bgview.snp.remakeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: kMessageAlertWidth, height: kMessageInputAlertHeight))
        }
        bottomBtnView.snp.remakeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(btnHeight_50)
        }
        alertMessageLabel.snp.remakeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(btnHeight_50)
        }
        
        inputTFView.snp.makeConstraints { (make) in
            make.height.equalTo(40)
            make.top.equalTo(alertMessageLabel.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(15)
        }
        bottomBtnView.leftBtnClickBlock = { [weak self] in
            guard let blockk = self?.cancelButtonCallClick else {
                return
            }
            blockk()
            self?.selfRemove()
        }
        bottomBtnView.rightBtnClickBlock = { [weak self] in
            guard let blockk = self?.sureButtonCallClick else {
                return
            }
            blockk()
            self?.selfRemove()
        }
    }
}

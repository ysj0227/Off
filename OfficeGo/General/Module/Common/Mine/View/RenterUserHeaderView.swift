//
//  RenterUserHeaderView.swift
//  OfficeGo
//
//  Created by mac on 2020/6/19.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class RenterUserHeaderView: UIView {
    
    lazy var headerViewBtn: UIButton = {
        let view = UIButton.init()
        view.isUserInteractionEnabled = true
        view.addTarget(self, action: #selector(leftBtnClick), for: .touchUpInside)
        return view
    }()
    
    lazy var settingBtn: UIButton = {
        let view = UIButton.init()
        view.setImage(UIImage.init(named: "setting"), for: .normal)
        view.imageEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: -20, right: -20)
        view.addTarget(self, action: #selector(sureSelectClick), for: .touchUpInside)
        return view
    }()
    
    lazy var headerImg: BaseImageView = {
        let view = BaseImageView.init()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.image = UIImage.init(named: "avatar")
        view.layer.cornerRadius = heder_cordious_36
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.font = FONT_MEDIUM_18
        view.textColor = kAppWhiteColor
        return view
    }()
    
    lazy var introductionLabel: UILabel = {
        let view = UILabel()
        view.font = FONT_13
        view.textColor = kAppWhiteColor
        return view
    }()
    
    lazy var aduitStatusView: UIButton = {
        let view = UIButton()
        view.isHidden = true
        view.titleLabel?.font = FONT_MEDIUM_11
        view.setTitleColor(kAppBlueColor, for: .normal)
        view.backgroundColor = kAppWhiteColor
        view.addTarget(self, action: #selector(identifyBtnClick), for: .touchUpInside)
        view.clipsToBounds = true
        return view
    }()
    
    lazy var loginbutton: UIButton = {
        let view = UIButton()
        view.setTitle("立即登录", for: .normal)
        view.isHidden = true
        view.titleLabel?.font = FONT_13
        view.setCornerRadius(cornerRadius: 15, masksToBounds: true)
        view.layer.borderColor = kAppWhiteColor.cgColor
        view.layer.borderWidth = 1.0
        view.setTitleColor(kAppWhiteColor, for: .normal)
        view.addTarget(self, action: #selector(leftBtnClick), for: .touchUpInside)
        return view
    }()
    var headerBtnClickBlock: (() -> Void)?
    
    var setBtnClickBlock: (() -> Void)?
    
    var identifyBtnClickBlock: (() -> Void)?

    
    var isNoLoginShowView: Bool = false {
        didSet {
            if isNoLoginShowView == true {
                aduitStatusView.isHidden = true
                loginbutton.isHidden = false
                headerImg.image = UIImage.init(named: "avatar")
                nameLabel.text = "未登录"
                introductionLabel.text = "登录开启所有精彩"
            }
        }
    }
    
    ///租户-
    var userModel: LoginUserModel = LoginUserModel() {
        didSet {
            aduitStatusView.isHidden = true
            loginbutton.isHidden = true
            headerImg.kf.setImage(with: URL(string: userModel.avatar ?? ""), placeholder: UIImage.init(named: "avatar"), options: nil, progressBlock: { (receivedSize, totalSize) in
                
                SSLog("receivedSize----\(receivedSize)---------totalSize---\(totalSize)")
            })
            if let realname = userModel.realname {
                nameLabel.text = realname
                if realname.count > 8 {
                    nameLabel.text = String(realname.prefix(8)) + ".."
                }
            }
            let company = userModel.company
            let job = userModel.job
            
            if company?.isBlankString != true && job?.isBlankString != true {
                introductionLabel.text = "\(company ?? "") - \(job ?? "")"
            }else if company?.isBlankString != true {
                introductionLabel.text = "\(company ?? "")"
            }else {
                introductionLabel.text = "\(job ?? "")"
            }
        }
    }
    
    //房东
    var ownerUserModel: LoginUserModel = LoginUserModel() {
        didSet {
            loginbutton.isHidden = true
            headerImg.kf.setImage(with: URL(string: ownerUserModel.avatar ?? ""), placeholder: UIImage.init(named: "avatar"), options: nil, progressBlock: { (receivedSize, totalSize) in
                
                SSLog("receivedSize----\(receivedSize)---------totalSize---\(totalSize)")
            })
            if let realname = ownerUserModel.proprietorRealname {
                nameLabel.text = realname
                if realname.count > 8 {
                    nameLabel.text = String(realname.prefix(8)) + ".."
                }
            }
            
            let company = ownerUserModel.proprietorCompany
            let job = ownerUserModel.proprietorJob
            
            if company?.isBlankString != true && company?.isBlankString != nil && job?.isBlankString != true && job?.isBlankString != nil {
                introductionLabel.text = "\(company ?? "") - \(job ?? "")"
            }else if company?.isBlankString != true {
                introductionLabel.text = "\(company ?? "")"
            }else {
                introductionLabel.text = "\(job ?? "")"
            }
            
            ///身份类型0个人1企业2联合
            let identify: Int = ownerUserModel.identityType ?? -1
            
            var identifyString: String?
            
            if identify == 0 {
                identifyString = ""
            }else if identify == 1 {
                identifyString = ""
            }else if identify == 2 {
                identifyString = ""
            }else {
                identifyString = "未认证"
            }
            
            ///审核状态0待审核1审核通过2审核未通过
            let auditStatus: Int = ownerUserModel.auditStatus ?? -1
            
            var auditStatusString: String?
            if auditStatus == 0 {
                auditStatusString = "待审核"
            }else if auditStatus == 1 {
                auditStatusString = "已认证"
            }else if auditStatus == 2 || auditStatus == 3 {
                auditStatusString = "审核未通过"
            }
            
            aduitStatusView.setTitle("  \(identifyString ?? "")\(auditStatusString ?? "")  ", for: .normal)
            aduitStatusView.isHidden = false
        }
    }
    
    @objc func leftBtnClick() {
        guard let blockk = headerBtnClickBlock else {
            return
        }
        blockk()
    }
    
    @objc func sureSelectClick() {
        guard let blockk = setBtnClickBlock else {
            return
        }
        blockk()
    }
    
    @objc func identifyBtnClick() {
         guard let blockk = identifyBtnClickBlock else {
             return
         }
         blockk()
     }
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    private func setupView() {
        
        addSubview(headerViewBtn)
        addSubview(settingBtn)
        headerViewBtn.addSubview(headerImg)
        headerViewBtn.addSubview(nameLabel)
        headerViewBtn.addSubview(introductionLabel)
        headerViewBtn.addSubview(loginbutton)
        headerViewBtn.addSubview(aduitStatusView)
        settingBtn.snp.makeConstraints { (make) in
            make.top.equalTo(kStatusBarHeight - 15)
            make.trailing.equalTo(-left_pending_space_17)
            make.size.equalTo(60)
        }
        headerViewBtn.snp.makeConstraints { (make) in
            make.top.equalTo(settingBtn.snp.centerY).offset(30)
            make.leading.bottom.trailing.equalToSuperview()
        }
        headerImg.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.leading.equalTo(left_pending_space_17)
            make.size.equalTo(72)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(headerImg)
            make.leading.equalTo(headerImg.snp.trailing).offset(10)
            make.height.equalTo(40)
        }
        //只有房东才会出现
        aduitStatusView.snp.makeConstraints { (make) in
            make.leading.equalTo(nameLabel.snp.trailing).offset(6)
            make.centerY.equalTo(nameLabel)
            make.width.greaterThanOrEqualTo(42)
            make.height.equalTo(18)
        }
        aduitStatusView.layer.cornerRadius = 9
        
        introductionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom)
            make.leading.equalTo(nameLabel)
            make.height.equalTo(28)
        }
        loginbutton.snp.makeConstraints { (make) in
            make.centerY.equalTo(headerImg)
            make.trailing.equalTo(settingBtn)
            make.size.equalTo(CGSize(width: 67, height: 30))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

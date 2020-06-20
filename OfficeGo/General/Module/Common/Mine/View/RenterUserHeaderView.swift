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
        view.addTarget(self, action: #selector(sureSelectClick), for: .touchUpInside)
        return view
    }()
    
    lazy var headerImg: BaseImageView = {
        let view = BaseImageView.init()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.image = UIImage.init(named: "avatar")
        view.layer.cornerRadius = heder_cordious_32
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
        view.font = FONT_12
        view.textColor = kAppWhiteColor
        return view
    }()
    
    lazy var aduitStatusView: UILabel = {
        let view = UILabel()
        view.isHidden = true
        view.font = FONT_MEDIUM_11
        view.textColor = kAppWhiteColor
        view.backgroundColor = kAppDarkBlueColor
        return view
    }()
    
    lazy var loginbutton: UIButton = {
        let view = UIButton()
        view.setTitle("立即登录", for: .normal)
        view.isHidden = true
        view.titleLabel?.font = FONT_12
        view.setCornerRadius(cornerRadius: 15, masksToBounds: true)
        view.layer.borderColor = kAppWhiteColor.cgColor
        view.layer.borderWidth = 1.0
        view.setTitleColor(kAppWhiteColor, for: .normal)
        view.addTarget(self, action: #selector(leftBtnClick), for: .touchUpInside)
        return view
    }()
    var headerBtnClickBlock: (() -> Void)?
    
    var setBtnClickBlock: (() -> Void)?
    
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
            nameLabel.text = userModel.realname ?? userModel.nickname ?? ""
            if let company = userModel.company {
                if company.isBlankString != true {
                    introductionLabel.text = "\(userModel.company ?? "") - \(userModel.job ?? "")"
                }else {
                    introductionLabel.text = ""
                }
            }else {
                introductionLabel.text = ""
            }
            
        }
    }
    
    //业主
    var ownerUserModel: LoginUserModel = LoginUserModel() {
        didSet {
            loginbutton.isHidden = true
            headerImg.kf.setImage(with: URL(string: ownerUserModel.avatar ?? ""), placeholder: UIImage.init(named: "avatar"), options: nil, progressBlock: { (receivedSize, totalSize) in
                
                SSLog("receivedSize----\(receivedSize)---------totalSize---\(totalSize)")
            })
            nameLabel.text = ownerUserModel.proprietorRealname ?? ""
            if let company = ownerUserModel.proprietorCompany {
                if company.isBlankString != true {
                    introductionLabel.text = "\(ownerUserModel.proprietorCompany ?? "") - \(ownerUserModel.proprietorJob ?? "-")"
                }else {
                    introductionLabel.text = ""
                }
            }else {
                introductionLabel.text = ""
            }
            
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
            make.top.equalTo(kStatusBarHeight + 20)
            make.trailing.equalTo(-left_pending_space_17)
            make.size.equalTo(20)
        }
        headerViewBtn.snp.makeConstraints { (make) in
            make.top.equalTo(settingBtn.snp.bottom)
            make.leading.bottom.trailing.equalToSuperview()
        }
        headerImg.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.leading.equalTo(left_pending_space_17)
            make.size.equalTo(64)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(headerImg)
            make.leading.equalTo(headerImg.snp.trailing).offset(10)
            make.height.equalTo(32)
        }
        //只有业主才会出现
        aduitStatusView.snp.makeConstraints { (make) in
            make.leading.equalTo(nameLabel.snp.trailing).offset(6)
            make.centerY.equalTo(nameLabel)
            make.width.equalTo(42)
            make.height.equalTo(18)
        }
        introductionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom)
            make.leading.equalTo(nameLabel)
            make.height.equalTo(introductionLabel)
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

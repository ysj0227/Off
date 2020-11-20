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
        view.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: -10, right: -10)
        view.addTarget(self, action: #selector(sureSelectClick), for: .touchUpInside)
        return view
    }()
    
    lazy var saoyisaoBtn: UIButton = {
        let view = UIButton.init()
        if UserTool.shared.user_id_type == 0 {
            view.isHidden = true
        }else {
            view.isHidden = false
        }
         view.setImage(UIImage.init(named: "QScan"), for: .normal)
         view.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: -10, right: -10)
         view.addTarget(self, action: #selector(saoyisaoSelectClick), for: .touchUpInside)
         return view
     }()
    
    lazy var headerImg: BaseImageView = {
        let view = BaseImageView.init()
//        view.contentMode = .scaleAspectFill
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
    
    ///扫一扫
    var saoyisaoBtnClickBlock: (() -> Void)?

    
    var isNoLoginShowView: Bool = false {
        didSet {
            if isNoLoginShowView == true {
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
            loginbutton.isHidden = true
            headerImg.kf.setImage(with: URL(string: userModel.avatar ?? ""), placeholder: UIImage.init(named: "avatar"), options: nil, progressBlock: { (receivedSize, totalSize) in
                
                SSLog("receivedSize----\(receivedSize)---------totalSize---\(totalSize)")
            })
            if let nickname = userModel.nickname {
                nameLabel.text = nickname
                if nickname.count > 8 {
                    nameLabel.text = String(nickname.prefix(8)) + ".."
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
            if let nickname = ownerUserModel.nickname {
                nameLabel.text = nickname
                if nickname.count > 8 {
                    nameLabel.text = String(nickname.prefix(8)) + ".."
                }
            }
            
            let company = ownerUserModel.company
            let job = ownerUserModel.job
            
            if company?.isBlankString != true && company?.isBlankString != nil && job?.isBlankString != true && job?.isBlankString != nil {
                introductionLabel.text = "\(company ?? "") - \(job ?? "")"
            }else if company?.isBlankString != true {
                introductionLabel.text = "\(company ?? "")"
            }else {
                introductionLabel.text = "\(job ?? "")"
            }
        }
    }
    
    @objc func leftBtnClick() {
        guard let blockk = headerBtnClickBlock else {
            return
        }
        blockk()
    }
    
    @objc func saoyisaoSelectClick() {
        guard let blockk = saoyisaoBtnClickBlock else {
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
        addSubview(saoyisaoBtn)
        headerViewBtn.addSubview(headerImg)
        headerViewBtn.addSubview(nameLabel)
        headerViewBtn.addSubview(introductionLabel)
        headerViewBtn.addSubview(loginbutton)
        settingBtn.snp.makeConstraints { (make) in
            make.top.equalTo(kStatusBarHeight - 5)
            make.trailing.equalTo(-left_pending_space_17)
            make.size.equalTo(40)
        }
        saoyisaoBtn.snp.makeConstraints { (make) in
            make.top.size.equalTo(settingBtn)
            make.trailing.equalTo(settingBtn.snp.leading)
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
        
        introductionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(-10)
            make.leading.equalTo(nameLabel)
            make.height.equalTo(48)
            make.trailing.equalToSuperview()
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

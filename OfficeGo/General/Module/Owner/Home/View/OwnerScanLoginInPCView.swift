//
//  OwnerScanLoginInPCView.swift
//  OfficeGo
//
//  Created by mac on 2020/8/24.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class OwnerScanLoginInPCView: UIView {
        
    lazy var blackAlphabgView: UIButton = {
        let button = UIButton.init()
        button.backgroundColor = UIColor.init(white: 0, alpha: 0.7)
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
    lazy var titleLabel: UILabel = {
        let view = UILabel(frame: CGRect.zero)
        view.clipsToBounds = true
        view.font = FONT_15
        view.numberOfLines = 2
        view.lineBreakMode = .byWordWrapping
        view.text = "打开http://www.officego.com.cn" + "\n" + "在电脑上发布和管理房源"
        view.textAlignment = .center
        view.textColor = kAppColor_333333
        return view
    }()
    
    lazy var closeBtn: UIButton = {
        let button = UIButton.init()
        button.setImage(UIImage.init(named: "closeGray"), for: .normal)
        button.addTarget(self, action: #selector(clickRemoveFromSuperview), for: .touchUpInside)
        return button
    }()
    
    lazy var img: UIImageView = {
        let view = UIImageView.init()
        view.contentMode = .scaleAspectFit
        view.image = UIImage.init(named: "pcLoginImg")
        return view
    }()
    
    lazy var continueEditBtn: UIButton = {
        let button = UIButton.init()
        button.setTitle("继续在APP上编辑", for: .normal)
        button.setTitleColor(kAppBlueColor, for: .normal)
        button.titleLabel?.font = FONT_13
        button.layer.borderColor = kAppBlueColor.cgColor
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = button_cordious_2
        button.backgroundColor = kAppWhiteColor
        button.addTarget(self, action: #selector(clickRemoveFromSuperview), for: .touchUpInside)
        return button
    }()
    
    lazy var pcEditBtn: UIButton = {
        let button = UIButton.init()
        button.setImage(UIImage.init(named: "QScan"), for: .normal)
        button.setTitle(" 去电脑上编辑", for: .normal)
        button.setTitleColor(kAppWhiteColor, for: .normal)
        button.titleLabel?.font = FONT_13
        button.layer.cornerRadius = button_cordious_2
        button.backgroundColor = kAppBlueColor
        button.addTarget(self, action: #selector(clickToPcScanView), for: .touchUpInside)
        return button
    }()
    
    // MARK: - block
    var cancelButtonCallClick:(() -> Void)?
    var sureButtonCallClick:(() -> Void)?
    
    @objc func clickRemoveFromSuperview() {
        guard let blockk = cancelButtonCallClick else {
            return
        }
        blockk()
        selfRemove()
    }
    
    @objc func clickToPcScanView() {
        guard let blockk = sureButtonCallClick else {
            return
        }
        blockk()
        selfRemove()
    }
    
    func selfRemove() {
        UserTool.shared.isShowPCScanLogin = true
        self.removeFromSuperview()
    }
    
    ///房东 - 我的 - 退出滑动 隐藏view
    class func Remove() {
        UIApplication.shared.keyWindow?.subviews.forEach({ (view) in
            if view.isKind(of: SureAlertView.self) {
                view.removeFromSuperview()
            }
        })
    }

    func remove() {
        UIApplication.shared.keyWindow?.subviews.forEach({ (view) in
           if view.isKind(of: OwnerScanLoginInPCView.self) {
               view.removeFromSuperview()
           }
       })
    }
    // MARK: - 弹出view显示 - message - 版本更新
    func ShowAlertView(cancelButtonCallClick: @escaping (() -> Void), sureButtonCallClick: @escaping (() -> Void)) -> Void {
        remove()
       
        self.sureButtonCallClick = sureButtonCallClick
        
        self.cancelButtonCallClick = cancelButtonCallClick

        UIApplication.shared.keyWindow?.addSubview(self)
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
        bgview.addSubview(titleLabel)
        bgview.addSubview(closeBtn)
        bgview.addSubview(img)
        bgview.addSubview(continueEditBtn)
        bgview.addSubview(pcEditBtn)
        
        blackAlphabgView.snp.makeConstraints { (make) in
            make.top.leading.bottom.trailing.equalToSuperview()
        }
        bgview.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 299, height: 391))
            make.center.equalToSuperview()
        }
        closeBtn.snp.makeConstraints { (make) in
            make.size.equalTo(42)
            make.top.trailing.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(closeBtn.snp.bottom).offset(-5)
            make.height.equalTo(46)
            make.leading.trailing.equalToSuperview().inset(28)
        }
        pcEditBtn.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().inset(35)
            make.size.equalTo(CGSize(width: 142, height: 32))
            make.centerX.equalToSuperview()
        }
        continueEditBtn.snp.makeConstraints { (make) in
            make.size.centerX.equalTo(pcEditBtn)
            make.bottom.equalTo(pcEditBtn.snp.top).offset(-22)
        }
        img.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(17)
            make.bottom.equalTo(continueEditBtn.snp.top).offset(-40)
        }
    }
}

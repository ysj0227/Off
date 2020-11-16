//
//  OwnerNoIdentifyShowView.swift
//  OfficeGo
//
//  Created by Mac pro on 2020/10/20.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class OWnerToIdentifyView: UIView {
    
    lazy var topIconImageView : BaseImageView = {
        let imageView = BaseImageView()
        imageView.backgroundColor = kAppWhiteColor
        return imageView
    }()
    
    lazy var imageView : BaseImageView = {
        let imageView = BaseImageView()
        imageView.image = UIImage.init(named: "toIdentify")
        imageView.backgroundColor = kAppWhiteColor
        return imageView
    }()
    
    lazy var identifyBtn: UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.layer.cornerRadius = button_cordious_15
        button.backgroundColor = kAppBlueColor
        button.setTitle("去认证", for: .normal)
        button.titleLabel?.font = FONT_MEDIUM_15
        button.addTarget(self, action: #selector(clickIdentify), for: .touchUpInside)
        return button
    }()
    
    var sureIdentifyButtonCallBack:(() -> Void)?
    
    @objc func clickIdentify() {
        guard let blockk = sureIdentifyButtonCallBack else {
            return
        }
        blockk()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.backgroundColor = kAppLightBlueColor
        setupView()
    }
    
    func setupView() {
        addSubview(topIconImageView)
        addSubview(imageView)
        addSubview(identifyBtn)
        topIconImageView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(74)
        }
        imageView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(left_pending_space_17)
            make.top.equalTo(topIconImageView.snp.bottom)
            make.height.equalTo(kWidth - left_pending_space_17 * 2)
        }
        identifyBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(37)
            make.size.equalTo(CGSize(width: 130, height: 30))
        }
    }
}


class OwnerNoIdentifyShowView: UIView {
        
    lazy var blackAlphabgView: UIButton = {
        let button = UIButton.init(frame: self.frame)
        button.backgroundColor = kAppAlphaWhite0_alpha_7
        button.addTarget(self, action: #selector(clickRemoveFromSuperview), for: .touchUpInside)
        return button
    }()
    
    lazy var bgView : UIView = {
        let view = UIView()
        view.frame = CGRect(x: (kWidth - 300) / 2.0, y: (kHeight - 300) / 2.0, width: 300, height: 350)
        view.backgroundColor = kAppWhiteColor
        view.clipsToBounds = true
        view.layer.cornerRadius = button_cordious_15
        return view
    }()
    
    lazy var closeBtn: UIButton = {
        let button = UIButton(frame: CGRect(x: (kWidth - 300) / 2.0 + 300 - 40, y: (kHeight - 300) / 2.0, width: 40, height: 40))
        button.setImage(UIImage.init(named: "closeGray"), for: .normal)
        button.addTarget(self, action: #selector(clickRemoveFromSuperview), for: .touchUpInside)
        return button
    }()
    
    
    lazy var cycleView:CycleView = {
        let cycleview = CycleView(frame: CGRect(x: (kWidth - 300) / 2.0, y: (kHeight - 280) / 2.0 + 40, width: 300, height: 200 + 80))
        cycleview.invalidateTimer()
        cycleview.mode = .scaleAspectFit
        cycleview.isAlert = true
        cycleview.pageColor = kAppLightBlueColor
        cycleview.currentPageColor = kAppBlueColor
        cycleview.imageURLStringArr = ["noIdentify1", "noIdentify2", "noIdentify3", "noIdentify4"]
        cycleview.titleArr = ["成为房东，房源全网触达", "720 VR全方位呈现房源", "与客户线上直接沟通", "交易数据保密，无中介费"]
        return cycleview
    }()
    
    
    lazy var identifyBtn: UIButton = {
        let button = UIButton(frame: CGRect(x: (kWidth - 130) / 2.0 , y: (kHeight - 300) / 2.0 + 40 + 220, width: 130, height: 30))
        button.clipsToBounds = true
        button.layer.cornerRadius = button_cordious_15
        button.backgroundColor = kAppBlueColor
        button.setTitle("去认证", for: .normal)
        button.titleLabel?.font = FONT_MEDIUM_15
        button.addTarget(self, action: #selector(clickIdentify), for: .touchUpInside)
        return button
    }()
    
    // MARK: - block
    fileprivate var clearButtonCallBack:(() -> Void)?
    
    fileprivate var sureIdentifyButtonCallBack:(() -> Void)?
                
    @objc func clickRemoveFromSuperview() {
        guard let blockk = clearButtonCallBack else {
            return
        }
        blockk()
        selfRemove()
    }
    
    @objc func clickIdentify() {
        guard let blockk = sureIdentifyButtonCallBack else {
            return
        }
        blockk()
        selfRemove()
    }
    
    func selfRemove() {
        self.removeFromSuperview()
    }
    
    
    // MARK: - 弹出view显示 - 排序
    func ShowOwnerNoIdentifyShowView(clearButtonCallBack: @escaping (() -> Void), sureHouseSortButtonCallBack: @escaping (() -> Void)) -> Void {
        UIApplication.shared.keyWindow?.subviews.forEach({ (view) in
            if view.isKind(of: OwnerNoIdentifyShowView.self) {
                view.removeFromSuperview()
            }
        })
        
        self.frame = CGRect(x: 0.0, y: 0, width: kWidth, height: kHeight)
        self.clearButtonCallBack = clearButtonCallBack
        self.sureIdentifyButtonCallBack = sureHouseSortButtonCallBack
        UIApplication.shared.keyWindow?.addSubview(self)
    }
        
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setUpSubviews()
    }
    
    func setUpSubviews() {
        addSubview(blackAlphabgView)
        addSubview(bgView)
        addSubview(closeBtn)
        addSubview(cycleView)
        addSubview(identifyBtn)
    }
}


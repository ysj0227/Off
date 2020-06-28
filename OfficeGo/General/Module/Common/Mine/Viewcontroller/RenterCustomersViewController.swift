//
//  RenterCustomersViewController.swift
//  OfficeGo
//
//  Created by mac on 2020/6/28.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class RenterCustomersViewController: BaseViewController {

    lazy var bgImgView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.init(named: "customerBgImg")
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    lazy var mailBtn: UIButton = {
        let view = UIButton()
        view.setImage(UIImage.init(named: "emailSend"), for: .normal)
        return view
    }()
    
    lazy var phoneBtn: UIButton = {
        let view = UIButton()
        view.setImage(UIImage.init(named: "dailNumber"), for: .normal)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpView()
    }
    
    func setUpView() {
    
        titleview = ThorNavigationView.init(type: .backTitleRight)
        titleview?.titleLabel.text = "联系客服"
        titleview?.rightButton.isHidden = true
        titleview?.leftButtonCallBack = { [weak self] in
            self?.leftBtnClick()
        }
        
        self.view.addSubview(titleview ?? ThorNavigationView.init(type: .backTitleRight))
        
        self.view.addSubview(bgImgView)
        bgImgView.snp.makeConstraints { (make) in
            make.top.equalTo(kNavigationHeight)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(kWidth * imgScale)
        }
        
        self.view.addSubview(mailBtn)
        mailBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(30)
            make.bottom.equalTo(bgImgView).offset(-30)
            make.size.equalTo(34)
        }
        
        self.view.addSubview(phoneBtn)
        phoneBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(mailBtn.snp.trailing).offset(30)
            make.bottom.size.equalTo(mailBtn)
        }
        
        mailBtn.addTarget(self, action: #selector(emailClick), for: .touchUpInside)
        
        phoneBtn.addTarget(self, action: #selector(phoneClick), for: .touchUpInside)

    }

    
    @objc func emailClick() {
        
    }
    
    @objc func phoneClick() {
        let alertController = UIAlertController.init(title: "联系客服", message: nil, preferredStyle: .actionSheet)
        let refreshAction = UIAlertAction.init(title: "业务咨询", style: .default) { (action: UIAlertAction) in
            SSTool.callPhoneTelpro(phone: "13817176560")
        }
        let copyAction = UIAlertAction.init(title: "技术支持", style: .default) { (action: UIAlertAction) in
            SSTool.callPhoneTelpro(phone: "13052007068")
        }
        let cancelAction = UIAlertAction.init(title: "取消", style: .cancel) { (action: UIAlertAction) in

        }
        alertController.addAction(refreshAction)
        alertController.addAction(copyAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)

    }
}

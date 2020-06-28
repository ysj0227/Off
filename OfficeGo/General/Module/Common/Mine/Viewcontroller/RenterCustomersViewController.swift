//
//  RenterCustomersViewController.swift
//  OfficeGo
//
//  Created by mac on 2020/6/28.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit
import MessageUI

class RenterCustomersViewController: BaseViewController, MFMailComposeViewControllerDelegate {

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
        //0.首先判断设备是否能发送邮件
        if MFMailComposeViewController.canSendMail() {
            //1.配置邮件窗口
            let mailView = configuredMailComposeViewController()
            //2. 显示邮件窗口
            present(mailView, animated: true, completion: nil)
        } else {
            print("Whoop...设备不能发送邮件")
            showSendMailErrorAlert()
        }
    }
    //MARK:- helper methods
    //配置邮件窗口
    func configuredMailComposeViewController() -> MFMailComposeViewController {

        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self

        //设置邮件地址、主题及正文
        mailComposeVC.setToRecipients(["Clientservice@officego.com"])
//        mailComposeVC.setToRecipients(["995924226@qq.com"])

        mailComposeVC.setSubject("")
        mailComposeVC.setMessageBody("", isHTML: false)

        return mailComposeVC
    }


    //提示框，提示用户设置邮箱
    func showSendMailErrorAlert() {

        let sendMailErrorAlert = UIAlertController(title: "未开启邮件功能", message: "设备邮件功能尚未开启，请在设置中更改", preferredStyle: .alert)
        sendMailErrorAlert.addAction(UIAlertAction(title: "确定", style: .default) { _ in })
        self.present(sendMailErrorAlert, animated: true){}
    }


    //MARK:- Mail Delegate
    //用户退出邮件窗口时被调用
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result.rawValue{
        case MFMailComposeResult.sent.rawValue:
            print("邮件已发送")
        case MFMailComposeResult.cancelled.rawValue:
            print("邮件已取消")
        case MFMailComposeResult.saved.rawValue:
            print("邮件已保存")
        case MFMailComposeResult.failed.rawValue:
            print("邮件发送失败")
        default:
            print("邮件没有发送")
            break
        }

        controller.dismiss(animated: true, completion: nil)
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

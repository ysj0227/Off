//
//  RenterChangePhoneViewController.swift
//  OfficeGo
//
//  Created by mac on 2020/6/18.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class RenterChangePhoneViewController: UIViewController {
    
    let phoneCurrentDescLabel: UILabel = {
        let view = UILabel()
        view.textColor = kAppColor_333333
        view.textAlignment = .center
        view.font = FONT_14
        return view
    }()
    let phoneCurrentField: UITextField = {
        let view = UITextField()
        view.placeholder = UserTool.shared.user_phone
        view.keyboardType = .phonePad
        view.clearsOnBeginEditing = false
        view.textColor = kAppColor_333333
        view.font = FONT_14
        return view
    }()
    
    let phoneCurrentLineView: UIView = {
        let sepView = UIView()
        sepView.backgroundColor = kAppColor_line_D8D8D8
        return sepView
    }()
    let phoneNewDescLabel: UILabel = {
        let view = UILabel()
        view.textColor = kAppColor_333333
        view.textAlignment = .center
        view.font = FONT_14
        return view
    }()
    let phoneNewField: UITextField = {
        let view = UITextField()
        view.placeholder = UserTool.shared.user_phone
        view.keyboardType = .phonePad
        view.clearsOnBeginEditing = false
        view.textColor = kAppColor_333333
        view.font = FONT_14
        return view
    }()
    let phoneBtnLineView: UIView = {
        let view = UIView()
        view.backgroundColor = kAppColor_line_D8D8D8
        return view
    }()
    let verifyBtn: UIButton = {
        let view = UIButton()
        view.setTitle("发送验证码", for: .normal)
        view.setTitleColor(kAppBlueColor, for: .normal)
        view.titleLabel?.font = FONT_14
        return view
    }()
    let phoneNewLineView: UIView = {
        let view = UIView()
        view.backgroundColor = kAppColor_line_D8D8D8
        return view
    }()
    let verifyCodeField: UITextField = {
        let view = UITextField()
        view.placeholder = UserTool.shared.user_phone
        view.keyboardType = .phonePad
        view.clearsOnBeginEditing = false
        view.textColor = kAppColor_333333
        view.font = FONT_14
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
}

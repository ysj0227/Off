//
//  CustomerSearchBarview.swift
//  OfficeGo
//
//  Created by mac on 2020/5/20.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class CustomerSearchBarview: UIView {
    
    var searchImg: UIImageView = {
        let view = UIImageView.init(image: UIImage.init(named: "searchGray"))
        return view
    }()
    
    var searchTextfiled: UITextField = {
        let view = UITextField()
        view.textAlignment = .left
        view.font = FONT_LIGHT_12
        view.textColor = kAppColor_333333
        view.placeholder = "通过姓名或公司搜索联系人"
        return view
    }()
    
    func setUpSubviews() {
        
        self.backgroundColor = kAppWhiteColor
        
        self.clipsToBounds = true
        
        self.layer.cornerRadius = self.height / 2.0
        
        addSubview(searchImg)
        addSubview(searchTextfiled)
        
//        searchTextfiled.delegate = self
        
        searchImg.snp.makeConstraints { (make) in
            make.leading.equalTo(13)
            make.centerY.equalToSuperview()
        }
        searchTextfiled.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
            make.leading.equalTo(searchImg.snp.trailing).offset(3)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpSubviews()
    }
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.frame = frame
        
        setUpSubviews()
    }
}

extension CustomerSearchBarview: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return true
    }
}

//
//  ButtonSelectItemView.swift
//  OfficeGo
//
//  Created by mac on 2020/5/14.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class ButtonSelectItemView: UIView {
    
    var recommendBtn: UIButton = {
        let view = UIButton()
        view.setTitle("推荐房源", for: .normal)
        view.titleLabel?.font = FONT_MEDIUM_15
        view.tag = 1
        view.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
        view.setTitleColor(kAppWhiteColor, for: .normal)
        return view
    }()
    var nearbyBtn: UIButton = {
        let view = UIButton()
        view.setTitle("附近房源", for: .normal)
        view.titleLabel?.font = FONT_LIGHT_11
        view.tag = 2
        view.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
        view.setTitleColor(kAppWhiteColor, for: .normal)
        return view
    }()
    
    var selectedBtn: UIButton?
    
    var buttonCallBack:((Int) -> Void)?
    
    func setunselected(btn: UIButton) {
        btn.titleLabel?.font = FONT_LIGHT_11
    }
    
    func setselected(btn: UIButton) {
        btn.titleLabel?.font = FONT_MEDIUM_15
    }
    
    @objc func btnClick(btn: UIButton) {
        if btn == selectedBtn {
            return
        }
        setunselected(btn: selectedBtn ?? UIButton())
        setselected(btn: btn)
        selectedBtn = btn
        guard let block = buttonCallBack else {
            return
        }
        block(btn.tag)
    }
    
    public override required init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        
        self.addSubview(recommendBtn)
        self.addSubview(nearbyBtn)
        
        recommendBtn.snp.makeConstraints { (make) in
            make.top.leading.bottom.equalToSuperview()
            make.width.equalTo(60)
        }
        
        nearbyBtn.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(recommendBtn.snp.trailing)
            make.width.equalTo(60)
        }
        
        selectedBtn = recommendBtn
    }
    
    
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


class ButtonCycleSelectItemView: UIView {
    
    var selectedBtn: UIButton?
    
    var buttonCallBack:((Int) -> Void)?
    
    //详情圆角按钮
    func setCyleunselected(btn: UIButton) {
        btn.setTitleColor(kAppBlueColor, for: .normal)
        btn.backgroundColor = kAppWhiteColor
    }
    //首页按钮
    func setCycleselected(btn: UIButton) {
        btn.setTitleColor(kAppWhiteColor, for: .normal)
        btn.backgroundColor = kAppBlueColor
    }
    @objc func btnCycleClick(btn: UIButton) {
        if btn == selectedBtn {
            return
        }
        setCyleunselected(btn: selectedBtn ?? UIButton())
        setCycleselected(btn: btn)
        selectedBtn = btn
        guard let block = buttonCallBack else {
            return
        }
        block(btn.tag)
    }
    
    //详情三个按钮点击切换
    public required init(frame: CGRect, titleArrs:[String], selectedIndex: Int) {        super.init(frame: frame)
        self.frame = frame
        
        self.backgroundColor = kAppWhiteColor
        
        self.clipsToBounds = true
        self.layer.cornerRadius = self.height / 2.0
        
        let x: Int = 0
        let itemWidth: Int = Int(self.width) / titleArrs.count
        for title in titleArrs {
            let index = titleArrs.lastIndex(of: title)
            let view = UIButton()
            view.setTitle(title, for: .normal)
            view.titleLabel?.font = FONT_MEDIUM_10
            view.tag = index ?? 0
            view.tag += 1
            view.addTarget(self, action: #selector(btnCycleClick(btn:)), for: .touchUpInside)
            view.setTitleColor(kAppBlueColor, for: .normal)
            view.frame = CGRect(x: (x + itemWidth) * (index ?? 0), y: 0, width: itemWidth, height: Int(self.height))
            view.clipsToBounds = true
            self.addSubview(view)
            
            
            //设置第一个按钮位选中 - tag为1
            if index == selectedIndex {
                selectedBtn = view
            }
        }
        setCycleselected(btn: selectedBtn ?? UIButton())
        guard let block = buttonCallBack else {
            return
        }
        block(selectedBtn?.tag ?? 1)
        
    }
    
    
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

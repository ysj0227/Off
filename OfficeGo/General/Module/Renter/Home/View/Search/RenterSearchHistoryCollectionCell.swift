//
//  RenterSearchHistoryCollectionCell.swift
//  OfficeGo
//
//  Created by mac on 2020/5/14.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class RenterSearchHistoryCollectionCell:  BaseCollectionViewCell {
    
    //按钮点击方法
    var buttonCallBack:((String) -> Void)?
    
    var isHistory: Bool = false
    
    @objc func btnClick() {
        guard let blockk = buttonCallBack else {
            return
        }
        if isHistory == true {
            if let name = historyModel?.keywords {
                blockk(name)
            }
        }else {
            if let name = findHotModel?.dictCname {
                blockk(name)
            }
        }        
    }
    
    lazy var titleLabel: UIButton = {
        let view = UIButton()
        //        view.textAlignment = .center
        view.clipsToBounds = true
        view.layer.cornerRadius = 2
        view.titleLabel?.font = FONT_LIGHT_11
        view.backgroundColor = kAppColor_line_EEEEEE
        view.setTitleColor(kAppColor_333333, for: .normal)
        view.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        return view
    }()
    
    var findHotModel: DictionaryModel? {
        didSet {
            titleLabel.setTitle(findHotModel?.dictCname, for: .normal)
        }
    }
    
    
    class func sizeWithFindHotData(findHotModel: DictionaryModel) -> CGSize {
        if findHotModel.dictCname?.count ?? 0 <= 0 {
            return .zero
        }
        let width:CGFloat = findHotModel.dictCname?.boundingRect(with: CGSize(width: kWidth, height: 24), font: FONT_LIGHT_11, lineSpacing: 0).width ?? 0.0
        return CGSize(width: width + 30.0, height: 24)
    }
    
    //历史
    var historyModel: SearchHistoryModel? {
        didSet {
            titleLabel.setTitle(historyModel?.keywords, for: .normal)
        }
    }
    
    
    class func sizeWithHistoryModelData(historyModel: SearchHistoryModel) -> CGSize {
        if historyModel.keywords?.count ?? 0 <= 0 {
            return .zero
        }
        let width:CGFloat = historyModel.keywords?.boundingRect(with: CGSize(width: kWidth, height: 24), font: FONT_LIGHT_11, lineSpacing: 0).width ?? 0.0
        return CGSize(width: width + 30.0, height: 24)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(24)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class RenterSearchCollectionViewHeader: UICollectionReusableView {
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = FONT_MEDIUM_15
        view.backgroundColor = kAppWhiteColor
        view.textColor = kAppColor_333333
        return view
    }()
    
    lazy var headerButton: UIButton = {
        let view = UIButton()
        view.imageView?.contentMode = .scaleAspectFit
        view.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        return view
    }()
    
    //按钮点击方法
    var buttonCallBack:((String) -> Void)?
    
    @objc func btnClick() {
        guard let blockk = buttonCallBack else {
            return
        }
        blockk("selectedIndex")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(headerButton)
        titleLabel.snp.makeConstraints { (make) in
            make.leading.top.bottom.equalToSuperview()
        }
        headerButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-left_pending_space_17)
            make.width.equalTo(14)
            make.height.equalTo(12)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
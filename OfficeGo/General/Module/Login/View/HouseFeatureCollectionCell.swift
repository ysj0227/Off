//
//  HouseFeatureCollectionCell.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/4/29.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class HouseFeatureCollectionCell: BaseCollectionViewCell {
    lazy var itemButton: BaseButton = {
        var colors = ThorButtonTextColor()
        colors.normalColor = kAppColor_333333
        colors.selectedColor = kAppBlueColor
        let button = BaseButton.init(textColors: colors, imageNames: nil, texts:nil)
        button.titleLabel?.font = FONT_LIGHT_13
        button.layer.cornerRadius = 3
        button.isUserInteractionEnabled = false
        button.clipsToBounds = true
        button.backgroundColor = kAppColor_bgcolor_F7F7F7
        return button
    }()
    
    var model: HouseFeatureModel? {
        didSet {
            itemButton.b_texts = ThorButtonText(normalText: model?.dictCname, selectedText: model?.dictCname, disableText: model?.dictCname)
        }
    }
    
    //设置背景颜色
    func setButtonSelected(isSelected: Bool) {
        if isSelected {
            itemButton.isSelected = true
            itemButton.titleLabel?.font = FONT_MEDIUM_13
            itemButton.backgroundColor = kAppLightBlueColor
        }else {
            itemButton.isSelected = false
            itemButton.titleLabel?.font = FONT_LIGHT_13
            itemButton.backgroundColor = kAppColor_bgcolor_F7F7F7
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(itemButton)
        itemButton.snp.makeConstraints { (make) in
            make.top.leading.bottom.trailing.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

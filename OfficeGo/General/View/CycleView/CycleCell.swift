//
//  CycleCell.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/4/26.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class CycleCell: UICollectionViewCell {
    
    var isAlert: Bool? {
        didSet {
            if isAlert == true {
                setUpAlertUI()
            }
        }
    }
    
    var mode : contentMode? {
        didSet{
            switch mode ?? .scaleAspectFill {
            case .scaleAspectFill:
                imageView.contentMode = .scaleAspectFill
            case .scaleAspectFit:
                imageView.contentMode = .scaleAspectFit
            }
        }
    }
    
    //FIXME: 本地和网络下载走的不同路径
    var imageURLString : String? {
        didSet{
            if (imageURLString?.hasPrefix("http"))! {
                //网络图片:使用SDWebImage下载即可
                imageView.setImage(with: imageURLString ?? "", placeholder: UIImage.init(named: Default_4x3_large))
            } else {
                //本地图片
                imageView.image = UIImage(named: imageURLString!)
            }
        }
    }
    
    var titleString : String? {
        didSet {
            titleLabel.text = titleString
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: 懒加载
    lazy var imageView : BaseImageView = {
        let imageView = BaseImageView(frame: bounds)
        imageView.clipsToBounds = true
        imageView.backgroundColor = kAppWhiteColor
        return imageView
    }()
    
    //MARK: 懒加载
    lazy var titleLabel : UILabel = {
        let imageView = UILabel()
        imageView.textAlignment = .center
        imageView.font = FONT_15
        imageView.textColor = kAppColor_333333
        imageView.backgroundColor = kAppWhiteColor
        return imageView
    }()
}

//MARK: 设置UI
extension CycleCell {
    fileprivate func setUpUI() {
        contentView.addSubview(imageView)
    }
    
    fileprivate func setUpAlertUI() {
        contentView.addSubview(titleLabel)
        titleLabel.frame = CGRect(x: 0, y: 0, width: self.width, height: 40)
        imageView.frame = CGRect(x: 0, y: 40, width: self.width, height: 180)
    }
    
}

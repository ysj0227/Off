//
//  OwnerImagePickerCell.swift
//  OfficeGo
//
//  Created by mac on 2020/7/13.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

typealias CloseBtnClickClouse = (Int)->()
typealias VisitPhotoBtnClickClouse = (Int)->()

class OwnerImagePickerCell: BaseCollectionViewCell {
    
    
    var indexPath: IndexPath? {
        didSet {
            closeBtn.tag = indexPath?.row ?? 0
        }
    }
    
    @objc var closeBtnClickClouse: CloseBtnClickClouse?
    @objc var visitPhotoBtnClickClouse: VisitPhotoBtnClickClouse?
    
    /// 关闭按钮
    @objc func clickCloseBtn(btn:UIButton) {
        
        if self.closeBtnClickClouse != nil {
            self.closeBtnClickClouse!(btn.tag)
        }
    }
    
    /// 选择相册
//    @objc func clickChooseImage(index:Int) {
//        if self.visitPhotoBtnClickClouse != nil {
//            self.visitPhotoBtnClickClouse!(index)
//        }
//    }
    let image: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = kAppClearColor
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.image = UIImage.init(named: "addImgBg")
        return view
    }()
    
    let closeBtn: UIButton = {
        let view = UIButton()
        view.setImage(UIImage.init(named: "imageDeleIcon"), for: .normal)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(image)
        addSubview(closeBtn)
        image.snp.makeConstraints { (make) in
            make.top.leading.bottom.trailing.equalToSuperview().inset(5)
        }
        closeBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.size.equalTo(20)
        }
//        image.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(clickChooseImage(index:))))

        closeBtn.addTarget(self, action: #selector(clickCloseBtn(btn:)), for: .touchUpInside)
    }
    
}

class OwnerImgPickerCollectionViewHeader: UICollectionReusableView {
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = FONT_14
        view.textColor = kAppColor_999999
        return view
    }()
    
    lazy var descLabel: UILabel = {
        let view = UILabel()
        view.font = FONT_12
        view.textColor = kAppColor_999999
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(descLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(left_pending_space_17)
            make.top.equalToSuperview()
            make.height.equalTo(46)
        }
        descLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(-15)
            make.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

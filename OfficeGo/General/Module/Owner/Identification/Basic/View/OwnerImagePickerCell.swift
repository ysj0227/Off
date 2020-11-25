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

class OwnerNewIdtnfifyImagePickerCell: BaseCollectionViewCell {
    
    var indexPath: IndexPath? {
        didSet {
            closeBtn.tag = indexPath?.row ?? 0
        }
    }
    
    ///删除
    @objc var closeBtnClickClouse: CloseBtnClickClouse?
    
    @objc var visitPhotoBtnClickClouse: VisitPhotoBtnClickClouse?
    
    /// 关闭按钮
    @objc func clickCloseBtn(btn:UIButton) {
        
        if self.closeBtnClickClouse != nil {
            self.closeBtnClickClouse!(btn.tag)
        }
    }
    
    let image: BaseImageView = {
        let view = BaseImageView()
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

        self.backgroundColor = kAppWhiteColor
          
        self.contentView.addSubview(image)
        self.contentView.addSubview(closeBtn)
        image.snp.makeConstraints { (make) in
            make.top.leading.bottom.trailing.equalToSuperview().inset(5)
        }
        closeBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.size.equalTo(20)
        }
        closeBtn.addTarget(self, action: #selector(clickCloseBtn(btn:)), for: .touchUpInside)
        
    }
    
}

class OwnerFYManagerImagePickerCell: BaseCollectionViewCell {
    
    
    var indexPath: IndexPath? {
        didSet {
            closeBtn.tag = indexPath?.row ?? 0
            mainTags.tag = indexPath?.row ?? 0
        }
    }
    
    ///删除
    @objc var closeBtnClickClouse: CloseBtnClickClouse?
    
    ///设置为封面图
    @objc var setMainPicClouse: CloseBtnClickClouse?
    
    @objc var visitPhotoBtnClickClouse: VisitPhotoBtnClickClouse?
    
    /// 关闭按钮
    @objc func clickCloseBtn(btn:UIButton) {
        
        if self.closeBtnClickClouse != nil {
            self.closeBtnClickClouse!(btn.tag)
        }
    }
    
    /// 封面图按钮
    @objc func clickSetMainBtn(btn:UIButton) {
        
        if self.setMainPicClouse != nil {
            self.setMainPicClouse!(btn.tag)
        }
    }
    
    /// 选择相册
//    @objc func clickChooseImage(index:Int) {
//        if self.visitPhotoBtnClickClouse != nil {
//            self.visitPhotoBtnClickClouse!(index)
//        }
//    }
    let image: BaseImageView = {
        let view = BaseImageView()
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
    
    let mainTags: UIButton = {
        let view = UIButton()
        view.backgroundColor = kAppBlueAlphaColor
        view.setTitle("设置为封面图", for: .normal)
        view.setTitleColor(kAppWhiteColor, for: .normal)
        view.titleLabel?.font = FONT_MEDIUM_11
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

        self.backgroundColor = kAppWhiteColor
          
        self.contentView.addSubview(image)
        self.contentView.addSubview(closeBtn)
        self.contentView.addSubview(mainTags)
        image.snp.makeConstraints { (make) in
            make.top.leading.bottom.trailing.equalToSuperview().inset(5)
        }
        closeBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.size.equalTo(20)
        }
        
        mainTags.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(image)
            make.height.equalTo(25)
        }
//        image.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(clickChooseImage(index:))))

        closeBtn.addTarget(self, action: #selector(clickCloseBtn(btn:)), for: .touchUpInside)
        
        mainTags.addTarget(self, action: #selector(clickSetMainBtn(btn:)), for: .touchUpInside)

        
    }
    
}


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
    let image: BaseImageView = {
        let view = BaseImageView()
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

        self.backgroundColor = kAppWhiteColor
        self.contentView.addSubview(image)
        self.contentView.addSubview(closeBtn)
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
        view.textColor = kAppColor_btnGray_BEBEBE
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


class OwnerNewIdentifyRejectViewHeader: UICollectionReusableView {
    
    @objc func openClick(btn: UIButton) {
        btn.isSelected = !btn.isSelected
        guard let block = isOpenBlock else {
            return
        }
        block(btn.isSelected)
    }
    
    var isOpen: Bool? {
        didSet {
            openBtn.isSelected = isOpen ?? false
        }
    }
    
    var isOpenBlock:((_ isOpen: Bool) -> Void)?

    ///驳回原因
    lazy var rejectReasonLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.textColor = kAppRedColor
        view.font = FONT_13
        return view
    }()
    
    ///收起按钮
    lazy var openBtn: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "upIconGary"), for: .selected)
        view.setImage(UIImage(named: "downIcon"), for: .normal)
        view.addTarget(self, action: #selector(openClick(btn:)), for: .touchUpInside)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(rejectReasonLabel)
        addSubview(openBtn)
        rejectReasonLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().inset(left_pending_space_17)
            make.top.bottom.equalToSuperview().inset(12)
            make.trailing.equalToSuperview().inset(44)
        }
        openBtn.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview()
            make.size.equalTo(42)
            make.top.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class OwnerImgPickerCollectionViewFooter: UICollectionReusableView {
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = FONT_12
        view.textColor = kAppColor_btnGray_BEBEBE
        view.text = "可上传9张图片，单张不大于10M，支持jpg、jpeg、png格式"
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(left_pending_space_17)
            make.top.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

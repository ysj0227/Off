//
//  OwnerShareServiceShowView.swift
//  OfficeGo
//
//  Created by Mac pro on 2020/10/13.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class OwnerShareServiceShowView: UIView {
    
    lazy var blackAlphabgView: UIButton = {
        let button = UIButton.init()
        button.backgroundColor = kAppClearColor
        button.addTarget(self, action: #selector(clickRemoveFromSuperview), for: .touchUpInside)
        return button
    }()
    
    var header: OwnerShareViewHeader = {
        let view = OwnerShareViewHeader()
        return view
    }()
    
    var footer: OwnerShareViewFooter = {
        let view = OwnerShareViewFooter()
        return view
    }()
    
    var featureCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: left_pending_space_17, bottom: 0, right: left_pending_space_17)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = kAppWhiteColor
        return view
    }()
    
    func reloadData() {
        featureCollectionView.reloadData()
    }
    
    @objc func clickRemoveFromSuperview() {
        guard let blockk = cancelBlock else {
            return
        }
        blockk()
        self.removeFromSuperview()
    }
    
    var itemSelectCallBack:((Int) -> Void)?
    
    ///取消，页面消失
    var cancelBlock:(() -> Void)?
    
    ///选中确定
    var sureSelectedBlock:((ShareServiceModel) -> Void)?

    var selectedIndex: Int = 0 {
        didSet {
            guard let blockk = itemSelectCallBack else {
                return
            }
            blockk(selectedIndex)
        }
    }
    
    var serviceDataModel: ShareServiceModel = ShareServiceModel() {
        didSet {
            reloadData()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpSubviews()
    }
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.frame = CGRect(x: 0.0, y: 0, width: kWidth, height: kHeight)
        
        setUpSubviews()
    }
    
    // MARK: - 弹出view显示
    // MARK: - 弹出view显示 - 筛选
    func ShowShareView(serviceModel: ShareServiceModel) {
        
        UIApplication.shared.keyWindow?.subviews.forEach({ (view) in
            if view.isKind(of: OwnerShareServiceShowView.self) {
                view.removeFromSuperview()
            }
        })
                
        serviceDataModel = serviceModel
        
        header.titleLabel.text = serviceModel.title
        
        UIApplication.shared.keyWindow?.addSubview(self)
    }
    
    func setUpSubviews() {
        
  //        初始化一个基于模糊效果的视觉效果视图
        let blur = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame = self.frame
        addSubview(blurView)
        
        addSubview(blackAlphabgView)
        addSubview(header)
        addSubview(footer)
        addSubview(featureCollectionView)
        
        header.closeButtonCallBack = { [weak self] in
            guard let blockk = self?.cancelBlock else {
                return
            }
            blockk()
            self?.removeFromSuperview()
        }
        
        footer.sureButtonCallBack = { [weak self] in
            guard let blockk = self?.sureSelectedBlock else {
                return
            }
            blockk(self?.serviceDataModel ?? ShareServiceModel())
            self?.removeFromSuperview()
        }
        
        blackAlphabgView.snp.makeConstraints { (make) in
            make.top.leading.bottom.trailing.equalToSuperview()
        }
       
        footer.snp.makeConstraints { (make) in
            make.leading.bottom.trailing.equalToSuperview()
            make.height.equalTo(80)
        }
        featureCollectionView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(cell_height_58 * 5)
            make.bottom.equalTo(footer.snp.top)
        }
        header.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(53)
            make.bottom.equalTo(featureCollectionView.snp.top)
        }
        featureCollectionView.register(RenterFeatureCollectionCell.self, forCellWithReuseIdentifier: RenterFeatureCollectionCell.reuseIdentifierStr)

        featureCollectionView.delegate = self
        featureCollectionView.dataSource = self
        
        reloadData()
    }
}

extension OwnerShareServiceShowView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RenterFeatureCollectionCell.reuseIdentifierStr, for: indexPath as IndexPath) as? RenterFeatureCollectionCell
        cell?.titleLabel.font = FONT_12

        cell?.itemImg.snp.updateConstraints { (make) in
            make.top.equalTo(9)
            make.leading.equalTo(3 + 16 + 8)
            make.size.equalTo(24)
        }
        if serviceDataModel.itemArr?[indexPath.row].isSelected == true {
            cell?.selectImg.image = UIImage.init(named: "circleSelected")
        }else {
            cell?.selectImg.image = UIImage.init(named: "circleUnSelected")
        }
        cell?.itemImg.setImage(with: serviceDataModel.itemArr?[indexPath.row].dictImgBlack ?? "", placeholder: UIImage.init(named: "shareservice"))
        cell?.titleLabel.text = serviceDataModel.itemArr?[indexPath.row].dictCname ?? ""
        return cell ?? RenterFeatureCollectionCell()
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    }
    //返回多少个cell
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return serviceDataModel.itemArr?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (kWidth - left_pending_space_17 - 10 - kWidth * 50 / 320.0) / 2.0, height: 46)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        serviceDataModel.itemArr?[indexPath.item].isSelected = !(serviceDataModel.itemArr?[indexPath.item].isSelected ?? false)
        featureCollectionView.reloadData()
    }
}
class OwnerShareViewHeader: UIView {
    
    //去掉block
    fileprivate var closeButtonCallBack:(() -> Void)?

    var titleLabel: UILabel = {
        let view = UILabel()
        view.font = FONT_16
        view.textColor = kAppColor_333333
        return view
    }()
    var closeBtn: UIButton = {
         let view = UIButton()
         view.setImage(UIImage.init(named: "closeGray"), for: .normal)
         view.addTarget(self, action: #selector(clickRemoveFromSuperview), for: .touchUpInside)
         return view
     }()
        
    @objc func clickRemoveFromSuperview() {
        guard let blockk = closeButtonCallBack else {
            return
        }
        blockk()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = kAppWhiteColor

        addSubview(titleLabel)
        addSubview(closeBtn)
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().inset(left_pending_space_17)
            make.top.bottom.equalToSuperview()
        }
        closeBtn.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview()
            make.width.equalTo(left_pending_space_17 * 3)
            make.top.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class OwnerShareViewFooter: UIView {
    
    //去掉block
    fileprivate var sureButtonCallBack:(() -> Void)?

    var closeBtn: UIButton = {
         let view = UIButton()
         view.backgroundColor = kAppBlueColor
         view.setTitle("确定", for: .normal)
         view.titleLabel?.font = FONT_MEDIUM_15
         view.addTarget(self, action: #selector(sureClick), for: .touchUpInside)
         return view
     }()
        
    @objc func sureClick() {
        guard let blockk = sureButtonCallBack else {
            return
        }
        blockk()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = kAppWhiteColor
        
        addSubview(closeBtn)
       
        closeBtn.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(left_pending_space_17)
            make.height.equalTo(40)
            make.top.equalToSuperview().offset(20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

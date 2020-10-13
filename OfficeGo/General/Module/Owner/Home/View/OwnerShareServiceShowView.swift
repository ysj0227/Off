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
    
    var featureCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = kAppWhiteColor
        return view
    }()
    
    func reloadData() {
        featureCollectionView.reloadData()
    }
    
    @objc func clickRemoveFromSuperview() {
        self.removeFromSuperview()
    }
    
    var itemSelectCallBack:((Int) -> Void)?
    
    var selectedIndex: Int = 0 {
        didSet {
            guard let blockk = itemSelectCallBack else {
                return
            }
            blockk(selectedIndex)
        }
    }
    var dataSourceArr: [DictionaryModel] = [] {
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
                
        if let item = serviceModel.itemArr {
            self.dataSourceArr = item
        }
        
        UIApplication.shared.keyWindow?.addSubview(self)
    }
    
    func setUpSubviews() {
        
  //        初始化一个基于模糊效果的视觉效果视图
        let blur = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame = self.frame
        addSubview(blurView)
        
        addSubview(blackAlphabgView)
        addSubview(featureCollectionView)
        
        blackAlphabgView.snp.makeConstraints { (make) in
            make.top.leading.bottom.trailing.equalToSuperview()
        }
       
        featureCollectionView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(53 + 80 + bottomMargin() + cell_height_58 * 5)
        }
        
        featureCollectionView.register(RenterFeatureCollectionCell.self, forCellWithReuseIdentifier: RenterFeatureCollectionCell.reuseIdentifierStr)
        
        featureCollectionView.register(OwnerShareViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "OwnerShareViewHeader")

        
        featureCollectionView.register(OwnerShareViewFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "OwnerShareViewFooter")

        featureCollectionView.delegate = self
        featureCollectionView.dataSource = self
        reloadData()
    }
}

extension OwnerShareServiceShowView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RenterFeatureCollectionCell.reuseIdentifierStr, for: indexPath as IndexPath) as? RenterFeatureCollectionCell
        cell?.model = HouseFeatureModel()
        cell?.titleLabel.textColor = kAppWhiteColor
        cell?.titleLabel.font = FONT_12
        cell?.numLabel.textColor = kAppWhiteColor
        cell?.numLabel.font = FONT_LIGHT_12
        cell?.itemImg.snp.updateConstraints { (make) in
            make.top.equalTo(9)
            make.leading.equalTo(5)
            make.size.equalTo(24)
        }
//        cell?.itemImg.setImage(with: dataSourceArr[indexPath.row].dictImg ?? "", placeholder: UIImage.init(named: ""))
//        cell?.titleLabel.text = dataSourceArr[indexPath.row].dictCname ?? ""
        cell?.itemImg.image = UIImage.init(named: "wechat")
        cell?.titleLabel.text = "124dgdg"
        return cell ?? RenterFeatureCollectionCell()
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    }
    //返回多少个cell
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (kWidth - left_pending_space_17 - 10 - kWidth * 50 / 320.0) / 2.0, height: cell_height_58)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "OwnerShareViewHeader", for: indexPath) as? OwnerShareViewHeader
            header?.titleLabel.text = "serviceModel.title"
            header?.closeButtonCallBack = { [weak self] in
                self?.removeFromSuperview()
            }
            return header ?? UICollectionReusableView()
        }else if kind == UICollectionView.elementKindSectionFooter {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "OwnerShareViewFooter", for: indexPath) as? OwnerShareViewFooter
            header?.sureButtonCallBack = { [weak self] in
                self?.removeFromSuperview()
            }
            return header ?? UICollectionReusableView()
        }
        
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: kWidth, height: 53)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: kWidth, height: 80 + bottomMargin())
    }
}
class OwnerShareViewHeader: UICollectionReusableView {
    
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

class OwnerShareViewFooter: UICollectionReusableView {
    
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

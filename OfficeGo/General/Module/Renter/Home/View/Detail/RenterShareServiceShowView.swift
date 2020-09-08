//
//  RenterShareServiceShowView.swift
//  OfficeGo
//
//  Created by mac on 2020/5/13.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class RenterShareServiceShowView: UIView {
    
    lazy var blackAlphabgView: UIButton = {
        let button = UIButton.init()
//        button.backgroundColor = UIColor.init(white: 0, alpha: 0.7)
        button.backgroundColor = kAppClearColor
        button.addTarget(self, action: #selector(clickRemoveFromSuperview), for: .touchUpInside)
        return button
    }()
    
    lazy var closeView: UIButton = {
        let button = UIButton.init()
        button.setImage(UIImage.init(named: "closeIcon"), for: .normal)
        button.addTarget(self, action: #selector(clickRemoveFromSuperview), for: .touchUpInside)
        return button
    }()
    
    var titleview: UILabel = {
        let view = UILabel()
        view.font = FONT_14
        view.textAlignment = .center
        view.textColor = kAppWhiteColor
        view.backgroundColor = kAppClearColor
        return view
    }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = kAppColor_line_EEEEEE
        return view
    }()
    
    var featureCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = kAppClearColor
        //        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(clickRemove(gesture:)))
        //        view.addGestureRecognizer(tapGesture)
        return view
    }()
    
    //   @objc func clickRemove(gesture:UITapGestureRecognizer) {
    //       clickRemoveFromSuperview()
    //   }
    
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
    func ShowHouseShaixuanView(serviceModel: ShareServiceModel) {
        
        UIApplication.shared.keyWindow?.subviews.forEach({ (view) in
            if view.isKind(of: RenterShareServiceShowView.self) {
                view.removeFromSuperview()
            }
        })
        
        self.titleview.text = serviceModel.title
        
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
        addSubview(titleview)
        addSubview(closeView)
        addSubview(featureCollectionView)
        addSubview(lineView)
        
        blackAlphabgView.snp.makeConstraints { (make) in
            make.top.leading.bottom.trailing.equalToSuperview()
        }
        
        titleview.snp.makeConstraints { (make) in
            make.top.equalTo(kStatusBarHeight)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        lineView.snp.makeConstraints { (make) in
            make.top.equalTo(titleview.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(left_pending_space_17)
            make.height.equalTo(1)
        }
        closeView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-(bottomMargin() + 16))
            make.centerX.equalToSuperview()
//            make.size.equalTo(33)
        }
        
//        featureCollectionView.frame = CGRect(x: left_pending_space_17, y: kNavigationHeight + 16, width: self.width - left_pending_space_17, height: self.height - kNavigationHeight - 16)
        featureCollectionView.snp.makeConstraints { (make) in
            make.leading.equalTo(left_pending_space_17)
            make.trailing.equalToSuperview()
            make.top.equalTo(titleview.snp.bottom).offset(16)
            make.bottom.equalTo(closeView.snp.top)
        }
        featureCollectionView.register(RenterFeatureCollectionCell.self, forCellWithReuseIdentifier: RenterFeatureCollectionCell.reuseIdentifierStr)
        featureCollectionView.delegate = self
        featureCollectionView.dataSource = self
        reloadData()
    }
}

extension RenterShareServiceShowView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
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
        cell?.itemImg.setImage(with: dataSourceArr[indexPath.row].dictImg ?? "", placeholder: UIImage.init(named: ""))
        cell?.titleLabel.text = dataSourceArr[indexPath.row].dictCname ?? ""
//        cell?.numLabel.text = "5-20人"
        if titleview.text == "特色服务" {
            cell?.numLabel.isHidden = false
        }else {
            cell?.numLabel.isHidden = true
        }
        return cell ?? RenterFeatureCollectionCell()
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    }
    //返回多少个cell
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSourceArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if titleview.text == "特色服务" {
            return CGSize(width: (kWidth - left_pending_space_17 - 10 - kWidth * 50 / 320.0) / 2.0, height: cell_height_58)
        }else {
            return CGSize(width: (kWidth - left_pending_space_17 - 10 - kWidth * 50 / 320.0) / 2.0, height: 46)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        clickRemoveFromSuperview()
    }
    
}

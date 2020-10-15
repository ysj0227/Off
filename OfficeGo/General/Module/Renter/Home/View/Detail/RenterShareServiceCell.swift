//
//  RenterShareServiceCell.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/5/11.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class RenterShareServiceCell: BaseTableViewCell {
    
    ///详情页面 - 弹框
    lazy var areaView: RenterShareServiceShowView = {
        let view = RenterShareServiceShowView.init(frame: CGRect(x: 0.0, y: 0, width: kWidth, height: kHeight))
        return view
    }()
    
    ///共享服务选择弹框
    lazy var shareView: OwnerShareServiceShowView = {
        let view = OwnerShareServiceShowView.init(frame: CGRect(x: 0.0, y: 0, width: kWidth, height: kHeight))
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = FONT_15
        view.textColor = kAppColor_333333
        return view
    }()
    
    lazy var featureCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: left_pending_space_17, bottom: 0, right: left_pending_space_17)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = kAppWhiteColor
        view.isScrollEnabled = false
        return view
    }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = kAppColor_line_EEEEEE
        return view
    }()
        
    var btype: Int?
    
    var buildingViewModel: FangYuanBuildingBuildingViewModel = FangYuanBuildingBuildingViewModel.init(model: FangYuanBuildingBuildingModel()) {
        didSet {
            if buildingViewModel.shareServices?.count ?? 0 > 0 {
                titleLabel.text = "共享服务"
            }else {
                titleLabel.text = ""
            }
            reloadData()
        }
    }
    
    var buildingModel: FangYuanBuildingEditDetailModel = FangYuanBuildingEditDetailModel() {
        didSet {
            titleLabel.text = "共享服务"
            reloadData()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(titleLabel)
        addSubview(featureCollectionView)
        addSubview(lineView)
        titleLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(left_pending_space_17)
            make.top.equalToSuperview().offset(15)
            make.height.equalTo(25)
        }
        featureCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.bottom.trailing.equalToSuperview()
        }
        lineView.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.leading.bottom.trailing.equalToSuperview()
        }
        featureCollectionView.register(RenterShareCollectionCell.self, forCellWithReuseIdentifier: RenterShareCollectionCell.reuseIdentifierStr)
        featureCollectionView.delegate = self
        featureCollectionView.dataSource = self
        featureCollectionView.register(RenterBuildingMsgHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "RenterBuildingMsgHeader")
    }
    
    func reloadData() {
        featureCollectionView.reloadData()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
extension RenterShareServiceCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        ///详情页面
        if let shareServices = buildingViewModel.shareServices {
            return shareServices.count
        }else {
            ///编辑添加页面
            return buildingModel.shareServices.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RenterShareCollectionCell.reuseIdentifierStr, for: indexPath) as? RenterShareCollectionCell
        
        ///详情页面
        if let serviceModel = buildingViewModel.shareServices?[indexPath.item] {
            cell?.serviceModel = serviceModel
        }else {
            ///编辑添加页面
            let serviceModel = buildingModel.shareServices[indexPath.item]
            cell?.serviceEditModel = serviceModel
        }
        
        return cell ?? RenterShareCollectionCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: kWidth, height: 20 + 18 + 18 + 26)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        ///详情页面
        if let serviceModel = buildingViewModel.shareServices?[indexPath.item] {
            areaView.ShowHouseShaixuanView(serviceModel: serviceModel)
        }else {
            ///编辑添加页面
            let serviceModel = buildingModel.shareServices[indexPath.item]
            shareView.ShowShareView(serviceModel: serviceModel)
            shareView.sureSelectedBlock = {[weak self] (servicemodel) in
                self?.buildingModel.shareServices[indexPath.item] = servicemodel
                self?.reloadData()
            }
            shareView.cancelBlock = {[weak self] in
                self?.reloadData()
            }
        }
    }
    
}

class RenterShareCollectionCell: BaseCollectionViewCell {
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = FONT_LIGHT_12
        view.textColor = kAppColor_666666
        return view
    }()
    lazy var itemButton: ShareItemBtnView = {
        var view = ShareItemBtnView.init(frame: CGRect(x: left_pending_space_17, y: 20 + 18 + 18, width: kWidth - left_pending_space_17 * 2, height: 26))
        return view
    }()
    lazy var detailIcon: BaseImageView = {
        var view = BaseImageView()
        view.image = UIImage.init(named: "ic_arrow_gray_right")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    ///详情页面
    var serviceModel: ShareServiceModel? {
        didSet {
            titleLabel.text = serviceModel?.title
            if let arr = serviceModel?.itemArr {
                itemButton.setUpFeatureSubviews(str: arr)
            }
        }
    }
        
    
    ///网点创建编辑页面
    var serviceEditModel: ShareServiceModel? {
        didSet {
            titleLabel.text = serviceEditModel?.title
            if let arr = serviceEditModel?.itemArr {
                itemButton.setUpEditFeatureSubviews(str: arr)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(itemButton)
        addSubview(detailIcon)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview().inset(left_pending_space_17)
            make.height.equalTo(18)
        }
        itemButton.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(18)
            make.leading.trailing.equalTo(titleLabel)
            make.height.equalTo(26)
        }
        itemButton.isUserInteractionEnabled = false
        detailIcon.snp.makeConstraints { (make) in
            make.centerY.equalTo(itemButton)
            make.trailing.equalToSuperview().inset(left_pending_space_17)
            make.width.equalTo(7)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ShareItemBtnView: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.frame = frame
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    //item之间间距
    let space: CGFloat = 20
    
    //每一项宽度添加的width
    var itemwidth: CGFloat = 20
    
    func setUpFeatureSubviews(str: [DictionaryModel]) {
        self.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        var width: CGFloat = 0.0
        for strs in str {
            if (width + (itemwidth + space)) > self.width {
                return
            }
            
            let btn = BaseImageView.init(frame: CGRect(x: width, y: 0, width: itemwidth, height: self.height))
            btn.contentMode = .scaleAspectFit
            btn.clipsToBounds = true
            btn.setImage(with: strs.dictImgBlack ?? "", placeholder: UIImage.init(named: ""))
            width =  width + (itemwidth + space)
            self.addSubview(btn)
        }
    }
    
    ///创建网点和编辑页面
    func setUpEditFeatureSubviews(str: [DictionaryModel]) {
        self.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        var width: CGFloat = 0.0
        for strs in str {
            if (width + (itemwidth + space)) > self.width {
                return
            }
            
            if strs.isSelected == true {
                let btn = BaseImageView.init(frame: CGRect(x: width, y: 0, width: itemwidth, height: self.height))
                btn.contentMode = .scaleAspectFit
                btn.clipsToBounds = true
                btn.setImage(with: strs.dictImgBlack ?? "", placeholder: UIImage.init(named: ""))
                width =  width + (itemwidth + space)
                self.addSubview(btn)
            }
        }
    }
    
}



//
//  OwnerBuildingNetworkSelectCell.swift
//  OfficeGo
//
//  Created by Mac pro on 2020/10/9.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class OwnerBuildingNetworkSelectCell: BaseTableViewCell {
    
    lazy var categoryTitleLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_14
        view.setContentCompressionResistancePriority(.required, for: .horizontal)
        view.textColor = kAppColor_333333
        return view
    }()
    
    lazy var featureCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
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
    
    ///标签
    var isMutTags: Bool?
    
    ///网络
    var isMutNetworks: Bool?
    
    ///装修类型
    var isSimpleDocument: Bool?
    
    //来自于房源
    var ISFY : Bool?
    
    //房源
    var FYModel: FangYuanHouseEditModel = FangYuanHouseEditModel() {
        didSet {
            reloadData()
        }
    }
    
    //楼盘
    var buildingModel: FangYuanBuildingEditModel = FangYuanBuildingEditModel() {
        didSet {
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

        self.backgroundColor = kAppWhiteColor
  
        addSubview(categoryTitleLabel)
        addSubview(featureCollectionView)
        addSubview(lineView)
        
        categoryTitleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(left_pending_space_17)
            make.trailing.equalTo(-left_pending_space_17)
            make.top.equalToSuperview()
            make.height.equalTo(59)
        }
        
        featureCollectionView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(categoryTitleLabel.snp.bottom)
            make.bottom.equalToSuperview()
        }
        
        lineView.snp.makeConstraints { (make) in
            make.leading.equalTo(left_pending_space_17)
            make.trailing.equalTo(-left_pending_space_17)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        
        featureCollectionView.register(HouseFeatureCollectionCell.self, forCellWithReuseIdentifier: HouseFeatureCollectionCell.reuseIdentifierStr)
        featureCollectionView.delegate = self
        featureCollectionView.dataSource = self
    }
    
    
    func reloadData() {
        featureCollectionView.reloadData()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}

extension OwnerBuildingNetworkSelectCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if ISFY == true {
            if isMutTags == true {
                return FYModel.houseMsg?.tagsLocal.count ?? 0
            }else if isSimpleDocument == true {
                return FYModel.houseMsg?.decoratesLocal.count ?? 0
            }else {
                return 0
            }
        }else {
            if isMutTags == true {
                return buildingModel.buildingMsg?.tagsLocal.count ?? 0
            }else if isMutNetworks == true {
                return buildingModel.buildingMsg?.internetLocal.count ?? 0
            }else if isSimpleDocument == true {
                return buildingModel.buildingMsg?.decoratesLocal.count ?? 0
            }else {
                return 0
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if ISFY == true {

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HouseFeatureCollectionCell.reuseIdentifierStr, for: indexPath) as? HouseFeatureCollectionCell
            
            if isMutTags == true {
                
                cell?.model = FYModel.houseMsg?.tagsLocal[indexPath.row]
                
                cell?.setButtonSelected(isSelected: cell?.model?.isDocumentSelected ?? false)
                
                return cell ?? HouseFeatureCollectionCell()
                
            }else if isSimpleDocument == true {

                cell?.model = FYModel.houseMsg?.decoratesLocal[indexPath.row]

                if FYModel.houseMsg?.decoration == FYModel.houseMsg?.decoratesLocal[indexPath.row].dictValue {
                    cell?.setButtonSelected(isSelected: true)
                }else {
                    cell?.setButtonSelected(isSelected: false)
                }
                
                
                return cell ?? HouseFeatureCollectionCell()
            }else {
                return HouseFeatureCollectionCell()
            }
        }else {

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HouseFeatureCollectionCell.reuseIdentifierStr, for: indexPath) as? HouseFeatureCollectionCell
            
            if isMutTags == true {
                
                cell?.model = buildingModel.buildingMsg?.tagsLocal[indexPath.row]
                
                cell?.setButtonSelected(isSelected: cell?.model?.isDocumentSelected ?? false)
                
                return cell ?? HouseFeatureCollectionCell()
                
            }else if isMutNetworks == true {

                cell?.model = buildingModel.buildingMsg?.internetLocal[indexPath.row]
                
                cell?.setButtonSelected(isSelected: cell?.model?.isOfficeBuildingSelected ?? false)
                
                return cell ?? HouseFeatureCollectionCell()
                
            }else if isSimpleDocument == true {

                cell?.model = buildingModel.buildingMsg?.decoratesLocal[indexPath.row]

                if buildingModel.buildingMsg?.decoration?.dictValue == buildingModel.buildingMsg?.decoratesLocal[indexPath.row].dictValue {
                    cell?.setButtonSelected(isSelected: true)
                }else {
                    cell?.setButtonSelected(isSelected: false)
                }
                
                
                return cell ?? HouseFeatureCollectionCell()
            }else {
                return HouseFeatureCollectionCell()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if ISFY == true {

            if isMutTags == true {
                if let tags = FYModel.houseMsg?.tagsLocal {

                    var num = 0
                    for model in tags {
                        if model.isDocumentSelected == true {
                            num += 1
                        }
                    }
                    if num >= 4 {
                        if FYModel.houseMsg?.tagsLocal[indexPath.item].isDocumentSelected != true {
                            AppUtilities.makeToast("最多可选择4个")
                        }else {
                            FYModel.houseMsg?.tagsLocal[indexPath.item].isDocumentSelected = !(FYModel.houseMsg?.tagsLocal[indexPath.item].isDocumentSelected ?? false)
                        }
                    }else {
                        tags[indexPath.item].isDocumentSelected = !(tags[indexPath.item].isDocumentSelected)
                    }
                }
                
            }else if isSimpleDocument == true {
                ///单选
                FYModel.houseMsg?.decoration = FYModel.houseMsg?.decoratesLocal[indexPath.item].dictValue
            }
        }else {

            if isMutTags == true {
                if let tags = buildingModel.buildingMsg?.tagsLocal {

                    var num = 0
                    for model in tags {
                        if model.isDocumentSelected == true {
                            num += 1
                        }
                    }
                    if num >= 4 {
                        if buildingModel.buildingMsg?.tagsLocal[indexPath.item].isDocumentSelected != true {
                            AppUtilities.makeToast("最多可选择4个")
                        }else {
                            buildingModel.buildingMsg?.tagsLocal[indexPath.item].isDocumentSelected = !(buildingModel.buildingMsg?.tagsLocal[indexPath.item].isDocumentSelected ?? false)
                        }
                    }else {
                        tags[indexPath.item].isDocumentSelected = !(tags[indexPath.item].isDocumentSelected)
                    }
                }
                
            }else if isMutNetworks == true {
                buildingModel.buildingMsg?.internetLocal[indexPath.item].isOfficeBuildingSelected = !(buildingModel.buildingMsg?.internetLocal[indexPath.item].isOfficeBuildingSelected ?? false)
            }else if isSimpleDocument == true {
                ///单选
                buildingModel.buildingMsg?.decoration = buildingModel.buildingMsg?.decoratesLocal[indexPath.item]
            }
        }
        
        self.featureCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (kWidth - left_pending_space_17 * 2 - 10 * 2) / 3, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
}
     

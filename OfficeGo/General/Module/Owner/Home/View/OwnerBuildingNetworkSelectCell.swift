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

    
    var buildingModel: FangYuanBuildingEditDetailModel = FangYuanBuildingEditDetailModel() {
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
        if isMutTags == true {
            return buildingModel.tagsLocal.count
        }else if isMutNetworks == true {
            return buildingModel.internetLocal.count
        }else if isSimpleDocument == true {
            return buildingModel.decoratesLocal.count
        }else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HouseFeatureCollectionCell.reuseIdentifierStr, for: indexPath) as? HouseFeatureCollectionCell
        
        if isMutTags == true {
            
            cell?.model = buildingModel.tagsLocal[indexPath.row]
            
            cell?.setButtonSelected(isSelected: cell?.model?.isDocumentSelected ?? false)
            
            return cell ?? HouseFeatureCollectionCell()
            
        }else if isMutNetworks == true {

            cell?.model = buildingModel.internetLocal[indexPath.row]
            
            cell?.setButtonSelected(isSelected: cell?.model?.isOfficeBuildingSelected ?? false)
            
            return cell ?? HouseFeatureCollectionCell()
            
        }else if isSimpleDocument == true {

            cell?.model = buildingModel.decoratesLocal[indexPath.row]

            if buildingModel.decorateModel?.dictValue == buildingModel.decoratesLocal[indexPath.row].dictValue {
                cell?.setButtonSelected(isSelected: true)
            }else {
                cell?.setButtonSelected(isSelected: false)
            }
            
            
            return cell ?? HouseFeatureCollectionCell()
        }else {
            return HouseFeatureCollectionCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isMutTags == true {
            var num = 0
            for model in buildingModel.tagsLocal {
                if model.isDocumentSelected == true {
                    num += 1
                }
            }
            if num >= 4 {
                if buildingModel.tagsLocal[indexPath.item].isDocumentSelected != true {
                    AppUtilities.makeToast("最多可选择4个")
                }else {
                    buildingModel.tagsLocal[indexPath.item].isDocumentSelected = !(buildingModel.tagsLocal[indexPath.item].isDocumentSelected)
                }
            }else {
                buildingModel.tagsLocal[indexPath.item].isDocumentSelected = !(buildingModel.tagsLocal[indexPath.item].isDocumentSelected)
            }
            
        }else if isMutNetworks == true {
            buildingModel.internetLocal[indexPath.item].isOfficeBuildingSelected = !(buildingModel.internetLocal[indexPath.item].isOfficeBuildingSelected)
        }else if isSimpleDocument == true {
            ///单选
            buildingModel.decorateModel = buildingModel.decoratesLocal[indexPath.item]
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
     

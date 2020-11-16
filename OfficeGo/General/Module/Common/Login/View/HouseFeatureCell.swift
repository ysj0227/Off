//
//  HouseFeatureCell.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/4/27.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class HouseFeatureCell: BaseTableViewCell {
    
    @IBOutlet weak var categoryTitleLabel: UILabel!
    
    @IBOutlet weak var featureCollectionView: UICollectionView!
    
    var isDocumentType: Bool?

    var selectModel: HouseSelectModel = HouseSelectModel() {
        didSet {
            reloadData()
        }
    }

    
    func rowHeight() -> CGFloat {
        return CGFloat((self.selectModel.shaixuanModel.featureModelArr.count / 3 + 1) * (60 + 10))
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
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
extension HouseFeatureCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isDocumentType == true {
            return selectModel.shaixuanModel.documentTypeModelArr.count
        }
        return selectModel.shaixuanModel.featureModelArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HouseFeatureCollectionCell.reuseIdentifierStr, for: indexPath) as? HouseFeatureCollectionCell
        
        if isDocumentType == true {
            cell?.model = selectModel.shaixuanModel.documentTypeModelArr[indexPath.row]
                    
            cell?.setButtonSelected(isSelected: selectModel.shaixuanModel.documentTypeModelArr[indexPath.row].isDocumentSelected)
            return cell ?? HouseFeatureCollectionCell()
        }else {
            cell?.model = selectModel.shaixuanModel.featureModelArr[indexPath.row]
                    
            if selectModel.typeModel.type != HouseTypeEnum.officeBuildingEnum {
                cell?.setButtonSelected(isSelected: selectModel.shaixuanModel.featureModelArr[indexPath.row].isOfficejointOfficeSelected)
            }else {
                cell?.setButtonSelected(isSelected: selectModel.shaixuanModel.featureModelArr[indexPath.row].isOfficeBuildingSelected)
            }
            return cell ?? HouseFeatureCollectionCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isDocumentType == true {
           selectModel.shaixuanModel.documentTypeModelArr[indexPath.item].isDocumentSelected = !(selectModel.shaixuanModel.documentTypeModelArr[indexPath.item].isDocumentSelected)

        }else {
            if selectModel.typeModel.type != HouseTypeEnum.officeBuildingEnum {
                selectModel.shaixuanModel.featureModelArr[indexPath.item].isOfficejointOfficeSelected = !(selectModel.shaixuanModel.featureModelArr[indexPath.item].isOfficejointOfficeSelected)

            }else {
                selectModel.shaixuanModel.featureModelArr[indexPath.item].isOfficeBuildingSelected = !(selectModel.shaixuanModel.featureModelArr[indexPath.item].isOfficeBuildingSelected)
            }
        }
        
        self.featureCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
          return CGSize(width: (kWidth - left_pending_space_17 * 2 - 10 * 2 - 5) / 3, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
}
 

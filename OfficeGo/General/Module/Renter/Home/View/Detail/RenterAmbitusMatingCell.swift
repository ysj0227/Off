//
//  RenterAmbitusMatingCell.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/5/11.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class RenterAmbitusMatingCell: BaseTableViewCell {
    
    @IBOutlet weak var collectionview: UICollectionView!
    var selectModel: HouseSelectModel = HouseSelectModel() {
        didSet {
            reloadData()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionview.register(RenterFeatureCollectionCell.self, forCellWithReuseIdentifier: RenterFeatureCollectionCell.reuseIdentifierStr)
        collectionview.delegate = self
        collectionview.dataSource = self
    }
    func reloadData() {
        collectionview.reloadData()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
extension RenterAmbitusMatingCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RenterFeatureCollectionCell.reuseIdentifierStr, for: indexPath) as? RenterFeatureCollectionCell
        cell?.model = HouseFeatureModel()
        return cell ?? HouseFeatureCollectionCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (kWidth - left_pending_space_17 * 2 - 10) / 2.0, height: 32 + 18)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
}


class RenterFeatureCollectionCell: BaseCollectionViewCell {
    
    lazy var selectImg: BaseImageView = {
        let view = BaseImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var itemImg: BaseImageView = {
        let view = BaseImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_13
        view.textColor = kAppColor_333333
        return view
    }()
    
    lazy var numLabel: UILabel = {
       let view = UILabel()
       view.textAlignment = .left
       view.font = FONT_LIGHT_13
       view.textColor = kAppColor_666666
       return view
   }()
    
    var model: HouseFeatureModel? {
        didSet {
            itemImg.setImage(with: "", placeholder: UIImage.init(named: Default_1x1))
            titleLabel.text = "11"
            numLabel.text = "4ge"
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(selectImg)
        self.contentView.addSubview(itemImg)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(numLabel)

        selectImg.snp.makeConstraints { (make) in
            make.size.equalTo(16)
            make.centerY.equalToSuperview()
            make.leading.equalTo(3)
        }
        
        itemImg.snp.makeConstraints { (make) in
            make.top.equalTo(9)
            make.leading.equalTo(3)
            make.size.equalTo(21)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(itemImg.snp.centerY)
            make.leading.equalTo(itemImg.snp.trailing).offset(10)
            make.height.greaterThanOrEqualTo(15)
        }
        numLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(titleLabel)
            make.height.greaterThanOrEqualTo(15)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

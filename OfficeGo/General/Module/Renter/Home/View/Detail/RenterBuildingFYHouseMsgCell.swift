//
//  RenterBuildingFYHouseMsgCell.swift
//  OfficeGo
//
//  Created by mac on 2020/9/7.
//  Copyright © 2020 Senwei. All rights reserved.
//

class RenterBuildingFYHouseMsgCell: BaseTableViewCell {
    
    lazy var featureCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
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
    
    var isDocumentType: Bool?
    
    var btype: Int?
    
    var basicViewModel: FangYuanBuildingFYDetailBasicInformationViewModel = FangYuanBuildingFYDetailBasicInformationViewModel.init(model: FangYuanBuildingFYDetailBasicInformationModel()) {
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
        addSubview(featureCollectionView)
        addSubview(lineView)
        featureCollectionView.snp.makeConstraints { (make) in
            make.top.leading.bottom.trailing.equalToSuperview()
        }
        lineView.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.leading.bottom.trailing.equalToSuperview()
        }
        featureCollectionView.register(OfficeBuildingmsgCollectionCell.self, forCellWithReuseIdentifier: OfficeBuildingmsgCollectionCell.reuseIdentifierStr)
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
extension RenterBuildingFYHouseMsgCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return basicViewModel.houseMsg?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OfficeBuildingmsgCollectionCell.reuseIdentifierStr, for: indexPath) as? OfficeBuildingmsgCollectionCell
        
        cell?.model = basicViewModel.houseMsg?[indexPath.item]
        return cell ?? OfficeBuildingmsgCollectionCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (kWidth - left_pending_space_17) / 2.0, height: 12 * 3 + 36)
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "RenterBuildingMsgHeader", for: indexPath) as? RenterBuildingMsgHeader
            if btype == 1 {
                header?.titleLabel.text = "房源信息"
            }else {
                header?.titleLabel.text = "房源信息"
            }
            
            return header ?? UICollectionReusableView()
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: kWidth, height: 50)
    }
}

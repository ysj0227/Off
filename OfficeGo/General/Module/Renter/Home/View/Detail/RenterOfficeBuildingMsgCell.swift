//
//  RenterOfficeBuildingMsgCell.swift
//  OfficeGo
//
//  Created by mac on 2020/9/7.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class RenterOfficeBuildingMsgCell: BaseTableViewCell {
    
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
    
    var buildingMsgViewModel: FangYuanBuildingIntroductionViewModel = FangYuanBuildingIntroductionViewModel.init(model: FangYuanBuildingIntroductionModel()) {
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
        featureCollectionView.register(RenterBuildingMsgFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "RenterBuildingMsgFooter")
    }
    
    func reloadData() {
        featureCollectionView.reloadData()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
extension RenterOfficeBuildingMsgCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return buildingMsgViewModel.buildingMsg?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OfficeBuildingmsgCollectionCell.reuseIdentifierStr, for: indexPath) as? OfficeBuildingmsgCollectionCell
        
        cell?.model = buildingMsgViewModel.buildingMsg?[indexPath.item]
        return cell ?? OfficeBuildingmsgCollectionCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (kWidth - left_pending_space_17) / 2.0, height: 12 * 3 + 36)
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "RenterBuildingMsgHeader", for: indexPath) as? RenterBuildingMsgHeader
            if btype == 1 {
                header?.titleLabel.text = "楼盘信息"
            }else {
                header?.titleLabel.text = "网点信息"
            }
            
            return header ?? UICollectionReusableView()
        }else {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "RenterBuildingMsgFooter", for: indexPath) as? RenterBuildingMsgFooter
            header?.nameLabel.text = buildingMsgViewModel.settlementLicenceName
            header?.nameValueLabel.text = buildingMsgViewModel.settlementLicence

            return header ?? UICollectionReusableView()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: kWidth, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: kWidth, height: buildingMsgViewModel.settlementLicenceHeight)
    }
}

class OfficeBuildingmsgCollectionCell: BaseCollectionViewCell {
    lazy var nameLabel: UILabel = {
        var view = UILabel()
        view.textColor = kAppColor_666666
        view.font = FONT_LIGHT_12
        return view
    }()
    lazy var nameValueLabel: UILabel = {
        var view = UILabel()
        view.textColor = kAppColor_333333
        view.numberOfLines = 2
        view.font = FONT_12
        view.adjustsFontSizeToFitWidth = true
        return view
    }()
    var model: FangYuanBuildingIntroductionMsgModel? {
        didSet {
            nameLabel.text = model?.name
            nameValueLabel.text = model?.value
            if model?.height ?? 0 > 20.0 {
                nameValueLabel.snp.remakeConstraints { (make) in
                    make.top.equalTo(nameLabel.snp.bottom).offset(5)
                    make.leading.equalTo(nameLabel)
                    make.trailing.equalToSuperview()
                    //            make.height.equalTo(20)
                }
            }else {
                nameValueLabel.snp.remakeConstraints { (make) in
                    make.top.equalTo(nameLabel.snp.bottom).offset(12)
                    make.leading.equalTo(nameLabel)
                    make.trailing.equalToSuperview()
                    //            make.height.equalTo(20)
                }
            }
        }
    }
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(nameLabel)
        addSubview(nameValueLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(12)
            make.leading.equalToSuperview().offset(left_pending_space_17)
            make.trailing.equalToSuperview()
        }
        nameValueLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(12)
            make.leading.equalTo(nameLabel)
            make.trailing.equalToSuperview()
//            make.height.equalTo(20)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class RenterBuildingMsgHeader: UICollectionReusableView {
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = FONT_15
        view.textColor = kAppColor_333333
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(left_pending_space_17)
            make.top.equalToSuperview().offset(15)
            make.height.equalTo(25)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
class RenterBuildingMsgFooter: UICollectionReusableView {
    
    lazy var nameLabel: UILabel = {
        var view = UILabel()
        view.textColor = kAppColor_666666
        view.font = FONT_LIGHT_12
        return view
    }()
    lazy var nameValueLabel: UILabel = {
        var view = UILabel()
        view.textColor = kAppColor_333333
        view.font = FONT_12
        view.numberOfLines = 0
        return view
    }()
    
    var model: FangYuanBuildingIntroductionViewModel? {
        didSet {
            nameLabel.text = "入职企业"
            nameValueLabel.text = model?.settlementLicence
        }
    }
        
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(nameLabel)
        addSubview(nameValueLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(12)
            make.leading.equalToSuperview().offset(left_pending_space_17)
            make.trailing.equalToSuperview()
        }
        nameValueLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(12)
            make.leading.equalTo(nameLabel)
            make.trailing.equalToSuperview().offset(-left_pending_space_17)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

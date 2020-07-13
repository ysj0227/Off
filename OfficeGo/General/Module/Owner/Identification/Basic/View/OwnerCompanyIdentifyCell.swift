//
//  OwnerCompanyIdentifyCell.swift
//  OfficeGo
//
//  Created by mac on 2020/7/13.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class OwnerCompanyIdentifyCell: BaseCollectionViewCell {
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_14
        view.textColor = kAppColor_333333
        return view
    }()
    lazy var numDescTF: UITextField = {
        let view = UITextField()
        view.textAlignment = .left
        view.font = FONT_14
        view.delegate = self
        view.textColor = kAppColor_333333
        return view
    }()
    lazy var detailIcon: BaseImageView = {
        let view = BaseImageView.init()
        view.contentMode = .scaleAspectFit
        view.image = UIImage.init(named: "moreDetail")
        return view
    }()
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = kAppColor_line_EEEEEE
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    class func rowHeight() -> CGFloat {
        return cell_height_58
    }
    
    var model: OwnerCompanyIedntifyConfigureModel = OwnerCompanyIedntifyConfigureModel(types: .OwnerCompanyIedntifyTypeIdentigy) {
        didSet {
            titleLabel.text = model.getNameFormType(type: model.type ?? .OwnerCompanyIedntifyTypeIdentigy)
            if model.type == .OwnerCompanyIedntifyTypeIdentigy || model.type == .OwnerCompanyIedntifyTypeBuildingFCType {
                numDescTF.isUserInteractionEnabled = false
                detailIcon.isHidden = false
                lineView.isHidden = false
            }else {
                numDescTF.isUserInteractionEnabled = true
                detailIcon.isHidden = true
                lineView.isHidden = false
                if model.type == .OwnerCompanyIedntifyTypeCompanyname {
                    lineView.isHidden = true
                }
            }
        }
    }
    
    func setupViews() {
        
        addSubview(titleLabel)
        addSubview(numDescTF)
        addSubview(detailIcon)
        addSubview(lineView)
        
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        detailIcon.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(10)
        }
        
        numDescTF.snp.makeConstraints { (make) in
            make.trailing.equalTo(detailIcon.snp.leading).offset(-9)
            make.centerY.equalToSuperview()
            make.leading.equalTo(titleLabel.snp.trailing)
        }
        lineView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
}

extension OwnerCompanyIdentifyCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
}

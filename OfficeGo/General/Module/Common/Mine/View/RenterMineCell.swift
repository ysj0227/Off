//
//  RenterMineCell.swift
//  OfficeGo
//
//  Created by mac on 2020/6/19.
//  Copyright © 2020 Senwei. All rights reserved.
//

class RenterMineCell: BaseTableViewCell {
    
    lazy var itemIcon: BaseImageView = {
        let view = BaseImageView.init()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_14
        view.textColor = kAppColor_333333
        return view
    }()
    
    lazy var numDescLabel: UILabel = {
        let view = UILabel()
        view.isHidden = true
        view.textAlignment = .right
        view.font = FONT_10
        view.textColor = kAppColor_666666
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
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    class func rowHeight() -> CGFloat {
        return 49
    }
    
    var renterModel: RenterMineConfigureModel = RenterMineConfigureModel(types: RenterMineType.RenterMineTypeAboutus) {
        didSet {
            itemIcon.image = UIImage.init(named: renterModel.getIconFormType(type: renterModel.type ?? RenterMineType.RenterMineTypeAboutus))
            titleLabel.text = renterModel.getNameFormType(type: renterModel.type ?? RenterMineType.RenterMineTypeAboutus)
            numDescLabel.text = "12"
        }
    }
    
    var userModel: LoginUserModel?
    
    var ownerModel: OwnerMineConfigureModel = OwnerMineConfigureModel(types: OwnerMineType.OwnerMineTypeAboutus) {
        didSet {
            itemIcon.image = UIImage.init(named: ownerModel.getIconFormType(type: ownerModel.type ?? OwnerMineType.OwnerMineTypeAboutus))
            titleLabel.text = ownerModel.getNameFormType(type: ownerModel.type ?? OwnerMineType.OwnerMineTypeAboutus)
            numDescLabel.text = "12"
            
            if ownerModel.type == OwnerMineType.OwnerMineTypeAuthority {
                if userModel?.authority == 0 {
                    itemIcon.image = UIImage.init(named: "")
                    titleLabel.text = ""
                }
            }
        }
    }
    
    func setupViews() {
        
        addSubview(itemIcon)
        addSubview(titleLabel)
        addSubview(numDescLabel)
        addSubview(detailIcon)
        addSubview(lineView)
        
        itemIcon.snp.makeConstraints { (make) in
            make.leading.equalTo(left_pending_space_17)
            make.centerY.equalToSuperview()
            make.size.equalTo(19)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(itemIcon.snp.trailing).offset(15)
            make.centerY.equalTo(itemIcon)
            make.trailing.equalTo(-100)
        }
        
        detailIcon.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-left_pending_space_17)
            make.centerY.equalTo(itemIcon)
            make.width.equalTo(10)
        }
        
        numDescLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(detailIcon.snp.leading).offset(9)
            make.centerY.equalTo(itemIcon)
            make.leading.equalTo(titleLabel.snp.trailing)
        }
        
        lineView.snp.makeConstraints { (make) in
            make.leading.equalTo(left_pending_space_17)
            make.trailing.equalTo(-left_pending_space_17)
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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}


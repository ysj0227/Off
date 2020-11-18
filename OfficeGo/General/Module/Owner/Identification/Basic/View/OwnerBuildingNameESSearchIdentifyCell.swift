//
//  OwnerBuildingNameESSearchIdentifyCell.swift
//  OfficeGo
//
//  Created by mac on 2020/7/14.
//  Copyright © 2020 Senwei. All rights reserved.
//

class OwnerBuildingNameESSearchIdentifyCell : BaseTableViewCell {
    
    
    ///房源管理 - 写字楼展示
    var isManagerBuilding: Bool? = false {
        didSet {
            if isManagerBuilding == true {
                addBtn.setTitle("关联楼盘", for: .normal)
            }
        }
    }
    
    ///房源管理 - 网点无数据展示
    var isManagerBranch: Bool? = false {
        didSet {
            if isManagerBranch == true {
                addBtn.setTitle("关联网点", for: .normal)
            }
        }
    }
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_LIGHT_13
        view.textColor = kAppColor_333333
        return view
    }()
    
    lazy var numDescLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_LIGHT_10
        view.textColor = kAppColor_666666
        return view
    }()
    lazy var addBtn: UIButton = {
        let view = UIButton()
        view.setTitleColor(kAppBlueColor, for: .normal)
        view.titleLabel?.font = FONT_12
        view.isUserInteractionEnabled = false
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
        return cell_height_58
    }
    var buildingModel: OwnerESBuildingSearchModel? {
        didSet {
            buildingViewModel = OwnerESBuildingSearchViewModel.init(model: buildingModel ?? OwnerESBuildingSearchModel())
        }
    }
    
    
    ///公司认证 楼盘
    ///个人认证 - 楼盘
    ///共享办公认证 - 楼盘
    var buildingViewModel: OwnerESBuildingSearchViewModel? {
        didSet {
            setShowView()
        }
    }
    
    func setShowView() {
        if buildingViewModel?.buildType == 1 {
            addBtn.setTitle("关联楼盘", for: .normal)
        }else {
            addBtn.setTitle("关联网点", for: .normal)
        }
        titleLabel.attributedText = buildingViewModel?.buildingAttributedName
        numDescLabel.attributedText = buildingViewModel?.addressString
    }
    var userModel: LoginUserModel?
    
    func setupViews() {

        self.backgroundColor = kAppWhiteColor
  
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(numDescLabel)
        self.contentView.addSubview(addBtn)
        self.contentView.addSubview(lineView)
        
        addBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(-left_pending_space_17)
            make.top.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(left_pending_space_17)
            make.top.equalTo(10)
            make.height.greaterThanOrEqualTo(20)
            make.trailing.equalTo(-(60 + left_pending_space_17))
        }
        numDescLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
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


//
//  OwnerBuildingNameESSearchIdentifyCell.swift
//  OfficeGo
//
//  Created by mac on 2020/7/14.
//  Copyright © 2020 Senwei. All rights reserved.
//

class OwnerBuildingNameESSearchIdentifyCell : BaseTableViewCell {
    
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
        view.setTitle("关联写字楼", for: .normal)
        view.setTitleColor(kAppBlueColor, for: .normal)
        view.titleLabel?.font = FONT_12
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
    var model: OwnerESBuildingSearchModel? {
        didSet {
            viewModel = OwnerESBuildingSearchViewModel.init(model: model ?? OwnerESBuildingSearchModel())
        }
    }
    var viewModel: OwnerESBuildingSearchViewModel? {
        didSet {
            ///身份类型0个人1企业2联合
            //展示楼盘名字 楼盘地址 关联按钮
            if UserTool.shared.user_owner_identifytype == 0 || UserTool.shared.user_owner_identifytype == 1 {
                numDescLabel.isHidden = false
                addBtn.isHidden = false
            }
            //只展示大楼名称
            else if UserTool.shared.user_owner_identifytype == 2 {
                numDescLabel.isHidden = true
                addBtn.isHidden = true
            }
            titleLabel.attributedText = viewModel?.buildingAttributedName
            numDescLabel.attributedText = viewModel?.addressString
        }
    }
    
    var userModel: LoginUserModel?
    
    func setupViews() {
        
        addSubview(titleLabel)
        addSubview(numDescLabel)
        addSubview(addBtn)
        addSubview(lineView)
        
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


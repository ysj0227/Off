//
//  OwnerCompanyESSearchIdentifyCell.swift
//  OfficeGo
//
//  Created by mac on 2020/7/14.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class OwnerCompanyESSearchIdentifyCell : BaseTableViewCell {
    
    lazy var itemIcon: BaseImageView = {
        let view = BaseImageView.init()
        view.image = UIImage.init(named: "companyIedntify")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
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
    var model: OwnerESCompanySearchModel? {
        didSet {
            viewModel = OwnerESCompanySearchViewModel.init(model: model ?? OwnerESCompanySearchModel())
        }
    }
    
    var isBranch: Bool? = false
    
    var viewModel: OwnerESCompanySearchViewModel? {
        didSet {
            ///身份类型0个人1企业2联合
            //没有公司
            if UserTool.shared.user_owner_identifytype == 0 {
                
            }
                //展示认证标签 公司名字 描述 加入按钮
            else if UserTool.shared.user_owner_identifytype == 1 {
                itemIcon.isHidden = false
                titleLabel.isHidden = false
                numDescLabel.isHidden = false
                addBtn.isHidden = false
                addBtn.setTitle("申请加入", for: .normal)
                numDescLabel.text = "加入公司，即可共同管理公司房源"
            }
                //只展示大楼名称
            else if UserTool.shared.user_owner_identifytype == 2 {
                //判断是否是网点
                //隐藏标签 展示网点名字 描述 加入按钮
                if isBranch == true {
                    itemIcon.isHidden = true
                    titleLabel.isHidden = false
                    numDescLabel.isHidden = false
                    addBtn.isHidden = false
                    addBtn.setTitle("申请加入", for: .normal)
                    numDescLabel.text = "加入网点，即可共同管理网点房源"
                }else {
                    //网点公司
                    //隐藏标签 描述  展示网点名字  加入按钮
                    itemIcon.isHidden = true
                    titleLabel.isHidden = false
                    
                    //认证过显示- 否则不展示 - 按钮和提示展示一个
//                    addBtn.isHidden = true
//                    numDescLabel.isHidden = false
//                    addBtn.setTitle("关联公司", for: .normal)
//                    numDescLabel.text = "该公司已认证为标准办公，不可重复认证"
                    
                    //没有认证过，展示按钮
                    addBtn.isHidden = false
                    numDescLabel.isHidden = true
                    addBtn.setTitle("关联公司", for: .normal)
                    numDescLabel.text = "该公司已认证为标准办公，不可重复认证"
                }
            }
            titleLabel.attributedText = viewModel?.companyString
        }
    }
    
    var userModel: LoginUserModel?
    
    func setupViews() {
        
        addSubview(itemIcon)
        addSubview(titleLabel)
        addSubview(numDescLabel)
        addSubview(addBtn)
        addSubview(lineView)
        
        itemIcon.snp.makeConstraints { (make) in
            make.leading.equalTo(left_pending_space_17)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 43, height: 20))
        }
        addBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(-left_pending_space_17)
            make.top.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(itemIcon.snp.trailing).offset(4)
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


//
//  OwnerFYListCell.swift
//  OfficeGo
//
//  Created by Mac pro on 2020/9/28.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class OwnerFYListCell: BaseTableViewCell {
    
    lazy var bgView : UIView = {
        let view = UIView()
        view.backgroundColor = kAppWhiteColor
        view.clipsToBounds = true
        view.layer.cornerRadius = button_cordious_8
        return view
    }()
    
    lazy var houseImageview: BaseImageView = {
        let view = BaseImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = button_cordious_2
        return view
    }()
    
    ///楼盘类型展示label
    lazy var houseTypTags: BaseImageView = {
        let view = BaseImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    lazy var houseNameLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_14
        view.numberOfLines = 1
        view.textColor = kAppColor_333333
        return view
    }()
    lazy var areaLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_12
        view.textColor = kAppColor_666666
        return view
    }()
    
    lazy var housePriceLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_MEDIUM_15
        view.textColor = kAppBlueColor
        return view
    }()
    lazy var housePriceUnitLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_12
        view.textColor = kAppColor_333333
        return view
    }()
    
    ///下架图片
    lazy var houseFailureview: BaseImageView = {
        let view = BaseImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
       
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = kAppColor_line_EEEEEE
        return view
    }()
    
    lazy var closePublishBtn: UIButton = {
        let view = UIButton.init()
        view.clipsToBounds = true
        view.layer.cornerRadius = button_cordious_12
        view.layer.borderColor = kAppColor_999999.cgColor
        view.layer.borderWidth = 0.5
        view.setTitle("   关闭   ", for: .normal)
        view.setTitleColor(kAppColor_333333, for: .normal)
        view.titleLabel?.font = FONT_12
        view.addTarget(self, action: #selector(closeBtnClick), for: .touchUpInside)
        return view
    }()
    
    lazy var sharehBtn: UIButton = {
        let view = UIButton.init()
        view.clipsToBounds = true
        view.layer.cornerRadius = button_cordious_12
        view.layer.borderColor = kAppColor_999999.cgColor
        view.layer.borderWidth = 0.5
        view.setTitle("   分享   ", for: .normal)
        view.setTitleColor(kAppColor_333333, for: .normal)
        view.titleLabel?.font = FONT_12
        view.addTarget(self, action: #selector(shareBtnClick), for: .touchUpInside)
        return view
    }()
    
    lazy var editBtn: UIButton = {
        let view = UIButton.init()
        view.clipsToBounds = true
        view.layer.cornerRadius = button_cordious_12
        view.layer.borderColor = kAppColor_999999.cgColor
        view.layer.borderWidth = 0.5
        view.setTitle("   编辑   ", for: .normal)
        view.setTitleColor(kAppColor_333333, for: .normal)
        view.titleLabel?.font = FONT_12
        view.addTarget(self, action: #selector(editBtnClick), for: .touchUpInside)
        return view
    }()
    
    
    lazy var moreBtn: UIButton = {
        let view = UIButton.init()
        view.clipsToBounds = true
        view.layer.cornerRadius = button_cordious_12
        view.layer.borderColor = kAppColor_999999.cgColor
        view.layer.borderWidth = 0.5
        view.setImage(UIImage.init(named: "ownerMore"), for: .normal)
        view.addTarget(self, action: #selector(moreBtnClick), for: .touchUpInside)
        return view
    }()
    
    var closeBtnClickBlock: (() -> Void)?
    
    @objc func closeBtnClick() {
        guard let blockk = closeBtnClickBlock else {
            return
        }
        blockk()
    }
    
    var shareBtnClickBlock: (() -> Void)?
    
    @objc func shareBtnClick() {
        if viewModel.isPublish != true {
            AppUtilities.makeToast("房源已下架，请先上架后再分享")
            return
        }
        guard let blockk = shareBtnClickBlock else {
            return
        }
        blockk()
    }
    
    var editBtnClickBlock: (() -> Void)?
    
    @objc func editBtnClick() {
        guard let blockk = editBtnClickBlock else {
            return
        }
        blockk()
    }
    var moreBtnClickBlock: (() -> Void)?
    
    @objc func moreBtnClick() {
        guard let blockk = moreBtnClickBlock else {
            return
        }
        blockk()
    }
    
    class func rowHeight() -> CGFloat {
        return 200
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
  
        self.backgroundColor = kAppColor_bgcolor_F7F7F7
        
        addSubview(bgView)
        addSubview(houseImageview)
        addSubview(houseNameLabel)
        addSubview(areaLabel)
        addSubview(housePriceLabel)
        addSubview(housePriceUnitLabel)
        addSubview(houseFailureview)
        addSubview(lineView)
        addSubview(houseTypTags)
        addSubview(moreBtn)
        addSubview(editBtn)
        addSubview(sharehBtn)
        addSubview(closePublishBtn)

        bgView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview().inset(7)
            make.leading.trailing.equalToSuperview().inset(left_pending_space_17)
        }
        
        houseImageview.snp.makeConstraints { (make) in
            make.leading.top.equalTo(bgView).offset(left_pending_space_17)
            make.size.equalTo(92)
        }
        
        houseTypTags.snp.makeConstraints { (make) in
            make.leading.top.equalTo(houseImageview)
            make.height.equalTo(22)
        }
        
        houseNameLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(houseImageview.snp.trailing).offset(13)
            make.trailing.equalTo(bgView).offset(-left_pending_space_17)
            make.top.equalTo(houseImageview).offset(-2)
            make.height.greaterThanOrEqualTo(31)
        }
        
        housePriceLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(houseNameLabel)
            make.bottom.equalTo(houseImageview.snp.bottom).offset(5)
        }
        
        housePriceUnitLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(housePriceLabel.snp.trailing).offset(1)
            make.centerY.equalTo(housePriceLabel)
        }
        
        areaLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(houseNameLabel)
            make.centerY.equalTo(houseImageview).offset(5)
        }
        
        houseFailureview.snp.makeConstraints { (make) in
            make.trailing.equalTo(houseNameLabel)
            make.bottom.equalTo(houseImageview.snp.bottom)
            make.size.equalTo(56)
        }
        
        lineView.snp.makeConstraints { (make) in
            make.leading.equalTo(houseImageview)
            make.trailing.equalTo(houseNameLabel)
            make.top.equalTo(houseImageview.snp.bottom).offset(left_pending_space_17)
            make.height.equalTo(1)
        }
        
        moreBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(houseNameLabel)
            make.top.equalTo(lineView.snp.bottom).offset(15)
            make.width.height.equalTo(24)
        }
        
        editBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(moreBtn.snp.leading).offset(-10)
            make.top.height.equalTo(moreBtn)
        }
        
        sharehBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(editBtn.snp.leading).offset(-10)
            make.top.height.equalTo(moreBtn)
        }
        
        closePublishBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(sharehBtn.snp.leading).offset(-10)
            make.top.height.equalTo(moreBtn)
        }
        
    }
    var model: OwnerFYListModel = OwnerFYListModel() {
        didSet {
            viewModel = OwnerFYListViewModel.init(model: model)
        }
    }
    
    var viewModel: OwnerFYListViewModel = OwnerFYListViewModel(model: OwnerFYListModel()) {
        didSet {
            setCellWithViewModel(viewModel: viewModel)
        }
    }
    
    ///列表页面
    func setCellWithViewModel(viewModel: OwnerFYListViewModel) {
        
        ///房源标签
        houseTypTags.image = UIImage.init(named: viewModel.houseTypTags ?? "")

        ///发布下架按钮标题
        closePublishBtn.setTitle(viewModel.closePublishBtnTitle, for: .normal)
        
        ///上架下架按钮隐藏
        closePublishBtn.isHidden = viewModel.closePublishBtnHidden ?? false
        
        ///下架icon
        houseFailureview.image = UIImage.init(named: viewModel.houseFailureImg ?? "")

        ///1是写字楼，2是共享办公
        if viewModel.btype == 1 {
            areaLabel.text = viewModel.buildingArea
            housePriceLabel.text = viewModel.buildingDayPriceString
            
        }else if viewModel.btype == 2 {
                        
            ///独立办公室
            if viewModel.officeType == 1 {

                areaLabel.text = viewModel.individualAreaString
                housePriceLabel.text = viewModel.individualDayPriceString
                
            }else {

                areaLabel.text = viewModel.openSeatsString
                housePriceLabel.text = viewModel.openMonthPriceString
                
            }
        }
        houseImageview.setImage(with: viewModel.mainPic ?? "", placeholder: UIImage(named: Default_1x1))
        houseNameLabel.text = "\(viewModel.houseName ?? "")"
        
//        sharehBtn.isUserInteractionEnabled = viewModel.isPublish ?? true
    }
    
}

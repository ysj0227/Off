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
    lazy var houseTypTags: UILabel = {
        let view = UILabel()
        view.font = FONT_10
        view.textColor = kAppWhiteColor
        view.backgroundColor = kAppBlueColor
        view.clipsToBounds = true
        view.layer.cornerRadius = button_cordious_2
        view.isHidden = true
        return view
    }()
    
    lazy var houseNameLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_14
        view.numberOfLines = 2
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
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = kAppColor_line_EEEEEE
        return view
    }()
    
    lazy var closeBtn: UIButton = {
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
    
    lazy var publishBtn: UIButton = {
        let view = UIButton.init()
        view.clipsToBounds = true
        view.layer.cornerRadius = button_cordious_12
        view.layer.borderColor = kAppColor_999999.cgColor
        view.layer.borderWidth = 0.5
        view.setTitle("   上架   ", for: .normal)
        view.setTitleColor(kAppColor_333333, for: .normal)
        view.titleLabel?.font = FONT_12
        view.addTarget(self, action: #selector(publishBtnClick), for: .touchUpInside)
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
//        view.setTitle("…", for: .normal)
//        view.setTitleColor(kAppColor_333333, for: .normal)
//        view.titleLabel?.font = FONT_MEDIUM_12
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
    
    var publishBtnClickBlock: (() -> Void)?
    
    @objc func publishBtnClick() {
        guard let blockk = publishBtnClickBlock else {
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
        
        self.backgroundColor = kAppColor_bgcolor_F7F7F7
        
        addSubview(bgView)
        addSubview(houseImageview)
        addSubview(houseNameLabel)
        addSubview(areaLabel)
        addSubview(housePriceLabel)
        addSubview(housePriceUnitLabel)
        addSubview(lineView)
        addSubview(houseTypTags)
        addSubview(moreBtn)
        addSubview(editBtn)
        addSubview(publishBtn)
        addSubview(closeBtn)

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
            make.height.equalTo(17)
        }
        
        houseNameLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(houseImageview.snp.trailing).offset(13)
            make.trailing.equalTo(bgView).offset(-left_pending_space_17)
            make.top.equalTo(houseImageview).offset(-2)
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
            make.bottom.equalTo(housePriceLabel.snp.top).offset(-5)
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
        
        publishBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(editBtn.snp.leading).offset(-10)
            make.top.height.equalTo(moreBtn)
        }
        
        closeBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(publishBtn.snp.leading).offset(-10)
            make.top.height.equalTo(moreBtn)
        }
        
    }
    var model: FangYuanListModel = FangYuanListModel() {
        didSet {
            viewModel = FangYuanListViewModel.init(model: model)
        }
    }
    
    var viewModel: FangYuanListViewModel = FangYuanListViewModel(model: FangYuanListModel()) {
        didSet {
            setCellWithViewModel(viewModel: viewModel)
        }
    }
    
    ///列表页面
    func setCellWithViewModel(viewModel: FangYuanListViewModel) {
        
                
        houseTypTags.isHidden = false
        ///1是写字楼，2是共享办公
        if viewModel.btype == 1 {
            houseTypTags.text = ""
        }else if viewModel.btype == 2 {
            houseTypTags.text = "  共享办公  "
        }
        houseImageview.setImage(with: viewModel.mainPicImgString ?? "", placeholder: UIImage(named: Default_1x1))
        houseNameLabel.text = "\(viewModel.buildingName ?? "")" + "\(viewModel.buildingName ?? "")" + "\(viewModel.buildingName ?? "")"
        
        areaLabel.text = "400m²"
        housePriceLabel.text = viewModel.dayPriceString
        housePriceUnitLabel.text = viewModel.unitString

    }
    
    //聊天预约看房页面
    var messageViewModel: MessageFYViewModel = MessageFYViewModel(model: MessageFYModel()) {
        didSet {
            setCellWithMessageViewModel(viewModel: messageViewModel)
        }
    }
    
    ///预约看房页面
    func setCellWithMessageViewModel(viewModel: MessageFYViewModel) {
        houseImageview.setImage(with: viewModel.mainPic ?? "", placeholder: UIImage.init(named: Default_1x1))
        houseNameLabel.text = viewModel.buildingName
        
        housePriceLabel.text = viewModel.dayPriceNoUnitString
        housePriceUnitLabel.text = viewModel.unitString
    }
    
}

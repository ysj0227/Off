//
//  OwnerCompanyIdentifyCell.swift
//  OfficeGo
//
//  Created by mac on 2020/7/13.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

typealias IdentifyEditingClickClouse = (String)->()


class OwnerCreateBuildTypeSelectCell: BaseTableViewCell {
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.setContentCompressionResistancePriority(.required, for: .horizontal)
        view.font = FONT_14
        view.textColor = kAppColor_999999
        return view
    }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = kAppColor_line_EEEEEE
        return view
    }()
    lazy var buildingBtn: UIButton = {
        let btn = UIButton.init()
        btn.setImage(UIImage.init(named: "radioBtn_gray"), for: .normal)
        btn.setImage(UIImage.init(named: "radioBtn_blue"), for: .selected)
        btn.setTitleColor(kAppColor_999999, for: .normal)
        btn.setTitleColor(kAppColor_333333, for: .selected)
        btn.setTitle(" 楼盘/园区", for: .normal)
        btn.titleLabel?.font = FONT_14
        btn.addTarget(self, action: #selector(buildingClick), for: .touchUpInside)
        return btn
    }()
    lazy var jointBtn: UIButton = {
        let btn = UIButton.init()
        btn.setImage(UIImage.init(named: "radioBtn_gray"), for: .normal)
        btn.setImage(UIImage.init(named: "radioBtn_blue"), for: .selected)
        btn.setTitleColor(kAppColor_999999, for: .normal)
        btn.setTitleColor(kAppColor_333333, for: .selected)
        btn.setTitle(" 共享办公", for: .normal)
        btn.titleLabel?.font = FONT_14
        btn.addTarget(self, action: #selector(jointClick), for: .touchUpInside)
        return btn
    }()
    
    //按钮点击方法
    var editClickBack:((OwnerCompanyIedntifyType) -> Void)?
    
    @objc func buildingClick() {
        userModel?.btype = "1"
        buildingBtn.isSelected = true
        jointBtn.isSelected = false
    }
        
    @objc func jointClick() {
        userModel?.btype = "2"
        buildingBtn.isSelected = false
        jointBtn.isSelected = true
    }
    
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
    //公司名字
    @objc var companyNameClickClouse: IdentifyEditingClickClouse?
    
    //大楼名称
    @objc var buildingNameClickClouse: IdentifyEditingClickClouse?
    
    //写字楼地址
    var buildingAddresEndEditingMessageCell:((String) -> Void)?
    
    //写字楼名称址
    var buildingNameEndEditingMessageCell:((String) -> Void)?
    
    //模拟认证模型
    var userModel: OwnerIdentifyUserModel?
    
    var model: OwnerCreatBuildingConfigureModel = OwnerCreatBuildingConfigureModel(types: OwnerCreteBuildingType.OwnerCreteBuildingTypeBuildOrJint) {
        didSet {
            
            titleLabel.attributedText = model.getNameFormType(type: model.type ?? OwnerCreteBuildingType.OwnerCreteBuildingTypeBuildOrJint)
            
            if userModel?.btype == "1" {
                buildingBtn.isSelected = true
                jointBtn.isSelected = false
            }else if userModel?.btype == "2" {
                buildingBtn.isSelected = false
                jointBtn.isSelected = true
            }else {
                buildingBtn.isSelected = false
                jointBtn.isSelected = false
            }
        }
    }
    func setupViews() {
        
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(lineView)
        self.contentView.addSubview(buildingBtn)
        self.contentView.addSubview(jointBtn)
        
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(left_pending_space_17)
            make.centerY.equalToSuperview()
        }
        
        buildingBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(titleLabel.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
            make.height.equalTo(25)
        }
        jointBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(buildingBtn.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
            make.height.equalTo(25)
        }
        lineView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(left_pending_space_17)
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

class OwnerCompanyIdentifyCell: BaseCollectionViewCell {
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.setContentCompressionResistancePriority(.required, for: .horizontal)
        view.font = FONT_14
        view.textColor = kAppColor_999999
        return view
    }()
    lazy var numDescTF: UITextField = {
        let view = UITextField()
        view.textAlignment = .left
        view.font = FONT_14
        view.textColor = kAppColor_333333
//        view.clearButtonMode = .whileEditing
        return view
    }()
    lazy var addressLabel: UILabel = {
        let view = UILabel()
        view.isHidden = true
        view.textAlignment = .left
        view.font = FONT_11
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
    lazy var editBtn: UIButton = {
        let btn = UIButton.init()
        btn.setImage(UIImage.init(named: "idenEdit"), for: .normal)
        btn.titleLabel?.font = FONT_8
        btn.addTarget(self, action: #selector(editClick), for: .touchUpInside)
        return btn
    }()
    lazy var closeBtn: UIButton = {
        let btn = UIButton.init()
        btn.setImage(UIImage.init(named: "idenDelete"), for: .normal)
        btn.titleLabel?.font = FONT_8
        btn.addTarget(self, action: #selector(closeClick), for: .touchUpInside)
        return btn
    }()
    
    //按钮点击方法
    var editClickBack:((OwnerCompanyIedntifyType) -> Void)?
    
    @objc func editClick() {
        guard let blockk = editClickBack else {
            return
        }
//        blockk(model.type ?? OwnerCompanyIedntifyType.OwnerCompanyIedntifyTypeIdentigy)
    }
    
    var closeClickBack:((OwnerCompanyIedntifyType) -> Void)?
    
    @objc func closeClick() {
        editBtn.isHidden = true
        numDescTF.text = ""
        numDescTF.isUserInteractionEnabled = true
        numDescTF.becomeFirstResponder()
        addressLabel.text = ""
        guard let blockk = self.closeClickBack else {
            return
        }
//        blockk(model.type ?? OwnerCompanyIedntifyType.OwnerCompanyIedntifyTypeIdentigy)
    }
    
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
    //公司名字
    @objc var companyNameClickClouse: IdentifyEditingClickClouse?
    
    //大楼名称
    @objc var buildingNameClickClouse: IdentifyEditingClickClouse?
    
    //写字楼地址
    var buildingAddresEndEditingMessageCell:((String) -> Void)?
    
    //写字楼名称址
    var buildingNameEndEditingMessageCell:((String) -> Void)?
    
    //模拟认证模型
    var userModel: OwnerIdentifyUserModel?
        
    func setupViews() {
        
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(numDescTF)
        self.contentView.addSubview(detailIcon)
        self.contentView.addSubview(lineView)
        self.contentView.addSubview(addressLabel)
        self.contentView.addSubview(editBtn)
        self.contentView.addSubview(closeBtn)
        
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
            make.trailing.equalTo(detailIcon.snp.leading).offset(-59)
            make.centerY.equalToSuperview()
            make.leading.equalTo(titleLabel.snp.trailing)
        }
        addressLabel.snp.makeConstraints { (make) in
            make.top.equalTo(numDescTF.snp.bottom)
            make.leading.equalTo(numDescTF)
        }
        closeBtn.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview()
            make.width.equalTo(25)
            make.centerY.equalToSuperview()
            make.height.equalTo(25)
        }
        editBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(closeBtn.snp.leading).offset(-3)
            make.width.equalTo(25)
            make.centerY.equalToSuperview()
            make.height.equalTo(25)
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

class OwnerCreateView: UIView {
    
    lazy var descLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_LIGHT_13
        view.text = ""
        view.textColor = kAppColor_999999
        return view
    }()
    
    lazy var creatBtn: UIButton = {
        let view = UIButton()
        view.setTitleColor(kAppBlueColor, for: .normal)
        view.setTitle("", for: .normal)
        view.titleLabel?.font = FONT_12
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    ///来自新认证 - 楼盘网点搜索
    var isNewIdentifyES: Bool? = false {
        didSet {
            descLabel.text = "楼盘/网点不存在，立即创建"
            creatBtn.setTitle("立即创建", for: .normal)
        }
    }
        
    ///房源管理 - 写字楼展示
    var isManagerBuilding: Bool? = false {
        didSet {

            descLabel.text = "楼盘不存在，去创建楼盘"
            creatBtn.setTitle("创建楼盘", for: .normal)
        }
    }
    
    ///房源管理 - 网点无数据展示
    var isManagerBranch: Bool? = false {
        didSet {

            descLabel.text = "网点不存在，去创建网点"
            creatBtn.setTitle("创建网点", for: .normal)
        }
    }
    
    
    ///创建回调
    var creatButtonCallClick:(() -> Void)?
    
    private func setupView() {
        
        self.backgroundColor = kAppWhiteColor
        
        
        addSubview(descLabel)
        addSubview(creatBtn)
        creatBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(-left_pending_space_17)
            make.top.bottom.equalToSuperview()
        }
        
        descLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(left_pending_space_17)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(-(60 + left_pending_space_17))
        }
        
        creatBtn.addTarget(self, action: #selector(creatBtnClick), for: .touchUpInside)
    }
    
    @objc func creatBtnClick() {
        guard let blockk = creatButtonCallClick else {
            return
        }
        blockk()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

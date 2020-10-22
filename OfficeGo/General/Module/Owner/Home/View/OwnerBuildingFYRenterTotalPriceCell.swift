//
//  OwnerBuildingFYRenterTotalPriceCell.swift
//  OfficeGo
//
//  Created by Mac pro on 2020/10/19.
//  Copyright © 2020 Senwei. All rights reserved.
//

class OwnerBuildingFYRenterTotalPriceCell: BaseTableViewCell {
    
    var alertBtnClickClouse:(() -> Void)?
    
    ///点击输入框
    var inputClickClouse:(() -> Void)?
    
    var buildingModel: FangYuanBuildingEditDetailModel?
    
    var endEditingMessageCell:((FangYuanBuildingEditDetailModel) -> Void)?
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_14
        view.setContentCompressionResistancePriority(.required, for: .horizontal)
        view.textColor = kAppColor_333333
        return view
    }()
    
    lazy var editLabel: UITextField = {
        let view = UITextField()
        view.textAlignment = .left
        view.keyboardType = .decimalPad
        view.font = FONT_14
        view.textColor = kAppColor_333333
        return view
    }()
    
    
    lazy var detailIcon: UIButton = {
        let view = UIButton()
        view.setImage(UIImage.init(named: "alertImg"), for: .normal)
        return view
    }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = kAppColor_line_EEEEEE
        return view
    }()
    
    
    var officeModel: OwnerBuildingOfficeConfigureModel = OwnerBuildingOfficeConfigureModel(types: OwnerBuildingOfficeType.OwnerBuildingOfficeTypeTotalPrice) {
        didSet {
            
            titleLabel.attributedText = officeModel.getNameFormType(type: OwnerBuildingOfficeType.OwnerBuildingOfficeTypeTotalPrice)
            
            editLabel.text = buildingModel?.totalPrice
            
        }
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
    
    func setupViews() {
        
        self.backgroundColor = kAppWhiteColor
        
        addSubview(titleLabel)
        addSubview(editLabel)
        addSubview(detailIcon)
        addSubview(lineView)
        
        editLabel.delegate = self
        
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(left_pending_space_17)
            make.top.bottom.equalToSuperview()
        }
        
        editLabel.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-50)
            make.leading.equalTo(titleLabel.snp.trailing)
            make.top.bottom.equalToSuperview()
        }
        
        detailIcon.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 47, height: 40))
        }
        
        detailIcon.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: left_pending_space_17)
        
        lineView.snp.makeConstraints { (make) in
            make.leading.equalTo(left_pending_space_17)
            make.trailing.equalTo(-left_pending_space_17)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        
        detailIcon.addTarget(self, action: #selector(clickAlertBtn), for: .touchUpInside)
    }
    
    /// ?按钮
    @objc func clickAlertBtn() {
        
        guard let blockk = self.alertBtnClickClouse else {
            return
        }
        blockk()
        
    }
}
extension OwnerBuildingFYRenterTotalPriceCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        buildingModel?.totalPrice = textField.text
        
        buildingModel?.totalPriceTemp = textField.text
        
        guard let blockk = self.endEditingMessageCell else {
            return
        }
        blockk(buildingModel ?? FangYuanBuildingEditDetailModel())
        
//        if buildingModel?.totalPrice != textField.text {
//
//        }
        
        
        
    }
    
    ///开始编辑 - 弹框
    func textFieldDidBeginEditing(_ textField: UITextField) {
        SSLog("开始编辑 - ------")
        
        guard let blockk = self.inputClickClouse else {
            return
        }
        blockk()
    }
}

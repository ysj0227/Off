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
        
    var FYModel: FangYuanHouseEditModel?
    
    ///房源
    var endEditingFYMessageCell:((FangYuanHouseEditModel) -> Void)?
    
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
    
    ///右边单位
    lazy var unitLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_14
        view.setContentCompressionResistancePriority(.required, for: .horizontal)
        view.textColor = kAppColor_btnGray_BEBEBE
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
            unitLabel.text = officeModel.getPalaceHolderFormType(type: OwnerBuildingOfficeType.OwnerBuildingOfficeTypeTotalPrice)
            
            editLabel.text = FYModel?.houseMsg?.monthPrice
            
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
        
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(editLabel)
        self.contentView.addSubview(detailIcon)
        self.contentView.addSubview(unitLabel)
        self.contentView.addSubview(lineView)
        
        editLabel.delegate = self
        
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(left_pending_space_17)
            make.top.bottom.equalToSuperview()
        }
        
        editLabel.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-100)
            make.leading.equalTo(titleLabel.snp.trailing)
            make.top.bottom.equalToSuperview()
        }
        
        detailIcon.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.width.equalTo(47)
        }
        
        unitLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(detailIcon.snp.leading)
            make.top.bottom.equalToSuperview()
        }
        
        
        detailIcon.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: left_pending_space_17)
        
        lineView.snp.makeConstraints { (make) in
            make.leading.equalTo(left_pending_space_17)
            make.trailing.equalTo(-left_pending_space_17)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        
        detailIcon.addTarget(self, action: #selector(clickAlertBtn), for: .touchUpInside)

        editLabel.addTarget(self, action: #selector(valueDidChange), for: .editingChanged)

    }
    
    
    @objc func valueDidChange() {
        let textNum = editLabel.text?.count
        ///租金总价 - 9位数
        //截取
         if textNum! > 9 {
             let index = editLabel.text?.index((editLabel.text?.startIndex)!, offsetBy: 9)
             editLabel.text = editLabel.text?.substring(to: index!)
         }
         if let num = Int(editLabel.text ?? "0") {
             if num > 150000000 {
                 editLabel.text?.removeLast(1)
                 AppUtilities.makeToast("仅支持1-150000000正整数")
             }
         }
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
        
        if FYModel?.houseMsg?.monthTotalClick == false {
            
            FYModel?.houseMsg?.monthPrice = textField.text
            
            FYModel?.houseMsg?.monthPriceTemp = textField.text
            
            guard let blockk = self.endEditingFYMessageCell else {
                return
            }
            blockk(FYModel ?? FangYuanHouseEditModel())
        }
        FYModel?.houseMsg?.monthTotalClick = false
    }
    
    ///开始编辑 - 弹框
    func textFieldDidBeginEditing(_ textField: UITextField) {
        SSLog("开始编辑 - ------")
        
        FYModel?.houseMsg?.monthTotalClick = false
        guard let blockk = self.inputClickClouse else {
            return
        }
        blockk()
    }
}

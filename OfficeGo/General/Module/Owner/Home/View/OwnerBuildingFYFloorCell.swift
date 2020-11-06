//
//  OwnerBuildingFYFloorCell.swift
//  OfficeGo
//
//  Created by Mac pro on 2020/10/19.
//  Copyright © 2020 Senwei. All rights reserved.
//

class OwnerBuildingFYFloorCell: BaseTableViewCell {
    
    var FYModel: FangYuanHouseEditModel?

    ///房源
    var endEditingFYMessageCell:((FangYuanHouseEditModel) -> Void)?
    
    ///办公室
    var officeModel: OwnerBuildingOfficeConfigureModel = OwnerBuildingOfficeConfigureModel(types: OwnerBuildingOfficeType.OwnerBuildingOfficeTypeBuildingImage) {
        didSet {
            
            leftEditLabel.text = FYModel?.houseMsg?.floor
            rightUnitLabel.text = "总\(FYModel?.totalFloor ?? "0")层"
            if FYModel?.houseMsg?.floorType == "1" || FYModel?.houseMsg?.floorType == "2" {
                self.isHidden = false
            }else {
                self.isHidden = true
            }
        }
    }
    
    ///独立办公室
     var jointIndepentOfficeModel: OwnerBuildingJointOfficeConfigureModel = OwnerBuildingJointOfficeConfigureModel(types: OwnerBuildingJointOfficeType.OwnerBuildingJointOfficeTypeBuildingImage) {
         didSet {
            
            leftEditLabel.text = FYModel?.houseMsg?.floor
            rightUnitLabel.text = "总\(FYModel?.totalFloor ?? "0")层"
             if FYModel?.houseMsg?.floorType == "1" || FYModel?.houseMsg?.floorType == "2" {
                 self.isHidden = false
             }else {
                 self.isHidden = true
             }
         }
     }
    
    ///开放工位
    var jointOpenStationModel: OwnerBuildingJointOpenStationConfigureModel = OwnerBuildingJointOpenStationConfigureModel(types: OwnerBuildingJointOpenStationType.OwnerBuildingJointOpenStationTypeBuildingImage) {
        didSet {
            
            leftEditLabel.text = FYModel?.houseMsg?.floor

            if FYModel?.houseMsg?.floorType == "1" || FYModel?.houseMsg?.floorType == "2" {
                self.isHidden = false
            }else {
                self.isHidden = true
            }
        }
    }
    lazy var leftLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_15
        view.setContentCompressionResistancePriority(.required, for: .horizontal)
        view.textColor = kAppColor_btnGray_BEBEBE
        view.text = "第"
        return view
    }()
    
    lazy var leftEditLabel: UITextField = {
        let view = UITextField()
        view.tag = 1
        view.textAlignment = .center
        view.font = FONT_15
        view.textColor = kAppColor_333333
        view.keyboardType = .numbersAndPunctuation
        view.clipsToBounds = true
        view.layer.borderColor = kAppColor_line_EEEEEE.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = button_cordious_2
        return view
    }()
    
    
    lazy var leftUnitLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_15
        view.setContentCompressionResistancePriority(.required, for: .horizontal)
        view.textColor = kAppColor_btnGray_BEBEBE
        view.text = "层"
        return view
    }()
    
    lazy var rightUnitLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_14
        view.setContentCompressionResistancePriority(.required, for: .horizontal)
        view.textColor = kAppColor_btnGray_BEBEBE
        view.text = "总0层"
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
    
    func setDelegate() {
        
    }
    
    func setupViews() {

        self.backgroundColor = kAppWhiteColor
  
        setDelegate()
        
        addSubview(leftLabel)
        addSubview(leftEditLabel)
        addSubview(leftUnitLabel)
        addSubview(rightUnitLabel)
        addSubview(lineView)
        
        leftLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(left_pending_space_17)
            make.top.bottom.equalToSuperview()
        }
        
        leftEditLabel.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 90, height: 36))
            make.leading.equalTo(leftLabel.snp.trailing).offset(5)
            make.centerY.equalTo(leftLabel)
        }
        leftUnitLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(leftEditLabel.snp.trailing).offset(5)
            make.centerY.equalTo(leftLabel)
        }
        rightUnitLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(-left_pending_space_17)
            make.centerY.equalTo(leftLabel)
        }
        
        lineView.snp.makeConstraints { (make) in
            make.leading.equalTo(left_pending_space_17)
            make.trailing.equalTo(-left_pending_space_17)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        
        setExtraView()
        
    }
    
    ///子类 独立设置自己要添加的控件和约束
    func setExtraView() {
        leftEditLabel.delegate = self
        leftEditLabel.addTarget(self, action: #selector(valueDidChange), for: .editingChanged)
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
    
    
    @objc func valueDidChange() {
        let textNum = leftEditLabel.text?.count
        
        //MARK: 办公室
        //MARK: 办公室 ///所在楼层
        if officeModel.type == .OwnerBuildingOfficeTypeTotalFloor {
            if FYModel?.houseMsg?.floorType == "1" {

                //截取
                if textNum! > 3 {
                    let index = leftEditLabel.text?.index((leftEditLabel.text?.startIndex)!, offsetBy: 2)
                    leftEditLabel.text = leftEditLabel.text?.substring(to: index!)
                }
                if let num = Int(leftEditLabel.text ?? "0") {
                    if num > 150 {
                        leftEditLabel.text?.removeLast(1)
                        AppUtilities.makeToast("仅支持-5-150整数")
                    }
                }
            }else {
                
            }
        }
        
        
        
        //MARK: 独立办公室
        //MARK: 独立办公室   ///所在楼层
        if jointIndepentOfficeModel.type == .OwnerBuildingJointOfficeTypeTotalFloor {
            if FYModel?.houseMsg?.floorType == "1" {

                //截取
                if textNum! > 3 {
                    let index = leftEditLabel.text?.index((leftEditLabel.text?.startIndex)!, offsetBy: 3)
                    leftEditLabel.text = leftEditLabel.text?.substring(to: index!)
                }
                if let num = Int(leftEditLabel.text ?? "0") {
                    if num > 150 {
                        leftEditLabel.text?.removeLast(1)
                        AppUtilities.makeToast("仅支持-5-150整数")
                    }
                }
            }else {

                //截取
                if textNum! > 3 {
                    let index = leftEditLabel.text?.index((leftEditLabel.text?.startIndex)!, offsetBy: 3)
                    leftEditLabel.text = leftEditLabel.text?.substring(to: index!)
                }
                if let num = Int(leftEditLabel.text ?? "0") {
                    if num > 150 {
                        leftEditLabel.text?.removeLast(1)
                        AppUtilities.makeToast("仅支持-5-150整数")
                    }
                }
            }
        }
    
        
        //MARK: 开放工位
        //MARK: 开放工位    ///所在楼层
        if jointOpenStationModel.type == .OwnerBuildingJointOpenStationTypeTotalFloor {
            if FYModel?.houseMsg?.floorType == "1" {

                //截取
                if textNum! > 3 {
                    let index = leftEditLabel.text?.index((leftEditLabel.text?.startIndex)!, offsetBy: 3)
                    leftEditLabel.text = leftEditLabel.text?.substring(to: index!)
                }
                if let num = Int(leftEditLabel.text ?? "0") {
                    if num > 150 {
                        leftEditLabel.text?.removeLast(1)
                        AppUtilities.makeToast("仅支持-5-150整数")
                    }
                }
            }else {

                //截取
                if textNum! > 3 {
                    let index = leftEditLabel.text?.index((leftEditLabel.text?.startIndex)!, offsetBy: 3)
                    leftEditLabel.text = leftEditLabel.text?.substring(to: index!)
                }
                if let num = Int(leftEditLabel.text ?? "0") {
                    if num > 150 {
                        leftEditLabel.text?.removeLast(1)
                        AppUtilities.makeToast("仅支持-5-150整数")
                    }
                }
            }
        }
        
    }
    
}
extension OwnerBuildingFYFloorCell: UITextFieldDelegate {
   
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        //MARK: 办公室
        //MARK: 办公室 ///所在楼层
        if officeModel.type == .OwnerBuildingOfficeTypeTotalFloor {
            
            FYModel?.houseMsg?.floor = textField.text
            guard let blockk = self.endEditingFYMessageCell else {
                return
            }
            blockk(FYModel ?? FangYuanHouseEditModel())
        }
        
        
        
        //MARK: 独立办公室
        //MARK: 独立办公室   ///所在楼层
        if jointIndepentOfficeModel.type == .OwnerBuildingJointOfficeTypeTotalFloor {
            
            FYModel?.houseMsg?.floor = textField.text
            guard let blockk = self.endEditingFYMessageCell else {
                return
            }
            blockk(FYModel ?? FangYuanHouseEditModel())
        }
    
        
        //MARK: 开放工位
        //MARK: 开放工位    ///所在楼层
        if jointOpenStationModel.type == .OwnerBuildingJointOpenStationTypeTotalFloor {
            
            FYModel?.houseMsg?.floor = textField.text
            guard let blockk = self.endEditingFYMessageCell else {
                return
            }
            blockk(FYModel ?? FangYuanHouseEditModel())
        }
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
}

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
            if let totalFloor = FYModel?.totalFloor {
                if totalFloor != "0" || totalFloor.isBlankString != true {
                    rightUnitLabel.text = "总\(totalFloor)层"
                }
            }
//            if FYModel?.houseMsg?.floorType == "1" || FYModel?.houseMsg?.floorType == "2" {
//                self.isHidden = false
//            }else {
//                self.isHidden = true
//            }
        }
    }
    
    ///独立办公室
     var jointIndepentOfficeModel: OwnerBuildingJointOfficeConfigureModel = OwnerBuildingJointOfficeConfigureModel(types: OwnerBuildingJointOfficeType.OwnerBuildingJointOfficeTypeBuildingImage) {
         didSet {
            
            leftEditLabel.text = FYModel?.houseMsg?.floor
            if let totalFloor = FYModel?.totalFloor {
                if totalFloor != "0" || totalFloor.isBlankString != true {
                    rightUnitLabel.text = "总\(totalFloor)层"
                }
            }
//            if FYModel?.houseMsg?.floorType == "1" || FYModel?.houseMsg?.floorType == "2" {
//                self.isHidden = false
//            }else {
//                self.isHidden = true
//            }
        }
     }
    
    ///开放工位
    var jointOpenStationModel: OwnerBuildingJointOpenStationConfigureModel = OwnerBuildingJointOpenStationConfigureModel(types: OwnerBuildingJointOpenStationType.OwnerBuildingJointOpenStationTypeBuildingImage) {
        didSet {
            
            leftEditLabel.text = FYModel?.houseMsg?.floor
            if let totalFloor = FYModel?.totalFloor {
                if totalFloor != "0" || totalFloor.isBlankString != true {
                    rightUnitLabel.text = "总\(totalFloor)层"
                }
            }
//            if FYModel?.houseMsg?.floorType == "1" || FYModel?.houseMsg?.floorType == "2" {
//                self.isHidden = false
//            }else {
//                self.isHidden = true
//            }
        }
    }
    
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.setContentCompressionResistancePriority(.required, for: .horizontal)
        view.textColor = kAppColor_999999
        view.attributedText = FuWenBen(name: "所在楼层", centerStr: " * ", last: "")
        return view
    }()
    
    
    //centerStr *
    func FuWenBen(name: String, centerStr: String, last: String) -> NSMutableAttributedString {
        
        //定义富文本即有格式的字符串
        let attributedStrM : NSMutableAttributedString = NSMutableAttributedString()
        
        if name.count > 0 {
            let nameAtt = NSAttributedString.init(string: name, attributes: [NSAttributedString.Key.backgroundColor : kAppWhiteColor , NSAttributedString.Key.foregroundColor : kAppColor_333333 , NSAttributedString.Key.font : FONT_14])
            attributedStrM.append(nameAtt)
            
        }
        
        if centerStr.count > 0 {
            //*
            let xingxing = NSAttributedString.init(string: centerStr, attributes: [NSAttributedString.Key.backgroundColor : kAppWhiteColor , NSAttributedString.Key.foregroundColor : kAppRedColor , NSAttributedString.Key.font : FONT_18])
            
            attributedStrM.append(xingxing)
            
        }
        
        if last.count > 0 {
            let lastAtt = NSAttributedString.init(string: last, attributes: [NSAttributedString.Key.backgroundColor : kAppWhiteColor , NSAttributedString.Key.foregroundColor : kAppColor_999999 , NSAttributedString.Key.font : FONT_10])
            attributedStrM.append(lastAtt)
            
        }
        
        return attributedStrM
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
        
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(leftLabel)
        self.contentView.addSubview(leftEditLabel)
        self.contentView.addSubview(leftUnitLabel)
        self.contentView.addSubview(rightUnitLabel)
        self.contentView.addSubview(lineView)
        
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(left_pending_space_17)
            make.top.bottom.equalToSuperview()
        }
        
        leftEditLabel.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 90, height: 36))
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview().offset(5)
        }
        leftLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(leftEditLabel.snp.leading).offset(-5)
            make.top.bottom.equalToSuperview()
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
            
            //截取
            if textNum! > 32 {
                let index = leftEditLabel.text?.index((leftEditLabel.text?.startIndex)!, offsetBy: 2)
                leftEditLabel.text = leftEditLabel.text?.substring(to: index!)
            }
        }
        
        
        
        //MARK: 独立办公室
        //MARK: 独立办公室   ///所在楼层
        if jointIndepentOfficeModel.type == .OwnerBuildingJointOfficeTypeTotalFloor {
            //截取
            if textNum! > 32 {
                let index = leftEditLabel.text?.index((leftEditLabel.text?.startIndex)!, offsetBy: 2)
                leftEditLabel.text = leftEditLabel.text?.substring(to: index!)
            }
        }
    
        
        //MARK: 开放工位
        //MARK: 开放工位    ///所在楼层
        if jointOpenStationModel.type == .OwnerBuildingJointOpenStationTypeTotalFloor {
            //截取
            if textNum! > 32 {
                let index = leftEditLabel.text?.index((leftEditLabel.text?.startIndex)!, offsetBy: 2)
                leftEditLabel.text = leftEditLabel.text?.substring(to: index!)
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

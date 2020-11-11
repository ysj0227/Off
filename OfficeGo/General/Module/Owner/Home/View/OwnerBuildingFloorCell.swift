//
//  OwnerBuildingFloorCell.swift
//  OfficeGo
//
//  Created by Mac pro on 2020/10/15.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class OwnerBuildingFloorCell: BaseTableViewCell {
    
    var buildingModel: FangYuanBuildingEditModel?
    
        ///楼盘
    var endEditingMessageCell:((FangYuanBuildingEditModel) -> Void)?
    
    var jointModel: OwnerBuildingJointEditConfigureModel = OwnerBuildingJointEditConfigureModel(types: OwnerBuildingJointEditType.OwnerBuildingJointEditTypeTotalFloor) {
        didSet {
            
            leftEditLabel.text = buildingModel?.buildingMsg?.totalFloor
            
            rightEditLabel.text = buildingModel?.buildingMsg?.branchesTotalFloor
            
            if buildingModel?.buildingMsg?.floorType == "1" || buildingModel?.buildingMsg?.floorType == "2" {
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
    
    lazy var rightLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_15
        view.setContentCompressionResistancePriority(.required, for: .horizontal)
        view.textColor = kAppColor_btnGray_BEBEBE
        view.text = "总"
        return view
    }()
    
    
    lazy var rightEditLabel: UITextField = {
        let view = UITextField()
        view.tag = 2
        view.textAlignment = .center
        view.font = FONT_15
        view.textColor = kAppColor_333333
        view.keyboardType = .numberPad
        view.clipsToBounds = true
        view.layer.borderColor = kAppColor_line_EEEEEE.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = button_cordious_2
        return view
    }()
    
    
    lazy var rightUnitLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_15
        view.setContentCompressionResistancePriority(.required, for: .horizontal)
        view.textColor = kAppColor_btnGray_BEBEBE
        view.text = "层"
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

    func setupViews() {

        self.backgroundColor = kAppWhiteColor
          
        addSubview(leftLabel)
        addSubview(leftEditLabel)
        addSubview(leftUnitLabel)
        addSubview(rightLabel)
        addSubview(rightEditLabel)
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
        
        rightLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(leftUnitLabel.snp.trailing).offset(20)
            make.centerY.equalTo(leftLabel)
        }
        
        rightEditLabel.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 73, height: 36))
            make.leading.equalTo(rightLabel.snp.trailing).offset(5)
            make.centerY.equalTo(leftLabel)
        }
        rightUnitLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(rightEditLabel.snp.trailing).offset(5)
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
        leftEditLabel.addTarget(self, action: #selector(valueDidChange(tf:))    , for: .editingChanged)
        rightEditLabel.delegate = self
        rightEditLabel.addTarget(self, action: #selector(valueDidChange(tf:)), for: .editingChanged)
    }
    
    
    @objc func valueDidChange(tf: UITextField) {
        
        if tf.tag == 1 {
            let textNum = leftEditLabel.text?.count
            //截取
            if textNum! > 32 {
                let index = leftEditLabel.text?.index((leftEditLabel.text?.startIndex)!, offsetBy: 2)
                leftEditLabel.text = leftEditLabel.text?.substring(to: index!)
            }
        }else {
            let textNum = rightUnitLabel.text?.count
            //截取
            if textNum! > 3 {
                let index = rightUnitLabel.text?.index((rightUnitLabel.text?.startIndex)!, offsetBy: 2)
                rightUnitLabel.text = rightUnitLabel.text?.substring(to: index!)
            }
            if let num = Int(rightUnitLabel.text ?? "0") {
                if num > 150 {
                    rightUnitLabel.text?.removeLast(1)
                    AppUtilities.makeToast("仅支持-5-150整数")
                }
            }
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
extension OwnerBuildingFloorCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == leftEditLabel {
            buildingModel?.buildingMsg?.totalFloor = textField.text
            
        }else {
            buildingModel?.buildingMsg?.branchesTotalFloor = textField.text
            
        }

    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
}

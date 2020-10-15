//
//  OwnerBuildingFloorCell.swift
//  OfficeGo
//
//  Created by Mac pro on 2020/10/15.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class OwnerBuildingFloorCell: BaseTableViewCell {
    
    var buildingModel: FangYuanBuildingEditDetailModel?
    
    var endEditingMessageCell:((FangYuanBuildingEditDetailModel) -> Void)?
    
    @objc func valueDidChange() {
        
    }
    
    
    var jointModel: OwnerBuildingJointEditConfigureModel = OwnerBuildingJointEditConfigureModel(types: OwnerBuildingJointEditType.OwnerBuildingJointEditTypeTotalFloor) {
        didSet {
            titleLabel.attributedText = jointModel.getNameFormType(type: jointModel.type ?? OwnerBuildingJointEditType.OwnerBuildingJointEditTypeTotalFloor)
            editLabel.placeholder = jointModel.getPalaceHolderFormType(type: jointModel.type ?? OwnerBuildingJointEditType.OwnerBuildingJointEditTypeTotalFloor)
        }
    }
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_15
        view.setContentCompressionResistancePriority(.required, for: .horizontal)
        view.textColor = kAppColor_999999
        return view
    }()
    
    
    lazy var editLabel: UITextField = {
        let view = UITextField()
        view.textAlignment = .right
        view.font = FONT_15
        view.textColor = kAppColor_333333
        view.clearButtonMode = .whileEditing
        return view
    }()
    
    
    lazy var detailIcon: BaseImageView = {
        let view = BaseImageView.init()
        view.image = UIImage.init(named: "moreDetail")
        view.contentMode = .scaleAspectFit
        return view
    }()
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = kAppColor_line_EEEEEE
        return view
    }()
    
    lazy var leftLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_15
        view.setContentCompressionResistancePriority(.required, for: .horizontal)
        view.textColor = kAppColor_999999
        view.text = "第"
        return view
    }()
    
    lazy var leftEditLabel: UITextField = {
        let view = UITextField()
        view.textAlignment = .center
        view.font = FONT_15
        view.textColor = kAppColor_333333
        view.isEnabled = false
        view.keyboardType = .numberPad
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
        view.textColor = kAppColor_999999
        view.text = "层"
        return view
    }()
    
    lazy var rightLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_15
        view.setContentCompressionResistancePriority(.required, for: .horizontal)
        view.textColor = kAppColor_999999
        view.text = "共"
        return view
    }()
    
    
    lazy var rightEditLabel: UITextField = {
        let view = UITextField()
        view.textAlignment = .center
        view.font = FONT_15
        view.textColor = kAppColor_333333
        view.isEnabled = false
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
        view.textColor = kAppColor_999999
        view.text = "层"
        return view
    }()
    
    lazy var bottomLineView: UIView = {
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
        return cell_height_58 * 2
    }
    
    func setDelegate() {
        
    }
    
    func setupViews() {
        
        setDelegate()
        
        addSubview(titleLabel)
        addSubview(editLabel)
        addSubview(detailIcon)
        addSubview(lineView)
        addSubview(leftLabel)
        addSubview(leftEditLabel)
        addSubview(leftUnitLabel)
        addSubview(rightLabel)
        addSubview(rightEditLabel)
        addSubview(rightUnitLabel)
        addSubview(bottomLineView)
        
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(left_pending_space_17)
            make.top.equalToSuperview()
            make.height.equalTo(cell_height_58)
        }
        
        editLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(-(left_pending_space_17 + 20))
            make.leading.equalTo(titleLabel.snp.trailing)
            make.centerY.equalTo(titleLabel)
        }
        
        detailIcon.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-left_pending_space_17)
            make.centerY.equalTo(titleLabel)
            make.width.equalTo(10)
        }
        lineView.snp.makeConstraints { (make) in
            make.leading.equalTo(left_pending_space_17)
            make.trailing.equalTo(-left_pending_space_17)
            make.top.equalTo(titleLabel.snp.bottom)
            make.height.equalTo(1)
        }
        
        leftLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(titleLabel)
            make.bottom.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom)
        }
        
        leftEditLabel.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 73, height: 36))
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
        
        bottomLineView.snp.makeConstraints { (make) in
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

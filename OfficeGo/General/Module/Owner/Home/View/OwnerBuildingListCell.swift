//
//  OwnerBuildingListCell.swift
//  OfficeGo
//
//  Created by Mac pro on 2020/10/21.
//  Copyright © 2020 Senwei. All rights reserved.
//

class OwnerBuildingListCell: BaseTableViewCell {
    
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
    
    lazy var redView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = kAppColor_line_EEEEEE
        return view
    }()
    
    lazy var scanBtn: UIButton = {
        let view = UIButton.init()
        view.setImage(UIImage.init(named: "scanBlue"), for: .selected)
        view.setImage(UIImage.init(named: "scanBlue"), for: .normal)
        view.addTarget(self, action: #selector(scanClick), for: .touchUpInside)
        return view
    }()
    
    lazy var editBtn: UIButton = {
        let view = UIButton.init()
        view.setImage(UIImage.init(named: "editBlue"), for: .selected)
        view.setImage(UIImage.init(named: "editGray"), for: .normal)
        view.addTarget(self, action: #selector(editClick), for: .touchUpInside)
        return view
    }()
    
    lazy var identifyBtn: UIButton = {
        let view = UIButton.init()
        view.isHidden = true
        view.setTitle("重新认证", for: .normal)
        view.clipsToBounds = true
        view.layer.cornerRadius = button_cordious_8
        view.backgroundColor = kAppBlueColor
        view.titleLabel?.font = FONT_14
        view.addTarget(self, action: #selector(identifyClick), for: .touchUpInside)
        return view
    }()
    
    var scanClickBlock: (() -> Void)?
    
    @objc func scanClick() {
        guard let blockk = scanClickBlock else {
            return
        }
        blockk()
    }
    
    var editClickBlock: (() -> Void)?
    
    @objc func editClick() {
        guard let blockk = editClickBlock else {
            return
        }
        blockk()
    }
    
    var identifyClickBlock: (() -> Void)?
    
    @objc func identifyClick() {
        guard let blockk = identifyClickBlock else {
            return
        }
        blockk()
    }
    
    
    class func rowHeight() -> CGFloat {
        return cell_height_53
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
  
        self.backgroundColor = kAppWhiteColor
        
        
        addSubview(houseTypTags)
        addSubview(houseNameLabel)
        addSubview(redView)
        addSubview(editBtn)
        addSubview(scanBtn)
        addSubview(identifyBtn)
        addSubview(lineView)
        
        
        houseTypTags.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(left_pending_space_17)
            make.height.equalTo(19)
            make.centerY.equalToSuperview()
        }
        
        editBtn.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 47, height: 40))
        }
        
        scanBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(editBtn.snp.leading)
            make.centerY.size.equalTo(editBtn)
        }
        identifyBtn.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-13)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 80, height: 30))
        }
        
        houseNameLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(scanBtn.snp.leading)
            make.leading.equalTo(houseTypTags.snp.trailing)
            make.top.bottom.equalToSuperview()
        }
        
        redView.snp.makeConstraints { (make) in
            make.leading.equalTo(houseNameLabel.snp.trailing)
            make.top.equalTo(12)
            make.size.equalTo(8)
        }
        
        lineView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(left_pending_space_17)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        
    }
    var model: OwnerBuildingListModel = OwnerBuildingListModel() {
        didSet {
            viewModel = OwnerBuildingListViewModel.init(model: model)
        }
    }
    
    var viewModel: OwnerBuildingListViewModel = OwnerBuildingListViewModel(model: OwnerBuildingListModel()) {
        didSet {
            setCellWithViewModel(viewModel: viewModel)
        }
    }
    
    ///列表页面
    func setCellWithViewModel(viewModel: OwnerBuildingListViewModel) {
        
        redView.image = UIImage.init(named: viewModel.redViewColor ?? "")
        
        redView.snp.remakeConstraints { (make) in
            make.leading.equalTo(houseTypTags.snp.trailing).offset(viewModel.redViewLeading ?? 0)
            make.top.equalTo(12)
            make.size.equalTo(8)
        }
        ///房源标签
        houseTypTags.image = UIImage.init(named: viewModel.houseTypTags ?? "")
        
        houseNameLabel.text = "\(viewModel.buildingName ?? "")"
        
        scanBtn.isSelected = true
        
        editBtn.isSelected = viewModel.isEdit ?? true
        
        scanBtn.isHidden = !viewModel.isHiddenIdentifyBtn
        
        editBtn.isHidden = !viewModel.isHiddenIdentifyBtn

        identifyBtn.isHidden = viewModel.isHiddenIdentifyBtn

//        editBtn.isUserInteractionEnabled = viewModel.isEdit ?? true
    }
    
}

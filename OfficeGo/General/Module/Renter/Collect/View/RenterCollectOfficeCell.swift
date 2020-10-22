//
//  RenterCollectOfficeCell.swift
//  OfficeGo
//
//  Created by mac on 2020/5/14.
//  Copyright © 2020 Senwei. All rights reserved.
//

class RenterCollectOfficeCell: BaseTableViewCell {
    
    lazy var houseImageview: BaseImageView = {
        let view = BaseImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        return view
    }()
    
    lazy var houseTagLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.font = FONT_10
        view.text = "独立办公室"
        view.textColor = kAppWhiteColor
        view.backgroundColor = kAppBlueColor
        return view
    }()
    
    lazy var vrImageview: BaseImageView = {
        let view = BaseImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    lazy var houseNameLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_16
        view.textColor = kAppColor_333333
        return view
    }()
    
    lazy var houseaddressIcon: BaseImageView = {
        let view = BaseImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage.init(named:"locationGray")
        return view
    }()
    
    lazy var houseAddressLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_LIGHT_11
        view.textColor = kAppColor_333333
        return view
    }()
    
    lazy var firstItem: detailItemView = {
        let view = detailItemView(frame: CGRect(x: 0, y: 0, width: (kWidth - 79 - left_pending_space_17 * 2 - 11) / 3.0, height: 40))
        view.titleLabel.textAlignment = .left
        view.descripLabel.textAlignment = .left
        view.titleLabel.font = FONT_13
        view.titleLabel.textColor = kAppColor_333333
        view.lineView.isHidden = true
        return view
    }()
    
    lazy var secondItem: detailItemView = {
        let view = detailItemView(frame: CGRect(x: (kWidth - 79 - left_pending_space_17 * 2 - 11) / 3.0, y: 0, width: (kWidth - 79 - left_pending_space_17 * 2 - 11) / 3.0, height: 40))
        view.titleLabel.font = FONT_MEDIUM_13
        view.lineView.isHidden = true
        return view
    }()
    
    lazy var thirdItem: detailItemView = {
        let view = detailItemView(frame: CGRect(x: (kWidth - 79 - left_pending_space_17 * 2 - 11) / 3.0 * 2, y: 0, width: (kWidth - 79 - left_pending_space_17 * 2 - 11) / 3.0, height: 40))
        view.titleLabel.textAlignment = .right
        view.descripLabel.textAlignment = .right
        view.titleLabel.font = FONT_MEDIUM_13
        view.lineView.isHidden = true
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
    
    /**
     ///开放工位
     ///工位数 - 30工位
     var openSeatsString : String?
     ///月租金
     var openMonthPriceString : String?
     ///最短租期---6个月可租
     var openMinimumLeaseString : String?
     */
    var model: FangYuanBuildingOpenStationModel = FangYuanBuildingOpenStationModel() {
        didSet {
            viewModel = FangYuanBuildingOpenStationViewModel.init(model: model)
        }
    }
    
    var viewModel: FangYuanBuildingOpenStationViewModel = FangYuanBuildingOpenStationViewModel(model: FangYuanBuildingOpenStationModel()) {
        didSet {
            
            setCellWithViewModel(viewModel: viewModel)
        }
    }
    /**
     ///面积
     var buildingArea : String?
     ///工位数
     var buildinSeats : String?
     var buildingDayPriceString : String?
     ///月租金
     var buildingMonthPriceString : String?
     ///装修
     var buildingDecoration : String?
     ///楼层
     var buildingFloor : String?
     */
    func setCellWithViewModel(viewModel: FangYuanBuildingOpenStationViewModel) {
        if viewModel.vr == "1" {
            vrImageview.image = UIImage.init(named: "vrPlayGray")
        }else {
            vrImageview.image = UIImage.init(named: "")
        }
        houseImageview.setImage(with: viewModel.mainPic ?? "", placeholder: UIImage(named: Default_1x1))
        houseNameLabel.text = viewModel.buildingName
        houseAddressLabel.text = viewModel.addressString
        if viewModel.addressString?.isBlankString == true {
            houseaddressIcon.isHidden = true
            houseAddressLabel.snp.remakeConstraints { (make) in
                make.leading.equalTo(houseNameLabel).offset(12 + 4)
                make.top.equalTo(houseNameLabel.snp.bottom).offset(0)
                make.trailing.equalTo(houseNameLabel)
                make.height.equalTo(0)
            }
        }else {
            houseaddressIcon.isHidden = false
            houseAddressLabel.snp.remakeConstraints { (make) in
                make.leading.equalTo(houseNameLabel).offset(12 + 4)
                make.top.equalTo(houseNameLabel.snp.bottom).offset(6)
                make.trailing.equalTo(houseNameLabel)
                make.height.equalTo(15)
            }
        }
        
        if viewModel.btype == 1 {
            
            houseTagLabel.isHidden = true
            secondItem.isHidden = false
            
            firstItem.titleLabel.text = viewModel.buildingArea
            firstItem.descripLabel.text = viewModel.buildinSeats
            secondItem.titleLabel.text = viewModel.buildingDayPriceString
            secondItem.descripLabel.text = viewModel.buildingMonthPriceString
            thirdItem.titleLabel.text = viewModel.buildingDecoration
            thirdItem.descripLabel.text = viewModel.buildingFloor
            
        }else if viewModel.btype == 2 {
            if viewModel.officeType == 1 {
                houseTagLabel.isHidden = false
            }
            secondItem.isHidden = true
            
            firstItem.titleLabel.text = viewModel.individualAreaString
            firstItem.descripLabel.text = viewModel.individualSeatsString
            thirdItem.titleLabel.text = "\(viewModel.individualMonthPriceString ?? "0")" + "/月"
            thirdItem.descripLabel.text = viewModel.individualDayPriceString
        }        
    }
    
    func setupViews() {

        self.backgroundColor = kAppWhiteColor
          self.addSubview(houseImageview)
        houseImageview.addSubview(houseTagLabel)
        self.addSubview(houseNameLabel)
        self.addSubview(houseaddressIcon)
        self.addSubview(houseAddressLabel)
        self.addSubview(firstItem)
        self.addSubview(secondItem)
        self.addSubview(thirdItem)
        self.addSubview(lineView)
        addSubview(vrImageview)

        houseImageview.snp.makeConstraints { (make) in
            make.top.leading.equalTo(left_pending_space_17)
            make.size.equalTo(92)
        }
        
        vrImageview.snp.makeConstraints { (make) in
            make.center.equalTo(houseImageview)
            make.size.equalTo(24)
        }
        houseTagLabel.snp.makeConstraints { (make) in
            make.top.leading.equalToSuperview()
            make.size.equalTo(CGSize(width: 74, height: 17))
        }
        houseNameLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(houseImageview.snp.trailing).offset(13)
            make.top.equalTo(houseImageview)
            make.trailing.equalToSuperview().offset(-left_pending_space_17)
        }
        houseAddressLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(houseNameLabel).offset(12 + 4)
            make.top.equalTo(houseNameLabel.snp.bottom).offset(6)
            make.trailing.equalTo(houseNameLabel)
            make.height.equalTo(15)
        }
        houseaddressIcon.snp.makeConstraints { (make) in
            make.leading.equalTo(houseNameLabel)
            make.centerY.height.equalTo(houseAddressLabel)
            make.width.equalTo(12)
        }
        
        let width = (kWidth - 92 - left_pending_space_17 * 2 - 13) / 3.0
        firstItem.snp.makeConstraints { (make) in
            make.leading.equalTo(houseNameLabel)
            make.top.equalTo(houseAddressLabel.snp.bottom).offset(7)
            make.width.equalTo(width)
        }
        secondItem.snp.makeConstraints { (make) in
            make.top.width.equalTo(firstItem)
            make.leading.equalTo(firstItem.snp.trailing)
        }
        thirdItem.snp.makeConstraints { (make) in
            make.top.equalTo(firstItem)
            make.trailing.equalToSuperview()
            make.leading.equalTo(secondItem.snp.trailing)
        }
        lineView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(left_pending_space_17)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
            make.trailing.equalToSuperview().offset(-left_pending_space_17)
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
    
    class func rowHeight() -> CGFloat {
        return 126
    }
    
}

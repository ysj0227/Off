//
//  RenterDetailFYListCell.swift
//  OfficeGo
//
//  Created by mac on 2020/5/12.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class RenterDetailFYListCell: BaseTableViewCell {
    lazy var mainImageView: BaseImageView = {
        let view = BaseImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = button_cordious_2
        return view
    }()
    lazy var leftTopLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_MEDIUM_13
        view.textColor = kAppColor_333333
        return view
    }()
    
    lazy var leftbottomLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_9
        view.textColor = kAppColor_999999
        return view
    }()
    lazy var rightPriceLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .right
        view.font = FONT_MEDIUM_13
        view.textColor = kAppBlueColor
        return view
    }()
    
    lazy var rightUnitLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .right
        view.font = FONT_12
        view.textColor = kAppColor_666666
        return view
    }()
    lazy var rightBottomUnitLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .right
        view.font = FONT_9
        view.textColor = kAppColor_999999
        return view
    }()
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = kAppColor_line_EEEEEE
        return view
    }()
    
    class func rowHeight() -> CGFloat {
        return 84
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
          addSubview(mainImageView)
        addSubview(leftTopLabel)
        addSubview(leftbottomLabel)
        addSubview(rightUnitLabel)
        addSubview(rightPriceLabel)
        addSubview(rightBottomUnitLabel)
        addSubview(lineView)
        
        mainImageView.snp.makeConstraints { (make) in
            make.leading.top.equalTo(left_pending_space_17)
            make.top.bottom.equalToSuperview().inset(12)
            make.width.equalTo(80)
        }
        
        let width = (kWidth - left_pending_space_17 * 3 - 80) / 2.0
        leftTopLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(mainImageView.snp.trailing).offset(left_pending_space_17)
            make.top.equalTo(mainImageView.snp.top)
            make.width.equalTo(width)
            make.height.equalTo(30)
        }
        leftbottomLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(leftTopLabel)
            make.top.equalTo(leftTopLabel.snp.bottom)
            make.width.equalTo(width)
            make.height.equalTo(leftTopLabel)
        }
        
        rightUnitLabel.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().inset(left_pending_space_17)
            make.top.equalTo(leftTopLabel)
            make.height.equalTo(leftTopLabel)
        }
        rightPriceLabel.snp.makeConstraints { (make) in
            make.top.height.equalTo(rightUnitLabel)
            make.trailing.equalTo(rightUnitLabel.snp.leading)
//            make.leading.equalTo(leftTopLabel.snp.trailing)
        }
        rightBottomUnitLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(rightUnitLabel)
            make.top.equalTo(rightUnitLabel.snp.bottom)
            make.width.equalTo(width)
            make.height.equalTo(leftTopLabel)
        }
        lineView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(left_pending_space_17)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        
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
    //开放工位 显示
    var model: FangYuanBuildingBuildingModel = FangYuanBuildingBuildingModel() {
         didSet {
             viewModel = FangYuanBuildingBuildingViewModel.init(model: model)
         }
     }
    var viewModel: FangYuanBuildingBuildingViewModel = FangYuanBuildingBuildingViewModel(model: FangYuanBuildingBuildingModel()) {
        didSet {
            setCellWithViewModel(viewModel: viewModel)
        }
    }
        
    func setCellWithViewModel(viewModel: FangYuanBuildingBuildingViewModel) {
        
        mainImageView.setImage(with: viewModel.openStationViewModel?.mainPic ?? "", placeholder: UIImage(named: Default_80x60))
        leftTopLabel.attributedText = viewModel.openStationViewModel?.openSeatsStringAttri
        leftbottomLabel.text = viewModel.openStationViewModel?.openSeatsUnitLBString
        rightPriceLabel.text = viewModel.openStationViewModel?.openMonthPriceString
        rightUnitLabel.text = "/位/月"
        rightBottomUnitLabel.text = viewModel.openStationViewModel?.openMinimumLeaseString
    }
    
    
        /**
       ///独立办公室
       ///
       ///面积
       var individualAreaString : String?
       ///每工位每月租金  3000.0
       var individualMonthPriceString : String?
       ///工位数 - 30工位
       var individualSeatsString : String?
       ///每工位每天租金  3000.0
       var individualDayPriceString : String?
       */
    
    var duliModel: FangYuanBuildingOpenStationModel = FangYuanBuildingOpenStationModel() {
        didSet {
            duliViewModel = FangYuanBuildingOpenStationViewModel.init(model: duliModel)
        }
    }
    
    var duliViewModel: FangYuanBuildingOpenStationViewModel = FangYuanBuildingOpenStationViewModel(model: FangYuanBuildingOpenStationModel()) {
        didSet {
            setDuliCellWithViewModel(viewModel: duliViewModel)
        }
    }
    func setDuliCellWithViewModel(viewModel: FangYuanBuildingOpenStationViewModel) {
        mainImageView.setImage(with: viewModel.mainPic ?? "", placeholder: UIImage(named: Default_80x60))
        leftTopLabel.attributedText = viewModel.individualSeatsStringAttri
        leftbottomLabel.text = viewModel.individualAreaString
        rightPriceLabel.text = viewModel.individualMonthPriceString
        rightUnitLabel.text = "/月"
        rightBottomUnitLabel.text = viewModel.individualDayPriceString
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

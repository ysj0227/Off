//
//  RenterDetailOfficeListCell.swift
//  OfficeGo
//
//  Created by mac on 2020/5/12.
//  Copyright © 2020 Senwei. All rights reserved.
//

import UIKit

class RenterDetailOfficeListCell: BaseTableViewCell {
    
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
        view.font = FONT_11
        view.textColor = kAppColor_333333
        view.adjustsFontSizeToFitWidth = true
        return view
    }()
    
    lazy var leftbottomLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_9
        view.textColor = kAppColor_333333
        view.adjustsFontSizeToFitWidth = true
        return view
    }()
    
    lazy var centerTopLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.font = FONT_11
        view.textColor = kAppColor_333333
        view.adjustsFontSizeToFitWidth = true
        return view
    }()
    
    lazy var centerBottomLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.font = FONT_9
        view.textColor = kAppColor_333333
        view.adjustsFontSizeToFitWidth = true
        return view
    }()
    
    lazy var rightDocumentLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .right
        view.font = FONT_11
        view.textColor = kAppBlueColor
        view.adjustsFontSizeToFitWidth = true
        return view
    }()
    
    lazy var rightBottomFloorLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .right
        view.font = FONT_9
        view.textColor = kAppColor_333333
        view.adjustsFontSizeToFitWidth = true
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
        addSubview(mainImageView)
        addSubview(leftTopLabel)
        addSubview(leftbottomLabel)
        addSubview(centerTopLabel)
        addSubview(centerBottomLabel)
        addSubview(rightDocumentLabel)
        addSubview(rightBottomFloorLabel)
        addSubview(lineView)
        
        mainImageView.snp.makeConstraints { (make) in
            make.leading.top.equalTo(left_pending_space_17)
            make.top.bottom.equalToSuperview().inset(12)
            make.width.equalTo(80)
        }
        
        let width = (kWidth - left_pending_space_17 * 3 - 80) / 3.0
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
        centerTopLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(leftTopLabel.snp.trailing)
            make.top.equalTo(leftTopLabel)
            make.width.equalTo(width)
            make.height.equalTo(leftTopLabel)
        }
        centerBottomLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(centerTopLabel)
            make.top.equalTo(centerTopLabel.snp.bottom)
            make.width.equalTo(width)
            make.height.equalTo(leftTopLabel)
        }
        rightDocumentLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(centerTopLabel.snp.trailing)
            make.top.equalTo(leftTopLabel)
            make.width.equalTo(width)
            make.height.equalTo(leftTopLabel)
        }
        rightBottomFloorLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(rightDocumentLabel)
            make.top.equalTo(rightDocumentLabel.snp.bottom)
            make.width.equalTo(width)
            make.height.equalTo(leftTopLabel)
        }
        lineView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(left_pending_space_17)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        
    }
    
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
        mainImageView.setImage(with: viewModel.mainPic ?? "", placeholder: UIImage(named: Default_80x60))
        leftTopLabel.text = viewModel.buildingArea
        leftbottomLabel.text = viewModel.buildinSeats
        centerTopLabel.text = viewModel.buildingDayPriceString
        centerBottomLabel.text = viewModel.buildingMonthPriceString
        rightDocumentLabel.text = viewModel.buildingDecoration
        rightBottomFloorLabel.text = viewModel.buildingFloor
    }
    
    
}

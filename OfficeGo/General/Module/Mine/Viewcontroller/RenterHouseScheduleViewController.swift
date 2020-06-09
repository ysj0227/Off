//
//  RenterHouseScheduleViewController.swift
//  OfficeGo
//
//  Created by mac on 2020/5/18.
//  Copyright © 2020 Senwei. All rights reserved.
//
import UIKit
import HandyJSON
import SwiftyJSON


class RenterHouseScheduleViewController: BaseTableViewController, FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    
    var dataSourceArr: [ScheduleViewModel] = []

    var currentDayString: String?
    
    ///当前显示的某一天的数据
    var currentModel: ScheduleViewModel?
    
    fileprivate lazy var calendar: FSCalendar = {
        //获取FSCalendar的实例
        let calendar = FSCalendar.init(frame: CGRect.init(x: 0, y: kNavigationHeight, width: kWidth, height: 260))
        //设置FSCalendar的dataSource和delegate
        calendar.dataSource = self
        calendar.delegate = self
        calendar.scope = .week
        calendar.placeholderType = .none
        //        calendar.scrollEnabled = true
        //        calendar.pagingEnabled = true
        //        calendar.rowHeight = 53
        //        return _scope == FSCalendarScopeMonth && _scrollEnabled && !_pagingEnabled;
        
        calendar.headerHeight = 45
        calendar.weekdayHeight = 30
        calendar.layoutSubviews()
        calendar.appearance.headerDateFormat = "yyyy年MM月"
        calendar.appearance.eventDefaultColor = kAppBlueColor;
        calendar.appearance.weekdayTextColor = kAppColor_757575
        calendar.appearance.weekdayFont = FONT_MEDIUM_14
        calendar.appearance.headerTitleColor = kAppColor_757575
        calendar.appearance.headerTitleFont = FONT_MEDIUM_14
        calendar.appearance.titleDefaultColor = kAppColor_757575
        calendar.appearance.titleFont = FONT_13
        calendar.appearance.selectionColor = kAppBlueColor      //选中的日期的背景
        calendar.appearance.titleSelectionColor = kAppWhiteColor//选中的日期的颜色
        calendar.select(Date(), scrollToDate: true)
        calendar.accessibilityIdentifier = "calendar"
        calendar.layoutSubviews()
        return calendar
    }()
    
    lazy var gregorian: NSCalendar = {
        let object = NSCalendar.init(identifier: NSCalendar.Identifier.gregorian)
        return object ?? NSCalendar.init(identifier: NSCalendar.Identifier.gregorian) as! NSCalendar
    }()
    
    var dateFormatter1: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    var dateFormatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    
    var datesWithEvent: [String] = []
    
    deinit {
        
    }
    
    
    override func refreshData() {
        
        var params = [String:AnyObject]()
        params["token"] = "MTA0X3N1bndlbGxfMTU5MTYwNTkwOV8w" as AnyObject?
        params["startTime"] = 1591002463 as AnyObject?
        params["endTime"] = 1591942800 as AnyObject?

        SSNetworkTool.SSSchedule.request_getScheduleListApp(params: params, success: { [weak self] (response) in
            guard let weakSelf = self else {return}
            if let decoratedArray = JSONDeserializer<ScheduleModel>.deserializeModelArrayFrom(json: JSON(response).rawString() ?? "", designatedPath: "data") {
                
                var arr: [ScheduleViewModel] = []
                for model in decoratedArray {
                    let viewmodel = ScheduleViewModel.init(model: model ?? ScheduleModel())
                    arr.append(viewmodel)
                    weakSelf.datesWithEvent.append(viewmodel.day ?? "")
                }
                weakSelf.dataSourceArr = arr
                weakSelf.setUpData()
                weakSelf.tableView.reloadData()
                
            }
            
            }, failure: { (error) in
                
        }) { (code, message) in
            
            //只有5000 提示给用户
            if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" {
                AppUtilities.makeToast(message)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentDayString =  self.dateFormatter2.string(from: NSDate() as Date)
        setUpView()
        
    }
    
}


extension RenterHouseScheduleViewController {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("didSelect\(date)")
        currentDayString = self.dateFormatter2.string(from: date)
        for model in dataSourceArr {
            if model.day == currentDayString {
                currentModel = model
                break
            }
        }
        self.tableView.reloadData()
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("calendarCurrentPageDidChange\(calendar.currentPage)")
        dataSourceArr.removeAll()
        self.tableView.reloadData()
    }
    
    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
        return self.gregorian.isDateInToday(date) ? "今" : nil
    }
    //    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
    //        return ""
    //    }
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        if self.datesWithEvent.contains(self.dateFormatter2.string(from: date)) {
            return 1
        }
        return 0
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventOffsetFor date: Date) -> CGPoint {
        if self.datesWithEvent.contains(self.dateFormatter2.string(from: date)) {
            return CGPoint(x: 0, y: -6)
        }
        return .zero
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventSelectionColorsFor date: Date) -> [UIColor]? {
        if self.datesWithEvent.contains(self.dateFormatter2.string(from: date)) {
            return [kAppBlackColor]
        }
        return nil
    }
}

extension RenterHouseScheduleViewController {
    
    @objc func previousClicked() {
        let previousMonth = gregorian.date(byAdding: .day, value: -7, to: self.calendar.currentPage, options: NSCalendar.Options(rawValue: 0)) ?? Date()
        self.calendar.setCurrentPage(previousMonth, animated: true)
    }
    
    @objc func nextClicked() {
        let nextMonth = gregorian.date(byAdding: .day, value: 7, to: self.calendar.currentPage, options: NSCalendar.Options(rawValue: 0)) ?? Date()
        self.calendar.setCurrentPage(nextMonth, animated: true)
    }
    
    
    func setUpView() {
        
        titleview = ThorNavigationView.init(type: .backTitleRight)
        titleview?.rightButton.isHidden = false
        titleview?.rightButton.setImage(UIImage.init(named: "today"), for: .normal)
        titleview?.rightButton.setTitle("约看记录", for: .normal)
        titleview?.rightButton.setTitleColor(kAppColor_333333, for: .normal)
        titleview?.rightButton.titleLabel?.font = FONT_13
        titleview?.rightButton.snp.remakeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-left_pending_space_17)
            //            make.height.equalTo(26)
            make.width.equalTo(90)
            //            make.centerY.equalTo(self.titleview?.leftButton.snp.centerY)
            make.top.bottom.equalToSuperview()
        }
        titleview?.rightButton.layoutButton(.imagePositionRight, margin: 2)
        titleview?.titleLabel.text = "看房行程"
        titleview?.leftButtonCallBack = { [weak self] in
            self?.leftBtnClick()
        }
        titleview?.rightBtnClickBlock = { [weak self] in
            let vc = RenterHouseScheduleViewController()
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        self.view.addSubview(titleview ?? ThorNavigationView.init(type: .backTitleRight))
        
        self.view.addSubview(calendar)
        
        self.view.sendSubviewToBack(calendar)
        
        let preBtn = UIButton.init(frame: CGRect(x: 0, y: kNavigationHeight, width: 50, height: 45))
        preBtn.backgroundColor = kAppWhiteColor
        preBtn.addTarget(self, action: #selector(previousClicked), for: .touchUpInside)
        preBtn.setImage(UIImage.init(named: "calendarPre"), for: .normal)
        self.view.addSubview(preBtn)
        
        let nextBtn = UIButton.init(frame: CGRect(x: kWidth - 50, y: kNavigationHeight, width: 50, height: 45))
        nextBtn.backgroundColor = kAppWhiteColor
        nextBtn.addTarget(self, action: #selector(nextClicked), for: .touchUpInside)
        nextBtn.setImage(UIImage.init(named: "calendarNext"), for: .normal)
        self.view.addSubview(nextBtn)
        
        self.tableView.snp.remakeConstraints { (make) in
            make.top.equalTo(kNavigationHeight + 128)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        self.tableView.register(RenterHouseScheduleCell.self, forCellReuseIdentifier: RenterHouseScheduleCell.reuseIdentifierStr)
        
        refreshData()
    }
    
    func setUpData() {
        
//        datesWithEvent.append("2020-05-01")
//        datesWithEvent.append("2020-05-19")
//        datesWithEvent.append("2020-05-20")
//        datesWithEvent.append("2020-05-28")
//
//        dataSourceArr.append("111")
//        dataSourceArr.append("2224")
//        dataSourceArr.append("111")
//        dataSourceArr.append("2224")
//        dataSourceArr.append("111")
//        dataSourceArr.append("2224")
//        dataSourceArr.append("111")
//        dataSourceArr.append("2224")
//        self.tableView.reloadData()
    }
    
}

extension RenterHouseScheduleViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RenterHouseScheduleCell.reuseIdentifierStr) as? RenterHouseScheduleCell
        cell?.selectionStyle = .none
        if let scheduleList = currentModel?.scheduleViewModelList {
            cell?.viewModel = scheduleList[indexPath.row]
        }
        return cell ?? RenterHouseScheduleCell.init(frame: .zero)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return currentModel?.scheduleViewModelList?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return RenterHouseScheduleCell.rowHeight()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = RenterHouseScheduleDetailViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 70
    }
}

class RenterHouseScheduleCell: BaseTableViewCell {
    
    //日期
    lazy var dateLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_10
        view.textColor = kAppColor_666666
        return view
    }()
    //时间
    lazy var dateTimeLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_14
        view.textColor = kAppColor_333333
        return view
    }()
    lazy var topLineView: UIView = {
        let view = UIView()
        return view
    }()
    lazy var timeIcon: BaseImageView = {
        let view = BaseImageView.init()
        return view
    }()
    lazy var bottomLineView: UIView = {
        let view = UIView()
        return view
    }()
    //背景 - 浅灰或者浅蓝色
    lazy var bgView: UIView = {
        let view = UIView()
        return view
    }()
    lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_MEDIUM_14
        return view
    }()
    
    lazy var companyLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_9
        view.textColor = kAppColor_666666
        return view
    }()
    
    lazy var stateLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_MEDIUM_10
        return view
    }()
    lazy var descLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_10
        view.textColor = kAppColor_666666
        return view
    }()
    lazy var addressIcon: BaseImageView = {
        let view = BaseImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage.init(named:"locationGray")
        return view
    }()
    lazy var addressLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_9
        view.textColor = kAppColor_666666
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
        return 102
    }
    
    var viewModel: ScheduleViewModelList = ScheduleViewModelList(model: ScheduleList()) {
        didSet {
            ///行程审核状态 0预约待接受 1预约成功 2预约失败 3已看房 4未看房
            if viewModel.auditStatus == 3 {
                timeIcon.image = UIImage.init(named: "timeIconGray")
                stateLabel.text = "已完成"
                stateLabel.textColor = kAppColor_666666
                bgView.backgroundColor = kAppColor_bgcolor_F7F7F7
                nameLabel.textColor = kAppColor_666666
                descLabel.textColor = kAppColor_666666
                
            }else if viewModel.auditStatus == 0 {
                timeIcon.image = UIImage.init(named: "timeIcon")
                stateLabel.text = "待接受"
                stateLabel.textColor = kAppBlueColor
                bgView.backgroundColor = kAppLightBlueColor
                nameLabel.textColor = kAppColor_333333
                descLabel.textColor = kAppColor_333333
            }else if viewModel.auditStatus == 1 {
                timeIcon.image = UIImage.init(named: "timeIcon")
                stateLabel.text = "预约成功"
                stateLabel.textColor = kAppBlueColor
                bgView.backgroundColor = kAppLightBlueColor
                nameLabel.textColor = kAppColor_333333
                descLabel.textColor = kAppColor_333333
            }
            dateLabel.text = viewModel.dateTimeString
            dateTimeLabel.text = viewModel.hourMinuterTimeString
            nameLabel.text = viewModel.contactNameString
            companyLabel.text = viewModel.companyJobString
            descLabel.text = viewModel.schedulebuildingName
            addressLabel.text = viewModel.businessDistrict
        }
    }
    
    func setupViews() {
        
        addSubview(dateLabel)
        addSubview(dateTimeLabel)
        addSubview(topLineView)
        addSubview(bottomLineView)
        addSubview(bgView)
        addSubview(timeIcon)
        bgView.addSubview(nameLabel)
        bgView.addSubview(companyLabel)
        bgView.addSubview(stateLabel)
        bgView.addSubview(descLabel)
        bgView.addSubview(addressIcon)
        bgView.addSubview(addressLabel)
        
        dateLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(left_pending_space_17)
            make.top.equalTo(19)
            make.width.equalTo(50)
            make.height.equalTo(20)
        }
        dateTimeLabel.snp.makeConstraints { (make) in
            make.leading.width.equalTo(dateLabel)
            make.top.equalTo(dateLabel.snp.bottom)
            make.height.equalTo(25)
        }
        timeIcon.snp.makeConstraints { (make) in
            make.leading.equalTo(dateLabel.snp.trailing)
            make.size.equalTo(17)
            make.centerY.equalToSuperview()
        }
        bgView.snp.makeConstraints { (make) in
            make.leading.equalTo(timeIcon.snp.trailing).offset(-8.5)
            make.top.equalTo(dateLabel)
            make.bottom.equalToSuperview()
            make.trailing.equalTo(-left_pending_space_17)
        }
        stateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.height.equalTo(23)
            make.trailing.equalToSuperview()
            make.width.equalTo(35)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(left_pending_space_17)
            make.centerY.height.equalTo(stateLabel)
        }
        companyLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(stateLabel.snp.leading).offset(-3)
            make.leading.equalTo(nameLabel.snp.trailing).offset(3)
            make.centerY.height.equalTo(stateLabel)
        }
        
        descLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(nameLabel)
            make.trailing.equalTo(stateLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(3)
            make.height.equalTo(21)
        }
        addressIcon.snp.makeConstraints { (make) in
            make.leading.equalTo(nameLabel)
            make.top.equalTo(descLabel.snp.bottom).offset(3)
            make.height.equalTo(18)
        }
        addressLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(addressIcon.snp.trailing).offset(5)
            make.centerY.height.equalTo(addressIcon)
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

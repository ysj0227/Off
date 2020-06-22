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
    
    ///默认显示看房行程- 为true 显示约看记录
    var isLookRecord: Bool = false {
        didSet {
            setDataType()
        }
    }
    
    ///开始请求时间戳
    var startTime: Int = 0
    
    ///结束请求时间戳
    var endTime: Int = 0
    
    ///显示数据
    var dataSourceArr: [ScheduleViewModel] = []
    
    ///当前显示的有数据的事件 2020-09-20
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
        ///设置周一为周的第一天
        calendar.firstWeekday = 2
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
        calendar.appearance.todayColor = kAppBlueColor
        calendar.appearance.todaySelectionColor = kAppBlueColor
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
    
    func getTimeIntervalWidhtDate(date: Date) -> Int {
        return Int(date.timeIntervalSince1970)
    }
    override func refreshData() {
        
        var params = [String:AnyObject]()
        params["token"] = "MTA0X3N1bndlbGxfMTU5MTYwNTkwOV8w" as AnyObject?
        params["startTime"] = startTime as AnyObject?
        params["endTime"] = endTime as AnyObject?
        
        if isLookRecord == true {
            ///请求看房记录 -
            SSNetworkTool.SSSchedule.request_getOldScheduleListApp(params: params, success: { [weak self] (response) in
                guard let weakSelf = self else {return}
                if let decoratedArray = JSONDeserializer<ScheduleModel>.deserializeModelArrayFrom(json: JSON(response).rawString() ?? "", designatedPath: "data") {
                    
                    var arr: [ScheduleViewModel] = []
                    var event: [String] = []
                    for model in decoratedArray {
                        let viewmodel = ScheduleViewModel.init(model: model ?? ScheduleModel())
                        arr.append(viewmodel)
                        event.append(viewmodel.day ?? "")
                    }
                    weakSelf.dataSourceArr = arr
                    weakSelf.datesWithEvent = event
                    weakSelf.loadViewShowViews()
                    
                }
                
                }, failure: { (error) in
                    
            }) { (code, message) in
                
                //只有5000 提示给用户
                if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" {
                    AppUtilities.makeToast(message)
                }
            }
        }else {
            
            SSNetworkTool.SSSchedule.request_getScheduleListApp(params: params, success: { [weak self] (response) in
                guard let weakSelf = self else {return}
                if let decoratedArray = JSONDeserializer<ScheduleModel>.deserializeModelArrayFrom(json: JSON(response).rawString() ?? "", designatedPath: "data") {
                    
                    var arr: [ScheduleViewModel] = []
                    var event: [String] = []
                    for model in decoratedArray {
                        let viewmodel = ScheduleViewModel.init(model: model ?? ScheduleModel())
                        arr.append(viewmodel)
                        event.append(viewmodel.day ?? "")
                    }
                    weakSelf.dataSourceArr = arr
                    weakSelf.datesWithEvent = event
                    weakSelf.loadViewShowViews()
                    
                }
                
                }, failure: { (error) in
                    
            }) { (code, message) in
                
                //只有5000 提示给用户
                if code == "\(SSCode.DEFAULT_ERROR_CODE_5000.code)" {
                    AppUtilities.makeToast(message)
                }
            }
        }
        
    }
    
    func loadViewShowViews() {
        SSTool.invokeInMainThread { [weak self] in
            
            if let arr = self?.datesWithEvent {
                if arr.count > 0 {
                    self?.currentDayString = arr[0]
                    let date = SSTool.timeStrChangeToDateYYYYMMdd(timeStr: self?.currentDayString)
                    self?.calendar.select(date, scrollToDate: true)
                    self?.currentModel = self?.dataSourceArr[0]
                }
            }
            self?.calendar.reloadData()
            self?.tableView.reloadData()
            self?.showNoDataView()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentDayString =  self.dateFormatter2.string(from: NSDate() as Date)
        
        setUpView()
    }
    
    
    func setDataType() {
        ///默认显示看房行程- 为true 显示约看记录
        ///当前为约看记录
        if isLookRecord == true {
            titleview?.rightButton.setTitle("看房行程", for: .normal)
            
            titleview?.titleLabel.text = "约看记录"
            
            ///清空之前显示的数据
            currentDayString = ""
            
            currentModel = nil
            
            refreshData()
            
            titleview?.rightBtnClickBlock = { [weak self] in
                self?.isLookRecord = false
            }
        }else {
            titleview?.rightButton.setTitle("约看记录", for: .normal)
            
            titleview?.titleLabel.text = "看房行程"
            
            ///清空之前显示的数据
            currentDayString = ""
            
            currentModel = nil
            
            refreshData()
            
            titleview?.rightBtnClickBlock = { [weak self] in
                self?.isLookRecord = true
            }
        }
    }
}


extension RenterHouseScheduleViewController {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        SSLog("didSelect\(date)")
        currentDayString = self.dateFormatter2.string(from: date)
        var isHas: Bool = false
        for model in dataSourceArr {
            if model.day == currentDayString {
                currentModel = model
                isHas = true
                break
            }
        }
        if isHas != true {
            currentDayString = ""
            currentModel = nil
            //AppUtilities.makeToast("没有数据～")
        }
        self.tableView.reloadData()
        self.showNoDataView()
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        SSLog("calendarCurrentPageDidChange\(calendar.currentPage)")
        currentDayString = ""
        currentModel = nil
        startTime = getTimeIntervalWidhtDate(date: self.calendar.currentPage)
        endTime = startTime + 86400 * 7
        refreshData()
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
            return [kAppWhiteColor]
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
            self?.isLookRecord = true
        }
        self.view.addSubview(titleview ?? ThorNavigationView.init(type: .backTitleRight))
        
        self.view.addSubview(calendar)
        
        self.view.sendSubviewToBack(calendar)
        
        SSLog("当前时间\(calendar.currentPage)")
        
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
        
        
        //第一次获取到的时间是上个月的最后一天 - 比之前要替桥一周 - 所以加一周的时间戳
        startTime = getTimeIntervalWidhtDate(date: self.calendar.currentPage) + 86400 * 1
        endTime = startTime + 86400 * 31
        refreshData()
    }
    
    func setUpData() {
        
    }
    
    func showNoDataView() {
        if currentModel?.scheduleViewModelList?.count ?? 0 > 0 {
            noDataView.isHidden = true
        }else {
            noDataView.isHidden = false
        }
    }
}

extension RenterHouseScheduleViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RenterHouseScheduleCell.reuseIdentifierStr) as? RenterHouseScheduleCell
        cell?.selectionStyle = .none
        if let scheduleList = currentModel?.scheduleViewModelList {
            
            if scheduleList.count > indexPath.row {
                cell?.viewModel = scheduleList[indexPath.row]
            }
            
            ///线条显示处理
            if scheduleList.count == 1 {
                cell?.topLineView.isHidden = true
                cell?.bottomLineView.isHidden = true
            }else {
                if indexPath.row == 0 {
                    cell?.topLineView.isHidden = true
                    cell?.bottomLineView.isHidden = false
                }else if indexPath.row == scheduleList.count - 1 {
                    cell?.topLineView.isHidden = false
                    cell?.bottomLineView.isHidden = true
                }
            }
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
        vc.scheduleId = currentModel?.scheduleViewModelList?[indexPath.row].scheduleId
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
        view.font = FONT_12
        view.textColor = kAppColor_666666
        return view
    }()
    //时间
    lazy var dateTimeLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_MEDIUM_15
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
        view.clipsToBounds = true
        view.layer.cornerRadius = button_cordious_2
        return view
    }()
    lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_MEDIUM_15
        return view
    }()
    
    lazy var companyLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_12
        view.textColor = kAppColor_666666
        return view
    }()
    
    lazy var stateLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .right
        view.font = FONT_MEDIUM_12
        return view
    }()
    lazy var descLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = FONT_12
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
        view.font = FONT_10
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
        return 120
    }
    
    var viewModel: ScheduleViewModelList = ScheduleViewModelList(model: ScheduleList()) {
        didSet {
            ///行程审核状态 0预约待接受 1预约成功 2预约失败 3已看房 4未看房
            bgView.backgroundColor = viewModel.autitBgViewColor
            timeIcon.image = UIImage.init(named: viewModel.autitStatusTimeIcon ?? "")
            stateLabel.text = viewModel.auditStatusString
            stateLabel.textColor = viewModel.autitStatusLabelColor
            nameLabel.textColor = viewModel.autitBuildingNameColor
            descLabel.textColor = viewModel.autitBuildingNameColor
            
            dateLabel.text = viewModel.dateTimeString
            dateTimeLabel.text = viewModel.hourMinuterTimeString
            nameLabel.text = viewModel.contactNameString
            companyLabel.text = viewModel.companyJobString
            descLabel.text = viewModel.schedulebuildingName
            addressLabel.text = viewModel.businessDistrict
            
            topLineView.backgroundColor = viewModel.autitStatusLabelColor
            bottomLineView.backgroundColor = viewModel.autitStatusLabelColor
        }
    }
    
    func setupViews() {
        
        addSubview(dateLabel)
        addSubview(dateTimeLabel)
        addSubview(bgView)
        addSubview(topLineView)
        addSubview(bottomLineView)
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
            make.width.equalTo(52)
            make.height.equalTo(20)
        }
        dateTimeLabel.snp.makeConstraints { (make) in
            make.leading.width.equalTo(dateLabel)
            make.top.equalTo(dateLabel.snp.bottom)
            make.height.equalTo(25)
        }
        timeIcon.snp.makeConstraints { (make) in
            make.leading.equalTo(dateLabel.snp.trailing)
            make.size.equalTo(20)
            make.centerY.equalToSuperview()
        }
        topLineView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.centerX.equalTo(timeIcon)
            make.bottom.equalTo(timeIcon.snp.top).offset(-4)
            make.width.equalTo(1.0)
        }
        bottomLineView.snp.makeConstraints { (make) in
            make.top.equalTo(timeIcon.snp.bottom).offset(4)
            make.centerX.equalTo(timeIcon)
            make.bottom.equalToSuperview()
            make.width.equalTo(1.0)
        }
        
        bgView.snp.makeConstraints { (make) in
            make.leading.equalTo(timeIcon.snp.trailing).offset(-10)
            make.top.equalTo(dateLabel)
            make.bottom.equalToSuperview()
            make.trailing.equalTo(-left_pending_space_17)
        }
        stateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(12)
            make.height.equalTo(28)
            make.trailing.equalToSuperview().offset(-13)
            make.width.equalTo(55)
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
            make.height.equalTo(22)
        }
        addressIcon.snp.makeConstraints { (make) in
            make.leading.equalTo(nameLabel)
            make.top.equalTo(descLabel.snp.bottom).offset(3)
            make.height.equalTo(20)
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

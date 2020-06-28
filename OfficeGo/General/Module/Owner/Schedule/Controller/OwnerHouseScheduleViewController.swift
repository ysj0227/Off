//
//  OwnerHouseScheduleViewController.swift
//  OfficeGo
//
//  Created by mac on 2020/6/18.
//  Copyright © 2020 Senwei. All rights reserved.
//

import HandyJSON
import SwiftyJSON


class OwnerHouseScheduleViewController: BaseTableViewController, FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    
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
        calendar.appearance.todayColor = kAppColor_757575
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
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let tab = self.navigationController?.tabBarController as? OwnerMainTabBarController
        tab?.customTabBar.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tab = self.navigationController?.tabBarController as? OwnerMainTabBarController
        tab?.customTabBar.isHidden = false
        
    }
    func getTimeIntervalWidhtDate(date: Date) -> Int {
        return Int(date.timeIntervalSince1970)
    }
    override func refreshData() {
        
        var params = [String:AnyObject]()
        params["token"] = UserTool.shared.user_token as AnyObject?
        params["startTime"] = startTime as AnyObject?
        params["endTime"] = endTime as AnyObject?
        
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
    
}


extension OwnerHouseScheduleViewController {
    
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
            AppUtilities.makeToast("没有数据～")
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
            return CGPoint(x: 0, y: 5)
        }
        return .zero
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventSelectionColorsFor date: Date) -> [UIColor]? {
        if self.datesWithEvent.contains(self.dateFormatter2.string(from: date)) {
            return [kAppBlueColor]
        }
        return nil
    }
}

extension OwnerHouseScheduleViewController {
    
    @objc func previousClicked() {
        let previousMonth = gregorian.date(byAdding: .day, value: -7, to: self.calendar.currentPage, options: NSCalendar.Options(rawValue: 0)) ?? Date()
        self.calendar.setCurrentPage(previousMonth, animated: true)
    }
    
    @objc func nextClicked() {
        let nextMonth = gregorian.date(byAdding: .day, value: 7, to: self.calendar.currentPage, options: NSCalendar.Options(rawValue: 0)) ?? Date()
        self.calendar.setCurrentPage(nextMonth, animated: true)
    }
    
    //MARK: 跳转到今天
    func scrollToDate() {
        SSLog("didSelect\(Date())")
        calendar.select(Date(), scrollToDate: true)
        currentDayString = self.dateFormatter2.string(from: Date())
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
        }
        self.tableView.reloadData()
        self.showNoDataView()
    }
    
    func setUpView() {
        
        titleview = ThorNavigationView.init(type: .backTitleRight)
        //设置背景颜色为蓝色 文字白色 -
        titleview?.backgroundColor = kAppBlueColor
        titleview?.backTitleRightView.backgroundColor = kAppClearColor
        titleview?.titleLabel.textColor = kAppWhiteColor
        titleview?.rightButton.setTitleColor(kAppWhiteColor, for: .normal)
        titleview?.rightButton.snp.remakeConstraints { (make) in
            make.trailing.equalToSuperview()
            make.width.equalTo(65)
            make.top.bottom.equalToSuperview()
        }
        titleview?.rightButton.setImage(UIImage.init(named: "whiteToday"), for: .normal)
        titleview?.leftButton.isHidden = true
        titleview?.rightButton.isHidden = false
        titleview?.rightButton.layoutButton(.imagePositionRight, margin: 2)
        titleview?.titleLabel.text = "看房行程"
        titleview?.leftButtonCallBack = { [weak self] in
            self?.leftBtnClick()
        }
        titleview?.rightBtnClickBlock = { [weak self] in
            self?.scrollToDate()
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
            make.bottom.equalToSuperview().offset(-bottomMargin())
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

extension OwnerHouseScheduleViewController {
    
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

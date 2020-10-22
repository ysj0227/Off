//
//  YLDatePicker.swift
//  YLDatePicker
//
//  Created by yl on 2017/11/15.
//  Copyright © 2017年 February12. All rights reserved.
//

import Foundation
import UIKit

fileprivate let YLDatePickerMargin:CGFloat = 0
fileprivate let YLDatePickerH:CGFloat = 270
typealias DoneBlock = (Date) -> ()

// 显示时间类型
public enum YLDatePickerType:String {
    case Y       // 年
    case YM      // 年月
    case MD      // 月日
    case YMD     // 年月日
    case YMDHm   // 年月日时分
    case MDHm    // 月日时分
    case Hm      // 时分
}

/// 记录
struct YLDateRecord {
    var year: String
    var month: String
    var day: String
    var hour: String
    var minute: String
}
/// 类型
enum YLDateComponent:Int {
    case year,month,day,hour,minute
}

public class YLDatePicker: UIView {
    
    fileprivate var doneBlock: DoneBlock?
    
    fileprivate var dataArray = [YLDateComponent:Array<String>]()
    fileprivate var dateComponentOrder = [YLDateComponent]()
    fileprivate var dateRecord: YLDateRecord!
    fileprivate var datePickerType: YLDatePickerType = .YMD // default 年月日
    
    fileprivate var datePicker: UIPickerView = {
        let datePicker = UIPickerView()
        datePicker.showsSelectionIndicator = false
        datePicker.backgroundColor = kAppWhiteColor
        return datePicker
    }()
    
    fileprivate var blackAlphabgView: UIButton = {
        let button = UIButton.init()
        button.backgroundColor = kAppAlphaWhite0_alpha_7
        button.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        return button
    }()
    
    fileprivate var backLabel: UILabel = {
        let label = UILabel()
        label.text = "看房时间"
        label.font = FONT_15
        label.textColor = kAppColor_666666
        label.backgroundColor = kAppWhiteColor
        label.textAlignment = .center
        return label
    }()
    
    fileprivate var minLimitDate = Date.init(timeIntervalSince1970: TimeInterval(0)) // 默认最小时间
    fileprivate var maxLimitDate = Date.init(timeIntervalSince1970: TimeInterval(9999999999)) // 默认最大时间
    
    convenience init(currentDate: Date?, minLimitDate: Date?, maxLimitDate: Date?, datePickerType: YLDatePickerType?, _ doneBlock: @escaping DoneBlock) {
        self.init()
        
        self.doneBlock = doneBlock
        
        let currentDate = currentDate ?? Date()
        let scrollToYear = String(currentDate.getComponent(component: .year))
        let scrollToMonth = addZero(currentDate.getComponent(component: .month))
        let scrollToDay = addZero(currentDate.getComponent(component: .day))
        let scrollToHour = addZero(currentDate.getComponent(component: .hour))
        let scrollToMinute = addZero(currentDate.getComponent(component: .minute))
        dateRecord = YLDateRecord(year: scrollToYear, month: scrollToMonth, day: scrollToDay, hour: scrollToHour, minute: scrollToMinute)
        
        if let minLimitDate = minLimitDate {
            self.minLimitDate = minLimitDate
        }
        if let maxLimitDate = maxLimitDate {
            self.maxLimitDate = maxLimitDate
        }
        if let datePickerType = datePickerType {
            self.datePickerType = datePickerType
        }
        
        layoutUI()
        
        loadData()
    }
    
    func layoutUI() {
        
        addSubview(blackAlphabgView)
        
        blackAlphabgView.frame = CGRect(x: 0, y: 0, width: kWidth, height: kHeight)
        
        //        // 背景文字
        addSubview(backLabel)
        backLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-YLDatePickerH + 57)
            make.height.equalTo(57)
        }
        
        // 按钮
        let doneButton = UIButton(type: .custom)
        doneButton.setTitle("取消", for: .normal)
        doneButton.setTitleColor(kAppColor_333333, for: .normal)
        doneButton.titleLabel?.font = FONT_15
        doneButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        addSubview(doneButton)
        doneButton.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.bottom.height.equalTo(backLabel)
            make.width.equalTo(60)
        }
        
        // 按钮
        let cancelButton = UIButton(type: .custom)
        cancelButton.setTitle("确定", for: .normal)
        cancelButton.setTitleColor(kAppBlueColor, for: .normal)
        cancelButton.titleLabel?.font = FONT_15
        cancelButton.addTarget(self, action: #selector(YLDatePicker.doneButtonHandle), for: .touchUpInside)
        addSubview(cancelButton)
        cancelButton.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview()
            make.bottom.height.equalTo(backLabel)
            make.width.equalTo(60)
        }
        
        // 时间控件
        datePicker.delegate = self
        datePicker.dataSource = self
        addSubview(datePicker)
        datePicker.snp.makeConstraints { (make) in
            make.trailing.leading.bottom.equalToSuperview()
            make.height.equalTo(YLDatePickerH - 57)
            make.bottom.equalToSuperview()
        }
        
        UIApplication.shared.keyWindow?.addSubview(self)

        blackAlphabgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismiss)))
        
    }
    
    func loadData() {
        
        // 获取对应数据
        for char in String(describing: datePickerType) {
            switch char {
            case "Y":
                dataArray[.year] = getYears()
                dateComponentOrder.append(.year)
            case "M":
                dataArray[.month] = getMonths()
                dateComponentOrder.append(.month)
            case "D":
                dataArray[.day] = getDays()
                dateComponentOrder.append(.day)
            case "H":
                dataArray[.hour] = getHours()
                dateComponentOrder.append(.hour)
            case "m":
                dataArray[.minute] = getMinute()
                dateComponentOrder.append(.minute)
            default:
                break
            }
        }
        
        // 刷新数据
        datePicker.reloadAllComponents()
        //        backLabel.text = dateRecord.year
        
        // 滚动到指定时间
        scrollToDate(components: dateComponentOrder, animated: false)
        
    }
    
    @objc func doneButtonHandle() {
        
        if let date = Date.getDate(dateStr: "\(dateRecord.year)-\(dateRecord.month)-\(dateRecord.day) \(dateRecord.hour):\(dateRecord.minute)", format: "yyyy-MM-dd HH:mm") {
            
            doneBlock?(date)
        }
        
        dismiss()
    }
    
    public func show() {
        self.frame = blackAlphabgView.frame
    }
    
    @objc public func dismiss() {
        self.removeFromSuperview()
    }
}

extension YLDatePicker: UIPickerViewDelegate, UIPickerViewDataSource {
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return dataArray.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let dateComponent = dateComponentOrder[component]
        return dataArray[dateComponent]?.count ?? 0
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let dateComponent = dateComponentOrder[component]
        return dataArray[dateComponent]?[row]
        
    }
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let dateComponent = dateComponentOrder[component]
        
        switch dateComponent {
        case .year:
            dateRecord.year = dataArray[.year]![row]
        //            backLabel.text = dateRecord.year
        case .month:
            dateRecord.month = dataArray[.month]![row]
        case .day:
            dateRecord.day = dataArray[.day]![row]
        case .hour:
            dateRecord.hour = dataArray[.hour]![row]
        case .minute:
            dateRecord.minute = dataArray[.minute]![row]
        }
        reload(dateComponent: dateComponent)
    }
}

// MARK: - 工具
extension YLDatePicker {
    
    func addZero(_ num: Int) -> String {
        return num < 10 ? ("0" + String(num)):String(num)
    }
    // 获取年份
    func getYears() -> Array<String> {
        var years = [String]()
        for year in minLimitDate.getComponent(component: .year)...maxLimitDate.getComponent(component: .year) {
            years.append(String(year))
        }
        return years
    }
    // 获取月份
    func getMonths() -> Array<String> {
        var months = [String]()
        
        var minMonth = 1
        if Int(dateRecord.year) == minLimitDate.getComponent(component: .year) {
            minMonth = minLimitDate.getComponent(component: .month)
        }
        var maxMonth = 12
        if Int(dateRecord.year) == maxLimitDate.getComponent(component: .year) {
            maxMonth = maxLimitDate.getComponent(component: .month)
        }
        
        for month in minMonth...maxMonth {
            months.append(month < 10 ? ("0" + String(month)):String(month))
        }
        return months
    }
    // 获取天数
    func getDays() -> Array<String> {
        var days = [String]()
        
        var minDay = 1
        if Int(dateRecord.year) == minLimitDate.getComponent(component: .year) && Int(dateRecord.month) == minLimitDate.getComponent(component: .month) {
            minDay = minLimitDate.getComponent(component: .day)
        }
        var maxDay = getMaxDays(year: Int(dateRecord.year)!, month: Int(dateRecord.month)!)
        if Int(dateRecord.year) == maxLimitDate.getComponent(component: .year) && Int(dateRecord.month) == maxLimitDate.getComponent(component: .month) {
            maxDay = maxLimitDate.getComponent(component: .day)
        }
        
        for day in minDay...maxDay {
            days.append(day < 10 ? ("0" + String(day)):String(day))
        }
        return days
    }
    // 获取小时
    func getHours() -> Array<String> {
//        let hours = ["00", "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23"]

        
        var hours = [String]()
        
        var minHour = 0
        if Int(dateRecord.year) == minLimitDate.getComponent(component: .year) && Int(dateRecord.month) == minLimitDate.getComponent(component: .month) &&
            Int(dateRecord.day) == minLimitDate.getComponent(component: .day) {
            minHour = minLimitDate.getComponent(component: .hour)
        }
        var maxHour = 23
        if Int(dateRecord.year) == maxLimitDate.getComponent(component: .year) && Int(dateRecord.month) == maxLimitDate.getComponent(component: .month) &&
            Int(dateRecord.day) == maxLimitDate.getComponent(component: .day) {
            maxHour = maxLimitDate.getComponent(component: .hour)
        }
        
        for hour in minHour...maxHour {
            hours.append(hour < 10 ? ("0" + String(hour)):String(hour))
        }
        return hours
    }
    // 获取分钟
    func getMinute() -> Array<String> {
//        let minutes = ["00", "15", "30", "45", "59"]
        
        var minutes = [String]()
        var minMinute = 0
        if Int(dateRecord.year) == minLimitDate.getComponent(component: .year) && Int(dateRecord.month) == minLimitDate.getComponent(component: .month) &&
            Int(dateRecord.day) == minLimitDate.getComponent(component: .day) &&
            Int(dateRecord.hour) == minLimitDate.getComponent(component: .hour) {
            minMinute = minLimitDate.getComponent(component: .minute)
        }
        var maxMinute = 59
        if Int(dateRecord.year) == maxLimitDate.getComponent(component: .year) && Int(dateRecord.month) == maxLimitDate.getComponent(component: .month) &&
            Int(dateRecord.day) == maxLimitDate.getComponent(component: .day) &&
            Int(dateRecord.hour) == maxLimitDate.getComponent(component: .hour) {
            maxMinute = maxLimitDate.getComponent(component: .minute)
        }
        
        for minute in minMinute...maxMinute {
            minutes.append(minute < 10 ? ("0" + String(minute)):String(minute))
        }
        return minutes
    }
    // 获取对应年月的天数
    func getMaxDays(year: Int, month: Int) -> Int {
        
        let isLeapYear = year % 4 == 0 ? (year % 100 == 0 ? (year % 400 == 0 ? true:false):true):false
        switch month {
        case 1,3,5,7,8,10,12:
            return 31
        case 4,6,9,11:
            return 30
        case 2:
            return isLeapYear ? 29 : 28
        default:
            return 30
        }
    }
    // 滚动到指定时间
    func scrollToDate(components:[YLDateComponent], animated: Bool) {
        
        for c in components {
            
            var timeString: String?
            
            switch c {
            case .year:
                timeString = dateRecord.year
            case .month:
                timeString = dateRecord.month
            case .day:
                timeString = dateRecord.day
            case .hour:
                timeString = dateRecord.hour
            case .minute:
                timeString = dateRecord.minute
            }
            
            guard let component = dateComponentOrder.firstIndex(of: c),
                let timeStr = timeString,
                let row = dataArray[c]?.firstIndex(of: timeStr)
                else {return}
            
            datePicker.selectRow(row, inComponent: component, animated: animated)
        }
    }
    // 刷新数据
    func reload(dateComponent:YLDateComponent) {
        
        guard let index = dateComponentOrder.firstIndex(of: dateComponent) else {return}
        
        var components = [YLDateComponent]()
        
        for (i,c) in dateComponentOrder.enumerated() {
            if i > index {
                components.append(c)
                switch c {
                case .month:
                    dataArray[.month]?.removeAll()
                    dataArray[.month] = getMonths()
                    datePicker.reloadComponent(dateComponentOrder.firstIndex(of: .month)!)
                    if Int(dateRecord.month)! < Int(dataArray[.month]!.first!)! {
                        dateRecord.month = dataArray[.month]!.first!
                    }else if Int(dateRecord!.month)! > Int(dataArray[.month]!.last!)! {
                        dateRecord.month = dataArray[.month]!.last!
                    }
                case .day:
                    dataArray[.day]?.removeAll()
                    dataArray[.day] = getDays()
                    datePicker.reloadComponent(dateComponentOrder.firstIndex(of: .day)!)
                    if Int(dateRecord.day)! < Int(dataArray[.day]!.first!)! {
                        dateRecord.day = dataArray[.day]!.first!
                    }else if Int(dateRecord.day)! > Int(dataArray[.day]!.last!)! {
                        dateRecord.day = dataArray[.day]!.last!
                    }
                case .hour:
                    dataArray[.hour]?.removeAll()
                    dataArray[.hour] = getHours()
                    datePicker.reloadComponent(dateComponentOrder.firstIndex(of: .hour)!)
                    if Int(dateRecord.hour)! < Int(dataArray[.hour]!.first!)! {
                        dateRecord.hour = dataArray[.hour]!.first!
                    }else if Int(dateRecord.hour)! > Int(dataArray[.hour]!.last!)! {
                        dateRecord.hour = dataArray[.hour]!.last!
                    }
                case .minute:
                    dataArray[.minute]?.removeAll()
                    dataArray[.minute] = getMinute()
                    datePicker.reloadComponent(dateComponentOrder.firstIndex(of: .minute)!)
                    if Int(dateRecord.minute)! < Int(dataArray[.minute]!.first!)! {
                        dateRecord.minute = dataArray[.minute]!.first!
                    }else if Int(dateRecord.minute)! > Int(dataArray[.minute]!.last!)! {
                        dateRecord.minute = dataArray[.minute]!.last!
                    }
                default:
                    break
                }
            }
        }
        
        scrollToDate(components: components, animated: false)
    }
}

//
//  DateExtension.swift
//  OfficeGo
//
//  Created by DENGFei on 2020/4/26.
//  Copyright © 2020 Senwei. All rights reserved.
//

import Foundation

extension Date {
    static func date(fromString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter.date(from:fromString)
    }
    
    public func localDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.string(from: self)
    }
    
    public func yyyyMMddString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
    
    func getString(format: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = format
        
        let dateString = dateFormatter.string(from: self)
        return dateString
    }
    
    static func getDate(dateStr: String, format: String) -> Date? {
          
          let dateFormatter = DateFormatter()
          dateFormatter.locale = Locale.current
          dateFormatter.timeZone = TimeZone.current
          dateFormatter.dateFormat = format
          
          let date = dateFormatter.date(from: dateStr)
          return date
      }
      
      func getComponent(component: Calendar.Component) -> Int {
          let calendar = Calendar.current
          return calendar.component(component, from: self)
      }
}

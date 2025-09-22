//
//  Date+Extension.swift
//  MobileTest
//
//  Created by 彭玮君 on 2025/9/21.
//

import Foundation
extension Date {
    
    var isPastDate: Bool {
        return self < Date()
    }
    
    func isSameDayWith(date2: Date) -> Bool {
        return  Calendar.current.isDate(self, inSameDayAs:date2)
    }
    
    func toString(format: String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "zh")
        return formatter.string(from: self)
    }
    
    func dateAndTimetoString(format: String = "yyyy-MM-dd HH:mm") -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func timeIn24HourFormat() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }
}

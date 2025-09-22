//
//  String+Extension.swift
//  MobileTest
//
//  Created by 彭玮君 on 2025/9/21.
//

import Foundation
extension String {
    func toDate() -> Date? {
        if let intel = TimeInterval(self) {
            return Date(timeIntervalSince1970: intel)
        }
        return nil
    }
    
    func toDateString(format: String = "yyyy-MM-dd") -> String {
        if let date = toDate(){
            return date.toString(format: format)
        }
        return ""
    }
    
    func timeIn24HourFormat() -> String {
        if let date = toDate(){
            return date.timeIn24HourFormat()
        }
        return ""
    }
}

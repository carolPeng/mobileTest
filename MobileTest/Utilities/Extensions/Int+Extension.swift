//
//  Int+Extension.swift
//  MobileTest
//
//  Created by 彭玮君 on 2025/9/22.
//

import Foundation
extension Int {
    
    func timerHourFormatted() -> String {
        let seconds: Int = self % 60
        let minutes: Int = (self / 60) % 60
        let hour: Int = (self / 3600 ) % 3600
        return String(format: "%02d:%02d:%02d", hour, minutes, seconds)
    }
    
    func timerMinuteFormatted() -> String {
        let seconds: Int = self % 60
        let minutes: Int = (self / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

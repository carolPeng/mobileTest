//
//  Booking.swift
//  MobileTest
//
//  Created by 彭玮君 on 2025/9/20.
//

import Foundation

struct Booking: Codable, Identifiable {
    /// 船唯一标志
    let shipReference: String
    ///船token
    let shipToken: String
    /// 是否发出检票
    let canIssueTicketChecking: Bool
    /// 有效时间
    let expiryTime: String
    /// 持续时间
    let duration: Int
    /// 分片
    let segments: [Segment]
    
    var id: String { shipReference }
}

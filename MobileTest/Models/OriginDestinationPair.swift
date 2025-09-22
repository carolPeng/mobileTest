//
//  OriginDestinationPair.swift
//  MobileTest
//
//  Created by 彭玮君 on 2025/9/20.
//

import Foundation
struct OriginDestinationPair: Codable {
    /// 终点信息
    let destination: Location
    /// 终点城市
    let destinationCity: String
    /// 起点信息
    let origin: Location
    /// 起点城市
    let originCity: String
}

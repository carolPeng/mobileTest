//
//  Segment.swift
//  MobileTest
//
//  Created by 彭玮君 on 2025/9/20.
//

import Foundation

struct Segment: Codable, Identifiable {
    let id: Int
    
    /// 起终点
    let originAndDestinationPair: OriginDestinationPair
}

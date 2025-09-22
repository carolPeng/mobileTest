//
//  BookingService.swift
//  MobileTest
//
//  Created by 彭玮君 on 2025/9/20.
//

import Foundation
import Combine

class BookingService {
    static let shared = BookingService()
    
    private init() {}
    
    func fetchBooking() -> AnyPublisher<Booking, Error> {
        // 模拟网络请求延迟
        return Future<Booking, Error> { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
                // 从本地JSON文件读取数据（模拟网络响应）
                if let url = Bundle.main.url(forResource: "booking", withExtension: "json") {
                    do {
                        let data = try Data(contentsOf: url)
                        let decoder = JSONDecoder()
                        let booking = try decoder.decode(Booking.self, from: data)
                        promise(.success(booking))
                    } catch {
                        promise(.failure(error))
                    }
                } else {
                    promise(.failure(NSError(domain: "ServiceError", code: 404)))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

//
//  BookingDataManager.swift
//  MobileTest
//
//  Created by 彭玮君 on 2025/9/20.
//

import Foundation
import Combine

/// Booking数据源
class BookingDataManager: ObservableObject {
    static let shared = BookingDataManager()
    
    @Published var currentBooking: Booking?
    @Published var isLoading = false
    @Published var error: Error?
    
    private var cancellables = Set<AnyCancellable>()
    /// 2分钟缓存有效期，存UserDefaults
    private let cacheExpiryTime: TimeInterval = 0
    
    private init() {
        loadCachedBooking()
    }
    
    // 从缓存加载数据
    private func loadCachedBooking() {
        do {
            let bookings = try SQLiteManager.shared.getAllBookings()
            if isCacheValid(),let cachedBooking = bookings.first{
                self.currentBooking = cachedBooking
                print("Loaded booking from cache: \(cachedBooking)")
            }
        } catch {
            print("Error loading cached booking: \(error)")
        }
    }
    
    // 检查缓存是否有效
    private func isCacheValid() -> Bool {
        let cacheExpiryTime = UserDefaults.standard.double(forKey: "cacheExpiryTime")
        if cacheExpiryTime == 0{
            return false
        }
        let expiryDate = Date(timeIntervalSince1970: cacheExpiryTime)
        return expiryDate > Date()
    }
    
    // 刷新数据
    func refreshBooking() {
        isLoading = true
        error = nil
        
        BookingService.shared.fetchBooking()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.error = error
                    print("Error fetching booking: \(error)")
                }
            } receiveValue: { [weak self] booking in
                self?.currentBooking = booking
                self?.cacheBooking(booking)
                UserDefaults.standard.setValue(Date().timeIntervalSince1970+120, forKey: "cacheExpiryTime")//假设数据 2 分钟过期
                print("Fetched new booking: \(booking)")
            }
            .store(in: &cancellables)
    }
    
    /// 缓存数据
    /// - Parameter booking: 数据
    private func cacheBooking(_ booking: Booking) {
        do {
//            try SQLiteManager.shared.clearAllBookings()
            try SQLiteManager.shared.saveBooking(booking)
            print("Booking cached successfully")
        } catch {
            print("Error caching booking: \(error)")
        }
    }
    
    // 获取当前数据（如果缓存无效则刷新）
    func getBooking() -> Booking? {
        if let booking = currentBooking, isCacheValid() {
            return booking
        } else {
            refreshBooking()
            return nil
        }
    }
    
    // 强制刷新
    func forceRefresh() {
        refreshBooking()
    }
    
    // 清除缓存
    func clearCache() {
        do {
            try SQLiteManager.shared.clearAllBookings()
            currentBooking = nil
            print("Cache cleared")
        } catch {
            print("Error clearing cache: \(error)")
        }
    }
}

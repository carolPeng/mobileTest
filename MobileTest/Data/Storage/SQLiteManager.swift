//
//  SQLiteManager.swift
//  MobileTest
//
//  Created by 彭玮君 on 2025/9/20.
//

// SQLiteManager.swift
import Foundation
import SQLite

class SQLiteManager {
    static let shared = SQLiteManager()
    private var db: Connection?
    
    /// 表
    private let bookingsTable = Table("bookings")
    private let id = Expression<String>("id")
    private let data = Expression<Data>("data")
    private let timestamp = Expression<Date>("timestamp")
    private let version = Expression<Int>("version")
    
    private init() {
        setupDatabase()
    }
    
    /// 设置数据库
    private func setupDatabase() {
        do {
            let path = NSSearchPathForDirectoriesInDomains(
                .documentDirectory, .userDomainMask, true
            ).first!
            
            db = try Connection("\(path)/bookings.sqlite3")
            
            try db?.run(bookingsTable.create(ifNotExists: true) { t in
                t.column(id, primaryKey: true)
                t.column(data)
                t.column(timestamp)
                t.column(version)
            })
        } catch {
            print("SQLite setup error: \(error)")
        }
    }
    
    /// 新增或更新
    /// - Parameter booking: 数据
    func saveBooking(_ booking: Booking) throws {
        guard let db = db else { throw NSError(domain: "SQLiteError", code: 1) }
        
        let encoder = JSONEncoder()
        let bookingData = try encoder.encode(booking)
        
        let update = bookingsTable.filter(id == booking.id)
                    .update(
                        data <- bookingData,
                        timestamp <- Date(),
                        version += 1  // 版本号自增
                    )
        let changes = try db.run(update)
        if changes == 0 {//新增
            let insert = bookingsTable.insert(
                id <- booking.id,
                data <- bookingData,
                timestamp <- Date(),
                version <- 0
            )
            try db.run(insert)
        }
    }
    
    /// 获取单个booking
    /// - Parameter bookingId: id
    /// - Returns: 数据
    func getBooking(byId bookingId: String) throws -> Booking? {
        guard let db = db else { throw NSError(domain: "SQLiteError", code: 1) }
        
        let query = bookingsTable.filter(id == bookingId)
        if let row = try db.pluck(query) {
            let decoder = JSONDecoder()
            return try decoder.decode(Booking.self, from: row[data])
        }
        
        return nil
    }
    
    /// 获取所有数据
    /// - Returns: 数据列表
    func getAllBookings() throws -> [Booking] {
        guard let db = db else { throw NSError(domain: "SQLiteError", code: 1) }
        
        var bookings: [Booking] = []
        let decoder = JSONDecoder()
        
        for row in try db.prepare(bookingsTable) {
            if let booking = try? decoder.decode(Booking.self, from: row[data]) {
                bookings.append(booking)
            }
        }
        
        return bookings
    }
    
    /// 删除单个booking
    /// - Parameter bookingId: id
    func deleteBooking(byId bookingId: String) throws {
        guard let db = db else { throw NSError(domain: "SQLiteError", code: 1) }
        
        let booking = bookingsTable.filter(id == bookingId)
        try db.run(booking.delete())
    }
    
    /// 清除所有booking
    func clearAllBookings() throws {
        guard let db = db else { throw NSError(domain: "SQLiteError", code: 1) }
        
        try db.run(bookingsTable.delete())
    }
}

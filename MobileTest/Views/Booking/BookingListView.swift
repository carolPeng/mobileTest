//
//  BookingListView.swift
//  MobileTest
//
//  Created by 彭玮君 on 2025/9/20.
//

// BookingListView.swift
import SwiftUI

struct BookingListView: View {
    @StateObject private var dataManager = BookingDataManager.shared
    @State private var hasAppeared = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                if dataManager.isLoading {
                    ProgressView("Loading...")
                        .padding()
                } else if let error = dataManager.error {
                    ErrorView(error: error, onRetry: {
                        dataManager.refreshBooking()
                    })
                } else if let booking = dataManager.currentBooking {
                    VStack(alignment: .leading) {
                        Text("是否开始检票：\(booking.canIssueTicketChecking ? "是":"否")")
                            .foregroundColor(.gray)
                        Text("有效时间：\( booking.expiryTime.toDateString())")
                            .foregroundColor(.gray)
                        Text("持续时长：\( booking.duration.timerHourFormatted())")
                            .foregroundColor(.gray)
                    }
                    .navigationTitle("Booking Details")
                    .padding()
                
                    List(booking.segments) { segment in
                        SegmentRow(segment: segment)
                    }
                    
                    .refreshable {
                        dataManager.refreshBooking()
                    }
                } else {
                    Text("No booking data available")
                        .foregroundColor(.gray)
                }
            }
            .onAppear {
                if !hasAppeared {
                    hasAppeared = true
                    // 每次页面出现时获取数据
                    if let booking = dataManager.getBooking() {
                        print("Booking data: \(booking)")
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        dataManager.forceRefresh()
                    }) {
                        Image(systemName: "arrow.clockwise")
                        Text("强制刷新")
                    }
                }
            }
        }
    }
}

struct SegmentRow: View {
    let segment: Segment
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("站点 \(segment.id)")
                .font(.headline)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("起始平台: \(segment.originAndDestinationPair.origin.displayName)")
                    Text("终点平台: \(segment.originAndDestinationPair.destination.displayName)")
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text(segment.originAndDestinationPair.originCity)
                    Text(segment.originAndDestinationPair.destinationCity)
                }
                .foregroundColor(.secondary)
                .font(.subheadline)
            }
        }
        .padding(.vertical, 4)
    }
}

struct ErrorView: View {
    let error: Error
    let onRetry: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Error data")
                .font(.headline)
            
            Text(error.localizedDescription)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button("Retry", action: onRetry)
                .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

#Preview {
    BookingListView()
}

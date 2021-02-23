//
//  DayViewModel.swift
//  at-calendar-ios
//
//  Created by 五加一 on 2021/2/23.
//

import Foundation

class DayViewViewModel {

    init(with date: Date) {
        self.date = date
    }

    private let date: Date
    private static let dateFormetter = DateFormatter()
}
// MARK: - DayViewViewModelSpec
extension DayViewViewModel: DayViewViewModelSpec {
    var isAvailable: Bool {
        Calendar.current.dateInterval(of: .day, for: Date())?.start.timeIntervalSince(date) ?? .zero <= .zero
    }
    var title: String {
        Self.dateFormetter.dateFormat = "E"
        return Self.dateFormetter.string(from: date)
    }
    var content: String {
        Self.dateFormetter.dateFormat = "dd"
        return Self.dateFormetter.string(from: date)
    }
}

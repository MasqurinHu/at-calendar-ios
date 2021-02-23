//
//  TimeViewModel.swift
//  at-calendar-ios
//
//  Created by 五加一 on 2021/2/23.
//

import Foundation

class TimeViewModel {
    let isAvailable: Bool

    init(with date: Date, isAvailable: Bool) {
        self.date = date
        self.isAvailable = isAvailable
    }

    private let date: Date
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
}
// MARK: - TextCollectionViewCellViewModelSpec
extension TimeViewModel: TextCollectionViewCellViewModelSpec {
    var text: String { Date().timeIntervalSince(date) <= .zero ? dateFormatter.string(from: date) : "" }
}

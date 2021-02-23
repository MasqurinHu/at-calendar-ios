//
//  TimeViewModel.swift
//  at-calendar-ios
//
//  Created by 五加一 on 2021/2/23.
//

import Foundation

class TimeViewModel {

    init(with date: Date) {
        self.date = Date()
    }

    private let date: Date
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
}

extension TimeViewModel: TextCollectionViewCellViewModelSpec {
    var text: String { isAvailable ? dateFormatter.string(from: date) : "" }
    var isAvailable: Bool { Date().timeIntervalSince(date) <= .zero }
}

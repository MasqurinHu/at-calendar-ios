//
//  CalendartRepository.swift
//  at-calendar-ios
//
//  Created by 五加一 on 2021/2/23.
//

import Foundation

enum CalendarError: Error {
    case getError
}

struct DummyCalendartRepository: CalendartRepositorySpec {

    func getCalendart(with timeIntervalSince1970: Int, doneHandle: @escaping ((Result<[(Date, Bool)], Error>) -> Void)) {
        let date = Date(timeIntervalSince1970: Double(timeIntervalSince1970))
        let calendar = Calendar.current
        guard
            let newDate = calendar.dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: date).date,
            let endDate =  calendar.dateInterval(of: .weekOfMonth, for: newDate)?.end
        else {
            doneHandle(.failure(CalendarError.getError))
            return
        }
        var temp: Date = newDate
        var tempList = [(Date, Bool)]()
        let thirtyMin: Double = -1800
        while temp.timeIntervalSince(endDate) < thirtyMin {
            guard let next = calendar.nextDate(
                    after: temp,
                    matching: DateComponents(minute: Bool.random() ? .zero : 30),
                    matchingPolicy: .nextTime)
            else { continue }
            temp = next
            if Int.random(in: 0 ..< 4) == .zero {
                tempList.append((next, Bool.random()))
            }
        }
        doneHandle(.success(tempList))
    }
}

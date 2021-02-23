//
//  DummyCalendartRepository.swift
//  at-calendar-ios
//
//  Created by 五加一 on 2021/2/24.
//

import Foundation

struct DummyCalendartRepository: CalendartRepositorySpec {

    func getCalendart(with timeIntervalSince1970: Int, doneHandle: @escaping ((Result<[(Date, Bool)], Error>) -> Void)) {
        let date = Date(timeIntervalSince1970: Double(timeIntervalSince1970))
        let calendar = Calendar.current
        guard
            let newDate = calendar.dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: date).date,
            let endDate =  calendar.dateInterval(of: .weekOfMonth, for: newDate)?.end
        else {
            doneHandle(.failure(CalendarError.dummyError))
            return
        }
        let allTimeInterval = endDate.timeIntervalSince(newDate)
        let count = Int.random(in: 20 ..< Int(allTimeInterval / 1800))
        let timeInterval = allTimeInterval / Double(count)
        var temp = newDate
        var tempList = [(Date, Bool)]()
        for _ in .zero ..< count {
            let nextDate = temp.addingTimeInterval(timeInterval)
            guard let next = calendar.nextDate(
                    after: nextDate,
                    matching: progressDateComponents(last: nextDate, gapMinutes: 30),
                    matchingPolicy: .nextTime)
            else { continue }
            if Int.random(in: .zero ..< 4) == .zero {
                tempList += progressReturnData(start: temp, End: next,available: nil, gapMinutes: 30, gapSeconds: 1800)
            }
            temp = next
        }
        doneHandle(.success(tempList))
    }
}

//
//  CalendartRepository.swift
//  at-calendar-ios
//
//  Created by 五加一 on 2021/2/23.
//

import Foundation

enum CalendarError: Error {
    case dummyError, apiError
}

struct CalendartRepository: CalendartRepositorySpec {
    let apiDataSourceSpec: NormalApiDataSourceSpec

    func getCalendart(with timeIntervalSince1970: Int, doneHandle: @escaping ((Result<[(Date, Bool)], Error>) -> Void)) {
        apiDataSourceSpec.getCalendart(with: timeIntervalSince1970) { result in
            switch result {
            case .success(let models):
                var temp = [(Date, Bool)]()
                models.available.forEach({
                    temp += progressReturnData(start: $0.start, End: $0.end,available: true, gapMinutes: 30, gapSeconds: 1800)
                })
                models.booked.forEach({
                    temp += progressReturnData(start: $0.start, End: $0.end,available: false, gapMinutes: 30, gapSeconds: 1800)
                })
                doneHandle(.success(temp))
            case .failure(let error):
                doneHandle(.failure(error))
            }
        }
    }
}

extension CalendartRepositorySpec {

    func progressReturnData(
        start: Date,
        End: Date,
        available: Bool?,
        gapMinutes: Int,
        gapSeconds: Double) -> ([(Date, Bool)]) {

        var bool: Bool
        if let available = available {
            bool = available
        } else {
            bool = Bool.random()
        }
        let calendar = Calendar.current
        var temp: Date = start
        var tempList = [(start, bool)]
        while temp.timeIntervalSince(End) < -gapSeconds {
            guard let next = calendar.nextDate(
                    after: temp,
                    matching: progressDateComponents(last: temp, gapMinutes: gapMinutes),
                    matchingPolicy: .nextTime)
            else { continue }
            temp = next

            tempList.append((next, bool))
        }
        return tempList
    }

    func progressDateComponents(last date: Date, gapMinutes: Int) -> DateComponents {
        DateComponents(minute: Calendar.current.component(.minute, from: date) >= gapMinutes ? .zero : gapMinutes)
    }
}

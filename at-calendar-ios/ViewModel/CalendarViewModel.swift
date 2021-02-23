//
//  CalendarViewModel.swift
//  at-calendar-ios
//
//  Created by 五加一 on 2021/2/22.
//

import Foundation

protocol CalendarRouterDelegate: AnyObject {
    func closeAction()
}

class CalendarViewModel {
    
    init(routerDelegate: CalendarRouterDelegate, calendarRepository: CalendartRepositorySpec) {
        router = routerDelegate
        self.calendarRepository = calendarRepository
    }

    private let calendarRepository: CalendartRepositorySpec
    private let dateFormatter = DateFormatter()
    private let calendar = Calendar.current

    private var selectDate = Date()
    private var dayList: (([DayViewViewModelSpec]) -> Void)?
    private var timeList: (([TextCollectionViewCellViewModelSpec]) -> Void)?
    private var isEnable: ((Bool) -> Void)?
    private var dayRange: ((String) -> Void)?

    private weak var router: CalendarRouterDelegate?
}
// MARK: - CalendarViewViewModelSpec
extension CalendarViewModel: CalendarViewViewModelSpec {
    var title: String { NSLocalizedString("CalendarTitle", comment: "Available times") }
    var closeBtnTitle: String { NSLocalizedString("CalendarClose", comment: "close") }
    
    func timeListDidChange(_ timeList: @escaping ([TextCollectionViewCellViewModelSpec]) -> Void) {
        self.timeList = timeList
        getData(with: Date())
    }

    func dayListDidChange(_ dayList: @escaping ([DayViewViewModelSpec]) -> Void) {
        self.dayList = dayList
    }
    
    func lastBtnEnableDidChange(_ isEnable: @escaping (Bool) -> Void) {
        self.isEnable = isEnable
    }
    
    func lastBtnAction() {
        guard let newDate =  calendar.dateInterval(of: .weekOfMonth, for: selectDate)?.start.addingTimeInterval(-1) else {
            return
        }
        selectDate = newDate
        getData(with: newDate)
    }
    
    func nextBtnAction() {
        guard let newDate =  calendar.dateInterval(of: .weekOfMonth, for: selectDate)?.end else {
            return
        }
        selectDate = newDate
        getData(with: newDate)
    }
    
    func dayRangeDidChange(_ dayRange: @escaping (String) -> Void) {
        self.dayRange = dayRange
    }
    
    func descriptionDidChange(_ description: (String) -> Void) {
        let gmt = (TimeZone.current.abbreviation() ?? "")
        let location = TimeZone.current.identifier
        let text = NSLocalizedString("CalendarDescription", comment: "CalendarDescription") + " \(location) (\(gmt))"
        description(text)
    }
    
    func closeBtnAction() {
        router?.closeAction()
    }
}

private extension CalendarViewModel {

    func getData(with date: Date) {
        progressDay(with: date)
        let timeInterval = Int(date.timeIntervalSince1970)
        calendarRepository.getCalendart(with: timeInterval, doneHandle: { [weak self] result in
            switch result {
            case .success(let models):
                self?.progressTime(with: models, select: date)
            case .failure(let error):
                print(error)
                break
            }
        })
    }

    func progressDay(with date: Date) {
        guard
            let newDate = calendar.dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: date).date,
            let endDate =  calendar.dateInterval(of: .weekOfMonth, for: newDate)?.end
        else {
            return
        }
        progressDayRange(start: newDate, end: endDate)
        progressLastBtnCanClick(with: newDate)
        var temp: Date = newDate
        var tempList = [newDate]
        while temp.timeIntervalSince(endDate) < .zero {
            guard let next = calendar.nextDate(
                    after: temp,
                    matching: DateComponents(hour: .zero),
                    matchingPolicy: .nextTime)
            else { continue }
            temp = next
            tempList.append(next)
        }
        dayList?(tempList.map({ DayViewViewModel(with: $0) }))
    }

    func progressDayRange(start: Date, end: Date) {
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let prefix = dateFormatter.string(from: start)
        dateFormatter.dateFormat = "dd"
        let suffix = dateFormatter.string(from: end)
        dayRange?(prefix + " - " + suffix)
    }

    func progressLastBtnCanClick(with date: Date) {
        isEnable?(Date().timeIntervalSince(date) < .zero)
    }

    func progressTime(with models: [(Date, Bool)], select date: Date) {
        guard
            let startDate = calendar.dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: date).date,
            let endDate =  calendar.dateInterval(of: .weekOfMonth, for: date)?.end else { return }
        var models = models
            .filter({ $0.0.timeIntervalSince(endDate) < . zero })
            .filter({ Date().timeIntervalSince($0.0) < . zero })
            .filter({ startDate.timeIntervalSince($0.0) < . zero })
            .sorted { $0.0 < $1.0 }
        dateFormatter.dateFormat = "dd"
        var tempContent = Array(repeating: [(Date, Bool)](), count: 7)
        models.enumerated().forEach({
            let week = calendar.component(.weekday, from: $0.element.0) - 1
            guard tempContent.count > week else { return }
            tempContent[week].append($0.element)
        })
        models.removeAll()
        var checkCode = 0x0000000
        let checkNumber = 127
        while checkCode != checkNumber {
            tempContent.enumerated().forEach { model in
                if tempContent[model.offset].count > .zero {
                    let subModel = tempContent[model.offset].removeFirst()
                    models.append(subModel)
                } else {
                    let check = 0x0000001 << model.offset
                    checkCode = checkCode | check
                    models.append((Date(timeIntervalSince1970: .zero), false))
                }
            }
        }
        timeList?(models.map({ TimeViewModel(with: $0.0, isAvailable: $0.1) }))
    }
}

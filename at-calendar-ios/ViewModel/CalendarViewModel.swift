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
    
    init(routerDelegate: CalendarRouterDelegate) {
        router = routerDelegate
    }
    
    private weak var router: CalendarRouterDelegate?
}
// MARK: - CalendarViewViewModelSpec
extension CalendarViewModel: CalendarViewViewModelSpec {

    func dayListDidChange(_ dayList: ([DayViewViewModelSpec]) -> Void) {
        dayList(Array(repeating: DayViewViewModel(), count: 7))
    }

    var title: String { NSLocalizedString("CalendarTitle", comment: "Available times") }
    
    func lastBtnEnableDidChange(_ isEnable: (Bool) -> Void) {
        isEnable(false)
    }
    
    func lastBtnAction() {
        print("last")
    }
    
    func nextBtnAction() {
        print("next")
    }
    
    func dayRangeDidChange(_ dayRange: (String) -> Void) {
        dayRange("2020/2/2")
    }
    
    func descriptionDidChange(_ description: (String) -> Void) {
        let text = NSLocalizedString("CalendarDescription", comment: "CalendarDescription")
        description(text)
    }
    
    var closeBtnTitle: String { NSLocalizedString("CalendarClose", comment: "close") }
    
    func closeBtnAction() {
        router?.closeAction()
    }
}

class DayViewViewModel: DayViewViewModelSpec {
    var isAvailable: Bool = Bool.random()
    var title: String { "mon" }
    var content: String { "30" }
}

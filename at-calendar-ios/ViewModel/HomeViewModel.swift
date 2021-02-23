//
//  HomeViewModel.swift
//  at-calendar-ios
//
//  Created by 五加一 on 2021/2/22.
//

import Foundation

protocol HomeRouterDelegate: AnyObject {
    func showDynamicCalendar()
    func showJsonCalendar()
}

class HomeViewModel {
    weak var router: HomeRouterDelegate?
    
    init(routerDelegate: HomeRouterDelegate) {
        router = routerDelegate
    }
}
// MARK: - BtnViewViewModelSpec
extension HomeViewModel: BtnViewViewModelSpec {
    var btnTitle: String { NSLocalizedString("HomeBtnTitle", comment: "dynamic") }
    var bottomBtnTitle: String { NSLocalizedString("HomebottomBtnTitle", comment: "json") }

    func bottomBtnAction() {
        router?.showJsonCalendar()
    }
    
    func btnAction() {
        router?.showDynamicCalendar()
    }
}

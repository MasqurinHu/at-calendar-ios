//
//  HomeViewModel.swift
//  at-calendar-ios
//
//  Created by 五加一 on 2021/2/22.
//

import Foundation

protocol HomeRouterDelegate: AnyObject {
    func showCalendar()
}

class HomeViewModel {
    weak var router: HomeRouterDelegate?
    
    init(routerDelegate: HomeRouterDelegate) {
        router = routerDelegate
    }
}

extension HomeViewModel: BtnViewViewModelSpec {
    var btnTitle: String { "下一頁" }
    
    func btnAction() {
        router?.showCalendar()
    }
}

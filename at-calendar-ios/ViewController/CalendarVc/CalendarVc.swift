//
//  CalendarVc.swift
//  at-calendar-ios
//
//  Created by 五加一 on 2021/2/22.
//

import UIKit

enum CalendarVcType {
    case dynamic, json
}

class CalendarVc: UIViewController {
    var type: CalendarVcType = .dynamic

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        let calendar = CalendarView()
        let repository: CalendartRepositorySpec
        switch type {
        case .dynamic:
            repository = DummyCalendartRepository()
        case .json:
            repository = CalendartRepository(apiDataSourceSpec: DummyApiDataSource())
        }
        calendar.setup(with: CalendarViewModel(routerDelegate: self, calendarRepository: repository))
        calendar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(calendar)
        NSLayoutConstraint.activate([
            calendar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            calendar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            calendar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            calendar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
// MARK: - CalendarRouterDelegate
extension CalendarVc: CalendarRouterDelegate {
    
    func closeAction() {
        dismiss(animated: true, completion: nil)
    }
}

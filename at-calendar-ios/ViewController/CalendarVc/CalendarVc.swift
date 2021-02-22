//
//  CalendarVc.swift
//  at-calendar-ios
//
//  Created by 五加一 on 2021/2/22.
//

import UIKit

class CalendarVc: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let calendar = CalendarView()
        calendar.setup(with: CalendarViewModel(routerDelegate: self))
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

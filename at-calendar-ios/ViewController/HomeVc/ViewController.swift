//
//  ViewController.swift
//  at-calendar-ios
//
//  Created by 五加一 on 2021/2/20.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var page: BtnView!

    override func viewDidLoad() {
        super.viewDidLoad()
        page.setup(with: HomeViewModel(routerDelegate: self))
    }
}
// MARK: - HomeRouterDelegate
extension ViewController: HomeRouterDelegate {

    func showJsonCalendar() {
        let vc = CalendarVc()
        vc.type = .json
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }

    func showDynamicCalendar() {
        let vc = CalendarVc()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
}

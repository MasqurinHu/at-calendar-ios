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

extension ViewController: HomeRouterDelegate {
    
    func showCalendar() {
        let vc = CalendarVc()
        present(vc, animated: true, completion: nil)
    }
}

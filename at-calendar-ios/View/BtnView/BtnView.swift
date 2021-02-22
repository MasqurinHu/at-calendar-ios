//
//  BtnView.swift
//  at-calendar-ios
//
//  Created by 五加一 on 2021/2/22.
//

import UIKit

protocol BtnViewViewModelSpec: ViewModelSpec {
    var btnTitle: String { get }
    func btnAction()
}

class BtnView: XibView {
    @IBOutlet private var btn: UIButton!
    
    typealias ViewModel = BtnViewViewModelSpec
    
    @IBAction private func btnTap(_ btn: UIButton) {
        viewModel?.btnAction()
    }
    
    private var viewModel: ViewModel?
}
// MARK: - ViewModelHolder
extension BtnView: ViewModelHolder {
    
    func setup(with viewModel: ViewModelSpec) {
        self.viewModel = viewModel as? ViewModel
        btn.setTitle(self.viewModel?.btnTitle, for: .normal)
    }
}

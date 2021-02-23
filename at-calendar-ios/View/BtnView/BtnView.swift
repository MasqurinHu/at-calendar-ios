//
//  BtnView.swift
//  at-calendar-ios
//
//  Created by 五加一 on 2021/2/22.
//

import UIKit

protocol BtnViewViewModelSpec: ViewModelSpec {
    var btnTitle: String { get }
    var bottomBtnTitle: String { get }
    func btnAction()
    func bottomBtnAction()
}

class BtnView: XibView {
    @IBOutlet private var btn: UIButton!
    @IBOutlet private var bottomBtn: UIButton!
    
    typealias ViewModel = BtnViewViewModelSpec
    
    @IBAction private func btnTap(_ btn: UIButton) {
        viewModel?.btnAction()
    }

    @IBAction private func bottomBtnTap(_ btn: UIButton) {
        viewModel?.bottomBtnAction()
    }
    
    private var viewModel: ViewModel?
}
// MARK: - ViewModelHolder
extension BtnView: ViewModelHolder {
    
    func setup(with viewModel: ViewModelSpec) {
        self.viewModel = viewModel as? ViewModel
        btn.setTitle(self.viewModel?.btnTitle, for: .normal)
        bottomBtn.setTitle(self.viewModel?.bottomBtnTitle, for: .normal)
    }
}

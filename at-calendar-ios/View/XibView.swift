//
//  XibView.swift
//  at-calendar-ios
//
//  Created by 五加一 on 2021/2/22.
//

import UIKit

class XibView: UIView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupXib()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupXib()
    }

    private func setupXib() {
        let bundle = Bundle(for: type(of: self))
        let nibName = String(describing: type(of: self))
        let nibs = bundle.loadNibNamed(nibName, owner: self, options: nil)
        guard let view = nibs?.first as? UIView else { return }
        view.frame = bounds
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
}

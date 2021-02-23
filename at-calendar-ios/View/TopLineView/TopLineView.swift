//
//  DayView.swift
//  at-calendar-ios
//
//  Created by 五加一 on 2021/2/23.
//

import UIKit

protocol DayViewViewModelSpec: ViewModelSpec {
    var isAvailable: Bool { get }
    var title: String { get }
    var content: String { get }
}

class TopLineView: UIView {

    typealias ViewModel = DayViewViewModelSpec

    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        layout()
    }

    private let title = UILabel()
    private let content = UILabel()

    private var viewModel: ViewModel?

    private lazy var line = getLine()
}

extension TopLineView: ViewModelHolder {

    func setup(with viewModel: ViewModelSpec) {
        self.viewModel = viewModel as? ViewModel
        line.backgroundColor = self.viewModel?.isAvailable ?? false ? .availableColor : .lightGray
        title.text = self.viewModel?.title
        title.textColor = self.viewModel?.isAvailable ?? false ? .darkText : .lightGray
        content.text = self.viewModel?.content
        content.textColor = self.viewModel?.isAvailable ?? false ? .darkText : .lightGray
    }
}

private extension TopLineView {

    func layout() {
        let dayStack = UIStackView(arrangedSubviews: [title, content])
        dayStack.alignment = .center
        dayStack.axis = .vertical
        let stack = UIStackView(arrangedSubviews: [line, dayStack])
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    func getLine() -> UIView {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 4).isActive = true
        return view
    }
}

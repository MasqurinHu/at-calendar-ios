//
//  CalendarView.swift
//  at-calendar-ios
//
//  Created by 五加一 on 2021/2/22.
//

import UIKit

protocol CalendarViewViewModelSpec: ViewModelSpec {
    var title: String { get }
    func lastBtnEnableDidChange(_ isEnable: (Bool) -> Void)
    func lastBtnAction()
    func nextBtnAction()
    func dayRangeDidChange(_ dayRange: (String) -> Void)
    func descriptionDidChange(_ description: (String) -> Void)
    var closeBtnTitle: String { get }
    func closeBtnAction()
}

class CalendarView: UIView {
    
    typealias ViewModel = CalendarViewViewModelSpec

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
    }

    private let dateRangeLb = UILabel()
    private let descriptionLb = UILabel()
    
    private var viewModel: ViewModel?
    
    private lazy var titleLb = getTitle()
    private lazy var lastBtn = getLastBtn()
    private lazy var nextBtn = getNextBtn()
    private lazy var closeBtn = getCloseBtn()
}
// MARK: - ViewModelHolder
extension CalendarView: ViewModelHolder {
    
    func setup(with viewModel: ViewModelSpec) {
        self.viewModel = viewModel as? ViewModel
        titleLb.text = self.viewModel?.title
        self.viewModel?.lastBtnEnableDidChange({ [weak self] isEnable in
            self?.lastBtn.isEnabled = isEnable
            self?.lastBtn.layer.borderColor = isEnable
                ? UIColor.darkText.cgColor
                : UIColor.lightGray.cgColor
        })
        self.viewModel?.dayRangeDidChange({ [weak self] dayRange in
            self?.dateRangeLb.text = dayRange
        })
        closeBtn.setTitle(self.viewModel?.closeBtnTitle, for: .normal)
        self.viewModel?.descriptionDidChange({ [weak self] description in
            self?.descriptionLb.text = description
        })
    }
}
// MARK: - layout
private extension CalendarView {
    
    func setupLayout() {
        let btnStack = UIStackView(arrangedSubviews: [lastBtn, nextBtn])
        btnStack.spacing = 4
        let centerStack = UIStackView(arrangedSubviews: [btnStack, dateRangeLb])
        centerStack.spacing = 12
        let topStack = UIStackView(arrangedSubviews: [titleLb, centerStack, descriptionLb])
        topStack.axis = .vertical
        topStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(topStack)
        NSLayoutConstraint.activate([
            topStack.topAnchor.constraint(equalTo: topAnchor),
            topStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            topStack.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        addSubview(closeBtn)
        closeBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            closeBtn.centerXAnchor.constraint(equalTo: centerXAnchor),
            closeBtn.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func getTitle() -> UILabel {
        let lb = UILabel()
        lb.font = UIFont.boldSystemFont(ofSize: 24)
        return lb
    }
    
    func getBtn(with title: String) -> UIButton {
        let btn = UIButton(type: .custom)
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(.darkText, for: .normal)
        btn.setTitleColor(.lightGray, for: .disabled)
        btn.layer.cornerRadius = 8
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.darkText.cgColor
        return btn
    }
    
    func getLastBtn() -> UIButton {
        let btn = getBtn(with: "<")
        btn.widthAnchor.constraint(equalToConstant: 44).isActive = true
        btn.addTarget(self, action: #selector(lastBtnAction(_:)), for: .touchUpInside)
        return btn
    }
    
    func getNextBtn() -> UIButton {
        let btn = getBtn(with: ">")
        btn.widthAnchor.constraint(equalToConstant: 44).isActive = true
        btn.addTarget(self, action: #selector(nextBtnAction(_:)), for: .touchUpInside)
        return btn
    }
    
    func getCloseBtn() -> UIButton {
        let btn = getBtn(with: "")
        btn.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        btn.addTarget(self, action: #selector(closeBtnAction(_:)), for: .touchUpInside)
        return btn
    }
    
    @objc func lastBtnAction(_ btn: UIButton) {
        viewModel?.lastBtnAction()
    }
    
    @objc func nextBtnAction(_ btn: UIButton) {
        viewModel?.nextBtnAction()
    }
    
    @objc func closeBtnAction(_ btn: UIButton) {
        viewModel?.closeBtnAction()
    }
}

//
//  CalendarView.swift
//  at-calendar-ios
//
//  Created by 五加一 on 2021/2/22.
//

import UIKit

protocol CalendarViewViewModelSpec: ViewModelSpec {
    var title: String { get }
    func lastBtnEnableDidChange(_ isEnable:  @escaping  (Bool) -> Void)
    func lastBtnAction()
    func nextBtnAction()
    func dayRangeDidChange(_ dayRange:  @escaping  (String) -> Void)
    func descriptionDidChange(_ description:  @escaping  (String) -> Void)
    func dayListDidChange(_ dayList:  @escaping  ([DayViewViewModelSpec]) -> Void)
    func timeListDidChange(_ timeList: @escaping ([TextCollectionViewCellViewModelSpec]) -> Void)
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
    private let descriptionLb: UILabel = {
        let lb = UILabel()
        lb.numberOfLines = .zero
        return lb
    }()
    
    private var viewModel: ViewModel?
    private var dayViewList = [TopLineView]()
    private var timeList = [TextCollectionViewCellViewModelSpec]()
    
    private lazy var titleLb = getTitle()
    private lazy var lastBtn = getLastBtn()
    private lazy var nextBtn = getNextBtn()
    private lazy var collectionView = getCollectionView()
    private lazy var closeBtn = getCloseBtn()
}
// MARK: - UICollectionViewDataSource
extension CalendarView: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        timeList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        timeList.count > indexPath.item
            ? timeList[indexPath.item].getCell(with: collectionView, indexPath: indexPath)
            : UICollectionViewCell()
    }
}
// MARK: - UICollectionViewDelegateFlowLayout
extension CalendarView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: (bounds.width - gap * 6) / CGFloat(dayCount), height: 20)
    }
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
        self.viewModel?.dayListDidChange({ [weak self] dayList in
            self?.dayViewList.enumerated().forEach({ [weak self] item in
                guard let self = self , item.offset < self.dayViewList.count else { return }
                item.element.setup(with: dayList[item.offset])
            })
        })
        self.viewModel?.timeListDidChange({ [weak self] timeList in
            guard let self = self else { return }
            self.timeList.removeAll()
            self.timeList = timeList
            timeList.forEach({$0.register(with: self.collectionView)})
            self.collectionView.reloadData()
        })
    }
}
// MARK: - layout
private extension CalendarView {
    var gap: CGFloat { 8 }
    var dayCount: Int { 7 }

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
        setupDayList()

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: dayViewList[0].bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        addSubview(closeBtn)
        closeBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            closeBtn.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 16),
            closeBtn.centerXAnchor.constraint(equalTo: centerXAnchor),
            safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: closeBtn.bottomAnchor, constant: gap)
        ])
    }

    func setupDayList() {
        dayViewList.forEach { $0.removeFromSuperview() }
        dayViewList.removeAll()
        for i in 0 ..< dayCount {
            let view = TopLineView()
            dayViewList.append(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
            view.topAnchor.constraint(equalTo: descriptionLb.bottomAnchor, constant: 16).isActive = true
            if i == .zero {
                view.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            } else {
                view.leadingAnchor.constraint(equalTo: dayViewList[i - 1].trailingAnchor, constant: gap).isActive = true
                view.widthAnchor.constraint(equalTo: dayViewList[i - 1].widthAnchor).isActive = true
            }
            if i == dayCount - 1 {
                view.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
            }
        }
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

    func getCollectionView() -> UICollectionView {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 8
        flowLayout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        return collectionView
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

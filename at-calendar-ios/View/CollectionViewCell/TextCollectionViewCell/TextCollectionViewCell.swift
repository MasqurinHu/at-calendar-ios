//
//  TextCollectionViewCell.swift
//  at-calendar-ios
//
//  Created by 五加一 on 2021/2/23.
//

import UIKit

protocol TextCollectionViewCellViewModelSpec: CollectionViewCellViewModelSpec {
    var text: String { get }
    var isAvailable: Bool { get }
}
// MARK: - CollectionViewCellViewModelSpec
extension TextCollectionViewCellViewModelSpec {
    var reusedId: String { String(describing: TextCollectionViewCell.self) }

    func register(with collectionView: UICollectionView) {
        let nib = UINib(nibName: reusedId, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: reusedId)
    }

    func getCell(with collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusedId, for: indexPath)
        if let cell = cell as? ViewModelHolder {
            cell.setup(with: self)
        }
        return cell
    }
}

class TextCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var text: UILabel!

    typealias ViewModel = TextCollectionViewCellViewModelSpec
}
// MARK: - ViewModelHolder
extension TextCollectionViewCell: ViewModelHolder {

    func setup(with viewModel: ViewModelSpec) {
        let viewModel = viewModel as? ViewModel
        text?.text = viewModel?.text
        text?.textColor = viewModel?.isAvailable ?? false ? .availableColor : .lightGray
    }
}

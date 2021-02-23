//
//  ViewModelSpec.swift
//  at-calendar-ios
//
//  Created by 五加一 on 2021/2/22.
//

import UIKit

protocol ViewModelSpec {}
protocol ReusedableViewModelSpec: ViewModelSpec {}
extension ReusedableViewModelSpec {
    var reusedId: String {
        assertionFailure("need override")
        return ""
    }
}
protocol CollectionViewCellViewModelSpec: ReusedableViewModelSpec {}
extension CollectionViewCellViewModelSpec {
    func register(with collectionView: UICollectionView) {
        assertionFailure("need override")
    }
    func getCell(with collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        assertionFailure("need override")
        return UICollectionViewCell()
    }
}

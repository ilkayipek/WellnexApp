//
//  UICollectionView+Extension.swift
//  WellnexApp
//
//  Created by MacBook on 15.05.2025.
//

import UIKit

extension UICollectionView {
    
    func registerCellFromNib<T: UICollectionViewCell>(_ cell: T.Type) {
        let cellString = String(describing: cell.self)
        self.register(UINib(nibName: cellString, bundle: nil), forCellWithReuseIdentifier: cellString)
    }
    
    func sameNameDequeueReusableCell<T: UICollectionViewCell>(_ cell: T.Type, indexPath: IndexPath) -> T {
        let cellString = String(describing: cell.self)
        return self.dequeueReusableCell(withReuseIdentifier: cellString, for: indexPath) as! T
    }
}

//
//  UITableView+Extension.swift
//  WellnexApp
//
//  Created by MacBook on 4.05.2025.
//

import UIKit

extension UITableView {
    
    func registerCellFromNib<T: UITableViewCell>(_ cell: T.Type) {
        let cellString = String(describing: cell.self)
        self.register(UINib(nibName: cellString, bundle: nil), forCellReuseIdentifier: cellString)
    }
    
    func sameNameDequeueReusableCell<T: UITableViewCell>(_ cell: T.Type, indexPath: IndexPath) -> T {
        let cellString = String(describing: cell.self)
        return self.dequeueReusableCell(withIdentifier: cellString, for: indexPath) as! T
    }
}

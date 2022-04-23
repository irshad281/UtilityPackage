//
//  UITableView+Extension.swift
//  UtilityPackage
//
//  Created by Irshad Ahmad on 10/03/22.
//

import UIKit

public extension UITableView {
    func register<T: UITableViewCell>(_ : T.Type) where T: ViewRegistrable {
        register(T.nib, forCellReuseIdentifier: T.identifier)
    }
    
    func dequeCell<T: UITableViewCell>() -> T where T: ViewRegistrable {
        dequeueReusableCell(withIdentifier: T.identifier) as? T ?? T()
    }
}

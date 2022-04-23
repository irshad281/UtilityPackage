//
//  UICollectionView+Extension.swift
//  UtilityPackage
//
//  Created by Irshad Ahmad on 10/03/22.
//

import UIKit

public extension UICollectionView {
    
    func register<T: UICollectionViewCell>(_: T.Type) where T: ViewRegistrable {
        register(T.nib, forCellWithReuseIdentifier: T.identifier)
    }
    
    func registerSupplementaryView<T: UICollectionReusableView>(_: T.Type) where T: ViewRegistrable {
        register(T.nib, forSupplementaryViewOfKind: T.identifier, withReuseIdentifier: T.identifier)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T where T: ViewRegistrable {
        
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.identifier)")
        }
        
        return cell
    }
}

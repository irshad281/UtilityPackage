//
//  UICollectionView+Extension.swift
//  UtilityPackage
//
//  Created by Irshad Ahmad on 10/03/22.
//
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

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
    
    func supplementaryViewOfKind<T: UICollectionReusableView>(atIndexPath indexPath: IndexPath) -> T where T: ViewRegistrable {
        guard let view = dequeueReusableSupplementaryView(ofKind: T.identifier, withReuseIdentifier: T.identifier, for: indexPath) as? T else {
            fatalError("Could not dequeue supplementaryElementOfKind with identifier: \(T.identifier)")
        }
        return view
    }
}

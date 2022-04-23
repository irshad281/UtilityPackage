//
//  Reusable.swift
//  UtilityPackage
//
//  Created by Irshad Ahmad on 10/03/22.
//

import UIKit

public protocol ViewRegistrable: AnyObject { }

public extension ViewRegistrable where Self: UIView {
    static var identifier: String { String(describing: self) }
    static var nib: UINib { UINib(nibName: self.identifier, bundle: nil) }
}

public extension ViewRegistrable where Self: UIViewController {
    static var identifier: String { String(describing: self) }
}

public protocol XibLoadable: AnyObject {}

public extension XibLoadable where Self: UIViewController {
    
    static var ID: String {
        return String(describing: self)
    }
    
    static var instance: Self {
        Self(nibName: Self.ID, bundle: nil)
    }
    
}

public extension XibLoadable where Self: UIView {
    
    static var ID: String {
        return String(describing: self)
    }
    
    static var nib: Self {
        UINib(nibName: Self.ID, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? Self ?? Self()
    }
    
}

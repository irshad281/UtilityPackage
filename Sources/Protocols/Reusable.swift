//
//  Reusable.swift
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

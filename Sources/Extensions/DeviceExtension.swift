//
//  DeviceExtension.swift
//  
//
//  Created by Irshad Ahmad on 04/05/22.
//

import UIKit

public extension UIDevice {
    
    static var iPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }

    static var iPhone: Bool {
        UIDevice.current.userInterfaceIdiom == .phone
    }
    
    static var isPortrait: Bool {
        let value = UIDevice.current.orientation == .portrait || UIDevice.current.orientation == .portraitUpsideDown
        return value
    }
    
    static var isLandscape: Bool {
        let value = UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight
        return value
    }
}

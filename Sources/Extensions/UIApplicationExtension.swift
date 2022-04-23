//
//  UIApplicationExtension.swift
//  
//
//  Created by Irshad Ahmad on 24/04/22.
//

import Foundation
import UIKit

public extension UIApplication {
    
    var window: UIWindow? { UIApplication.shared.keyWindow }
    
    static var version: String? {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    weak var currentController: UIViewController? {
        return UIApplication.shared.window?.rootViewController?.topMostViewController()
    }
    
    func openAppURL(_ urlStr: String?) {
        guard let path = urlStr,
              let encodedUrl = path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: encodedUrl)
        else {
            return
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
}

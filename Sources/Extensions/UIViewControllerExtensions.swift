//
//  UIViewController+Extension.swift
//  UtilityPackage
//
//  Created by Irshad Ahmad on 17/03/22.
//

import UIKit

public extension UIViewController {
    
    var isModal: Bool {
        if let index = navigationController?.viewControllers.firstIndex(of: self), index > 0 {
            return false
        } else if presentingViewController != nil {
            return true
        } else if navigationController?.presentingViewController?.presentedViewController == navigationController {
            return true
        } else if tabBarController?.presentingViewController is UITabBarController {
            return true
        } else {
            return false
        }
    }
    
    func topMostViewController() -> UIViewController? {
        if self.presentedViewController == nil {
            if let navigation = self as? UINavigationController {
                return navigation.visibleViewController?.topMostViewController()
            }
            if let tab = self as? UITabBarController {
                if let selectedTab = tab.selectedViewController {
                    return selectedTab.topMostViewController()
                }
                return tab.topMostViewController()
            }
            return self
        }
        if let navigation = self.presentedViewController as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController()
        }
        if let tab = self.presentedViewController as? UITabBarController {
            if let selectedTab = tab.selectedViewController {
                return selectedTab.topMostViewController()
            }
            return tab.topMostViewController()
        }
        return self.presentedViewController?.topMostViewController()
    }
    
    func push(_ controller: UIViewController, animated: Bool = true) {
        self.navigationController?.pushViewController(controller, animated: animated)
    }
    
}

//
//  UIAlertControllerExtension.swift
//  UtilityPackage
//
//  Created by Irshad Ahmad on 05/04/22.
//

#if canImport(UIKit) && !os(watchOS)
import UIKit

#if canImport(AudioToolbox)
import AudioToolbox
#endif

// MARK: - Methods
public extension UIAlertController {
    @available(iOSApplicationExtension, unavailable)
    func show(animated: Bool = true, vibrate: Bool = false, completion: (() -> Void)? = nil) {
        UIApplication.shared.currentController?.present(self, animated: animated, completion: completion)
        if vibrate {
            #if canImport(AudioToolbox)
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
            #endif
        }
    }

    @discardableResult
    func addAction(
        title: String,
        style: UIAlertAction.Style = .default,
        isEnabled: Bool = true,
        handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
        let action = UIAlertAction(title: title, style: style, handler: handler)
        action.isEnabled = isEnabled
        addAction(action)
        return action
    }
    
    func addTextField(
        text: String? = nil,
        placeholder: String? = nil,
        editingChangedTarget: Any?,
        editingChangedSelector: Selector?) {
        addTextField { textField in
            textField.text = text
            textField.placeholder = placeholder
            if let target = editingChangedTarget, let selector = editingChangedSelector {
                textField.addTarget(target, action: selector, for: .editingChanged)
            }
        }
    }
}

// MARK: - Initializers
public extension UIAlertController {
    convenience init(
        title: String,
        message: String? = nil,
        defaultActionButtonTitle: String = "OK",
        tintColor: UIColor? = nil) {
        self.init(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: defaultActionButtonTitle, style: .default, handler: nil)
        addAction(defaultAction)
        if let color = tintColor {
            view.tintColor = color
        }
    }
    
    convenience init(
        title: String = "Error",
        error: Error,
        defaultActionButtonTitle: String = "OK",
        preferredStyle: UIAlertController.Style = .alert,
        tintColor: UIColor? = nil) {
        self.init(title: title, message: error.localizedDescription, preferredStyle: preferredStyle)
        let defaultAction = UIAlertAction(title: defaultActionButtonTitle, style: .default, handler: nil)
        addAction(defaultAction)
        if let color = tintColor {
            view.tintColor = color
        }
    }
}

#endif

//
//  UITextFieldExtensions.swift
//  UtilityPackage
//
//  Created by Irshad Ahmad on 05/04/22.
//

#if canImport(UIKit) && !os(watchOS)
import UIKit

private var __maxLengths = [UITextField: Int]()

// MARK: - Enums
public extension UITextField {
    /// UtilityPackage: UITextField text type.
    enum TextType {
        /// UtilityPackage: UITextField is used to enter email addresses.
        case emailAddress

        /// UtilityPackage: UITextField is used to enter passwords.
        case password

        /// UtilityPackage: UITextField is used to enter generic text.
        case generic
    }
}

// MARK: - Properties
public extension UITextField {
    /// UtilityPackage: Set textField for common text types.
    var textType: TextType {
        get {
            if keyboardType == .emailAddress {
                return .emailAddress
            } else if isSecureTextEntry {
                return .password
            }
            return .generic
        }
        set {
            switch newValue {
            case .emailAddress:
                keyboardType = .emailAddress
                autocorrectionType = .no
                autocapitalizationType = .none
                isSecureTextEntry = false
                placeholder = "Email Address"

            case .password:
                keyboardType = .asciiCapable
                autocorrectionType = .no
                autocapitalizationType = .none
                isSecureTextEntry = true
                placeholder = "Password"

            case .generic:
                isSecureTextEntry = false
            }
        }
    }

    /// UtilityPackage: Check if text field is empty.
    var isEmpty: Bool {
        return text?.isEmpty == true
    }

    /// UtilityPackage: Return text with no spaces or new lines in beginning and end.
    var trimmedText: String? {
        return text?.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// UtilityPackage: Check if textFields text is a valid email format.
    var hasValidEmail: Bool {
        // http://stackoverflow.com/questions/25471114/how-to-validate-an-e-mail-address-in-swift
        return text!.range(of: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}",
                           options: String.CompareOptions.regularExpression,
                           range: nil, locale: nil) != nil
    }

    /// UtilityPackage: Left view tint color.
    @IBInspectable var leftViewTintColor: UIColor? {
        get {
            guard let iconView = leftView as? UIImageView else { return nil }
            return iconView.tintColor
        }
        set {
            guard let iconView = leftView as? UIImageView else { return }
            iconView.image = iconView.image?.withRenderingMode(.alwaysTemplate)
            iconView.tintColor = newValue
        }
    }

    /// UtilityPackage: Right view tint color.
    @IBInspectable var rightViewTintColor: UIColor? {
        get {
            guard let iconView = rightView as? UIImageView else { return nil }
            return iconView.tintColor
        }
        set {
            guard let iconView = rightView as? UIImageView else { return }
            iconView.image = iconView.image?.withRenderingMode(.alwaysTemplate)
            iconView.tintColor = newValue
        }
    }
}

// MARK: - Methods
public extension UITextField {
    @IBInspectable var maxLength: Int {
        get {
            guard let l = __maxLengths[self] else {
                return 150
            }
            return l
        }
        set {
            __maxLengths[self] = newValue
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
    }
    
    @objc func fix(textField: UITextField) {
        if let newText = textField.text?.prefix(maxLength) {
            textField.text = String(newText)
        }
    }
    /// UtilityPackage: Clear text.
    func clear() {
        text = ""
        attributedText = NSAttributedString(string: "")
    }

    /// UtilityPackage: Set placeholder text color.
    ///
    /// - Parameter color: placeholder text color.
    func setPlaceHolderTextColor(_ color: UIColor) {
        guard let holder = placeholder, !holder.isEmpty else { return }
        attributedPlaceholder = NSAttributedString(string: holder, attributes: [.foregroundColor: color])
    }

    /// UtilityPackage: Add padding to the left of the textfield rect.
    ///
    /// - Parameter padding: amount of padding to apply to the left of the textfield rect.
    func addPaddingLeft(_ padding: CGFloat) {
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: frame.height))
        leftViewMode = .always
    }

    /// UtilityPackage: Add padding to the right of the textfield rect.
    ///
    /// - Parameter padding: amount of padding to apply to the right of the textfield rect.
    func addPaddingRight(_ padding: CGFloat) {
        rightView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: frame.height))
        rightViewMode = .always
    }

    /// UtilityPackage: Add padding to the left of the textfield rect.
    func addPaddingLeftIcon(_ image: UIImage, padding: CGFloat) {
        let iconView = UIView(frame: CGRect(x: 0, y: 0, width: image.size.width + padding, height: image.size.height))
        let imageView = UIImageView(image: image)
        imageView.frame = iconView.bounds
        imageView.contentMode = .center
        iconView.addSubview(imageView)
        leftView = iconView
        leftViewMode = .always
    }

    /// UtilityPackage: Add padding to the right of the textfield rect.
    func addPaddingRightIcon(_ image: UIImage, padding: CGFloat) {
        let iconView = UIView(frame: CGRect(x: 0, y: 0, width: image.size.width + padding, height: image.size.height))
        let imageView = UIImageView(image: image)
        imageView.frame = iconView.bounds
        imageView.contentMode = .center
        iconView.addSubview(imageView)
        rightView = iconView
        rightViewMode = .always
    }
    
    /// Add tool bars to the textfield input accessory view.
    #if os(iOS)
    @discardableResult
    func addToolbar(items: [UIBarButtonItem]?, height: CGFloat = 44) -> UIToolbar {
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: height))
        toolBar.setItems(items, animated: false)
        inputAccessoryView = toolBar
        return toolBar
    }
    #endif
}

#endif

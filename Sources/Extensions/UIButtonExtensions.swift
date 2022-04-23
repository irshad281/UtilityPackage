//
//  UIButtonExtensions.swift
//  UtilityPackage
//
//  Created by Irshad Ahmad on 05/04/22.
//

#if canImport(UIKit) && !os(watchOS)
import UIKit

// MARK: - Properties
public extension UIButton {
    /// UtilityPackage: Image of disabled state for button; also inspectable from Storyboard.
    @IBInspectable
    var imageForDisabled: UIImage? {
        get { image(for: .disabled) }
        set { setImage(newValue, for: .disabled) }
    }

    /// UtilityPackage: Image of highlighted state for button; also inspectable from Storyboard.
    @IBInspectable
    var imageForHighlighted: UIImage? {
        get { image(for: .highlighted) }
        set { setImage(newValue, for: .highlighted) }
    }

    /// UtilityPackage: Image of normal state for button; also inspectable from Storyboard.
    @IBInspectable
    var imageForNormal: UIImage? {
        get { image(for: .normal) }
        set { setImage(newValue, for: .normal) }
    }

    /// UtilityPackage: Image of selected state for button; also inspectable from Storyboard.
    @IBInspectable
    var imageForSelected: UIImage? {
        get { image(for: .selected) }
        set { setImage(newValue, for: .selected) }
    }

    /// UtilityPackage: Title color of disabled state for button; also inspectable from Storyboard.
    @IBInspectable
    var titleColorForDisabled: UIColor? {
        get { titleColor(for: .disabled) }
        set { setTitleColor(newValue, for: .disabled) }
    }

    /// UtilityPackage: Title color of highlighted state for button; also inspectable from Storyboard.
    @IBInspectable
    var titleColorForHighlighted: UIColor? {
        get { titleColor(for: .highlighted) }
        set { setTitleColor(newValue, for: .highlighted) }
    }

    /// UtilityPackage: Title color of normal state for button; also inspectable from Storyboard.
    @IBInspectable
    var titleColorForNormal: UIColor? {
        get { titleColor(for: .normal) }
        set { setTitleColor(newValue, for: .normal) }
    }

    /// UtilityPackage: Title color of selected state for button; also inspectable from Storyboard.
    @IBInspectable
    var titleColorForSelected: UIColor? {
        get { titleColor(for: .selected) }
        set { setTitleColor(newValue, for: .selected) }
    }

    /// UtilityPackage: Title of disabled state for button; also inspectable from Storyboard.
    @IBInspectable
    var titleForDisabled: String? {
        get { title(for: .disabled) }
        set { setTitle(newValue, for: .disabled) }
    }

    /// UtilityPackage: Title of highlighted state for button; also inspectable from Storyboard.
    @IBInspectable
    var titleForHighlighted: String? {
        get { title(for: .highlighted) }
        set { setTitle(newValue, for: .highlighted) }
    }

    /// UtilityPackage: Title of normal state for button; also inspectable from Storyboard.
    @IBInspectable
    var titleForNormal: String? {
        get { title(for: .normal) }
        set { setTitle(newValue, for: .normal) }
    }

    /// UtilityPackage: Title of selected state for button; also inspectable from Storyboard.
    @IBInspectable
    var titleForSelected: String? {
        get { title(for: .selected) }
        set { setTitle(newValue, for: .selected) }
    }
    
    /// UtilityPackage: Attributed title of disabled state for button.
    var attributedTitleForDisabled: NSAttributedString? {
        get { attributedTitle(for: .disabled) }
        set { setAttributedTitle(newValue, for: .disabled) }
    }

    /// UtilityPackage: Attributed title of highlighted state for button.
    var attributedTitleForHighlighted: NSAttributedString? {
        get { attributedTitle(for: .highlighted) }
        set { setAttributedTitle(newValue, for: .highlighted) }
    }

    /// UtilityPackage: Attributed title of normal state for button.
    var attributedTitleForNormal: NSAttributedString? {
        get { attributedTitle(for: .normal) }
        set { setAttributedTitle(newValue, for: .normal) }
    }

    /// UtilityPackage: Attributed title of selected state for button.
    var attributedTitleForSelected: NSAttributedString? {
        get { attributedTitle(for: .selected) }
        set { setAttributedTitle(newValue, for: .selected) }
    }
}

// MARK: - Methods
public extension UIButton {
    private var states: [UIControl.State] {
        [.normal, .selected, .highlighted, .disabled]
    }

    /// UtilityPackage: Set image for all states.
    ///
    /// - Parameter image: UIImage.
    func setImageForAllStates(_ image: UIImage) {
        states.forEach { setImage(image, for: $0) }
    }

    /// UtilityPackage: Set title color for all states.
    ///
    /// - Parameter color: UIColor.
    func setTitleColorForAllStates(_ color: UIColor) {
        states.forEach { setTitleColor(color, for: $0) }
    }

    /// UtilityPackage: Set title for all states.
    ///
    /// - Parameter title: title string.
    func setTitleForAllStates(_ title: String) {
        states.forEach { setTitle(title, for: $0) }
    }

    /// UtilityPackage: Set attributed title for all states.
    ///
    /// - Parameter title: title string.
    func setAttributedTitleForAllStates(_ title: NSAttributedString) {
        states.forEach { setAttributedTitle(title, for: $0) }
    }
    
    /// UtilityPackage: Center align title text and image.
    /// - Parameters:
    ///   - imageAboveText: set true to make image above title text, default is false, image on left of text.
    ///   - spacing: spacing between title text and image.
    func centerTextAndImage(imageAboveText: Bool = false, spacing: CGFloat) {
        if imageAboveText {
            // https://stackoverflow.com/questions/2451223/#7199529
            guard
                let imageSize = imageView?.image?.size,
                let text = titleLabel?.text,
                let font = titleLabel?.font else { return }

            let titleSize = text.size(withAttributes: [.font: font])

            let titleOffset = -(imageSize.height + spacing)
            titleEdgeInsets = UIEdgeInsets(top: 0.0, left: -imageSize.width, bottom: titleOffset, right: 0.0)

            let imageOffset = -(titleSize.height + spacing)
            imageEdgeInsets = UIEdgeInsets(top: imageOffset, left: 0.0, bottom: 0.0, right: -titleSize.width)

            let edgeOffset = abs(titleSize.height - imageSize.height) / 2.0
            contentEdgeInsets = UIEdgeInsets(top: edgeOffset, left: 0.0, bottom: edgeOffset, right: 0.0)
        } else {
            let insetAmount = spacing / 2
            imageEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: insetAmount)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: -insetAmount)
            contentEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
        }
    }
}

#endif

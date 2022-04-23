//
//  ShadowView.swift
//  UtilityPackage
//
//  Created by Irshad Ahmad on 13/03/22.
//

import UIKit

// swiftlint:disable unnecessary_type
public class ShadowView: UIView {
    /// The corner radius of the `ShadowView`, inspectable in Interface Builder
    @IBInspectable public var cornerRadius: CGFloat = 5.0 {
        didSet {
            self.updateProperties()
        }
    }
    /// The shadow color of the `ShadowView`, inspectable in Interface Builder
    @IBInspectable public var shadowColor: UIColor = UIColor.black {
        didSet {
            self.updateProperties()
        }
    }
    /// The shadow offset of the `ShadowView`, inspectable in Interface Builder
    @IBInspectable public var shadowOffset: CGSize = CGSize(width: 0.0, height: 2) {
        didSet {
            self.updateProperties()
        }
    }
    /// The shadow radius of the `ShadowView`, inspectable in Interface Builder
    @IBInspectable public var shadowRadius: CGFloat = 4.0 {
        didSet {
            self.updateProperties()
        }
    }
    /// The shadow opacity of the `ShadowView`, inspectable in Interface Builder
    @IBInspectable public var shadowOpacity: Float = 0.5 {
        didSet {
            self.updateProperties()
        }
    }

    /**
    Masks the layer to it's bounds and updates the layer properties and shadow path.
    */
    public override func awakeFromNib() {
        super.awakeFromNib()

        self.layer.masksToBounds = false

        self.updateProperties()
        self.updateShadowPath()
    }

    /**
    Updates all layer properties according to the public properties of the `ShadowView`.
    */
    fileprivate func updateProperties() {
        self.layer.cornerRadius = self.cornerRadius
        self.layer.shadowColor = self.shadowColor.cgColor
        self.layer.shadowOffset = self.shadowOffset
        self.layer.shadowRadius = self.shadowRadius
        self.layer.shadowOpacity = self.shadowOpacity
    }

    /**
    Updates the bezier path of the shadow to be the same as the layer's bounds, taking the layer's corner radius into account.
    */
    fileprivate func updateShadowPath() {
        self.layer.shadowPath = UIBezierPath(roundedRect: layer.bounds, cornerRadius: layer.cornerRadius).cgPath
    }

    /**
    Updates the shadow path everytime the views frame changes.
    */
    public override func layoutSubviews() {
        super.layoutSubviews()

        self.updateShadowPath()
    }
}

//
//  BasePopupView.swift
//  
//
//  Created by Irshad Ahmad on 24/04/22.
//

import UIKit

let SCREEN_WIDTH = UIScreen.main.bounds.width
let SCREEN_HEIGHT = UIScreen.main.bounds.height

public class BasePopUpView: UIView {
    
    public enum PopupPosition: CaseIterable {
        case center
        case bottomSheet
    }
    
    private weak var parentVC: UIViewController?
    public var position: PopupPosition = .center
    
    // popup background view....
    private lazy var bgView: UIView = {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.6)
        return view
    }()
    
    private lazy var initialCentre: CGPoint = {
        let height = self.frame.height + 16
        var point = CGPoint(x: SCREEN_WIDTH / 2, y: SCREEN_HEIGHT + height)
        if position == .center {
            point = CGPoint(x: SCREEN_WIDTH / 2, y: -height)
        }
        return point
    }()
    
    private lazy var finalCentre: CGPoint = {
        let height = self.frame.height
        var point = CGPoint(x: SCREEN_WIDTH / 2, y: (SCREEN_HEIGHT - height / 2))
        if position == .center {
            point = CGPoint(x: SCREEN_WIDTH / 2, y: SCREEN_HEIGHT/2)
        }
        return point
    }()
    
    private lazy var bottomCentre: CGPoint = {
        let height = self.frame.height + 16
        let point = CGPoint(x: SCREEN_WIDTH / 2, y: SCREEN_HEIGHT + height)
        return point
    }()
    
    @IBAction func clickOnCross(_ sender: UIButton) {
       hidePopup()
    }
}

extension BasePopUpView {
    
    @objc func showPopup(from viewController: UIViewController? = nil) {
        self.parentVC = viewController
        
        self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        bgView.addSubview(self)
        bgView.alpha = 0
        self.center = initialCentre
        
        if let controller = parentVC {
            controller.view.addSubview(bgView)
            controller.view.endEditing(true)
            return
        }
        
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        
        window.addSubview(bgView)
        
        UIView.animate(withDuration: 0.74, delay: 0.1, usingSpringWithDamping: 0.66, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            self.center = self.finalCentre
            self.bgView.alpha = 1
            self.transform = .identity
        })
    }
    
    /// use to hide select order type popup...
    @objc func hidePopup() {
        UIView.animate(withDuration: 0.74, delay: 0.1, usingSpringWithDamping: 0.66, initialSpringVelocity: 0.7, options: .curveEaseInOut, animations: {
            self.center = self.bottomCentre
            self.bgView.alpha = 0
            self.transform = CGAffineTransform(scaleX: 0.33, y: 0.33)
        }) { _ in
            self.bgView.removeFromSuperview()
            self.removeFromSuperview()
        }
    }
}

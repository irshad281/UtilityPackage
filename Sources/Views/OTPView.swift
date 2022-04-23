//
//  File.swift
//  
//
//  Created by Irshad Ahmad on 24/04/22.
//

import Foundation
import UIKit

// MARK: - OTPViewDelegate -

@objc public protocol OTPViewDelegate: AnyObject {
    @objc optional func didUpdateOTP(_ value: String, isValid: Bool)
}

// MARK: - OtpField -

fileprivate final class OtpField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func deleteBackward() {
        super.deleteBackward()
        
        NotificationCenter.default.post(name: Notification.Name("Back"), object: self)
    }
    
}

fileprivate extension OtpField {
    func isEmpty() -> Bool {
        guard let text = self.text else {
            return true
        }
        return text.isEmpty
    }
}

// MARK: - OTPView: -

@IBDesignable public final class OTPView: UIView {
    
   @IBInspectable public var numberOfFields: Int = 4 {
        didSet{
            setupViews()
        }
    }
    
    // swiftlint:disable unnecessary_type valid_ibinspectable
    @IBInspectable public var font: UIFont = .systemFont(ofSize: 15) {
        didSet{
            setupFonts()
        }
    }
    
    @IBInspectable public var txtColor: UIColor = UIColor.black {
        didSet{
            setupColor()
        }
    }
    
    @IBInspectable public var layerColor: UIColor = .lightGray {
        didSet{
            setupViews()
        }
    }
    
    private var otpFields = [OtpField]()
    private var borderLine: [UIImageView]! = []
    
    public var otpValue: String {
        var text: String = ""
        for field in self.otpFields {
            text.append(field.text ?? "")
        }
        return text
    }
    
    private var isValid: Bool {
        var valid: Bool = true
        for field in self.otpFields {
            if field.isEmpty() {
                valid = false
                break
            }
        }
        return valid
    }
    
    weak public var delegate: OTPViewDelegate?
   
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupViews()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(backPressed(notification:)),
            name: NSNotification.Name("Back"),
            object: nil
        )
    }
    
    private func setupViews() {
        
        for subview in self.subviews{
            subview.removeFromSuperview()
            self.otpFields.removeAll()
            self.borderLine.removeAll()
        }
        
        let width = self.frame.width / CGFloat(numberOfFields)
        let height = self.frame.height
        let spacing: CGFloat = 10
        
        for index in 0...numberOfFields - 1 {
            let xPosition: CGFloat = index == .zero ? .zero : (CGFloat(index) * width)
            let frame = CGRect(x: xPosition, y: 0, width: width - spacing, height: height)
            
            let field = OtpField(frame: frame)
            
            field.tag = index
            field.keyboardType = .numberPad
            field.textAlignment = .center
            field.font = font
            field.tintColor = self.tintColor
            field.delegate = self
            field.textColor = txtColor
            field.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
            
            let line = UIImageView(frame: CGRect(x: field.frame.origin.x, y: height - 1, width: field.frame.width, height: 2))
            
            line.backgroundColor = .clear
            line.image = UIImage(named: "blackLine")
            
            self.otpFields.append(field)
            
            self.addSubview(field)
            self.addSubview(line)
            
            borderLine.append(line)
        }
    }
    
    private func setupFonts() {
        for field in self.otpFields{
            field.font = font
        }
    }
    
    private func setupColor() {
        for field in self.otpFields{
            field.textColor = txtColor
        }
    }
    
    @objc private func backPressed(notification: Notification) {
        guard let field = notification.object as? OtpField else {
            return
        }
        if field.tag != 0 && field.isEmpty() {
            otpFields[field.tag - 1].becomeFirstResponder()
            updateLines()
        }
    }
    
    deinit {
       NotificationCenter.default.removeObserver(self, name: Notification.Name("Back"), object: nil)
    }
    
}

// MARK: - OTPView: UITextFieldDelegate -

extension OTPView: UITextFieldDelegate {
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentString = (textField.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)
        
        if (currentString as String).count == 1 && string != ""{
            if textField.tag != (numberOfFields - 1) {
                otpFields[textField.tag + 1].becomeFirstResponder()
                if otpFields[textField.tag + 1].isEmpty(){
                    otpFields[textField.tag + 1].text = string
                    otpFields[textField.tag + 1].sendActions(for: .editingChanged)
                }
            }
            updateLines()
        }
        
        return newString.count <= 1
    }
    
    @objc func textDidChange(_ sender: UITextField) {
        guard let text = sender.text else {
            return
        }
        
        updateLines()
        self.delegate?.didUpdateOTP?(self.otpValue, isValid: isValid)
        
        if text.isEmpty {
            if sender.tag != 0{
               otpFields[sender.tag - 1].becomeFirstResponder()
            }
        } else if text.count == 1 {
            if sender.tag != (numberOfFields - 1) {
               otpFields[sender.tag + 1].becomeFirstResponder()
            }
        }
    }
    
    private func updateLines() {
        
    }
    
    func reset() {
        otpFields.forEach({
            $0.text = nil
            $0.resignFirstResponder()
        })
        self.superview?.endEditing(true)
    }
}

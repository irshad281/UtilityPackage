//
//  DatePickerField.swift
//  
//
//  Created by Irshad Ahmad on 06/05/22.
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

public class DatePickerField: UITextField {
    private let datePicker = UIDatePicker()
    
    public var dateFormat = "MM/dd/yyyy"
    public var dateChanged: ((Date) -> Void)?
    
    public var mode: UIDatePicker.Mode = .date {
        didSet {
            self.setupPickerView()
        }
    }
    
    public var minimumDate = Date(){
        didSet {
            self.setupPickerView()
        }
    }
    
    public var selectedDate = Date(){
        didSet {
            self.setupPickerView()
        }
    }
    
    public var maximumDate: Date?{
        didSet {
            self.setupPickerView()
        }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    
        createDatePicker()
        setupToolBar()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func createDatePicker() {
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.addTarget(self, action: #selector(pickerDidChange(_:)), for: .valueChanged)
        self.inputView = datePicker
        setupPickerView()
    }
    
    private func setupPickerView() {
        datePicker.datePickerMode = mode
        datePicker.date = selectedDate
        datePicker.minimumDate = minimumDate
        datePicker.maximumDate = maximumDate
    }
    
    private func setupToolBar() {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.systemBlue
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(textDidEndEditing))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        self.inputAccessoryView = toolBar
    }
    
    @objc private func pickerDidChange(_ picker: UIDatePicker) {
        self.text = picker.date.string(withFormat: dateFormat)
    }
    
    @objc private func textDidEndEditing() {
        dateChanged?(datePicker.date)
        self.text = datePicker.date.string(withFormat: dateFormat)
        self.resignFirstResponder()
    }
}


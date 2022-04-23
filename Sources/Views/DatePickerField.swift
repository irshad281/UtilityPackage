//
//  DatePickerField.swift
//  
//
//  Created by Irshad Ahmad on 06/05/22.
//

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


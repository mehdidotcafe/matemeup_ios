//
//  AccountModifierController.swift
//  matemeup
//
//  Created by Mehdi Meddour on 3/31/18.
//  Copyright © 2018 MateMeUp. All rights reserved.
//

import UIKit
//import GooglePlaces

class AccountModifierController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    let pickerData = ["Man", "Woman"]
    let birthdatePicker: UIDatePicker? = UIDatePicker()
    let genderPicker: UIPickerView = UIPickerView()

    
    var currentGenderRow: Int? = nil
    var currentBirthdate: Date? = nil
    var currentOpenChat: Bool? = nil
    var currentLocation: String? = nil
    
    var _genderInput: UITextField? = nil
    var _birthdateInput: UITextField? = nil
    var _openChatInput: UISwitch? = nil
    
    func getGender() -> Int? {
        return currentGenderRow
    }
    
    func getBirthdate() -> Date? {
        return currentBirthdate
    }
    
    func getOpenChat() -> Bool? {
        return currentOpenChat
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentGenderRow = row;
    }
    
    
    @objc func dateChanged(_ sender: UIDatePicker) {
        let componenets = Calendar.current.dateComponents([.year, .month, .day], from: sender.date)
        if let day = componenets.day, let month = componenets.month, let year = componenets.year {
            print("\(day) \(month) \(year)")
        }
    }
    
    @objc func donedatePicker(){
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "dd/MM/yyyy"
        _birthdateInput?.text = formatter.string(from: birthdatePicker!.date)
        currentBirthdate = birthdatePicker!.date
        //dismiss date picker dialog
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        //cancel button dismiss datepicker dialog
        self.view.endEditing(true)
    }
    
    func createPickerToolbar(confirm: Selector, cancel: Selector) -> UIToolbar {
        //ToolBar
        let toolbar = UIToolbar();
        
        toolbar.sizeToFit()
        
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Confirmer", style: .plain, target: self, action: confirm)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Annuler", style: .plain, target: self, action: cancel)
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        return toolbar
    }
    
    @objc func createGenderPicker()
    {
        let toolbar = createPickerToolbar(confirm: #selector(confGender), cancel: #selector(cancelGender))
        
        self.genderPicker.delegate = self
        self.genderPicker.dataSource = self
        DispatchQueue.main.async {
            self._genderInput?.inputAccessoryView = toolbar
            self._genderInput?.inputView = self.genderPicker
        }
        
    }
    
    @objc func confGender() {
        DispatchQueue.main.async {
            if (self.currentGenderRow != nil) {
                self._genderInput?.text = self.pickerData[self.currentGenderRow!]
            }
        }
        self.view.endEditing(true)
    }
    
    @objc func cancelGender() {
        self.view.endEditing(true)
        
    }
    
    @objc func createBirthdatePicker() {
        let toolbar = createPickerToolbar(confirm: #selector(donedatePicker), cancel: #selector(cancelDatePicker))
        
        
        birthdatePicker!.datePickerMode = .date
        DispatchQueue.main.async {
            self._birthdateInput?.inputAccessoryView = toolbar
            self._birthdateInput?.inputView = self.birthdatePicker
        }
    }
    
    @objc func onOpenChatChange(ocswitch: UISwitch) {
        print("switch change")
        currentOpenChat = ocswitch.isOn
    }
    
    func setOpenChatListener() {
        _openChatInput!.addTarget(self, action: #selector(onOpenChatChange), for: UIControlEvents.valueChanged)
    }
    
    func setInputs(birthdate: UITextField?, gender: UITextField?, openChat: UISwitch?) {
        if (birthdate != nil) {
            self._birthdateInput = birthdate
            createBirthdatePicker()
        }
        if (gender != nil) {
            self._genderInput = gender
            createGenderPicker()
        }
        if (openChat != nil) {
            self._openChatInput = openChat
            setOpenChatListener()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func validateField(_ field: Array<Any?>) -> Bool {
        let value = field[0] as? String
        let validator = field[1] as? (String) -> Bool
        let isNullable = field[2] as? Bool
        
        if isNullable == true && value == nil {
            return true
        }
        else if (value == nil) {
            return false
        }
        else if (validator != nil) {
            return validator!(value!)
        }
        return true
    }
    
    func validateFields(_ fields: Dictionary<String, Array<Any?>>) -> Bool {
        for (key, value) in fields {
            if (validateField(value) == false) {
                print("FAIL")
                print(key, value)
                return false
            }
        }
        return true
    }
}

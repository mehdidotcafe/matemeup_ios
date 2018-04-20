//
//  Validator.swift
//  matemeup
//
//  Created by Mehdi Meddour on 3/28/18.
//  Copyright © 2018 MateMeUp. All rights reserved.
//

import Foundation

class Validator {
    static func isEmail(_ email: String) -> Bool {
        return (true)
    }
    
    static func isString(_ str: String) -> Bool {
        return str.count > 0
    }
    
    static func isPassword(_ password: String) -> Bool {
        return password.count > 8
    }
    
    static func isSameAs(_ field1: String, _ field2: String) -> Bool {
        return field1 == field2
    }
    
    static func isInt(_ value: String) -> Bool {
        return Int(value) != nil
    }
    
    static func isBool(_ value: Int) -> Bool {
        return value == 0 || value == 1
    }
}

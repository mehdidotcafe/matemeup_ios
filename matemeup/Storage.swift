//
//  Storage.swift
//  matemeup
//
//  Created by Mehdi Meddour on 3/24/18.
//  Copyright © 2018 MateMeUp. All rights reserved.
//

import Foundation

class Storage {
    public static func get(_ key: String) -> String? {
        let defaults = UserDefaults.standard
        
        return defaults.string(forKey: key)
    }
    
    public static func unset(_ key: String) {
        let defaults = UserDefaults.standard
        
        defaults.removeObject(forKey: key)
    }
    
    public static func put(_ key: String, _ value: String) {
        let defaults = UserDefaults.standard
        
        defaults.set(value, forKey: key)
    }
}

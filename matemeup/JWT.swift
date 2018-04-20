//
//  JWT.swift
//  matemeup
//
//  Created by Mehdi Meddour on 3/24/18.
//  Copyright © 2018 MateMeUp. All rights reserved.
//

import Foundation

class JWT: Storage {
    private static let MM_KEY: String = "JWT_MM"
    private static let API_KEY: String = "JWT_API"

    public static func putMM(_ value: String) {
        return self.put(self.MM_KEY, value)
    }
    
    public static func getMM() -> String? {
        return self.get(self.MM_KEY)
    }
    
    public static func putAPI(_ value: String) {
        return self.put(self.API_KEY, value)
    }
    
    public static func getAPI() -> String? {
        return self.get(self.API_KEY)
    }
}

//
//  Loginout.swift
//  matemeup
//
//  Created by Mehdi on 26/07/2018.
//  Copyright © 2018 MateMeUp. All rights reserved.
//

import Foundation

class Loginout {
    public static func login() {
        
    }
    
    public static func logout() {
        JWT.unsetMM()
        JWT.unsetAPI()
        ConnectedUser.unset()
        APIRequest.getInstance().unsetQueryString()
        MMUWebSocket.unset()
    }
}

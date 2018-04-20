//
//  Callback.swift
//  matemeup
//
//  Created by Mehdi Meddour on 3/24/18.
//  Copyright © 2018 MateMeUp. All rights reserved.
//

import Foundation

struct Callback {
    public var success: (_ data: Any) -> ()
    public var fail: (_ error: String) -> ()
    
    init(success: @escaping (_ data: Any) -> (), fail: @escaping (_ error: String) -> ()) {
        self.success = success
        self.fail = fail
    }
}

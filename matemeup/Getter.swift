//
//  Getter.swift
//  matemeup
//
//  Created by Mehdi Meddour on 3/31/18.
//  Copyright © 2018 MateMeUp. All rights reserved.
//

import UIKit

class Getter {
    static func getText(_ input: UITextField) -> String {
        return input.text == nil ? "" : input.text!
    }
    
}

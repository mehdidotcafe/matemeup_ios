//
//  RegisterController.swift
//  matemeup
//
//  Created by Mehdi Meddour on 3/27/18.
//  Copyright © 2018 MateMeUp. All rights reserved.
//

import UIKit

class RegisterController: AccountModifierController {
    
    
    // MARK: Properties
    @IBOutlet weak var birthdateInput: UITextField!
    @IBOutlet weak var genderInput: UITextField!
    @IBOutlet weak var openChatInput: UISwitch!
    

    override func viewDidLoad() {
        super.setInputs(birthdate: birthdateInput, gender: genderInput, openChat: openChatInput)
        super.viewDidLoad()
        NavbarLogoCenter.displayLogo(navigationItem)
    }
    
    // Mark: Actions
    @IBAction func register(_ sender: Any) {
    }
}

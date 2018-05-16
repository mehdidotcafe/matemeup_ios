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
    @IBOutlet weak var locationInput: UIButton!
    
    @IBAction func goToLocationView(_ sender: Any) {
        self.displayLocationView()
    }
    
    override func onLocationSet(location: String?) {
        locationInput.setTitle(location, for: .normal)
        locationInput.setTitleColor(.black, for: .normal)
    }
    
    func displayPlaceInput() {
        locationInput.layer.cornerRadius = 5
        locationInput.clipsToBounds = true
    }

    override func viewDidLoad() {
        displayPlaceInput()
        super.setInputs(birthdate: birthdateInput, gender: genderInput, openChat: openChatInput)
        super.viewDidLoad()
        NavbarLogoCenter.displayLogo(navigationItem)
    }
    
    // Mark: Actions
    @IBAction func register(_ sender: Any) {
    }
}

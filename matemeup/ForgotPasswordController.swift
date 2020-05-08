//
//  ForgotPasswordController.swift
//  matemeup
//
//  Created by Mehdi Meddour on 3/27/18.
//  Copyright © 2018 MateMeUp. All rights reserved.
//

import UIKit

class ForgotPasswordController: UIViewController {
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var emailInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NavbarLogoCenter.displayLogo(navigationItem)
    }
    
    @IBAction func sendMail(_ sender: Any) {
        let email: String = emailInput.text!

        if (Validator.isEmail(email)) {
            let _ = APIRequest.getInstance().send(route: "recover", method: "POST", body: ["email": email], callback: Callback(success: { (data) in
                Navigation.goTo(segue: "successForgotPasswordSegue", view: self)
            }, fail: {(error) in print(error)}))
        }
    }
}

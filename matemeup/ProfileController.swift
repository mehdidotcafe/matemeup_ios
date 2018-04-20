//
//  ProfileController.swift
//  matemeup
//
//  Created by Mehdi Meddour on 3/25/18.
//  Copyright © 2018 MateMeUp. All rights reserved.
//

import UIKit

class ProfileController : AccountModifierController {
    
    // MARK: Properties
    @IBOutlet weak var avatarContainer: UIImageView!
    @IBOutlet weak var usernameContainer: UILabel!
    @IBOutlet weak var firstnameContainer: UITextField!
    @IBOutlet weak var lastnameContainer: UITextField!
    @IBOutlet weak var passwordContainer: UITextField!
    @IBOutlet weak var confirmationPasswordContainer: UITextField!
    @IBOutlet weak var birthdateContainer: UITextField!
    @IBOutlet weak var localisationContainer: UITextField!
    @IBOutlet weak var genderContainer: UITextField!
    @IBOutlet weak var chatSwitch: UISwitch!
    
    func updateDisplay(_ user: ConnectedUser) {
        AvatarRemoteImageLoader.load(view: avatarContainer, path: user.avatar)

        DispatchQueue.main.async {
            self.usernameContainer.text = user.name
            self.firstnameContainer.text = user.firstname
            self.lastnameContainer.text = user.lastname
        }
    }
    
    func getValidation() -> Dictionary<String, Array<Any?>>{
        let birthdate: Date? = getBirthdate()
        
        return [
            "firstname": [Getter.getText(firstnameContainer), Validator.isString, false],
            "lastname": [Getter.getText(lastnameContainer), Validator.isString, false],
            "password": [Getter.getText(passwordContainer), Validator.isPassword, true],
            "password-confirmation": [Getter.getText(firstnameContainer), {text in Validator.isSameAs(Getter.getText(self.passwordContainer), text)}, true]	,
            "bdyear": [birthdate == nil ? nil : String(describing: DateConverter.getYear(self.getBirthdate()!)), Validator.isInt, false],
            "bdmonth": [birthdate == nil ? nil : String(describing: DateConverter.getMonth(self.getBirthdate()!)), Validator.isInt, false],
            "bdday": [birthdate == nil ? nil : String(describing: DateConverter.getDay(self.getBirthdate()!)), Validator.isInt, false],
            "location": [self.currentLocation, Validator.isString, false],
            "gender": [getGender() == nil ? nil : String(describing: getGender()), Validator.isBool, false],
            "open_chat_disabled": [getOpenChat() == nil ? nil : String(describing: getOpenChat()), Validator.isBool, false]
        ]
    }
    
    func getUser() {
        self.updateDisplay(ConnectedUser.getInstance())
    }
    
    override func viewDidLoad() {
        super.setInputs(birthdate: birthdateContainer, gender: genderContainer, openChat: chatSwitch)
        super.viewDidLoad()
        getUser()
    }
    
    func updateSuccess(_ obj: Any) {
        
    }
    
    func updateFail(_ error: String) {
        print("fail")
    }
    
    // MARK: Actions
    @IBAction func update(_ sender: Any) {
        
        let req: APIRequest = APIRequest.getInstance()
        
        self.validateFields(getValidation())
//        req.send(route: "update", method: "POST", body: obj, callback: Callback(
 //           success: self.updateSuccess,
  //          fail: self.updateFail
    //    ))
    }
}

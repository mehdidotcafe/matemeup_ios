//
//  ProfileController.swift
//  matemeup
//
//  Created by Mehdi Meddour on 3/25/18.
//  Copyright © 2018 MateMeUp. All rights reserved.
//

import UIKit
import GooglePlaces

class ProfileController : AccountModifierController, UITextFieldDelegate {
    
    // MARK: Properties
    @IBOutlet weak var avatarContainer: UIImageView!
    @IBOutlet weak var usernameContainer: UILabel!
    @IBOutlet weak var firstnameContainer: UITextField!
    @IBOutlet weak var lastnameContainer: UITextField!
    @IBOutlet weak var passwordContainer: UITextField!
    @IBOutlet weak var confirmationPasswordContainer: UITextField!
    @IBOutlet weak var birthdateContainer: UITextField!
    @IBOutlet weak var genderContainer: UITextField!
    @IBOutlet weak var chatSwitch: UISwitch!
    @IBOutlet weak var locationContainer: UIButton!
    @IBOutlet weak var rewardButton: UIButton!
    
    @IBAction func displayLocation(_ sender: Any) {
        self.displayLocationView()
        
    }
    
    @IBAction func getReward(_ sender: Any) {
        MMUWebSocket.getInstance().emit(message: "reward.use", data: [:], callback: Callback(
            success: { data in
                print(data)
                let response = data as! [String: Any]
                
                Alert.ok(controller: self, title: "Votre récompense: ", message: self.getRewardAsMessages((response["rewards"] as? [String: String])!), callback: nil)
        },
            fail: {data in print("FAIL GETTING REWARD")}))
    }
    
    @IBAction func deconnection(_ sender: Any) {
        Loginout.logout()
        Navigation.goTo(segue: "profilDeconnectionSegue", view: self)
    }
    
    func getRewardAsMessages(_ rewards: [String: String]) -> [String] {
        var ret: [String] = []
        
        for (key, value) in rewards {
            ret.append(value + " " + key + ".")
        }
        return ret
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func onLocationSet(location: String?) {
        locationContainer.setTitleColor(.black, for: .normal)
        locationContainer.setTitle(location, for: .normal)
    }
    
    func updateDisplay(_ user: ConnectedUser) {
        let date = DateConverter.getFromStringUS(user.birthdate)
        
        Style.border(view: avatarContainer)
        let _ = AvatarRemoteImageLoader.load(view: avatarContainer, path: user.avatar)
        if user.location != "" {
            self.locationContainer.setTitleColor(.black, for: .normal)
        }
        DispatchQueue.main.async {
            self.usernameContainer.text = user.name
            self.firstnameContainer.text = user.firstname
            self.lastnameContainer.text = user.lastname
            self.birthdateContainer.text = DateConverter.toString(date!)
            self.setGenderValue(container: self.genderContainer, gender: user.gender)
            self.chatSwitch.setOn(!user.isOpenChatDisabled, animated: false)
            self.locationContainer.setTitle(user.location, for: .normal)
        }
    }
    
    func getValidation() -> Dictionary<String, Array<Any?>>{
        let birthdate: Date? = getBirthdate()
        let openChat = getOpenChat()! == true ? 1 : 0;
        
        return [
            "firstname": [Getter.getText(firstnameContainer), Validator.isString, false],
            "lastname": [Getter.getText(lastnameContainer), Validator.isString, false],
            "password": [Getter.getText(passwordContainer), Validator.isPassword, true],
            "password-confirmation": [Getter.getText(confirmationPasswordContainer), {text in Validator.isSameAs(Getter.getText(self.passwordContainer), text)}, false],
            "bdyear": [birthdate == nil ? nil : String(describing: DateConverter.getYear(self.getBirthdate()!)), Validator.isInt, false],
            "bdmonth": [birthdate == nil ? nil : String(describing: DateConverter.getMonth(self.getBirthdate()!)), Validator.isInt, false],
            "bdday": [birthdate == nil ? nil : String(describing: DateConverter.getDay(self.getBirthdate()!)), Validator.isInt, false],
            "location": [self.currentLocation, Validator.isString, false],
            "gender": [getGender() == nil ? nil : String(describing: getGender()!), Validator.isBool, false],
            "open_chat_disabled": [getOpenChat() == nil ? nil : String(describing: openChat), Validator.isBool, false]
        ]
    }
    
    func updateValues(_ user: ConnectedUser) {
        currentBirthdate = DateConverter.getFromStringUS(user.birthdate)
        currentLocation = user.location
        currentOpenChat = user.isOpenChatDisabled
        currentGenderRow = user.gender
    }
    
    func getUser() {
        let user: ConnectedUser = ConnectedUser.getInstance()
        
        self.updateValues(user)
        self.updateDisplay(user)
    }
    
    func displayLocationInput() {
        locationContainer.layer.cornerRadius = 5
        locationContainer.layer.borderWidth = 0.5
        locationContainer.layer.borderColor = UIColor(red: 200.0/255.0, green: 200.0/255.0, blue: 200.0/255.0, alpha: 1.0).cgColor
    }
    
    func setDelegates() {
        firstnameContainer.delegate = self
        lastnameContainer.delegate = self
        passwordContainer.delegate = self
        confirmationPasswordContainer.delegate = self
    }
    
    func setButtonRewardVisibility() {
        print("AU REVOIR")
        MMUWebSocket.getInstance().emit(message: "reward.isAvailable", data: [:], callback: Callback(
            success: { data in
                print(data)
                let response = data as! [String: Any]
               
                self.rewardButton.isHidden = true
                if (response["state"] as? Bool == true &&
                    response["isAvailable"] as? Bool == true) {
                    self.rewardButton.isHidden = false
                }
        },
            fail: {data in print("FAIL GETTING REWARD AVAILABILITY")}))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setButtonRewardVisibility()
        
    }
    
    override func viewDidLoad() {        
        displayLocationInput()
        super.setInputs(birthdate: birthdateContainer, gender: genderContainer, openChat: chatSwitch)
        super.viewDidLoad()
        setDelegates()
        getUser()
    }
    
    func updateSuccess(_ obj: Any) {
        DispatchQueue.main.async {
            Alert.ok(controller: self, title: "Mise à jour de votre profil", message: "Votre profil s'est correctement mis à jour", callback: nil)
        }
        
    }
    
    func updateFail(_ error: String) {
        print("fail")
    }
    
    // MARK: Actions
    @IBAction func update(_ sender: Any) {
        let obj = self.validateFields(getValidation())
        
        if (obj != nil) {
            let _ = APIRequest.getInstance().send(route: "update", method: "POST", body: obj!, callback: Callback(
                success: self.updateSuccess,
                fail: self.updateFail
            ))
        }
    }
}

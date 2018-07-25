//
//  ChatContainerController.swift
//  matemeup
//
//  Created by Mehdi Meddour on 4/22/18.
//  Copyright © 2018 MateMeUp. All rights reserved.
//

import UIKit
import ImagePicker

class ChatContainerController : UIViewController, UITextFieldDelegate, ImagePickerDelegate {
    var user: User? = nil
    var isInvitation: Bool = false
    let socket: MMUWebSocket = MMUWebSocket.getInstance()
    
    @IBOutlet weak var textInput: UITextField!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var textButton: UIButton!
    @IBOutlet weak var container: UIView!
    
    @IBAction func sendFile(_ sender: Any) {
        let imagePickerController = ImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.imageLimit = 1
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func sendText(_ sender: Any) {
        let text: String? = textInput.text
        
        if text != nil && text!.count > 0 {
            self.textInput.text = ""
            setButtonVisibility()
            socket.emit(message: "global.chat", data: [
                "userId": user!["id"],
                "type": 1,
                "message": text
                ] as Any, callback: nil)
        }
    }

    @IBAction func textChanged(_ sender: Any) {
        setButtonVisibility()
    }
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
    }
    
    func sendImage(_ image: String) {
        let obj = [
            "userId": String(user!["id"] as! Int),
            "type": "2",
            "message": image
        ]
        

        MMUWebSocket.getInstance().emit(message: "global.chat", data: obj, callback: nil)
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        imagePicker.dismiss(animated: true)
        let imageData = UIImageJPEGRepresentation(images[0], 0.25)
        let base64encoding = imageData?.base64EncodedString()
        
        if (base64encoding != nil) {
            sendImage("data:image/jpeg;base64," + base64encoding!)
        }
    }

    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true)
    }
    
    func setButtonVisibility() {
        if textInput.text!.count > 0 {
            imageButton.isHidden = true
            textButton.isHidden = false
        }
        else {
            imageButton.isHidden = false
            textButton.isHidden = true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    public func setUser(_ u: User) {
        self.user = u
    }
    
    public func setIsInvitation(_ isInvitation: Bool) {
        self.isInvitation = isInvitation
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chatListEmbed" {
            if let toViewController = segue.destination as? ChatController {
                toViewController.setUser(self.user!); toViewController.setIsInvitation(self.isInvitation)
            }
        }
    }
    
    func setNavbarTitle() {
        let view = UIStackView()
        let imageView = UIImageView()
        let label = UILabel()
        
        let _ = AvatarRemoteImageLoader.load(view: imageView, path: self.user!["avatar"] as! String)
        view.alignment = .fill
        view.distribution = .fill
        view.axis = .horizontal
        view.spacing = 4
        label.textColor = .white
        label.text = self.user!["name"] as? String
        label.frame = CGRect(x: -16, y: -16, width: 64, height: 32)
        view.addArrangedSubview(imageView)
        view.addArrangedSubview(label)
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: -16, y: -16, width: 32, height: 32)
        imageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        Style.border(view: imageView)
        Navbar.view(self.navigationItem, view)
    }
    
    func setMessagesAsSeen() {
        socket.emit(message: "global.chat.message.seen", data: ["userId": user!["id"] as! Int], callback: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textInput.delegate = self
        Style.shadowTop(view: container)
        if self.navigationController != nil {
            Style.shadowBot(view: (self.navigationController?.navigationBar)!)
        }
        setMessagesAsSeen()
        setNavbarTitle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        super.viewWillDisappear(animated)
        
        NewMessageNotifier.getInstance().setCurrentUser(self.user!)
        NewMessageNotifier.getInstance().delUser(self.user!)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        super.viewWillDisappear(animated)
        
        NewMessageNotifier.getInstance().delUser(self.user!)
        NewMessageNotifier.getInstance().setCurrentUser(nil)
    }
}

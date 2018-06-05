//
//  ChatController.swift
//  matemeup
//
//  Created by Mehdi Meddour on 3/25/18.
//  Copyright © 2018 MateMeUp. All rights reserved.
//

import UIKit

class ChatListController : LayoutUIViewController, UITextFieldDelegate {
    
    // MARK: Properties
    @IBOutlet weak var segmented: UISegmentedControl!
    @IBOutlet weak var chatView: UIView!
    @IBOutlet weak var invitationView: UIView!
    @IBOutlet weak var filterInput: UITextField!
    var socket: MMUWebSocket = MMUWebSocket.getInstance()
    
    var user: User? = nil
    var isInvitation: Bool = false
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func newChat(_ sender: Any) {
        Navigation.goTo(segue: "goToUserListFromChatList", view: self)
    }
    
    @IBAction func filter(_ sender: UITextField) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "chatListFilter"), object: nil,  userInfo: ["pattern": sender.text!])
    }
    

   private func configSegmentedControl() {
        segmented.layer.borderColor = UIColor.init(red: 33 / 255, green: 37 / 255, blue: 41 / 255, alpha: 1).cgColor
        filterInput.backgroundColor = UIColor.init(red: 33 / 255, green: 37 / 255, blue: 41 / 255, alpha: 1)
        segmented.layer.cornerRadius = 0.0
        segmented.layer.borderWidth = 1.5
        let font = UIFont.systemFont(ofSize: 18)
        segmented.setTitleTextAttributes([NSAttributedStringKey.font: font], for: .normal)
    }
    
    private func configSocket() {
        socket.setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Style.shadowBot(view: segmented)
        self.filterInput.delegate = self
        configSegmentedControl()
        configSocket()
        Navbar.logo(self.navigationItem)
    }
    
    // MARK: Actions
    @IBAction func changeView(_ sender: Any) {
        switch segmented.selectedSegmentIndex
        {
            case 0:
                invitationView.isHidden = true
                chatView.isHidden = false
            case 1:
                invitationView.isHidden = false
                chatView.isHidden = true
            default:
                break;
        }
    }
    
    public func setUser(_ u: User) {
        self.user = u
    }
    
    public func setIsInvitation(_ isInvitation: Bool) {
        self.isInvitation = isInvitation
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        super.viewWillDisappear(animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToChat" {
            if let toViewController = segue.destination as? ChatContainerController {
                toViewController.setUser(self.user!)
                toViewController.setIsInvitation(self.isInvitation)
            }
        } else if segue.identifier == "goToUserListFromChatList" {
            let toViewController = segue.destination as! UserSelectController
            
            toViewController.setCallback{ newUser in
                print("BONJOURRR")
                self.user = newUser
                Navigation.goTo(segue: "goToChat", view: self)
            }
        }
    }
}


    //
//  ChatController.swift
//  matemeup
//
//  Created by Mehdi Meddour on 3/25/18.
//  Copyright © 2018 MateMeUp. All rights reserved.
//

import UIKit

class ChatController : LayoutUIViewController {
    
    // MARK: Properties
    @IBOutlet weak var segmented: UISegmentedControl!
    @IBOutlet weak var chatView: UIView!
    @IBOutlet weak var invitationView: UIView!
    @IBOutlet weak var filterInput: UITextField!
    var socket: MMUWebSocket = MMUWebSocket.getInstance()
    
    func configSegmentedControl() {
        segmented.layer.borderColor = UIColor.init(red: 233 / 255, green: 76 / 255, blue: 76 / 255, alpha: 1).cgColor
        filterInput.backgroundColor = UIColor.init(red: 233 / 255, green: 76 / 255, blue: 76 / 255, alpha: 1)
        segmented.layer.cornerRadius = 0.0
        segmented.layer.borderWidth = 1.5
        let font = UIFont.systemFont(ofSize: 18)
        segmented.setTitleTextAttributes([NSAttributedStringKey.font: font], for: .normal)
    }
    
    func configSocket() {
        socket.setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configSegmentedControl()
        configSocket()
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
}


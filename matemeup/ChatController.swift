//
//  ChatController.swift
//  matemeup
//
//  Created by Mehdi Meddour on 4/21/18.
//  Copyright © 2018 MateMeUp. All rights reserved.
//

import UIKit

class MessageCell : UITableViewCell {
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var superContainer: UIStackView!
    @IBOutlet weak var messageImg: UIImageView!
    
}

class ChatController : UITableViewController {
    var user: User? = nil
    let socket: MMUWebSocket = MMUWebSocket.getInstance()
    let chunkSize: Int = 10
    let ceil: Float = 30
    var chunkIndex: Int = 0
    var getUrl: String = "global.chat.user.normal.history"
    var messages: [Message] = []
    var isLoading: Bool = false
    var hasLoadAllHistory: Bool = false
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (100 * Float(scrollView.contentOffset.y) / Float(scrollView.contentSize.height)) <= ceil && isLoading == false && scrollView.panGestureRecognizer.translation(in: scrollView.superview).y > 0 {
            getChunk(callback: Callback(
                success: {data in
                    self.displayChunk(needScroll: false, data: data)
                },
                fail: {data in
                    print("ERROR")
            }))
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func displayCellText(_ cell: MessageCell, _ message: Message) {
        cell.label.text = message["message"] as? String
        cell.label.isHidden = false
        cell.messageImg.isHidden = true

        ChatRemoteImageLoader.empty(view: cell.messageImg)
        //DispatchQueue.main.async {
        //    cell.messageImg.sizeToFit()
        //    cell.label.sizeToFit()
        //}
    }
    
    func displayCellImage(_ cell: MessageCell, _ message: Message) {
        ChatRemoteImageLoader.load(view: cell.messageImg, path: message["message"] as! String)
        cell.label.isHidden = true
        cell.label.text = ""
        cell.messageImg.isHidden = false
        //cell.messageImg.sizeToFit()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageList", for: indexPath) as! MessageCell
        let message = messages[indexPath.row]
        let prevMessage = indexPath.row - 1 >= 0 ? messages[indexPath.row - 1] : nil

        cell.selectionStyle = .none
        if user!["id"] as! Int == message["senderUserId"] as! Int {
            cell.superContainer.semanticContentAttribute = .forceRightToLeft
            cell.label.semanticContentAttribute = .forceRightToLeft
        }
        else {
            cell.superContainer.semanticContentAttribute = .forceLeftToRight
            cell.label.semanticContentAttribute = .forceLeftToRight
        }
        cell.container.layer.masksToBounds = true
        cell.container.layer.cornerRadius = 5
        if (message["type"] as! Int == 1) {
            displayCellText(cell, message)
        } else if (message["type"] as! Int == 2) {
            displayCellImage(cell, message)
        }
        
        //DispatchQueue.main.async {
        //    cell.container.sizeToFit()
        //}
        if prevMessage == nil || message["senderUserId"] as! Int != prevMessage!["senderUserId"] as! Int {
            cell.avatar.isHidden = false
            Style.border(view: cell.avatar)
            AvatarRemoteImageLoader.load(view: cell.avatar, path: message["senderUserAvatar"] as! String)
        } else {
            cell.avatar.isHidden = true
        }
        return cell
    }
    
    
    public func setUser(_ u: User) {
        self.user = u
    }
    
    func displayChunk(needScroll: Bool, data: Any) {
        let chunkInfos = data as! [String: Any]
        let _ = chunkInfos["userId"] as! Int
        let chunk = chunkInfos["history"] as! [Message]
   
        if chunk.count == 0 {
            hasLoadAllHistory = true
        }
        messages = chunk + messages
        chunkIndex += chunk.count
        self.tableView.reloadData()
        if needScroll == true {
            Scroller.toBottom(view: self.tableView, array: self.messages)
        }
    }
    
    func getChunk(callback: Callback?) {
        isLoading = true
        if hasLoadAllHistory == false {
            socket.emit(message: getUrl, data: [
                "userId": user!["id"],
                "chunkSize": chunkSize,
                "index": chunkIndex
                ] as Any, callback: Callback(
                    success: { data in
                        callback?.success(data)
                        self.isLoading = false
                },
                    fail: { data in
                        self.isLoading = false
                        callback?.fail(data)
                }
            ))
        }
    }
    
    func unsetListeners() {
        socket.off(customId: "chatNewListenerChatController")
    }
    
    func setListeners() {
        socket.on(message: "global.chat.new", callback: Callback(
            success: {data in
                self.socket.emit(message: "global.chat.message.seen", data: ["userId": self.user!["id"] as! Int], callback: nil)
                self.messages.append(data as! Message)
                self.tableView.reloadData()
                Scroller.toBottom(view: self.tableView, array: self.messages)
            },
            fail: {data in
                print("ERROR REQUEST CHATCONTROLLER.CONFIGLISTENERS")
        }), customId: "chatNewListenerChatController")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsetListeners()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setListeners()
        getChunk(callback: Callback(
            success: {data in
                self.displayChunk(needScroll: true, data: data)
            },
            fail: {data in
                print("ERROR CHATCONTROLLER.VIEWDIDLOAD")
        }
    ))}
}

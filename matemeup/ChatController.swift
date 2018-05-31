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
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var messageImg: UIImageView!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var stackContainer: UIStackView!
    
    var currentRequest: URLSessionDataTask? = nil

    override func prepareForReuse() {
        super.prepareForReuse()
        
        if currentRequest != nil {
            currentRequest?.cancel()
            currentRequest = nil
        }
        label.text = ""
        label.isHidden = true
//        messageImg.isHidden = true
//        messageImg.image = nil
    }
}

class ChatController : UITableViewController {
    var user: User? = nil
    let socket: MMUWebSocket = MMUWebSocket.getInstance()
    let chunkSize: Int = 10
    let ceil: Float = 30
    var chunkIndex: Int = 0
    var messages: [Message] = []
    var isLoading: Bool = false
    var hasLoadAllHistory: Bool = false
    var isInvitation: Bool = false
    
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
    
    func getUrl() -> String {
        return isInvitation == false ? "global.chat.user.normal.history" : "global.chat.user.invitation.history"
    }
    
    func displayCellText(_ cell: MessageCell, _ message: Message) {
        cell.label.text = message["message"] as? String
        cell.label.isHidden = false
    }
    
    func displayCellImage(_ cell: MessageCell, _ message: Message) {
        /*cell.messageImg.isHidden = false
        cell.label.isHidden = false
        cell.currentRequest = ChatRemoteImageLoader.load(view: cell.messageImg, path: message["message"] as! String, callback: Callback(
            success: {data in
                print("foooo")
                //cell.imageView?.contentMode = .scaleAspectFill
                //cell.container.contentMode = .scaleToFill
                //cell.superContainer.contentMode = .scaleToFill
                //cell.label.sizeToFit()
                //cell.viewContainer.sizeToFit()
            },
            fail: {data in}
        ))*/
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageList", for: indexPath) as! MessageCell
        let message = messages[indexPath.row]
        let prevMessage = indexPath.row - 1 >= 0 ? messages[indexPath.row - 1] : nil

        cell.selectionStyle = .none
        if user!["id"] as! Int == message["senderUserId"] as! Int {
            cell.stackContainer.semanticContentAttribute = .forceRightToLeft
            cell.container.semanticContentAttribute = .forceRightToLeft
            cell.label.semanticContentAttribute = .forceRightToLeft
        }
        else {
            cell.stackContainer.semanticContentAttribute = .forceLeftToRight
            cell.container.semanticContentAttribute = .forceLeftToRight
            cell.label.semanticContentAttribute = .forceLeftToRight
        }
        Style.border(view: cell.label)
        if (message["type"] as! Int == 1) {
            displayCellText(cell, message)
        } else if (message["type"] as! Int == 2) {
            displayCellImage(cell, message)
        }
    
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
    
    public func setIsInvitation(_ isInvitation: Bool) {
        self.isInvitation = isInvitation
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
            socket.emit(message: getUrl(), data: [
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
        NewMessageNotifier.getInstance().on(message: "newConnectedMessage", callback: Callback(
            success: {data in
                let dataArray = data as! [String: Any]
                let lastMessage = dataArray["lastMessage"] as! Message

                self.socket.emit(message: "global.chat.message.seen", data: ["userId": self.user!["id"] as! Int], callback: nil)
                self.messages.append(lastMessage)
                self.tableView.reloadData()
                Scroller.toBottom(view: self.tableView, array: self.messages)
            },
            fail: {data in
                print("ERROR REQUEST CHATCONTROLLER.CONFIGLISTENERS")
            }
        ))
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

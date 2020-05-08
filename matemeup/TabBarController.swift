//
//  TabBarController.swift
//  matemeup
//
//  Created by Mehdi Meddour on 5/8/18.
//  Copyright © 2018 MateMeUp. All rights reserved.
//

import UIKit

class TabBarController : UITabBarController {
    private func incrBadge(_ tab: UITabBarItem) {
        let value: Int = tab.badgeValue == nil ? 0 : Int(tab.badgeValue!)!
        
        tab.badgeValue = String(value + 1)
    }
    
    private func decrBadge(_ tab: UITabBarItem) {
        let value: Int = tab.badgeValue == nil ? 0 : Int(tab.badgeValue!)!
        
        if (value - 1 == 0) {
            tab.badgeValue = nil
        } else {
            tab.badgeValue = String(value - 1)
        }
    }
    
    private func incrChatBadge() {
        let tabItems = self.tabBar.items! as NSArray
        let chatTab = tabItems[0] as! UITabBarItem
        
        incrBadge(chatTab)
    }
    
    private func decrChatBadge() {
        let tabItems = self.tabBar.items! as NSArray
        let chatTab = tabItems[0] as! UITabBarItem
        
        decrBadge(chatTab)
    }
    
    private func setBadge(_ value: Int) {
        let tabItems = self.tabBar.items! as NSArray
        let chatTab = tabItems[0] as! UITabBarItem
        
        setBadge(chatTab, value)
    }
    
    private func setBadge(_ tab: UITabBarItem, _ value: Int) {
        if (value <= 0) {
            tab.badgeValue = nil
        } else {
            tab.badgeValue = String(value)
        }
    }
    
    private func onNewMessage(_ data: Any) {
        let dataArray = data as! [String: Any]
        let notifier: NewMessageNotifier = dataArray["instance"] as! NewMessageNotifier

        setBadge(notifier.getUserLength())
    }
    
    private func setListeners() {
        let notifier: NewMessageNotifier = NewMessageNotifier.getInstance()
        
        notifier.on(message: "newUser", callback: Callback(
            success: self.onNewMessage,
            fail: {data in print("fail")}
        ))
        notifier.on(message: "delUser", callback: Callback(
            success: self.onNewMessage,
            fail: {data in print("fail")}
        ))
    }
    
    override func viewDidLoad() {
        if #available(iOS 10.0, *) {
            self.tabBar.unselectedItemTintColor = UIColor.white
        }
        Style.shadowTop(view: self.tabBar)
        setListeners()
        let logo = UIImage(named: "logo-margin.png")
        let imageView = UIImageView(image:logo)
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView
    }
}

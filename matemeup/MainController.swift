//
//  MainController.swift
//  matemeup
//
//  Created by Mehdi Meddour on 3/24/18.
//  Copyright © 2018 MateMeUp. All rights reserved.
//

import UIKit

class MainController: UIViewController {
    @IBOutlet weak var nav: UINavigationItem!
    
    func onAutoLoginSuccess(_ res: Any) {
        let data: Dictionary<String, Any> = res as! Dictionary<String, Any>
        
        let _ = ConnectedUser.set(data["user"] as! Dictionary<String, Any>)
        Navigation.goTo(segue: "JWTSuccessSegue", view: self)
    }

    func onAutoLoginFail(_ error: String) {
    }
    
    func tryAutoLogin(token: String) {
        let req: APIRequest = APIRequest.getInstance()
        
        req.addQueryString("token", token)
        let _  = req.send(route: "me", method: "GET", body: [:], callback: Callback(
            success: self.onAutoLoginSuccess,
            fail: self.onAutoLoginFail
        ))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let jwt = JWT.getAPI()

        if (jwt == nil || jwt == "") {
            self.onAutoLoginFail("no token")
        }
        else {
            self.tryAutoLogin(token: jwt!)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
}

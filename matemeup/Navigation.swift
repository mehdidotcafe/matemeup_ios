//
//  Navigation.swift
//  matemeup
//
//  Created by Mehdi Meddour on 3/26/18.
//  Copyright © 2018 MateMeUp. All rights reserved.
//

import UIKit


class Navigation {
    static func goTo(segue: String, view: UIViewController) {
        DispatchQueue.main.async {
            view.performSegue(withIdentifier: segue, sender: view)
        }
    }
}

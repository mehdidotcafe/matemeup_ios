//
//  Scroller.swift
//  matemeup
//
//  Created by Mehdi Meddour on 4/22/18.
//  Copyright © 2018 MateMeUp. All rights reserved.
//

import UIKit

class Scroller {
    static func toBottom(view: UITableView, array: [Any]){
        DispatchQueue.main.async {
            if array.count > 0 {
                let indexPath = IndexPath(row: array.count-1, section: 0)
                print(view, indexPath)
                view.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }
}

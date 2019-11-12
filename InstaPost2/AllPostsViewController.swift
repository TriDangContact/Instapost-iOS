//
//  AllPostsViewController.swift
//  InstaPost2
//
//  Created by Tri Dang on 11/11/19.
//  Copyright © 2019 Tri Dang. All rights reserved.
//

import Foundation
import UIKit

class AllPostsViewController: UIViewController {
    
    var username:String?
    var password:String?
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let user = username, let pw = password else {
            print("data not passed")
            return
        }
    
        usernameLabel.text = user
        passwordLabel.text = pw
        
    }
    
    
    
}

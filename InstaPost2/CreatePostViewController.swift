//
//  CreatePostViewController.swift
//  InstaPost2
//
//  Created by Tri Dang on 11/11/19.
//  Copyright © 2019 Tri Dang. All rights reserved.
//

import UIKit
import Alamofire

class CreatePostViewController: UIViewController {

    var email:String?
    var password:String?
    var api = InstaPostAPI()
    
    @IBOutlet weak var apiTesting: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
        
        // user credentials stored in UserDefaults, not ideal
        email = UserDefaults.standard.string(forKey: "email")
        password = UserDefaults.standard.string(forKey: "password")
    }
    
    @IBAction func submit(_ sender: Any) {
        // upload the post
        print("Uploading post")
        
        // custom unwind segue
        performSegue(withIdentifier: "CreateToMain", sender: self)
    }
}

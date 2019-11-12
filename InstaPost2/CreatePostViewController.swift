//
//  CreatePostViewController.swift
//  InstaPost2
//
//  Created by Tri Dang on 11/11/19.
//  Copyright © 2019 Tri Dang. All rights reserved.
//

import UIKit

class CreatePostViewController: UIViewController {

    var username:String?
    var password:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func submit(_ sender: Any) {
        // upload the post
        print("Uploading post")
        
        // custom unwind segue
        performSegue(withIdentifier: "CreateToMain", sender: self)
        
    }
    
}

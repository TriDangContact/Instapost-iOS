//
//  SignUpViewController.swift
//  InstaPost2
//
//  Created by Tri Dang on 11/11/19.
//  Copyright © 2019 Tri Dang. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    var isPWHidden:Bool?
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var usernameInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var hidePWBtn: UIButton!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var message: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // make sure pw text is hidden
        passwordInput.isSecureTextEntry = true
        // lets pw input know that there's a button in it
        passwordInput.rightViewMode = .always
        passwordInput.rightView = hidePWBtn
    }
    
    @IBAction func toggleHidePW(_ sender: UIButton) {
        passwordInput.isSecureTextEntry.toggle()
    }
    
    @IBAction func submit(_ sender: UIButton) {
        // validate form
        
        // if not sucess, display message
        // if success, go back to login screen
    }

}

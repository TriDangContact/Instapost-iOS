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
    var registerSuccess = false
    
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
        if !registerSuccess {
            message.text = "Registration Failed!"
            message.textColor = #colorLiteral(red: 1, green: 0.1039071781, blue: 0.0251960371, alpha: 1)
            message.isHidden = false
        } else {
            // if success, go back to login screen
            message.text = "Registration Successful!"
            message.textColor = #colorLiteral(red: 0.005956960255, green: 0.5896615933, blue: 0.1788459191, alpha: 1)
            message.isHidden = false
            performSegue(withIdentifier: "RegisterToLogin", sender: self)
        }
    }

}

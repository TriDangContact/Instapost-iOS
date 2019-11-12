//
//  LoginViewController.swift
//  InstaPost2
//
//  Created by Tri Dang on 11/11/19.
//  Copyright © 2019 Tri Dang. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {

    var isLoggedIn:Bool = false
    var isPWHidden:Bool = true
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var usernameInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var hidePWBtn: UIButton!
    
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
        // check credentials and log in
        
        // log in
        performSegue(withIdentifier: "LoginToMain", sender: self)
    }
    
    @IBAction func register(_ sender: UIButton) {
        performSegue(withIdentifier: "LoginToRegister", sender: self)
    }
    
    // pass data from this controller to destination
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginToMain" {
            let destination = segue.destination as? MainController
            // assign the sender's data to destination's property
            // this will allow us to highlight courses that were already selected
            destination?.username = self.usernameInput.text
            destination?.password = self.passwordInput.text
        }
        else if segue.identifier == "LoginToRegister" {
            let destination = segue.destination as? RegisterViewController
            destination?.isPWHidden = self.isPWHidden
            
        }
    }
    
    // pass data from source back to this controller
    @IBAction func back(unwindSegue:UIStoryboardSegue) {
        if let source = unwindSegue.source as? MainController {
            resetLogin()
        }
    }
    
    // custom unwind
    @IBAction func unwindRegistration(segue:UIStoryboardSegue) {
        if let source = segue.source as? RegisterViewController {
            print("Unwinded programmatically")
            usernameInput.text = source.usernameInput.text
            passwordInput.text = source.passwordInput.text
            isPWHidden = source.isPWHidden ?? true
        }
    }
    
    func resetLogin() {
        // reset the login forms and data
        usernameInput.text = ""
        passwordInput.text = ""
        isLoggedIn = false
    }
    
    
    
}

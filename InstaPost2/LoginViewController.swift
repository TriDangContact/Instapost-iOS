//
//  LoginViewController.swift
//  InstaPost2
//
//  Created by Tri Dang on 11/11/19.
//  Copyright © 2019 Tri Dang. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class LoginViewController: UIViewController {
    
    var isPWHidden:Bool = true
    var email:String?
    var password:String?
    var api = InstaPostAPI()
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var usernameInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var hidePWBtn: UIButton!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var rememberLogin: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // allows dismiss keyboard on tap
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        // Did the user want to be remembered from last session?
        let isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
        if isLoggedIn {
            email = UserDefaults.standard.string(forKey: "email")
            password = UserDefaults.standard.string(forKey: "password")
            performSegue(withIdentifier: "LoginToMain", sender: self)
        }
        
        
        // make sure pw text is hidden
//        passwordInput.isSecureTextEntry = true
        // lets pw input know that there's a button in it
        passwordInput.rightViewMode = .always
        passwordInput.rightView = hidePWBtn
        
        rememberLogin.isOn = false
    }

    
    @IBAction func toggleHidePW(_ sender: UIButton) {
        passwordInput.isSecureTextEntry.toggle()
    }
    
    // check credentials and log in
    @IBAction func submit(_ sender: UIButton) {
        // validate inputs
        guard usernameInput.text == UserDefaults.standard.string(forKey: "username"), passwordInput.text == UserDefaults.standard.string(forKey: "password") else {
            displayMessage(success: false, message: "Incorrect username/password")
            return
        }
        
        
        // if user wants to remember their credentials
        if rememberLogin.isOn {
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
        } else {
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
        }
        
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
            destination?.email = email
            destination?.password = password
        }
        else if segue.identifier == "LoginToRegister" {
            let destination = segue.destination as? RegisterViewController
            destination?.isPWHidden = self.isPWHidden
            
        }
    }
    
    // pass data from source back to this controller
    @IBAction func back(unwindSegue:UIStoryboardSegue) {
        if unwindSegue.source is MainController {
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
            message.isHidden = true
        }
    }
    
    func resetLogin() {
        // reset the login forms and data
        usernameInput.text = ""
        passwordInput.text = ""
        rememberLogin.isOn = false
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
    }
    
    func displayMessage(success:Bool, message: String) {
        if success {
            self.message.textColor = #colorLiteral(red: 0.005956960255, green: 0.5896615933, blue: 0.1788459191, alpha: 1)
            
        } else {
            self.message.textColor = #colorLiteral(red: 1, green: 0.1039071781, blue: 0.0251960371, alpha: 1)
        }
        self.message.text = message
        self.message.isHidden = false
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

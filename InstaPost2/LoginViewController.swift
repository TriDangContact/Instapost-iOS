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
    @IBOutlet weak var emailInput: UITextField!
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
        
        // Did the user want to be remembered from last session? If yes, let them through
        let isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
        if isLoggedIn {
            email = UserDefaults.standard.string(forKey: "email")
            password = UserDefaults.standard.string(forKey: "password")
            performSegue(withIdentifier: "LoginToMain", sender: self)
        }
        
        // lets pw input know that there's a button in it
        passwordInput.rightViewMode = .always
        passwordInput.rightView = hidePWBtn
        
        rememberLogin.isOn = false
        
        // let the input get focus
        emailInput.becomeFirstResponder()
    }

    
    @IBAction func toggleHidePW(_ sender: UIButton) {
        passwordInput.isSecureTextEntry.toggle()
    }
    
    // check credentials and log in
    @IBAction func submit(_ sender: UIButton) {
        // validate inputs
        email = emailInput.text
        password = passwordInput.text
        
        guard let possibleEmail = emailInput.text, let possiblePassword = passwordInput.text else {
            return
        }
        
        guard possibleEmail.count > 0 && possiblePassword.count > 0 else {
            displayMessage(success: false, message: "Please enter email/password")
            return
        }
        
        // authenticate with server
        api.authenticate(email:possibleEmail, password:possiblePassword, completionHandler: authenticateCallback)
    }
    
    
    //-------------------- START API REQUEST --------------------------
    func authenticateCallback(response: AFDataResponse<Any>) ->Void {
        switch response.result {
            case .success(let result):
                let dict = result as! NSDictionary
                let isCorrect = dict.value(forKey: "result") as! Bool
                guard isCorrect else {
                    // AUTHENTICATION FAILED
                    self.displayMessage(success: false, message: "Incorrect email/password")
                    return
                }
                
                // AUTHENTICATION SUCCESS
                // if user wants to remember their credentials
                if self.rememberLogin.isOn {
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                } else {
                    UserDefaults.standard.set(false, forKey: "isLoggedIn")
                }
                
                // store the credentials somewhere, not ideal
                guard let possibleEmail = emailInput.text, let possiblePassword = passwordInput.text else {
                    return
                }
                UserDefaults.standard.set(possibleEmail, forKey: "email")
                UserDefaults.standard.set(possiblePassword, forKey: "password")
                self.email = possibleEmail
                self.password = possiblePassword
                
                // log in
                self.performSegue(withIdentifier: "LoginToMain", sender: self)
        
            case .failure(let error):
                debugPrint(error.errorDescription ?? "Server Error: Cannot retrieve nicknames")
                self.displayMessage(success: false, message: "Server Error")
        }
    }
    
    //-------------------- END API REQUEST --------------------------
    
    
    //---------------START SEGUE-RELATED FUNCTIONS------------
    @IBAction func register(_ sender: UIButton) {
        performSegue(withIdentifier: "LoginToRegister", sender: self)
    }
    
    // pass data from this controller to destination
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginToMain" {
            let destination = segue.destination as? MainController
            // assign the sender's data to destination's property
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
            emailInput.text = source.emailInput.text
            passwordInput.text = source.passwordInput.text
            isPWHidden = source.isPWHidden ?? true
            message.isHidden = true
        }
    }
    //---------------END SEGUE-RELATED FUNCTIONS------------
    
    
    func resetLogin() {
        // reset the login forms and data
        emailInput.text = ""
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

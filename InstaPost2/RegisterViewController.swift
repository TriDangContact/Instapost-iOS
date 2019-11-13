//
//  SignUpViewController.swift
//  InstaPost2
//
//  Created by Tri Dang on 11/11/19.
//  Copyright © 2019 Tri Dang. All rights reserved.
//

import UIKit
import Alamofire

class RegisterViewController: UIViewController {

    var isPWHidden:Bool?
    var api = InstaPostAPI()
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var usernameInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var firstnameInput: UITextField!
    @IBOutlet weak var lastnameInput: UITextField!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var hidePWBtn: UIButton!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var message: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // make sure pw text is hidden
//        passwordInput.isSecureTextEntry = true
        // lets pw input know that there's a button in it
        passwordInput.rightViewMode = .always
        passwordInput.rightView = hidePWBtn
    }
    
    @IBAction func toggleHidePW(_ sender: UIButton) {
        passwordInput.isSecureTextEntry.toggle()
    }
    
    @IBAction func submit(_ sender: UIButton) {
        guard let email = emailInput.text,
            let password = passwordInput.text,
            let firstname = firstnameInput.text,
            let lastname = lastnameInput.text,
            let username = usernameInput.text else {
                self.displayMessage(success: false, message: "Invalid inputs")
            return
        }
        
        guard email.count > 0, firstname.count > 0, lastname.count > 0, username.count > 0, password.count > 0 else {
                self.displayMessage(success: false, message: "Please enter all fields")
            return
        }
        
        guard password.count >= 3 else {
            self.displayMessage(success: false, message: "Password must be at least 3 characters")
            return
        }
        
        
        // check for existing nickname
        let param = api.getNicknameExistsParameters(nickname: username)
        
        AF.request(api.nicknamesExistURL, parameters: param)
        .validate()
        .responseJSON { response in
            switch response.result {
                case .success(let result):
                    let dict = result as! NSDictionary
                    let exists = dict.value(forKey: "result") as! Bool
                    guard !exists else {
                        self.displayMessage(success: false, message: "Username already exists")
                        return
                    }
                    self.register(email: email, pw: password, first: firstname, last: lastname, nickname: username)
                case .failure(let error):
                    print(error.errorDescription ?? "Server Error: Cannot retrieve nicknames")
                    self.displayMessage(success: false, message: "Server Error")
            }
        }
    }
    
    func register(email:String, pw:String, first:String, last:String, nickname:String) {
        let parameters = api.getNewUserParameters(first: first, last: last, nickname: nickname, email: email, pw: pw)
        
        AF.request(api.newUserURL, parameters: parameters)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let result):
                    let message = self.api.convertANYtoString(data: result, key: "result")
                    let errorMessage = self.api.convertANYtoString(data: result, key: "errors")
                    guard message != "fail" else {
                        // REGISTRATION FAIL
                        self.displayMessage(success: false, message: errorMessage)
                        return
                    }
                    
                    // REGISTRATION SUCCESS, go back to login screen
                    // temporary way to store credentials, not ideal
                    UserDefaults.standard.set(nickname, forKey: "username")
                    UserDefaults.standard.set(pw, forKey: "password")
                    UserDefaults.standard.set(email, forKey: "email")
                    
                    self.displayMessage(success: true, message: "Registration Successful!")
                    self.performSegue(withIdentifier: "RegisterToLogin", sender: self)
                    
                case .failure(let error):
                    print(error.errorDescription ?? "Server Error: Cannot register user")
                    self.displayMessage(success: false, message: "Server Error")
                }
        }
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

}

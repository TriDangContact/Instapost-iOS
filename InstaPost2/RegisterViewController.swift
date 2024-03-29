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
        // allows dismiss keyboard on tap
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)

        // lets pw input know that there's a button in it
        passwordInput.rightViewMode = .always
        passwordInput.rightView = hidePWBtn
        
        // let the username box get focus
        usernameInput.becomeFirstResponder()
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
        
        api.checkNicknamesExist(nickname: username, completionHandler: checkNicknamesExistCallback)
    }
    
    //-------------------- START API REQUEST --------------------------
    func checkNicknamesExistCallback(response: AFDataResponse<Any>) ->Void {
        switch response.result {
            case .success(let result):
                let dict = result as! NSDictionary
                let exists = dict.value(forKey: "result") as! Bool
                guard !exists else {
                    self.displayMessage(success: false, message: "Username already exists")
                    return
                }
                guard let email = emailInput.text,
                    let password = passwordInput.text,
                    let firstname = firstnameInput.text,
                    let lastname = lastnameInput.text,
                    let username = usernameInput.text else {
                        self.displayMessage(success: false, message: "Invalid inputs")
                    return
                }
                
                // we can now register the user if the nickname doesn't exist yet
                api.newUser(email: email, pw: password, first: firstname, last: lastname, nickname: username, completionHandler: newUserCallback)
            case .failure(let error):
                debugPrint(error.errorDescription ?? "Server Error: Cannot retrieve nicknames")
                self.displayMessage(success: false, message: "Server Error in Check Username")
        }
    }
    
    func newUserCallback(response: AFDataResponse<Any>) ->Void {
        switch response.result {
        case .success(let result):
            let message = self.api.convertANYtoSTRING(data: result, key: "result")
            let errorMessage = self.api.convertANYtoSTRING(data: result, key: "errors")
            guard message != "fail" else {
                // REGISTRATION FAIL
                self.displayMessage(success: false, message: errorMessage)
                return
            }
            
            // REGISTRATION SUCCESS
            self.displayMessage(success: true, message: "Registration Successful!")
            self.performSegue(withIdentifier: "RegisterToLogin", sender: self)
            
        case .failure(let error):
            debugPrint(error.errorDescription ?? "Server Error: Cannot register user")
            self.displayMessage(success: false, message: "Server Error in Registration")
        }
    }
    
    //-------------------- END API REQUEST --------------------------
    
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

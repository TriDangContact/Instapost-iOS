//
//  CreatePostViewController.swift
//  InstaPost2
//
//  Created by Tri Dang on 11/11/19.
//  Copyright © 2019 Tri Dang. All rights reserved.
//

import UIKit
import Alamofire

class CreatePostViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var email:String?
    var password:String?
    var api = InstaPostAPI()
    var tags = [String]()
    
    @IBOutlet weak var tagTableView: UITableView!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var captionInput: UITextField!
    @IBOutlet weak var tagInput: UITextField!
    @IBOutlet weak var message: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // user credentials stored in UserDefaults, not ideal
        email = UserDefaults.standard.string(forKey: "email")
        password = UserDefaults.standard.string(forKey: "password")
        
        // placeholder tags
        tags = ["#tag1", "#tag2", "#tag3"]
    }
    
    // TODO: need to handle image picker
    @IBAction func tapImage(_ sender: UITapGestureRecognizer) {
        print("Select an Image")
    }
    
    @IBAction func addTag(_ sender: UIButton) {
        // validate tags
        guard let tag = tagInput.text else {
            return
        }
        guard tag.count > 0, tag.count < 10 else {
            displayMessage(success: false, message: "Hashtag must be between 1 and 10 characters")
            return
        }
        
        // add tag to table
        tags.append("#\(tag)")
        tagTableView.reloadData()
    }
    
    // upload the post
    @IBAction func submit(_ sender: Any) {
        // validate captions
        guard let caption = captionInput.text else {
            return
        }
        guard caption.count > 0, caption.count <= 144 else {
            displayMessage(success: false, message: "Caption must be between 1 and 144 characters")
            return
        }
        
        // temporary email
        email = "td2@td.com"
        
        // validate credentials
        guard let e = email, let pw = password else {
            print("CreatePost: Invalid credentials, email: \(email), pw: \(password)")
            return
        }
        
        uploadPost(email: e, password: pw, caption: caption)
    }
    
    func uploadPost(email:String, password:String, caption: String) {
        progressBar.progress = 0.0
        progressBar.progress += 0.2
        
        let parameters = api.getUploadPostParameters(email: email, pw: password, text: caption, tags: tags)
        
        AF.request(api.uploadPostURL, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .responseJSON { response in
                switch response.result {
                    case .success(let result):
                        let message = self.api.convertANYtoString(data: result, key: "result")
                        let postID = self.api.convertANYtoInt(data: result, key: "id")
                        let errorMessage = self.api.convertANYtoString(data: result, key: "errors")
                        guard message != "fail" else {
                            // REGISTRATION FAIL
                            self.displayMessage(success: false, message: errorMessage)
                            return
                        }
                        
                        // Post SUCCESS
                        
                        // TODO: upload image to post
                        // we can how use the generated post ID to upload it's image
                        self.uploadImageToPost(postID: postID)
                        
                    case .failure(let error):
                        self.displayMessage(success: false, message: error.errorDescription ?? "Server Error: Cannot Post")
                }
            }
    }
    
    
    // TODO: need to implement
    func uploadImageToPost(postID:Int) {
        print("PostID: \(postID)")
        
        // TODO: upload image to post on server
        
        // finish progressbar after request is retrieved
       self.progressBar.setProgress(1.0, animated: true)
       // custom unwind segue
       self.displayMessage(success: true, message: "Upload Successful!")
       self.performSegue(withIdentifier: "CreateToMain", sender: self)
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
    
    
    // TABLE VIEW TO DISPLAY TAGS
     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Hashtags"
     }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return tags.count
     }
    
    // display each tags
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "createTagCell", for: indexPath)
     
         if !tags.isEmpty {
             let tag = tags[indexPath.row]
             cell.textLabel?.text = tag
         }
        return cell
     }
    
}

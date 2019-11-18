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
    var imagePicker: ImagePicker!
    
    @IBOutlet weak var tagTableView: UITableView!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var captionInput: UITextField!
    @IBOutlet weak var tagInput: UITextField!
    @IBOutlet weak var message: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // allows dismiss keyboard on tap
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)

        
        // set up the image picker
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        
        // user credentials stored in UserDefaults, not ideal
        email = UserDefaults.standard.string(forKey: "email")
        password = UserDefaults.standard.string(forKey: "password")
        
    }
    
    // allow user to pick image
    @IBAction func pickImage(_ sender: UIButton) {
        self.imagePicker.present(from: sender)
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
        
        // check for anything other than letters and numbers
        let regex = NSRegularExpression("[^A-Za-z0-9]+")
        // matches when we found an unwanted character
        guard !regex.matches(tag) else {
            displayMessage(success: false, message: "Hashtag must be alphanumeric characters")
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
        
        // validate credentials
        guard let e = email, let pw = password else {
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
                        let message = self.api.convertANYtoSTRING(data: result, key: "result")
                        let postID = self.api.convertANYtoINT(data: result, key: "id")
                        let errorMessage = self.api.convertANYtoSTRING(data: result, key: "errors")
                        guard message != "fail" else {
                            // REGISTRATION FAIL
                            self.displayMessage(success: false, message: errorMessage)
                            return
                        }
                        
                        // Post SUCCESS
                        // we can how use the generated post ID to upload it's image
                        self.uploadImageToPost(email: email, password: password, postID: postID)
                        
                    case .failure(let error):
                        self.displayMessage(success: false, message: error.errorDescription ?? "Server Error: Cannot Post")
                }
            }
    }
    
    
    // immediately called after we have uploaded a post and given a postID
    func uploadImageToPost(email:String, password:String, postID:Int) {
        
        guard imageView.image != nil else {
            self.displayMessage(success: false, message: "Please choose an image")
            return
        }
        guard let image = imageView.image else {
            return
        }
        
        // convert image to base 64-bit encoding required by server
        let imageConverter = ImageConversion()
        let imageString = imageConverter.ToBase64String(img: image)
        
        // upload image to post on server
        let parameters = api.getUploadImageParameters(email: email, pw: password, image:imageString, postID: postID)
                AF.request(api.uploadImageURL, method: .post, parameters: parameters, encoding: JSONEncoding.default)
                    .validate()
                    .responseJSON { response in
                        switch response.result {
                            case .success(let result):
                                let message = self.api.convertANYtoSTRING(data: result, key: "result")
                                let errorMessage = self.api.convertANYtoSTRING(data: result, key: "errors")
                                guard message != "fail" else {
                                    // UPLOAD FAIL
                                    self.displayMessage(success: false, message: "UPLOAD FAIL: \(errorMessage)")
                                    debugPrint(errorMessage)
                                    return
                                }
                                
                                // Upload SUCCESS
                                // finish progressbar after request is retrieved
                                self.progressBar.setProgress(1.0, animated: true)
                                self.displayMessage(success: true, message: "Upload Successful!")
                                // give a small delay so user can see successful posting
                                var countdown = 3
                                let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                                    countdown-=1
                                    if countdown == 0 {
                                        timer.invalidate()
                                        // custom unwind segue
                                        self.performSegue(withIdentifier: "CreateToMain", sender: self)
                                    }
                                }
                                
                                
                                
                                
                            // SERVER ERROR
                            case .failure(let error):
//                                debugPrint(error.errorDescription ?? "Server Error: Cannot Post")
                                self.displayMessage(success: false, message: "SERVER ERROR: \(String(describing: error.errorDescription))")
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
    
    
    //---------------START TABLE VIEW TO DISPLAY TAGS------------
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
    
    // enable deletion of tags
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tags.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    //---------------END TABLE VIEW TO DISPLAY TAGS------------
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

// helps the controller conform to image picker
extension CreatePostViewController: ImagePickerDelegate {

    func didSelect(image: UIImage?) {
        self.imageView.image = image
    }
}

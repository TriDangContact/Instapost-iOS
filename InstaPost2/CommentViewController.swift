//
//  CommentViewController.swift
//  InstaPost2
//
//  Created by Tri Dang on 11/12/19.
//  Copyright © 2019 Tri Dang. All rights reserved.
//

import UIKit
import Alamofire

class CommentViewController: UIViewController {

    let api = InstaPostAPI()
    let imageConverter = ImageConversion()
    let ratingStep:Float = 5
    var email:String?
    var password:String?
    var post:Post?
    var submittedComment = ""
    
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var commentInput: UITextField!
    @IBOutlet weak var ratingSlider: UISlider!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var message: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // allows dismiss keyboard on tap
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        // making sure rating label matches slider
        ratingLabel.text = String(Int(ratingSlider.value / ratingStep) + 1)
        
        // user credentials stored in UserDefaults, not ideal
        email = UserDefaults.standard.string(forKey: "email")
        password = UserDefaults.standard.string(forKey: "password")
        
        guard let realPost = post else {
            return
        }
        // some checking to make sure we display proper image
        if !realPost.imageBase64.isEmpty {
            let image:UIImage = imageConverter.ToImage(imageBase64String: realPost.imageBase64)
            postImage.image = image
        }
        else {
            postImage.image = UIImage(named: "logo")
        }
        
        // let the comment box get focus
        commentInput.becomeFirstResponder()
    }
    
    // calculate the rating based on our interval, setting the ratingLabel, and upload the rating to the server
    @IBAction func sliderChanged(_ sender: UISlider) {
        let roundedValue = round(sender.value / ratingStep) * ratingStep
        sender.value = roundedValue
        
        // Do something else with the value
        let rating = Int(sender.value / ratingStep) + 1
        ratingLabel.text = String(rating)
        
        uploadRating(rating: rating)
    }
    
    @IBAction func submit(_ sender: UIButton) {
        guard let comment = commentInput.text else {
            return
        }
        guard !comment.isEmpty else {
            self.displayMessage(success: false, message: "Comment cannot be empty")
            return
        }
        
        guard let rating = Int(ratingLabel.text ?? "-1") else {
            return
        }
        uploadRating(rating: rating)
        // Post the comment to the server
        
        guard let possibleEmail = email, let pw = password, let postID = post?.id  else {
            return
        }
        
        let parameters = api.getUploadCommentParameters(email: possibleEmail, pw: pw, comment:comment, postID: postID)
//        debugPrint("Uploading Comment: email = \(possibleEmail), pw = \(pw), comment = \(comment), postid = \(postID)")
        AF.request(api.uploadCommentURL, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .responseJSON { response in
                switch response.result {
                    case .success(let result):
                        let message = self.api.convertANYtoSTRING(data: result, key: "result")
                        let errorMessage = self.api.convertANYtoSTRING(data: result, key: "errors")
                        guard message != "fail" else {
                            // UPLOAD FAIL
                            self.displayMessage(success: false, message: errorMessage)
//                            debugPrint(errorMessage)
                            return
                        }
                        // Upload SUCCESS
                        
                        // workaround to let us update the comment section in PostDetail
                        self.submittedComment = comment
                        self.performSegue(withIdentifier: "CommentToPostDetail", sender: self)
                    
                    // SERVER ERROR
                    case .failure(let error):
//                        debugPrint(error.errorDescription ?? "Server Error: Cannot Post")
                        self.displayMessage(success: false, message: error.errorDescription ?? "Server Error: Cannot Post Comment")
                }
            }
    }
    
    
    // send the rating to the server
    func uploadRating(rating:Int) {
        
        guard let possibleEmail = email, let pw = password, let postID = post?.id  else {
            return
        }
        let parameters = api.getUploadRatingParameters(email: possibleEmail, pw: pw, rating: rating, postID: postID)
        AF.request(api.uploadRatingURL, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .responseJSON { response in
                switch response.result {
                    case .success(let result):
                        let message = self.api.convertANYtoSTRING(data: result, key: "result")
                        let errorMessage = self.api.convertANYtoSTRING(data: result, key: "errors")
                        guard message != "fail" else {
                            // UPLOAD FAIL
                            self.displayMessage(success: false, message: errorMessage)
//                            debugPrint(errorMessage)
                            return
                        }
                        // Upload SUCCESS
                        self.displayMessage(success: true, message: "Rating Updated")
                    
                    case .failure(let error):
//                        debugPrint(error.errorDescription ?? "Server Error: Cannot Post")
                        self.displayMessage(success: false, message: error.errorDescription ?? "Server Error: Cannot Post Rating")
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

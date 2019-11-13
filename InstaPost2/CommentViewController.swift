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

    var email:String?
    var password:String?
    var post:Post?
    var ratingStep:Float = 5
    var api = InstaPostAPI()
    
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var commentInput: UITextField!
    @IBOutlet weak var ratingSlider: UISlider!
    @IBOutlet weak var ratingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // making sure rating label matches slider
        ratingLabel.text = String(Int(ratingSlider.value / ratingStep) + 1)
        
        // user credentials stored in UserDefaults, not ideal
        email = UserDefaults.standard.string(forKey: "email")
        password = UserDefaults.standard.string(forKey: "password")
        
        postImage.image = UIImage(named: post?.image ?? "")
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
            return
        }
                
        //TODO: post the comment to the server
        // temporary email
        email = "td2@td.com"
        
        guard let possibleEmail = email, let pw = password, let postID = post?.id  else {
            return
        }
        
        let parameters = api.getUploadCommentParameters(email: possibleEmail, pw: pw, comment:comment, postID: postID)
        AF.request(api.uploadCommentURL, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .responseJSON { response in
                switch response.result {
                    case .success(let result):
                        let message = self.api.convertANYtoString(data: result, key: "result")
                        let errorMessage = self.api.convertANYtoString(data: result, key: "errors")
                        guard message != "fail" else {
                            // UPLOAD FAIL
//                            self.displayMessage(success: false, message: errorMessage)
                            print(errorMessage)
                            return
                        }
                        // Upload SUCCESS
                        self.performSegue(withIdentifier: "CommentToPostDetail", sender: self)
                        
                    case .failure(let error):
                        print(error.errorDescription ?? "Server Error: Cannot Post")
//                        self.displayMessage(success: false, message: error.errorDescription ?? "Server Error: Cannot Post")
                }
            }
    }
    
    
    // send the rating to the server
    func uploadRating(rating:Int) {
        // temporary email
        email = "td2@td.com"
        
        guard let possibleEmail = email, let pw = password, let postID = post?.id  else {
            return
        }
        let parameters = api.getUploadRatingParameters(email: possibleEmail, pw: pw, rating: rating, postID: postID)
        AF.request(api.uploadRatingURL, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .responseJSON { response in
                switch response.result {
                    case .success(let result):
                        let message = self.api.convertANYtoString(data: result, key: "result")
                        let errorMessage = self.api.convertANYtoString(data: result, key: "errors")
                        guard message != "fail" else {
                            // UPLOAD FAIL
//                            self.displayMessage(success: false, message: errorMessage)
                            print(errorMessage)
                            return
                        }
                        // Upload SUCCESS
                        
                    case .failure(let error):
                        print(error.errorDescription ?? "Server Error: Cannot Post")
//                        self.displayMessage(success: false, message: error.errorDescription ?? "Server Error: Cannot Post")
                }
            }
    }
}

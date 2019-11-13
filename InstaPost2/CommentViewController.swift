//
//  CommentViewController.swift
//  InstaPost2
//
//  Created by Tri Dang on 11/12/19.
//  Copyright © 2019 Tri Dang. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController {

    var email:String?
    var password:String?
    var post:Post?
    var ratingStep:Float = 5
    
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var commentInput: UITextField!
    @IBOutlet weak var ratingSlider: UISlider!
    @IBOutlet weak var ratingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // making sure rating label matches slider
        ratingLabel.text = String(Int(ratingSlider.value / ratingStep))
        
        // user credentials stored in UserDefaults, not ideal
        email = UserDefaults.standard.string(forKey: "email")
        password = UserDefaults.standard.string(forKey: "password")
        
        postImage.image = UIImage(named: post?.image ?? "")
    }
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        
        let roundedValue = round(sender.value / ratingStep) * ratingStep
        sender.value = roundedValue
        // Do something else with the value
//        print(sender.value)
        ratingLabel.text = String(Int(sender.value / ratingStep))
    }
    
    @IBAction func submit(_ sender: UIButton) {
        if let comment = commentInput.text {
            if !comment.isEmpty {
                postComment(comment: commentInput.text ?? "")
                performSegue(withIdentifier: "CommentToPostDetail", sender: self)
            }
        }
    }
    
    func postComment(comment:String) {
        // post the comment to the server
        print(comment)
    }
}

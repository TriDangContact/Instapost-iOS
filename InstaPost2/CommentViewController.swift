//
//  CommentViewController.swift
//  InstaPost2
//
//  Created by Tri Dang on 11/12/19.
//  Copyright © 2019 Tri Dang. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController {

    var post:Post?
    
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var commentInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        postImage.image = UIImage(named: post?.image ?? "")
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

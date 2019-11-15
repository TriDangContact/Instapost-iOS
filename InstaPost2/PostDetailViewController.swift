//
//  PostDetailViewController.swift
//  InstaPost2
//
//  Created by Tri Dang on 11/12/19.
//  Copyright © 2019 Tri Dang. All rights reserved.
//

import UIKit

class PostDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let imageConverter = ImageConversion()
    var user:String?
    var tag:String?
    var post:Post?
    var comments = [String]()
    
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var rating: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var caption: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var ratingCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        displayPost()
        getComments()
        getTags()
    }
    
    func displayPost() {
        // get the post using the data that was passed in
        guard let realPost = post else {
           return
        }
        
        rating.image = UIImage(named: realPost.ratingImage )
        ratingCountLabel.text = "\(realPost.ratingCount ) Ratings"
        username.text = user
        caption.text = post?.text
        
        // some checking to make sure we display proper image
        if !realPost.imageBase64.isEmpty {
            let image:UIImage = imageConverter.ToImage(imageBase64String: realPost.imageBase64)
            postImage.image = image
        }
        else {
            postImage.image = UIImage(named: "no_image_light")
        }
        
        //TODO: need to implement
        // placeholder tag until proper hashtag display is implemented
        tagLabel.text = "tag"
//        tagLabel.text = post?.hashtags
        
    }
    
    func getComments() {
        guard let possiblePost = post else {
            return
        }
        
        comments = possiblePost.comments
        // need to refresh the table
        commentTableView.reloadData()
    }
    
    func getTags() {
        //TODO: figure out how to display all the tags
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PostDetailToComment" {
            let destination = segue.destination as? CommentViewController
            destination?.post = self.post
        }
    }
    
    @IBAction func comment(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "PostDetailToComment", sender: self)
    }
    
    // custom unwind
    @IBAction func unwindToPostDetail(segue: UIStoryboardSegue) {
        if let source = segue.source as? CommentViewController {
            // refresh comments
            // workaround to get the submitted comment, so we don't have to request it from server
            if !source.submittedComment.isEmpty {
                post?.comments.append(source.submittedComment)
                getComments()
            }
        }
    }
    
    
    // TABLE VIEW TO DISPLAY COMMENTS
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
       return "Comments"
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
   
   // display each comments
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath)
    
        if !comments.isEmpty {
            let comment = comments[indexPath.row]
            cell.textLabel?.text = comment
        }
       return cell
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


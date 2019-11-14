//
//  PostDetailViewController.swift
//  InstaPost2
//
//  Created by Tri Dang on 11/12/19.
//  Copyright © 2019 Tri Dang. All rights reserved.
//

import UIKit

class PostDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var user:String?
    var tag:String?
    var post:Post?
    var comments = [Comment]()
    
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var rating: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var caption: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        displayPost()
        getComments()
        getTags()
    }
    
    func displayPost() {
        // get the post using the data that was passed in
        
        postImage.image = UIImage(named: post?.image ?? "logo")
        rating.image = UIImage(named: post?.ratingImage ?? "")
        username.text = post?.username
        caption.text = post?.caption
        tagLabel.text = post?.tag
    }
    
    func getComments() {
        comments = [
            Comment(username: "user1", comment: "OOOOOOOOOO OOOOOOOOOOOOOO OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO OOOOOOO OOOOOOOOOOOOOOOOOOOOO OOOOOOOOOOOOOOOOOOO OOOOOOOOOOOOOOOOOOO OOOOOOOOOOOOOO"),
            Comment(username: "user2", comment: "OOOOOOOOOO OOOOOOOOOOOOOO OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO OOOOOOO OOOOOOOOOOOOOOOOOOOOO OOOOOOOOOOOOOOOOOOO OOOOOOOOOOOOOOOOOOO OOOOOOOOOOOOOO"),
            Comment(username: "user3", comment: "OOOOOOOOOO OOOOOOOOOOOOOO OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO OOOOOOO OOOOOOOOOOOOOOOOOOOOO OOOOOOOOOOOOOOOOOOO OOOOOOOOOOOOOOOOOOO OOOOOOOOOOOOOO")
        ]
        
        
        // TODO: use the post's ID to get comments
        
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
//            print("Back From CommentViewController, programmatically")
            // refresh comments
            commentTableView.reloadData()
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
            cell.textLabel?.text = comment.username
            cell.detailTextLabel?.text = comment.comment
        }
       return cell
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


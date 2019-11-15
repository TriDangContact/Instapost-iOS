//
//  AllPostsViewController.swift
//  InstaPost2
//
//  Created by Tri Dang on 11/11/19.
//  Copyright © 2019 Tri Dang. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class AllPostsViewController: UITableViewController {
//    var email:String?
//    var password:String?
    let api = InstaPostAPI()
    let imageConverter = ImageConversion()
    var posts = [Post]()
    

    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var ratingCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print("Email in AllPost: \(email)")
//        print("PW in AllPost: \(password)")
        
        // fix problem where custom cell height is not same as in IB
        tableView.estimatedRowHeight = 555
        tableView.rowHeight = 555
//        tableView.rowHeight = UITableView.automaticDimension
        
        getPosts()
        
        // allow user to refresh the list on pulldown
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:  #selector(refresh), for: .valueChanged)
        self.refreshControl = refreshControl
    }
    
    // fetch data from the server
    func getPosts() {
        posts = [
            Post(id: 0, username: "name1", rating: 3.5, ratingCount: 5, text: "caption1", hashtags: ["#tag1","tag2"], comments: ["comment1", "comment2"]),
            Post(id: 1, username: "name2", rating: 5, ratingCount: 5, text: "caption2", hashtags: ["#tag1","tag2"], comments: ["comment1", "comment2"]),
            Post(id: 2, username: "name3", rating: -1, ratingCount: 5, text: "caption3", hashtags: ["#tag1","tag2"], comments: ["comment1", "comment2"]),
            Post(id: 3, username: "name4", rating: 1, ratingCount: 5, text: "caption4", hashtags: ["#tag1","tag2"], comments: ["comment1", "comment2"]),
            Post(id: 4, username: "name5", rating: 4, ratingCount: 5, text: "caption5", hashtags: ["#tag1","tag2"], comments: ["comment1", "comment2"]),
        ]
        
        progressBar.progress = 0.0
        progressBar.progress += 0.2
        
        
        // TODO: get all posts from the server
        
        // finish progressbar after request is retrieved
        self.progressBar.setProgress(1.0, animated: true)
        
        
    }
    
    @objc func refresh() {
        getPosts()
        refreshControl?.endRefreshing()
    }

    
    // TABLEVIEW HANDLING
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    // displaying each cell in the table
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customPostCell", for: indexPath) as! CustomPostCell
        
        if !posts.isEmpty {
            let post = posts[indexPath.row]
            cell.username.text = post.username
            cell.caption.text = post.text
            cell.rating.image = UIImage(named: post.ratingImage)
            cell.ratingCount.text = "\(post.ratingCount) Ratings"
            // TODO: need to implement
            // placeholder tag until proper hashtag display is implemented
            cell.tagLabel.text = "tag"
//            cell.tagLabel.text = post.hashtags
            
            
            // some checking to make sure we display proper image
            if !post.imageBase64.isEmpty {
                let image:UIImage = imageConverter.ToImage(imageBase64String: post.imageBase64)
                cell.postImage.image = image
            }
            else {
                cell.postImage.image = UIImage(named: "no_image_light")
            }
            
        }
        return cell
    }
    
    // handle the selected row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPost = posts[indexPath.row]
        
        if let viewController = storyboard?.instantiateViewController(identifier: "PostDetailViewController") as? PostDetailViewController {
            viewController.user = selectedPost.username
            viewController.post = selectedPost
            navigationController?.pushViewController(viewController, animated: true)
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


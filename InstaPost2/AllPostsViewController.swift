//
//  AllPostsViewController.swift
//  InstaPost2
//
//  Created by Tri Dang on 11/11/19.
//  Copyright © 2019 Tri Dang. All rights reserved.
//

import Foundation
import UIKit

class AllPostsViewController: UITableViewController {
    var username:String?
    var password:String?
    var posts = [
        Post(id: 0, username: "name1", image: "logo", rating: "stars_5", caption: "caption1", tag: "tag1"),
        Post(id: 1, username: "name2", image: "logo", rating: "stars_3", caption: "caption2", tag: "tag2"),
        Post(id: 2, username: "name3", image: "logo", rating: "stars_0", caption: "caption3", tag: "tag3")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let user = username, let pw = password else {
            print("data not passed")
            return
        }
        
        // fix problem where custom cell height is not same as in IB
        tableView.estimatedRowHeight = 555
        tableView.rowHeight = 555
//        tableView.rowHeight = UITableView.automaticDimension
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
//
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    
    // displaying each cell in the table
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customPostCell", for: indexPath) as! CustomPostCell
        
        if !posts.isEmpty {
            let post = posts[indexPath.row]
            cell.username.text = post.username
            cell.caption.text = post.caption
            cell.tagLabel.text = post.tag
            cell.postImage.image = UIImage(named: post.image ?? "")
            cell.rating.image = UIImage(named: post.rating ?? "")
        }
        return cell
    }
    
    // handle the selected row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPost = posts[indexPath.row]
        
        if let viewController = storyboard?.instantiateViewController(identifier: "PostDetailViewController") as? PostDetailViewController {
            viewController.post = selectedPost
            navigationController?.pushViewController(viewController, animated: true)
        }
    }

}

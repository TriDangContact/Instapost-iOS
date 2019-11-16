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

class AllPostsViewController: UITableViewController, UICollectionViewDataSource {
//    var email:String?
//    var password:String?
    let api = InstaPostAPI()
    let imageConverter = ImageConversion()
    var posts = [Post]()
    
    // NEEDED FOR TAG COLLECTION VIEW
    var tableViewCellCoordinator = [Int: IndexPath]()

    @IBOutlet weak var progressBar: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print("Email in AllPost: \(email)")
//        print("PW in AllPost: \(password)")
        
        // fix problem where custom cell height is not same as in IB
        tableView.estimatedRowHeight = 555
        tableView.rowHeight = 555
//        tableView.rowHeight = UITableView.automaticDimension
        
        
        // Uncomment the following line to preserve selection between presentations
//        self.clearsSelectionOnViewWillAppear = false
        // Register cell classes for TagCollectionView
        
        getPosts()
        
        // allow user to refresh the list on pulldown
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:  #selector(refresh), for: .valueChanged)
        self.refreshControl = refreshControl
    }
    
    // fetch data from the server
    func getPosts() {
        posts = [
            Post(id: 0, username: "name1", rating: 3.5, ratingCount: 5, text: "caption1", hashtags: ["#taggggggg1","#tag2","#tag3","#tag4","#tag5","#tag6","#tag7","#tag8","#tag9","#tag10"], comments: ["OOOOOOOOOOOOOOOOOOOO OOOOOOOOOO OOOOOOOOOO OOOOOOOOOO", "IIIIIIII IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII IIIIIIIIIIIIIIII IIIIIIII IIIIIIII IIIIIIII"]),
            Post(id: 1, username: "name2", rating: 5, ratingCount: 5, text: "caption2", hashtags: ["#tag3"], comments: ["comment1", "comment2"]),
            Post(id: 2, username: "name3", rating: -1, ratingCount: 5, text: "caption3", hashtags: ["#tag5","#tag6"], comments: ["comment1", "comment2"]),
            Post(id: 3, username: "name4", rating: 1, ratingCount: 5, text: "caption4", hashtags: ["#tag7","#tag8"], comments: ["comment1", "comment2"]),
            Post(id: 4, username: "name5", rating: 4, ratingCount: 5, text: "caption5", hashtags: ["#tag9","#tag10"], comments: ["comment1", "comment2"]),
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

    
    
    ///---------------START TABLE VIEW TO DISPLAY POSTS------------
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    // displaying each cell in the table
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customPostCell", for: indexPath) as! CustomPostCell
        
        
        // NEEDED FOR TAG COLLECTION VIEW
        // START TAG COLLECTIONVIEW Configuration
        cell.tagCollectionView.dataSource = self as UICollectionViewDataSource
        
        let tag = tableViewCellCoordinator.count
        cell.tagCollectionView.tag = tag
        tableViewCellCoordinator[tag] = indexPath
        // END TAG COLLECTIONVIEW Configuration
        
        
        if !posts.isEmpty {
            let post = posts[indexPath.row]
            cell.username.text = post.username
            cell.caption.text = post.text
            cell.rating.image = UIImage(named: post.ratingImage)
            cell.ratingCount.text = "\(post.ratingCount) Ratings"
            
            // NEEDED FOR TAG COLLECTION VIEW
            // need to load the hash tags
//            cell.collectionViewFlowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            cell.tagCollectionView.reloadData()
            
            // some checking to make sure we display proper image
            if !post.imageBase64.isEmpty {
                let image:UIImage = imageConverter.ToImage(imageBase64String: post.imageBase64)
                cell.postImage.image = image
                cell.loadingIndicator.stopAnimating()
            }
            else {
                cell.postImage.image = UIImage(named: "no_image_light")
            }
            
        }
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! CustomPostCell
        
        // NEEDED FOR TAG COLLECTION VIEW
        //refresh the data inside the collection, inside each table cell
        cell.tagCollectionView.reloadData()
        cell.tagCollectionView.contentOffset = .zero
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
    ///---------------END TABLE VIEW TO DISPLAY POSTS------------
    
    
    // NEEDED FOR TAG COLLECTION VIEW
    ///---------------START COLLECTION VIEW TO DISPLAY TAGS------------
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard !posts.isEmpty else {
            return 1
        }
        
        // get the current cell
//        print("Cell|| -------------------")
        guard let indexPathCoord = tableViewCellCoordinator[collectionView.tag] else {
            return 1
        }
//        let index1 = indexPathCoord[0]
        let cellPosition = indexPathCoord[1]
        let tagsCount = posts[cellPosition].hashtags.count
//        print("Cell|| index1 = \(index1), cell# = \(cellPosition), count = \(tagsCount)")
        return tagsCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagCollectionCell", for: indexPath) as! CustomCollectionCell

        guard !posts.isEmpty else {
            return cell
        }
        
        guard let indexPathCoord = tableViewCellCoordinator[collectionView.tag] else {
            return cell
        }
        
        let postIndex = indexPathCoord[1]
        let tagIndex = indexPath[1]
        let tag = posts[postIndex].hashtags[tagIndex]
//        print("Cell|| hashtag = \(tag)")
//        print("Cell|| postIndex = \(postIndex), tagIndex = \(tagIndex), indexPath = \(indexPath), coord = \(indexPathCoord)")
        cell.tagLabel.text = tag
        return cell
    }
    
    
    ///---------------END COLLECTION VIEW TO DISPLAY TAGS------------
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

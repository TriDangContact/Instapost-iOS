//
//  UserPostViewController.swift
//  InstaPost2
//
//  Created by Tri Dang on 11/12/19.
//  Copyright © 2019 Tri Dang. All rights reserved.
//

import UIKit
import Alamofire

class UserPostViewController: UITableViewController {

    let api = InstaPostAPI()
    let imageConverter = ImageConversion()
    var user:String?
    var postIDs = [Int]()
    var posts = [Post]()
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.title = user
        
        getPostIDs()
        getPosts()
        
        // allow user to refresh the list on pulldown
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:  #selector(refresh), for: .valueChanged)
        self.refreshControl = refreshControl
    }
    
    // we need to download all of the user's postIDs, before we can retrieve each post
    func getPostIDs() {
        progressBar.progress = 0.0
        progressBar.progress += 0.2
                
        // TODO: get all posts from the server based on username
        guard let username = user else {
            return
        }
        
        let parameters = api.getNicknamePostsParameters(nickname: username)
        AF.request(api.nicknamePostsURL, parameters: parameters)
                .validate()
                .responseJSON { response in
                    switch response.result {
                        case .success(let result):
                            let message = self.api.convertANYtoSTRING(data: result, key: "result")
                            let errorMessage = self.api.convertANYtoSTRING(data: result, key: "errors")
                            guard message != "fail" else {
                                // DOWNLOAD FAIL
//                                self.displayMessage(success: false, message: errorMessage)
                                print(errorMessage)
                                return
                            }
                            // DOWNLOAD SUCCESS
                            self.postIDs = self.api.convertANYtoINTArray(data: result, key: "ids")
                            // once we have our list of post ids, we download each post
                            self.getPosts()
                        
                        // SERVER ERROR
                        case .failure(let error):
                            print(error.errorDescription ?? "Server Error: Cannot Retrieve PostIDs")
//                            self.displayMessage(success: false, message: error.errorDescription ?? "Server Error: Cannot Post Comment")
                    }
                }
    }
    
    // we download each individual posts using the list of postIDs that we downloaded
    func getPosts() {
        // need to retrieve each post
        guard !postIDs.isEmpty else {
            return
        }
        
        for id in postIDs {
            let parameters = api.getPostFromIdParameters(postID: id)
                    AF.request(api.postFromIdURL, parameters: parameters)
                            .validate()
                            .responseJSON { response in
                                switch response.result {
                                    case .success(let result):
                                        let message = self.api.convertANYtoSTRING(data: result, key: "result")
                                        let errorMessage = self.api.convertANYtoSTRING(data: result, key: "errors")
                                        guard message != "fail" else {
                                            // DOWNLOAD FAIL
            //                                self.displayMessage(success: false, message: errorMessage)
                                            print(errorMessage)
                                            return
                                        }
                                        // DOWNLOAD SUCCESS
                                        let post = self.api.convertANYtoPOST(data: result, key: "post")
                                        
                                        // we add each post we downloaded into our collection
                                        self.posts.append(post)
                                        // update the table each time a post gets downloaded
                                        self.tableView.reloadData()

                                    // SERVER ERROR
                                    case .failure(let error):
                                        print(error.errorDescription ?? "Server Error: Cannot Retrieve Post")
            //                            self.displayMessage(success: false, message: error.errorDescription ?? "Server Error: Cannot Post Comment")
                                }
                            }
            
        }
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
            cell.username.text = user
            cell.caption.text = post.text
            cell.rating.image = UIImage(named: post.ratingImage)
            cell.ratingCount.text = "\(post.ratingCount) Ratings"
            
            // some checking to make sure we display proper image
            if let imageSrc = post.image {
                let image:UIImage = imageConverter.ToImage(imageBase64String: imageSrc)
                cell.postImage.image = image
            }
            else {
                cell.postImage.image = UIImage(named: "logo")
            }
            
            //TODO: need to implement
            // placeholder tag until proper hashtag display is implemented
            cell.tagLabel.text = "tag"
//            cell.tagLabel.text = post.hashtags
        }
        return cell
    }
    
    // handle the selected row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPost = posts[indexPath.row]
        
        if let viewController = storyboard?.instantiateViewController(identifier: "PostDetailViewController") as? PostDetailViewController {
            viewController.user = user
            viewController.post = selectedPost
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//
//  TagPostViewController.swift
//  InstaPost2
//
//  Created by Tri Dang on 11/12/19.
//  Copyright © 2019 Tri Dang. All rights reserved.
//

import UIKit
import Alamofire

class TagPostViewController: UITableViewController {

    let api = InstaPostAPI()
    let imageConverter = ImageConversion()
    var tag:String?
    var postIDs = [Int]()
    var posts = [Post]()
    
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = tag
        
        getPostIDs()
        getPosts()
        
        // allow user to refresh the list on pulldown
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:  #selector(refresh), for: .valueChanged)
        self.refreshControl = refreshControl
    }
    
    
    //--------------------START POST DOWNLOAD--------------------------
    // we need to download all of the user's postIDs, before we can retrieve each post
    func getPostIDs() {
        progressBar.progress = 0.0
        progressBar.progress += 0.2
                
        guard let hashtag = tag else {
            return
        }
        
        let parameters = api.getHashtagPostsParameters(hashtag: hashtag)
        AF.request(api.hashtagPostsURL, parameters: parameters)
                .validate()
                .responseJSON { response in
                    switch response.result {
                        case .success(let result):
                            let message = self.api.convertANYtoSTRING(data: result, key: "result")
                            let errorMessage = self.api.convertANYtoSTRING(data: result, key: "errors")
                            guard message != "fail" else {
                                // DOWNLOAD FAIL
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
                            
                                //need to download the image of the recently added post
                                let index = self.posts.count - 1
                                self.getImage(index: index)

                            // SERVER ERROR
                            case .failure(let error):
                                print(error.errorDescription ?? "Server Error: Cannot Retrieve Post")
                        }
                    }
        }
    }
    
    func getImage(index:Int) {
        let parameters = api.getImageFromIdParameters(imageID: posts[index].image)
            AF.request(api.imageFromIdURL, parameters: parameters)
                    .validate()
                    .responseJSON { response in
                        switch response.result {
                            case .success(let result):
                                let message = self.api.convertANYtoSTRING(data: result, key: "result")
                                let errorMessage = self.api.convertANYtoSTRING(data: result, key: "errors")
                                guard message != "fail" else {
                                    // DOWNLOAD FAIL
                                    print(errorMessage)
                                    return
                                }
                                // DOWNLOAD SUCCESS
                                self.posts[index].imageBase64 = self.api.convertANYtoSTRING(data: result, key: "image")
                                
                                // update the table each time an image gets downloaded
                                self.tableView.reloadData()

                            // SERVER ERROR
                            case .failure(let error):
                                print(error.errorDescription ?? "Server Error: Cannot Retrieve Image")
                        }
                    }
        // finish progressbar after request is retrieved
        self.progressBar.setProgress(1.0, animated: true)
    }
    
    //--------------------END POST DOWNLOAD--------------------------
    
    
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
        
        if !posts.isEmpty {
            let post = posts[indexPath.row]
            // a post doesn't have username associated so we can't display it
            cell.username.text = post.username
            cell.caption.text = post.text
            cell.rating.image = UIImage(named: post.ratingImage)
            cell.ratingCount.text = "\(post.ratingCount) Ratings"
            
            // some checking to make sure we display proper image
            if !post.imageBase64.isEmpty {
                let image:UIImage = imageConverter.ToImage(imageBase64String: post.imageBase64)
                cell.postImage.image = image
            }
            else {
                cell.postImage.image = UIImage(named: "no_image_light")
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
        if !posts.isEmpty {
            let selectedPost = posts[indexPath.row]
            
            if let viewController = storyboard?.instantiateViewController(identifier: "PostDetailViewController") as? PostDetailViewController {
                viewController.post = selectedPost
                navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
    ///---------------END TABLE VIEW TO DISPLAY POSTS------------
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

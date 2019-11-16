//
//  UserPostViewController.swift
//  InstaPost2
//
//  Created by Tri Dang on 11/12/19.
//  Copyright © 2019 Tri Dang. All rights reserved.
//

import UIKit
import Alamofire

class UserPostViewController: UITableViewController, UICollectionViewDataSource {

    let api = InstaPostAPI()
    let imageConverter = ImageConversion()
    var user:String?
    var postIDs = [Int]()
    var posts = [Post]()
    
    // NEEDED FOR TAG COLLECTION VIEW
    var tableViewCellCoordinator = [Int: IndexPath]()
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // fix problem where custom cell height is not same as in IB
        tableView.estimatedRowHeight = 555
        tableView.rowHeight = 555
        
        self.navigationItem.title = user
        
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
                                debugPrint(errorMessage)
                                return
                            }
                            // DOWNLOAD SUCCESS
                            self.postIDs = self.api.convertANYtoINTArray(data: result, key: "ids")
                            // once we have our list of post ids, we download each post
                            self.getPosts()
                        
                        // SERVER ERROR
                        case .failure(let error):
                            debugPrint(error.errorDescription ?? "Server Error: Cannot Retrieve PostIDs")
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
                                        debugPrint(errorMessage)
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
                                    debugPrint(error.errorDescription ?? "Server Error: Cannot Retrieve Post")
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
                                    debugPrint(errorMessage)
                                    return
                                }
                                // DOWNLOAD SUCCESS
                                debugPrint("User's Post Image download success")
                                self.posts[index].imageBase64 = self.api.convertANYtoSTRING(data: result, key: "image")
                                
                                // update the table each time an image gets downloaded
                                self.tableView.reloadData()

                            // SERVER ERROR
                            case .failure(let error):
                                debugPrint(error.errorDescription ?? "Server Error: Cannot Retrieve Image")
                        }
                    }
        // finish progressbar after request is retrieved
        self.progressBar.setProgress(1.0, animated: true)
    }
    
    //--------------------END POST DOWNLOAD--------------------------
    
    
    
    @objc func refresh() {
        getPostIDs()
        refreshControl?.endRefreshing()
    }
    
    
    ///---------------START TABLE VIEW TO DISPLAY POSTS------------
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if posts.isEmpty {
            return 1
        }
        return posts.count
    }
    
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
            cell.username.text = user
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
                cell.loadingIndicator.stopAnimating()
            }
            
        } else {
            cell.username.text = ""
            cell.caption.text = ""
            cell.ratingCount.text = ""
            
            cell.postImage.image = UIImage(named: "no_post_light")
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
        if !posts.isEmpty {
            let selectedPost = posts[indexPath.row]
            
            if let viewController = storyboard?.instantiateViewController(identifier: "PostDetailViewController") as? PostDetailViewController {
                viewController.user = user
                viewController.post = selectedPost
                navigationController?.pushViewController(viewController, animated: true)
            }
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
//        debugPrint("Cell|| -------------------")
        guard let indexPathCoord = tableViewCellCoordinator[collectionView.tag] else {
            return 1
        }
//        let index1 = indexPathCoord[0]
        let cellPosition = indexPathCoord[1]
        let tagsCount = posts[cellPosition].hashtags.count
//        debugPrint("Cell|| index1 = \(index1), cell# = \(cellPosition), count = \(tagsCount)")
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
//        debugPrint("Cell|| hashtag = \(tag)")
//        debugPrint("Cell|| postIndex = \(postIndex), tagIndex = \(tagIndex), indexPath = \(indexPath), coord = \(indexPathCoord)")
        cell.tagLabel.text = tag
        return cell
    }
    ///---------------END COLLECTION VIEW TO DISPLAY TAGS------------
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

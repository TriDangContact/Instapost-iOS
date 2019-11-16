//
//  PostDetailViewController.swift
//  InstaPost2
//
//  Created by Tri Dang on 11/12/19.
//  Copyright © 2019 Tri Dang. All rights reserved.
//

import UIKit

class PostDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource {

    let imageConverter = ImageConversion()
    var user:String?
    var post:Post?
    var tags = [String]()
    var comments = [String]()
    
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var rating: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var caption: UILabel!
    @IBOutlet weak var ratingCountLabel: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tagCollectionView: UICollectionView!
    
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
            loadingIndicator.stopAnimating()
        }
        else {
            postImage.image = UIImage(named: "no_image_light")
        }
        
        //TODO: need to implement
        // placeholder tag until proper hashtag display is implemented
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
        guard let possiblePost = post else {
            return
        }
        tags = possiblePost.hashtags
        // NEEDED FOR TAG COLLECTION VIEW
        //refresh the data inside the collection, inside each table cell
        tagCollectionView.contentOffset = .zero
        tagCollectionView.reloadData()
        
    }

    
    //---------------START SEGUE-RELATED FUNCTIONS------------
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
    //---------------END SEGUE-RELATED FUNCTIONS------------
    
    
    
    ///---------------START TABLE VIEW TO DISPLAY COMMENTS------------
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
    ///---------------END TABLE VIEW TO DISPLAY COMMENTS------------
    
    
    // NEEDED FOR TAG COLLECTION VIEW
    ///---------------START COLLECTION VIEW TO DISPLAY TAGS------------
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard !tags.isEmpty else {
            return 1
        }
        return tags.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagCollectionCell", for: indexPath) as! CustomCollectionCell

        guard !tags.isEmpty else {
            return cell
        }
        
        let tag = tags[indexPath.row]
        cell.tagLabel.text = tag
        return cell
    }
    ///---------------END COLLECTION VIEW TO DISPLAY TAGS------------
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


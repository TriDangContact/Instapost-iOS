//
//  AllTagsViewController.swift
//  InstaPost2
//
//  Created by Tri Dang on 11/11/19.
//  Copyright © 2019 Tri Dang. All rights reserved.
//

import UIKit
import Alamofire

class AllTagsViewController: UITableViewController {

    let api = InstaPostAPI()
    var tags = [String]()
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // simple workaround to prevent long loading time
        api.stopAllCurrentAPIRequests()
        
        getTagss()
        
        // allow user to refresh the list on pulldown
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:  #selector(refresh), for: .valueChanged)
        self.refreshControl = refreshControl
    }
    
    @objc func refresh() {
        getTagss()
        refreshControl?.endRefreshing()
    }
    
    // allow user to scroll to top by shaking
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        debugPrint("Shaken")
        scrollToTop()
    }
    
    func scrollToTop() {
        var offset = CGPoint(
            x: -tableView.contentInset.left,
            y: -tableView.contentInset.top)

        if #available(iOS 11.0, *) {
            offset = CGPoint(
                x: -tableView.adjustedContentInset.left,
                y: -tableView.adjustedContentInset.top)
        }
        tableView.setContentOffset(offset, animated: true)
    }
    
    
    //-------------------- START API REQUEST --------------------------
    // fetch data from the server
    func getTagss() {
//        tags = ["tag1", "tag2", "tag3"]
        progressBar.progress = 0.0
        progressBar.progress += 0.2
        
        api.getHashtags(completionHandler: getHashtagsCallback)
    }
    
// callback function that gets called after async request is completed
    func getHashtagsCallback(response: AFDataResponse<Any>) ->Void {
        switch response.result {
            case .success(let result):
                self.tags = self.api.convertANYtoSTRINGArray(data: result, key: "hashtags")
//                  debugPrint(self.tags)
                
                self.tabBarItem.title = "\(self.tags.count) Tags"
                self.tableView.reloadData()
                self.progressBar.setProgress(1.0, animated: true)
            // SERVER ERROR
            case .failure(let error):
                debugPrint(error.errorDescription ?? "Server Error: cannot retrieve nicknames")
        }
    }
    
    //-------------------- END API REQUEST --------------------------
    
    

    //---------------START TABLE VIEW TO DISPLAY TAGS------------
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tags.count
    }
        
    // displaying each cell in the table
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tagCell", for: indexPath)
        
        if !tags.isEmpty {
            let tag = tags[indexPath.row]
            cell.textLabel?.text = tag
        }
        return cell
    }
    
    // handle the selected row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTag = tags[indexPath.row]
        
        if let viewController = storyboard?.instantiateViewController(identifier: "TagPostViewController") as? TagPostViewController {
            viewController.tag = selectedTag
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    //---------------END TABLE VIEW TO DISPLAY TAGS------------
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//
//  AllUsersViewController.swift
//  InstaPost2
//
//  Created by Tri Dang on 11/11/19.
//  Copyright © 2019 Tri Dang. All rights reserved.
//

import UIKit
import Alamofire

class AllUsersViewController: UITableViewController  {
    
    let api = InstaPostAPI()
    var users = [String]()
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // simple workaround to prevent long loading time
        api.stopAllCurrentAPIRequests()
        
        getUsers()
        
        // allow user to refresh the list on pulldown
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:  #selector(refresh), for: .valueChanged)
        self.refreshControl = refreshControl
    }
    
    @objc func refresh() {
        getUsers()
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
    
    func showLoading(show:Bool){
        UIView.animate(withDuration: 10.0) {
            self.progressBar.setProgress(1.0, animated: true)
        }
    }
    
    
    //-------------------- START API REQUEST --------------------------
    // fetch data from the server
    func getUsers() {
//        progressBar.progress = 0.0
//        progressBar.progress += 0.2
        showLoading(show:true)
        
        api.getNicknames(completionHandler: getNicknamesCallback)
    }
    
    // callback function that gets called after async request is completed
    func getNicknamesCallback(response: AFDataResponse<Any>) ->Void {
        switch response.result {
            case .success(let result):
                self.users = self.api.convertANYtoSTRINGArray(data: result, key: "nicknames")
//                  debugPrint(self.users)
                
                self.tabBarItem.title = "\(self.users.count) Users"
                self.tableView.reloadData()
                self.progressBar.setProgress(1.0, animated: true)
            case .failure(let error):
                debugPrint(error.errorDescription ?? "Server Error: cannot retrieve nicknames")
        }
    }
    //-------------------- END API REQUEST --------------------------
    
    
    //---------------START TABLE VIEW TO DISPLAY USERS------------
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
        
    // displaying each cell in the table
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "usernameCell", for: indexPath)
        
        if !users.isEmpty {
            let user = users[indexPath.row]
            cell.textLabel?.text = user
        }
        return cell
    }
    
    // handle the selected row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedUser = users[indexPath.row]
        
        if let viewController = storyboard?.instantiateViewController(identifier: "UserPostViewController") as? UserPostViewController {
            viewController.user = selectedUser
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    //---------------END TABLE VIEW TO DISPLAY USERS------------
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

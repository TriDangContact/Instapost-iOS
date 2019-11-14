//
//  AllUsersViewController.swift
//  InstaPost2
//
//  Created by Tri Dang on 11/11/19.
//  Copyright © 2019 Tri Dang. All rights reserved.
//

import UIKit
import Alamofire

class AllUsersViewController: UITableViewController {
    
    let api = InstaPostAPI()
    var users = [String]()
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getUsers()
        
        // allow user to refresh the list on pulldown
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:  #selector(refresh), for: .valueChanged)
        self.refreshControl = refreshControl
    }
    
    // fetch data from the server
    func getUsers() {
//        users = ["user1", "user2", "user3"]
        progressBar.progress = 0.0
        progressBar.progress += 0.2
        
        AF.request(api.nicknamesURL)
        .validate()
        .responseJSON { response in
            switch response.result {
                case .success(let result):
                    self.users = self.api.convertANYtoSTRINGArray(data: result, key: "nicknames")
//                    print(self.users)
                    
                    self.tableView.reloadData()
                    self.progressBar.setProgress(1.0, animated: true)
                case .failure(let error):
                    print(error.errorDescription ?? "Server Error: cannot retrieve nicknames")
            }
        }
    }
    
    @objc func refresh() {
        getUsers()
        refreshControl?.endRefreshing()
    }
    
    
    // TABLEVIEW HANDLING
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

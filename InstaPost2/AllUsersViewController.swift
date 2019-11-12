//
//  AllUsersViewController.swift
//  InstaPost2
//
//  Created by Tri Dang on 11/11/19.
//  Copyright © 2019 Tri Dang. All rights reserved.
//

import UIKit

class AllUsersViewController: UITableViewController {

    var users = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getUsers()
    }
    
    func getUsers() {
        users = ["user1", "user2", "user3"]
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

}

//
//  AllTagsViewController.swift
//  InstaPost2
//
//  Created by Tri Dang on 11/11/19.
//  Copyright © 2019 Tri Dang. All rights reserved.
//

import UIKit

class AllTagsViewController: UITableViewController {

    var tags = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getTagss()
    }
    
    func getTagss() {
        tags = ["tag1", "tag2", "tag3"]
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
}

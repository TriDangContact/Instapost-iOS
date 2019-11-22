//
//  ViewController.swift
//  InstaPost2
//
//  Created by Tri Dang on 11/11/19.
//  Copyright © 2019 Tri Dang. All rights reserved.
//

import UIKit
import Alamofire

class MainController: UITabBarController, UITabBarControllerDelegate {

    var email:String?
    var password:String?
    
    @IBOutlet weak var createPostBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Assign self for delegate for that ViewController can respond to UITabBarControllerDelegate methods
        self.delegate = self
        
        // disable default NavViewController's back button
        self.navigationItem.setHidesBackButton(true, animated:true)
        
        // set the nav title to a custom image
//        self.navigationItem.titleView = UIImageView(image: UIImage(named: "instapost-logo"))
        
        // get references to each tab
        guard let viewControllers = self.viewControllers else {
            debugPrint("No view controllers")
            return
        }
        guard
            let allPostsController = viewControllers[0] as? AllPostsViewController,
            let allUsersController = viewControllers[1] as? AllUsersViewController,
            let allTagsViewController = viewControllers[2] as? AllTagsViewController
        else {
            debugPrint("No view controllers")
            return
        }
        
        // we can assign any object to each of the tabviewcontroller's tabs here
//        allPostsController.email = email
//        allPostsController.password = password
//        allUsersController.email = email
//        allUsersController.password = password
//        allTagsController.email = email
//        allTagsController.password = password
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // this is where we can call functions based on which tab was selected
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let title = viewController.title {
            if title == "AllPostsViewController" {
                let view = viewController as? AllPostsViewController
                //do something here
            } else if title == "AllUsersViewController" {
                let view = viewController as? AllUsersViewController
                //do something here
            } else if title == "AllTagsViewController" {
                let view = viewController as? AllTagsViewController
                //do something here
            }
        }
    }
    
    //---------------START SEGUE-RELATED FUNCTIONS------------
    @IBAction func createPost(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "MainToCreate", sender: self)
    }
    
    // pass data from this controller to destination
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MainToCreate" {
            let destination = segue.destination as? CreatePostViewController
            // assign the sender's data to destination's property
//            destination?.email = self.email
//            destination?.password = self.password
        }
    }
    
    // using built-in unwind, pass data from source back to this controller
    @IBAction func back(unwindSegue:UIStoryboardSegue) {
        if let source = unwindSegue.source as? CreatePostViewController {
        }
    }
    
    
    // using custom unwind; pass data from source back to this controller
    @IBAction func unwindToMain(segue: UIStoryboardSegue) {
        if let source = segue.source as? CreatePostViewController {
                    debugPrint("Back From CreatePostViewController, programmatically")
        }
    }
    //---------------END SEGUE-RELATED FUNCTIONS------------
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


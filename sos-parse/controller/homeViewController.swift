//
//  homeViewController.swift
//  sos-parse
//
//  Created by wenjiez on 14/11/20.
//  Copyright (c) 2014年 wenjiez. All rights reserved.
//

import UIKit

class homeViewController: UITabBarController, UITabBarControllerDelegate {

    var setting: PFObject?
    
    enum TabIndex: Int {
        case EventIndex = 0
        case FriendsIndex = 1
        case UserIndex = 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabSubview()
        setupUserSetting()
        self.delegate = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    func setupTabSubview() {
        let eventviewController: eventTableViewController = eventTableViewController(className: "Event")
        eventviewController.title = "事件";
        eventviewController.pullToRefreshEnabled = true;
        eventviewController.paginationEnabled = false;
        
        let eventnavgviewController: UINavigationController = UINavigationController(rootViewController:eventviewController)
        let image = UIImage(named: "setting.png")
        let item = UITabBarItem(title: "事件", image:image, tag:0)
        
        eventviewController.tabBarItem = item;
        
        var viewcontrollers = self.viewControllers?
        
        viewcontrollers!.insert(eventnavgviewController, atIndex: 0)
        self.setViewControllers(viewcontrollers!, animated: true)
    }
    
    func setupUserSetting() {
        NSLog("user has login.")
        let query = PFQuery(className: "Setting")
        query.whereKey("user", equalTo: PFUser.currentUser())
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                // The find succeeded.
                NSLog("Successfully retrieved \(objects.count) scores.")
                if objects.count == 0 {
                    self.setting = PFObject(className:"Setting")
                    self.setting!["user"] = PFUser.currentUser()
                    self.setting!.saveInBackgroundWithBlock(nil)
                }
                // Do something with the found objects
            } else {
                // Log details of the failure
                NSLog("Error: %@ %@", error, error.userInfo!)
            }
        }
    }

    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        switch tabBarController.selectedIndex {
            case TabIndex.EventIndex.rawValue:
                NSLog("selected event")
            case TabIndex.FriendsIndex.rawValue:
                NSLog("selected friends")
            case TabIndex.UserIndex.rawValue:
                NSLog("selected user")
                initUserController(viewController as? userTableViewController)
            default:
                NSLog("selected unkonw index")
        }
    }
    
    func initUserController(userController: userTableViewController?) {
        if (userController != nil) {
            userController!.setting = self.setting!
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  homeViewController.swift
//  sos-parse
//
//  Created by wenjiez on 14/11/20.
//  Copyright (c) 2014年 wenjiez. All rights reserved.
//

import UIKit

class homeViewController: UITabBarController, UITabBarControllerDelegate {

    enum TabIndex: Int {
        case EventIndex = 0
        case FriendsIndex = 1
        case UserIndex = 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabSubview()
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
            if let currentuser = PFUser.currentUser() {
                NSLog("user has login.")
                let query = PFQuery(className: "Setting")
                query.whereKey("user", equalTo: currentuser)
                query.findObjectsInBackgroundWithBlock {
                    (objects: [AnyObject]!, error: NSError!) -> Void in
                    if error == nil {
                        // The find succeeded.
                        NSLog("Successfully retrieved \(objects.count) scores.")
                        // Do something with the found objects
                    } else {
                        // Log details of the failure
                        NSLog("Error: %@ %@", error, error.userInfo!)
                        for object in objects {
                            NSLog("%@", object.objectId)
                            userController!.setting.append(object as PFObject)
                        }
                    }
                }
            }
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

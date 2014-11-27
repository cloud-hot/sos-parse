//
//  AppDelegate.swift
//  sos-parse
//
//  Created by wenjiez on 14/11/16.
//  Copyright (c) 2014年 wenjiez. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        Parse.setApplicationId("AU6FpsErtGbMMbCiQha0eHO5Rd9jUoahgXZpaWtq", clientKey: "f2OSvwStllZrlcUknYXvbc3SluaYi3kp2tC3C9Vy")
        
        let storyBoard = UIStoryboard(name: "Main", bundle:nil)
        let logInviewController: logInController = storyBoard.instantiateViewControllerWithIdentifier("login") as logInController
        let homeviewController: homeViewController = storyBoard.instantiateViewControllerWithIdentifier("home") as homeViewController
        
        setupTabSubview(homeviewController)
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        if let user = PFUser.currentUser() {
            // Present wall straight-away
            self.window!.rootViewController = homeviewController
        } else {
            // Go to the welcome screen and have them log in or create an account.
            self.window!.rootViewController = logInviewController
        }

        self.window!.makeKeyAndVisible()
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            // do some task
            self.setupTestData()
            self.setupUserData()
//            dispatch_async(dispatch_get_main_queue()) {
                // update some UI
//            }
        }

        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func setupTabSubview(homeviewController: homeViewController) {
        let eventviewController: eventTableViewController = eventTableViewController(className: "Event")
        eventviewController.title = "事件";
        eventviewController.pullToRefreshEnabled = true;
        eventviewController.paginationEnabled = false;
        
        let eventnavgviewController: UINavigationController = UINavigationController(rootViewController:eventviewController)
        
        var viewcontrollers = homeviewController.viewControllers?
        
        viewcontrollers!.append(eventnavgviewController)
        homeviewController.setViewControllers(viewcontrollers!, animated: true)
    }

    func setupTestData() {
        let events = [ "Build Parse",
            "Make everything awesome",
            "Go out for the longest run",
            "Do more stuff",
            "Conquer the world",
            "Build a house",
            "Grow a tree",
            "Be awesome",
            "Setup an app",
            "Do stuff",
            "Buy groceries",
            "Wash clothes" ]
    
        var objects = [PFObject]()
        
        let query = PFQuery(className: "Event")
        let event = query.findObjects()
        if (event.count == 0) {
            var count = 0;
            for title in events {
                var priority = count % 3;
                
                var event_object = PFObject(className:"Event")
                event_object["title"] = title;
                event_object["priority"] = priority;
                objects.append(event_object)
                
                count++;
            }
        }
        if (objects.count != 0) {
            PFObject.saveAll(objects)
        }
    }
    
    func setupUserData() {
        let settings = [ "设置",
            "退出" ]
        
        var objects = [PFObject]()
        let currentUser = PFUser.currentUser()

        let query = PFQuery(className: "Setting")
        let setting = query.findObjects()
        if (setting.count == 0) {
            var count = 0;
            for title in settings {
                
                var setting_object = PFObject(className:"Setting")
                setting_object["title"] = title;
                setting_object["user"] = currentUser
                objects.append(setting_object)
                
                count++;
            }
        }
        if (objects.count != 0) {
            PFObject.saveAll(objects)
        }
    }
}


//
//  alertEventTableViewController.swift
//  sos-parse
//
//  Created by wenjiez on 14/12/2.
//  Copyright (c) 2014年 wenjiez. All rights reserved.
//

import UIKit

class alertEventTableViewController: UITableViewController {

    var friends = [PFUser]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "addFriend:",
            name: "addFriends",
            object: nil)
        
        var relation : PFRelation = PFUser.currentUser().relationForKey("KfriendsRelation")
        relation.query().findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error != nil {
                // There was an error
            } else {
                // objects has all the Posts the current user liked.
                self.friends += objects as [PFUser]
                for friend in self.friends {
                    NSLog("friend.name is \(friend.username)")
                }
                
                self.tableView.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if section == 0 {
            return 1
        } else {
            return friends.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let section = indexPath.section
        let cell = tableView.dequeueReusableCellWithIdentifier("alertevent", forIndexPath: indexPath) as UITableViewCell
        
        // Configure the cell...
        if section == 0 {
            cell.textLabel?.text = PFUser.currentUser().username
        } else {
            cell.textLabel?.text = friends[indexPath.row].username
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "自己"
        } else {
            return "好友"
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
    func addFriend(notification: NSNotification) -> () {
        if let newUser = notification.object as? PFUser {
            friends.append(newUser)
            self.tableView.reloadData()
            NSLog("recv notification")
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "detailevent" {
            NSLog("segue detailevent")
            let detaileventController:detailEventTableViewController = segue.destinationViewController as detailEventTableViewController
            detaileventController.eventUser = friends[self.tableView.indexPathForSelectedRow()!.row]
        } else if segue.identifier == "login" {
            NSLog("segue register")
        }
    }

}

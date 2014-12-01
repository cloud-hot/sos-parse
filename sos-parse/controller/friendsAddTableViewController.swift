//
//  friendsAddTableViewController.swift
//  sos-parse
//
//  Created by wenjiez on 14/11/30.
//  Copyright (c) 2014年 wenjiez. All rights reserved.
//

import UIKit

protocol addFriendsDelegate: NSObjectProtocol{
    func addFriendsData(user: PFUser) -> ()
}

class friendsAddTableViewController: UITableViewController, UISearchDisplayDelegate, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBAction func addFriends(sender: AnyObject) {
        var button: UIButton = sender as UIButton
        delegate?.addFriendsData(friends[button.tag])
        var relation : PFRelation = PFUser.currentUser().relationForKey("KfriendsRelation")
        relation.addObject(friends[button.tag])
        PFUser.currentUser().saveInBackgroundWithBlock { (succeed:Bool, error: NSError!) -> Void in
            if error != nil {
            NSLog("add friends to parse error.")
            }
            NSLog("add friends \(self.friends[button.tag].username)to parse successfully.")
        }

        NSLog("button tag is \(button.tag).")
    }
    
    @IBAction func cancel(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }

//    @IBAction func done(sender: AnyObject) {
//        delegate?.addFriendsData(PFUser.currentUser())
//        navigationController?.popViewControllerAnimated(true)
//    }
    
    var delegate: addFriendsDelegate?
    var isFiltered: Bool?
    var friends = [PFUser]()

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return friends.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: addFriendsTableViewCell = tableView.dequeueReusableCellWithIdentifier("addfriends", forIndexPath: indexPath) as addFriendsTableViewCell
        
        // Configure the cell...
        //set the buttons tag to the index path.row
        cell.button.tag = indexPath.row;
        cell.textLabel.text = friends[indexPath.row].username
        
        return cell
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
    
    // MARK: - SearchBar
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isFiltered = false
        } else {
            isFiltered = true
            var query = PFUser.query()
            query.whereKey("username", equalTo: searchText)
            query.findObjectsInBackgroundWithBlock {
                (objects: [AnyObject]!, error: NSError!) -> Void in
                if error == nil {
                    // The find succeeded.
                    NSLog("Successfully retrieved \(objects.count) scores.")
                    if objects.count != 0 {
                        self.friends = objects as [PFUser]
                        self.tableView.reloadData()
                    }
                    // Do something with the found objects
                } else {
                    // Log details of the failure
                    NSLog("Error: %@ %@", error, error.userInfo!)
                }
            }

        }
    }

}

//
//  postEventViewController.swift
//  sos-parse
//
//  Created by wenjiez on 14/12/3.
//  Copyright (c) 2014年 wenjiez. All rights reserved.
//

import UIKit

protocol postDoneDelegate: NSObjectProtocol{
    func refreshView() -> ()
}

class postEventViewController: UIViewController {
    
    @IBOutlet weak var postText: UITextField!
    
    @IBAction func postDone(sender: AnyObject) {

        // Stitch together a postObject and send this async to Parse
        let postObject = PFObject(className: "Posts")
        postObject["text"] = self.postText.text;
        postObject["username"] = PFUser.currentUser();
        
        // Use PFACL to restrict future modifications to this object.
        let readOnlyACL = PFACL()
        readOnlyACL.setPublicReadAccess(true)
        readOnlyACL.setPublicWriteAccess(false)
        postObject.ACL = readOnlyACL
        
        postObject.saveInBackgroundWithBlock { (succeeded: Bool, error: NSError!) ->() in
            if (error != nil) {
                NSLog("Couldn't save!")
                NSLog("\(error)")
                return
            }
            if (succeeded) {
                NSLog("Successfully saved!")
            } else {
                NSLog("Failed to save.")
            }

        }
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func postCancel(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

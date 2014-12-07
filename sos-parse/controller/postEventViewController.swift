//
//  postEventViewController.swift
//  sos-parse
//
//  Created by wenjiez on 14/12/3.
//  Copyright (c) 2014年 wenjiez. All rights reserved.
//

import UIKit
import CoreLocation

protocol postDoneDelegate: NSObjectProtocol{
    func refreshView() -> ()
}

class postEventViewController: UIViewController, CLLocationManagerDelegate  {
    
    @IBOutlet weak var postText: UITextField!
    
    @IBAction func postDone(sender: AnyObject) {
        // Stitch together a postObject and send this async to Parse
        let postObject = PFObject(className: "Posts")
        postObject["text"] = self.postText.text
        postObject["username"] = PFUser.currentUser()
        
        let currentCoordinate = self.currentLocation!.coordinate
        let currentPoint = PFGeoPoint(latitude:currentCoordinate.latitude, longitude:currentCoordinate.longitude)

        postObject["location"] = currentPoint
        
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
    
    var locationManager: CLLocationManager?
    var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager = CLLocationManager()
        
        self.locationManager!.requestAlwaysAuthorization()
        
        self.locationManager!.delegate = self;
        self.locationManager!.desiredAccuracy = kCLLocationAccuracyBest;
        
        // Set a movement threshold for new events.
        self.locationManager!.distanceFilter = kCLLocationAccuracyNearestTenMeters;
        
        self.locationManager!.startUpdatingLocation()
        
        self.currentLocation = self.locationManager?.location

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
    
    // MARK: - LocationManager delegete
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        NSLog("Change auth for locationManager")
        switch (status) {
        case .Authorized:
                NSLog("Authorized")
                // Re-enable the post button if it was disabled before.
                self.navigationItem.rightBarButtonItem?.enabled = true;
                self.locationManager?.startUpdatingLocation()
            break;
        case .Denied:
            NSLog("Denied");
            let alertView = UIAlertView(title: "Anywall can’t access your current location.\n\nTo view nearby posts or create a post at your current location, turn on access for Anywall to your location in the Settings app under Location Services.", message:nil, delegate:self, cancelButtonTitle:nil)
            alertView.show()
            // Disable the post button.
            self.navigationItem.rightBarButtonItem?.enabled = false;
            break;
        case .NotDetermined:
            NSLog("NotDetermined")
            break;
        case .Restricted:
            NSLog("Restricted")
            break;
        case .AuthorizedWhenInUse:
            NSLog("AuthorizedWhenInUse")
            break
        default:
            NSLog("defalut")
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        self.currentLocation = newLocation
        NSLog("didUpdateToLocation")
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        NSLog("Error: \(error.description)")
        CLError.Denied.rawValue
        if (error.code == CLError.Denied.rawValue) {
            self.locationManager?.stopUpdatingLocation
        } else if (error.code == CLError.LocationUnknown.rawValue) {
            // todo: retry?
            // set a timer for five seconds to cycle location, and if it fails again, bail and tell the user.
        } else {
            let alert = UIAlertView(title: "Error retrieving location",
            message: error.localizedDescription,
            delegate: nil,
            cancelButtonTitle:nil)
            alert.show()
        }

    }

}

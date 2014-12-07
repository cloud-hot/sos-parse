//
//  singleEventViewController.swift
//  sos-parse
//
//  Created by wenjiez on 14/12/2.
//  Copyright (c) 2014年 wenjiez. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class singleEventViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var eventLab: UILabel!
    
    @IBAction func Cancel(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    var eventObject: PFObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1
        let location = CLLocationCoordinate2D(
            latitude: 51.50007773,
            longitude: -0.1246402
        )
        // 2
        let span = MKCoordinateSpanMake(0.05, 0.05)
        if let lt = eventObject?["location"] as? PFGeoPoint {
            let coordinate = CLLocationCoordinate2D(
                latitude: lt.latitude,
                longitude: lt.longitude
            )

            let region = MKCoordinateRegion(center: coordinate, span: span)
            mapView.setRegion(region, animated: true)
            NSLog("latitude is \(lt.latitude), longitude is \(lt.longitude)")
        } else {
            let region = MKCoordinateRegion(center: location, span: span)
            mapView.setRegion(region, animated: true)
        }
        
        //3
        let annotation = MKPointAnnotation()
        annotation.setCoordinate(location)
        annotation.title = "Big Ben"
        annotation.subtitle = "London"
        mapView.addAnnotation(annotation)
        
        eventLab.text = eventObject?["text"] as? String

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

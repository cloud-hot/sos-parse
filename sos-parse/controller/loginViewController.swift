//
//  ViewController.swift
//  sos-parse
//
//  Created by wenjiez on 14/11/16.
//  Copyright (c) 2014年 wenjiez. All rights reserved.
//

import UIKit

class logInController: PFLogInViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {

    let logInLabel = UILabel()
    let signUpLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        logInLabel.text = "SOS parse"
        logInLabel.sizeToFit()
        self.logInView.logo = logInLabel
        signUpLabel.text = "SOS parse"
        signUpLabel.sizeToFit()
        self.signUpController.signUpView.logo = signUpLabel
        self.delegate = self
        self.signUpController.delegate = self;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        println("did login")
        performSegueWithIdentifier("login", sender: self)
    }
    
    func logInViewControllerDidCancelLogIn(logInController: PFLogInViewController) {
        println("did login cancel")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser){
        println("did signup")
        self.dismissViewControllerAnimated(false, completion: nil)
        performSegueWithIdentifier("login", sender: self)
    }
    
    func signUpViewControllerDidCancelLogIn(signUpController: PFSignUpViewController){
        println("did signup cancel")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}


//
//  ViewController.swift
//  sos-parse
//
//  Created by wenjiez on 14/11/16.
//  Copyright (c) 2014年 wenjiez. All rights reserved.
//

import UIKit

class logInController: PFLogInViewController {

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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func logInViewControllerDidCancelLogIn(logInController: PFLogInViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func signUpViewControllerDidCancelLogIn(signUpController: PFSignUpViewController){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}


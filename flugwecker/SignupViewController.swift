//
//  SignupViewController.swift
//  flugwecker
//
//  Created by Udo von Eynern on 24.08.14.
//  Copyright (c) 2014 Udo von Eynern. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {
 
    @IBOutlet weak var loginButton: UIButton!
    
    
    @IBOutlet weak var registerButton: UIButton!
    
    
    @IBOutlet weak var facebookButton: UIButton!
    
    @IBOutlet weak var imageViewPicture: UIImageView!
    
    @IBAction func registerButtonAction(sender: AnyObject) {
    }
    
    
    @IBAction func facebookButtonAction(sender: AnyObject) {
    }
    
    func loginButtonAction(sender: AnyObject) {
        
    }
    
    func logoutButtonAction(sender: AnyObject) {
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.buildGUI()
    }
    
    func buildGUI() {
        
        self.facebookButton.setTitle(NSLocalizedString("Sign in via Facebook", comment: ""), forState:UIControlState.Normal)
        self.registerButton.setTitle(NSLocalizedString("Register", comment: ""), forState: UIControlState.Normal)
        
        if UserService.isUserLoggedIn() == true {
            
            self.title = NSLocalizedString("Logout", comment: "")
            self.loginButton.setTitle(NSLocalizedString("Logout", comment: ""), forState: UIControlState.Normal)
            self.registerButton.hidden = true
            self.facebookButton.hidden = true
            self.loginButton.addTarget(self, action: "logoutButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
            
        } else {
            
            self.title = NSLocalizedString("Login", comment: "")
            self.loginButton.setTitle(NSLocalizedString("Login", comment: ""), forState: UIControlState.Normal)
            self.registerButton.hidden = false
            self.facebookButton.hidden = false
            self.loginButton.addTarget(self, action: "loginButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        }
    }
    
    func loginButtonAction(sender: UIButton) {
        
    }
    
    func logoutButtonAction(sender: UIButton) {
        
    }
    
    
}
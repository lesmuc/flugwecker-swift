//
//  LoginViewController.swift
//  flugwecker
//
//  Created by Udo von Eynern on 25.08.14.
//  Copyright (c) 2014 Udo von Eynern. All rights reserved.
//

import UIKit

class LoginViewController: KeyboardInputViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("Login", comment: "")
        
        self.loginButton.setTitle(NSLocalizedString("Login", comment: ""), forState: UIControlState.Normal)
        
        self.keyboardFrame = CGRectNull
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Listen for changes to keyboard visibility so that we can adjust the text view accordingly.
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "handleKeyboardWillShowNotification:", name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: "handleKeyboardWillHideNotification:", name: UIKeyboardWillHideNotification, object: nil)
        
        if UIDevice.currentDevice().model.rangeOfString("Simulator") != nil {
            self.usernameTextField.text = "voneynern"
            self.passwordTextField.text = "123456"
        }
    }
    
    @IBAction func doLogin(sender: UIButton) {
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        PFUser.logInWithUsernameInBackground(self.usernameTextField.text, password:self.passwordTextField.text) {
            (user: PFUser!, error: NSError!) -> Void in
            
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            
            if user != nil {

                self.navigationController?.popViewControllerAnimated(true);
                
            } else {
                
                let userInfo:Dictionary = error.userInfo!
                let message:String = userInfo["error"] as String
                
                let alert = UIAlertView()
                alert.title = NSLocalizedString(message, comment: "")
                
                let okayString = NSLocalizedString("OK", comment: "")
                
                alert.addButtonWithTitle(okayString)
                alert.show()
            }
        }
    }
    
}
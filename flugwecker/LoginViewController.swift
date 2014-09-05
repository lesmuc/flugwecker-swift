//
//  LoginViewController.swift
//  flugwecker
//
//  Created by Udo von Eynern on 25.08.14.
//  Copyright (c) 2014 Udo von Eynern. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: KeyboardInputViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var emailTextField: UITextField!
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
            self.emailTextField.text = "udo@voneynern.de"
        }
    }
    
    @IBAction func doLogin(sender: UIButton) {
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        Manager.sharedInstance.defaultHeaders["Accept"] = "application/json"
        
        let parameters = [
            "email": self.emailTextField.text,
            "password" : self.passwordTextField.text,
        ]
        
        let plainString = "\(self.emailTextField.text):\(self.passwordTextField.text)" as NSString
        let plainData = plainString.dataUsingEncoding(NSUTF8StringEncoding)
        let base64String = plainData?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.fromRaw(0)!)
        Manager.sharedInstance.defaultHeaders["Authorization"] = "Basic " + base64String!
        
        Alamofire
            .request(.POST, "\(API_URL)/api/user?XDEBUG_SESSION_START")
            .response {request, response, data, error in
            
            var json = JSONValue(data as NSData!)
            
            let statusCode = response?.statusCode as Int!
            
            println(statusCode)
            
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            
            if statusCode == 200 { // Logged in Successfully
                
                var user = User.decode(json)
                user.password = self.passwordTextField.text
                
                var json = JSONValue(user.toDictionary())
                
                KeychainService.saveUserJSON(json.description)
                
                self.navigationController?.popViewControllerAnimated(true);
                
            } else {
                
                self.checkAndDisplayErrors(statusCode, jsonError:json)
                
            }
        }
    }
    
}
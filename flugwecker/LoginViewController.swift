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
            self.passwordTextField.text = "123456"
        }
    }
    
    @IBAction func doLogin(sender: UIButton) {
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        let manager = AFHTTPRequestOperationManager()
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept");
        manager.requestSerializer = UserService.getAuthentificationRequestSerializer(self.emailTextField.text, password: self.passwordTextField.text)
        
        manager.POST("\(API_URL)/api/user", parameters: nil,
            
            success: { (operation: AFHTTPRequestOperation!,data: AnyObject!) in
            
                var json = JSON(data as NSDictionary!)
                
                let statusCode = operation.response?.statusCode as Int!
                
                var user = User.decode(json)
                
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                
                if statusCode == 200 { // Logged in Successfully
                    
                    user.password = self.passwordTextField.text;
                    
                    json = User.encode(user)
                    
                    KeychainService.saveUserJSON(json.rawJSONString)
                    
                    self.navigationController?.popViewControllerAnimated(true);
                    
                } else {
                    
                    self.checkAndDisplayErrors(statusCode, jsonError:json)
                    
                }
            
            },
            failure: { (operation: AFHTTPRequestOperation!,error: NSError!) in
                
                let json = JSON(data: operation.responseData as NSData!)
                let statusCode = operation.response?.statusCode as Int!
                
                println(json.description)
                
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                self.checkAndDisplayErrors(statusCode, jsonError:json)
        })
    }
    
}
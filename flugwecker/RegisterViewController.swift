//
//  RegisterViewController.swift
//  flugwecker
//
//  Created by Udo von Eynern on 25.08.14.
//  Copyright (c) 2014 Udo von Eynern. All rights reserved.
//

import UIKit
import Alamofire

class RegisterViewController: ImageUploadViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField1: UITextField!
    @IBOutlet weak var passwordTextField2: UITextField!

    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("Register", comment: "")
        
        self.registerButton.setTitle(NSLocalizedString("Register", comment: ""), forState: UIControlState.Normal)
        
        self.keyboardFrame = CGRectNull
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if UIDevice.currentDevice().model.rangeOfString("Simulator") != nil {
            self.usernameTextField.text = "voneynern"
            self.emailTextField.text = "udo@voneynern.de"
            self.passwordTextField1.text = "123456"
            self.passwordTextField2.text = self.passwordTextField1.text
        }
    }
    
    @IBAction func doRegister(sender: UIButton) {
        if self.isValidForm() == false {
            return
        }
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        /*
        Manager.sharedInstance.defaultHeaders["Accept"] = "application/json"
        
        let parameters = [
            "username": self.usernameTextField.text,
            "email": self.emailTextField.text,
            "password" : self.passwordTextField1.text,
            "passwordVerify" : self.passwordTextField2.text,
        ]
        
        Alamofire.request(.POST, "\(API_URL)/api/user", parameters: parameters).response {request, response, data, error in
            
            let json = JSONValue(data as NSData!)
        
            let statusCode = response?.statusCode as Int!
        
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        
            if statusCode == 201 { // Created Successfully
                
                KeychainService.saveUserJSON(json.description)
                
                /*
                // TODO: Multipart is not supported by Alomofire yet.
                if self.selectedImage != nil {
                    MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                    
                    let imageData:NSData = UIImageJPEGRepresentation(self.selectedImage, 0.75);

                    Alamofire.upload(.PUT, "\(API_URL)/api/user", imageData).response {request, response, data, error in
                        let statusCode = response?.statusCode as Int!
                        
                        if (statusCode == 200) {
                            
                        } else {
                            self.checkAndDisplayErrors(statusCode, jsonError:json)
                        }
                    }
                }
                */
                    
                self.navigationController?.popViewControllerAnimated(true);
                
            } else {
                
                self.checkAndDisplayErrors(statusCode, jsonError:json)
                
            }
        }
        */
    }
    
    func isValidForm() -> Bool {
        
        let alertTitle = NSLocalizedString("Error", comment: "")
        let okayString = NSLocalizedString("OK", comment: "")
        
        if self.usernameTextField.text.isEmpty {
            
            let alertMessage = NSLocalizedString("Missing username.", comment: "")
            
            if nil != NSClassFromString("UIAlertController") {
                var alert : UIAlertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: okayString, style:.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                
                let alert = UIAlertView()
                alert.title = alertTitle
                alert.message = alertMessage
                alert.addButtonWithTitle(okayString)
                alert.show()
            }
            
            return false
        }
        
        if self.emailTextField.text.isEmpty {
            
            let alertMessage = NSLocalizedString("Missing email.", comment: "")
            
            if nil != NSClassFromString("UIAlertController") {
                var alert : UIAlertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: okayString, style:.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                
                let alert = UIAlertView()
                alert.title = alertTitle
                alert.message = alertMessage
                alert.addButtonWithTitle(okayString)
                alert.show()
            }
            
            return false
        }
        
        if (self.passwordTextField1.text.isEmpty) || (self.passwordTextField1.text != self.passwordTextField2.text) {
            
            let alertMessage = NSLocalizedString("Missing passwords or both passwords are not equal.", comment: "")
            
            if nil != NSClassFromString("UIAlertController") {
                var alert : UIAlertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: okayString, style:.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                
                let alert = UIAlertView()
                alert.title = alertTitle
                alert.message = alertMessage
                alert.addButtonWithTitle(okayString)
                alert.show()
            }
            
            return false
        }
        
        return true
    }    
}
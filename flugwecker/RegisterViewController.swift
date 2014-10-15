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
        
        let manager = AFHTTPRequestOperationManager()
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept");
        
        let parameters = [
            "username": self.usernameTextField.text,
            "email": self.emailTextField.text,
            "password" : self.passwordTextField1.text,
            "passwordVerify" : self.passwordTextField2.text,
        ]
        
        manager.POST("\(API_URL)/api/user",
            parameters: parameters,
            success: { (operation: AFHTTPRequestOperation!,data: AnyObject!) in
                
                var json = JSON(data as NSDictionary!)
                
                let statusCode = operation.response?.statusCode as Int!
                
                var user = User.decode(json)
                
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                
                if statusCode == 201 && user.id > 0 { // Created Successfully
                    
                    user.password = self.passwordTextField1.text;
                    
                    json = User.encode(user)
                    
                    KeychainService.saveUserJSON(json.rawJSONString)
                    
                    if self.selectedImage != nil {
                        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                        
                        let imageData = UIImageJPEGRepresentation(self.selectedImage, 0.75);
                        
                        if (imageData != nil) {
                            
                            manager.requestSerializer = UserService.getAuthentificationRequestSerializer()
                            
                            manager.POST("\(API_URL)/api/user/\(user.id)?XDEBUG_SESSION_START", parameters: nil,
                                constructingBodyWithBlock: { (data: AFMultipartFormData!) in
                                    data.appendPartWithFileData(imageData, name: "image", fileName: "\(user.id).jpg", mimeType: "image/jpeg")
                                },
                                success: { operation, response in
                                    
                                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                                    
                                    println("[success] operation: \(operation), response: \(response)")
                                    
                                    let statusCode = operation.response?.statusCode as Int!
                                    
                                    if (statusCode == 200) {
                                        self.navigationController?.popViewControllerAnimated(true);
                                    } else {
                                        self.checkAndDisplayErrors(statusCode, jsonError:json)
                                    }
                                    
                                },
                                failure: { operation, error in
                                 
                                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                                    
                                    println("[fail] operation: \(operation), error: \(error)")
                                }
                            )
                        }
                    } else {
                        self.navigationController?.popViewControllerAnimated(true);
                    }
                    
                } else {
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    self.checkAndDisplayErrors(statusCode, jsonError:json)
                }
                
            },
            failure: { (operation: AFHTTPRequestOperation!,error: NSError!) in
                
                let json = JSON(data: operation.responseData as NSData!)
                let statusCode = operation.response?.statusCode as Int!
                
                println(json.description)
                
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                self.checkAndDisplayErrors(statusCode, jsonError:json)
        });
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
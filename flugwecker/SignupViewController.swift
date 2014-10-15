//
//  SignupViewController.swift
//  flugwecker
//
//  Created by Udo von Eynern on 24.08.14.
//  Copyright (c) 2014 Udo von Eynern. All rights reserved.
//

import UIKit
import Alamofire

class SignupViewController: ImageUploadViewController {
 
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var facebookButton: UIButton!
    
    @IBOutlet weak var imageViewPicture: UIImageView!
    
    @IBAction func registerButtonAction(sender: AnyObject) {
    }
    
    
    @IBAction func facebookButtonAction(sender: AnyObject) {
    }
    
    func loginButtonAction(sender: AnyObject) {
        var loginViewController:LoginViewController = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as LoginViewController
        
        self.navigationController?.pushViewController(loginViewController, animated: true)
        
    }
    
    func logoutButtonAction(sender: AnyObject) {
        KeychainService.deleteUserJSON()
        
        self.buildGUI()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.buildGUI()
    }
    
    override func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]!) {

        super.imagePickerController(picker, didFinishPickingMediaWithInfo: info)
        
        // upload image
        if self.selectedImage != nil {
            
            /*
            // TODO: Multipart is not supported by Alomofire yet.
            if UserService.isUserLoggedIn() == true {
                
                var jsonUserString:String = KeychainService.loadUserJSON()
                
                let data = (jsonUserString as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                let json = JSONValue(data as NSData!)
                let user = User.decode(json)
            
                MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                
                let imageData:NSData = UIImageJPEGRepresentation(self.selectedImage, 0.75);

                Manager.sharedInstance.defaultHeaders["Accept"] = "application/json"
                
                println(user.email)
                println(user.password)
                
                let plainString = "\(user.email):\(user.password)" as NSString
                let plainData = plainString.dataUsingEncoding(NSUTF8StringEncoding)
                let base64String = plainData?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.fromRaw(0)!)
                Manager.sharedInstance.defaultHeaders["Authorization"] = "Basic " + base64String!
                
                Alamofire.upload(.PUT, "\(API_URL)/api/user/\(user.id)?XDEBUG_SESSION_START", imageData)
                    
                    .response {request, response, data, error in
                    
                    let json = JSONValue(data as NSData!)
                    
                    let statusCode = response?.statusCode as Int!
                    
                    println(json)
                    print(statusCode)
                    
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    
                    if (statusCode == 200) {
                        
                    } else {
                        self.checkAndDisplayErrors(statusCode, jsonError:json)
                    }
                }
            }
            */
        }
    }
    
    func buildGUI() {
        
        self.facebookButton.setTitle(NSLocalizedString("Sign in via Facebook", comment: ""), forState:UIControlState.Normal)
        self.registerButton.setTitle(NSLocalizedString("Register", comment: ""), forState: UIControlState.Normal)
        
        if UserService.isUserLoggedIn() == true {
            
            var jsonUserString:String = KeychainService.loadUserJSON()
            
            let data = (jsonUserString as NSString).dataUsingEncoding(NSUTF8StringEncoding)
            let json = JSON(data as NSData!)
            let user = User.decode(json)
            
            self.title = NSLocalizedString("Logout", comment: "")
            self.navigationItem.title = user.username
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
}
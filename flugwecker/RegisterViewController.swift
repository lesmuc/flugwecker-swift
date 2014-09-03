//
//  RegisterViewController.swift
//  flugwecker
//
//  Created by Udo von Eynern on 25.08.14.
//  Copyright (c) 2014 Udo von Eynern. All rights reserved.
//

import UIKit
import Alamofire

class RegisterViewController: KeyboardInputViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var buttonTakePicture: UIButton!

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField1: UITextField!
    @IBOutlet weak var passwordTextField2: UITextField!

    @IBOutlet weak var registerButton: UIButton!
    
    var selectedImage: UIImage!
    
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
    
    func actionSheet(myActionSheet: UIActionSheet!, clickedButtonAtIndex buttonIndex: Int){

        var imagePicker:UIImagePickerController = UIImagePickerController()
        
        if buttonIndex == 0 { // camera
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
                imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            } else {
                imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            }
            
        } else if buttonIndex == 1 {
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]!) {
        
        self.selectedImage = info[UIImagePickerControllerEditedImage] as UIImage!
        
        if self.selectedImage == nil {
            self.selectedImage = info[UIImagePickerControllerOriginalImage] as UIImage!
        }
        
        var cropped:UIImage = VEResizeImage(self.selectedImage, CGSizeMake(self.buttonTakePicture.frame.size.width, self.buttonTakePicture.frame.size.height))
        self.buttonTakePicture.setImage(cropped, forState: UIControlState.Normal)

        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func doRegister(sender: UIButton) {
        if self.isValidForm() == false {
            return
        }
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
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
        
            println(statusCode)
        
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        
            if statusCode == 201 { // Created Successfully
                
                KeychainService.saveUserJSON(json.description)
                    
                self.navigationController?.popViewControllerAnimated(true);
                
            } else {
                
                self.checkAndDisplayErrors(statusCode, jsonError:json)
                
            }
        }
    }
    
    @IBAction func takePictureAction(sender: UIButton) {
        
        let title = NSLocalizedString("Where?", comment: "")
        let cancelButtonTitle = NSLocalizedString("Cancel", comment: "")
        let cameraButtonTitle = NSLocalizedString("Camera", comment: "")
        let photoLibraryButtonTitle = NSLocalizedString("Photo Library", comment: "")
        
        var popupQuery:UIActionSheet = UIActionSheet(title: title, delegate: self, cancelButtonTitle: cancelButtonTitle, destructiveButtonTitle: nil, otherButtonTitles: cameraButtonTitle, photoLibraryButtonTitle)
        popupQuery.actionSheetStyle = UIActionSheetStyle.BlackOpaque
        popupQuery.showInView(self.view)
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
//
//  RegisterViewController.swift
//  flugwecker
//
//  Created by Udo von Eynern on 25.08.14.
//  Copyright (c) 2014 Udo von Eynern. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var buttonTakePicture: UIButton!

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField1: UITextField!
    @IBOutlet weak var passwordTextField2: UITextField!

    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var viewBottomLayoutGuideConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewTopLayoutGuideConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var viewContainerContent: UIView!
    
    var activeTextField: UITextField!
    var keyboardFrame: CGRect!
    
    var selectedImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("Register", comment: "")
        
        self.registerButton.setTitle(NSLocalizedString("Register", comment: ""), forState: UIControlState.Normal)
        
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
            self.emailTextField.text = "udo@voneynern.de"
            self.passwordTextField1.text = "123456"
            self.passwordTextField2.text = self.passwordTextField1.text
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
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
        
        Alamofire.Manager.sharedInstance.defaultHeaders["Accept"] = "application/json"
        
        let parameters = [
            "username": self.usernameTextField.text,
            "email": self.emailTextField.text,
            "password" : self.passwordTextField1.text,
            "passwordVerify" : self.passwordTextField2.text,
        ]
        
        Alamofire.request(.POST, "\(API_URL)/api/user", parameters: parameters).response {request, response, data, error in
            
                let json = JSONValue(data as NSData!)
                
                let response = response
                
                if (self.checkAndDisplayErrors(json) == true) {
                    
                    var user = User.decode(json["data"])
                    
                    let keychain:ACSimpleKeychain = ACSimpleKeychain.defaultKeychain() as ACSimpleKeychain
                    
                    
                    keychain.storeUsername(user.username as String!, password: user.password, identifier: user.id, forService:"flugwecker")
                    
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    
                    self.navigationController.popViewControllerAnimated(true);
                }
        }
    }
    
    func checkAndDisplayErrors(json:JSONValue) -> Bool {
        if let message = json["error"]["message"].string {
            
            var additionalFieldErrorMessages = Array<String>()
            
            let alertTitle = NSLocalizedString("Error", comment: "")
            let okayString = NSLocalizedString("OK", comment: "")
            
            var errors = json["error"]["errors"].object as Dictionary<String, JSONValue>!
            
            for (field, fieldErrors) in errors {
                let localizedFieldTitle = NSLocalizedString(field, comment: "")
                
                var dictionaryErrors = fieldErrors.object as Dictionary<String, JSONValue>!
                
                for (errorType, errorMessage) in dictionaryErrors {
                    println(errorType)
                    println()
                    
                    let localizedErrorMessage = NSLocalizedString(errorMessage.string as String!, comment: "")
                    
                    additionalFieldErrorMessages.append(localizedFieldTitle + ": " + localizedErrorMessage)
                }
                
                
            }
            
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            
            let joiner = "\n"
            
            let alert = UIAlertView()
            alert.title = NSLocalizedString(message, comment: "")
            alert.message =  joiner.join(additionalFieldErrorMessages)
            alert.addButtonWithTitle(okayString)
            alert.show()
            
            return false
        } else {
            return true
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
    
    // MARK: UITextFieldDelegate
    func textFieldDidBeginEditing(textField: UITextField!) {
        self.activeTextField = textField
        
        println("active textfield: " + self.activeTextField.placeholder)
        
        self.updatePosition()
    }
    
    func textFieldDidEndEditing(textField: UITextField!) {
        self.activeTextField = nil
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    // MARK: Notifications for Keyboard
    func handleKeyboardWillShowNotification(notification: NSNotification) {
        let userInfo = notification.userInfo!
        
        self.keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
        
        self.updatePosition()
    }
    
    func handleKeyboardWillHideNotification(notification: NSNotification) {
        let userInfo = notification.userInfo!
        
        self.keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
        
        self.updatePosition()
    }
    
    func updatePosition() {

        var savedConstant = viewTopLayoutGuideConstraint
        
        if self.activeTextField != nil && CGRectIsNull(self.keyboardFrame) == false {
            var window = UIApplication.sharedApplication().keyWindow
            var localKeyboardFrame = window.convertRect(self.keyboardFrame, toView: self.view)
            var localKeyboardFrameMinY = Float(CGRectGetMinY(localKeyboardFrame))
            
            var textFieldBuffer = Float(120.0)
            
            var textFieldFrame = self.activeTextField.frame
            var textFieldFrameMaxY = Float(CGRectGetMaxY(self.activeTextField.frame))
            
            // Check for Visibility of active UITextField
            if textFieldFrameMaxY + textFieldBuffer > localKeyboardFrameMinY {
                viewTopLayoutGuideConstraint.constant -= CGFloat(textFieldFrameMaxY + textFieldBuffer - localKeyboardFrameMinY)
            } else {
                viewTopLayoutGuideConstraint.constant = 0
            }
            
            self.view.setNeedsUpdateConstraints()
            
            println(viewTopLayoutGuideConstraint.constant)
            
            UIView.animateWithDuration(0, delay: 0, options: .BeginFromCurrentState, animations: {
                self.view.layoutIfNeeded()
                }, completion: nil)
            
        } else {
            viewTopLayoutGuideConstraint.constant = 0
        }

    }
    
    
    
}
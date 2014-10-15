//
//  KeyboardInputViewController.swift
//  flugwecker
//
//  Created by Udo von Eynern on 03.09.14.
//  Copyright (c) 2014 Udo von Eynern. All rights reserved.
//

import UIKit

class KeyboardInputViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var viewBottomLayoutGuideConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewTopLayoutGuideConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewContainerContent: UIView!
    
    var activeTextField: UITextField!
    var keyboardFrame: CGRect!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if (self.viewContainerContent != nil) {
            // Listen for changes to keyboard visibility so that we can adjust the text view accordingly.
            let notificationCenter = NSNotificationCenter.defaultCenter()
            notificationCenter.addObserver(self, selector: "handleKeyboardWillShowNotification:", name: UIKeyboardWillShowNotification, object: nil)
            notificationCenter.addObserver(self, selector: "handleKeyboardWillHideNotification:", name: UIKeyboardWillHideNotification, object: nil)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (self.viewContainerContent != nil) {
            let notificationCenter = NSNotificationCenter.defaultCenter()
            notificationCenter.removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
            notificationCenter.removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        }
    }
    
    // MARK: UITextFieldDelegate
    func textFieldDidBeginEditing(textField: UITextField!) {
        self.activeTextField = textField
        
        println("active textfield: \(self.activeTextField.placeholder)")
        
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
    
    func checkAndDisplayErrors(statusCode:Int, jsonError:JSON) -> Bool {
        
        let alertTitle = NSLocalizedString("Error", comment: "")
        let okayString = NSLocalizedString("OK", comment: "")
        
        if let message = jsonError["error"]["message"].string {
            
            var additionalFieldErrorMessages = Array<String>()
            
            if var errors = jsonError["error"]["errors"].dictionaryValue as Dictionary<String, JSON>! {
                for (field, fieldErrors) in errors {
                    let localizedFieldTitle = NSLocalizedString(field, comment: "")
                    
                    var dictionaryErrors = fieldErrors.dictionaryValue as Dictionary<String, JSON>!
                    
                    for (errorType, errorMessage) in dictionaryErrors {
                        
                        let localizedErrorMessage = NSLocalizedString(errorMessage.stringValue as String!, comment: "")
                        
                        additionalFieldErrorMessages.append(localizedFieldTitle + ": " + localizedErrorMessage)
                    }
                }
            }
            
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            
            let joiner = "\n"
            
            let alert = UIAlertView()
            alert.title = NSLocalizedString(message, comment: "")
            
            if additionalFieldErrorMessages.count > 0 {
                alert.message =  joiner.join(additionalFieldErrorMessages)
            }

            alert.addButtonWithTitle(okayString)
            alert.show()
            
            return false
        } else {
            
            if statusCode >= 400 {
                let message = NSLocalizedString("An unknown error has occurred.", comment: "") + " (\(statusCode))"
                
                let alert = UIAlertView()
                alert.title = NSLocalizedString(message, comment: "")
                alert.addButtonWithTitle(okayString)
                alert.show()
                return false
            } else {
                return true
            }
            
        }
    }
    
}
